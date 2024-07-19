


create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 6 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list pcie_/pcie_7x_0_support_i/pipe_clock_i/CLK_USERCLK2]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 32 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_time_cnt_w[0]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_time_cnt_w[1]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_time_cnt_w[2]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_time_cnt_w[3]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_time_cnt_w[4]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_time_cnt_w[5]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_time_cnt_w[6]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_time_cnt_w[7]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_time_cnt_w[8]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_time_cnt_w[9]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_time_cnt_w[10]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_time_cnt_w[11]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_time_cnt_w[12]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_time_cnt_w[13]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_time_cnt_w[14]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_time_cnt_w[15]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_time_cnt_w[16]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_time_cnt_w[17]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_time_cnt_w[18]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_time_cnt_w[19]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_time_cnt_w[20]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_time_cnt_w[21]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_time_cnt_w[22]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_time_cnt_w[23]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_time_cnt_w[24]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_time_cnt_w[25]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_time_cnt_w[26]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_time_cnt_w[27]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_time_cnt_w[28]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_time_cnt_w[29]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_time_cnt_w[30]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_time_cnt_w[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 32 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_max_time_w[0]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_max_time_w[1]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_max_time_w[2]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_max_time_w[3]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_max_time_w[4]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_max_time_w[5]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_max_time_w[6]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_max_time_w[7]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_max_time_w[8]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_max_time_w[9]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_max_time_w[10]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_max_time_w[11]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_max_time_w[12]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_max_time_w[13]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_max_time_w[14]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_max_time_w[15]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_max_time_w[16]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_max_time_w[17]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_max_time_w[18]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_max_time_w[19]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_max_time_w[20]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_max_time_w[21]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_max_time_w[22]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_max_time_w[23]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_max_time_w[24]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_max_time_w[25]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_max_time_w[26]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_max_time_w[27]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_max_time_w[28]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_max_time_w[29]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_max_time_w[30]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_max_time_w[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 16 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_done_cnt_w[0]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_done_cnt_w[1]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_done_cnt_w[2]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_done_cnt_w[3]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_done_cnt_w[4]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_done_cnt_w[5]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_done_cnt_w[6]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_done_cnt_w[7]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_done_cnt_w[8]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_done_cnt_w[9]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_done_cnt_w[10]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_done_cnt_w[11]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_done_cnt_w[12]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_done_cnt_w[13]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_done_cnt_w[14]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/compl_done_cnt_w[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 8 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {ttcd/brcst_data[0]} {ttcd/brcst_data[1]} {ttcd/brcst_data[2]} {ttcd/brcst_data[3]} {ttcd/brcst_data[4]} {ttcd/brcst_data[5]} {ttcd/brcst_data[6]} {ttcd/brcst_data[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 16 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/req_compl_cnt_w[0]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/req_compl_cnt_w[1]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/req_compl_cnt_w[2]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/req_compl_cnt_w[3]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/req_compl_cnt_w[4]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/req_compl_cnt_w[5]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/req_compl_cnt_w[6]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/req_compl_cnt_w[7]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/req_compl_cnt_w[8]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/req_compl_cnt_w[9]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/req_compl_cnt_w[10]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/req_compl_cnt_w[11]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/req_compl_cnt_w[12]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/req_compl_cnt_w[13]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/req_compl_cnt_w[14]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/req_compl_cnt_w[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 64 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_w[0]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_w[1]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_w[2]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_w[3]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_w[4]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_w[5]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_w[6]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_w[7]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_w[8]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_w[9]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_w[10]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_w[11]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_w[12]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_w[13]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_w[14]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_w[15]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_w[16]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_w[17]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_w[18]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_w[19]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_w[20]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_w[21]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_w[22]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_w[23]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_w[24]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_w[25]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_w[26]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_w[27]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_w[28]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_w[29]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_w[30]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_w[31]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_w[32]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_w[33]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_w[34]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_w[35]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_w[36]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_w[37]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_w[38]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_w[39]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_w[40]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_w[41]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_w[42]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_w[43]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_w[44]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_w[45]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_w[46]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_w[47]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_w[48]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_w[49]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_w[50]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_w[51]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_w[52]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_w[53]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_w[54]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_w[55]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_w[56]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_w[57]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_w[58]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_w[59]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_w[60]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_w[61]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_w[62]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_w[63]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 64 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_r_w[0]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_r_w[1]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_r_w[2]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_r_w[3]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_r_w[4]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_r_w[5]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_r_w[6]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_r_w[7]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_r_w[8]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_r_w[9]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_r_w[10]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_r_w[11]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_r_w[12]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_r_w[13]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_r_w[14]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_r_w[15]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_r_w[16]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_r_w[17]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_r_w[18]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_r_w[19]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_r_w[20]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_r_w[21]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_r_w[22]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_r_w[23]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_r_w[24]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_r_w[25]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_r_w[26]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_r_w[27]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_r_w[28]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_r_w[29]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_r_w[30]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_r_w[31]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_r_w[32]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_r_w[33]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_r_w[34]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_r_w[35]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_r_w[36]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_r_w[37]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_r_w[38]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_r_w[39]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_r_w[40]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_r_w[41]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_r_w[42]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_r_w[43]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_r_w[44]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_r_w[45]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_r_w[46]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_r_w[47]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_r_w[48]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_r_w[49]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_r_w[50]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_r_w[51]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_r_w[52]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_r_w[53]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_r_w[54]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_r_w[55]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_r_w[56]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_r_w[57]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_r_w[58]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_r_w[59]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_r_w[60]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_r_w[61]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_r_w[62]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/s_axis_tx_tdata_r_w[63]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 3 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/tx_state_w[0]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/tx_state_w[1]} {pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/tx_state_w[2]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 8 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tkeep_w[0]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tkeep_w[1]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tkeep_w[2]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tkeep_w[3]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tkeep_w[4]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tkeep_w[5]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tkeep_w[6]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tkeep_w[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 64 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tdata_w[0]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tdata_w[1]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tdata_w[2]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tdata_w[3]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tdata_w[4]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tdata_w[5]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tdata_w[6]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tdata_w[7]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tdata_w[8]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tdata_w[9]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tdata_w[10]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tdata_w[11]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tdata_w[12]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tdata_w[13]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tdata_w[14]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tdata_w[15]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tdata_w[16]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tdata_w[17]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tdata_w[18]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tdata_w[19]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tdata_w[20]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tdata_w[21]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tdata_w[22]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tdata_w[23]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tdata_w[24]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tdata_w[25]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tdata_w[26]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tdata_w[27]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tdata_w[28]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tdata_w[29]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tdata_w[30]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tdata_w[31]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tdata_w[32]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tdata_w[33]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tdata_w[34]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tdata_w[35]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tdata_w[36]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tdata_w[37]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tdata_w[38]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tdata_w[39]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tdata_w[40]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tdata_w[41]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tdata_w[42]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tdata_w[43]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tdata_w[44]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tdata_w[45]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tdata_w[46]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tdata_w[47]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tdata_w[48]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tdata_w[49]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tdata_w[50]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tdata_w[51]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tdata_w[52]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tdata_w[53]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tdata_w[54]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tdata_w[55]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tdata_w[56]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tdata_w[57]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tdata_w[58]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tdata_w[59]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tdata_w[60]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tdata_w[61]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tdata_w[62]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tdata_w[63]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 22 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tuser_w[0]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tuser_w[1]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tuser_w[2]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tuser_w[3]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tuser_w[4]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tuser_w[5]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tuser_w[6]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tuser_w[7]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tuser_w[8]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tuser_w[9]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tuser_w[10]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tuser_w[11]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tuser_w[12]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tuser_w[13]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tuser_w[14]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tuser_w[15]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tuser_w[16]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tuser_w[17]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tuser_w[18]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tuser_w[19]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tuser_w[20]} {pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tuser_w[21]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 10 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list {pcie_/app/PIO/PIO_EP_inst/req_len[0]} {pcie_/app/PIO/PIO_EP_inst/req_len[1]} {pcie_/app/PIO/PIO_EP_inst/req_len[2]} {pcie_/app/PIO/PIO_EP_inst/req_len[3]} {pcie_/app/PIO/PIO_EP_inst/req_len[4]} {pcie_/app/PIO/PIO_EP_inst/req_len[5]} {pcie_/app/PIO/PIO_EP_inst/req_len[6]} {pcie_/app/PIO/PIO_EP_inst/req_len[7]} {pcie_/app/PIO/PIO_EP_inst/req_len[8]} {pcie_/app/PIO/PIO_EP_inst/req_len[9]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 8 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list {pcie_/app/PIO/PIO_EP_inst/req_be[0]} {pcie_/app/PIO/PIO_EP_inst/req_be[1]} {pcie_/app/PIO/PIO_EP_inst/req_be[2]} {pcie_/app/PIO/PIO_EP_inst/req_be[3]} {pcie_/app/PIO/PIO_EP_inst/req_be[4]} {pcie_/app/PIO/PIO_EP_inst/req_be[5]} {pcie_/app/PIO/PIO_EP_inst/req_be[6]} {pcie_/app/PIO/PIO_EP_inst/req_be[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 2 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list {pcie_/app/PIO/PIO_EP_inst/req_attr[0]} {pcie_/app/PIO/PIO_EP_inst/req_attr[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 32 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list {pcie_/app/PIO/PIO_EP_inst/req_addr[0]} {pcie_/app/PIO/PIO_EP_inst/req_addr[1]} {pcie_/app/PIO/PIO_EP_inst/req_addr[2]} {pcie_/app/PIO/PIO_EP_inst/req_addr[3]} {pcie_/app/PIO/PIO_EP_inst/req_addr[4]} {pcie_/app/PIO/PIO_EP_inst/req_addr[5]} {pcie_/app/PIO/PIO_EP_inst/req_addr[6]} {pcie_/app/PIO/PIO_EP_inst/req_addr[7]} {pcie_/app/PIO/PIO_EP_inst/req_addr[8]} {pcie_/app/PIO/PIO_EP_inst/req_addr[9]} {pcie_/app/PIO/PIO_EP_inst/req_addr[10]} {pcie_/app/PIO/PIO_EP_inst/req_addr[11]} {pcie_/app/PIO/PIO_EP_inst/req_addr[12]} {pcie_/app/PIO/PIO_EP_inst/req_addr[13]} {pcie_/app/PIO/PIO_EP_inst/req_addr[14]} {pcie_/app/PIO/PIO_EP_inst/req_addr[15]} {pcie_/app/PIO/PIO_EP_inst/req_addr[16]} {pcie_/app/PIO/PIO_EP_inst/req_addr[17]} {pcie_/app/PIO/PIO_EP_inst/req_addr[18]} {pcie_/app/PIO/PIO_EP_inst/req_addr[19]} {pcie_/app/PIO/PIO_EP_inst/req_addr[20]} {pcie_/app/PIO/PIO_EP_inst/req_addr[21]} {pcie_/app/PIO/PIO_EP_inst/req_addr[22]} {pcie_/app/PIO/PIO_EP_inst/req_addr[23]} {pcie_/app/PIO/PIO_EP_inst/req_addr[24]} {pcie_/app/PIO/PIO_EP_inst/req_addr[25]} {pcie_/app/PIO/PIO_EP_inst/req_addr[26]} {pcie_/app/PIO/PIO_EP_inst/req_addr[27]} {pcie_/app/PIO/PIO_EP_inst/req_addr[28]} {pcie_/app/PIO/PIO_EP_inst/req_addr[29]} {pcie_/app/PIO/PIO_EP_inst/req_addr[30]} {pcie_/app/PIO/PIO_EP_inst/req_addr[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
set_property port_width 16 [get_debug_ports u_ila_0/probe15]
connect_debug_port u_ila_0/probe15 [get_nets [list {pcie_/app/PIO/PIO_EP_inst/req_rid[0]} {pcie_/app/PIO/PIO_EP_inst/req_rid[1]} {pcie_/app/PIO/PIO_EP_inst/req_rid[2]} {pcie_/app/PIO/PIO_EP_inst/req_rid[3]} {pcie_/app/PIO/PIO_EP_inst/req_rid[4]} {pcie_/app/PIO/PIO_EP_inst/req_rid[5]} {pcie_/app/PIO/PIO_EP_inst/req_rid[6]} {pcie_/app/PIO/PIO_EP_inst/req_rid[7]} {pcie_/app/PIO/PIO_EP_inst/req_rid[8]} {pcie_/app/PIO/PIO_EP_inst/req_rid[9]} {pcie_/app/PIO/PIO_EP_inst/req_rid[10]} {pcie_/app/PIO/PIO_EP_inst/req_rid[11]} {pcie_/app/PIO/PIO_EP_inst/req_rid[12]} {pcie_/app/PIO/PIO_EP_inst/req_rid[13]} {pcie_/app/PIO/PIO_EP_inst/req_rid[14]} {pcie_/app/PIO/PIO_EP_inst/req_rid[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe16]
set_property port_width 4 [get_debug_ports u_ila_0/probe16]
connect_debug_port u_ila_0/probe16 [get_nets [list {pcie_/app/PIO/PIO_EP_inst/rd_be[0]} {pcie_/app/PIO/PIO_EP_inst/rd_be[1]} {pcie_/app/PIO/PIO_EP_inst/rd_be[2]} {pcie_/app/PIO/PIO_EP_inst/rd_be[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe17]
set_property port_width 8 [get_debug_ports u_ila_0/probe17]
connect_debug_port u_ila_0/probe17 [get_nets [list {pcie_/app/PIO/PIO_EP_inst/wr_be[0]} {pcie_/app/PIO/PIO_EP_inst/wr_be[1]} {pcie_/app/PIO/PIO_EP_inst/wr_be[2]} {pcie_/app/PIO/PIO_EP_inst/wr_be[3]} {pcie_/app/PIO/PIO_EP_inst/wr_be[4]} {pcie_/app/PIO/PIO_EP_inst/wr_be[5]} {pcie_/app/PIO/PIO_EP_inst/wr_be[6]} {pcie_/app/PIO/PIO_EP_inst/wr_be[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe18]
set_property port_width 8 [get_debug_ports u_ila_0/probe18]
connect_debug_port u_ila_0/probe18 [get_nets [list {pcie_/app/PIO/PIO_EP_inst/s_axis_tx_tkeep_w[0]} {pcie_/app/PIO/PIO_EP_inst/s_axis_tx_tkeep_w[1]} {pcie_/app/PIO/PIO_EP_inst/s_axis_tx_tkeep_w[2]} {pcie_/app/PIO/PIO_EP_inst/s_axis_tx_tkeep_w[3]} {pcie_/app/PIO/PIO_EP_inst/s_axis_tx_tkeep_w[4]} {pcie_/app/PIO/PIO_EP_inst/s_axis_tx_tkeep_w[5]} {pcie_/app/PIO/PIO_EP_inst/s_axis_tx_tkeep_w[6]} {pcie_/app/PIO/PIO_EP_inst/s_axis_tx_tkeep_w[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe19]
set_property port_width 3 [get_debug_ports u_ila_0/probe19]
connect_debug_port u_ila_0/probe19 [get_nets [list {pcie_/app/PIO/PIO_EP_inst/req_tc[0]} {pcie_/app/PIO/PIO_EP_inst/req_tc[1]} {pcie_/app/PIO/PIO_EP_inst/req_tc[2]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe20]
set_property port_width 8 [get_debug_ports u_ila_0/probe20]
connect_debug_port u_ila_0/probe20 [get_nets [list {pcie_/app/PIO/PIO_EP_inst/req_tag[0]} {pcie_/app/PIO/PIO_EP_inst/req_tag[1]} {pcie_/app/PIO/PIO_EP_inst/req_tag[2]} {pcie_/app/PIO/PIO_EP_inst/req_tag[3]} {pcie_/app/PIO/PIO_EP_inst/req_tag[4]} {pcie_/app/PIO/PIO_EP_inst/req_tag[5]} {pcie_/app/PIO/PIO_EP_inst/req_tag[6]} {pcie_/app/PIO/PIO_EP_inst/req_tag[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe21]
set_property port_width 27 [get_debug_ports u_ila_0/probe21]
connect_debug_port u_ila_0/probe21 [get_nets [list {fc/fla_w[1]} {fc/fla_w[2]} {fc/fla_w[3]} {fc/fla_w[4]} {fc/fla_w[5]} {fc/fla_w[6]} {fc/fla_w[7]} {fc/fla_w[8]} {fc/fla_w[9]} {fc/fla_w[10]} {fc/fla_w[11]} {fc/fla_w[12]} {fc/fla_w[13]} {fc/fla_w[14]} {fc/fla_w[15]} {fc/fla_w[16]} {fc/fla_w[17]} {fc/fla_w[18]} {fc/fla_w[19]} {fc/fla_w[20]} {fc/fla_w[21]} {fc/fla_w[22]} {fc/fla_w[23]} {fc/fla_w[24]} {fc/fla_w[25]} {fc/fla_w[26]} {fc/fla_w[27]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe22]
set_property port_width 16 [get_debug_ports u_ila_0/probe22]
connect_debug_port u_ila_0/probe22 [get_nets [list {fc/flash_wrd_w[0]} {fc/flash_wrd_w[1]} {fc/flash_wrd_w[2]} {fc/flash_wrd_w[3]} {fc/flash_wrd_w[4]} {fc/flash_wrd_w[5]} {fc/flash_wrd_w[6]} {fc/flash_wrd_w[7]} {fc/flash_wrd_w[8]} {fc/flash_wrd_w[9]} {fc/flash_wrd_w[10]} {fc/flash_wrd_w[11]} {fc/flash_wrd_w[12]} {fc/flash_wrd_w[13]} {fc/flash_wrd_w[14]} {fc/flash_wrd_w[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe23]
set_property port_width 16 [get_debug_ports u_ila_0/probe23]
connect_debug_port u_ila_0/probe23 [get_nets [list {fc/flash_rdd_w[0]} {fc/flash_rdd_w[1]} {fc/flash_rdd_w[2]} {fc/flash_rdd_w[3]} {fc/flash_rdd_w[4]} {fc/flash_rdd_w[5]} {fc/flash_rdd_w[6]} {fc/flash_rdd_w[7]} {fc/flash_rdd_w[8]} {fc/flash_rdd_w[9]} {fc/flash_rdd_w[10]} {fc/flash_rdd_w[11]} {fc/flash_rdd_w[12]} {fc/flash_rdd_w[13]} {fc/flash_rdd_w[14]} {fc/flash_rdd_w[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe24]
set_property port_width 64 [get_debug_ports u_ila_0/probe24]
connect_debug_port u_ila_0/probe24 [get_nets [list {lb/beam_data_w[0]} {lb/beam_data_w[1]} {lb/beam_data_w[2]} {lb/beam_data_w[3]} {lb/beam_data_w[4]} {lb/beam_data_w[5]} {lb/beam_data_w[6]} {lb/beam_data_w[7]} {lb/beam_data_w[8]} {lb/beam_data_w[9]} {lb/beam_data_w[10]} {lb/beam_data_w[11]} {lb/beam_data_w[12]} {lb/beam_data_w[13]} {lb/beam_data_w[14]} {lb/beam_data_w[15]} {lb/beam_data_w[16]} {lb/beam_data_w[17]} {lb/beam_data_w[18]} {lb/beam_data_w[19]} {lb/beam_data_w[20]} {lb/beam_data_w[21]} {lb/beam_data_w[22]} {lb/beam_data_w[23]} {lb/beam_data_w[24]} {lb/beam_data_w[25]} {lb/beam_data_w[26]} {lb/beam_data_w[27]} {lb/beam_data_w[28]} {lb/beam_data_w[29]} {lb/beam_data_w[30]} {lb/beam_data_w[31]} {lb/beam_data_w[32]} {lb/beam_data_w[33]} {lb/beam_data_w[34]} {lb/beam_data_w[35]} {lb/beam_data_w[36]} {lb/beam_data_w[37]} {lb/beam_data_w[38]} {lb/beam_data_w[39]} {lb/beam_data_w[40]} {lb/beam_data_w[41]} {lb/beam_data_w[42]} {lb/beam_data_w[43]} {lb/beam_data_w[44]} {lb/beam_data_w[45]} {lb/beam_data_w[46]} {lb/beam_data_w[47]} {lb/beam_data_w[48]} {lb/beam_data_w[49]} {lb/beam_data_w[50]} {lb/beam_data_w[51]} {lb/beam_data_w[52]} {lb/beam_data_w[53]} {lb/beam_data_w[54]} {lb/beam_data_w[55]} {lb/beam_data_w[56]} {lb/beam_data_w[57]} {lb/beam_data_w[58]} {lb/beam_data_w[59]} {lb/beam_data_w[60]} {lb/beam_data_w[61]} {lb/beam_data_w[62]} {lb/beam_data_w[63]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe25]
set_property port_width 15 [get_debug_ports u_ila_0/probe25]
connect_debug_port u_ila_0/probe25 [get_nets [list {lb/adrr_w[0]} {lb/adrr_w[1]} {lb/adrr_w[2]} {lb/adrr_w[3]} {lb/adrr_w[4]} {lb/adrr_w[5]} {lb/adrr_w[6]} {lb/adrr_w[7]} {lb/adrr_w[8]} {lb/adrr_w[9]} {lb/adrr_w[10]} {lb/adrr_w[11]} {lb/adrr_w[12]} {lb/adrr_w[13]} {lb/adrr_w[14]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe26]
set_property port_width 32 [get_debug_ports u_ila_0/probe26]
connect_debug_port u_ila_0/probe26 [get_nets [list {pcie_/cfg_gnt_time_cnt_w[0]} {pcie_/cfg_gnt_time_cnt_w[1]} {pcie_/cfg_gnt_time_cnt_w[2]} {pcie_/cfg_gnt_time_cnt_w[3]} {pcie_/cfg_gnt_time_cnt_w[4]} {pcie_/cfg_gnt_time_cnt_w[5]} {pcie_/cfg_gnt_time_cnt_w[6]} {pcie_/cfg_gnt_time_cnt_w[7]} {pcie_/cfg_gnt_time_cnt_w[8]} {pcie_/cfg_gnt_time_cnt_w[9]} {pcie_/cfg_gnt_time_cnt_w[10]} {pcie_/cfg_gnt_time_cnt_w[11]} {pcie_/cfg_gnt_time_cnt_w[12]} {pcie_/cfg_gnt_time_cnt_w[13]} {pcie_/cfg_gnt_time_cnt_w[14]} {pcie_/cfg_gnt_time_cnt_w[15]} {pcie_/cfg_gnt_time_cnt_w[16]} {pcie_/cfg_gnt_time_cnt_w[17]} {pcie_/cfg_gnt_time_cnt_w[18]} {pcie_/cfg_gnt_time_cnt_w[19]} {pcie_/cfg_gnt_time_cnt_w[20]} {pcie_/cfg_gnt_time_cnt_w[21]} {pcie_/cfg_gnt_time_cnt_w[22]} {pcie_/cfg_gnt_time_cnt_w[23]} {pcie_/cfg_gnt_time_cnt_w[24]} {pcie_/cfg_gnt_time_cnt_w[25]} {pcie_/cfg_gnt_time_cnt_w[26]} {pcie_/cfg_gnt_time_cnt_w[27]} {pcie_/cfg_gnt_time_cnt_w[28]} {pcie_/cfg_gnt_time_cnt_w[29]} {pcie_/cfg_gnt_time_cnt_w[30]} {pcie_/cfg_gnt_time_cnt_w[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe27]
set_property port_width 16 [get_debug_ports u_ila_0/probe27]
connect_debug_port u_ila_0/probe27 [get_nets [list {pcie_/cfg_gnt_cnt_w[0]} {pcie_/cfg_gnt_cnt_w[1]} {pcie_/cfg_gnt_cnt_w[2]} {pcie_/cfg_gnt_cnt_w[3]} {pcie_/cfg_gnt_cnt_w[4]} {pcie_/cfg_gnt_cnt_w[5]} {pcie_/cfg_gnt_cnt_w[6]} {pcie_/cfg_gnt_cnt_w[7]} {pcie_/cfg_gnt_cnt_w[8]} {pcie_/cfg_gnt_cnt_w[9]} {pcie_/cfg_gnt_cnt_w[10]} {pcie_/cfg_gnt_cnt_w[11]} {pcie_/cfg_gnt_cnt_w[12]} {pcie_/cfg_gnt_cnt_w[13]} {pcie_/cfg_gnt_cnt_w[14]} {pcie_/cfg_gnt_cnt_w[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe28]
set_property port_width 16 [get_debug_ports u_ila_0/probe28]
connect_debug_port u_ila_0/probe28 [get_nets [list {pcie_/cfg_req_cnt_w[0]} {pcie_/cfg_req_cnt_w[1]} {pcie_/cfg_req_cnt_w[2]} {pcie_/cfg_req_cnt_w[3]} {pcie_/cfg_req_cnt_w[4]} {pcie_/cfg_req_cnt_w[5]} {pcie_/cfg_req_cnt_w[6]} {pcie_/cfg_req_cnt_w[7]} {pcie_/cfg_req_cnt_w[8]} {pcie_/cfg_req_cnt_w[9]} {pcie_/cfg_req_cnt_w[10]} {pcie_/cfg_req_cnt_w[11]} {pcie_/cfg_req_cnt_w[12]} {pcie_/cfg_req_cnt_w[13]} {pcie_/cfg_req_cnt_w[14]} {pcie_/cfg_req_cnt_w[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe29]
set_property port_width 32 [get_debug_ports u_ila_0/probe29]
connect_debug_port u_ila_0/probe29 [get_nets [list {pcie_/cfg_gnt_time_max_w[0]} {pcie_/cfg_gnt_time_max_w[1]} {pcie_/cfg_gnt_time_max_w[2]} {pcie_/cfg_gnt_time_max_w[3]} {pcie_/cfg_gnt_time_max_w[4]} {pcie_/cfg_gnt_time_max_w[5]} {pcie_/cfg_gnt_time_max_w[6]} {pcie_/cfg_gnt_time_max_w[7]} {pcie_/cfg_gnt_time_max_w[8]} {pcie_/cfg_gnt_time_max_w[9]} {pcie_/cfg_gnt_time_max_w[10]} {pcie_/cfg_gnt_time_max_w[11]} {pcie_/cfg_gnt_time_max_w[12]} {pcie_/cfg_gnt_time_max_w[13]} {pcie_/cfg_gnt_time_max_w[14]} {pcie_/cfg_gnt_time_max_w[15]} {pcie_/cfg_gnt_time_max_w[16]} {pcie_/cfg_gnt_time_max_w[17]} {pcie_/cfg_gnt_time_max_w[18]} {pcie_/cfg_gnt_time_max_w[19]} {pcie_/cfg_gnt_time_max_w[20]} {pcie_/cfg_gnt_time_max_w[21]} {pcie_/cfg_gnt_time_max_w[22]} {pcie_/cfg_gnt_time_max_w[23]} {pcie_/cfg_gnt_time_max_w[24]} {pcie_/cfg_gnt_time_max_w[25]} {pcie_/cfg_gnt_time_max_w[26]} {pcie_/cfg_gnt_time_max_w[27]} {pcie_/cfg_gnt_time_max_w[28]} {pcie_/cfg_gnt_time_max_w[29]} {pcie_/cfg_gnt_time_max_w[30]} {pcie_/cfg_gnt_time_max_w[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe30]
set_property port_width 32 [get_debug_ports u_ila_0/probe30]
connect_debug_port u_ila_0/probe30 [get_nets [list {beam_cnt_or[0]} {beam_cnt_or[1]} {beam_cnt_or[2]} {beam_cnt_or[3]} {beam_cnt_or[4]} {beam_cnt_or[5]} {beam_cnt_or[6]} {beam_cnt_or[7]} {beam_cnt_or[8]} {beam_cnt_or[9]} {beam_cnt_or[10]} {beam_cnt_or[11]} {beam_cnt_or[12]} {beam_cnt_or[13]} {beam_cnt_or[14]} {beam_cnt_or[15]} {beam_cnt_or[16]} {beam_cnt_or[17]} {beam_cnt_or[18]} {beam_cnt_or[19]} {beam_cnt_or[20]} {beam_cnt_or[21]} {beam_cnt_or[22]} {beam_cnt_or[23]} {beam_cnt_or[24]} {beam_cnt_or[25]} {beam_cnt_or[26]} {beam_cnt_or[27]} {beam_cnt_or[28]} {beam_cnt_or[29]} {beam_cnt_or[30]} {beam_cnt_or[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe31]
set_property port_width 32 [get_debug_ports u_ila_0/probe31]
connect_debug_port u_ila_0/probe31 [get_nets [list {beam_cnt[1]__0[0]} {beam_cnt[1]__0[1]} {beam_cnt[1]__0[2]} {beam_cnt[1]__0[3]} {beam_cnt[1]__0[4]} {beam_cnt[1]__0[5]} {beam_cnt[1]__0[6]} {beam_cnt[1]__0[7]} {beam_cnt[1]__0[8]} {beam_cnt[1]__0[9]} {beam_cnt[1]__0[10]} {beam_cnt[1]__0[11]} {beam_cnt[1]__0[12]} {beam_cnt[1]__0[13]} {beam_cnt[1]__0[14]} {beam_cnt[1]__0[15]} {beam_cnt[1]__0[16]} {beam_cnt[1]__0[17]} {beam_cnt[1]__0[18]} {beam_cnt[1]__0[19]} {beam_cnt[1]__0[20]} {beam_cnt[1]__0[21]} {beam_cnt[1]__0[22]} {beam_cnt[1]__0[23]} {beam_cnt[1]__0[24]} {beam_cnt[1]__0[25]} {beam_cnt[1]__0[26]} {beam_cnt[1]__0[27]} {beam_cnt[1]__0[28]} {beam_cnt[1]__0[29]} {beam_cnt[1]__0[30]} {beam_cnt[1]__0[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe32]
set_property port_width 32 [get_debug_ports u_ila_0/probe32]
connect_debug_port u_ila_0/probe32 [get_nets [list {beam_addr_or[0]} {beam_addr_or[1]} {beam_addr_or[2]} {beam_addr_or[3]} {beam_addr_or[4]} {beam_addr_or[5]} {beam_addr_or[6]} {beam_addr_or[7]} {beam_addr_or[8]} {beam_addr_or[9]} {beam_addr_or[10]} {beam_addr_or[11]} {beam_addr_or[12]} {beam_addr_or[13]} {beam_addr_or[14]} {beam_addr_or[15]} {beam_addr_or[16]} {beam_addr_or[17]} {beam_addr_or[18]} {beam_addr_or[19]} {beam_addr_or[20]} {beam_addr_or[21]} {beam_addr_or[22]} {beam_addr_or[23]} {beam_addr_or[24]} {beam_addr_or[25]} {beam_addr_or[26]} {beam_addr_or[27]} {beam_addr_or[28]} {beam_addr_or[29]} {beam_addr_or[30]} {beam_addr_or[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe33]
set_property port_width 32 [get_debug_ports u_ila_0/probe33]
connect_debug_port u_ila_0/probe33 [get_nets [list {beam_cnt[0]__0[0]} {beam_cnt[0]__0[1]} {beam_cnt[0]__0[2]} {beam_cnt[0]__0[3]} {beam_cnt[0]__0[4]} {beam_cnt[0]__0[5]} {beam_cnt[0]__0[6]} {beam_cnt[0]__0[7]} {beam_cnt[0]__0[8]} {beam_cnt[0]__0[9]} {beam_cnt[0]__0[10]} {beam_cnt[0]__0[11]} {beam_cnt[0]__0[12]} {beam_cnt[0]__0[13]} {beam_cnt[0]__0[14]} {beam_cnt[0]__0[15]} {beam_cnt[0]__0[16]} {beam_cnt[0]__0[17]} {beam_cnt[0]__0[18]} {beam_cnt[0]__0[19]} {beam_cnt[0]__0[20]} {beam_cnt[0]__0[21]} {beam_cnt[0]__0[22]} {beam_cnt[0]__0[23]} {beam_cnt[0]__0[24]} {beam_cnt[0]__0[25]} {beam_cnt[0]__0[26]} {beam_cnt[0]__0[27]} {beam_cnt[0]__0[28]} {beam_cnt[0]__0[29]} {beam_cnt[0]__0[30]} {beam_cnt[0]__0[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe34]
set_property port_width 32 [get_debug_ports u_ila_0/probe34]
connect_debug_port u_ila_0/probe34 [get_nets [list {beam_addr[1]__0[0]} {beam_addr[1]__0[1]} {beam_addr[1]__0[2]} {beam_addr[1]__0[3]} {beam_addr[1]__0[4]} {beam_addr[1]__0[5]} {beam_addr[1]__0[6]} {beam_addr[1]__0[7]} {beam_addr[1]__0[8]} {beam_addr[1]__0[9]} {beam_addr[1]__0[10]} {beam_addr[1]__0[11]} {beam_addr[1]__0[12]} {beam_addr[1]__0[13]} {beam_addr[1]__0[14]} {beam_addr[1]__0[15]} {beam_addr[1]__0[16]} {beam_addr[1]__0[17]} {beam_addr[1]__0[18]} {beam_addr[1]__0[19]} {beam_addr[1]__0[20]} {beam_addr[1]__0[21]} {beam_addr[1]__0[22]} {beam_addr[1]__0[23]} {beam_addr[1]__0[24]} {beam_addr[1]__0[25]} {beam_addr[1]__0[26]} {beam_addr[1]__0[27]} {beam_addr[1]__0[28]} {beam_addr[1]__0[29]} {beam_addr[1]__0[30]} {beam_addr[1]__0[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe35]
set_property port_width 4 [get_debug_ports u_ila_0/probe35]
connect_debug_port u_ila_0/probe35 [get_nets [list {busy__0[0]} {busy__0[1]} {busy__0[2]} {busy__0[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe36]
set_property port_width 64 [get_debug_ports u_ila_0/probe36]
connect_debug_port u_ila_0/probe36 [get_nets [list {beam_data_or[0]} {beam_data_or[1]} {beam_data_or[2]} {beam_data_or[3]} {beam_data_or[4]} {beam_data_or[5]} {beam_data_or[6]} {beam_data_or[7]} {beam_data_or[8]} {beam_data_or[9]} {beam_data_or[10]} {beam_data_or[11]} {beam_data_or[12]} {beam_data_or[13]} {beam_data_or[14]} {beam_data_or[15]} {beam_data_or[16]} {beam_data_or[17]} {beam_data_or[18]} {beam_data_or[19]} {beam_data_or[20]} {beam_data_or[21]} {beam_data_or[22]} {beam_data_or[23]} {beam_data_or[24]} {beam_data_or[25]} {beam_data_or[26]} {beam_data_or[27]} {beam_data_or[28]} {beam_data_or[29]} {beam_data_or[30]} {beam_data_or[31]} {beam_data_or[32]} {beam_data_or[33]} {beam_data_or[34]} {beam_data_or[35]} {beam_data_or[36]} {beam_data_or[37]} {beam_data_or[38]} {beam_data_or[39]} {beam_data_or[40]} {beam_data_or[41]} {beam_data_or[42]} {beam_data_or[43]} {beam_data_or[44]} {beam_data_or[45]} {beam_data_or[46]} {beam_data_or[47]} {beam_data_or[48]} {beam_data_or[49]} {beam_data_or[50]} {beam_data_or[51]} {beam_data_or[52]} {beam_data_or[53]} {beam_data_or[54]} {beam_data_or[55]} {beam_data_or[56]} {beam_data_or[57]} {beam_data_or[58]} {beam_data_or[59]} {beam_data_or[60]} {beam_data_or[61]} {beam_data_or[62]} {beam_data_or[63]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe37]
set_property port_width 64 [get_debug_ports u_ila_0/probe37]
connect_debug_port u_ila_0/probe37 [get_nets [list {beam_data[1]__0[0]} {beam_data[1]__0[1]} {beam_data[1]__0[2]} {beam_data[1]__0[3]} {beam_data[1]__0[4]} {beam_data[1]__0[5]} {beam_data[1]__0[6]} {beam_data[1]__0[7]} {beam_data[1]__0[8]} {beam_data[1]__0[9]} {beam_data[1]__0[10]} {beam_data[1]__0[11]} {beam_data[1]__0[12]} {beam_data[1]__0[13]} {beam_data[1]__0[14]} {beam_data[1]__0[15]} {beam_data[1]__0[16]} {beam_data[1]__0[17]} {beam_data[1]__0[18]} {beam_data[1]__0[19]} {beam_data[1]__0[20]} {beam_data[1]__0[21]} {beam_data[1]__0[22]} {beam_data[1]__0[23]} {beam_data[1]__0[24]} {beam_data[1]__0[25]} {beam_data[1]__0[26]} {beam_data[1]__0[27]} {beam_data[1]__0[28]} {beam_data[1]__0[29]} {beam_data[1]__0[30]} {beam_data[1]__0[31]} {beam_data[1]__0[32]} {beam_data[1]__0[33]} {beam_data[1]__0[34]} {beam_data[1]__0[35]} {beam_data[1]__0[36]} {beam_data[1]__0[37]} {beam_data[1]__0[38]} {beam_data[1]__0[39]} {beam_data[1]__0[40]} {beam_data[1]__0[41]} {beam_data[1]__0[42]} {beam_data[1]__0[43]} {beam_data[1]__0[44]} {beam_data[1]__0[45]} {beam_data[1]__0[46]} {beam_data[1]__0[47]} {beam_data[1]__0[48]} {beam_data[1]__0[49]} {beam_data[1]__0[50]} {beam_data[1]__0[51]} {beam_data[1]__0[52]} {beam_data[1]__0[53]} {beam_data[1]__0[54]} {beam_data[1]__0[55]} {beam_data[1]__0[56]} {beam_data[1]__0[57]} {beam_data[1]__0[58]} {beam_data[1]__0[59]} {beam_data[1]__0[60]} {beam_data[1]__0[61]} {beam_data[1]__0[62]} {beam_data[1]__0[63]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe38]
set_property port_width 64 [get_debug_ports u_ila_0/probe38]
connect_debug_port u_ila_0/probe38 [get_nets [list {beam_data[0]__0[0]} {beam_data[0]__0[1]} {beam_data[0]__0[2]} {beam_data[0]__0[3]} {beam_data[0]__0[4]} {beam_data[0]__0[5]} {beam_data[0]__0[6]} {beam_data[0]__0[7]} {beam_data[0]__0[8]} {beam_data[0]__0[9]} {beam_data[0]__0[10]} {beam_data[0]__0[11]} {beam_data[0]__0[12]} {beam_data[0]__0[13]} {beam_data[0]__0[14]} {beam_data[0]__0[15]} {beam_data[0]__0[16]} {beam_data[0]__0[17]} {beam_data[0]__0[18]} {beam_data[0]__0[19]} {beam_data[0]__0[20]} {beam_data[0]__0[21]} {beam_data[0]__0[22]} {beam_data[0]__0[23]} {beam_data[0]__0[24]} {beam_data[0]__0[25]} {beam_data[0]__0[26]} {beam_data[0]__0[27]} {beam_data[0]__0[28]} {beam_data[0]__0[29]} {beam_data[0]__0[30]} {beam_data[0]__0[31]} {beam_data[0]__0[32]} {beam_data[0]__0[33]} {beam_data[0]__0[34]} {beam_data[0]__0[35]} {beam_data[0]__0[36]} {beam_data[0]__0[37]} {beam_data[0]__0[38]} {beam_data[0]__0[39]} {beam_data[0]__0[40]} {beam_data[0]__0[41]} {beam_data[0]__0[42]} {beam_data[0]__0[43]} {beam_data[0]__0[44]} {beam_data[0]__0[45]} {beam_data[0]__0[46]} {beam_data[0]__0[47]} {beam_data[0]__0[48]} {beam_data[0]__0[49]} {beam_data[0]__0[50]} {beam_data[0]__0[51]} {beam_data[0]__0[52]} {beam_data[0]__0[53]} {beam_data[0]__0[54]} {beam_data[0]__0[55]} {beam_data[0]__0[56]} {beam_data[0]__0[57]} {beam_data[0]__0[58]} {beam_data[0]__0[59]} {beam_data[0]__0[60]} {beam_data[0]__0[61]} {beam_data[0]__0[62]} {beam_data[0]__0[63]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe39]
set_property port_width 32 [get_debug_ports u_ila_0/probe39]
connect_debug_port u_ila_0/probe39 [get_nets [list {beam_addr[0]__0[0]} {beam_addr[0]__0[1]} {beam_addr[0]__0[2]} {beam_addr[0]__0[3]} {beam_addr[0]__0[4]} {beam_addr[0]__0[5]} {beam_addr[0]__0[6]} {beam_addr[0]__0[7]} {beam_addr[0]__0[8]} {beam_addr[0]__0[9]} {beam_addr[0]__0[10]} {beam_addr[0]__0[11]} {beam_addr[0]__0[12]} {beam_addr[0]__0[13]} {beam_addr[0]__0[14]} {beam_addr[0]__0[15]} {beam_addr[0]__0[16]} {beam_addr[0]__0[17]} {beam_addr[0]__0[18]} {beam_addr[0]__0[19]} {beam_addr[0]__0[20]} {beam_addr[0]__0[21]} {beam_addr[0]__0[22]} {beam_addr[0]__0[23]} {beam_addr[0]__0[24]} {beam_addr[0]__0[25]} {beam_addr[0]__0[26]} {beam_addr[0]__0[27]} {beam_addr[0]__0[28]} {beam_addr[0]__0[29]} {beam_addr[0]__0[30]} {beam_addr[0]__0[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe40]
set_property port_width 32 [get_debug_ports u_ila_0/probe40]
connect_debug_port u_ila_0/probe40 [get_nets [list {rd_addr[0]} {rd_addr[1]} {rd_addr[2]} {rd_addr[3]} {rd_addr[4]} {rd_addr[5]} {rd_addr[6]} {rd_addr[7]} {rd_addr[8]} {rd_addr[9]} {rd_addr[10]} {rd_addr[11]} {rd_addr[12]} {rd_addr[13]} {rd_addr[14]} {rd_addr[15]} {rd_addr[16]} {rd_addr[17]} {rd_addr[18]} {rd_addr[19]} {rd_addr[20]} {rd_addr[21]} {rd_addr[22]} {rd_addr[23]} {rd_addr[24]} {rd_addr[25]} {rd_addr[26]} {rd_addr[27]} {rd_addr[28]} {rd_addr[29]} {rd_addr[30]} {rd_addr[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe41]
set_property port_width 64 [get_debug_ports u_ila_0/probe41]
connect_debug_port u_ila_0/probe41 [get_nets [list {rd_data[0]__0[0]} {rd_data[0]__0[1]} {rd_data[0]__0[2]} {rd_data[0]__0[3]} {rd_data[0]__0[4]} {rd_data[0]__0[5]} {rd_data[0]__0[6]} {rd_data[0]__0[7]} {rd_data[0]__0[8]} {rd_data[0]__0[9]} {rd_data[0]__0[10]} {rd_data[0]__0[11]} {rd_data[0]__0[12]} {rd_data[0]__0[13]} {rd_data[0]__0[14]} {rd_data[0]__0[15]} {rd_data[0]__0[16]} {rd_data[0]__0[17]} {rd_data[0]__0[18]} {rd_data[0]__0[19]} {rd_data[0]__0[20]} {rd_data[0]__0[21]} {rd_data[0]__0[22]} {rd_data[0]__0[23]} {rd_data[0]__0[24]} {rd_data[0]__0[25]} {rd_data[0]__0[26]} {rd_data[0]__0[27]} {rd_data[0]__0[28]} {rd_data[0]__0[29]} {rd_data[0]__0[30]} {rd_data[0]__0[31]} {rd_data[0]__0[32]} {rd_data[0]__0[33]} {rd_data[0]__0[34]} {rd_data[0]__0[35]} {rd_data[0]__0[36]} {rd_data[0]__0[37]} {rd_data[0]__0[38]} {rd_data[0]__0[39]} {rd_data[0]__0[40]} {rd_data[0]__0[41]} {rd_data[0]__0[42]} {rd_data[0]__0[43]} {rd_data[0]__0[44]} {rd_data[0]__0[45]} {rd_data[0]__0[46]} {rd_data[0]__0[47]} {rd_data[0]__0[48]} {rd_data[0]__0[49]} {rd_data[0]__0[50]} {rd_data[0]__0[51]} {rd_data[0]__0[52]} {rd_data[0]__0[53]} {rd_data[0]__0[54]} {rd_data[0]__0[55]} {rd_data[0]__0[56]} {rd_data[0]__0[57]} {rd_data[0]__0[58]} {rd_data[0]__0[59]} {rd_data[0]__0[60]} {rd_data[0]__0[61]} {rd_data[0]__0[62]} {rd_data[0]__0[63]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe42]
set_property port_width 64 [get_debug_ports u_ila_0/probe42]
connect_debug_port u_ila_0/probe42 [get_nets [list {rd_data[2]__0[0]} {rd_data[2]__0[1]} {rd_data[2]__0[2]} {rd_data[2]__0[3]} {rd_data[2]__0[4]} {rd_data[2]__0[5]} {rd_data[2]__0[6]} {rd_data[2]__0[7]} {rd_data[2]__0[8]} {rd_data[2]__0[9]} {rd_data[2]__0[10]} {rd_data[2]__0[11]} {rd_data[2]__0[12]} {rd_data[2]__0[13]} {rd_data[2]__0[14]} {rd_data[2]__0[15]} {rd_data[2]__0[16]} {rd_data[2]__0[17]} {rd_data[2]__0[18]} {rd_data[2]__0[19]} {rd_data[2]__0[20]} {rd_data[2]__0[21]} {rd_data[2]__0[22]} {rd_data[2]__0[23]} {rd_data[2]__0[24]} {rd_data[2]__0[25]} {rd_data[2]__0[26]} {rd_data[2]__0[27]} {rd_data[2]__0[28]} {rd_data[2]__0[29]} {rd_data[2]__0[30]} {rd_data[2]__0[31]} {rd_data[2]__0[32]} {rd_data[2]__0[33]} {rd_data[2]__0[34]} {rd_data[2]__0[35]} {rd_data[2]__0[36]} {rd_data[2]__0[37]} {rd_data[2]__0[38]} {rd_data[2]__0[39]} {rd_data[2]__0[40]} {rd_data[2]__0[41]} {rd_data[2]__0[42]} {rd_data[2]__0[43]} {rd_data[2]__0[44]} {rd_data[2]__0[45]} {rd_data[2]__0[46]} {rd_data[2]__0[47]} {rd_data[2]__0[48]} {rd_data[2]__0[49]} {rd_data[2]__0[50]} {rd_data[2]__0[51]} {rd_data[2]__0[52]} {rd_data[2]__0[53]} {rd_data[2]__0[54]} {rd_data[2]__0[55]} {rd_data[2]__0[56]} {rd_data[2]__0[57]} {rd_data[2]__0[58]} {rd_data[2]__0[59]} {rd_data[2]__0[60]} {rd_data[2]__0[61]} {rd_data[2]__0[62]} {rd_data[2]__0[63]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe43]
set_property port_width 64 [get_debug_ports u_ila_0/probe43]
connect_debug_port u_ila_0/probe43 [get_nets [list {rd_data_or[0]} {rd_data_or[1]} {rd_data_or[2]} {rd_data_or[3]} {rd_data_or[4]} {rd_data_or[5]} {rd_data_or[6]} {rd_data_or[7]} {rd_data_or[8]} {rd_data_or[9]} {rd_data_or[10]} {rd_data_or[11]} {rd_data_or[12]} {rd_data_or[13]} {rd_data_or[14]} {rd_data_or[15]} {rd_data_or[16]} {rd_data_or[17]} {rd_data_or[18]} {rd_data_or[19]} {rd_data_or[20]} {rd_data_or[21]} {rd_data_or[22]} {rd_data_or[23]} {rd_data_or[24]} {rd_data_or[25]} {rd_data_or[26]} {rd_data_or[27]} {rd_data_or[28]} {rd_data_or[29]} {rd_data_or[30]} {rd_data_or[31]} {rd_data_or[32]} {rd_data_or[33]} {rd_data_or[34]} {rd_data_or[35]} {rd_data_or[36]} {rd_data_or[37]} {rd_data_or[38]} {rd_data_or[39]} {rd_data_or[40]} {rd_data_or[41]} {rd_data_or[42]} {rd_data_or[43]} {rd_data_or[44]} {rd_data_or[45]} {rd_data_or[46]} {rd_data_or[47]} {rd_data_or[48]} {rd_data_or[49]} {rd_data_or[50]} {rd_data_or[51]} {rd_data_or[52]} {rd_data_or[53]} {rd_data_or[54]} {rd_data_or[55]} {rd_data_or[56]} {rd_data_or[57]} {rd_data_or[58]} {rd_data_or[59]} {rd_data_or[60]} {rd_data_or[61]} {rd_data_or[62]} {rd_data_or[63]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe44]
set_property port_width 64 [get_debug_ports u_ila_0/probe44]
connect_debug_port u_ila_0/probe44 [get_nets [list {rd_data[1]__0[0]} {rd_data[1]__0[1]} {rd_data[1]__0[2]} {rd_data[1]__0[3]} {rd_data[1]__0[4]} {rd_data[1]__0[5]} {rd_data[1]__0[6]} {rd_data[1]__0[7]} {rd_data[1]__0[8]} {rd_data[1]__0[9]} {rd_data[1]__0[10]} {rd_data[1]__0[11]} {rd_data[1]__0[12]} {rd_data[1]__0[13]} {rd_data[1]__0[14]} {rd_data[1]__0[15]} {rd_data[1]__0[16]} {rd_data[1]__0[17]} {rd_data[1]__0[18]} {rd_data[1]__0[19]} {rd_data[1]__0[20]} {rd_data[1]__0[21]} {rd_data[1]__0[22]} {rd_data[1]__0[23]} {rd_data[1]__0[24]} {rd_data[1]__0[25]} {rd_data[1]__0[26]} {rd_data[1]__0[27]} {rd_data[1]__0[28]} {rd_data[1]__0[29]} {rd_data[1]__0[30]} {rd_data[1]__0[31]} {rd_data[1]__0[32]} {rd_data[1]__0[33]} {rd_data[1]__0[34]} {rd_data[1]__0[35]} {rd_data[1]__0[36]} {rd_data[1]__0[37]} {rd_data[1]__0[38]} {rd_data[1]__0[39]} {rd_data[1]__0[40]} {rd_data[1]__0[41]} {rd_data[1]__0[42]} {rd_data[1]__0[43]} {rd_data[1]__0[44]} {rd_data[1]__0[45]} {rd_data[1]__0[46]} {rd_data[1]__0[47]} {rd_data[1]__0[48]} {rd_data[1]__0[49]} {rd_data[1]__0[50]} {rd_data[1]__0[51]} {rd_data[1]__0[52]} {rd_data[1]__0[53]} {rd_data[1]__0[54]} {rd_data[1]__0[55]} {rd_data[1]__0[56]} {rd_data[1]__0[57]} {rd_data[1]__0[58]} {rd_data[1]__0[59]} {rd_data[1]__0[60]} {rd_data[1]__0[61]} {rd_data[1]__0[62]} {rd_data[1]__0[63]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe45]
set_property port_width 32 [get_debug_ports u_ila_0/probe45]
connect_debug_port u_ila_0/probe45 [get_nets [list {wr_addr[0]} {wr_addr[1]} {wr_addr[2]} {wr_addr[3]} {wr_addr[4]} {wr_addr[5]} {wr_addr[6]} {wr_addr[7]} {wr_addr[8]} {wr_addr[9]} {wr_addr[10]} {wr_addr[11]} {wr_addr[12]} {wr_addr[13]} {wr_addr[14]} {wr_addr[15]} {wr_addr[16]} {wr_addr[17]} {wr_addr[18]} {wr_addr[19]} {wr_addr[20]} {wr_addr[21]} {wr_addr[22]} {wr_addr[23]} {wr_addr[24]} {wr_addr[25]} {wr_addr[26]} {wr_addr[27]} {wr_addr[28]} {wr_addr[29]} {wr_addr[30]} {wr_addr[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe46]
set_property port_width 10 [get_debug_ports u_ila_0/probe46]
connect_debug_port u_ila_0/probe46 [get_nets [list {req_len[0]} {req_len[1]} {req_len[2]} {req_len[3]} {req_len[4]} {req_len[5]} {req_len[6]} {req_len[7]} {req_len[8]} {req_len[9]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe47]
set_property port_width 10 [get_debug_ports u_ila_0/probe47]
connect_debug_port u_ila_0/probe47 [get_nets [list {wr_req_len[0]} {wr_req_len[1]} {wr_req_len[2]} {wr_req_len[3]} {wr_req_len[4]} {wr_req_len[5]} {wr_req_len[6]} {wr_req_len[7]} {wr_req_len[8]} {wr_req_len[9]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe48]
set_property port_width 64 [get_debug_ports u_ila_0/probe48]
connect_debug_port u_ila_0/probe48 [get_nets [list {wr_data[0]} {wr_data[1]} {wr_data[2]} {wr_data[3]} {wr_data[4]} {wr_data[5]} {wr_data[6]} {wr_data[7]} {wr_data[8]} {wr_data[9]} {wr_data[10]} {wr_data[11]} {wr_data[12]} {wr_data[13]} {wr_data[14]} {wr_data[15]} {wr_data[16]} {wr_data[17]} {wr_data[18]} {wr_data[19]} {wr_data[20]} {wr_data[21]} {wr_data[22]} {wr_data[23]} {wr_data[24]} {wr_data[25]} {wr_data[26]} {wr_data[27]} {wr_data[28]} {wr_data[29]} {wr_data[30]} {wr_data[31]} {wr_data[32]} {wr_data[33]} {wr_data[34]} {wr_data[35]} {wr_data[36]} {wr_data[37]} {wr_data[38]} {wr_data[39]} {wr_data[40]} {wr_data[41]} {wr_data[42]} {wr_data[43]} {wr_data[44]} {wr_data[45]} {wr_data[46]} {wr_data[47]} {wr_data[48]} {wr_data[49]} {wr_data[50]} {wr_data[51]} {wr_data[52]} {wr_data[53]} {wr_data[54]} {wr_data[55]} {wr_data[56]} {wr_data[57]} {wr_data[58]} {wr_data[59]} {wr_data[60]} {wr_data[61]} {wr_data[62]} {wr_data[63]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe49]
set_property port_width 1 [get_debug_ports u_ila_0/probe49]
connect_debug_port u_ila_0/probe49 [get_nets [list bar_hit]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe50]
set_property port_width 1 [get_debug_ports u_ila_0/probe50]
connect_debug_port u_ila_0/probe50 [get_nets [list {beam[0]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe51]
set_property port_width 1 [get_debug_ports u_ila_0/probe51]
connect_debug_port u_ila_0/probe51 [get_nets [list {beam[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe52]
set_property port_width 1 [get_debug_ports u_ila_0/probe52]
connect_debug_port u_ila_0/probe52 [get_nets [list beam_or]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe53]
set_property port_width 1 [get_debug_ports u_ila_0/probe53]
connect_debug_port u_ila_0/probe53 [get_nets [list beam_prep_or]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe54]
set_property port_width 1 [get_debug_ports u_ila_0/probe54]
connect_debug_port u_ila_0/probe54 [get_nets [list beaming_in_progress]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe55]
set_property port_width 1 [get_debug_ports u_ila_0/probe55]
connect_debug_port u_ila_0/probe55 [get_nets [list busy_or]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe56]
set_property port_width 1 [get_debug_ports u_ila_0/probe56]
connect_debug_port u_ila_0/probe56 [get_nets [list pcie_/app/PIO/PIO_EP_inst/compl_done_w]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe57]
set_property port_width 1 [get_debug_ports u_ila_0/probe57]
connect_debug_port u_ila_0/probe57 [get_nets [list fc/den_w]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe58]
set_property port_width 1 [get_debug_ports u_ila_0/probe58]
connect_debug_port u_ila_0/probe58 [get_nets [list pcie_/eng_busy_ext]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe59]
set_property port_width 1 [get_debug_ports u_ila_0/probe59]
connect_debug_port u_ila_0/probe59 [get_nets [list pcie_/app/PIO/PIO_EP_inst/eng_busy_w]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe60]
set_property port_width 1 [get_debug_ports u_ila_0/probe60]
connect_debug_port u_ila_0/probe60 [get_nets [list fc/floe_w]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe61]
set_property port_width 1 [get_debug_ports u_ila_0/probe61]
connect_debug_port u_ila_0/probe61 [get_nets [list fc/flrst_w]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe62]
set_property port_width 1 [get_debug_ports u_ila_0/probe62]
connect_debug_port u_ila_0/probe62 [get_nets [list fc/flwe_w]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe63]
set_property port_width 1 [get_debug_ports u_ila_0/probe63]
connect_debug_port u_ila_0/probe63 [get_nets [list lb/loopback_beam_w]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe64]
set_property port_width 1 [get_debug_ports u_ila_0/probe64]
connect_debug_port u_ila_0/probe64 [get_nets [list pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tlast_w]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe65]
set_property port_width 1 [get_debug_ports u_ila_0/probe65]
connect_debug_port u_ila_0/probe65 [get_nets [list pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tready_w]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe66]
set_property port_width 1 [get_debug_ports u_ila_0/probe66]
connect_debug_port u_ila_0/probe66 [get_nets [list pcie_/app/PIO/PIO_EP_inst/m_axis_rx_tvalid_w]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe67]
set_property port_width 1 [get_debug_ports u_ila_0/probe67]
connect_debug_port u_ila_0/probe67 [get_nets [list pcie_/app/PIO/PIO_EP_inst/EP_TX_inst/one_more_tlp_w]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe68]
set_property port_width 1 [get_debug_ports u_ila_0/probe68]
connect_debug_port u_ila_0/probe68 [get_nets [list pcie_rst_n]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe69]
set_property port_width 1 [get_debug_ports u_ila_0/probe69]
connect_debug_port u_ila_0/probe69 [get_nets [list rd_en]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe70]
set_property port_width 1 [get_debug_ports u_ila_0/probe70]
connect_debug_port u_ila_0/probe70 [get_nets [list req_compl]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe71]
set_property port_width 1 [get_debug_ports u_ila_0/probe71]
connect_debug_port u_ila_0/probe71 [get_nets [list pcie_/app/PIO/PIO_EP_inst/req_compl_w]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe72]
set_property port_width 1 [get_debug_ports u_ila_0/probe72]
connect_debug_port u_ila_0/probe72 [get_nets [list pcie_/app/PIO/PIO_EP_inst/req_compl_wd]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe73]
set_property port_width 1 [get_debug_ports u_ila_0/probe73]
connect_debug_port u_ila_0/probe73 [get_nets [list pcie_/app/PIO/PIO_EP_inst/req_ep]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe74]
set_property port_width 1 [get_debug_ports u_ila_0/probe74]
connect_debug_port u_ila_0/probe74 [get_nets [list pcie_/app/PIO/PIO_EP_inst/req_td]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe75]
set_property port_width 1 [get_debug_ports u_ila_0/probe75]
connect_debug_port u_ila_0/probe75 [get_nets [list pcie_/app/PIO/PIO_EP_inst/s_axis_tx_tlast_w]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe76]
set_property port_width 1 [get_debug_ports u_ila_0/probe76]
connect_debug_port u_ila_0/probe76 [get_nets [list pcie_/app/PIO/PIO_EP_inst/s_axis_tx_tready_w]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe77]
set_property port_width 1 [get_debug_ports u_ila_0/probe77]
connect_debug_port u_ila_0/probe77 [get_nets [list pcie_/app/PIO/PIO_EP_inst/s_axis_tx_tvalid_w]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe78]
set_property port_width 1 [get_debug_ports u_ila_0/probe78]
connect_debug_port u_ila_0/probe78 [get_nets [list pcie_/tx_cfg_gnt_w]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe79]
set_property port_width 1 [get_debug_ports u_ila_0/probe79]
connect_debug_port u_ila_0/probe79 [get_nets [list pcie_/tx_cfg_req]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe80]
set_property port_width 1 [get_debug_ports u_ila_0/probe80]
connect_debug_port u_ila_0/probe80 [get_nets [list wr_addr_valid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe81]
set_property port_width 1 [get_debug_ports u_ila_0/probe81]
connect_debug_port u_ila_0/probe81 [get_nets [list wr_en]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets pcie_clk_OBUF]
