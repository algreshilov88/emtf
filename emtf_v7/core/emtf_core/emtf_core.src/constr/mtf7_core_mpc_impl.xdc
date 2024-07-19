create_clock -period 1.563 -name sync_ref_clk_p0 [get_ports {sync_ref_clk_p[0]}]
create_clock -period 1.563 -name sync_ref_clk_p1 [get_ports {sync_ref_clk_p[1]}]
create_clock -period 1.563 -name sync_ref_clk_p2 [get_ports {sync_ref_clk_p[2]}]
create_clock -period 1.563 -name sync_ref_clk_p3 [get_ports {sync_ref_clk_p[3]}]
create_clock -period 1.563 -name sync_ref_clk_p4 [get_ports {sync_ref_clk_p[4]}]
create_clock -period 1.563 -name sync_ref_clk_p5 [get_ports {sync_ref_clk_p[5]}]
create_clock -period 1.563 -name sync_ref_clk_p6 [get_ports {sync_ref_clk_p[6]}]
create_clock -period 1.563 -name sync_ref_clk_p7 [get_ports {sync_ref_clk_p[7]}]
create_clock -period 8.000 [get_ports async_ref_clk_p[*]]

# create_generated_clock -name clk_250mhz_x0y31 [get_pins mpc_gen[1].mpc/serial.rx[7].gc/gt_usrclk_source/txoutclk_bufg0_i/O]
create_clock -period 4.000 -name clk_250mhz_x0y31 [get_pins {mpc_gen[1].mpc/serial.rx[7].gc/mtf7_combo_link_init_i/mtf7_combo_link_i/gt0_mtf7_combo_link_i/gthe2_i/TXOUTCLK}]

set_false_path -from [get_clocks clk_250mhz_x0y31] -to [get_clocks CLK_OUT2_usrclk_mmcm]
set_false_path -from [get_clocks CLK_OUT2_usrclk_mmcm] -to [get_clocks clk_250mhz_x0y31]
set_false_path -from [get_clocks pcie_clk] -to [get_clocks clk_250mhz_x0y31]

# DRP Clock Constraint
#NET "drp_clk_in" TNM_NET = "drp_clk_in";
#TIMESPEC "TS_drp_clk_in" = PERIOD "drp_clk_in" 25.0;

# User Clock Constraints

#create_clock -name gt0_txusrclk_i -period 6.25  [get_pins -hier -filter {name=~*mpc_gen[*].mpc*serial.rx[*].g*gt0_txusrclk_i}]
#create_clock -name gt0_rxusrclk_i -period 6.252 [get_pins -hier -filter {name=~*gtwizard_0_support_i*gtwizard_0_init_i/gt0_rxoutclk_out}]

####################### GT reference clock constraints #######################


################################# mgt wrapper constraints #####################

# all clocks

set_property -dict {LOC BB8 } [get_ports {sync_ref_clk_p[0]}]; # 110
set_property -dict {LOC AH8 } [get_ports {sync_ref_clk_p[1]}]; # 113
set_property -dict {LOC R10 } [get_ports {sync_ref_clk_p[2]}]; # 116
set_property -dict {LOC G10 } [get_ports {sync_ref_clk_p[3]}]; # 118
set_property -dict {LOC AT37} [get_ports {sync_ref_clk_p[4]}]; # 211
set_property -dict {LOC AH37} [get_ports {sync_ref_clk_p[5]}]; # 213
set_property -dict {LOC R35 } [get_ports {sync_ref_clk_p[6]}]; # 216
set_property -dict {LOC G35 } [get_ports {sync_ref_clk_p[7]}]; # 218

#set_property -dict {LOC E35} [get_ports async_ref_clk_p]

set_property -dict {LOC AR10} [get_ports {async_ref_clk_p[0]}]; # 111
set_property -dict {LOC AF8 } [get_ports {async_ref_clk_p[1]}]; # 113
set_property -dict {LOC N10 } [get_ports {async_ref_clk_p[2]}]; # 116
set_property -dict {LOC E10 } [get_ports {async_ref_clk_p[3]}]; # 118
set_property -dict {LOC AR35} [get_ports {async_ref_clk_p[4]}]; # 211
set_property -dict {LOC AF37} [get_ports {async_ref_clk_p[5]}]; # 213
set_property -dict {LOC N35 } [get_ports {async_ref_clk_p[6]}]; # 216
set_property -dict {LOC E35 } [get_ports {async_ref_clk_p[7]}]; # 218

