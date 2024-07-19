#-*-tcl-*-
set_property PACKAGE_PIN D6 [get_ports sys_clk_p]
# PCIe Lane 0
#set_property LOC GTXE2_CHANNEL_X0Y2 [get_cells {pcie_/pcie_7x_0_i/gt_top_i/pipe_wrapper_i/pipe_lane[0].gt_wrapper_i/gtx_channel.gtxe2_channel_i}]
# PCIe Lane 1
#set_property LOC GTXE2_CHANNEL_X0Y3 [get_cells {pcie_/pcie_7x_0_i/gt_top_i/pipe_wrapper_i/pipe_lane[1].gt_wrapper_i/gtx_channel.gtxe2_channel_i}]

set_property LOC GTXE2_CHANNEL_X0Y3 [get_cells {pcie_/pcie_7x_0_support_i/pcie_7x_0_i/inst/inst/gt_top_i/pipe_wrapper_i/pipe_lane[1].gt_wrapper_i/gtx_channel.gtxe2_channel_i}]
set_property PACKAGE_PIN J4 [get_ports {pci_exp_rxp[1]}]
set_property PACKAGE_PIN H2 [get_ports {pci_exp_txp[1]}]
set_property LOC GTXE2_CHANNEL_X0Y2 [get_cells {pcie_/pcie_7x_0_support_i/pcie_7x_0_i/inst/inst/gt_top_i/pipe_wrapper_i/pipe_lane[0].gt_wrapper_i/gtx_channel.gtxe2_channel_i}]
set_property PACKAGE_PIN L4 [get_ports {pci_exp_rxp[0]}]
set_property PACKAGE_PIN K2 [get_ports {pci_exp_txp[0]}]

