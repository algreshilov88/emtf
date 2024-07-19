// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.1 (lin64) Build 2902540 Wed May 27 19:54:35 MDT 2020
// Date        : Thu Mar  3 13:25:01 2022
// Host        : endcap-tf2 running 64-bit Ubuntu 18.04.6 LTS
// Command     : write_verilog -force -mode funcsim -rename_top debug_bridge_0 -prefix
//               debug_bridge_0_ debug_bridge_0_sim_netlist.v
// Design      : debug_bridge_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7vx690tffg1927-2
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* HW_HANDOFF = "debug_bridge_0.hwdef" *) 
module debug_bridge_0_bd_54be
   (jtag_tck,
    jtag_tdi,
    jtag_tdo,
    jtag_tms,
    m0_bscan_bscanid_en,
    m0_bscan_capture,
    m0_bscan_drck,
    m0_bscan_reset,
    m0_bscan_runtest,
    m0_bscan_sel,
    m0_bscan_shift,
    m0_bscan_tck,
    m0_bscan_tdi,
    m0_bscan_tdo,
    m0_bscan_tms,
    m0_bscan_update);
  input jtag_tck;
  input jtag_tdi;
  output jtag_tdo;
  input jtag_tms;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bscan:1.0 m0_bscan BSCANID_en" *) output m0_bscan_bscanid_en;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bscan:1.0 m0_bscan CAPTURE" *) output m0_bscan_capture;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bscan:1.0 m0_bscan DRCK" *) output m0_bscan_drck;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bscan:1.0 m0_bscan RESET" *) output m0_bscan_reset;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bscan:1.0 m0_bscan RUNTEST" *) output m0_bscan_runtest;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bscan:1.0 m0_bscan SEL" *) output m0_bscan_sel;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bscan:1.0 m0_bscan SHIFT" *) output m0_bscan_shift;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bscan:1.0 m0_bscan TCK" *) output m0_bscan_tck;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bscan:1.0 m0_bscan TDI" *) output m0_bscan_tdi;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bscan:1.0 m0_bscan TDO" *) input m0_bscan_tdo;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bscan:1.0 m0_bscan TMS" *) output m0_bscan_tms;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bscan:1.0 m0_bscan UPDATE" *) output m0_bscan_update;

  wire bsip_m_bscan_CAPTURE;
  wire bsip_m_bscan_DRCK;
  wire bsip_m_bscan_RESET;
  wire bsip_m_bscan_RUNTEST;
  wire bsip_m_bscan_SEL;
  wire bsip_m_bscan_SHIFT;
  wire bsip_m_bscan_TCK;
  wire bsip_m_bscan_TDI;
  wire bsip_m_bscan_TDO;
  wire bsip_m_bscan_TMS;
  wire bsip_m_bscan_UPDATE;
  wire jtag_tck;
  wire jtag_tdi;
  wire jtag_tdo;
  wire jtag_tms;
  wire m0_bscan_bscanid_en;
  wire m0_bscan_capture;
  wire m0_bscan_drck;
  wire m0_bscan_reset;
  wire m0_bscan_runtest;
  wire m0_bscan_sel;
  wire m0_bscan_shift;
  wire m0_bscan_tck;
  wire m0_bscan_tdi;
  wire m0_bscan_tdo;
  wire m0_bscan_tms;
  wire m0_bscan_update;

  (* X_CORE_INFO = "bs_switch_v1_0_0_bs_switch,Vivado 2020.1.1_AR73018" *) 
  debug_bridge_0_bd_54be_bs_switch_0_0 bs_switch_0
       (.bscanid_en_0(m0_bscan_bscanid_en),
        .capture_0(m0_bscan_capture),
        .drck_0(m0_bscan_drck),
        .reset_0(m0_bscan_reset),
        .runtest_0(m0_bscan_runtest),
        .s_bscan_capture(bsip_m_bscan_CAPTURE),
        .s_bscan_drck(bsip_m_bscan_DRCK),
        .s_bscan_reset(bsip_m_bscan_RESET),
        .s_bscan_runtest(bsip_m_bscan_RUNTEST),
        .s_bscan_sel(bsip_m_bscan_SEL),
        .s_bscan_shift(bsip_m_bscan_SHIFT),
        .s_bscan_tck(bsip_m_bscan_TCK),
        .s_bscan_tdi(bsip_m_bscan_TDI),
        .s_bscan_tdo(bsip_m_bscan_TDO),
        .s_bscan_tms(bsip_m_bscan_TMS),
        .s_bscan_update(bsip_m_bscan_UPDATE),
        .s_bscanid_en(1'b0),
        .sel_0(m0_bscan_sel),
        .shift_0(m0_bscan_shift),
        .tck_0(m0_bscan_tck),
        .tdi_0(m0_bscan_tdi),
        .tdo_0(m0_bscan_tdo),
        .tms_0(m0_bscan_tms),
        .update_0(m0_bscan_update));
  (* X_CORE_INFO = "bsip_v1_1_0_bsip,Vivado 2020.1.1_AR73018" *) 
  debug_bridge_0_bd_54be_bsip_0 bsip
       (.capture(bsip_m_bscan_CAPTURE),
        .drck(bsip_m_bscan_DRCK),
        .reset(bsip_m_bscan_RESET),
        .runtest(bsip_m_bscan_RUNTEST),
        .sel(bsip_m_bscan_SEL),
        .shift(bsip_m_bscan_SHIFT),
        .tap_tck(jtag_tck),
        .tap_tdi(jtag_tdi),
        .tap_tdo(jtag_tdo),
        .tap_tms(jtag_tms),
        .tck(bsip_m_bscan_TCK),
        .tdi(bsip_m_bscan_TDI),
        .tdo(bsip_m_bscan_TDO),
        .tms(bsip_m_bscan_TMS),
        .update(bsip_m_bscan_UPDATE));
endmodule

(* X_CORE_INFO = "bs_switch_v1_0_0_bs_switch,Vivado 2020.1.1_AR73018" *) 
module debug_bridge_0_bd_54be_bs_switch_0_0
   (s_bscan_drck,
    s_bscan_reset,
    s_bscan_sel,
    s_bscan_capture,
    s_bscan_shift,
    s_bscan_update,
    s_bscan_tdi,
    s_bscan_runtest,
    s_bscan_tck,
    s_bscan_tms,
    s_bscanid_en,
    s_bscan_tdo,
    drck_0,
    reset_0,
    sel_0,
    capture_0,
    shift_0,
    update_0,
    tdi_0,
    runtest_0,
    tck_0,
    tms_0,
    bscanid_en_0,
    tdo_0);
  input s_bscan_drck;
  input s_bscan_reset;
  input s_bscan_sel;
  input s_bscan_capture;
  input s_bscan_shift;
  input s_bscan_update;
  input s_bscan_tdi;
  input s_bscan_runtest;
  input s_bscan_tck;
  input s_bscan_tms;
  input s_bscanid_en;
  output s_bscan_tdo;
  output drck_0;
  output reset_0;
  output sel_0;
  output capture_0;
  output shift_0;
  output update_0;
  output tdi_0;
  output runtest_0;
  output tck_0;
  output tms_0;
  output bscanid_en_0;
  input tdo_0;


endmodule

(* X_CORE_INFO = "bsip_v1_1_0_bsip,Vivado 2020.1.1_AR73018" *) 
module debug_bridge_0_bd_54be_bsip_0
   (drck,
    reset,
    sel,
    shift,
    tdi,
    update,
    capture,
    runtest,
    tck,
    tms,
    tap_tdo,
    tdo,
    tap_tdi,
    tap_tms,
    tap_tck);
  output drck;
  output reset;
  output sel;
  output shift;
  output tdi;
  output update;
  output capture;
  output runtest;
  output tck;
  output tms;
  output tap_tdo;
  input tdo;
  input tap_tdi;
  input tap_tms;
  input tap_tck;


endmodule

(* CHECK_LICENSE_TYPE = "debug_bridge_0,bd_54be,{}" *) (* DowngradeIPIdentifiedWarnings = "yes" *) (* X_CORE_INFO = "bd_54be,Vivado 2020.1.1_AR73018" *) 
(* NotValidForBitStream *)
module debug_bridge_0
   (jtag_tdi,
    jtag_tdo,
    jtag_tms,
    jtag_tck,
    m0_bscan_bscanid_en,
    m0_bscan_capture,
    m0_bscan_drck,
    m0_bscan_reset,
    m0_bscan_runtest,
    m0_bscan_sel,
    m0_bscan_shift,
    m0_bscan_tck,
    m0_bscan_tdi,
    m0_bscan_tdo,
    m0_bscan_tms,
    m0_bscan_update);
  input jtag_tdi;
  output jtag_tdo;
  input jtag_tms;
  input jtag_tck;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bscan:1.0 m0_bscan BSCANID_en" *) output m0_bscan_bscanid_en;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bscan:1.0 m0_bscan CAPTURE" *) output m0_bscan_capture;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bscan:1.0 m0_bscan DRCK" *) output m0_bscan_drck;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bscan:1.0 m0_bscan RESET" *) output m0_bscan_reset;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bscan:1.0 m0_bscan RUNTEST" *) output m0_bscan_runtest;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bscan:1.0 m0_bscan SEL" *) output m0_bscan_sel;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bscan:1.0 m0_bscan SHIFT" *) output m0_bscan_shift;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bscan:1.0 m0_bscan TCK" *) output m0_bscan_tck;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bscan:1.0 m0_bscan TDI" *) output m0_bscan_tdi;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bscan:1.0 m0_bscan TDO" *) input m0_bscan_tdo;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bscan:1.0 m0_bscan TMS" *) output m0_bscan_tms;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bscan:1.0 m0_bscan UPDATE" *) output m0_bscan_update;

  wire jtag_tck;
  wire jtag_tdi;
  wire jtag_tdo;
  wire jtag_tms;
  wire m0_bscan_bscanid_en;
  wire m0_bscan_capture;
  wire m0_bscan_drck;
  wire m0_bscan_reset;
  wire m0_bscan_runtest;
  wire m0_bscan_sel;
  wire m0_bscan_shift;
  wire m0_bscan_tck;
  wire m0_bscan_tdi;
  wire m0_bscan_tdo;
  wire m0_bscan_tms;
  wire m0_bscan_update;

  (* HW_HANDOFF = "debug_bridge_0.hwdef" *) 
  debug_bridge_0_bd_54be inst
       (.jtag_tck(jtag_tck),
        .jtag_tdi(jtag_tdi),
        .jtag_tdo(jtag_tdo),
        .jtag_tms(jtag_tms),
        .m0_bscan_bscanid_en(m0_bscan_bscanid_en),
        .m0_bscan_capture(m0_bscan_capture),
        .m0_bscan_drck(m0_bscan_drck),
        .m0_bscan_reset(m0_bscan_reset),
        .m0_bscan_runtest(m0_bscan_runtest),
        .m0_bscan_sel(m0_bscan_sel),
        .m0_bscan_shift(m0_bscan_shift),
        .m0_bscan_tck(m0_bscan_tck),
        .m0_bscan_tdi(m0_bscan_tdi),
        .m0_bscan_tdo(m0_bscan_tdo),
        .m0_bscan_tms(m0_bscan_tms),
        .m0_bscan_update(m0_bscan_update));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
