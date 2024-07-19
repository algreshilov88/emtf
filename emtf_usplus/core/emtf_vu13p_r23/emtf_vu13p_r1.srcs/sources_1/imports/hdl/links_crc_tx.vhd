--------------------------------------------------------------------------------
-- links crc tx, kadamidi, 2020
-- calculates and outputs the tx CRC16 checksum
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.package_links.all;
use work.emp_data_types.all;


entity links_crc_tx is
  generic(
    MGT_KIND   : integer );
  port (
    clk              : in  std_logic;
    rst              : in  std_logic;
    txdata_in        : in  lword;
    crc_word_out     : out std_logic_vector(16 downto 0)
    );
end links_crc_tx;

architecture behave of links_crc_tx is
  
    signal safe_b2b                   : integer;
    signal data_valid_shreg           : std_logic_vector(1 downto 0);
    signal crc_word                   : std_logic_vector(15 downto 0);
    signal crc_rst                    : std_logic;
    signal transmit_crc_i             : std_logic;
    signal crc_enable                 : std_logic;
    signal back_to_back_dis           : std_logic;
    signal valid_bit_crc_i            : std_logic;
    signal end_of_packet_i            : std_logic;
    signal start_of_packet_i          : std_logic;
  
    attribute keep                 : string;
    attribute keep of safe_b2b     : signal is "true";

begin

    safe_b2b <= SAFE_B2B_16G when (MGT_KIND = GTH16G or MGT_KIND = GTY16G) else SAFE_B2B_25G when MGT_KIND = GTY25G;

    data_valid_shreg(0) <= txdata_in.valid;
    end_of_packet_i     <= txdata_in.last;
    
    -- calculate crc only when valid bit is 1
    crc_enable <= txdata_in.valid;

    process(clk)
    begin
      if rising_edge(clk) then
          -- sreg valid bit 
          data_valid_shreg(1) <= data_valid_shreg(0);
      end if;
    end process;

    -- crc on valid bit falling edge
    valid_bit_crc_i <= '1' when data_valid_shreg = "10" else '0';

    -- transmit crc after the last word of every packet
    transmit_crc_i <= (start_of_packet_i or valid_bit_crc_i) and not back_to_back_dis;

    -- prevent back to back crc checks
    process(clk)
      variable cntr : integer range 0 to SAFE_B2B_16G;
    begin
      if rising_edge(clk) then
        if rst = '1' then
          back_to_back_dis <= '0';
        else
          if transmit_crc_i = '1' then
            back_to_back_dis <= '1';
          end if;

          if back_to_back_dis = '1' then
            if cntr = SAFE_B2B then
              back_to_back_dis <= '0';
              cntr             := 0;
            else
              cntr := cntr + 1;
            end if;
          end if;
          start_of_packet_i <= end_of_packet_i and txdata_in.valid;
        end if;
      end if;
    end process;

    -- reset at the first word of every packet
    crc_rst <= '1' when start_of_packet_i = '1' or data_valid_shreg = "01" else '0' ;

    -- crc16
    crc_calc: entity work.crc16isfTG

      port map(
        clk     => clk,
        rst     => crc_rst,
        crc_en  => crc_enable,
        data_in => txdata_in.data,
        crc_out => crc_word
        );
    
    -- transmit crc 
    crc_word_out  <= "1" & crc_word when transmit_crc_i = '1' else (others=>'0');
    

end behave;

