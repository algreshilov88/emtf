//-----------------------------------------------------------------------------
//
// (c) Copyright 2010-2011 Xilinx, Inc. All rights reserved.
//
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
//
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
//
//-----------------------------------------------------------------------------
// Project    : Series-7 Integrated Block for PCI Express
// File       : PIO_EP.v
// Version    : 3.3
//
// Description: Endpoint Programmed I/O module.
//              Consists of Receive and Transmit modules and a Memory Aperture
//
//------------------------------------------------------------------------------

`timescale 1ps/1ps

(* DowngradeIPIdentifiedWarnings = "yes" *)
module PIO_EP #(
  parameter C_DATA_WIDTH = 64,            // RX/TX interface data width

  // Do not override parameters below this line
  parameter KEEP_WIDTH = C_DATA_WIDTH / 8,              // TSTRB width
  parameter TCQ        = 1
) (

  input                         clk,
  input                         rst_n,

  // AXIS TX
  input                         s_axis_tx_tready,
  output  [C_DATA_WIDTH-1:0]    s_axis_tx_tdata,
  output  [KEEP_WIDTH-1:0]      s_axis_tx_tkeep,
  output                        s_axis_tx_tlast,
  output                        s_axis_tx_tvalid,
  output                        tx_src_dsc,

  //AXIS RX
  input   [C_DATA_WIDTH-1:0]    m_axis_rx_tdata,
  input   [KEEP_WIDTH-1:0]      m_axis_rx_tkeep,
  input                         m_axis_rx_tlast,
  input                         m_axis_rx_tvalid,
  output                        m_axis_rx_tready,
  input   [21:0]                m_axis_rx_tuser,

  output                        req_compl,
  output                        compl_done,
  output eng_busy,

  input   [15:0]                cfg_completer_id,
  input [15:0] cfg_dcommand
);

    // Local wires

    wire  [31:0]      rd_addr;
    (* mark_debug = "TRUE" *) wire  [3:0]       rd_be;
    wire  [63:0]      rd_data;

    wire  [31:0]      wr_addr;
    (* mark_debug = "TRUE" *) wire  [7:0]       wr_be;
    wire  [63:0]      wr_data;
    wire              wr_en;
    wire              wr_busy;
	wire          bar_hit; // shows which BAR is hit
	wire          wr_addr_valid; // address strobe

    (* mark_debug = "TRUE" *) wire              req_compl_wd;

    (* mark_debug = "TRUE" *) wire  [2:0]       req_tc;
    (* mark_debug = "TRUE" *) wire              req_td;
    (* mark_debug = "TRUE" *) wire              req_ep;
    (* mark_debug = "TRUE" *) wire  [1:0]       req_attr;
    (* mark_debug = "TRUE" *) wire  [9:0]       req_len;
    (* mark_debug = "TRUE" *) wire  [15:0]      req_rid;
    (* mark_debug = "TRUE" *) wire  [7:0]       req_tag;
    (* mark_debug = "TRUE" *) wire  [7:0]       req_be;
    (* mark_debug = "TRUE" *) wire  [31:0]      req_addr;

	wire        cfg_bus_mstr_enable = 1'b1;
	wire        rd_en;
	wire        beam;
	wire [31:0] beam_addr;
	wire [63:0] beam_data;
	wire [31:0] beam_cnt;
	wire        beaming_in_progress;
	wire        busy;
	wire beam_prep;
	reg beam_busy;
	(* mark_debug = "TRUE" *) wire beam_busy_w = beam_busy;
/*
	always @(posedge clk)
	begin
		if (beam_prep  == 1'b1) beam_busy = 1'b1; // starts when beam_length register written
		if (compl_done == 1'b1) beam_busy = 1'b0; // stops when beam_to register read completes
	end
*/
	// engines are busy for any reason
	assign eng_busy = /*beam_busy | */ tx_eng_busy | rx_eng_busy; 


	// PCI loopback module
	// used for PCI performance tests

    wire l1a_internal;
    parameter BAR0 = 32'hFF000000; // 16M aperture for memory access, should be write-combining
	parameter BAR1 = 32'hFFFFFC00; // 1K aperture for registers, should be regular
	


    //
    // Local-Link Receive Controller
    //

  PIO_RX_ENGINE #(
    .C_DATA_WIDTH( C_DATA_WIDTH ),
    .KEEP_WIDTH( KEEP_WIDTH ),
    .TCQ( TCQ )

  ) EP_RX_inst (

    .clk(clk),                              // I
    .rst_n(rst_n),                          // I

    // AXIS RX
    .m_axis_rx_tdata( m_axis_rx_tdata ),    // I
    .m_axis_rx_tkeep( m_axis_rx_tkeep ),    // I
    .m_axis_rx_tlast( m_axis_rx_tlast ),    // I
    .m_axis_rx_tvalid( m_axis_rx_tvalid ),  // I
    .m_axis_rx_tready( m_axis_rx_tready ),  // O
    .m_axis_rx_tuser ( m_axis_rx_tuser ),   // I

    // Handshake with Tx engine
    .req_compl(req_compl),              // O
    .req_compl_wd(req_compl_wd),            // O
    .compl_done(compl_done),            // I

    .req_tc(req_tc),                        // O [2:0]
    .req_td(req_td),                        // O
    .req_ep(req_ep),                        // O
    .req_attr(req_attr),                    // O [1:0]
    .req_len(req_len),                      // O [9:0]
    .req_rid(req_rid),                      // O [15:0]
    .req_tag(req_tag),                      // O [7:0]
    .req_be(req_be),                        // O [7:0]
    .req_addr(req_addr),                    // O [12:0]
                                            
    // Memory Write Port
	.bar_hit (bar_hit),
    .wr_addr(wr_addr),                      // O [10:0]
	.wr_addr_valid (wr_addr_valid),
    .wr_be(wr_be),                          // O [7:0]
    .wr_data(wr_data),                      // O [31:0]
    .wr_en(wr_en),                          // O
    .wr_busy(wr_busy),                       // I
	.rx_eng_busy (rx_eng_busy)
  );

    //
    // Local-Link Transmit Controller
    //

  PIO_TX_ENGINE #(
    .C_DATA_WIDTH( C_DATA_WIDTH ),
    .KEEP_WIDTH( KEEP_WIDTH ),
    .TCQ( TCQ )
  )EP_TX_inst(

    .clk(clk),                                  // I
    .rst_n(rst_n),                              // I

    // AXIS Tx
    .s_axis_tx_tready( s_axis_tx_tready ),      // I
    .s_axis_tx_tdata( s_axis_tx_tdata ),        // O
    .s_axis_tx_tkeep( s_axis_tx_tkeep ),        // O
    .s_axis_tx_tlast( s_axis_tx_tlast ),        // O
    .s_axis_tx_tvalid( s_axis_tx_tvalid ),      // O
    .tx_src_dsc( tx_src_dsc ),                  // O

    // Handshake with Rx engine
    .req_compl(req_compl),                // I
    .req_compl_wd(req_compl_wd),              // I
    .compl_done(compl_done),                // 0

    .req_tc(req_tc),                          // I [2:0]
    .req_td(req_td),                          // I
    .req_ep(req_ep),                          // I
    .req_attr(req_attr),                      // I [1:0]
    .req_len(req_len),                        // I [9:0]
    .req_rid(req_rid),                        // I [15:0]
    .req_tag(req_tag),                        // I [7:0]
    .req_be(req_be),                          // I [7:0]
    .req_addr(req_addr),                      // I [12:0]

    // Read Port

    .rd_addr(rd_addr),                        // O [10:0]
    .rd_be(rd_be),                            // O [3:0]
    .rd_data(rd_data),                        // I [31:0]
	.rd_en (rd_en),

    .completer_id(cfg_completer_id),          // I [15:0]
  
	.cfg_bus_mstr_enable (cfg_bus_mstr_enable),
    .cfg_dcommand (cfg_dcommand), 
    .beam (beam),
    .beam_addr (beam_addr),
    .beam_data (beam_data),
    .beam_cnt (beam_cnt),
    .beaming_in_progress (beaming_in_progress),
    .busy (busy),
	.tx_eng_busy (tx_eng_busy)

    );


  (* mark_debug = "TRUE" *) wire                    s_axis_tx_tready_w = s_axis_tx_tready;
//  (* mark_debug = "TRUE" *) wire [C_DATA_WIDTH-1:0] s_axis_tx_tdata_w = s_axis_tx_tdata;
  (* mark_debug = "TRUE" *) wire [KEEP_WIDTH-1:0]   s_axis_tx_tkeep_w = s_axis_tx_tkeep;
  (* mark_debug = "TRUE" *) wire                    s_axis_tx_tlast_w = s_axis_tx_tlast;
  (* mark_debug = "TRUE" *) wire                    s_axis_tx_tvalid_w = s_axis_tx_tvalid;
  (* mark_debug = "TRUE" *) wire [C_DATA_WIDTH-1:0] m_axis_rx_tdata_w = m_axis_rx_tdata;
  (* mark_debug = "TRUE" *) wire [KEEP_WIDTH-1:0]   m_axis_rx_tkeep_w = m_axis_rx_tkeep;
  (* mark_debug = "TRUE" *) wire                    m_axis_rx_tlast_w = m_axis_rx_tlast;
  (* mark_debug = "TRUE" *) wire                    m_axis_rx_tvalid_w = m_axis_rx_tvalid;
  (* mark_debug = "TRUE" *) wire                    m_axis_rx_tready_w = m_axis_rx_tready;
  (* mark_debug = "TRUE" *) wire [21:0]             m_axis_rx_tuser_w = m_axis_rx_tuser;
  (* mark_debug = "TRUE" *) wire                    req_compl_w = req_compl;
  (* mark_debug = "TRUE" *) wire                    compl_done_w = compl_done;
  (* mark_debug = "TRUE" *) wire                    eng_busy_w = eng_busy;


endmodule // PIO_EP

