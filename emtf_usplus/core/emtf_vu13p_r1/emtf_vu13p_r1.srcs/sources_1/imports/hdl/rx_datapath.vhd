--------------------------------------------------------------------------------
-- rx datapath, kadamidi, 2020
-- includes receiver blocks that decode received data and feed them to the 
-- payload module
--------------------------------------------------------------------------------

library ieee;
use ieee.STD_LOGIC_1164.all;


use work.emp_data_types.all;
use work.package_links.all;

entity rx_datapath is
  generic(
    CH          : integer;
    INDEX       : integer;
    MGT_KIND    : integer; -- GTY25G
    IDLE_METHOD : integer; -- 1 or 2?
    RX_INST     : integer
    );
  port(
    freerun_clk           : in  std_logic;
    ttc_clk               : in  std_logic;
    rxusrclk              : in  std_logic;
    reset                 : in  std_logic;
    reset_cnt_in          : in  std_logic;
    reset_latched_in      : in  std_logic;
    link_status_in        : in  std_logic;
    rx_data_in            : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    rx_header_in          : in  std_logic_vector(2 downto 0);
    rx_datavalid_in       : in  std_logic;
    align_marker_sel_in   : in  std_logic;
    align_marker_dis_in   : in  std_logic;
    disable_ICM_in        : in  std_logic;
    rxram_pointer_ctrl_in : in  rxram_pointer_t;
    unscrambled_data_out  : out std_logic_vector(DATA_WIDTH-1 downto 0);
    valid_bit_out         : out std_logic;
    rx_datavalid_out      : out std_logic;
    rxdata_out            : out lword;
    rxMetadata_out        : out linkRxMetadata_t;
    linkStatusInfo_out    : out linkStatusInfo_t

    );
end entity;

architecture RTL of rx_datapath is

  signal rx_data_i         : std_logic_vector(63 downto 0) := (others => '0');
  signal data_ttc_i        : std_logic_vector(63 downto 0) := (others => '0');
  signal bram_out_data_i   : std_logic_vector(65 downto 0) := (others => '0');
  signal crc_ttc_word_i    : std_logic_vector(16 downto 0) := (others => '0');
  signal rx_datavalid_i    : std_logic;
  signal valid_bit_i       : std_logic;
  signal align_tag_i       : std_logic;
  signal start_of_packet_i : std_logic;
  signal end_of_packet_i   : std_logic;
  signal data_start_i      : std_logic;
  signal rst_rx            : std_logic;
  signal rst_ttc           : std_logic;
  signal rst_cntr_rx       : std_logic;
  signal rst_cntr_ttc      : std_logic;
  signal valid_bit_ttc_i   : std_logic;
  signal align_marker_i    : std_logic;
  signal reset_latched     : std_logic;

