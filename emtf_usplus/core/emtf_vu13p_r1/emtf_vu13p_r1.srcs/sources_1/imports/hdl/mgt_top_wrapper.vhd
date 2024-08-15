-- =====================================================================================================================
-- Top wrapper of MGT IP cores and logic - kadamidi - 2020
-- =====================================================================================================================

library IEEE;
use IEEE.STD_LOGIC_1164.all;

use work.drp_decl.all;
use work.package_links.all;

entity mgt_top_wrapper is
  generic ( 
            MGT_I_KIND : integer;
            MGT_O_KIND : integer );
  port (
    mgtrefclk                    : in  std_logic;
    clk_freerun                  : in  std_logic;
    gtrxp_in                     : in  std_logic_vector(N_CHANNELS-1 downto 0);
    gtrxn_in                     : in  std_logic_vector(N_CHANNELS-1 downto 0);
    reset_all_in                 : in  std_logic;
    reset_tx_pll_and_datapath_in : in  std_logic;
    reset_rx_datapath_in         : in  std_logic;
    userdata_tx_in               : in  type_vector_of_stdlogicvec_x64(N_CHANNELS-1 downto 0);
    txheader_in                  : in  type_vector_of_stdlogicvec_x6(N_CHANNELS-1 downto 0);
    txsequence_in                : in  type_vector_of_stdlogicvec_x7(N_CHANNELS-1 downto 0);
    rxgearboxslip_in             : in  std_logic_vector(N_CHANNELS-1 downto 0) := (others=>'0');
    drp_in_com                   : in  drp_wbus;
    drp_in                       : in  drp_wbus_array(N_CHANNELS - 1 downto 0);
    mgtControl_in                : in  mgtControl_i_t;
    gttxn_out                    : out std_logic_vector(N_CHANNELS-1 downto 0);
    gttxp_out                    : out std_logic_vector(N_CHANNELS-1 downto 0);
    rx_usrclk2_out               : out std_logic_vector(N_CHANNELS-1 downto 0);
    tx_usrclk2_out               : out std_logic;
    userdata_rx_out              : out type_vector_of_stdlogicvec_x64(N_CHANNELS-1 downto 0);
    rxheader_out                 : out type_vector_of_stdlogicvec_x3(N_CHANNELS-1 downto 0);
    rxdatavalid_out              : out type_vector_of_stdlogicvec_x2(N_CHANNELS-1 downto 0);
    tx_init_done_out             : out std_logic_vector(N_CHANNELS-1 downto 0);
    rx_init_done_out             : out std_logic_vector(N_CHANNELS-1 downto 0);
    drp_out_com                  : out drp_rbus;
    drp_out                      : out drp_rbus_array(N_CHANNELS - 1 downto 0);
    mgtControl_out               : out mgtControl_o_t
    );

end mgt_top_wrapper;


architecture RTL of mgt_top_wrapper is

  function MgtKind( MGT_I_KIND , MGT_O_KIND : integer ) RETURN INTEGER IS
  begin
    if MGT_I_KIND /= NOMGT then 
      return MGT_I_KIND;
    else 
      return MGT_O_KIND;
    end if;
  end function MgtKind;


 CONSTANT TX_ENABLE : BOOLEAN := ( MGT_O_KIND /= NOMGT );
 CONSTANT RX_ENABLE : BOOLEAN := ( MGT_I_KIND /= NOMGT );

 CONSTANT MGT_KIND : INTEGER := MgtKind( MGT_I_KIND , MGT_O_KIND );


begin

