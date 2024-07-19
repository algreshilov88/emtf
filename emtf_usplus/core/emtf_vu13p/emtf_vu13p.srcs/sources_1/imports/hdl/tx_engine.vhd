--------------------------------------------------------------------------------
-- tx engige, kadamidi, 2020
-- tx engine crosses data to the txusrclk domain, generates artificial filler 
-- words and builds the CSP 64 bit frames
--------------------------------------------------------------------------------

library ieee;
use ieee.STD_LOGIC_1164.all;

use work.package_links.all;
use work.emp_data_types.all;


entity tx_engine is
  generic(
    INDEX                  : integer;
    CH                     : integer
    );
  port(
    ttc_clk                : in  std_logic;
    txusrclk               : in  std_logic;
    rst_ttc                : in  std_logic;
    rst_tx                 : in  std_logic;
    rst_latched            : in  std_logic;
    tx_gb_datavalid_in     : in  std_logic;
    txsequence_in          : in  std_logic_vector(6 downto 0);
    txdata_in              : in  lword;
    crc_word_in            : in  std_logic_vector(16 downto 0);
    tx_idle_method_in      : in  std_logic;
    upstream_link_error_in : in  std_logic;
    txMetadata_in          : in  linkTxMetadata_t;
    tx_data_out            : out std_logic_vector(DATA_WIDTH-1 downto 0);
    tx_header_out          : out std_logic_vector(2 downto 0);
    txsequence_out         : out std_logic_vector(6 downto 0);
    tx_gb_datavalid_out    : out std_logic;
    almost_full_out        : out std_logic;
    full_out               : out std_logic
    );
end entity;

architecture RTL of tx_engine is

  signal fifo_data_in_i  : std_logic_vector(71 downto 0) := (others => '0');
  signal fifo_data_out_i : std_logic_vector(71 downto 0) := (others => '0');
  signal txdata_i1       : std_logic_vector(63 downto 0) := (others => '0');
  signal crc_word_link_i : std_logic_vector(16 downto 0) := (others => '0');
  signal crc_word_link_i1 : std_logic_vector(16 downto 0) := (others => '0');
  signal empty_i         : std_logic                     := '1';

  signal txdata_i2        : std_logic_vector(63 downto 0) := (others => '0');
  signal txheader_i2      : std_logic_vector(2 downto 0)  := (others => '0');
  signal txsequence_i1    : std_logic_vector(6 downto 0)  := (others => '0');
  signal txsequence_i2    : std_logic_vector(6 downto 0)  := (others => '0');

  signal tx_gb_datavalid_i1: std_logic := '0';
  signal empty_i1          : std_logic := '0';
  signal align_tag_i1      : std_logic := '0';
  signal read_fifo_i       : std_logic := '0';
  signal crc_filler_flag_i1: std_logic := '0';
  signal valid_bit_i1      : std_logic := '0';
  
  function bit_reverse(s1 : std_logic_vector) return std_logic_vector is
    variable rr : std_logic_vector(s1'high downto s1'low);
  begin
    for ii in s1'high downto s1'low loop
      rr(ii) := s1(s1'high-ii);
    end loop;
    return rr;
  end bit_reverse;
  
begin

-- TX Asynchronous FIFO 
--============================================================================================================================

   -- data to cross domain through fifo
   fifo_data_in_i(63 downto 0)  <= txdata_in.data;
   fifo_data_in_i(64)           <= txdata_in.valid; 
   fifo_data_in_i(65)           <= crc_word_in(16);
   fifo_data_in_i(66)           <= txdata_in.start_of_orbit;
   fifo_data_in_i(71 downto 67) <= (others => '0');

  tx_cdc : entity work.tx_data_cdc
    port map(
      rst_ttc               => rst_ttc,
      rst_tx                => rst_tx,
      reset_latch           => rst_latched,
      -- Write ports           
      ttc_clk               => ttc_clk,
      fifo_data_in          => fifo_data_in_i,
      crc_word_in           => crc_word_in(15 downto 0),
      almost_full_latch_out => almost_full_out,
      full_latch_out        => full_out,
      -- Read ports        
      txusrclk              => txusrclk,
      read_enable_in        => read_fifo_i,
      fifo_data_out         => fifo_data_out_i,
      crc_word_link_out     => crc_word_link_i,
      empty_out             => empty_i
      );

--============================================================================================================================


-- Generate Deterministic Filler Words
--============================================================================================================================
  filler_gen : entity work.det_filler_gen
    port map(
      txusrclk            => txusrclk,
      rst_tx              => rst_tx,
      fifo_data_in        => fifo_data_out_i(66 downto 0),
      crc_word_link_in    => crc_word_link_i,
      empty_in            => empty_i,
      tx_gb_datavalid_in  => tx_gb_datavalid_in,
      txdata_out          => txdata_i1,
      valid_bit_out       => valid_bit_i1,
      crc_word_link_out   => crc_word_link_i1,
      crc_filler_flag_out => crc_filler_flag_i1,
      align_tag_out       => align_tag_i1,
      read_fifo_out       => read_fifo_i,
      empty_out           => empty_i1,
      tx_gb_datavalid_out => tx_gb_datavalid_i1
      );

--============================================================================================================================


-- CMS Standard Protocol Frame Builder
--============================================================================================================================
  tx_frame_builder : entity work.frame_builder
    generic map(
      INDEX                  => INDEX,
      CH                     => CH)
    port map(
      txusrclk               => txusrclk,
      rst_tx                 => rst_tx,
      data_in                => txdata_i1,
      crc_word_in            => crc_word_link_i1,
      valid_bit_in           => valid_bit_i1,
      pad_in                 => empty_i1,
      tx_gb_datavalid_in     => tx_gb_datavalid_i1,
      crc_filler_flag_in     => crc_filler_flag_i1,
      align_tag_in           => align_tag_i1,
      tx_idle_method_in      => tx_idle_method_in,
      upstream_link_error_in => upstream_link_error_in,
      txMetadata_in          => txMetadata_in,
      data_out               => txdata_i2,
      header_out             => txheader_i2,
      tx_gb_datavalid_out    => tx_gb_datavalid_out
      );

--============================================================================================================================

-- pipeline tx sequence to match data latency
--============================================================================================================================
  process(txusrclk)
  begin
    if rising_edge(txusrclk) then
       -- delay 1 cc to match filler generation delay
      txsequence_i1    <= txsequence_in;
      -- delay 1 cc to match packet builder delay
      txsequence_i2   <= txsequence_i1;
    end if;
  end process;
--============================================================================================================================


-- Out Ports
--============================================================================================================================
--  tx_data_out    <= bit_reverse(txdata_i2);
  tx_data_out    <= (txdata_i2);
  tx_header_out  <= txheader_i2;
  txsequence_out <= txsequence_i2;
--============================================================================================================================

end architecture;
