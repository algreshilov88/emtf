create_clock -period 8.000 -name pcie_clk [get_ports pcie_clk]

create_clock -period 8.000 -name ext_clk_in [get_ports ext_clk_in]

create_clock -period 24.000 -name clk40_in_p [get_ports clk40_in_p]
create_clock -period 24.000 -name clk40_in [get_ports clk40_in]

set_property IOSTANDARD LVCMOS12 [get_ports pcie_clk]

# must go to clock pin on core FPGA
set_property -dict {IOSTANDARD LVCMOS12 DRIVE 8 SLEW FAST} [get_ports ext_clk_out]

# must be a clock pin
set_property IOSTANDARD LVCMOS12 [get_ports ext_clk_in]

set_property -dict {IOSTANDARD LVCMOS12 DRIVE 8 SLEW FAST} [get_ports {ext_data_out[*]}]

set_property IOSTANDARD LVCMOS12 [get_ports {ext_data_in[*]}]

set_property IOSTANDARD LVCMOS12 [get_ports core_phase_inc]

set_property -dict {LOC AW21} [get_ports core_phase_inc]
set_property -dict {LOC AU21} [get_ports {ext_data_out[13]}]
set_property -dict {LOC BC23} [get_ports {ext_data_in[13]}]
set_property -dict {LOC BA24} [get_ports m_aresetn]
set_property -dict {LOC AU25} [get_ports pcie_clk]
set_property -dict {LOC BA25} [get_ports {ext_data_in[0]}]
set_property -dict {LOC BB23} [get_ports ext_clk_out]
set_property -dict {LOC AY24} [get_ports {ext_data_in[1]}]
set_property -dict {LOC AU23} [get_ports {ext_data_in[2]}]
set_property -dict {LOC AU22} [get_ports {ext_data_in[3]}]
set_property -dict {LOC AW25} [get_ports {ext_data_in[4]}]
set_property -dict {LOC AW26} [get_ports {ext_data_in[5]}]
set_property -dict {LOC BD26} [get_ports {ext_data_in[6]}]
set_property -dict {LOC BC25} [get_ports {ext_data_in[7]}]
set_property -dict {LOC AT23} [get_ports {ext_data_in[8]}]
set_property -dict {LOC AW22} [get_ports {ext_data_in[9]}]
set_property -dict {LOC AU26} [get_ports {ext_data_in[10]}]
set_property -dict {LOC AU27} [get_ports {ext_data_in[11]}]
set_property -dict {LOC AN23} [get_ports {ext_data_in[12]}]
set_property -dict {LOC AW24} [get_ports {ext_data_out[0]}]
set_property -dict {LOC AR22} [get_ports {ext_data_out[1]}]
set_property -dict {LOC AV23} [get_ports {ext_data_out[2]}]
set_property -dict {LOC BA20} [get_ports {ext_data_out[3]}]
set_property -dict {LOC BB22} [get_ports {ext_data_out[4]}]
set_property -dict {LOC AY18} [get_ports {ext_data_out[5]}]
set_property -dict {LOC AW19} [get_ports {ext_data_out[6]}]
set_property -dict {LOC BA21} [get_ports {ext_data_out[7]}]
set_property -dict {LOC AY23} [get_ports {ext_data_out[8]}]
set_property -dict {LOC AV22} [get_ports {ext_data_out[9]}]
set_property -dict {LOC AY19} [get_ports {ext_data_out[10]}]
set_property -dict {LOC AY21} [get_ports {ext_data_out[11]}]
set_property -dict {LOC AW20} [get_ports {ext_data_out[12]}]
set_property -dict {LOC AT21} [get_ports ext_clk_in]

set_property -dict {LOC AT8} [get_ports clk40_in_p]

set_property PACKAGE_PIN AU20 [get_ports clk40_in]
set_property IOSTANDARD LVCMOS12 [get_ports clk40_in]

set_property -dict {LOC BA18 IOSTANDARD LVCMOS12} [get_ports lhc_clk_good] ;# CNT<37>

set_property -dict {LOC AK29 IOSTANDARD LVCMOS18} [get_ports {led[0]}]
set_property -dict {LOC AL28 IOSTANDARD LVCMOS18} [get_ports {led[1]}]
set_property -dict {LOC AL29 IOSTANDARD LVCMOS18} [get_ports {led[2]}]
set_property -dict {LOC AR27 IOSTANDARD LVCMOS18} [get_ports {led[3]}]

set_property -dict {LOC BA26 IOSTANDARD LVCMOS12} [get_ports ttc_l1a]
set_property -dict {LOC AY26 IOSTANDARD LVCMOS12} [get_ports ttc_mpc_inject]
set_property -dict {LOC BA23 IOSTANDARD LVCMOS12} [get_ports ttc_bc0]
set_property -dict {LOC AY22 IOSTANDARD LVCMOS12} [get_ports ttc_resync]
set_property -dict {LOC BA16 IOSTANDARD LVCMOS12} [get_ports ttc_hard_reset] ;# CNT<36>

