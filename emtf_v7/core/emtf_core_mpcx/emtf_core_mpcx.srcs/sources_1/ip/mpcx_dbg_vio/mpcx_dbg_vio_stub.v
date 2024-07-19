// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.1 (lin64) Build 2902540 Wed May 27 19:54:35 MDT 2020
// Date        : Thu Mar  3 13:24:28 2022
// Host        : endcap-tf2 running 64-bit Ubuntu 18.04.6 LTS
// Command     : write_verilog -force -mode synth_stub -rename_top mpcx_dbg_vio -prefix
//               mpcx_dbg_vio_ mpcx_dbg_vio_stub.v
// Design      : mpcx_dbg_vio
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7vx690tffg1927-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "vio,Vivado 2020.1" *)
module mpcx_dbg_vio(clk, probe_out0, probe_out1, probe_out2, 
  probe_out3, probe_out4, probe_out5, probe_out6, probe_out7, probe_out8, probe_out9, 
  probe_out10, probe_out11, probe_out12, probe_out13, probe_out14)
/* synthesis syn_black_box black_box_pad_pin="clk,probe_out0[2:0],probe_out1[2:0],probe_out2[2:0],probe_out3[3:0],probe_out4[3:0],probe_out5[3:0],probe_out6[2:0],probe_out7[2:0],probe_out8[2:0],probe_out9[0:0],probe_out10[0:0],probe_out11[0:0],probe_out12[2:0],probe_out13[2:0],probe_out14[2:0]" */;
  input clk;
  output [2:0]probe_out0;
  output [2:0]probe_out1;
  output [2:0]probe_out2;
  output [3:0]probe_out3;
  output [3:0]probe_out4;
  output [3:0]probe_out5;
  output [2:0]probe_out6;
  output [2:0]probe_out7;
  output [2:0]probe_out8;
  output [0:0]probe_out9;
  output [0:0]probe_out10;
  output [0:0]probe_out11;
  output [2:0]probe_out12;
  output [2:0]probe_out13;
  output [2:0]probe_out14;
endmodule
