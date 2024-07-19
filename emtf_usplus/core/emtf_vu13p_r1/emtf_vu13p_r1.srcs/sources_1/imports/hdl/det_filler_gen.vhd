----------------------------------------------------------------------------------
-- deterministic filler words generation, kadamidi, 2020
-- generates artificial filler words to be used as the OT/BC0 or CRC filler words
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;

use work.package_links.all;


entity det_filler_gen is

  port (
    txusrclk            : in  std_logic;
    rst_tx              : in  std_logic;
    fifo_data_in        : in  std_logic_vector(66 downto 0);
    crc_word_link_in    : in  std_logic_vector(16 downto 0);
    empty_in            : in  std_logic;
    tx_gb_datavalid_in  : in  std_logic;
    txdata_out          : out std_logic_vector(63 downto 0);
    valid_bit_out       : out std_logic;
    crc_word_link_out   : out std_logic_vector(16 downto 0);
    crc_filler_flag_out : out std_logic;
    align_tag_out       : out std_logic;
    read_fifo_out       : out std_logic;
    tx_gb_datavalid_out : out std_logic;
    empty_out           : out std_logic;
    txsequence_out      : out std_logic_vector(6 downto 0)
    );
end det_filler_gen;

architecture Behavioral of det_filler_gen is

  signal filler_word_in    : std_logic := '0';
  signal filler_word_p     : std_logic := '0';
  signal filler_word_s     : std_logic := '0';
  signal filler_word_s_l1  : std_logic := '0';
  signal filler_word_flag  : std_logic := '0';
  signal filler_word_af_ps : std_logic := '0';
  signal filler_word_o     : std_logic := '0';


  signal tx_gb_datavalid_i1           : std_logic                    := '0';
  signal tx_gb_datavalid_i2           : std_logic                    := '0';
  signal empty_i1                     : std_logic                    := '0';
  signal read_fifo                    : std_logic                    := '0';
  signal pause_after_tag_flag         : std_logic                    := '0';
  signal empty_after_tag_flag         : std_logic                    := '0';
  signal orbit_tag_t                  : std_logic                    := '0';
  signal read_fifo_o                  : std_logic                    := '0';
  signal empty_after_tag_n_pause_flag : std_logic                    := '0';
  signal special_read_flags           : std_logic                    := '0';
  signal crc_filler_i                 : std_logic                    := '0';
  signal tag_filler_i                 : std_logic                    := '0';
  signal tag_filler_i1                : std_logic                    := '0';
  signal tag_filler_i2                : std_logic                    := '0';
  signal filler_mux_i                 : std_logic_vector(1 downto 0);

  attribute DONT_TOUCH                : string;
  attribute DONT_TOUCH of Behavioral  : architecture is "yes";
  attribute keep                      : string;
  attribute keep of filler_word_s     : signal is "true";
  attribute keep of filler_word_af_ps : signal is "true";

