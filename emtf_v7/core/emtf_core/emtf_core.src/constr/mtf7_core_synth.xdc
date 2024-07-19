create_clock -period 8.000 -name pcie_clk [get_ports pcie_clk]

create_clock -period 8.000 -name ext_clk_in [get_ports ext_clk_in]

create_clock -period 24.000 -name clk40_in_p [get_ports clk40_in_p]
create_clock -period 24.000 -name clk40_in [get_ports clk40_in]

#create_clock -period 6.25 -name gt0_txusrclk_i [get_cells mpc_gen[*].mpc/serial.rx[*].g/gt0_txusrclk_i]

#create_clock -period 4.0 [get_cells mpc_gen[1].mpc/serial.rx[7].gc/gt0_txusrclk2_i]