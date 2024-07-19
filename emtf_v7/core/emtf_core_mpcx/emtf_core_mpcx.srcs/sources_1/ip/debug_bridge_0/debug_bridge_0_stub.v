// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.1 (lin64) Build 2902540 Wed May 27 19:54:35 MDT 2020
// Date        : Thu Mar  3 13:25:01 2022
// Host        : endcap-tf2 running 64-bit Ubuntu 18.04.6 LTS
// Command     : write_verilog -force -mode synth_stub -rename_top debug_bridge_0 -prefix
//               debug_bridge_0_ debug_bridge_0_stub.v
// Design      : debug_bridge_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7vx690tffg1927-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "bd_54be,Vivado 2020.1.1_AR73018" *)
module debug_bridge_0(jtag_tdi, jtag_tdo, jtag_tms, jtag_tck, 
  m0_bscan_bscanid_en, m0_bscan_capture, m0_bscan_drck, m0_bscan_reset, m0_bscan_runtest, 
  m0_bscan_sel, m0_bscan_shift, m0_bscan_tck, m0_bscan_tdi, m0_bscan_tdo, m0_bscan_tms, 
  m0_bscan_update)
/* synthesis syn_black_box black_box_pad_pin="jtag_tdi,jtag_tdo,jtag_tms,jtag_tck,m0_bscan_bscanid_en,m0_bscan_capture,m0_bscan_drck,m0_bscan_reset,m0_bscan_runtest,m0_bscan_sel,m0_bscan_shift,m0_bscan_tck,m0_bscan_tdi,m0_bscan_tdo,m0_bscan_tms,m0_bscan_update" */;
  input jtag_tdi;
  output jtag_tdo;
  input jtag_tms;
  input jtag_tck;
  output m0_bscan_bscanid_en;
  output m0_bscan_capture;
  output m0_bscan_drck;
  output m0_bscan_reset;
  output m0_bscan_runtest;
  output m0_bscan_sel;
  output m0_bscan_shift;
  output m0_bscan_tck;
  output m0_bscan_tdi;
  input m0_bscan_tdo;
  output m0_bscan_tms;
  output m0_bscan_update;
endmodule
