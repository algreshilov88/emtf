---------------------------------------------------------------------------------------------------------------
-- Company: UOI - CERN
-- Engineer: Stavros Mallios, Kosmas Adamidis
-- File: CMS Standard Trigger Link Protocol Top wrapper
--
-- local version number
-- ======================================================================================
-- || Developer | Version |                 Changes                       |    Date    ||
-- ||-----------|---------|-----------------------------------------------|------------||
-- || kadamidi  |   1.0   | first version of Standard Protocol Syntax     | 10.2021    ||
-- || kadamidi  |   1.1   | new crc, index correction, user metadatA      | 11.2021    ||
-- || kadamidi  |   1.2   | modifications and cleaning, rmv init fsm      | 02.2022    ||
-- || kadamidi  |   1.3   | txIM in runtime, invalidInComb, descript      | 03.2022    ||
-- || kadamidi  |   1.4   | errorInjections, ICM                          | 02.2023    ||
-- || kadamidi  |   1.5   | new alignment process                         | 03.2023    ||
-- || kadamidi  |   1.6   | wider counters, new ICM                       | 04.2023    ||
-- || kadamidi  |   1.7   | move to link id 1 format 1                    | 03.2024    ||
-- ======================================================================================
---------------------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;

use work.emp_data_types.all;
use work.package_links.all;
use work.drp_decl.all;


entity CSTLP_top is
  generic(
    IDLE_METHOD         : integer;
    INDEX               : integer;
    MGT_I_KIND          : integer;
    MGT_O_KIND          : integer;
    TX_INST             : integer;
    RX_INST             : integer
    );
  port(
    freerun_clk        : in  std_logic;
    ttc_clk            : in  std_logic;
    refclk             : in  std_logic;
    -- Parallel interface data
    txdata_in          : in  ldata(N_CHANNELS - 1 downto 0);
    rxdata_out         : out ldata(N_CHANNELS - 1 downto 0);
    -- rx bram read pointer control
    rxram_pointer_ctrl_in : in  rxram_pointer_t_v(N_CHANNELS - 1 downto 0);
    -- TX & RX clocks for monitoring purposes
    rxclk_mon          : out std_logic_vector(N_CHANNELS - 1 downto 0);
    txclk_mon          : out std_logic;
    -- Channel control and status registers
    chan_ro_regs_out   : out type_chan_ro_reg_array(N_CHANNELS - 1 downto 0);
    chan_rw_regs_in    : in  type_chan_rw_reg_array(N_CHANNELS - 1 downto 0);
    -- Common control and status registers
    common_ro_regs_out : out type_common_ro_reg;
    common_rw_regs_in  : in  type_common_rw_reg;
    --DRP Ports
    drp_in_com         : in  drp_wbus;
    drp_out_com        : out drp_rbus;
    drp_in             : in  drp_wbus_array(N_CHANNELS - 1 downto 0);
    drp_out            : out drp_rbus_array(N_CHANNELS - 1 downto 0)
    );
end CSTLP_top;


