----------------------------------------------------------------------------------
-- link control and status interface , kadamidi, 2019
-- connectes the control and status signals to the control bus registers and 
-- performs the appropriate domain crossings
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use work.package_links.all;
use IEEE.NUMERIC_STD.all;


entity links_cs_interface is
  port (
    ttc_clk_in                    : in std_logic;
    txusrclk2_i                   : in std_logic;
    rxusrclk2_i                   : in std_logic_vector(N_CHANNELS-1 downto 0);
    stable_clk_in                 : in std_logic;

    mgtControl_in                 : in  mgtControl_o_t;
    mgtControl_out                : out mgtControl_i_t;
    -- Channel Registers
    chan_ro_regs_out              : out type_chan_ro_reg_array(N_CHANNELS-1 downto 0);
    chan_rw_regs_in               : in  type_chan_rw_reg_array(N_CHANNELS-1 downto 0);
    -- Common Registers
    common_ro_regs_out            : out type_common_ro_reg;
    common_rw_regs_in             : in  type_common_rw_reg;
    -- Channel in signals
    link_status_in                : in  std_logic_vector(N_CHANNELS-1 downto 0);
    link_down_latched_in          : in  std_logic_vector(N_CHANNELS-1 downto 0);
    linkStatusInfo_in             : in  linkStatusInfo_t_v(N_CHANNELS-1 downto 0);
    tx_init_done_in               : in  std_logic_vector(N_CHANNELS-1 downto 0);
    rx_init_done_in               : in  std_logic_vector(N_CHANNELS-1 downto 0);
    txCtrlStatus_in               : in  txCtrlnStatus_t_v(N_CHANNELS-1 downto 0);
    rxMetadata_in                 : in  linkRxMetadata_t_v(N_CHANNELS-1 downto 0);
    -- Channel out signals        
    align_marker_sel_out          : out std_logic_vector(N_CHANNELS-1 downto 0);
    align_marker_dis_out          : out std_logic_vector(N_CHANNELS-1 downto 0);
    reset_counters_out            : out std_logic_vector(N_CHANNELS-1 downto 0);
    reset_latched_out             : out std_logic_vector(N_CHANNELS-1 downto 0);
    tx_usrrst_out                 : out std_logic_vector(N_CHANNELS-1 downto 0);
    rx_usrrst_out                 : out std_logic_vector(N_CHANNELS-1 downto 0);
    tx_idle_method_out            : out std_logic_vector(N_CHANNELS-1 downto 0);
    disable_ICM_out               : out std_logic_vector(N_CHANNELS-1 downto 0);
    inject_error_out              : out inject_error_t_v(N_CHANNELS-1 downto 0);
    -- Common in signal
    reset_tx_pll_and_datapath_out : out std_logic;
    reset_rx_datapath_out         : out std_logic;
   -- Common out signals
    txMetadata_out                : out linkTxMetadata_t
    );
end links_cs_interface;


