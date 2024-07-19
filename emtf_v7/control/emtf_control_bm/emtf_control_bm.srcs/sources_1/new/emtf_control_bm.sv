`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/31/2017 02:34:06 PM
// Design Name: 
// Module Name: emtf_control_bm
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module emtf_control_bm
#(
     parameter FL_AW = 27, // NOR flash memory address bus
     parameter FL_DW = 16, // NOR flash memory data bus
     // BAR parameters must match the generated PCIe core
     parameter BAR0 = 32'hFF000000, // 16M aperture for memory access, should be write-combining
     parameter BAR1 = 32'hFFFFFC00 // 1K aperture for registers, should be regular
)
(

    // PCIe IO
    output  [1:0]    pci_exp_txp,
    output  [1:0]    pci_exp_txn,
    input   [1:0]    pci_exp_rxp,
    input   [1:0]    pci_exp_rxn,

    // PCIe clock
    input sys_clk_p,
    input sys_clk_n,

    // LHC clock input
    input lhc_clk_p,
    input lhc_clk_n,
    // clock selected for dejittering
    output bpclk_p,
    output bpclk_n,
    
	// stable clock active at power up
    input clk50_p,
    input clk50_n,
    
	// clock 40 MHz sync to LHC dejittered
	input clk40_p,
	input clk40_n,
	
	// clock output for core FPGA
	output clk40_out,
	
	// ttc data input
	input ttcb_p,
	input ttcb_n,
	
    // sync clock module control
    output s_clk,
    output s_data,
    output s_le,
    input  s_lock,
    output s_sync,
	input  s_hold,
	input  s_los,

	// flash
	output [FL_AW:1]  fla,
	inout [FL_DW-1:0] fldq,
	output 		   flce,
	output 		   floe,
	output 		   flwe,
	output 		   flrst,
	output 		   flclk,
	output 		   fladv,
	input 			   flwait,

	// core FPGA configuration
	output 		 cfcclk,
	output 		 cfcsi_b,
	input 		 cfdone,
	input 		 cfdout_busy,
	output 	 	 cfpudc,
	input 		 cfinit,
	output [2:0] cfm,
	output 		 cfprogram,
	output 		 cfrdwr,
	output [15:0] core_d,
	
	output pcie_clk,

	output axi_resetn,
	output core_phase_inc,

    // ttc outputs	
	output reg mpc_inject,
	output reg l1a,
	output bc0,
	output ev_cnt_reset,
	output reg or_cnt_reset,
	output reg resync,
    output reg hard_reset,

	output ev_cnt_reset_tp,
    
    input ext_clk_in,
    input [13:0] ext_data_in,
    output ext_clk_out,
    output [13:0] ext_data_out,
    
    output [1:0] z,
    
    // DAQ RX link
    input  daq_rxn_in,
    input  daq_rxp_in,
    output daq_txn_out,
    output daq_txp_out,

    // DAQ RX bus to core FPGA
    output k_rxresetdone,
    output [1:0] k_rxnotintable,
    output [1:0] k_rxchariscomma,
    output [1:0] k_rxcharisk,
    output [15:0] k_rxdata,
    output k_rx_clk,
    
    output pcie_led,
    output lock_led,
    output lhc_clk_good
);

	assign z = 2'bz;

	wire clk50;
	wire lhc_clk;
	wire sys_rst_n_c;
	wire s_done; 
	wire s_en = 1'b0;
    wire [31:0] clk_word;
	

	// clock module configuration logic and clock buffers
	clocks clocks_
	(
		// LHC clock input
		.lhc_clk_p (lhc_clk_p),
		.lhc_clk_n (lhc_clk_n),
		// clock selected for dejittering
		.bpclk_p (bpclk_p),
		.bpclk_n (bpclk_n),
		
		.clk50_p (clk50_p),
		.clk50_n (clk50_n),
		.clk50   (clk50),
		
		.clk40_p (clk40_p),
		.clk40_n (clk40_n),
		.clk40   (clk40),

		.lhc_clk (lhc_clk),
		
		// sync clock
		.s_clk  (s_clk ),
		.s_data (s_data),
		.s_le   (s_le  ),
		.s_lock (s_lock),
		.s_sync (s_sync),
		.s_en   (s_en),
		.s_done (s_done),
		
		.clk_config_done (sys_rst_n_c),
		.clk_word (clk_word),
		.lhc_clk_good (lhc_clk_good)
	);

//	assign clk40_out = clk40;
    wire clk40_out_b;
	// oddr for clock forwarding and obufds for LHC clock
    ODDR clk40_oddr
    (
        .Q(clk40_out_b), // 1-bit DDR output
        .C(lhc_clk), // 1-bit clock input
        .CE(1'b1), // 1-bit clock enable input
        .D1(1'b1), // 1-bit data input (positive edge)
        .D2(1'b0), // 1-bit data input (negative edge)
        .R(1'b0), // 1-bit reset
        .S(1'b0) // 1-bit set
    );
    OBUF clk40_obuf (.O(clk40_out), .I(clk40_out_b));
    
    wire [5:0] pl_ltssm_state; 
    wire user_reset; 
    wire user_lnk_up;
	(* mark_debug = "TRUE" *) wire 		 busy_or;
	wire config_busy = 1'b0;
    
    

	wire [35:0] CONTROL;
	wire sys_rst_p;

   // interface to the FPGA logic
    (* mark_debug = "TRUE" *) wire [63:0]  rd_data_or;
	wire 		 rd_compl_done;
	
	// command wires
    (* mark_debug = "TRUE" *) wire beam_or;
	
	// beaming interface
	(* mark_debug = "TRUE" *) wire [31:0]  beam_addr_or; // memory address to beam to
	(* mark_debug = "TRUE" *) wire [63:0]  beam_data_or; // data
    (* mark_debug = "TRUE" *) wire [31:0]  beam_cnt_or; // beam word count


	// OR buses from submodules
    (* mark_debug = "TRUE" *) wire [63:0]  rd_data [2:0];
    (* mark_debug = "TRUE" *) wire         beam [1:0];
	(* mark_debug = "TRUE" *) wire [31:0]  beam_addr [1:0]; // memory address to beam to
	(* mark_debug = "TRUE" *) wire [63:0]  beam_data [1:0]; // data
    (* mark_debug = "TRUE" *) wire [31:0]  beam_cnt [1:0]; // beam word count
	wire beam_prep;
	(* mark_debug = "TRUE" *) wire beam_prep_or;
	(* mark_debug = "TRUE" *) wire [3:0] 	 busy;
	
    assign rd_data_or      = rd_data     [0] | rd_data     [1] | rd_data     [2];
    assign beam_or         = beam        [0] | beam        [1];
	assign beam_addr_or    = beam_addr   [0] | beam_addr   [1];
    assign beam_data_or    = beam_data   [0] | beam_data   [1];
    assign beam_cnt_or     = beam_cnt    [0] | beam_cnt    [1];
    assign busy_or         = busy        [0] | busy        [1] | busy        [2];
    assign beam_prep_or    = beam_prep;

	wire link_eng_busy;
	reg [31:0] lhc_cnt, pll_cnt;
	wire pcie_clk_buf;
    reg [11:0] bc0_period = 12'habc;
    reg [19:0] resync_cnt = 20'h0;
    reg [19:0] hr_cnt = 20'h0;
    

	xilinx_pcie_2_1_ep_7x pcie_
	(
	    .pci_exp_txp (pci_exp_txp),
	    .pci_exp_txn (pci_exp_txn),
	    .pci_exp_rxp (pci_exp_rxp),
	    .pci_exp_rxn (pci_exp_rxn),
	    .sys_clk_p   (sys_clk_p  ),
	    .sys_clk_n   (sys_clk_n  ),
	    .sys_rst_n   (sys_rst_n_c),
	    .sys_clk     (pcie_clk_buf),
	    .user_clk    (pcie_clk),
	    .pcie_led    (pcie_led),
	    .axi_resetn (axi_resetn)
	 );

	// connections to PIO module that is buried inside the example design
	// too much stuff to bring out through all the hierarchy
	(* mark_debug = "TRUE" *) wire [31:0] rd_addr       = pcie_.app.PIO.PIO_EP_inst.rd_addr;
	(* mark_debug = "TRUE" *) wire        rd_en         = pcie_.app.PIO.PIO_EP_inst.rd_en;

    (* mark_debug = "TRUE" *) wire [31:0] wr_addr       = pcie_.app.PIO.PIO_EP_inst.wr_addr;
    (* mark_debug = "TRUE" *) wire [63:0] wr_data       = pcie_.app.PIO.PIO_EP_inst.wr_data;
    (* mark_debug = "TRUE" *) wire        wr_en         = pcie_.app.PIO.PIO_EP_inst.wr_en;
	(* mark_debug = "TRUE" *) wire        bar_hit       = pcie_.app.PIO.PIO_EP_inst.bar_hit; // shows which BAR is hit
	(* mark_debug = "TRUE" *) wire        wr_addr_valid = pcie_.app.PIO.PIO_EP_inst.wr_addr_valid; // address strobe
	(* mark_debug = "TRUE" *) wire        pcie_rst_n    = pcie_.app.PIO.pio_reset_n;
	(* mark_debug = "TRUE" *) wire        req_compl     = pcie_.app.PIO.req_compl;
	(* mark_debug = "TRUE" *) wire [9:0]  wr_req_len    = pcie_.app.PIO.PIO_EP_inst.req_len; 
	(* mark_debug = "TRUE" *) wire        beaming_in_progress = pcie_.app.PIO.PIO_EP_inst.beaming_in_progress;

	assign pcie_.app.PIO.PIO_EP_inst.beam      = beam_or;
	assign pcie_.app.PIO.PIO_EP_inst.beam_addr = beam_addr_or;
	assign pcie_.app.PIO.PIO_EP_inst.beam_data = beam_data_or;
	assign pcie_.app.PIO.PIO_EP_inst.beam_cnt  = beam_cnt_or;
	assign pcie_.app.PIO.PIO_EP_inst.beam_prep = beam_prep_or;
	assign pcie_.app.PIO.PIO_EP_inst.busy      = busy_or;
	assign pcie_.app.PIO.PIO_EP_inst.wr_busy   = busy_or;
	assign pcie_.app.PIO.PIO_EP_inst.rd_data   = rd_data_or;
	// end of connections to PIO module

    //
	// PCI loopback module
	// used for PCI performance tests

    wire l1a_internal;
	
    pcie_loopback #
	(
		 .BAR0(BAR0), .BAR1(BAR1),
		 .REG_OFF(32'h0), .MEM_OFF(32'h0)
	) lb
    (

         .clk(pcie_clk),
		 .rst_n(pcie_rst_n),
		 
         // read port
		 .rd_addr_i(rd_addr),
		 .rd_data_o(rd_data[0]),
		 .rd_en_i (rd_en),

         // write port
		 .bar_hit(bar_hit),
         .wr_addr_i(wr_addr),
		 .wr_addr_valid (wr_addr_valid),
         .wr_data_i(wr_data),
		 .wr_en_i(wr_en),

		 // beam port
         .beam(beam[0]),
         .beam_addr_o(beam_addr[0]),
         .beam_data_o (beam_data[0]),
         .beam_cnt_o(beam_cnt[0]),
         .beaming_in_progress(beaming_in_progress),
         .busy(busy[0]),
	     .beam_prep (beam_prep),
		 
		 .lhc_cnt (lhc_cnt),
		 .pll_cnt (pll_cnt),
		 .bc0_period (bc0_period),
		 .resync_cnt (resync_cnt),
		 .hr_cnt (hr_cnt),
		 .l1a_internal (l1a_internal),
		 
		 // clock module interface
		 .clk_word (clk_word),
		 .clk_status ({s_los, s_hold, s_lock})
    );

	// NOR flash memory control module
    flash_control #
	(
		 .BAR1(BAR1),
		 .REG_OFF(32'h20), 
		 .FL_AW(FL_AW), .FL_DW(FL_DW)
	) fc 		
	(

         .clk(pcie_clk),
		 .rst_n(pcie_rst_n),

		 // read port
		 .rd_addr_i(rd_addr),
		 .rd_data_o(rd_data[1]),
		 .rd_en_i (rd_en),
		 .req_compl (req_compl),
//		 .rd_compl_done(rd_compl_done),

		 // write port
		 .bar_hit(bar_hit),
		 .wr_addr_i(wr_addr),
		 .wr_addr_valid (wr_addr_valid),
		 .wr_data_i(wr_data),
		 .wr_en_i(wr_en),

		 .busy(busy[1]),

         .fla    (fla),
		 .fldq   (fldq),
		 .flce   (flce),
		 .floe   (floe),
		 .flwe   (flwe),
		 .flrst  (flrst),
		 .flclk  (flclk),
		 .fladv  (fladv),
		 .flwait (flwait),

		 .cfcclk (cfcclk),
		 .cfdone (cfdone),
		 .cfdout_busy (cfdout_busy),
		 .cfinit (cfinit),
		 .cfprogram (cfprogram),
		 .core_d_t (core_d),

         .axi_resetn (axi_resetn)

	 );


	wire clk_200M, clk_200M_locked, clk_250M;
    core_link #
	(
		 .BAR0(BAR0), .BAR1(BAR1),
		 .REG_OFF(32'h40), .MEM_OFF(32'h80000)
	) cl
    (

         .clk(pcie_clk),
		 .rst_n(clk_200M_locked),
		 
         // read port
		 .rd_addr_i(rd_addr),
		 .rd_data_o(rd_data[2]),
		 .rd_en_i (rd_en),

         // write port
		 .bar_hit(bar_hit),
         .wr_addr_i(wr_addr),
		 .wr_addr_valid (wr_addr_valid),
         .wr_data_i(wr_data),
		 .wr_en_i(wr_en),
		 .wr_req_len (wr_req_len),

		 // beam port
         .beam(beam[1]),
         .beam_addr_o(beam_addr[1]),
         .beam_data_o (beam_data[1]),
         .beam_cnt_o(beam_cnt[1]),
         .beaming_in_progress(beaming_in_progress),
         .busy(busy[2]),
	     .eng_busy (link_eng_busy),
	     .config_busy (config_busy),
         
         .idelay_ref_clk (clk_200M),
         .phy_clk (clk_250M),
         .axi_resetn (axi_resetn),
		 .core_phase_inc (core_phase_inc),
         
		.ext_clk_in (ext_clk_in),
		.ext_data_in (ext_data_in),
		.ext_clk_out (ext_clk_out),
		.ext_data_out (ext_data_out)
         
    );

	 // tied core FPGA config signals 
	 assign cfpudc 	  = 1'b0;
	 assign cfm       = 3'b110; // slave selectmap
	 assign cfcsi_b   = 1'b0;
	 assign cfrdwr    = 1'b0;
	 
 	clk_wiz_1 mmcm_
  	(
	   .clk_125M(pcie_clk),      // input clk_125M
	   .clk_200M(clk_200M),     // output clk_200M
	   .clk_250M(clk_250M),     // output clk_200M
	   .reset(!pcie_rst_n),// input resetn
	   .locked(clk_200M_locked)      // output locked
	);
	 

	wire TTCready ;
	wire L1Accept ;
	wire BCntRes  ;
	wire EvCntRes ;
	wire SinErrStr;
	wire DbErrStr ;
	wire BrcstStr ;
	wire [5:0] Brcst;

	TTC_decoder ttcd 
	(
		.TTC_CLK    (lhc_clk ), // FCLKA input
		.TTC_data_p (ttcb_p), // Fabric B (port 3) input
		.TTC_data_n (ttcb_n),
		.TTCready   (TTCready  ), // valid TTC stream seen
		.L1Accept   (L1Accept  ), // decoded L1A out
		.BCntRes    (BCntRes   ), // decoded BC0 out
		.EvCntRes   (EvCntRes  ), // decoded ECR out
		.SinErrStr  (SinErrStr ), // single-bit hamming error seen
		.DbErrStr   (DbErrStr  ), // multi-bit hamming error seen
		.BrcstStr   (BrcstStr  ), // broadcast command strobe
		.Brcst      (Brcst     ),  // broadcast data
		.Clock40    (),
		.ttc_dat    ()
	); 	 

//	assign l1a = L1Accept | l1a_internal;
    always @(posedge lhc_clk) l1a = L1Accept | l1a_internal;
	
	wire bc0_w = bc0;
	wire resync_w = resync;
	assign ev_cnt_reset = EvCntRes;
	assign ev_cnt_reset_tp = EvCntRes;

    // these constants show contents of entire bus {Brcst, EvCntRes, BCntRes}
    // command mapping in upgraded muon trigger TCDS partition is different from CSCTF 
    `define TTC_BCMD_BC0       8'h01
    `define TTC_BCMD_EC0       8'h02
    `define TTC_BCMD_RESYNC    8'h04
    `define TTC_BCMD_OC0       8'h08
    `define TTC_BCMD_TEST_SYNC 8'h0c
    `define TTC_BCMD_START     8'h10
    `define TTC_BCMD_STOP      8'h14
    `define TTC_BCMD_NULL      8'h00
    `define TTC_BCMD_HARDRESET 8'h4c


    assign bc0 = BCntRes;
    reg [11:0] bc0_period_cnt; 

	always @(posedge lhc_clk)
	begin
		mpc_inject = 1'b0;
