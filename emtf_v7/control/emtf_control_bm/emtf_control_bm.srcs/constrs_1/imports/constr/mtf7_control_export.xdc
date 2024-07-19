#-*-tcl-*-

# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:2
create_clock -period 20.000 -name clk40_p [get_ports clk40_p]

# actually 250 M
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:6
create_clock -period 4.000 -name clk50_p [get_ports clk50_p]

# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:9
create_clock -period 8 -name ext_clk_in [get_ports ext_clk_in]

# The following cross clock domain false path constraints can be uncommented in order to mimic ucf constraints behavior (see message at the beginning of this file)
set_false_path -from [get_clocks sys_clk] -to [get_clocks {clk40_p clk50_p ext_clk_in}]
#set_false_path -from [get_clocks clk_250mhz] -to [get_clocks [list clk40_p clk50_p ext_clk_in]]
#set_false_path -from [get_clocks clk_125mhz] -to [get_clocks [list clk40_p clk50_p ext_clk_in]]
set_false_path -from [get_clocks userclk1] -to [get_clocks {clk40_p clk50_p ext_clk_in}]
#set_false_path -from [get_clocks userclk2] -to [get_clocks [list clk40_p clk50_p ext_clk_in]]
set_false_path -from [get_clocks clk40_p] -to [get_clocks {sys_clk userclk1 clk50_p ext_clk_in}]
set_false_path -from [get_clocks clk50_p] -to [get_clocks {sys_clk userclk1 clk40_p ext_clk_in}]
set_false_path -from [get_clocks ext_clk_in] -to [get_clocks {sys_clk userclk1 clk40_p clk50_p}]
set_false_path -from [get_clocks clk_125M_ctoc_mmcm_in] -to [get_clocks clk_125M_ctoc_mmcm]
set_false_path -from [get_clocks clk_125M_ctoc_mmcm] -to [get_clocks clk_125M_ctoc_mmcm_in]


# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:12
# The conversion of 'IOSTANDARD' constraint on 'net' object 'clk50_p' has been applied to the port object 'clk50_p'.
set_property IOSTANDARD LVDS [get_ports clk50_p]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:13
# The conversion of 'DIFF_TERM' constraint on 'net' object 'clk50_p' has been applied to the port object 'clk50_p'.
set_property DIFF_TERM TRUE [get_ports clk50_p]
set_property PACKAGE_PIN AA2 [get_ports clk50_n]
set_property PACKAGE_PIN AA3 [get_ports clk50_p]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:15
# The conversion of 'IOSTANDARD' constraint on 'net' object 'clk50_n' has been applied to the port object 'clk50_n'.
set_property IOSTANDARD LVDS [get_ports clk50_n]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:16
# The conversion of 'DIFF_TERM' constraint on 'net' object 'clk50_n' has been applied to the port object 'clk50_n'.
set_property DIFF_TERM TRUE [get_ports clk50_n]

#//NET clk40_p LOC = F17  | IOSTANDARD = LVDS_25;
#//NET clk40_n LOC = E17  | IOSTANDARD = LVDS_25;
set_property PACKAGE_PIN K5 [get_ports clk40_n]
set_property PACKAGE_PIN K6 [get_ports clk40_p]

