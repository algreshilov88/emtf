

set_property -dict {LOC BA24 IOSTANDARD LVCMOS12} [get_ports m_aresetn]

set_property PACKAGE_PIN AU15 [get_ports k_rx_clk]

set_property PACKAGE_PIN BD12 [get_ports {k_rxdata[0]}]
set_property PACKAGE_PIN BD15 [get_ports {k_rxdata[1]}]
set_property PACKAGE_PIN BD16 [get_ports {k_rxdata[2]}]
set_property PACKAGE_PIN BD11 [get_ports {k_rxdata[3]}]
set_property PACKAGE_PIN BC12 [get_ports {k_rxdata[4]}]
set_property PACKAGE_PIN BC17 [get_ports {k_rxdata[5]}]
set_property PACKAGE_PIN BD17 [get_ports {k_rxdata[6]}]
set_property PACKAGE_PIN BC15 [get_ports {k_rxdata[7]}]
set_property PACKAGE_PIN BD14 [get_ports {k_rxdata[8]}]
set_property PACKAGE_PIN AW17 [get_ports {k_rxdata[9]}]
set_property PACKAGE_PIN BB21 [get_ports {k_rxdata[10]}]
set_property PACKAGE_PIN BC19 [get_ports {k_rxdata[11]}]
set_property PACKAGE_PIN BD19 [get_ports {k_rxdata[12]}]
set_property PACKAGE_PIN BD25 [get_ports {k_rxdata[13]}]
set_property PACKAGE_PIN BD24 [get_ports {k_rxdata[14]}]
set_property PACKAGE_PIN BD20 [get_ports {k_rxdata[15]}]
set_property PACKAGE_PIN BC20 [get_ports {k_rxcharisk[0]}]
set_property PACKAGE_PIN BB26 [get_ports {k_rxcharisk[1]}]
set_property PACKAGE_PIN BB25 [get_ports {k_rxchariscomma[0]}]
set_property PACKAGE_PIN BC22 [get_ports {k_rxchariscomma[1]}]
set_property PACKAGE_PIN BD21 [get_ports {k_rxnotintable[0]}]
set_property PACKAGE_PIN BC24 [get_ports {k_rxnotintable[1]}]
set_property PACKAGE_PIN BD22 [get_ports k_rxresetdone]

set_property IOSTANDARD LVCMOS12 [get_ports k_rx*]

create_clock -period 4.000 -name k_rx_clk [get_ports k_rx_clk]

set_false_path -from [get_clocks k_rx_clk]
set_false_path -to [get_clocks k_rx_clk]

set_property IOB TRUE [get_ports {k_rxdata[*]}]
set_property IOB TRUE [get_ports {k_rxcharisk[*]}]
set_property IOB TRUE [get_ports {k_rxchariscomma[*]}]
set_property IOB TRUE [get_ports {k_rxnotintable[*]}]
#set_property IOB TRUE [get_ports k_rxresetdone]
set_property IOB TRUE [get_ports ttc_*]

set_input_delay -clock k_rx_clk 2.000 [get_ports {k_rxdata[*]}]
set_input_delay -clock k_rx_clk 2.000 [get_ports {k_rxcharisk[*]}]
set_input_delay -clock k_rx_clk 2.000 [get_ports {k_rxchariscomma[*]}]
set_input_delay -clock k_rx_clk 2.000 [get_ports {k_rxnotintable[*]}]

# preset by status signals, don't really care how long it takes
set_false_path -to [get_pins {amc13_link_tx_/DAQ_LINK_7S_I/reset_SyncRegs_reg[*]/PRE}]




