-- Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2020.1 (lin64) Build 2902540 Wed May 27 19:54:35 MDT 2020
-- Date        : Thu Mar  3 13:25:01 2022
-- Host        : endcap-tf2 running 64-bit Ubuntu 18.04.6 LTS
-- Command     : write_vhdl -force -mode funcsim -rename_top debug_bridge_0 -prefix
--               debug_bridge_0_ debug_bridge_0_sim_netlist.vhdl
-- Design      : debug_bridge_0
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7vx690tffg1927-2
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity debug_bridge_0_bd_54be is
  port (
    jtag_tck : in STD_LOGIC;
    jtag_tdi : in STD_LOGIC;
    jtag_tdo : out STD_LOGIC;
    jtag_tms : in STD_LOGIC;
    m0_bscan_bscanid_en : out STD_LOGIC;
    m0_bscan_capture : out STD_LOGIC;
    m0_bscan_drck : out STD_LOGIC;
    m0_bscan_reset : out STD_LOGIC;
    m0_bscan_runtest : out STD_LOGIC;
    m0_bscan_sel : out STD_LOGIC;
    m0_bscan_shift : out STD_LOGIC;
    m0_bscan_tck : out STD_LOGIC;
    m0_bscan_tdi : out STD_LOGIC;
    m0_bscan_tdo : in STD_LOGIC;
    m0_bscan_tms : out STD_LOGIC;
    m0_bscan_update : out STD_LOGIC
  );
  attribute HW_HANDOFF : string;
  attribute HW_HANDOFF of debug_bridge_0_bd_54be : entity is "debug_bridge_0.hwdef";
end debug_bridge_0_bd_54be;

architecture STRUCTURE of debug_bridge_0_bd_54be is
  component debug_bridge_0_bd_54be_bs_switch_0_0 is
  port (
    s_bscan_drck : in STD_LOGIC;
    s_bscan_reset : in STD_LOGIC;
    s_bscan_sel : in STD_LOGIC;
    s_bscan_capture : in STD_LOGIC;
    s_bscan_shift : in STD_LOGIC;
    s_bscan_update : in STD_LOGIC;
    s_bscan_tdi : in STD_LOGIC;
    s_bscan_runtest : in STD_LOGIC;
    s_bscan_tck : in STD_LOGIC;
    s_bscan_tms : in STD_LOGIC;
    s_bscanid_en : in STD_LOGIC;
    s_bscan_tdo : out STD_LOGIC;
    drck_0 : out STD_LOGIC;
    reset_0 : out STD_LOGIC;
    sel_0 : out STD_LOGIC;
    capture_0 : out STD_LOGIC;
    shift_0 : out STD_LOGIC;
    update_0 : out STD_LOGIC;
    tdi_0 : out STD_LOGIC;
    runtest_0 : out STD_LOGIC;
    tck_0 : out STD_LOGIC;
    tms_0 : out STD_LOGIC;
    bscanid_en_0 : out STD_LOGIC;
    tdo_0 : in STD_LOGIC
  );
  end component debug_bridge_0_bd_54be_bs_switch_0_0;
  component debug_bridge_0_bd_54be_bsip_0 is
  port (
    drck : out STD_LOGIC;
    reset : out STD_LOGIC;
    sel : out STD_LOGIC;
    shift : out STD_LOGIC;
    tdi : out STD_LOGIC;
    update : out STD_LOGIC;
    capture : out STD_LOGIC;
    runtest : out STD_LOGIC;
    tck : out STD_LOGIC;
    tms : out STD_LOGIC;
    tap_tdo : out STD_LOGIC;
    tdo : in STD_LOGIC;
    tap_tdi : in STD_LOGIC;
    tap_tms : in STD_LOGIC;
    tap_tck : in STD_LOGIC
  );
  end component debug_bridge_0_bd_54be_bsip_0;
  signal bsip_m_bscan_CAPTURE : STD_LOGIC;
  signal bsip_m_bscan_DRCK : STD_LOGIC;
  signal bsip_m_bscan_RESET : STD_LOGIC;
  signal bsip_m_bscan_RUNTEST : STD_LOGIC;
  signal bsip_m_bscan_SEL : STD_LOGIC;
  signal bsip_m_bscan_SHIFT : STD_LOGIC;
  signal bsip_m_bscan_TCK : STD_LOGIC;
  signal bsip_m_bscan_TDI : STD_LOGIC;
  signal bsip_m_bscan_TDO : STD_LOGIC;
  signal bsip_m_bscan_TMS : STD_LOGIC;
  signal bsip_m_bscan_UPDATE : STD_LOGIC;
  attribute X_CORE_INFO : string;
  attribute X_CORE_INFO of bs_switch_0 : label is "bs_switch_v1_0_0_bs_switch,Vivado 2020.1.1_AR73018";
  attribute X_CORE_INFO of bsip : label is "bsip_v1_1_0_bsip,Vivado 2020.1.1_AR73018";
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of m0_bscan_bscanid_en : signal is "xilinx.com:interface:bscan:1.0 m0_bscan BSCANID_en";
  attribute X_INTERFACE_INFO of m0_bscan_capture : signal is "xilinx.com:interface:bscan:1.0 m0_bscan CAPTURE";
  attribute X_INTERFACE_INFO of m0_bscan_drck : signal is "xilinx.com:interface:bscan:1.0 m0_bscan DRCK";
  attribute X_INTERFACE_INFO of m0_bscan_reset : signal is "xilinx.com:interface:bscan:1.0 m0_bscan RESET";
  attribute X_INTERFACE_INFO of m0_bscan_runtest : signal is "xilinx.com:interface:bscan:1.0 m0_bscan RUNTEST";
  attribute X_INTERFACE_INFO of m0_bscan_sel : signal is "xilinx.com:interface:bscan:1.0 m0_bscan SEL";
  attribute X_INTERFACE_INFO of m0_bscan_shift : signal is "xilinx.com:interface:bscan:1.0 m0_bscan SHIFT";
  attribute X_INTERFACE_INFO of m0_bscan_tck : signal is "xilinx.com:interface:bscan:1.0 m0_bscan TCK";
  attribute X_INTERFACE_INFO of m0_bscan_tdi : signal is "xilinx.com:interface:bscan:1.0 m0_bscan TDI";
  attribute X_INTERFACE_INFO of m0_bscan_tdo : signal is "xilinx.com:interface:bscan:1.0 m0_bscan TDO";
  attribute X_INTERFACE_INFO of m0_bscan_tms : signal is "xilinx.com:interface:bscan:1.0 m0_bscan TMS";
  attribute X_INTERFACE_INFO of m0_bscan_update : signal is "xilinx.com:interface:bscan:1.0 m0_bscan UPDATE";