begin

  --============================================================================================================================

  rx_gen : if MGT_KIND = NOMGT generate

    unscrambled_data_out <= (others => '0');
    rx_datavalid_out     <= '0';
    valid_bit_out        <= '0';

    rxdata_out.data            <= (others => '0');
    rxdata_out.valid           <= '0';
    rxdata_out.strobe          <= '1';
    rxdata_out.start           <= '0';
    rxdata_out.start_of_orbit  <= '0';
    rxdata_out.last            <= '0';

  else generate -- rx_gen
  
    reset_synchronizer_rstRx_inst : entity work.emp_reset_synchronizer
      port map(
        clk_in  => rxusrclk,
        rst_in  => reset,
        rst_out => rst_rx
        );  
    reset_synchronizer_rstTTC_inst : entity work.emp_reset_synchronizer
      port map(
        clk_in  => ttc_clk,
        rst_in  => reset,
        rst_out => rst_ttc
        );
    reset_synchronizer_rstCnt_inst : entity work.emp_reset_synchronizer
      port map(
        clk_in  => rxusrclk,
        rst_in  => reset_cnt_in,
        rst_out => rst_cntr_rx
        );
    reset_synchronizer_rstCntttc_inst : entity work.emp_reset_synchronizer
      port map(
        clk_in  => ttc_clk,
        rst_in  => reset_cnt_in,
        rst_out => rst_cntr_ttc
        );
      reset_synchronizer_rstLatched_inst : entity work.emp_reset_synchronizer
      port map(
        clk_in  => rxusrclk,
        rst_in  => reset_latched_in,
        rst_out => reset_latched
        );
  
  
    -- Protocol Decoding Blocks
    --============================================================================================================================
    decode : entity work.protocol_decoders
      port map(
        rxusrclk                 => rxusrclk,
        rst_rx                   => rst_rx,
        rst_counters             => rst_cntr_rx,
        rxdata_in                => rx_data_in,
        rx_datavalid_in          => rx_datavalid_in,
        rxheader_in              => rx_header_in,
        unscrambled_data_out     => rx_data_i,
        valid_bit_out            => valid_bit_i,
        rx_datavalid_out         => rx_datavalid_i,
        linkStatusInfo_out       => linkStatusInfo_out
        );
    --============================================================================================================================


    -- CMS Standard Protocol Engine
    --============================================================================================================================
    rx : entity work.rx_engine
      port map(
        freerun_clk              => freerun_clk,
        rxusrclk                 => rxusrclk,
        ttc_clk                  => ttc_clk,
        rst_rx                   => rst_rx,
        rst_ttc                  => rst_ttc,
        rst_latched              => reset_latched,
        rst_cntr_rx              => rst_cntr_rx,
        link_status_in           => link_status_in,
        rx_data_in               => rx_data_i,
        valid_bit_in             => valid_bit_i,
        rx_datavalid_in          => rx_datavalid_i,
        rxram_pointer_ctrl_in    => rxram_pointer_ctrl_in,
        disable_ICM_in           => disable_ICM_in,
        bram_data_out            => bram_out_data_i,
        crc_ttc_word_out         => crc_ttc_word_i,
        rxMetadata_out           => rxMetadata_out,
        align_tag_out            => align_tag_i,
        special_bits_out         => linkStatusInfo_out.special_bits,
        index_lock_lost_out      => linkStatusInfo_out.rx_index_lock_lost,
        index_lock_lost_cntr_out => linkStatusInfo_out.rx_index_lock_lost_cntr,
        wrong_index_cntr_out     => linkStatusInfo_out.wrong_index_cntr_out
        );
    --============================================================================================================================


    -- check crc errors
    --============================================================================================================================         
    crc_check : entity work.links_crc_rx
      generic map(
        MGT_KIND    => MGT_KIND,
        IDLE_METHOD => IDLE_METHOD 
        )
      port map(
        reset                    => rst_ttc,
        reset_counters_in        => rst_cntr_ttc,
        clk                      => ttc_clk,
        clken_in                 => '1',
        data_in                  => bram_out_data_i(63 downto 0),
        valid_bit_in             => bram_out_data_i(64),
        crc_flag_in              => bram_out_data_i(65),
        crc_ttc_word_in          => crc_ttc_word_i,
        align_tag_in             => align_tag_i,
        align_marker_sel_in      => align_marker_sel_in,
        align_marker_dis_in      => align_marker_dis_in,
        data_out                 => data_ttc_i,
        valid_bit_out            => valid_bit_ttc_i,
        data_start_out           => data_start_i,
        end_of_packet_out        => end_of_packet_i,
        align_marker_out         => align_marker_i,        
        packet_cnt_out           => linkStatusInfo_out.packet_cntr,
        crc_error_cnt_out        => linkStatusInfo_out.crc_errors
        );
    --============================================================================================================================         

    -- out ports   
    --============================================================================================================================
    -- rxusrclk domain
    unscrambled_data_out <= rx_data_i;
    rx_datavalid_out     <= rx_datavalid_i;
    valid_bit_out        <= valid_bit_i;

    -- payload clock domain
    rxdata_out.data           <= data_ttc_i;
    rxdata_out.valid          <= valid_bit_ttc_i;
    rxdata_out.strobe         <= '1';
    rxdata_out.start          <= data_start_i;
    rxdata_out.start_of_orbit <= align_marker_i;
    rxdata_out.last           <= end_of_packet_i;
    --============================================================================================================================

  end generate rx_gen;
  --============================================================================================================================


end architecture;
