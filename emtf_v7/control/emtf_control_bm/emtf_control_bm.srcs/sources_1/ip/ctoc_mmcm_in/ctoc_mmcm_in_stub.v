// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.1 (lin64) Build 2902540 Wed May 27 19:54:35 MDT 2020
// Date        : Fri Mar 24 18:20:21 2023
// Host        : endcap-tf2 running 64-bit Ubuntu 18.04.6 LTS
// Command     : write_verilog -force -mode synth_stub
//               /home/madorsky/github/vivado/emtf/emtf_v7/control/emtf_control_bm/emtf_control_bm.srcs/sources_1/ip/ctoc_mmcm_in/ctoc_mmcm_in_stub.v
// Design      : ctoc_mmcm_in
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7k70tfbg676-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module ctoc_mmcm_in(clk_625M, clk_125M, psclk, psen, psincdec, psdone, 
  reset, input_clk_stopped, locked, clk_125M_in)
/* synthesis syn_black_box black_box_pad_pin="clk_625M,clk_125M,psclk,psen,psincdec,psdone,reset,input_clk_stopped,locked,clk_125M_in" */;
  output clk_625M;
  output clk_125M;
  input psclk;
  input psen;
  input psincdec;
  output psdone;
  input reset;
  output input_clk_stopped;
  output locked;
  input clk_125M_in;
endmodule