architecture Behavioral of links_cs_interface is

  signal txpolarity_i             : std_logic_vector(N_CHANNELS-1 downto 0);
  signal rxpolarity_i             : std_logic_vector(N_CHANNELS-1 downto 0);
  signal tx_usrrst_i              : std_logic_vector(N_CHANNELS-1 downto 0);
  signal tx_usrrst_b              : std_logic_vector(N_CHANNELS-1 downto 0);
  signal rx_usrrst_i              : std_logic_vector(N_CHANNELS-1 downto 0);
  signal rx_usrrst_b              : std_logic_vector(N_CHANNELS-1 downto 0);
  signal reset_counters_i         : std_logic_vector(N_CHANNELS-1 downto 0);
  signal rxprbscntreset_i         : std_logic_vector(N_CHANNELS-1 downto 0);
  signal rxprbserr_i              : std_logic_vector(N_CHANNELS-1 downto 0);
  signal rxprbslocked_i           : std_logic_vector(N_CHANNELS-1 downto 0);
  signal tx_init_done_i           : std_logic_vector(N_CHANNELS-1 downto 0);
  signal rx_init_done_i           : std_logic_vector(N_CHANNELS-1 downto 0);
  signal almost_full_i            : std_logic_vector(N_CHANNELS-1 downto 0);
  signal full_i                   : std_logic_vector(N_CHANNELS-1 downto 0);
  signal txprbsforceerr_i         : std_logic_vector(N_CHANNELS-1 downto 0);
  signal txprbsforceerr_i_synced  : std_logic_vector(N_CHANNELS-1 downto 0);
  signal txprbsforcerr_i_synced_d : std_logic_vector(N_CHANNELS-1 downto 0);
  signal txprbsforceerr_i_single  : std_logic_vector(N_CHANNELS-1 downto 0);
  signal rx_index_lock_lost_i     : std_logic_vector(N_CHANNELS-1 downto 0);
  signal link_status_i            : std_logic_vector(N_CHANNELS-1 downto 0);
  signal link_down_latched_i      : std_logic_vector(N_CHANNELS-1 downto 0);
  signal tx_idle_method_i         : std_logic_vector(N_CHANNELS-1 downto 0);
  signal disable_ICM_i            : std_logic_vector(N_CHANNELS-1 downto 0);
  signal board_id_i               : std_logic_vector(23 downto 0);
  signal txpd_i                   : std_logic;
  signal txpd_s                   : std_logic;
  signal rxpd_i                   : std_logic;
  signal loopback                 : type_vector_of_stdlogicvec_x3(N_CHANNELS-1 downto 0);
  signal rx_crc_error_cnt_i       : type_vector_of_stdlogicvec_x32(N_CHANNELS-1 downto 0);
  signal packet_cntr_i            : type_vector_of_stdlogicvec_x32(N_CHANNELS-1 downto 0);
  signal rxprbssel_i              : type_vector_of_stdlogicvec_x4(N_CHANNELS-1 downto 0);
  signal txprbssel_i              : type_vector_of_stdlogicvec_x4(N_CHANNELS-1 downto 0);
  signal hard_errors_i            : type_vector_of_stdlogicvec_x16(N_CHANNELS-1 downto 0);
  signal invalid_ctrl_i           : type_vector_of_stdlogicvec_x4(N_CHANNELS-1 downto 0);
  signal cwt_single_errors_i      : type_vector_of_stdlogicvec_x16(N_CHANNELS-1 downto 0);
  signal cwt_double_errors_i      : type_vector_of_stdlogicvec_x16(N_CHANNELS-1 downto 0);
  signal rx_index_lock_lost_cntr_i: type_vector_of_stdlogicvec_x16(N_CHANNELS-1 downto 0);
  signal wrong_index_cntr_i       : type_vector_of_stdlogicvec_x16(N_CHANNELS-1 downto 0);
  signal tm_period_i              : type_vector_of_stdlogicvec_x5(N_CHANNELS-1 downto 0);
  signal startOrLastHighnAndValidLow_i    : type_vector_of_stdlogicvec_x4(N_CHANNELS-1 downto 0);
  signal starOrLasttHighForMultiCycles_i  : type_vector_of_stdlogicvec_x4(N_CHANNELS-1 downto 0);
  signal startAndLastHighSimultaneously_i : type_vector_of_stdlogicvec_x4(N_CHANNELS-1 downto 0);
  signal NoLastBeforeStart_ValidInBoth_i  : type_vector_of_stdlogicvec_x4(N_CHANNELS-1 downto 0);
  signal LastAndNotStart_ValidInBoth_i    : type_vector_of_stdlogicvec_x4(N_CHANNELS-1 downto 0);
  signal wbuf_add_word_i    : type_vector_of_stdlogicvec_x9(N_CHANNELS-1 downto 0);
  signal rbuf_add_word_i    : type_vector_of_stdlogicvec_x9(N_CHANNELS-1 downto 0);
  signal buff_addr_diff     : type_vector_of_stdlogicvec_x9(N_CHANNELS-1 downto 0);
  signal txMetadata               : linkTxMetadata_t;
  signal rXStatusInfo               : linkStatusInfo_t_v(N_CHANNELS-1 downto 0);

  attribute ASYNC_REG                       : string;
  attribute ASYNC_REG of txMetadata_out     : signal is "TRUE";
  attribute ASYNC_REG of rXStatusInfo       : signal is "TRUE";
 