begin
bs_switch_0: component debug_bridge_0_bd_54be_bs_switch_0_0
     port map (
      bscanid_en_0 => m0_bscan_bscanid_en,
      capture_0 => m0_bscan_capture,
      drck_0 => m0_bscan_drck,
      reset_0 => m0_bscan_reset,
      runtest_0 => m0_bscan_runtest,
      s_bscan_capture => bsip_m_bscan_CAPTURE,
      s_bscan_drck => bsip_m_bscan_DRCK,
      s_bscan_reset => bsip_m_bscan_RESET,
      s_bscan_runtest => bsip_m_bscan_RUNTEST,
      s_bscan_sel => bsip_m_bscan_SEL,
      s_bscan_shift => bsip_m_bscan_SHIFT,
      s_bscan_tck => bsip_m_bscan_TCK,
      s_bscan_tdi => bsip_m_bscan_TDI,
      s_bscan_tdo => bsip_m_bscan_TDO,
      s_bscan_tms => bsip_m_bscan_TMS,
      s_bscan_update => bsip_m_bscan_UPDATE,
      s_bscanid_en => '0',
      sel_0 => m0_bscan_sel,
      shift_0 => m0_bscan_shift,
      tck_0 => m0_bscan_tck,
      tdi_0 => m0_bscan_tdi,
      tdo_0 => m0_bscan_tdo,
      tms_0 => m0_bscan_tms,
      update_0 => m0_bscan_update
    );