-- GTH at 16 G
--===================================================================================================================
  gth16g_inst : if MGT_KIND = GTH16G generate

    example_wrapper_inst : entity work.mgt_gth16g_core
      generic map(
        TX_ENABLE  => TX_ENABLE,
        RX_ENABLE  => RX_ENABLE)
      port map(
        mgtrefclk                    => mgtrefclk,
        clk_freerun                  => clk_freerun,
        gtrxp_in                     => gtrxp_in,
        gtrxn_in                     => gtrxn_in,
        reset_all_in                 => reset_all_in,
        reset_tx_pll_and_datapath_in => reset_tx_pll_and_datapath_in,
        userdata_tx_in               => userdata_tx_in,
        txheader_in                  => txheader_in,
        txsequence_in                => txsequence_in,
        reset_rx_datapath_in         => reset_rx_datapath_in,
        rxgearboxslip_in             => rxgearboxslip_in,
        drp_in_com                   => drp_in_com,
        drp_in                       => drp_in,
        mgtControl_in                => mgtControl_in,
        gttxn_out                    => gttxn_out,
        gttxp_out                    => gttxp_out,
        rx_usrclk2_out               => rx_usrclk2_out,
        tx_usrclk2_out               => tx_usrclk2_out,
        userdata_rx_out              => userdata_rx_out,
        rxheader_out                 => rxheader_out,
        rxdatavalid_out              => rxdatavalid_out,
        tx_init_done_out             => tx_init_done_out,
        rx_init_done_out             => rx_init_done_out,
        drp_out_com                  => drp_out_com,
        drp_out                      => drp_out,
        mgtControl_out               => mgtControl_out
        );

  end generate gth16g_inst;
--===================================================================================================================


-- GTY at 16 G
--===================================================================================================================
  gty16g_inst : if MGT_KIND = GTY16G generate

    example_wrapper_inst : entity work.mgt_gty16g_core
      generic map(
        TX_ENABLE  => TX_ENABLE,
        RX_ENABLE  => RX_ENABLE)
      port map(
        mgtrefclk                    => mgtrefclk,
        clk_freerun                  => clk_freerun,
        gtrxp_in                     => gtrxp_in,
        gtrxn_in                     => gtrxn_in,
        reset_all_in                 => reset_all_in,
        reset_tx_pll_and_datapath_in => reset_tx_pll_and_datapath_in,
        userdata_tx_in               => userdata_tx_in,
        txheader_in                  => txheader_in,
        txsequence_in                => txsequence_in,
        reset_rx_datapath_in         => reset_rx_datapath_in,
        rxgearboxslip_in             => rxgearboxslip_in,
        drp_in_com                   => drp_in_com,
        drp_in                       => drp_in,
        mgtControl_in                => mgtControl_in,
        gttxn_out                    => gttxn_out,
        gttxp_out                    => gttxp_out,
        rx_usrclk2_out               => rx_usrclk2_out,
        tx_usrclk2_out               => tx_usrclk2_out,
        userdata_rx_out              => userdata_rx_out,
        rxheader_out                 => rxheader_out,
        rxdatavalid_out              => rxdatavalid_out,
        tx_init_done_out             => tx_init_done_out,
        rx_init_done_out             => rx_init_done_out,
        drp_out_com                  => drp_out_com,
        drp_out                      => drp_out,
        mgtControl_out               => mgtControl_out
        );

  end generate gty16g_inst;
--===================================================================================================================


-- GTY at 25 G
--===================================================================================================================
  gty25g_inst : if MGT_KIND = GTY25G generate

    example_wrapper_inst : entity work.mgt_gty25g_core
      generic map(
        TX_ENABLE  => TX_ENABLE,
        RX_ENABLE  => RX_ENABLE)
      port map(
        mgtrefclk                    => mgtrefclk,
        clk_freerun                  => clk_freerun,
        gtrxp_in                     => gtrxp_in,
        gtrxn_in                     => gtrxn_in,
        reset_all_in                 => reset_all_in,
        reset_tx_pll_and_datapath_in => reset_tx_pll_and_datapath_in,
        userdata_tx_in               => userdata_tx_in,
        txheader_in                  => txheader_in,
        txsequence_in                => txsequence_in,
        reset_rx_datapath_in         => reset_rx_datapath_in,
        rxgearboxslip_in             => rxgearboxslip_in,
        drp_in_com                   => drp_in_com,
        drp_in                       => drp_in,
        mgtControl_in                => mgtControl_in,
        gttxn_out                    => gttxn_out,
        gttxp_out                    => gttxp_out,
        rx_usrclk2_out               => rx_usrclk2_out,
        tx_usrclk2_out               => tx_usrclk2_out,
        userdata_rx_out              => userdata_rx_out,
        rxheader_out                 => rxheader_out,
        rxdatavalid_out              => rxdatavalid_out,
        tx_init_done_out             => tx_init_done_out,
        rx_init_done_out             => rx_init_done_out,
        drp_out_com                  => drp_out_com,
        drp_out                      => drp_out,
        mgtControl_out               => mgtControl_out
        );

  end generate gty25g_inst;
--===================================================================================================================

end RTL;