begin

  synchronizers_gen : for i in 0 to N_CHANNELS - 1 generate

    bit_synchronizer_disableICM_inst : entity work.emp_bit_synchronizer
      port map(
        clk_in => rxusrclk2_i(i),
        i_in   => disable_ICM_i(i),
        o_out  => disable_ICM_out(i)
        );
    bit_synchronizer_txIdlMethod_inst : entity work.emp_bit_synchronizer
      port map(
        clk_in => txusrclk2_i,
        i_in   => tx_idle_method_i(i),
        o_out  => tx_idle_method_out(i)
        );
    bit_synchronizer_linkSt_inst : entity work.emp_bit_synchronizer
      port map(
        clk_in => stable_clk_in,
        i_in   => link_status_in(i),
        o_out  => link_status_i(i)
        );
    bit_synchronizer_linkDnLtc_inst : entity work.emp_bit_synchronizer
      port map(
        clk_in => stable_clk_in,
        i_in   => link_down_latched_in(i),
        o_out  => link_down_latched_i(i)
        );
    bit_synchronizer_indexLock_inst : entity work.emp_bit_synchronizer
      port map(
        clk_in => stable_clk_in,
        i_in   => linkStatusInfo_in(i).rx_index_lock_lost,
        o_out  => rx_index_lock_lost_i(i)
        );
    bit_synchronizer_txinitdone_inst : entity work.emp_bit_synchronizer
      port map(
        clk_in => stable_clk_in,
        i_in   => tx_init_done_in(i),
        o_out  => tx_init_done_i(i)
        );
    bit_synchronizer_rxinitdone_inst : entity work.emp_bit_synchronizer
      port map(
        clk_in => stable_clk_in,
        i_in   => rx_init_done_in(i),
        o_out  => rx_init_done_i(i)
        );
    bit_synchronizer_prbslock_inst : entity work.emp_bit_synchronizer
      port map(
        clk_in => stable_clk_in,
        i_in   => mgtControl_in.rxprbslocked_out(i),
        o_out  => rxprbslocked_i(i)
        );
    bit_synchronizer_prbserr_inst : entity work.emp_bit_synchronizer
      port map(
        clk_in => stable_clk_in,
        i_in   => mgtControl_in.rxprbserr_out(i),
        o_out  => rxprbserr_i(i)
        );
    bit_synchronizer_txprbsforceerr_inst : entity work.emp_bit_synchronizer
      port map(
        clk_in => txusrclk2_i,
        i_in   => txprbsforceerr_i(i),
        o_out  => txprbsforceerr_i_synced(i)
        );

    one_period_high : process (txusrclk2_i)
    begin
      if rising_edge(txusrclk2_i) then
        txprbsforcerr_i_synced_d(i) <= txprbsforceerr_i_synced(i);
        if (txprbsforceerr_i_single(i) = '1') then
          txprbsforceerr_i_single(i) <= '0';
        elsif (txprbsforceerr_i_synced(i) = '1' and txprbsforcerr_i_synced_d(i) = '0') then
          txprbsforceerr_i_single(i) <= '1';
        end if;
        mgtControl_out.txprbsforceerr_in(i) <= txprbsforceerr_i_single(i);
      end if;
    end process;

    bit_synchronizer_txpol_inst : entity work.emp_bit_synchronizer
      port map(
        clk_in => txusrclk2_i,
        i_in   => txpolarity_i(i),
        o_out  => mgtControl_out.txpolarity_in(i)
        );
    bit_synchronizer_rxpol_inst : entity work.emp_bit_synchronizer
      port map(
        clk_in => rxusrclk2_i(i),
        i_in   => rxpolarity_i(i),
        o_out  => mgtControl_out.rxpolarity_in(i)
        );
    bit_synchronizer_almostfull_inst : entity work.emp_bit_synchronizer
      port map(
        clk_in => stable_clk_in,
        i_in   => txCtrlStatus_in(i).almost_full,
        o_out  => almost_full_i(i)
        );
    bit_synchronizer_full_inst : entity work.emp_bit_synchronizer
      port map(
        clk_in => stable_clk_in,
        i_in   => txCtrlStatus_in(i).full,
        o_out  => full_i(i)
        );
    reset_synchronizer_txrst_inst : entity work.emp_reset_synchronizer
      port map(
        clk_in  => txusrclk2_i,
        rst_in  => tx_usrrst_b(i),
        rst_out => tx_usrrst_out(i)
        );

    reset_synchronizer_rxrst_inst : entity work.emp_reset_synchronizer
      port map(
        clk_in  => rxusrclk2_i(i),
        rst_in  => rx_usrrst_b(i),
        rst_out => rx_usrrst_out(i)
        );

    reset_synchronizer_rxprbsrst_inst : entity work.emp_reset_synchronizer
      port map(
        clk_in  => rxusrclk2_i(i),
        rst_in  => rxprbscntreset_i(i),
        rst_out => mgtControl_out.rxprbscntreset_in(i)
        );

    reset_synchronizer_rstcrc_inst : entity work.emp_reset_synchronizer
      port map(
        clk_in  => ttc_clk_in,
        rst_in  => reset_counters_i(i),
        rst_out => reset_counters_out(i)
        );

    synchronizers_9b_gen : for j in 0 to 8 generate


        bit_synchronizer_wbuff_inst : entity work.emp_bit_synchronizer
          port map(
            clk_in => stable_clk_in,
            i_in   => linkStatusInfo_in(i).wbuf_add_word_out(j),
            o_out  => wbuf_add_word_i(i)(j)
            );
        bit_synchronizer_rbuff_inst : entity work.emp_bit_synchronizer
          port map(
            clk_in => stable_clk_in,
            i_in   => linkStatusInfo_in(i).rbuf_add_word_out(j),
            o_out  => rbuf_add_word_i(i)(j)
            );
    end generate synchronizers_9b_gen;
   