bsip: component debug_bridge_0_bd_54be_bsip_0
     port map (
      capture => bsip_m_bscan_CAPTURE,
      drck => bsip_m_bscan_DRCK,
      reset => bsip_m_bscan_RESET,
      runtest => bsip_m_bscan_RUNTEST,
      sel => bsip_m_bscan_SEL,
      shift => bsip_m_bscan_SHIFT,
      tap_tck => jtag_tck,
      tap_tdi => jtag_tdi,
      tap_tdo => jtag_tdo,
      tap_tms => jtag_tms,
      tck => bsip_m_bscan_TCK,
      tdi => bsip_m_bscan_TDI,
      tdo => bsip_m_bscan_TDO,
      tms => bsip_m_bscan_TMS,
      update => bsip_m_bscan_UPDATE
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity debug_bridge_0 is
  port (
    jtag_tdi : in STD_LOGIC;
    jtag_tdo : out STD_LOGIC;
    jtag_tms : in STD_LOGIC;
    jtag_tck : in STD_LOGIC;
    m0_bscan_bscanid_en : out STD_LOGIC;
    m0_bscan_capture : out STD_LOGIC;
    m0_bscan_drck : out STD_LOGIC;
    m0_bscan_reset : out STD_LOGIC;
    m0_bscan_runtest : out STD_LOGIC;
    m0_bscan_sel : out STD_LOGIC;
    m0_bscan_shift : out STD_LOGIC;
    m0_bscan_tck : out STD_LOGIC;
    m0_bscan_tdi : out STD_LOGIC;
    m0_bscan_tdo : in STD_LOGIC;
    m0_bscan_tms : out STD_LOGIC;
    m0_bscan_update : out STD_LOGIC
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of debug_bridge_0 : entity is true;
  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of debug_bridge_0 : entity is "debug_bridge_0,bd_54be,{}";
  attribute DowngradeIPIdentifiedWarnings : string;
  attribute DowngradeIPIdentifiedWarnings of debug_bridge_0 : entity is "yes";
  attribute X_CORE_INFO : string;
  attribute X_CORE_INFO of debug_bridge_0 : entity is "bd_54be,Vivado 2020.1.1_AR73018";
end debug_bridge_0;

architecture STRUCTURE of debug_bridge_0 is
  attribute HW_HANDOFF : string;
  attribute HW_HANDOFF of inst : label is "debug_bridge_0.hwdef";
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of m0_bscan_bscanid_en : signal is "xilinx.com:interface:bscan:1.0 m0_bscan BSCANID_en";
  attribute X_INTERFACE_INFO of m0_bscan_capture : signal is "xilinx.com:interface:bscan:1.0 m0_bscan CAPTURE";
  attribute X_INTERFACE_INFO of m0_bscan_drck : signal is "xilinx.com:interface:bscan:1.0 m0_bscan DRCK";
  attribute X_INTERFACE_INFO of m0_bscan_reset : signal is "xilinx.com:interface:bscan:1.0 m0_bscan RESET";
  attribute X_INTERFACE_INFO of m0_bscan_runtest : signal is "xilinx.com:interface:bscan:1.0 m0_bscan RUNTEST";
  attribute X_INTERFACE_INFO of m0_bscan_sel : signal is "xilinx.com:interface:bscan:1.0 m0_bscan SEL";
  attribute X_INTERFACE_INFO of m0_bscan_shift : signal is "xilinx.com:interface:bscan:1.0 m0_bscan SHIFT";
  attribute X_INTERFACE_INFO of m0_bscan_tck : signal is "xilinx.com:interface:bscan:1.0 m0_bscan TCK";
  attribute X_INTERFACE_INFO of m0_bscan_tdi : signal is "xilinx.com:interface:bscan:1.0 m0_bscan TDI";
  attribute X_INTERFACE_INFO of m0_bscan_tdo : signal is "xilinx.com:interface:bscan:1.0 m0_bscan TDO";
  attribute X_INTERFACE_INFO of m0_bscan_tms : signal is "xilinx.com:interface:bscan:1.0 m0_bscan TMS";
  attribute X_INTERFACE_INFO of m0_bscan_update : signal is "xilinx.com:interface:bscan:1.0 m0_bscan UPDATE";
begin
inst: entity work.debug_bridge_0_bd_54be
     port map (
      jtag_tck => jtag_tck,
      jtag_tdi => jtag_tdi,
      jtag_tdo => jtag_tdo,
      jtag_tms => jtag_tms,
      m0_bscan_bscanid_en => m0_bscan_bscanid_en,
      m0_bscan_capture => m0_bscan_capture,
      m0_bscan_drck => m0_bscan_drck,
      m0_bscan_reset => m0_bscan_reset,
      m0_bscan_runtest => m0_bscan_runtest,
      m0_bscan_sel => m0_bscan_sel,
      m0_bscan_shift => m0_bscan_shift,
      m0_bscan_tck => m0_bscan_tck,
      m0_bscan_tdi => m0_bscan_tdi,
      m0_bscan_tdo => m0_bscan_tdo,
      m0_bscan_tms => m0_bscan_tms,
      m0_bscan_update => m0_bscan_update
    );
end STRUCTURE;