set_property -dict {LOC BC14 IOSTANDARD LVCMOS12} [get_ports ttc_ev_cnt_reset]
set_property -dict {LOC AY16 IOSTANDARD LVCMOS12} [get_ports ttc_or_cnt_reset]


set_property -dict {LOC AM27 IOSTANDARD LVCMOS18} [get_ports fp[0]]
set_property -dict {LOC AK28 IOSTANDARD LVCMOS18} [get_ports fp[1]]
set_property -dict {LOC AM28 IOSTANDARD LVCMOS18} [get_ports fp[2]]
set_property -dict {LOC AK27 IOSTANDARD LVCMOS18} [get_ports fp[3]]

set_property -dict {LOC AT30 IOSTANDARD LVCMOS18} [get_ports resync_tp]
set_false_path -to [get_ports resync_tp]

set_false_path -from [get_clocks pcie_clk] -to [get_clocks CLK_OUT1_usrclk_mmcm]
set_false_path -from [get_clocks CLK_OUT1_usrclk_mmcm] -to [get_clocks pcie_clk]

set_false_path -from [get_clocks pcie_clk] -to [get_clocks CLK_OUT2_usrclk_mmcm]
set_false_path -from [get_clocks CLK_OUT2_usrclk_mmcm] -to [get_clocks pcie_clk]

set_false_path -from [get_clocks pcie_clk] -to [get_clocks CLK_OUT4_usrclk_mmcm]
set_false_path -from [get_clocks CLK_OUT4_usrclk_mmcm] -to [get_clocks pcie_clk]

set_false_path -from [get_clocks pcie_clk] -to [get_clocks clk40_in_p]
set_false_path -from [get_clocks clk40_in_p] -to [get_clocks pcie_clk]

set_false_path -from [get_clocks pcie_clk] -to [get_clocks clk40_in]
set_false_path -from [get_clocks clk40_in] -to [get_clocks pcie_clk]

set_false_path -from [get_pins ctoc/rst_isd_reg/C] -to [get_pins ctoc/rst_isd_r_reg/D]

#set_false_path -from [get_clocks CLK_OUT1_usrclk_mmcm] -to [get_clocks gt0_txusrclk_i]
set_false_path -from [get_pins ttc_resync_rx_reg/C] -to [get_pins {amc13_link_tx_/DAQ_LINK_7S_I/ReSyncAndEmptySync_reg[0]/D}]

# for 80MHz DAQ, comment out for 40MHz DAQ
set_false_path -from [get_clocks pcie_clk] -to [get_clocks clk_out1_mmcm_daq]
set_false_path -from [get_clocks clk_out1_mmcm_daq] -to [get_clocks pcie_clk]

set_false_path -to [get_ports fp[*]]

set_false_path -from [get_clocks clk_out1_mmcm_sync] -to [get_clocks pcie_clk]
set_false_path -from [get_clocks pcie_clk] -to [get_clocks clk_out1_mmcm_sync]

#set_false_path -from [get_clocks clk_out1_mmcm_async] -to [get_clocks CLK_OUT2_usrclk_mmcm]
#set_false_path -from [get_clocks CLK_OUT2_usrclk_mmcm] -to [get_clocks clk_out1_mmcm_async]

set_property LOC MMCME2_ADV_X1Y5 [get_cells ctoc/ctoc_mmcm_in_/inst/mmcm_adv_inst]

#set_max_delay -from [get_pins {mpc_gen[1].mpc/serial.rx[7].gc/txdata_din_reg[*]/C}] -to [get_pins {mpc_gen[1].mpc/serial.rx[7].gc/tx_portal_10g/mem_reg[*]/D}] -datapath_only 4
#set_max_delay -from [get_pins {mpc_gen[1].mpc/serial.rx[7].gc/mmcm_120/inst/mmcm_adv_inst/CLKOUT0}] -to [get_pins {mpc_gen[1].mpc/serial.rx[7].gc/tx_portal_10g/wr_clk_r_reg/D}] -datapath_only 4
#set_max_delay -from [get_pins {mpc_gen[1].mpc/serial.rx[7].gc/txdata_din_reg[*]/C}] -to [get_pins {mpc_gen[1].mpc/serial.rx[7].gc/tx_portal_10g/dout_reg[*]/D}] -datapath_only 4

set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.OVERTEMPPOWERDOWN ENABLE [current_design]
set_property BITSTREAM.CONFIG.USR_ACCESS TIMESTAMP [current_design]

 set_property CFGBVS GND [current_design]
 #where value1 is either VCCO or GND

 set_property CONFIG_VOLTAGE 1.8 [current_design]
 #where value2 is the voltage provided to configuration bank 0