# MPC RX locations
set_property -dict {LOC GTHE2_CHANNEL_X1Y39} [get_cells {mpc_gen[0].mpc/serial.rx[0].g/single_rx_tx_init_i/single_rx_tx_i/gt0_single_rx_tx_i/gthe2_i}]
set_property -dict {LOC GTHE2_CHANNEL_X1Y37} [get_cells {mpc_gen[0].mpc/serial.rx[1].g/single_rx_tx_init_i/single_rx_tx_i/gt0_single_rx_tx_i/gthe2_i}]
set_property -dict {LOC GTHE2_CHANNEL_X0Y39} [get_cells {mpc_gen[0].mpc/serial.rx[2].g/single_rx_tx_init_i/single_rx_tx_i/gt0_single_rx_tx_i/gthe2_i}]
set_property -dict {LOC GTHE2_CHANNEL_X0Y38} [get_cells {mpc_gen[0].mpc/serial.rx[3].g/single_rx_tx_init_i/single_rx_tx_i/gt0_single_rx_tx_i/gthe2_i}]
set_property -dict {LOC GTHE2_CHANNEL_X1Y38} [get_cells {mpc_gen[0].mpc/serial.rx[4].g/single_rx_tx_init_i/single_rx_tx_i/gt0_single_rx_tx_i/gthe2_i}]
set_property -dict {LOC GTHE2_CHANNEL_X1Y36} [get_cells {mpc_gen[0].mpc/serial.rx[5].g/single_rx_tx_init_i/single_rx_tx_i/gt0_single_rx_tx_i/gthe2_i}]
set_property -dict {LOC GTHE2_CHANNEL_X0Y37} [get_cells {mpc_gen[0].mpc/serial.rx[6].g/single_rx_tx_init_i/single_rx_tx_i/gt0_single_rx_tx_i/gthe2_i}]
set_property -dict {LOC GTHE2_CHANNEL_X0Y35} [get_cells {mpc_gen[0].mpc/serial.rx[7].g/single_rx_tx_init_i/single_rx_tx_i/gt0_single_rx_tx_i/gthe2_i}]

set_property -dict {LOC GTHE2_CHANNEL_X1Y35} [get_cells {mpc_gen[1].mpc/serial.rx[0].g/single_rx_tx_init_i/single_rx_tx_i/gt0_single_rx_tx_i/gthe2_i}]
set_property -dict {LOC GTHE2_CHANNEL_X1Y34} [get_cells {mpc_gen[1].mpc/serial.rx[1].g/single_rx_tx_init_i/single_rx_tx_i/gt0_single_rx_tx_i/gthe2_i}]
set_property -dict {LOC GTHE2_CHANNEL_X0Y36} [get_cells {mpc_gen[1].mpc/serial.rx[2].g/single_rx_tx_init_i/single_rx_tx_i/gt0_single_rx_tx_i/gthe2_i}]
set_property -dict {LOC GTHE2_CHANNEL_X0Y33} [get_cells {mpc_gen[1].mpc/serial.rx[3].g/single_rx_tx_init_i/single_rx_tx_i/gt0_single_rx_tx_i/gthe2_i}]
set_property -dict {LOC GTHE2_CHANNEL_X1Y33} [get_cells {mpc_gen[1].mpc/serial.rx[4].g/single_rx_tx_init_i/single_rx_tx_i/gt0_single_rx_tx_i/gthe2_i}]
set_property -dict {LOC GTHE2_CHANNEL_X1Y32} [get_cells {mpc_gen[1].mpc/serial.rx[5].g/single_rx_tx_init_i/single_rx_tx_i/gt0_single_rx_tx_i/gthe2_i}]
set_property -dict {LOC GTHE2_CHANNEL_X0Y34} [get_cells {mpc_gen[1].mpc/serial.rx[6].g/single_rx_tx_init_i/single_rx_tx_i/gt0_single_rx_tx_i/gthe2_i}]
# set_property -dict "LOC GTHE2_CHANNEL_X0Y31" [get_cells  mpc_gen[1].mpc/serial.rx[7].g/single_rx_tx_init_i/single_rx_tx_i/gt0_single_rx_tx_i/gthe2_i ];
set_property -dict {LOC GTHE2_CHANNEL_X0Y31} [get_cells {mpc_gen[1].mpc/serial.rx[7].gc/mtf7_combo_link_init_i/mtf7_combo_link_i/gt0_mtf7_combo_link_i/gthe2_i}]