//		bc0 = 1'b0;
		resync = 1'b0;
		hard_reset = 1'b0;
		or_cnt_reset = 1'b0;
		if (BrcstStr) // command strobe
		begin
//			if (Brcst == 6'h30) mpc_inject = 1'b1; // MPC inject command
//			if (Brcst == 6'h01) bc0 = 1'b1; // bc0 command
//			if (Brcst == 6'h03) resync = 1'b1; // resync command
			if ({Brcst, 2'h0} == `TTC_BCMD_RESYNC)
			begin 
			     resync = 1'b1; // resync command
			     resync_cnt = resync_cnt + 20'h1;
			end
			
			if ({Brcst, 2'h0} == `TTC_BCMD_HARDRESET)
            begin 
                 hard_reset = 1'b1; // resync command
                 hr_cnt = hr_cnt + 20'h1;
            end

            if ({Brcst, 2'h0} == `TTC_BCMD_OC0) or_cnt_reset = 1'b1; // orbit counter reset
        end
		
		if (bc0) 
		begin
		  bc0_period = bc0_period_cnt;
		  bc0_period_cnt = 12'h0;
		end
		else
		  bc0_period_cnt = bc0_period_cnt + 12'h1;
	end
	 
	 reg clk20;
	 always @(posedge clk40)
		clk20 = ~clk20;
		
	reg clk_trig, clk20_r, clk20_rr;
	wire clk_trig_w = clk_trig;
	always @(negedge lhc_clk)
	begin
		clk_trig = 1'b0;
		if ((clk20_rr ^ clk20_r) == 1'b0) clk_trig = 1'b1;
		clk20_rr = clk20_r;
		clk20_r = clk20;
	end
	
	always @(posedge lhc_clk) lhc_cnt = lhc_cnt + 32'h1;
	always @(posedge clk40 ) pll_cnt = pll_cnt + 32'h1;
		
	// DAQ RX link, sends data via parallel bus to core FPGA
	daq_link_rx_exdes daq_link_rx
    (
        .ref_clk (pcie_clk_buf),
        .drp_clk (clk40),
        .RXN_IN  (daq_rxn_in),
        .RXP_IN  (daq_rxp_in),
        .TXN_OUT (daq_txn_out),
        .TXP_OUT (daq_txp_out),
        
        .k_rxresetdone (k_rxresetdone),
        .k_rxnotintable (k_rxnotintable),
        .k_rxchariscomma (k_rxchariscomma),
        .k_rxcharisk (k_rxcharisk),
        .k_rxdata (k_rxdata),
        .gt0_rxoutclk_p (k_rx_clk),
        .soft_reset_i ((!pcie_rst_n) | (!axi_resetn))
        
    );

    assign lock_led = s_lock;
	 
endmodule