architecture rtl of CSTLP_top is

  signal rxn_in                      : std_logic_vector(N_CHANNELS - 1 downto 0);
  signal rxp_in                      : std_logic_vector(N_CHANNELS - 1 downto 0);
  signal txn_out                     : std_logic_vector(N_CHANNELS - 1 downto 0);
  signal txp_out                     : std_logic_vector(N_CHANNELS - 1 downto 0);

  signal link_status_i               : std_logic_vector(N_CHANNELS-1 downto 0);
  signal link_down_latched_i         : std_logic_vector(N_CHANNELS-1 downto 0);
  signal txusrclk2_i                 : std_logic;
  signal txdata_i                    : type_vector_of_stdlogicvec_x64(N_CHANNELS-1 downto 0);
  signal txheader_i                  : type_vector_of_stdlogicvec_x6(N_CHANNELS-1 downto 0);
  signal txsequence_i                : type_vector_of_stdlogicvec_x7(N_CHANNELS-1 downto 0);

  signal rxusrclk2_i                 : std_logic_vector(N_CHANNELS - 1 downto 0);
  signal rxdata_i                    : type_vector_of_stdlogicvec_x64(N_CHANNELS-1 downto 0);
  signal unscrambled_data_i2         : type_vector_of_stdlogicvec_x64(N_CHANNELS-1 downto 0);
  signal rxheader_out_i              : type_vector_of_stdlogicvec_x3(N_CHANNELS-1 downto 0);
  signal rx_datavalid_i              : type_vector_of_stdlogicvec_x2(N_CHANNELS-1 downto 0);
  signal rx_datavalid_i2             : std_logic_vector(N_CHANNELS-1 downto 0);
  signal rxgearboxslip_i             : std_logic_vector(N_CHANNELS-1 downto 0);

  signal tx_init_done_i              : std_logic_vector(N_CHANNELS-1 downto 0);
  signal rx_init_done_i              : std_logic_vector(N_CHANNELS-1 downto 0);
  signal reset_rx_datapath_i         : std_logic;

  signal align_marker_sel_i          : std_logic_vector(N_CHANNELS-1 downto 0);
  signal align_marker_dis_i          : std_logic_vector(N_CHANNELS-1 downto 0);
  signal reset_counters_i            : std_logic_vector(N_CHANNELS-1 downto 0);
  signal reset_latched_i             : std_logic_vector(N_CHANNELS-1 downto 0);
  signal tx_usrrst                   : std_logic_vector(N_CHANNELS-1 downto 0);
  signal rx_usrrst                   : std_logic_vector(N_CHANNELS-1 downto 0);
  signal tx_usrrst_i                 : std_logic_vector(N_CHANNELS-1 downto 0);
  signal rx_usrrst_i                 : std_logic_vector(N_CHANNELS-1 downto 0);
  signal reset_tx_pll_and_datapath_i : std_logic;
  signal rx_valid_bit_i2             : std_logic_vector(N_CHANNELS-1 downto 0);
  signal tx_idle_method_i            : std_logic_vector(N_CHANNELS-1 downto 0);
  signal disable_ICM_i               : std_logic_vector(N_CHANNELS-1 downto 0);
  signal rxMetadata_i                : linkRxMetadata_t_v(N_CHANNELS-1 downto 0);
  signal txMetadata_i                : linkTxMetadata_t;

  signal mgtControl_i_s              : mgtControl_i_t;
  signal mgtControl_o_s              : mgtControl_o_t;
  signal linkStatusInfo_i            : linkStatusInfo_t_v(N_CHANNELS-1 downto 0);
  signal txCtrlStatus_i              : txCtrlnStatus_t_v(N_CHANNELS-1 downto 0);

  signal inject_error_i              : inject_error_t_v(N_CHANNELS-1 downto 0); 

begin


-- Loop over all (N_CHANNELS) channels
--===================================================================================================================
  chan_gen : for i in 0 to N_CHANNELS-1 generate

  begin

    --  RESETS
    --===================================================================================================================
    tx_usrrst_i(i) <= tx_usrrst(i) or reset_tx_pll_and_datapath_i;
    rx_usrrst_i(i) <= rx_usrrst(i) or reset_rx_datapath_i;
    --===================================================================================================================


    -- Transmitter Datapath
    --===================================================================================================================
    tx_path : entity work.tx_datapath
      generic map(
        INDEX                    => INDEX,
        CH                       => i,
        MGT_KIND                 => MGT_O_KIND,
        TX_INST                  => TX_INST
        )
      port map(
        ttc_clk                  => ttc_clk,
        txusrclk                 => txusrclk2_i,
        reset                    => tx_usrrst_i(i),
        reset_cnt_in             => reset_counters_i(i),
        reset_latched_in         => reset_latched_i(i),
        inject_error_in          => inject_error_i(i),
        tx_data_in               => txdata_in(i),
        tx_idle_method_in        => tx_idle_method_i(i),
        txMetadata_in            => txMetadata_i,
        tx_data_out              => txdata_i(i),
        tx_sequence_out          => txsequence_i(i),
        tx_header_out            => txheader_i(i),
        txCtrlStatus_out         => txCtrlStatus_i(i)
        );
    --===================================================================================================================


    --  Receiver datapath
    --===================================================================================================================
    rx_path : entity work.rx_datapath
      generic map(
        CH          => i,
        INDEX       => INDEX,
        MGT_KIND    => MGT_I_KIND,
        IDLE_METHOD => IDLE_METHOD,
        RX_INST     => RX_INST
        )
      port map(
        freerun_clk              => freerun_clk,
        ttc_clk                  => ttc_clk,
        rxusrclk                 => rxusrclk2_i(i),
        reset                    => rx_usrrst_i(i),
        reset_cnt_in             => reset_counters_i(i),
        reset_latched_in         => reset_latched_i(i),
        link_status_in           => link_status_i(i),
        rx_data_in               => rxdata_i(i),
        rx_header_in             => rxheader_out_i(i),
        rxram_pointer_ctrl_in    => rxram_pointer_ctrl_in(i),
        rx_datavalid_in          => rx_datavalid_i(i)(0),
        align_marker_sel_in      => align_marker_sel_i(i),
        align_marker_dis_in      => align_marker_dis_i(i),
        disable_ICM_in           => disable_ICM_i(i),
        unscrambled_data_out     => unscrambled_data_i2(i),
        rx_datavalid_out         => rx_datavalid_i2(i),
        valid_bit_out            => rx_valid_bit_i2(i),
        rxdata_out               => rxdata_out(i),
        rxMetadata_out           => rxMetadata_i(i),
        linkStatusInfo_out       => linkStatusInfo_i(i)
        );
    --===================================================================================================================


    --  Link initialization and status
    --===================================================================================================================
    link_managment : entity work.init_and_status
      port map(
        rxusrclk2_i                => rxusrclk2_i(i),
        reset                      => rx_usrrst_i(i),
        reset_link_down_latch_in   => reset_latched_i(i),
        rx_init_done_in            => rx_init_done_i(i),
        rx_datavalid_in            => rx_datavalid_i2(i),
        rxdata_in                  => unscrambled_data_i2(i),
        rx_valid_bit_in            => rx_valid_bit_i2(i),
        rxgearboxslip_out          => rxgearboxslip_i(i),
        link_status_out            => link_status_i(i),
        link_down_latched_out      => link_down_latched_i(i)
        );
    --===================================================================================================================

  end generate chan_gen;