set_property -dict {LOC GTHE2_CHANNEL_X1Y31} [get_cells {mpc_gen[2].mpc/serial.rx[0].g/single_rx_tx_init_i/single_rx_tx_i/gt0_single_rx_tx_i/gthe2_i}]
set_property -dict {LOC GTHE2_CHANNEL_X1Y30} [get_cells {mpc_gen[2].mpc/serial.rx[1].g/single_rx_tx_init_i/single_rx_tx_i/gt0_single_rx_tx_i/gthe2_i}]
set_property -dict {LOC GTHE2_CHANNEL_X0Y32} [get_cells {mpc_gen[2].mpc/serial.rx[2].g/single_rx_tx_init_i/single_rx_tx_i/gt0_single_rx_tx_i/gthe2_i}]
set_property -dict {LOC GTHE2_CHANNEL_X0Y29} [get_cells {mpc_gen[2].mpc/serial.rx[3].g/single_rx_tx_init_i/single_rx_tx_i/gt0_single_rx_tx_i/gthe2_i}]
set_property -dict {LOC GTHE2_CHANNEL_X1Y29} [get_cells {mpc_gen[2].mpc/serial.rx[4].g/single_rx_tx_init_i/single_rx_tx_i/gt0_single_rx_tx_i/gthe2_i}]
set_property -dict {LOC GTHE2_CHANNEL_X1Y28} [get_cells {mpc_gen[2].mpc/serial.rx[5].g/single_rx_tx_init_i/single_rx_tx_i/gt0_single_rx_tx_i/gthe2_i}]
set_property -dict {LOC GTHE2_CHANNEL_X0Y30} [get_cells {mpc_gen[2].mpc/serial.rx[6].g/single_rx_tx_init_i/single_rx_tx_i/gt0_single_rx_tx_i/gthe2_i}]
set_property -dict {LOC GTHE2_CHANNEL_X0Y27} [get_cells {mpc_gen[2].mpc/serial.rx[7].g/single_rx_tx_init_i/single_rx_tx_i/gt0_single_rx_tx_i/gthe2_i}]

set_property -dict {LOC GTHE2_CHANNEL_X1Y27} [get_cells {mpc_gen[3].mpc/serial.rx[0].g/single_rx_tx_init_i/single_rx_tx_i/gt0_single_rx_tx_i/gthe2_i}]
set_property -dict {LOC GTHE2_CHANNEL_X1Y26} [get_cells {mpc_gen[3].mpc/serial.rx[1].g/single_rx_tx_init_i/single_rx_tx_i/gt0_single_rx_tx_i/gthe2_i}]
set_property -dict {LOC GTHE2_CHANNEL_X0Y28} [get_cells {mpc_gen[3].mpc/serial.rx[2].g/single_rx_tx_init_i/single_rx_tx_i/gt0_single_rx_tx_i/gthe2_i}]
set_property -dict {LOC GTHE2_CHANNEL_X0Y25} [get_cells {mpc_gen[3].mpc/serial.rx[3].g/single_rx_tx_init_i/single_rx_tx_i/gt0_single_rx_tx_i/gthe2_i}]
set_property -dict {LOC GTHE2_CHANNEL_X1Y25} [get_cells {mpc_gen[3].mpc/serial.rx[4].g/single_rx_tx_init_i/single_rx_tx_i/gt0_single_rx_tx_i/gthe2_i}]
set_property -dict {LOC GTHE2_CHANNEL_X1Y24} [get_cells {mpc_gen[3].mpc/serial.rx[5].g/single_rx_tx_init_i/single_rx_tx_i/gt0_single_rx_tx_i/gthe2_i}]
set_property -dict {LOC GTHE2_CHANNEL_X0Y26} [get_cells {mpc_gen[3].mpc/serial.rx[6].g/single_rx_tx_init_i/single_rx_tx_i/gt0_single_rx_tx_i/gthe2_i}]
set_property -dict {LOC GTHE2_CHANNEL_X0Y23} [get_cells {mpc_gen[3].mpc/serial.rx[7].g/single_rx_tx_init_i/single_rx_tx_i/gt0_single_rx_tx_i/gthe2_i}]

set_property -dict {LOC GTHE2_CHANNEL_X1Y23} [get_cells {mpc_gen[4].mpc/serial.rx[0].g/single_rx_tx_init_i/single_rx_tx_i/gt0_single_rx_tx_i/gthe2_i}]
set_property -dict {LOC GTHE2_CHANNEL_X1Y22} [get_cells {mpc_gen[4].mpc/serial.rx[1].g/single_rx_tx_init_i/single_rx_tx_i/gt0_single_rx_tx_i/gthe2_i}]
set_property -dict {LOC GTHE2_CHANNEL_X0Y24} [get_cells {mpc_gen[4].mpc/serial.rx[2].g/single_rx_tx_init_i/single_rx_tx_i/gt0_single_rx_tx_i/gthe2_i}]
set_property -dict {LOC GTHE2_CHANNEL_X0Y21} [get_cells {mpc_gen[4].mpc/serial.rx[3].g/single_rx_tx_init_i/single_rx_tx_i/gt0_single_rx_tx_i/gthe2_i}]
set_property -dict {LOC GTHE2_CHANNEL_X1Y21} [get_cells {mpc_gen[4].mpc/serial.rx[4].g/single_rx_tx_init_i/single_rx_tx_i/gt0_single_rx_tx_i/gthe2_i}]
set_property -dict {LOC GTHE2_CHANNEL_X1Y20} [get_cells {mpc_gen[4].mpc/serial.rx[5].g/single_rx_tx_init_i/single_rx_tx_i/gt0_single_rx_tx_i/gthe2_i}]
set_property -dict {LOC GTHE2_CHANNEL_X0Y22} [get_cells {mpc_gen[4].mpc/serial.rx[6].g/single_rx_tx_init_i/single_rx_tx_i/gt0_single_rx_tx_i/gthe2_i}]
set_property -dict {LOC GTHE2_CHANNEL_X0Y19} [get_cells {mpc_gen[4].mpc/serial.rx[7].g/single_rx_tx_init_i/single_rx_tx_i/gt0_single_rx_tx_i/gthe2_i}]

