// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.2 (lin64) Build 1909853 Thu Jun 15 18:39:10 MDT 2017
// Date        : Thu Jun 11 04:40:09 2020
// Host        : uftrig01.dyndns.cern.ch running 64-bit Scientific Linux CERN SLC release 6.10 (Carbon)
// Command     : write_verilog -force -mode synth_stub
//               /home/madorsky/cernbox/projects/vivado/emtf_v7/core/emtf_core/emtf_core.src/ip/daq_rx_fifo/daq_rx_fifo_stub.v
// Design      : daq_rx_fifo
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7vx690tffg1927-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "fifo_generator_v13_1_4,Vivado 2017.2" *)
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
