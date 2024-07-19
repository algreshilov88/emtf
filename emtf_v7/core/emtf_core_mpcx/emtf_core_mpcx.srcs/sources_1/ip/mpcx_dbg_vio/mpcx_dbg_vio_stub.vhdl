-- Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2020.1 (lin64) Build 2902540 Wed May 27 19:54:35 MDT 2020
-- Date        : Thu Mar  3 13:24:28 2022
-- Host        : endcap-tf2 running 64-bit Ubuntu 18.04.6 LTS
-- Command     : write_vhdl -force -mode synth_stub -rename_top mpcx_dbg_vio -prefix
--               mpcx_dbg_vio_ mpcx_dbg_vio_stub.vhdl
-- Design      : mpcx_dbg_vio
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7vx690tffg1927-2
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mpcx_dbg_vio is
  Port ( 
    clk : in STD_LOGIC;
    probe_out0 : out STD_LOGIC_VECTOR ( 2 downto 0 );
    probe_out1 : out STD_LOGIC_VECTOR ( 2 downto 0 );
    probe_out2 : out STD_LOGIC_VECTOR ( 2 downto 0 );
    probe_out3 : out STD_LOGIC_VECTOR ( 3 downto 0 );
    probe_out4 : out STD_LOGIC_VECTOR ( 3 downto 0 );
    probe_out5 : out STD_LOGIC_VECTOR ( 3 downto 0 );
    probe_out6 : out STD_LOGIC_VECTOR ( 2 downto 0 );
    probe_out7 : out STD_LOGIC_VECTOR ( 2 downto 0 );
    probe_out8 : out STD_LOGIC_VECTOR ( 2 downto 0 );
    probe_out9 : out STD_LOGIC_VECTOR ( 0 to 0 );
    probe_out10 : out STD_LOGIC_VECTOR ( 0 to 0 );
    probe_out11 : out STD_LOGIC_VECTOR ( 0 to 0 );
    probe_out12 : out STD_LOGIC_VECTOR ( 2 downto 0 );
    probe_out13 : out STD_LOGIC_VECTOR ( 2 downto 0 );
    probe_out14 : out STD_LOGIC_VECTOR ( 2 downto 0 )
  );

end mpcx_dbg_vio;

architecture stub of mpcx_dbg_vio is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk,probe_out0[2:0],probe_out1[2:0],probe_out2[2:0],probe_out3[3:0],probe_out4[3:0],probe_out5[3:0],probe_out6[2:0],probe_out7[2:0],probe_out8[2:0],probe_out9[0:0],probe_out10[0:0],probe_out11[0:0],probe_out12[2:0],probe_out13[2:0],probe_out14[2:0]";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "vio,Vivado 2020.1";
begin
end;
