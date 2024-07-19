
--------------------------------------------------------------------------------
-- crc and data cdc
-- crosses data to the txusrclk domain using FIFO block and the CRC using Flip
-- Flops
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

use work.package_links.all;


entity tx_data_cdc is
  port(
    rst_ttc               : in  std_logic;
    rst_tx                : in  std_logic;
    reset_latch           : in  std_logic;
    ttc_clk               : in  std_logic;
    txusrclk              : in  std_logic;
    fifo_data_in          : in  std_logic_vector(71 downto 0);
    crc_word_in           : in  std_logic_vector(15 downto 0);
    read_enable_in        : in  std_logic;
    fifo_data_out         : out std_logic_vector(71 downto 0);
    crc_word_link_out     : out std_logic_vector(16 downto 0);
    full_latch_out        : out std_logic;
    almost_full_latch_out : out std_logic;
    empty_out             : out std_logic
    );

end tx_data_cdc;


architecture xilinx of tx_data_cdc is

  component tx_fifo is
    port (
      rst           : in  std_logic;
      wr_clk        : in  std_logic;
      rd_clk        : in  std_logic;
      din           : in  std_logic_vector(71 downto 0) := (others => '0');
      wr_en         : in  std_logic;
      rd_en         : in  std_logic;
      dout          : out std_logic_vector(71 downto 0) := (others => '0');
      full          : out std_logic;
      almost_full   : out std_logic;
      empty         : out std_logic;
      almost_empty  : out std_logic;
      rd_data_count : out std_logic_vector(8 downto 0);
      wr_data_count : out std_logic_vector(8 downto 0);
      prog_full     : out std_logic;
      prog_empty    : out std_logic
      );
  end component;

  signal fifo_out            : std_logic_vector(71 downto 0) := (others => '0');
  signal crc_word_link       : std_logic_vector(15 downto 0) := (others => '0');
  signal crc_word_ttc_i1     : std_logic_vector(15 downto 0);
  signal rd_data_count       : std_logic_vector(8 downto 0); 
  signal wr_data_count       : std_logic_vector(8 downto 0); 
  signal wr_en_i             : std_logic                     := '0';
  signal empty               : std_logic                     := '0';
  signal full                : std_logic                     := '0';
  signal almost_full         : std_logic                     := '0';
  signal full_i1             : std_logic                     := '0';
  signal almost_full_i1      : std_logic                     := '0';
  signal almost_empty        : std_logic                     := '0';

  attribute ASYNC_REG                : string;
  attribute ASYNC_REG of crc_word_link  : signal is "TRUE";

begin

--======================================================================================
  process(ttc_clk)
  begin
    if rising_edge(ttc_clk) then
       if fifo_data_in(65) = '1' then
         crc_word_ttc_i1 <= crc_word_in;
       end if;
    end if;
  end process;
  
  process(ttc_clk)
  begin
    if rising_edge(ttc_clk) then
      if rst_ttc = '1' then
        wr_en_i <= '0';
      else
        wr_en_i <= '1';
      end if;
    end if;
  end process;

  top_inst : tx_fifo
    port map (
      rst           => rst_ttc,
      wr_clk        => ttc_clk,
      rd_clk        => txusrclk,
      din           => fifo_data_in,
      wr_en         => wr_en_i,
      rd_en         => read_enable_in,
      dout          => fifo_out,
      full          => full,
      almost_full   => almost_full,
      empty         => empty,
      almost_empty  => almost_empty,
      rd_data_count => rd_data_count,
      wr_data_count => wr_data_count,
      prog_full     => open,
      prog_empty    => open
      );
--======================================================================================

-- latch crc word on link domain
--======================================================================================
  process(txusrclk)
  begin
      if rising_edge(txusrclk) then
        crc_word_link <= crc_word_ttc_i1;
      end if;
  end process;
 
--======================================================================================
  
  crc_word_link_out <= "1" & crc_word_link when fifo_out(65) = '1' and read_enable_in = '1' else (others=>'0');
  empty_out         <= empty;
  fifo_data_out     <= fifo_out;

--======================================================================================
  process(ttc_clk)
  begin
    if rising_edge(ttc_clk) then
      if reset_latch = '1' then
        full_latch_out        <= '0';
        almost_full_latch_out <= '0';
      else
        full_i1 <= full;
        almost_full_i1 <= almost_full;
        if full_i1 = '1' then
          full_latch_out <= '1';
        end if;
        if almost_full_i1 = '1' then
          almost_full_latch_out <= '1';
        end if;
      end if;
    end if;
  end process;
--======================================================================================

end xilinx;
