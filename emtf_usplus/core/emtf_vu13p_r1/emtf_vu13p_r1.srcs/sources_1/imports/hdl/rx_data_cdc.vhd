--------------------------------------------------------------------------------
-- rx data cdc, kadamidi, 2020
-- crosses user data from the rxusrclk to the payload clock through a dual port
-- block ram. crc is also crossed through the ram in chunks of 4-bits each
--------------------------------------------------------------------------------


library ieee;
use ieee.STD_LOGIC_1164.all;
use ieee.STD_LOGIC_UNSIGNED.all;
use ieee.NUMERIC_STD.all;
use work.package_links.all;


entity rx_data_cdc is
  port(
    rxusrclk         : in  std_logic;
    ttc_clk          : in  std_logic;
    rst_rx           : in  std_logic;
    rst_ttc          : in  std_logic;
    rx_data_in       : in  std_logic_vector(63 downto 0) := (others => '0');
    valid_bit_in     : in  std_logic;
    filler_tag_in    : in  std_logic;
    crc_word_in      : in  std_logic_vector(16 downto 0);
    addra_in         : in  std_logic_vector(8 downto 0);
    addrb_in         : in  std_logic_vector(8 downto 0);
    wr_en_in         : in  std_logic;
    bram_data_out    : out std_logic_vector(71 downto 0);
    crc_ttc_word_out : out std_logic_vector(16 downto 0)
    );
end entity;


architecture RTL of rx_data_cdc is

  component bram_rx_buffer
    port(
      clka  : in  std_logic;
      wea   : in  std_logic_vector(0 downto 0);
      addra : in  std_logic_vector(8 downto 0);
      dina  : in  std_logic_vector(71 downto 0);
      clkb  : in  std_logic;
      enb   : in  std_logic;
      addrb : in  std_logic_vector(8 downto 0);
      doutb : out std_logic_vector(71 downto 0)
      );
  end component;


  signal bram_in_data   : std_logic_vector(71 downto 0);
  signal bram_out_data  : std_logic_vector(71 downto 0);
  signal crc_ttc_word_i : std_logic_vector(15 downto 0) := (others => '0');
  signal crc_check_i    : std_logic                    := '0';
  signal crc_out_flag   : std_logic                    := '0';
  signal crc_out_flag_p : std_logic                    := '0';
  signal crc_wr_frn     : std_logic_vector(3 downto 0) := (others => '0');

begin


--
--======================================================================================
  process(rxusrclk)
    variable index : integer range 0 to 5;
  begin
    if rising_edge(rxusrclk) then
      if rst_rx = '1' then
        crc_wr_frn <= "0000";
        index      := 0;
      else
        if crc_word_in(16) = '1' then
          index := 0;
        end if;
        if wr_en_in = '1' then
          if index = 4 then
            crc_wr_frn <= "0000";
          elsif index < 4 then
            crc_wr_frn <= crc_word_in(index*4+3 downto index*4);
            index      := index +1;
          end if;
        end if;
      end if;
    end if;
  end process;

  crc_check_i <= '1' when crc_word_in(16) = '1' and wr_en_in = '1'else '0';
--======================================================================================

  -- write data in bram    
  bram_in_data(63 downto 0)  <= rx_data_in;
  bram_in_data(64)           <= valid_bit_in;
  bram_in_data(65)           <= crc_check_i;
  bram_in_data(66)           <= filler_tag_in;
  bram_in_data(67)           <= '0';
  bram_in_data(71 downto 68) <= crc_wr_frn;

---- Simple DUAL Port RAM RX cdc buffer
  rx_buffer : bram_rx_buffer
    port map (
      clka   => rxusrclk,
      wea(0) => wr_en_in,
      addra  => addra_in,
      dina   => bram_in_data,
      clkb   => ttc_clk,
      enb    => '1',
      addrb  => addrb_in,
      doutb  => bram_out_data
      );

--======================================================================================
  process(ttc_clk)
    variable index : integer range 0 to 5;
  begin
    if rising_edge(ttc_clk) then
      if rst_ttc = '1' then
        crc_ttc_word_i <= (others => '0');
        crc_out_flag   <= '0';
        index          := 0;
      else
        if bram_out_data(65) = '1' then
          index := 0;
        else
          if index = 4 then
            crc_ttc_word_i <= (others => '0');
          elsif index < 4 then
            crc_ttc_word_i(index*4+3 downto index*4) <= bram_out_data(71 downto 68);
            index                                    := index + 1;

          end if;
        end if;

        if index = 3 then
          crc_out_flag <= '1';
        else
          crc_out_flag <= '0';
        end if;
        crc_out_flag_p <= crc_out_flag;
      end if;
    end if;
  end process;

  crc_ttc_word_out <= crc_out_flag_p & crc_ttc_word_i;

  bram_data_out <= bram_out_data;
--======================================================================================

end architecture;