begin

  crc_filler_i <= fifo_data_in(65); 
  tag_filler_i <= fifo_data_in(66);

  process(txusrclk)
  begin
    if rising_edge(txusrclk) then
      if rst_tx = '1' then
        filler_mux_i <= "00";
        tag_filler_i1 <= '0';
      else
        if tx_gb_datavalid_in = '1' and empty_in = '0' then 
            if crc_filler_i = '1' and tag_filler_i = '0' then
              filler_mux_i <= "01";         -- crc filler 
              tag_filler_i1 <= '0';
            elsif crc_filler_i = '0' and tag_filler_i = '1' then
              filler_mux_i <= "10";         -- tag filler
              tag_filler_i1 <= '0';
            elsif crc_filler_i = '1' and tag_filler_i = '1' then
              filler_mux_i <= "01";  
              tag_filler_i1 <= '1';      
            else
              filler_mux_i <= "00";
              tag_filler_i1 <= '0';
            end if;
            tag_filler_i2 <= tag_filler_i1;
        end if;
      end if;
    end if;
  end process;


  filler_word_s <= ((crc_filler_i or tag_filler_i) and read_fifo_o) or tag_filler_i1;

  process(txusrclk)
  begin
    if rising_edge(txusrclk) then
      if rst_tx = '1' then
        filler_word_s_l1   <= '0';
        tx_gb_datavalid_i1 <= '0';
        tx_gb_datavalid_i2 <= '0';
      else
        tx_gb_datavalid_i1 <= tx_gb_datavalid_in;
        tx_gb_datavalid_i2 <= tx_gb_datavalid_i1;

        filler_word_s_l1   <= filler_word_s;
      end if;
    end if;
  end process;


  process(txusrclk)
  begin

    if rising_edge(txusrclk) then
      if rst_tx = '1' then
        filler_word_flag <= '0';
      else
        -- in case of filler word during gearbox pause, wait until pause is done
        if tx_gb_datavalid_in = '0' and filler_word_s = '1' then
          filler_word_flag <= '1';
        elsif tx_gb_datavalid_i1 = '1' then
          filler_word_flag <= '0';
        end if;
      end if;
    end if;
  end process;

  -- everything below this line needs 1 level of pipeline , except from filler_word_flag
  filler_word_af_ps <= not tx_gb_datavalid_i2 and tx_gb_datavalid_i1 and filler_word_flag;

  filler_word_o <= (filler_word_s_l1 and tx_gb_datavalid_i1) or filler_word_af_ps;


-- Generate Filler Word signal with 1 FF inbetween
--============================================================================================================================
  process(txusrclk)
  begin

    if rising_edge(txusrclk) then
      if rst_tx = '1' then

        txdata_out                   <= (others => '0');
        valid_bit_out                <= '0';
        pause_after_tag_flag         <= '0';
        empty_after_tag_flag         <= '0';
        empty_after_tag_n_pause_flag <= '0';

      else

        -- pause pipeline when pause fifo read, except read_en_i
        if (filler_word_o = '0' and empty_i1 = '0') and special_read_flags = '0' then
          -- 
          txdata_out    <= fifo_data_in(63 downto 0);
          valid_bit_out <= fifo_data_in(64);
        end if;

        -- pause fifo read and pipeline for 1 more cc when pause comes after filler
        if (tx_gb_datavalid_in = '0' and filler_word_o = '1' and empty_i1 = '0') then
          pause_after_tag_flag <= '1';
        elsif tx_gb_datavalid_in = '1' then
          pause_after_tag_flag <= '0';
        end if;

        -- pause fifo read and pipeline for 1 more cc when empty comes with filler
        empty_after_tag_flag <= empty_in and filler_word_o;

        -- there is one very special case where you have filler -> empty -> pause
        if tx_gb_datavalid_in = '0' and empty_after_tag_flag = '1' then
          empty_after_tag_n_pause_flag <= '1';
        elsif tx_gb_datavalid_in = '1' then
          empty_after_tag_n_pause_flag <= '0';
        end if;

        -- 1 cc pipeline
        crc_word_link_out  <= crc_word_link_in;
        empty_i1           <= empty_in;

      end if;
    end if;
  end process;
--============================================================================================================================

  special_read_flags <= pause_after_tag_flag or empty_after_tag_flag or empty_after_tag_n_pause_flag;

  read_fifo_o   <= tx_gb_datavalid_in and (empty_i1 or not filler_word_o) and not special_read_flags;
  read_fifo_out <= read_fifo_o;

  tx_gb_datavalid_out <= tx_gb_datavalid_i1;
  empty_out           <= empty_i1;

  crc_filler_flag_out <= '1' when filler_word_o = '1' and filler_mux_i = "01" else '0';
  align_tag_out       <= '1' when (filler_word_o = '1' and filler_mux_i = "10") or (filler_word_o = '1' and tag_filler_i2 = '1') else '0';

end Behavioral;