set_property -dict {LOC GTHE2_CHANNEL_X1Y14} [get_cells {mpcn/serial.rx[0].g/single_rx_tx_init_i/single_rx_tx_i/gt0_single_rx_tx_i/gthe2_i}]
set_property -dict {LOC GTHE2_CHANNEL_X1Y15} [get_cells {mpcn/serial.rx[1].g/single_rx_tx_init_i/single_rx_tx_i/gt0_single_rx_tx_i/gthe2_i}]
set_property -dict {LOC GTHE2_CHANNEL_X0Y14} [get_cells {mpcn/serial.rx[2].g/single_rx_tx_init_i/single_rx_tx_i/gt0_single_rx_tx_i/gthe2_i}]
set_property -dict {LOC GTHE2_CHANNEL_X0Y15} [get_cells {mpcn/serial.rx[3].g/single_rx_tx_init_i/single_rx_tx_i/gt0_single_rx_tx_i/gthe2_i}]
set_property -dict {LOC GTHE2_CHANNEL_X1Y12} [get_cells {mpcn/serial.rx[4].g/single_rx_tx_init_i/single_rx_tx_i/gt0_single_rx_tx_i/gthe2_i}]
set_property -dict {LOC GTHE2_CHANNEL_X1Y13} [get_cells {mpcn/serial.rx[5].g/single_rx_tx_init_i/single_rx_tx_i/gt0_single_rx_tx_i/gthe2_i}]
set_property -dict {LOC GTHE2_CHANNEL_X0Y13} [get_cells {mpcn/serial.rx[6].g/single_rx_tx_init_i/single_rx_tx_i/gt0_single_rx_tx_i/gthe2_i}]
set_property -dict {LOC GTHE2_CHANNEL_X0Y12} [get_cells {mpcn/serial.rx[7].g/single_rx_tx_init_i/single_rx_tx_i/gt0_single_rx_tx_i/gthe2_i}]
set_property -dict {LOC GTHE2_CHANNEL_X1Y10} [get_cells {mpcn/serial.rx[8].g/single_rx_tx_init_i/single_rx_tx_i/gt0_single_rx_tx_i/gthe2_i}]

# CPPF RX locations
set_property LOC GTHE2_CHANNEL_X0Y20 [get_cells cppfl/ql[0].link_10g/cppf_link_10g_support_i/cppf_link_10g_init_i/inst/cppf_link_10g_i/gt0_cppf_link_10g_i/gthe2_i]
set_property LOC GTHE2_CHANNEL_X0Y17 [get_cells cppfl/ql[1].link_10g/cppf_link_10g_support_i/cppf_link_10g_init_i/inst/cppf_link_10g_i/gt0_cppf_link_10g_i/gthe2_i]
set_property LOC GTHE2_CHANNEL_X0Y18 [get_cells cppfl/ql[2].link_10g/cppf_link_10g_support_i/cppf_link_10g_init_i/inst/cppf_link_10g_i/gt0_cppf_link_10g_i/gthe2_i]
set_property LOC GTHE2_CHANNEL_X1Y16 [get_cells cppfl/ql[3].link_10g/cppf_link_10g_support_i/cppf_link_10g_init_i/inst/cppf_link_10g_i/gt0_cppf_link_10g_i/gthe2_i]
set_property LOC GTHE2_CHANNEL_X1Y17 [get_cells cppfl/ql[4].link_10g/cppf_link_10g_support_i/cppf_link_10g_init_i/inst/cppf_link_10g_i/gt0_cppf_link_10g_i/gthe2_i]
set_property LOC GTHE2_CHANNEL_X1Y18 [get_cells cppfl/ql[5].link_10g/cppf_link_10g_support_i/cppf_link_10g_init_i/inst/cppf_link_10g_i/gt0_cppf_link_10g_i/gthe2_i]
set_property LOC GTHE2_CHANNEL_X1Y19 [get_cells cppfl/ql[6].link_10g/cppf_link_10g_support_i/cppf_link_10g_init_i/inst/cppf_link_10g_i/gt0_cppf_link_10g_i/gthe2_i]
