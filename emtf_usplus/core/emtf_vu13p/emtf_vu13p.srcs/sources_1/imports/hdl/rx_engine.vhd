--------------------------------------------------------------------------------
-- rx engine - kadamidi - 2020
-- rx engine controls the write enable of bram, the read pointer, crosses 
-- data to the payload domain
--------------------------------------------------------------------------------


library ieee;
use ieee.STD_LOGIC_1164.all;
use work.package_links.all;


entity rx_engine is
  port(
    freerun_clk              : in  std_logic;
    rxusrclk                 : in  std_logic;
    ttc_clk                  : in  std_logic;
    rst_rx                   : in  std_logic;
    rst_ttc                  : in  std_logic;
    rst_latched              : in  std_logic;
    rst_cntr_rx              : in  std_logic;
    rx_data_in               : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    valid_bit_in             : in  std_logic;
    rx_datavalid_in          : in  std_logic;
    rxram_pointer_ctrl_in    : in  rxram_pointer_t;
    link_status_in           : in  std_logic;
    disable_ICM_in           : in  std_logic;
    bram_data_out            : out std_logic_vector(65 downto 0);
    crc_ttc_word_out         : out std_logic_vector(16 downto 0);
    rxMetadata_out           : out linkRxMetadata_t;
    special_bits_out         : out std_logic_vector(3 downto 0);
    index_lock_lost_out      : out std_logic;
    index_lock_lost_cntr_out : out std_logic_vector(3 downto 0);
    wrong_index_cntr_out     : out std_logic_vector(3 downto 0);
    align_tag_out            : out std_logic
    );
end entity;


architecture RTL of rx_engine is

  signal wbuf_add_word_i        : std_logic_vector(8 downto 0);
  signal rbuf_add_word_i        : std_logic_vector(8 downto 0);
  signal special_bits_i         : std_logic_vector(7 downto 0);
  signal sb_data_i              : std_logic_vector(63 downto 0);
  signal sb_outdata_i           : std_logic_vector(63 downto 0);
  signal bram_out_data          : std_logic_vector(71 downto 0);
  signal crc_word_i             : std_logic_vector(16 downto 0);
  signal crc_ttc_word_i         : std_logic_vector(16 downto 0);
  signal wr_en_i                : std_logic;
  signal filler_tag_i           : std_logic;
  signal sb_valid_i1            : std_logic;
  signal rx_datavalid_i1        : std_logic;
  signal sb_single_error_i      : std_logic;
  signal sb_double_error_i      : std_logic;

begin


  -- BRAM Pointers Control
  --======================================================================================
  bram_control : entity work.rxbram_ctrl
    port map(
      freerun_clk              => freerun_clk,
      rxusrclk                 => rxusrclk,
      ttc_clk                  => ttc_clk,
      rst_rx                   => rst_rx,
      rst_ttc                  => rst_ttc,
      rst_latched              => rst_latched,
      rst_cntr_rx              => rst_cntr_rx,
      rx_data_in               => rx_data_in,
      valid_bit_in             => valid_bit_in,
      rx_datavalid_in          => rx_datavalid_in,
      link_status_in           => link_status_in,
      disable_ICM_in           => disable_ICM_in,
      rxram_pointer_ctrl_in    => rxram_pointer_ctrl_in,
      wbuf_add_word_out        => wbuf_add_word_i,
      rbuf_add_word_out        => rbuf_add_word_i,
      filler_tag_out           => filler_tag_i,
      crc_word_out             => crc_word_i,
      rxMetadata_out           => rxMetadata_out,
      special_bits_out         => special_bits_i,
      index_lock_lost_out      => index_lock_lost_out,
      index_lock_lost_cntr_out => index_lock_lost_cntr_out,
      wrong_index_cntr_out     => wrong_index_cntr_out,
      wr_en_out                => wr_en_i
      );
  --======================================================================================
  
  -- BRAM and crc cdc
  --======================================================================================
  rx_cdc : entity work.rx_data_cdc
    port map(
      rxusrclk         => rxusrclk,
      ttc_clk          => ttc_clk,
      rst_rx           => rst_rx,
      rst_ttc          => rst_ttc,
      rx_data_in       => rx_data_in,
      valid_bit_in     => valid_bit_in,
      filler_tag_in    => filler_tag_i,
      crc_word_in      => crc_word_i,
      addra_in         => wbuf_add_word_i,
      addrb_in         => rbuf_add_word_i,
      wr_en_in         => wr_en_i,
      bram_data_out    => bram_out_data,
      crc_ttc_word_out => crc_ttc_word_i
      );
  --======================================================================================

  -- Special Bits Hamming decode
  --======================================================================================
  process(rxusrclk)
  begin
    if rising_edge(rxusrclk) then
      sb_valid_i1     <= crc_word_i(16);
      rx_datavalid_i1 <= rx_datavalid_in;
    end if;
  end process;
  
  sb_data_i <= special_bits_i & x"00000000000000";
  
  decoder : entity work.hamming_dececoder
    port map(
      rxusrclk                 => rxusrclk,
      rst_rx                   => rst_rx,
      rx_datavalid_in          => rx_datavalid_i1,
      rxdata_in                => sb_data_i,
      valid_bit_in             => sb_valid_i1,
      rxdata_out               => sb_outdata_i,
      cwt_single_error_out     => sb_single_error_i,
      cwt_double_error_out     => sb_double_error_i
      );
  --======================================================================================

  -- Out Ports
  bram_data_out    <= bram_out_data(65 downto 0);
  align_tag_out    <= bram_out_data(66);  
  crc_ttc_word_out <= crc_ttc_word_i;
  special_bits_out <= sb_outdata_i(59 downto 56);


end architecture;
