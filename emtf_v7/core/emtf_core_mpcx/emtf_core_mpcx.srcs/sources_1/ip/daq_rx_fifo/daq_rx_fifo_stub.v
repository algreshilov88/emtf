// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2.1 (lin64) Build 2729669 Thu Dec  5 04:48:12 MST 2019
// Date        : Fri Apr 10 16:37:22 2020
// Host        : endcap-tf1.phys.ufl.edu running 64-bit CentOS Linux release 7.7.1908 (Core)
// Command     : write_verilog -force -mode synth_stub
//               /home/madorsky/cernbox/projects/vivado/emtf_v7/core/emtf_core_mgtb/emtf_core.srcs/daq_rx_fifo/ip/daq_rx_fifo/daq_rx_fifo_stub.v
// Design      : daq_rx_fifo
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7vx690tffg1927-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "fifo_generator_v13_2_5,Vivado 2019.2.1" *)
module daq_rx_fifo(rst, wr_clk, rd_clk, din, wr_en, rd_en, dout, full, 
  empty, underflow)
/* synthesis syn_black_box black_box_pad_pin="rst,wr_clk,rd_clk,din[21:0],wr_en,rd_en,dout[21:0],full,empty,underflow" */;
  input rst;
  input wr_clk;
  input rd_clk;
  input [21:0]din;
  input wr_en;
  input rd_en;
  output [21:0]dout;
  output full;
  output empty;
  output underflow;
endmodule
