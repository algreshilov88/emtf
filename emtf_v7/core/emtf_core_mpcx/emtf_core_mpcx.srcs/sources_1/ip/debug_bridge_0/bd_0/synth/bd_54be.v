//Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Command: generate_target bd_54be.bd
//Design : bd_54be
//Purpose: IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "bd_54be,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=bd_54be,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=2,numReposBlks=2,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=SBD,synth_mode=OOC_per_IP}" *) (* HW_HANDOFF = "debug_bridge_0.hwdef" *) 
module bd_54be
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
  (* x_interface_info = "xilinx.com:interface:bscan:1.0 m0_bscan BSCANID_en" *) output m0_bscan_bscanid_en;
  (* x_interface_info = "xilinx.com:interface:bscan:1.0 m0_bscan CAPTURE" *) output m0_bscan_capture;
  (* x_interface_info = "xilinx.com:interface:bscan:1.0 m0_bscan DRCK" *) output m0_bscan_drck;
  (* x_interface_info = "xilinx.com:interface:bscan:1.0 m0_bscan RESET" *) output m0_bscan_reset;
  (* x_interface_info = "xilinx.com:interface:bscan:1.0 m0_bscan RUNTEST" *) output m0_bscan_runtest;
  (* x_interface_info = "xilinx.com:interface:bscan:1.0 m0_bscan SEL" *) output m0_bscan_sel;
  (* x_interface_info = "xilinx.com:interface:bscan:1.0 m0_bscan SHIFT" *) output m0_bscan_shift;
  (* x_interface_info = "xilinx.com:interface:bscan:1.0 m0_bscan TCK" *) output m0_bscan_tck;
  (* x_interface_info = "xilinx.com:interface:bscan:1.0 m0_bscan TDI" *) output m0_bscan_tdi;
  (* x_interface_info = "xilinx.com:interface:bscan:1.0 m0_bscan TDO" *) input m0_bscan_tdo;
  (* x_interface_info = "xilinx.com:interface:bscan:1.0 m0_bscan TMS" *) output m0_bscan_tms;
  (* x_interface_info = "xilinx.com:interface:bscan:1.0 m0_bscan UPDATE" *) output m0_bscan_update;

  wire bs_switch_0_m0_bscan_BSCANID_en;
  wire bs_switch_0_m0_bscan_CAPTURE;
  wire bs_switch_0_m0_bscan_DRCK;
  wire bs_switch_0_m0_bscan_RESET;
  wire bs_switch_0_m0_bscan_RUNTEST;
  wire bs_switch_0_m0_bscan_SEL;
  wire bs_switch_0_m0_bscan_SHIFT;
  wire bs_switch_0_m0_bscan_TCK;
  wire bs_switch_0_m0_bscan_TDI;
  wire bs_switch_0_m0_bscan_TDO;
  wire bs_switch_0_m0_bscan_TMS;
  wire bs_switch_0_m0_bscan_UPDATE;
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
  wire bsip_tap_tdo;
  wire jtag_tck_1;
  wire jtag_tdi_1;
  wire jtag_tms_1;

  assign bs_switch_0_m0_bscan_TDO = m0_bscan_tdo;
  assign jtag_tck_1 = jtag_tck;
  assign jtag_tdi_1 = jtag_tdi;
  assign jtag_tdo = bsip_tap_tdo;
  assign jtag_tms_1 = jtag_tms;
  assign m0_bscan_bscanid_en = bs_switch_0_m0_bscan_BSCANID_en;
  assign m0_bscan_capture = bs_switch_0_m0_bscan_CAPTURE;
  assign m0_bscan_drck = bs_switch_0_m0_bscan_DRCK;
  assign m0_bscan_reset = bs_switch_0_m0_bscan_RESET;
  assign m0_bscan_runtest = bs_switch_0_m0_bscan_RUNTEST;
  assign m0_bscan_sel = bs_switch_0_m0_bscan_SEL;
  assign m0_bscan_shift = bs_switch_0_m0_bscan_SHIFT;
  assign m0_bscan_tck = bs_switch_0_m0_bscan_TCK;
  assign m0_bscan_tdi = bs_switch_0_m0_bscan_TDI;
  assign m0_bscan_tms = bs_switch_0_m0_bscan_TMS;
  assign m0_bscan_update = bs_switch_0_m0_bscan_UPDATE;
  bd_54be_bs_switch_0_0 bs_switch_0
       (.bscanid_en_0(bs_switch_0_m0_bscan_BSCANID_en),
        .capture_0(bs_switch_0_m0_bscan_CAPTURE),
        .drck_0(bs_switch_0_m0_bscan_DRCK),
        .reset_0(bs_switch_0_m0_bscan_RESET),
        .runtest_0(bs_switch_0_m0_bscan_RUNTEST),
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
        .sel_0(bs_switch_0_m0_bscan_SEL),
        .shift_0(bs_switch_0_m0_bscan_SHIFT),
        .tck_0(bs_switch_0_m0_bscan_TCK),
        .tdi_0(bs_switch_0_m0_bscan_TDI),
        .tdo_0(bs_switch_0_m0_bscan_TDO),
        .tms_0(bs_switch_0_m0_bscan_TMS),
        .update_0(bs_switch_0_m0_bscan_UPDATE));
  bd_54be_bsip_0 bsip
       (.capture(bsip_m_bscan_CAPTURE),
        .drck(bsip_m_bscan_DRCK),
        .reset(bsip_m_bscan_RESET),
        .runtest(bsip_m_bscan_RUNTEST),
        .sel(bsip_m_bscan_SEL),
        .shift(bsip_m_bscan_SHIFT),
        .tap_tck(jtag_tck_1),
        .tap_tdi(jtag_tdi_1),
        .tap_tdo(bsip_tap_tdo),
        .tap_tms(jtag_tms_1),
        .tck(bsip_m_bscan_TCK),
        .tdi(bsip_m_bscan_TDI),
        .tdo(bsip_m_bscan_TDO),
        .tms(bsip_m_bscan_TMS),
        .update(bsip_m_bscan_UPDATE));
endmodule