--===================================================================================================================


--  MGT QUAD Instantiation
--===================================================================================================================
  mgt_inst : entity work.mgt_top_wrapper
    generic map(
      MGT_I_KIND  => MGT_I_KIND,
      MGT_O_KIND  => MGT_O_KIND)
    port map(
      mgtrefclk                    => refclk,
      clk_freerun                  => freerun_clk,
      reset_all_in                 => '0',
      -- Serial Ports                 
      gtrxp_in                     => rxp_in,
      gtrxn_in                     => rxn_in,
      gttxn_out                    => txn_out,
      gttxp_out                    => txp_out,
      -- TX ports   
      tx_usrclk2_out               => txusrclk2_i,
      reset_tx_pll_and_datapath_in => reset_tx_pll_and_datapath_i,
      userdata_tx_in               => txdata_i,
      txheader_in                  => txheader_i,
      txsequence_in                => txsequence_i,
      -- RX ports    
      rx_usrclk2_out               => rxusrclk2_i,
      reset_rx_datapath_in         => reset_rx_datapath_i,
      userdata_rx_out              => rxdata_i,
      rxheader_out                 => rxheader_out_i,
      rxdatavalid_out              => rx_datavalid_i,
      rxgearboxslip_in             => rxgearboxslip_i,
      -- Initialization
      tx_init_done_out             => tx_init_done_i,
      rx_init_done_out             => rx_init_done_i,
      -- DRP Ports
      drp_in_com                   => drp_in_com,
      drp_out_com                  => drp_out_com,
      drp_in                       => drp_in,
      drp_out                      => drp_out,
      -- Contro and Status ports
      mgtControl_in                => mgtControl_i_s,
      mgtControl_out               => mgtControl_o_s
      );
--===================================================================================================================


-- TX & RX clocks for monitoring
--===================================================================================================================
  clk_div : entity work.freq_ctr_div
    generic map(
      N_CLK => 5
      )
    port map(
      clk(3 downto 0)    => rxusrclk2_i,
      clk(4)             => txusrclk2_i,
      clkdiv(3 downto 0) => rxclk_mon,
      clkdiv(4)          => txclk_mon
      );
--===================================================================================================================


-- control and status registers
--===================================================================================================================
  cs_regs : entity work.links_cs_interface
    port map(
      ttc_clk_in                    => ttc_clk,
      txusrclk2_i                   => txusrclk2_i,
      rxusrclk2_i                   => rxusrclk2_i,
      stable_clk_in                 => freerun_clk,
      mgtControl_in                 => mgtControl_o_s,
      mgtControl_out                => mgtControl_i_s,
      chan_ro_regs_out              => chan_ro_regs_out,
      chan_rw_regs_in               => chan_rw_regs_in,
      common_ro_regs_out            => common_ro_regs_out,
      common_rw_regs_in             => common_rw_regs_in,
      --Channel status (read) signals   
      link_status_in                => link_status_i,
      link_down_latched_in          => link_down_latched_i,
      tx_init_done_in               => tx_init_done_i,
      rx_init_done_in               => rx_init_done_i,
      linkStatusInfo_in             => linkStatusInfo_i,
      rxMetadata_in                 => rxMetadata_i,
      txCtrlStatus_in               => txCtrlStatus_i,
      -- Channel control (write) signals
      reset_counters_out            => reset_counters_i,
      reset_latched_out             => reset_latched_i,
      tx_usrrst_out                 => tx_usrrst,
      rx_usrrst_out                 => rx_usrrst,
      tx_idle_method_out            => tx_idle_method_i,
      disable_ICM_out               => disable_ICM_i,
      align_marker_dis_out          => align_marker_dis_i,
      align_marker_sel_out          => align_marker_sel_i,
      inject_error_out              => inject_error_i,
      -- Common status signals
      -- Common control signals
      reset_tx_pll_and_datapath_out => reset_tx_pll_and_datapath_i,
      reset_rx_datapath_out         => reset_rx_datapath_i,
      txMetadata_out                => txMetadata_i
      );
--===================================================================================================================

end rtl;