set_property PACKAGE_PIN F17 [get_ports {z[0]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:24
# The conversion of 'IOSTANDARD' constraint on 'net' object 'z[0]' has been applied to the port object 'z[0]'.
set_property IOSTANDARD LVCMOS18 [get_ports {z[0]}]
set_property PACKAGE_PIN E17 [get_ports {z[1]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:26
# The conversion of 'IOSTANDARD' constraint on 'net' object 'z[1]' has been applied to the port object 'z[1]'.
set_property IOSTANDARD LVCMOS18 [get_ports {z[1]}]

set_property PACKAGE_PIN AC1 [get_ports s_clk]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:41
# The conversion of 'IOSTANDARD' constraint on 'net' object 'a_clk' has been applied to the port object 'a_clk'.
set_property IOSTANDARD LVCMOS18 [get_ports s_clk]
set_property PACKAGE_PIN AB6 [get_ports s_data]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:43
# The conversion of 'IOSTANDARD' constraint on 'net' object 'a_data' has been applied to the port object 'a_data'.
set_property IOSTANDARD LVCMOS18 [get_ports s_data]
set_property PACKAGE_PIN AB5 [get_ports s_le]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:45
# The conversion of 'IOSTANDARD' constraint on 'net' object 'a_le' has been applied to the port object 'a_le'.
set_property IOSTANDARD LVCMOS18 [get_ports s_le]
set_property PACKAGE_PIN AE2 [get_ports s_lock]
set_property IOSTANDARD LVCMOS18 [get_ports s_lock]
set_property PACKAGE_PIN AD3 [get_ports s_sync]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:49
# The conversion of 'IOSTANDARD' constraint on 'net' object 'a_sync' has been applied to the port object 'a_sync'.
set_property IOSTANDARD LVCMOS18 [get_ports s_sync]
set_property PACKAGE_PIN AF2 [get_ports s_hold]
set_property IOSTANDARD LVCMOS18 [get_ports s_hold]
set_property PACKAGE_PIN AF3 [get_ports s_los]
set_property IOSTANDARD LVCMOS18 [get_ports s_los]

# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:56
# The conversion of 'IOSTANDARD' constraint on 'net' object 'lhc_clk_p' has been applied to the port object 'lhc_clk_p'.
set_property IOSTANDARD LVDS [get_ports lhc_clk_p]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:57
# The conversion of 'DIFF_TERM' constraint on 'net' object 'lhc_clk_p' has been applied to the port object 'lhc_clk_p'.
set_property DIFF_TERM TRUE [get_ports lhc_clk_p]
set_property PACKAGE_PIN AB4 [get_ports lhc_clk_n]
set_property PACKAGE_PIN AA4 [get_ports lhc_clk_p]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:59
# The conversion of 'IOSTANDARD' constraint on 'net' object 'lhc_clk_n' has been applied to the port object 'lhc_clk_n'.
set_property IOSTANDARD LVDS [get_ports lhc_clk_n]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:60
# The conversion of 'DIFF_TERM' constraint on 'net' object 'lhc_clk_n' has been applied to the port object 'lhc_clk_n'.
set_property DIFF_TERM TRUE [get_ports lhc_clk_n]

# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:63
# The conversion of 'IOSTANDARD' constraint on 'net' object 'bpclk_p' has been applied to the port object 'bpclk_p'.
set_property IOSTANDARD LVDS [get_ports bpclk_p]
set_property PACKAGE_PIN AE1 [get_ports bpclk_n]
set_property PACKAGE_PIN AD1 [get_ports bpclk_p]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:65
# The conversion of 'IOSTANDARD' constraint on 'net' object 'bpclk_n' has been applied to the port object 'bpclk_n'.
set_property IOSTANDARD LVDS [get_ports bpclk_n]


set_property PACKAGE_PIN B24 [get_ports {fldq[0]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:70
# The conversion of 'IOSTANDARD' constraint on 'net' object 'fldq[0]' has been applied to the port object 'fldq[0]'.
set_property IOSTANDARD LVCMOS18 [get_ports {fldq[0]}]
set_property PACKAGE_PIN A25 [get_ports {fldq[1]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:73
# The conversion of 'IOSTANDARD' constraint on 'net' object 'fldq[1]' has been applied to the port object 'fldq[1]'.
set_property IOSTANDARD LVCMOS18 [get_ports {fldq[1]}]
set_property PACKAGE_PIN B22 [get_ports {fldq[2]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:76
# The conversion of 'IOSTANDARD' constraint on 'net' object 'fldq[2]' has been applied to the port object 'fldq[2]'.
set_property IOSTANDARD LVCMOS18 [get_ports {fldq[2]}]
set_property PACKAGE_PIN A22 [get_ports {fldq[3]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:79
# The conversion of 'IOSTANDARD' constraint on 'net' object 'fldq[3]' has been applied to the port object 'fldq[3]'.
set_property IOSTANDARD LVCMOS18 [get_ports {fldq[3]}]
set_property PACKAGE_PIN A23 [get_ports {fldq[4]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:82
# The conversion of 'IOSTANDARD' constraint on 'net' object 'fldq[4]' has been applied to the port object 'fldq[4]'.
set_property IOSTANDARD LVCMOS18 [get_ports {fldq[4]}]
set_property PACKAGE_PIN A24 [get_ports {fldq[5]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:85
# The conversion of 'IOSTANDARD' constraint on 'net' object 'fldq[5]' has been applied to the port object 'fldq[5]'.
set_property IOSTANDARD LVCMOS18 [get_ports {fldq[5]}]
set_property PACKAGE_PIN D26 [get_ports {fldq[6]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:88
# The conversion of 'IOSTANDARD' constraint on 'net' object 'fldq[6]' has been applied to the port object 'fldq[6]'.
set_property IOSTANDARD LVCMOS18 [get_ports {fldq[6]}]
set_property PACKAGE_PIN C26 [get_ports {fldq[7]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:91
# The conversion of 'IOSTANDARD' constraint on 'net' object 'fldq[7]' has been applied to the port object 'fldq[7]'.
set_property IOSTANDARD LVCMOS18 [get_ports {fldq[7]}]
set_property PACKAGE_PIN C23 [get_ports flce]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:93
# The conversion of 'IOSTANDARD' constraint on 'net' object 'flce' has been applied to the port object 'flce'.
set_property IOSTANDARD LVCMOS18 [get_ports flce]
set_property PACKAGE_PIN C24 [get_ports {fldq[8]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:96
# The conversion of 'IOSTANDARD' constraint on 'net' object 'fldq[8]' has been applied to the port object 'fldq[8]'.
set_property IOSTANDARD LVCMOS18 [get_ports {fldq[8]}]
set_property PACKAGE_PIN D21 [get_ports {fldq[9]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:99
# The conversion of 'IOSTANDARD' constraint on 'net' object 'fldq[9]' has been applied to the port object 'fldq[9]'.
set_property IOSTANDARD LVCMOS18 [get_ports {fldq[9]}]
set_property PACKAGE_PIN C22 [get_ports {fldq[10]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:102
# The conversion of 'IOSTANDARD' constraint on 'net' object 'fldq[10]' has been applied to the port object 'fldq[10]'.
set_property IOSTANDARD LVCMOS18 [get_ports {fldq[10]}]
set_property PACKAGE_PIN B20 [get_ports {fldq[11]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:105
# The conversion of 'IOSTANDARD' constraint on 'net' object 'fldq[11]' has been applied to the port object 'fldq[11]'.
set_property IOSTANDARD LVCMOS18 [get_ports {fldq[11]}]
set_property PACKAGE_PIN A20 [get_ports {fldq[12]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:108
# The conversion of 'IOSTANDARD' constraint on 'net' object 'fldq[12]' has been applied to the port object 'fldq[12]'.
set_property IOSTANDARD LVCMOS18 [get_ports {fldq[12]}]
set_property PACKAGE_PIN E22 [get_ports {fldq[13]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:111
# The conversion of 'IOSTANDARD' constraint on 'net' object 'fldq[13]' has been applied to the port object 'fldq[13]'.
set_property IOSTANDARD LVCMOS18 [get_ports {fldq[13]}]
set_property PACKAGE_PIN C21 [get_ports {fldq[14]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:114
# The conversion of 'IOSTANDARD' constraint on 'net' object 'fldq[14]' has been applied to the port object 'fldq[14]'.
set_property IOSTANDARD LVCMOS18 [get_ports {fldq[14]}]
set_property PACKAGE_PIN B21 [get_ports {fldq[15]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:117
# The conversion of 'IOSTANDARD' constraint on 'net' object 'fldq[15]' has been applied to the port object 'fldq[15]'.
set_property IOSTANDARD LVCMOS18 [get_ports {fldq[15]}]
set_property PACKAGE_PIN G26 [get_ports {fla[16]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:119
# The conversion of 'IOSTANDARD' constraint on 'net' object 'fla[16]' has been applied to the port object 'fla[16]'.
set_property IOSTANDARD LVCMOS18 [get_ports {fla[16]}]
set_property PACKAGE_PIN F25 [get_ports {fla[15]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:121
# The conversion of 'IOSTANDARD' constraint on 'net' object 'fla[15]' has been applied to the port object 'fla[15]'.
set_property IOSTANDARD LVCMOS18 [get_ports {fla[15]}]
set_property PACKAGE_PIN E26 [get_ports {fla[14]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:123
# The conversion of 'IOSTANDARD' constraint on 'net' object 'fla[14]' has been applied to the port object 'fla[14]'.
set_property IOSTANDARD LVCMOS18 [get_ports {fla[14]}]
set_property PACKAGE_PIN J26 [get_ports {fla[13]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:125
# The conversion of 'IOSTANDARD' constraint on 'net' object 'fla[13]' has been applied to the port object 'fla[13]'.
set_property IOSTANDARD LVCMOS18 [get_ports {fla[13]}]
set_property PACKAGE_PIN H26 [get_ports {fla[12]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:127
# The conversion of 'IOSTANDARD' constraint on 'net' object 'fla[12]' has been applied to the port object 'fla[12]'.
set_property IOSTANDARD LVCMOS18 [get_ports {fla[12]}]
set_property PACKAGE_PIN H21 [get_ports {fla[11]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:129
# The conversion of 'IOSTANDARD' constraint on 'net' object 'fla[11]' has been applied to the port object 'fla[11]'.
set_property IOSTANDARD LVCMOS18 [get_ports {fla[11]}]
set_property PACKAGE_PIN G21 [get_ports {fla[10]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:131
# The conversion of 'IOSTANDARD' constraint on 'net' object 'fla[10]' has been applied to the port object 'fla[10]'.
set_property IOSTANDARD LVCMOS18 [get_ports {fla[10]}]
set_property PACKAGE_PIN H23 [get_ports {fla[9]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:133
# The conversion of 'IOSTANDARD' constraint on 'net' object 'fla[9]' has been applied to the port object 'fla[9]'.
set_property IOSTANDARD LVCMOS18 [get_ports {fla[9]}]
set_property PACKAGE_PIN H24 [get_ports {fla[8]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:135
# The conversion of 'IOSTANDARD' constraint on 'net' object 'fla[8]' has been applied to the port object 'fla[8]'.
set_property IOSTANDARD LVCMOS18 [get_ports {fla[8]}]
set_property PACKAGE_PIN H22 [get_ports {fla[7]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:137
# The conversion of 'IOSTANDARD' constraint on 'net' object 'fla[7]' has been applied to the port object 'fla[7]'.
set_property IOSTANDARD LVCMOS18 [get_ports {fla[7]}]
set_property PACKAGE_PIN J24 [get_ports {fla[6]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:139
# The conversion of 'IOSTANDARD' constraint on 'net' object 'fla[6]' has been applied to the port object 'fla[6]'.
set_property IOSTANDARD LVCMOS18 [get_ports {fla[6]}]
set_property PACKAGE_PIN J25 [get_ports {fla[5]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:141
# The conversion of 'IOSTANDARD' constraint on 'net' object 'fla[5]' has been applied to the port object 'fla[5]'.
set_property IOSTANDARD LVCMOS18 [get_ports {fla[5]}]
set_property PACKAGE_PIN L22 [get_ports {fla[4]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:143
# The conversion of 'IOSTANDARD' constraint on 'net' object 'fla[4]' has been applied to the port object 'fla[4]'.
set_property IOSTANDARD LVCMOS18 [get_ports {fla[4]}]
set_property PACKAGE_PIN K22 [get_ports {fla[3]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:145
# The conversion of 'IOSTANDARD' constraint on 'net' object 'fla[3]' has been applied to the port object 'fla[3]'.
set_property IOSTANDARD LVCMOS18 [get_ports {fla[3]}]
set_property PACKAGE_PIN K23 [get_ports {fla[2]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:147
# The conversion of 'IOSTANDARD' constraint on 'net' object 'fla[2]' has been applied to the port object 'fla[2]'.
set_property IOSTANDARD LVCMOS18 [get_ports {fla[2]}]
set_property PACKAGE_PIN J23 [get_ports {fla[1]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:149
# The conversion of 'IOSTANDARD' constraint on 'net' object 'fla[1]' has been applied to the port object 'fla[1]'.
set_property IOSTANDARD LVCMOS18 [get_ports {fla[1]}]
set_property PACKAGE_PIN C16 [get_ports flclk]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:151
# The conversion of 'IOSTANDARD' constraint on 'net' object 'flclk' has been applied to the port object 'flclk'.
set_property IOSTANDARD LVCMOS18 [get_ports flclk]
set_property PACKAGE_PIN G16 [get_ports flrst]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:153
# The conversion of 'IOSTANDARD' constraint on 'net' object 'flrst' has been applied to the port object 'flrst'.
set_property IOSTANDARD LVCMOS18 [get_ports flrst]
set_property PACKAGE_PIN D20 [get_ports fladv]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:155
# The conversion of 'IOSTANDARD' constraint on 'net' object 'fladv' has been applied to the port object 'fladv'.
set_property IOSTANDARD LVCMOS18 [get_ports fladv]
set_property PACKAGE_PIN F19 [get_ports {fla[27]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:157
# The conversion of 'IOSTANDARD' constraint on 'net' object 'fla[27]' has been applied to the port object 'fla[27]'.
set_property IOSTANDARD LVCMOS18 [get_ports {fla[27]}]
set_property PACKAGE_PIN E20 [get_ports {fla[26]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:159
# The conversion of 'IOSTANDARD' constraint on 'net' object 'fla[26]' has been applied to the port object 'fla[26]'.
set_property IOSTANDARD LVCMOS18 [get_ports {fla[26]}]
set_property PACKAGE_PIN H19 [get_ports {fla[25]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:161
# The conversion of 'IOSTANDARD' constraint on 'net' object 'fla[25]' has been applied to the port object 'fla[25]'.
set_property IOSTANDARD LVCMOS18 [get_ports {fla[25]}]
set_property PACKAGE_PIN G20 [get_ports {fla[24]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:163
# The conversion of 'IOSTANDARD' constraint on 'net' object 'fla[24]' has been applied to the port object 'fla[24]'.
set_property IOSTANDARD LVCMOS18 [get_ports {fla[24]}]
set_property PACKAGE_PIN K20 [get_ports {fla[23]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:165
# The conversion of 'IOSTANDARD' constraint on 'net' object 'fla[23]' has been applied to the port object 'fla[23]'.
set_property IOSTANDARD LVCMOS18 [get_ports {fla[23]}]
set_property PACKAGE_PIN J20 [get_ports {fla[22]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:167
# The conversion of 'IOSTANDARD' constraint on 'net' object 'fla[22]' has been applied to the port object 'fla[22]'.
set_property IOSTANDARD LVCMOS18 [get_ports {fla[22]}]
set_property PACKAGE_PIN J18 [get_ports {fla[21]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:169
# The conversion of 'IOSTANDARD' constraint on 'net' object 'fla[21]' has been applied to the port object 'fla[21]'.
set_property IOSTANDARD LVCMOS18 [get_ports {fla[21]}]
set_property PACKAGE_PIN J19 [get_ports {fla[20]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:171
# The conversion of 'IOSTANDARD' constraint on 'net' object 'fla[20]' has been applied to the port object 'fla[20]'.
set_property IOSTANDARD LVCMOS18 [get_ports {fla[20]}]
set_property PACKAGE_PIN L20 [get_ports {fla[19]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:173
# The conversion of 'IOSTANDARD' constraint on 'net' object 'fla[19]' has been applied to the port object 'fla[19]'.
set_property IOSTANDARD LVCMOS18 [get_ports {fla[19]}]
set_property PACKAGE_PIN K16 [get_ports {fla[18]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:175
# The conversion of 'IOSTANDARD' constraint on 'net' object 'fla[18]' has been applied to the port object 'fla[18]'.
set_property IOSTANDARD LVCMOS18 [get_ports {fla[18]}]
set_property PACKAGE_PIN K17 [get_ports {fla[17]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:177
# The conversion of 'IOSTANDARD' constraint on 'net' object 'fla[17]' has been applied to the port object 'fla[17]'.
set_property IOSTANDARD LVCMOS18 [get_ports {fla[17]}]
set_property IOB TRUE [get_ports floe]
set_property PACKAGE_PIN M17 [get_ports floe]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:180
# The conversion of 'IOSTANDARD' constraint on 'net' object 'floe' has been applied to the port object 'floe'.
set_property IOSTANDARD LVCMOS18 [get_ports floe]
set_property IOB TRUE [get_ports flwe]
set_property PACKAGE_PIN L18 [get_ports flwe]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:183
# The conversion of 'IOSTANDARD' constraint on 'net' object 'flwe' has been applied to the port object 'flwe'.
set_property IOSTANDARD LVCMOS18 [get_ports flwe]
#NET cfdout_cso LOC = V11  | IOSTANDARD = LVCMOS18  | IOB = TRUE;
set_property PACKAGE_PIN W11 [get_ports cfrdwr]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:186
# The conversion of 'IOSTANDARD' constraint on 'net' object 'cfrdwr' has been applied to the port object 'cfrdwr'.
set_property IOSTANDARD LVCMOS18 [get_ports cfrdwr]
set_property PACKAGE_PIN W10 [get_ports cfdone]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:188
# The conversion of 'IOSTANDARD' constraint on 'net' object 'cfdone' has been applied to the port object 'cfdone'.
set_property IOSTANDARD LVCMOS18 [get_ports cfdone]
set_property PACKAGE_PIN W9 [get_ports {cfm[0]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:190
# The conversion of 'IOSTANDARD' constraint on 'net' object 'cfm[0]' has been applied to the port object 'cfm[0]'.
set_property IOSTANDARD LVCMOS18 [get_ports {cfm[0]}]
set_property PACKAGE_PIN Y11 [get_ports {core_d[11]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:192
# The conversion of 'IOSTANDARD' constraint on 'net' object 'core_d[11]' has been applied to the port object 'core_d[11]'.
set_property IOSTANDARD LVCMOS18 [get_ports {core_d[11]}]
set_property PACKAGE_PIN Y10 [get_ports {cfm[1]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:194
# The conversion of 'IOSTANDARD' constraint on 'net' object 'cfm[1]' has been applied to the port object 'cfm[1]'.
set_property IOSTANDARD LVCMOS18 [get_ports {cfm[1]}]
set_property PACKAGE_PIN AB11 [get_ports {core_d[13]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:196
# The conversion of 'IOSTANDARD' constraint on 'net' object 'core_d[13]' has been applied to the port object 'core_d[13]'.
set_property IOSTANDARD LVCMOS18 [get_ports {core_d[13]}]
set_property PACKAGE_PIN AC11 [get_ports {core_d[10]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:198
# The conversion of 'IOSTANDARD' constraint on 'net' object 'core_d[10]' has been applied to the port object 'core_d[10]'.
set_property IOSTANDARD LVCMOS18 [get_ports {core_d[10]}]
set_property PACKAGE_PIN AA10 [get_ports {cfm[2]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:200
# The conversion of 'IOSTANDARD' constraint on 'net' object 'cfm[2]' has been applied to the port object 'cfm[2]'.
set_property IOSTANDARD LVCMOS18 [get_ports {cfm[2]}]
set_property PACKAGE_PIN AB10 [get_ports {core_d[14]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:202
# The conversion of 'IOSTANDARD' constraint on 'net' object 'core_d[14]' has been applied to the port object 'core_d[14]'.
set_property IOSTANDARD LVCMOS18 [get_ports {core_d[14]}]
set_property PACKAGE_PIN AB12 [get_ports {core_d[15]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:204
# The conversion of 'IOSTANDARD' constraint on 'net' object 'core_d[15]' has been applied to the port object 'core_d[15]'.
set_property IOSTANDARD LVCMOS18 [get_ports {core_d[15]}]
set_property PACKAGE_PIN AC12 [get_ports {core_d[6]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:206
# The conversion of 'IOSTANDARD' constraint on 'net' object 'core_d[6]' has been applied to the port object 'core_d[6]'.
set_property IOSTANDARD LVCMOS18 [get_ports {core_d[6]}]
set_property PACKAGE_PIN AA13 [get_ports {core_d[1]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:208
# The conversion of 'IOSTANDARD' constraint on 'net' object 'core_d[1]' has been applied to the port object 'core_d[1]'.
set_property IOSTANDARD LVCMOS18 [get_ports {core_d[1]}]
set_property PACKAGE_PIN AA12 [get_ports {core_d[0]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:210
# The conversion of 'IOSTANDARD' constraint on 'net' object 'core_d[0]' has been applied to the port object 'core_d[0]'.
set_property IOSTANDARD LVCMOS18 [get_ports {core_d[0]}]
set_property PACKAGE_PIN AC13 [get_ports {core_d[2]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:212
# The conversion of 'IOSTANDARD' constraint on 'net' object 'core_d[2]' has been applied to the port object 'core_d[2]'.
set_property IOSTANDARD LVCMOS18 [get_ports {core_d[2]}]
set_property PACKAGE_PIN AD13 [get_ports {core_d[7]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:214
# The conversion of 'IOSTANDARD' constraint on 'net' object 'core_d[7]' has been applied to the port object 'core_d[7]'.
set_property IOSTANDARD LVCMOS18 [get_ports {core_d[7]}]
set_property PACKAGE_PIN Y13 [get_ports cfpudc]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:216
# The conversion of 'IOSTANDARD' constraint on 'net' object 'cfpudc' has been applied to the port object 'cfpudc'.
set_property IOSTANDARD LVCMOS18 [get_ports cfpudc]
set_property PACKAGE_PIN Y12 [get_ports {core_d[12]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:218
# The conversion of 'IOSTANDARD' constraint on 'net' object 'core_d[12]' has been applied to the port object 'core_d[12]'.
set_property IOSTANDARD LVCMOS18 [get_ports {core_d[12]}]
set_property PACKAGE_PIN AD11 [get_ports {core_d[9]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:220
# The conversion of 'IOSTANDARD' constraint on 'net' object 'core_d[9]' has been applied to the port object 'core_d[9]'.
set_property IOSTANDARD LVCMOS18 [get_ports {core_d[9]}]
set_property PACKAGE_PIN AE11 [get_ports cfinit]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:222
# The conversion of 'IOSTANDARD' constraint on 'net' object 'cfinit' has been applied to the port object 'cfinit'.
set_property IOSTANDARD LVCMOS18 [get_ports cfinit]
set_property PACKAGE_PIN AE10 [get_ports cfcsi_b]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:224
# The conversion of 'IOSTANDARD' constraint on 'net' object 'cfcsi_b' has been applied to the port object 'cfcsi_b'.
set_property IOSTANDARD LVCMOS18 [get_ports cfcsi_b]
set_property PACKAGE_PIN AE12 [get_ports {core_d[4]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:226
# The conversion of 'IOSTANDARD' constraint on 'net' object 'core_d[4]' has been applied to the port object 'core_d[4]'.
set_property IOSTANDARD LVCMOS18 [get_ports {core_d[4]}]
set_property PACKAGE_PIN AF12 [get_ports {core_d[8]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:228
# The conversion of 'IOSTANDARD' constraint on 'net' object 'core_d[8]' has been applied to the port object 'core_d[8]'.
set_property IOSTANDARD LVCMOS18 [get_ports {core_d[8]}]
set_property IOB TRUE [get_ports cfprogram]
set_property PACKAGE_PIN AF8 [get_ports cfprogram]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:231
# The conversion of 'IOSTANDARD' constraint on 'net' object 'cfprogram' has been applied to the port object 'cfprogram'.
set_property IOSTANDARD LVCMOS18 [get_ports cfprogram]
set_property PACKAGE_PIN AE13 [get_ports {core_d[3]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:233
# The conversion of 'IOSTANDARD' constraint on 'net' object 'core_d[3]' has been applied to the port object 'core_d[3]'.
set_property IOSTANDARD LVCMOS18 [get_ports {core_d[3]}]
set_property PACKAGE_PIN AF13 [get_ports {core_d[5]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:235
# The conversion of 'IOSTANDARD' constraint on 'net' object 'core_d[5]' has been applied to the port object 'core_d[5]'.
set_property IOSTANDARD LVCMOS18 [get_ports {core_d[5]}]
set_property IOB TRUE [get_ports cfcclk]
set_property PACKAGE_PIN AF10 [get_ports cfcclk]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:238
# The conversion of 'IOSTANDARD' constraint on 'net' object 'cfcclk' has been applied to the port object 'cfcclk'.
set_property IOSTANDARD LVCMOS18 [get_ports cfcclk]

#NET fsio_mosi LOC = B16  | IOSTANDARD = LVCMOS18  | IOB = TRUE;
#NET fsio_miso LOC = A18  | IOSTANDARD = LVCMOS18  | IOB = TRUE;
#NET fsio_sck LOC = B17  | IOSTANDARD = LVCMOS18  | IOB = TRUE;
#NET sddat<0> LOC = B19  | IOSTANDARD = LVCMOS18  | IOB = TRUE;
#NET sddat<1> LOC = C17  | IOSTANDARD = LVCMOS18  | IOB = TRUE;
#NET sddat<2> LOC = C18  | IOSTANDARD = LVCMOS18  | IOB = TRUE;
#NET sddat<3> LOC = D15  | IOSTANDARD = LVCMOS18  | IOB = TRUE;
#NET sdcmd_di LOC = D16  | IOSTANDARD = LVCMOS18  | IOB = TRUE;
#NET sdclk_sck LOC = H16  | IOSTANDARD = LVCMOS18  | IOB = TRUE;
#NET sdcrd_dt LOC = G15  | IOSTANDARD = LVCMOS18  | IOB = TRUE;

# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:251
# The conversion of 'IOSTANDARD' constraint on 'net' object 'pcie_clk' has been applied to the port object 'pcie_clk'.
set_property IOSTANDARD LVCMOS12 [get_ports pcie_clk]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:252
# The conversion of 'DRIVE' constraint on 'net' object 'pcie_clk' has been applied to the port object 'pcie_clk'.
set_property DRIVE 8 [get_ports pcie_clk]

# must go to clock pin on core FPGA
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:255
# The conversion of 'IOSTANDARD' constraint on 'net' object 'ext_clk_out' has been applied to the port object 'ext_clk_out'.
set_property IOSTANDARD LVCMOS12 [get_ports ext_clk_out]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:256
# The conversion of 'DRIVE' constraint on 'net' object 'ext_clk_out' has been applied to the port object 'ext_clk_out'.
set_property DRIVE 8 [get_ports ext_clk_out]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:257
# The conversion of 'SLEW' constraint on 'net' object 'ext_clk_out' has been applied to the port object 'ext_clk_out'.
set_property SLEW FAST [get_ports ext_clk_out]

# must be a clock pin
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:260
# The conversion of 'IOSTANDARD' constraint on 'net' object 'ext_clk_in' has been applied to the port object 'ext_clk_in'.
set_property IOSTANDARD LVCMOS12 [get_ports ext_clk_in]

# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:262
# The conversion of 'IOSTANDARD' constraint on 'net' object 'ext_data_out[0]' has been applied to the port object 'ext_data_out[0]'.
set_property IOSTANDARD LVCMOS12 [get_ports {ext_data_out[0]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:263
# The conversion of 'IOSTANDARD' constraint on 'net' object 'ext_data_out[10]' has been applied to the port object 'ext_data_out[10]'.
set_property IOSTANDARD LVCMOS12 [get_ports {ext_data_out[10]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:264
# The conversion of 'IOSTANDARD' constraint on 'net' object 'ext_data_out[11]' has been applied to the port object 'ext_data_out[11]'.
set_property IOSTANDARD LVCMOS12 [get_ports {ext_data_out[11]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:265
# The conversion of 'IOSTANDARD' constraint on 'net' object 'ext_data_out[12]' has been applied to the port object 'ext_data_out[12]'.
set_property IOSTANDARD LVCMOS12 [get_ports {ext_data_out[12]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:266
# The conversion of 'IOSTANDARD' constraint on 'net' object 'ext_data_out[13]' has been applied to the port object 'ext_data_out[13]'.
set_property IOSTANDARD LVCMOS12 [get_ports {ext_data_out[13]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:267
# The conversion of 'IOSTANDARD' constraint on 'net' object 'ext_data_out[1]' has been applied to the port object 'ext_data_out[1]'.
set_property IOSTANDARD LVCMOS12 [get_ports {ext_data_out[1]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:268
# The conversion of 'IOSTANDARD' constraint on 'net' object 'ext_data_out[2]' has been applied to the port object 'ext_data_out[2]'.
set_property IOSTANDARD LVCMOS12 [get_ports {ext_data_out[2]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:269
# The conversion of 'IOSTANDARD' constraint on 'net' object 'ext_data_out[3]' has been applied to the port object 'ext_data_out[3]'.
set_property IOSTANDARD LVCMOS12 [get_ports {ext_data_out[3]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:270
# The conversion of 'IOSTANDARD' constraint on 'net' object 'ext_data_out[4]' has been applied to the port object 'ext_data_out[4]'.
set_property IOSTANDARD LVCMOS12 [get_ports {ext_data_out[4]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:271
# The conversion of 'IOSTANDARD' constraint on 'net' object 'ext_data_out[5]' has been applied to the port object 'ext_data_out[5]'.
set_property IOSTANDARD LVCMOS12 [get_ports {ext_data_out[5]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:272
# The conversion of 'IOSTANDARD' constraint on 'net' object 'ext_data_out[6]' has been applied to the port object 'ext_data_out[6]'.
set_property IOSTANDARD LVCMOS12 [get_ports {ext_data_out[6]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:273
# The conversion of 'IOSTANDARD' constraint on 'net' object 'ext_data_out[7]' has been applied to the port object 'ext_data_out[7]'.
set_property IOSTANDARD LVCMOS12 [get_ports {ext_data_out[7]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:274
# The conversion of 'IOSTANDARD' constraint on 'net' object 'ext_data_out[8]' has been applied to the port object 'ext_data_out[8]'.
set_property IOSTANDARD LVCMOS12 [get_ports {ext_data_out[8]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:275
# The conversion of 'IOSTANDARD' constraint on 'net' object 'ext_data_out[9]' has been applied to the port object 'ext_data_out[9]'.
set_property IOSTANDARD LVCMOS12 [get_ports {ext_data_out[9]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:276
# The conversion of 'DRIVE' constraint on 'net' object 'ext_data_out[0]' has been applied to the port object 'ext_data_out[0]'.
set_property DRIVE 8 [get_ports {ext_data_out[0]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:277
# The conversion of 'DRIVE' constraint on 'net' object 'ext_data_out[10]' has been applied to the port object 'ext_data_out[10]'.
set_property DRIVE 8 [get_ports {ext_data_out[10]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:278
# The conversion of 'DRIVE' constraint on 'net' object 'ext_data_out[11]' has been applied to the port object 'ext_data_out[11]'.
set_property DRIVE 8 [get_ports {ext_data_out[11]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:279
# The conversion of 'DRIVE' constraint on 'net' object 'ext_data_out[12]' has been applied to the port object 'ext_data_out[12]'.
set_property DRIVE 8 [get_ports {ext_data_out[12]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:280
# The conversion of 'DRIVE' constraint on 'net' object 'ext_data_out[13]' has been applied to the port object 'ext_data_out[13]'.
set_property DRIVE 8 [get_ports {ext_data_out[13]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:281
# The conversion of 'DRIVE' constraint on 'net' object 'ext_data_out[1]' has been applied to the port object 'ext_data_out[1]'.
set_property DRIVE 8 [get_ports {ext_data_out[1]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:282
# The conversion of 'DRIVE' constraint on 'net' object 'ext_data_out[2]' has been applied to the port object 'ext_data_out[2]'.
set_property DRIVE 8 [get_ports {ext_data_out[2]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:283
# The conversion of 'DRIVE' constraint on 'net' object 'ext_data_out[3]' has been applied to the port object 'ext_data_out[3]'.
set_property DRIVE 8 [get_ports {ext_data_out[3]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:284
# The conversion of 'DRIVE' constraint on 'net' object 'ext_data_out[4]' has been applied to the port object 'ext_data_out[4]'.
set_property DRIVE 8 [get_ports {ext_data_out[4]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:285
# The conversion of 'DRIVE' constraint on 'net' object 'ext_data_out[5]' has been applied to the port object 'ext_data_out[5]'.
set_property DRIVE 8 [get_ports {ext_data_out[5]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:286
# The conversion of 'DRIVE' constraint on 'net' object 'ext_data_out[6]' has been applied to the port object 'ext_data_out[6]'.
set_property DRIVE 8 [get_ports {ext_data_out[6]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:287
# The conversion of 'DRIVE' constraint on 'net' object 'ext_data_out[7]' has been applied to the port object 'ext_data_out[7]'.
set_property DRIVE 8 [get_ports {ext_data_out[7]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:288
# The conversion of 'DRIVE' constraint on 'net' object 'ext_data_out[8]' has been applied to the port object 'ext_data_out[8]'.
set_property DRIVE 8 [get_ports {ext_data_out[8]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:289
# The conversion of 'DRIVE' constraint on 'net' object 'ext_data_out[9]' has been applied to the port object 'ext_data_out[9]'.
set_property DRIVE 8 [get_ports {ext_data_out[9]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:290
# The conversion of 'SLEW' constraint on 'net' object 'ext_data_out[0]' has been applied to the port object 'ext_data_out[0]'.
set_property SLEW FAST [get_ports {ext_data_out[0]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:291
# The conversion of 'SLEW' constraint on 'net' object 'ext_data_out[10]' has been applied to the port object 'ext_data_out[10]'.
set_property SLEW FAST [get_ports {ext_data_out[10]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:292
# The conversion of 'SLEW' constraint on 'net' object 'ext_data_out[11]' has been applied to the port object 'ext_data_out[11]'.
set_property SLEW FAST [get_ports {ext_data_out[11]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:293
# The conversion of 'SLEW' constraint on 'net' object 'ext_data_out[12]' has been applied to the port object 'ext_data_out[12]'.
set_property SLEW FAST [get_ports {ext_data_out[12]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:294
# The conversion of 'SLEW' constraint on 'net' object 'ext_data_out[13]' has been applied to the port object 'ext_data_out[13]'.
set_property SLEW FAST [get_ports {ext_data_out[13]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:295
# The conversion of 'SLEW' constraint on 'net' object 'ext_data_out[1]' has been applied to the port object 'ext_data_out[1]'.
set_property SLEW FAST [get_ports {ext_data_out[1]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:296
# The conversion of 'SLEW' constraint on 'net' object 'ext_data_out[2]' has been applied to the port object 'ext_data_out[2]'.
set_property SLEW FAST [get_ports {ext_data_out[2]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:297
# The conversion of 'SLEW' constraint on 'net' object 'ext_data_out[3]' has been applied to the port object 'ext_data_out[3]'.
set_property SLEW FAST [get_ports {ext_data_out[3]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:298
# The conversion of 'SLEW' constraint on 'net' object 'ext_data_out[4]' has been applied to the port object 'ext_data_out[4]'.
set_property SLEW FAST [get_ports {ext_data_out[4]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:299
# The conversion of 'SLEW' constraint on 'net' object 'ext_data_out[5]' has been applied to the port object 'ext_data_out[5]'.
set_property SLEW FAST [get_ports {ext_data_out[5]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:300
# The conversion of 'SLEW' constraint on 'net' object 'ext_data_out[6]' has been applied to the port object 'ext_data_out[6]'.
set_property SLEW FAST [get_ports {ext_data_out[6]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:301
# The conversion of 'SLEW' constraint on 'net' object 'ext_data_out[7]' has been applied to the port object 'ext_data_out[7]'.
set_property SLEW FAST [get_ports {ext_data_out[7]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:302
# The conversion of 'SLEW' constraint on 'net' object 'ext_data_out[8]' has been applied to the port object 'ext_data_out[8]'.
set_property SLEW FAST [get_ports {ext_data_out[8]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:303
# The conversion of 'SLEW' constraint on 'net' object 'ext_data_out[9]' has been applied to the port object 'ext_data_out[9]'.
set_property SLEW FAST [get_ports {ext_data_out[9]}]

# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:305
# The conversion of 'IOSTANDARD' constraint on 'net' object 'ext_data_in[0]' has been applied to the port object 'ext_data_in[0]'.
set_property IOSTANDARD LVCMOS12 [get_ports {ext_data_in[0]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:306
# The conversion of 'IOSTANDARD' constraint on 'net' object 'ext_data_in[10]' has been applied to the port object 'ext_data_in[10]'.
set_property IOSTANDARD LVCMOS12 [get_ports {ext_data_in[10]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:307
# The conversion of 'IOSTANDARD' constraint on 'net' object 'ext_data_in[11]' has been applied to the port object 'ext_data_in[11]'.
set_property IOSTANDARD LVCMOS12 [get_ports {ext_data_in[11]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:308
# The conversion of 'IOSTANDARD' constraint on 'net' object 'ext_data_in[12]' has been applied to the port object 'ext_data_in[12]'.
set_property IOSTANDARD LVCMOS12 [get_ports {ext_data_in[12]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:309
# The conversion of 'IOSTANDARD' constraint on 'net' object 'ext_data_in[13]' has been applied to the port object 'ext_data_in[13]'.
set_property IOSTANDARD LVCMOS12 [get_ports {ext_data_in[13]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:310
# The conversion of 'IOSTANDARD' constraint on 'net' object 'ext_data_in[1]' has been applied to the port object 'ext_data_in[1]'.
set_property IOSTANDARD LVCMOS12 [get_ports {ext_data_in[1]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:311
# The conversion of 'IOSTANDARD' constraint on 'net' object 'ext_data_in[2]' has been applied to the port object 'ext_data_in[2]'.
set_property IOSTANDARD LVCMOS12 [get_ports {ext_data_in[2]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:312
# The conversion of 'IOSTANDARD' constraint on 'net' object 'ext_data_in[3]' has been applied to the port object 'ext_data_in[3]'.
set_property IOSTANDARD LVCMOS12 [get_ports {ext_data_in[3]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:313
# The conversion of 'IOSTANDARD' constraint on 'net' object 'ext_data_in[4]' has been applied to the port object 'ext_data_in[4]'.
set_property IOSTANDARD LVCMOS12 [get_ports {ext_data_in[4]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:314
# The conversion of 'IOSTANDARD' constraint on 'net' object 'ext_data_in[5]' has been applied to the port object 'ext_data_in[5]'.
set_property IOSTANDARD LVCMOS12 [get_ports {ext_data_in[5]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:315
# The conversion of 'IOSTANDARD' constraint on 'net' object 'ext_data_in[6]' has been applied to the port object 'ext_data_in[6]'.
set_property IOSTANDARD LVCMOS12 [get_ports {ext_data_in[6]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:316
# The conversion of 'IOSTANDARD' constraint on 'net' object 'ext_data_in[7]' has been applied to the port object 'ext_data_in[7]'.
set_property IOSTANDARD LVCMOS12 [get_ports {ext_data_in[7]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:317
# The conversion of 'IOSTANDARD' constraint on 'net' object 'ext_data_in[8]' has been applied to the port object 'ext_data_in[8]'.
set_property IOSTANDARD LVCMOS12 [get_ports {ext_data_in[8]}]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:318
# The conversion of 'IOSTANDARD' constraint on 'net' object 'ext_data_in[9]' has been applied to the port object 'ext_data_in[9]'.
set_property IOSTANDARD LVCMOS12 [get_ports {ext_data_in[9]}]

# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:320
# The conversion of 'IOSTANDARD' constraint on 'net' object 'axi_resetn' has been applied to the port object 'axi_resetn'.
set_property IOSTANDARD LVCMOS12 [get_ports axi_resetn]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:321
# The conversion of 'IOSTANDARD' constraint on 'net' object 'core_phase_inc' has been applied to the port object 'core_phase_inc'.
set_property IOSTANDARD LVCMOS12 [get_ports core_phase_inc]

# CNT<67>
set_property PACKAGE_PIN P19 [get_ports core_phase_inc]
# CNT<70>
set_property PACKAGE_PIN M22 [get_ports axi_resetn]
# CNT<71>
set_property PACKAGE_PIN P23 [get_ports pcie_clk]
# CNT<72>
set_property PACKAGE_PIN N23 [get_ports {ext_data_out[0]}]
# CNT<73>
set_property PACKAGE_PIN N21 [get_ports ext_clk_in]
# CNT<74>
set_property PACKAGE_PIN N22 [get_ports {ext_data_out[1]}]
# CNT<75>
set_property PACKAGE_PIN R21 [get_ports {ext_data_out[2]}]
# CNT<76>
set_property PACKAGE_PIN P21 [get_ports {ext_data_out[3]}]
# CNT<77>
set_property PACKAGE_PIN R22 [get_ports {ext_data_out[4]}]
#//NET ext_data_out<4> LOC = P25; # CNT<62>
# CNT<78>
set_property PACKAGE_PIN R23 [get_ports {ext_data_out[5]}]
# CNT<79>
set_property PACKAGE_PIN T24 [get_ports {ext_data_out[6]}]
# CNT<80>
set_property PACKAGE_PIN T25 [get_ports {ext_data_out[7]}]
# CNT<81>
set_property PACKAGE_PIN T20 [get_ports {ext_data_out[8]}]
# CNT<82>
set_property PACKAGE_PIN R20 [get_ports {ext_data_out[9]}]
# CNT<83>
set_property PACKAGE_PIN T22 [get_ports {ext_data_out[10]}]
# CNT<84>
set_property PACKAGE_PIN T23 [get_ports {ext_data_out[11]}]
# CNT<85>
set_property PACKAGE_PIN U19 [get_ports {ext_data_out[12]}]
# CNT<69>
set_property PACKAGE_PIN M21 [get_ports {ext_data_out[13]}]
# CNT<86>
set_property PACKAGE_PIN U20 [get_ports {ext_data_in[0]}]
# CNT<87>
set_property PACKAGE_PIN T18 [get_ports {ext_data_in[1]}]
# CNT<88>
set_property PACKAGE_PIN T19 [get_ports {ext_data_in[2]}]
# CNT<89>
set_property PACKAGE_PIN P16 [get_ports {ext_data_in[3]}]
# CNT<90>
set_property PACKAGE_PIN N17 [get_ports {ext_data_in[4]}]
# CNT<91>
set_property PACKAGE_PIN R16 [get_ports {ext_data_in[5]}]
# CNT<92>
set_property PACKAGE_PIN R17 [get_ports {ext_data_in[6]}]
# CNT<93>
set_property PACKAGE_PIN N18 [get_ports {ext_data_in[7]}]
# CNT<94>
set_property PACKAGE_PIN M19 [get_ports {ext_data_in[8]}]
# CNT<95>
set_property PACKAGE_PIN U17 [get_ports {ext_data_in[9]}]
# CNT<96>
set_property PACKAGE_PIN T17 [get_ports {ext_data_in[10]}]
# CNT<97>
set_property PACKAGE_PIN R18 [get_ports {ext_data_in[11]}]
# CNT<98>
set_property PACKAGE_PIN P18 [get_ports {ext_data_in[12]}]
# CNT<68>
set_property PACKAGE_PIN P20 [get_ports {ext_data_in[13]}]
# CNT<99>
set_property PACKAGE_PIN U16 [get_ports ext_clk_out]

# CNT<8>
#set_property PACKAGE_PIN J10 [get_ports clk40_out]
set_property PACKAGE_PIN H11 [get_ports clk40_out]

# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:393
# The conversion of 'IOSTANDARD' constraint on 'net' object 'clk40_out' has been applied to the port object 'clk40_out'.
set_property IOSTANDARD LVCMOS12 [get_ports clk40_out]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:394
# The conversion of 'DRIVE' constraint on 'net' object 'clk40_out' has been applied to the port object 'clk40_out'.
set_property DRIVE 8 [get_ports clk40_out]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:395
# The conversion of 'SLEW' constraint on 'net' object 'clk40_out' has been applied to the port object 'clk40_out'.
set_property SLEW FAST [get_ports clk40_out]

# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:398
# The conversion of 'IOSTANDARD' constraint on 'net' object 'ttcb_n' has been applied to the port object 'ttcb_n'.
set_property IOSTANDARD LVDS [get_ports ttcb_n]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:399
# The conversion of 'DIFF_TERM' constraint on 'net' object 'ttcb_n' has been applied to the port object 'ttcb_n'.
set_property DIFF_TERM TRUE [get_ports ttcb_n]
set_property PACKAGE_PIN U1 [get_ports ttcb_n]
set_property PACKAGE_PIN U2 [get_ports ttcb_p]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:401
# The conversion of 'IOSTANDARD' constraint on 'net' object 'ttcb_p' has been applied to the port object 'ttcb_p'.
set_property IOSTANDARD LVDS [get_ports ttcb_p]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:402
# The conversion of 'DIFF_TERM' constraint on 'net' object 'ttcb_p' has been applied to the port object 'ttcb_p'.
set_property DIFF_TERM TRUE [get_ports ttcb_p]

# CNT<65>
set_property PACKAGE_PIN M24 [get_ports l1a]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:406
# The conversion of 'IOSTANDARD' constraint on 'net' object 'l1a' has been applied to the port object 'l1a'.
set_property IOSTANDARD LVCMOS12 [get_ports l1a]
# CNT<66>
set_property PACKAGE_PIN L24 [get_ports mpc_inject]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:409
# The conversion of 'IOSTANDARD' constraint on 'net' object 'mpc_inject' has been applied to the port object 'mpc_inject'.
set_property IOSTANDARD LVCMOS12 [get_ports mpc_inject]
# CNT<64>
set_property PACKAGE_PIN M20 [get_ports bc0]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:412
# The conversion of 'IOSTANDARD' constraint on 'net' object 'bc0' has been applied to the port object 'bc0'.
set_property IOSTANDARD LVCMOS12 [get_ports bc0]
# CNT<63>
set_property PACKAGE_PIN N19 [get_ports resync]
# F:/Users/madorsky/projects/ise/sp_slhc/mtf7/mtf7_control/plan_ahead/plan_ahead.runs/impl_1/.constrs/mtf7_control.ucf:415
# The conversion of 'IOSTANDARD' constraint on 'net' object 'resync' has been applied to the port object 'resync'.
set_property IOSTANDARD LVCMOS12 [get_ports resync]

set_false_path -from [get_pins cl/ctoc/phase_done_reg/C] -to [get_pins cl/ctoc/phase_done_t_reg/D]
#set_false_path -from [get_clocks lhc_clk]

set_property PACKAGE_PIN B12 [get_ports ev_cnt_reset]
set_property IOSTANDARD LVCMOS12 [get_ports ev_cnt_reset]

set_property PACKAGE_PIN F15 [get_ports ev_cnt_reset_tp]
set_property IOSTANDARD LVCMOS18 [get_ports ev_cnt_reset_tp]
set_false_path -to [get_ports ev_cnt_reset_tp]

set_property PACKAGE_PIN C13 [get_ports or_cnt_reset]
set_property IOSTANDARD LVCMOS12 [get_ports or_cnt_reset]

set_property -dict {LOC C14 IOSTANDARD LVCMOS12} [get_ports lhc_clk_good] ;# CNT<37>
set_property -dict {LOC E12 IOSTANDARD LVCMOS12} [get_ports hard_reset] ;# CNT<36>

set_property -dict {LOC V6 IOSTANDARD LVCMOS18} [get_ports pcie_led]
set_property -dict {LOC V4 IOSTANDARD LVCMOS18} [get_ports lock_led]

set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.OVERTEMPPOWERDOWN ENABLE [current_design]
set_property BITSTREAM.CONFIG.USR_ACCESS TIMESTAMP [current_design]

set_property CFGBVS GND [current_design]
set_property CONFIG_VOLTAGE 1.8 [current_design]

#set_false_path -from [get_clocks -of_objects [get_pins pcie_/ext_clk.pipe_clock_i/mmcm_i/CLKOUT3]] -to [get_clocks -of_objects [get_pins cl/ctoc/ctoc_mmcm_in_/inst/mmcm_adv_inst/CLKOUT1]]
set_multicycle_path -from [get_clocks -of_objects [get_pins clocks_/lhc_clk_monitor/inst/CLK_CORE_DRP_I/clk_inst/mmcm_adv_inst/CLKOUT0]] -to [get_clocks -of_objects [get_pins pcie_/pcie_7x_0_support_i/pipe_clock_i/mmcm_i/CLKOUT2]] 2
set_false_path -from [get_clocks -of_objects [get_pins clocks_/lhc_clk_monitor/inst/CLK_CORE_DRP_I/clk_inst/mmcm_adv_inst/CLKOUT0]] -to [get_clocks -of_objects [get_pins pcie_/pcie_7x_0_support_i/pipe_clock_i/mmcm_i/CLKOUT2]]
set_false_path -from [get_clocks -of_objects [get_pins pcie_/pcie_7x_0_support_i/pipe_clock_i/mmcm_i/CLKOUT2]] -to [get_clocks -of_objects [get_pins clocks_/lhc_clk_monitor/inst/CLK_CORE_DRP_I/clk_inst/mmcm_adv_inst/CLKOUT0]]
set_false_path -from [get_clocks clk50_p] -to [get_clocks -of_objects [get_pins clocks_/lhc_clk_monitor/inst/CLK_CORE_DRP_I/clk_inst/mmcm_adv_inst/CLKOUT0]]
set_false_path -from [get_clocks -of_objects [get_pins clocks_/lhc_clk_monitor/inst/CLK_CORE_DRP_I/clk_inst/mmcm_adv_inst/CLKOUT0]] -to [get_clocks clk50_p]

#set_property IOB TRUE [get_ports mpc_inject]
set_property IOB TRUE [get_ports l1a]
set_property IOB TRUE [get_ports bc0]
set_property IOB TRUE [get_ports ev_cnt_reset]
set_property IOB TRUE [get_ports or_cnt_reset]
set_property IOB TRUE [get_ports resync]
set_property IOB TRUE [get_ports hard_reset]