--    synchronizers_16b_gen : for j in 0 to 15 generate

--      bit_synchronizer_hrderr_inst : entity work.emp_bit_synchronizer
--        port map(
--          clk_in => stable_clk_in,
--          i_in   => linkStatusInfo_in(i).hard_errors(j),
--          o_out  => hard_errors_i(i)(j)
--          );

--      bit_synchronizer_cwtSnglErr_inst : entity work.emp_bit_synchronizer
--        port map(
--          clk_in => stable_clk_in,
--          i_in   => linkStatusInfo_in(i).cwt_single_errors(j),
--          o_out  => cwt_single_errors_i(i)(j)
--          );
--      bit_synchronizer_cwtDbleErr_inst : entity work.emp_bit_synchronizer
--        port map(
--          clk_in => stable_clk_in,
--          i_in   => linkStatusInfo_in(i).cwt_double_errors(j),
--          o_out  => cwt_double_errors_i(i)(j)
--          );

--      bit_synchronizer_indexLockLost_inst : entity work.emp_bit_synchronizer
--        port map(
--          clk_in => stable_clk_in,
--          i_in   => linkStatusInfo_in(i).rx_index_lock_lost_cntr(j),
--          o_out  => rx_index_lock_lost_cntr_i(i)(j)
--          );
--      bit_synchronizer_wrongIndex_inst : entity work.emp_bit_synchronizer
--        port map(
--          clk_in => stable_clk_in,
--          i_in   => linkStatusInfo_in(i).wrong_index_cntr_out(j),
--          o_out  => wrong_index_cntr_i(i)(j)
--          );
--    end generate synchronizers_16b_gen;


    process(stable_clk_in)
    begin
        if rising_edge(stable_clk_in) then
            rXStatusInfo(i).crc_errors  <= linkStatusInfo_in(i).crc_errors;
            rXStatusInfo(i).packet_cntr <= linkStatusInfo_in(i).packet_cntr;
            rXStatusInfo(i).hard_errors <= linkStatusInfo_in(i).hard_errors;
            rXStatusInfo(i).cwt_single_errors <= linkStatusInfo_in(i).cwt_single_errors;
            rXStatusInfo(i).cwt_double_errors <= linkStatusInfo_in(i).cwt_double_errors;
            rXStatusInfo(i).rx_index_lock_lost_cntr <= linkStatusInfo_in(i).rx_index_lock_lost_cntr;
            rXStatusInfo(i).wrong_index_cntr_out <= linkStatusInfo_in(i).wrong_index_cntr_out;
        end if;
    end process;
    
--    synchronizers_32b_gen : for j in 0 to 31 generate

