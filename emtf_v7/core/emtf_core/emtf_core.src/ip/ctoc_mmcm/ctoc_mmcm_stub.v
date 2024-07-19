// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.2 (lin64) Build 1909853 Thu Jun 15 18:39:10 MDT 2017
// Date        : Thu Jun 11 04:40:02 2020
// Host        : uftrig01.dyndns.cern.ch running 64-bit Scientific Linux CERN SLC release 6.10 (Carbon)
// Command     : write_verilog -force -mode synth_stub
//               /home/madorsky/cernbox/projects/vivado/emtf_v7/core/emtf_core/emtf_core.src/ip/ctoc_mmcm/ctoc_mmcm_stub.v
// Design      : ctoc_mmcm
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7vx690tffg1927-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module ctoc_mmcm(clk_625M, clk_125M, reset, input_clk_stopped, 
  locked, clk_125M_in)
/* synthesis syn_black_box black_box_pad_pin="clk_625M,clk_125M,reset,input_clk_stopped,locked,clk_125M_in" */;
  output clk_625M;
  output clk_125M;
  input reset;
  output input_clk_stopped;
  output locked;
  input clk_125M_in;
endmodule
