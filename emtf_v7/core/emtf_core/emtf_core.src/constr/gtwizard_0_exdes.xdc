

#create_clock -period 4.000 [get_ports daq_refclk_p]





#create_clock -name drpclk_in_i -period 16.667 [get_ports DRP_CLK_IN_P]


# User Clock Constraints


#set_false_path -to [get_pins -hierarchical -filter {NAME =~ *_txfsmresetdone_r*/CLR}]
#set_false_path -to [get_pins -hierarchical -filter {NAME =~ *_txfsmresetdone_r*/D}]
################################# RefClk Location constraints #####################
#set_property PACKAGE_PIN AR10 [get_ports daq_refclk_p]
#set_property PACKAGE_PIN AR9 [get_ports daq_refclk_n]

## LOC constrain for DRP_CLK_P/N
## set_property LOC C25 [get_ports  DRP_CLK_IN_P]
## set_property LOC B25 [get_ports  DRP_CLK_IN_N]

################################# mgt wrapper constraints #####################

##---------- Set placement for gt0_gth_wrapper_i/GTHE2_CHANNEL ------
set_property LOC GTHE2_CHANNEL_X1Y4 [get_cells amc13_link_tx_/gth_tx/daq_link_tx_init_i/daq_link_tx_i/gt0_daq_link_tx_i/gthe2_i]

##---------- Set ASYNC_REG for flop which have async input ----------
##set_property ASYNC_REG TRUE [get_cells -hier -filter {name=~*gt0_frame_gen*system_reset_r_reg}]
##set_property ASYNC_REG TRUE [get_cells -hier -filter {name=~*gt0_frame_check*system_reset_r_reg}]

##---------- Set False Path from one clock to other ----------
create_clock -period 3.900 -name amc13_tx_clk [get_pins amc13_link_tx_/gth_tx/daq_link_tx_init_i/daq_link_tx_i/gt0_daq_link_tx_i/gthe2_i/TXOUTCLK]
set_false_path -from [get_clocks clk_out1_mmcm_daq] -to [get_clocks amc13_tx_clk]
set_false_path -from [get_clocks amc13_tx_clk] -to [get_clocks clk_out1_mmcm_daq]

set_false_path -from [get_clocks amc13_tx_clk] -to [get_clocks CLK_OUT2_usrclk_mmcm]
set_false_path -from [get_clocks CLK_OUT2_usrclk_mmcm] -to [get_clocks amc13_tx_clk]

set_false_path -from [get_clocks pcie_clk] -to [get_clocks amc13_tx_clk]
set_false_path -from [get_clocks amc13_tx_clk] -to [get_clocks pcie_clk]