--      bit_synchronizer_crcerr_inst : entity work.emp_bit_synchronizer
--        port map(
--          clk_in => stable_clk_in,
--          i_in   => linkStatusInfo_in(i).crc_errors(j),
--          o_out  => rx_crc_error_cnt_i(i)(j)
--          );
--      bit_synchronizer_crcchk_inst : entity work.emp_bit_synchronizer
--        port map(
--          clk_in => stable_clk_in,
--          i_in   => linkStatusInfo_in(i).packet_cntr(j),
--          o_out  => packet_cntr_i(i)(j)
--          );
--    end generate synchronizers_32b_gen;

    synchronizers_4b_gen : for j in 0 to 3 generate

      bit_synchronizer_txprbs_inst : entity work.emp_bit_synchronizer
        port map(
          clk_in => txusrclk2_i,
          i_in   => txprbssel_i(i)(j),
          o_out  => mgtControl_out.txprbssel_in(i)(j)
          );
      bit_synchronizer_rxprbs_inst : entity work.emp_bit_synchronizer
        port map(
          clk_in => rxusrclk2_i(i),
          i_in   => rxprbssel_i(i)(j),
          o_out  => mgtControl_out.rxprbssel_in(i)(j)
          );

      bit_synchronizer_startOrLastHighnAndValidLow_inst : entity work.emp_bit_synchronizer
        port map(
          clk_in => stable_clk_in,
          i_in   => txCtrlStatus_in(i).invalid_tx_comb_cntr.startOrLastHighnAndValidLow(j),
          o_out  => startOrLastHighnAndValidLow_i(i)(j)
          );
      bit_synchronizer_starOrLasttHighForMultiCycles_inst : entity work.emp_bit_synchronizer
        port map(
          clk_in => stable_clk_in,
          i_in   => txCtrlStatus_in(i).invalid_tx_comb_cntr.starOrLasttHighForMultiCycles(j),
          o_out  => starOrLasttHighForMultiCycles_i(i)(j)
          );
      bit_synchronizer_startAndLastHighSimultaneously_inst : entity work.emp_bit_synchronizer
        port map(
          clk_in => stable_clk_in,
          i_in   => txCtrlStatus_in(i).invalid_tx_comb_cntr.startAndLastHighSimultaneously(j),
          o_out  => startAndLastHighSimultaneously_i(i)(j)
          );
      bit_synchronizer_NoLastBeforeStart_inst : entity work.emp_bit_synchronizer
        port map(
          clk_in => stable_clk_in,
          i_in   => txCtrlStatus_in(i).invalid_tx_comb_cntr.NoLastBeforeStart_ValidInBoth(j),
          o_out  => NoLastBeforeStart_ValidInBoth_i(i)(j)
          );
      bit_synchronizer_LastAndNotStart_inst : entity work.emp_bit_synchronizer
        port map(
          clk_in => stable_clk_in,
          i_in   => txCtrlStatus_in(i).invalid_tx_comb_cntr.LastAndNotStart_ValidInBoth(j),
          o_out  => LastAndNotStart_ValidInBoth_i(i)(j)
          );

    end generate synchronizers_4b_gen;

  buff_addr_diff(i) <= wbuf_add_word_i(i) - rbuf_add_word_i(i);

  end generate;

  -- Loop over all channels
  reg_chan_gen : for i in 0 to N_CHANNELS - 1 generate
    ----------------------------------------------------------------------------- 
    -- ReadOnly Regs.
    -----------------------------------------------------------------------------
    -- Link ID 0 
    chan_ro_regs_out(i)(0) <= x"000" &                                          -- mask 0xFFF00000 -- Reserved
                              rxMetadata_in(i).crate_id &                       -- mask 0x000FF000
                              rxMetadata_in(i).slot_id &                        -- mask 0x00000F00
                              rxMetadata_in(i).channel_id;                      -- mask 0x000000FF
                              
    -- Link ID 1 
    chan_ro_regs_out(i)(1) <= rxMetadata_in(i).link_id_1;                       -- Copying full 32-bit word from link, to accommodate both formats (0 & 1)

    -- Link Status 
    chan_ro_regs_out(i)(2) <= startOrLastHighnAndValidLow_i(i) &                -- mask 0xF0000000
                              starOrLasttHighForMultiCycles_i(i) &              -- mask 0x0F000000
                              startAndLastHighSimultaneously_i(i) &             -- mask 0x00F00000
                              NoLastBeforeStart_ValidInBoth_i(i) &              -- mask 0x000F0000
                              LastAndNotStart_ValidInBoth_i(i) &                -- mask 0x0000F000
                              "00" &                                            -- mask 0x00000C00
                              rxprbserr_i(i) &                                  -- mask 0x00000200
                              rxprbslocked_i(i) &                               -- mask 0x00000100
                              mgtControl_in.rxcdrlock_out(i) &                  -- mask 0x00000080
                              almost_full_i(i) &                                -- mask 0x00000040
                              full_i(i) &                                       -- mask 0x00000020
                              link_status_i(i) &                                -- mask 0x00000010
                              link_down_latched_i(i) &                          -- mask 0x00000008
                              tx_init_done_i(i) &                               -- mask 0x00000004
                              rx_init_done_i(i) &                               -- mask 0x00000002
                              rx_index_lock_lost_i(i);                          -- mask 0x00000001
    
    chan_ro_regs_out(i)(3) <= rXStatusInfo(i).crc_errors; 
    
    chan_ro_regs_out(i)(4) <= rXStatusInfo(i).packet_cntr; 
    
    -- Packet and Error counters
    chan_ro_regs_out(i)(5) <= rXStatusInfo(i).cwt_double_errors &               -- mask 0xFFFF0000
                              rXStatusInfo(i).cwt_single_errors;                -- mask 0x0000FFFF
    
    -- Packet and Error counters
    chan_ro_regs_out(i)(6) <= rXStatusInfo(i).rx_index_lock_lost_cntr &         -- mask 0xFFFF0000 
                              rXStatusInfo(i).hard_errors;                      -- mask 0x0000FFFF 
    
    -- Packet and Error counters
    chan_ro_regs_out(i)(7) <= x"0" & "000" &                                    -- mask 0xFE0000000
                              buff_addr_diff(i) &                               -- mask 0x01FF0000
                              rXStatusInfo(i).wrong_index_cntr_out;             -- mask 0x0000FFFF


    -----------------------------------------------------------------------------
    -- ReadWrite Regs. 
    -----------------------------------------------------------------------------
    mgtControl_out.loopback_in(i)     <= chan_rw_regs_in(i)(0)(2 downto 0);     -- mask 0x00000007
    reset_counters_i(i)               <= chan_rw_regs_in(i)(0)(3);              -- mask 0x00000008 
    txpolarity_i(i)                   <= chan_rw_regs_in(i)(0)(4);              -- mask 0x00000010
    rxpolarity_i(i)                   <= chan_rw_regs_in(i)(0)(5);              -- mask 0x00000020 
    tx_usrrst_i(i)                    <= chan_rw_regs_in(i)(0)(6);              -- mask 0x00000040 
    rx_usrrst_i(i)                    <= chan_rw_regs_in(i)(0)(7);              -- mask 0x00000080 
    align_marker_sel_out(i)           <= chan_rw_regs_in(i)(0)(8);              -- mask 0x00000100
    align_marker_dis_out(i)           <= chan_rw_regs_in(i)(0)(9);              -- mask 0x00000200
    reset_latched_out(i)              <= chan_rw_regs_in(i)(0)(10);             -- mask 0x00000400
    mgtControl_out.eyescanreset_in(i) <= chan_rw_regs_in(i)(0)(11);             -- mask 0x00000800
    txprbssel_i(i)                    <= chan_rw_regs_in(i)(0)(15 downto 12);   -- mask 0x0000F000
    rxprbssel_i(i)                    <= chan_rw_regs_in(i)(0)(19 downto 16);   -- mask 0x000F0000
    rxprbscntreset_i(i)               <= chan_rw_regs_in(i)(0)(20);             -- mask 0x00100000
    txprbsforceerr_i(i)               <= chan_rw_regs_in(i)(0)(21);             -- mask 0x00200000
    mgtControl_out.rxpmareset_in(i)   <= chan_rw_regs_in(i)(0)(22);             -- mask 0x00400000
    mgtControl_out.rxlpmen_in(i)      <= chan_rw_regs_in(i)(0)(23);             -- mask 0x00800000
    tx_idle_method_i(i)               <= chan_rw_regs_in(i)(0)(24);             -- mask 0x01000000
    disable_ICM_i(i)                  <= chan_rw_regs_in(i)(0)(25);             -- mask 0x02000000 -- Index Correction Mechanism

    mgtControl_out.txdiffctrl_in((i + 1) * MGT_DIFFCTRL_WIDTH - 1 downto i * MGT_DIFFCTRL_WIDTH)   <= chan_rw_regs_in(i)(1)(MGT_DIFFCTRL_WIDTH - 1 downto 0);  -- mask 0x0000001F
    mgtControl_out.txpostcursor_in(i * 5 + 4 downto i * 5) <= chan_rw_regs_in(i)(1)(9 downto 5);     -- mask 0x000003E0
    mgtControl_out.txprecursor_in(i * 5 + 4 downto i * 5)  <= chan_rw_regs_in(i)(1)(14 downto 10);   -- mask 0x00007C00

    txMetadata.packet_interval(i)     <= chan_rw_regs_in(i)(2)(11 downto 0);     -- mask 0x00000FFF
    txMetadata.packet_size(i)         <= chan_rw_regs_in(i)(2)(23 downto 12);    -- mask 0x00FFF000
    
    inject_error_out(i).header_1bit   <= chan_rw_regs_in(i)(3)(0);               -- mask 0x00000001
    inject_error_out(i).header_2bit   <= chan_rw_regs_in(i)(3)(1);               -- mask 0x00000002
    inject_error_out(i).CC_1bit       <= chan_rw_regs_in(i)(3)(2);               -- mask 0x00000004
    inject_error_out(i).CC_2bit       <= chan_rw_regs_in(i)(3)(3);               -- mask 0x00000008
    inject_error_out(i).CRC_1bit      <= chan_rw_regs_in(i)(3)(4);               -- mask 0x00000010
    inject_error_out(i).index_1bit    <= chan_rw_regs_in(i)(3)(5);               -- mask 0x00000020
   
    tx_usrrst_b(i) <= tx_usrrst_i(i) when txprbssel_i(i) = x"0" else '1';
    rx_usrrst_b(i) <= rx_usrrst_i(i) when rxprbssel_i(i) = x"0" else '1';
    
  end generate;


  -----------------------------------------------------------------------------
  ---- COMMON Register Access:
  -----------------------------------------------------------------------------
  -- COMMON: ReadOnly Regs
  common_ro_regs_out(0)(0)           <= mgtControl_in.qpll0lock_out;  -- mask 0x00000001
  common_ro_regs_out(0)(31 downto 1) <= (others => '0');  -- mask 0xFFFFFFFE

  -- COMMON: ReadWrite Regs
  reset_tx_pll_and_datapath_out      <= common_rw_regs_in(0)(0);                 -- mask 0x00000001 - async
  reset_rx_datapath_out              <= common_rw_regs_in(0)(1);                 -- mask 0x00000002 - async
  -- Power Down ports are active hi
  -- ipbus reg is Low by defua
  -- using NOT gate to set MGT on Power Down by defau
  mgtControl_out.qpll0pd_in(0)       <= not common_rw_regs_in(0)(2);             -- mask 0x00000004 - async
  rxpd_i                             <= not common_rw_regs_in(0)(3);             -- mask 0x00000008 - async
  txpd_i                             <= not common_rw_regs_in(0)(4);             -- mask 0x00000010 - 
  txMetadata.crate_id                <= common_rw_regs_in(0)(12 downto 5);       -- mask 0x00001FE0
  txMetadata.slot_id                 <= common_rw_regs_in(0)(16 downto 13);      -- mask 0x0001E000

  process(txusrclk2_i)
  begin
    if rising_edge(txusrclk2_i) then
        txMetadata_out <= txMetadata;
    end if;
  end process;

  -- txpd is sync to txusrclk2
  bit_synchronizer_txpd_inst : entity work.emp_bit_synchronizer
    port map(
      clk_in => txusrclk2_i,
      i_in   => txpd_i,
      o_out  => txpd_s
      );

  -- connect tx and rx pd signals together
  txrxPd : for i in 0 to 7 generate
      mgtControl_out.txpd_in(i) <= txpd_s;
      mgtControl_out.rxpd_in(i) <= rxpd_i;
  end generate;
  
  -- TXELECIDLE must be strapped to TXPD[1] and TXPD[0]
  txelecidle : for i in 0 to 3 generate
      mgtControl_out.txelecidle_in(i) <= txpd_s;
  end generate;


end Behavioral;
