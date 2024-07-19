`timescale 1ns / 1ps

`include "../core/vppc_macros.sv"
`include "mgt_interfaces.sv"
`include "interfaces.sv"

`define WITH_CORE

module emtf_core_top
(
    input m_aresetn,
    input pcie_clk,
	input core_phase_inc,

	// core link
	input ext_clk_in,
	input [13:0] ext_data_in,
	output ext_clk_out,
	output [13:0] ext_data_out,
    
    output [3:0] led,
	 
	input clk40_in_p,
	input clk40_in_n,
	input clk40_in,
	
    input [15:0] refclk_p,
    input [15:0] refclk_n,

	// ttc inputs
	input ttc_l1a,
	input ttc_mpc_inject,
	input ttc_bc0,
	input ttc_resync,
    input ttc_ev_cnt_reset,
    input ttc_or_cnt_reset,
    input ttc_hard_reset,
	
	//front panel outputs
	output [3:0] fp,
	output resync_tp,

	// pt lut rldram interface
	inout	[71:0]	pt_dq,
	output	[3:0]	pt_ba,
	output	[19:0]	pt_a,
	output	[7:0]	pt_dk_p_,
	output	[7:0]	pt_dk_n_,
	output	[31:0]	pt_cs,
	output	[3:0]	pt_ref,
	output	[3:0]	pt_we,
	output	pt_reset_rldram,

	// pt lut clock chip inteface
	output pt_leu, 
	output pt_clku,
	inout  pt_datau,
	output pt_goe, 
	input  pt_ld, 
	output pt_sync,

	output ptclk_p_,
	output ptclk_n_,
	inout clk_del,
	
    // inputs from amc13 link receiver in control FPGA
    input k_rxresetdone,
    input [1:0] k_rxnotintable,
    input [1:0] k_rxchariscomma,
    input [1:0] k_rxcharisk,
    input [15:0] k_rxdata,
    input k_rx_clk,
    
    input lhc_clk_good
	
);

`include "../core/spbits.sv"

    mgt_rx ge11_rx [6:0]();
    mgt_rx cppf_rx [6:0]();
    mgt_rx mpc_rx  [4:0][7:0]();
    mgt_rx mpcn_rx [8:0]();
    mgt_tx gmt_tx [1:0]();
    mgt_tx daq_tx [0:0]();
    wire DAQ_0_mmcm_clk;
    wire CPPF_7_mmcm_clk;
    wire CPPF_3_mmcm_clk;

	(* mark_debug *) drp #(.AW(12)) drpt (); // AW parameter must match AW_QUAD parameter in fpga.sv
	(* mark_debug *) wire drprdy;
	
    wire pcie_clk_buf, pcie_clk_ibuf;

      
    wire clk125_nob;
    emtf_serial_io emtf_sio
    (
        .drp_fif  (drpt ),
        .drpclk   (pcie_clk_buf  ),
        .refclk_p (refclk_p),
        .refclk_n (refclk_n),
        .ge11_rx  (ge11_rx ),
        .mpc2_rx  (mpc_rx[2] ),
        .mpc4_rx  (mpc_rx[4] ),
        .cppf_rx  (cppf_rx ),
        .mpc3_rx  (mpc_rx[3] ),
        .mpc1_rx  (mpc_rx[1] ),
        .mpc0_rx  (mpc_rx[0] ),
        .mpcn_rx  (mpcn_rx ),
        .gmt_tx   (gmt_tx  ),
        .daq_tx   (daq_tx  ),
        .CPPF_3_mmcm_clk (CPPF_3_mmcm_clk),
        .DAQ_0_mmcm_clk  (DAQ_0_mmcm_clk ),
        .CPPF_7_mmcm_clk (CPPF_7_mmcm_clk),
        .clk125_nob (clk125_nob)
    );


    IBUFG pcie_clk_buff (.I(pcie_clk), .O(pcie_clk_ibuf));
    BUFG pcie_clk_bufg (.I(pcie_clk_ibuf), .O(pcie_clk_buf));
    
    wire clk40, clk40_inb, clk40_in_w;
    // clock input from PLL
    IBUFDS_GTE2 clk40_buf (.I(clk40_in_p), .IB(clk40_in_n), .CEB(1'b0), .O(clk40_in_w), .ODIV2());
    
    BUFG clk40_bufg (.I(clk40_in_w), .O(clk40_inb));

	wire clk_160;

    // AXI interfaces
    axi_in  m_axi (pcie_clk_buf, m_aresetn); // master outputs
    axi_out s_axi [3:0] (); // slave outputs
    axi_out s_axi_or (); // master inputs
    
    // OR multiplexor for AXI modules' outputs
    axi_or_mux axior 
    (
        .inp  (s_axi),
        .outp (s_axi_or)
    );
    
    wire [8:0] 	   cs [6:0];
    wire [1:0] 		  sel;
    wire [bw_addr-1:0] addr;

    (* mark_debug *) wire [63:0] 	  r_in; // reg data for memory or register
    (* mark_debug *) wire [63:0] 	  r_out_or; // output data from memory or register
    (* mark_debug *) wire 			  we; // write enable for memory or register
	
	(* mark_debug *) wire [63:0] r_out [2:0];
	assign r_out_or = r_out[0] | r_out[1] | r_out[2]; // read data mux for registers
	wire pt_busy;
	wire lat_test;
    wire [63:0] ge11_link_status;
	
	wire [63:0] control_reg; // control register
	wire soft_reset           = control_reg[0]; // GTH reset in MPCs 
	wire local_inject         = control_reg[1]; // inject test data
	wire spy_reset            = control_reg[2]; // reset spy memory
	wire pt_clk_reset         = control_reg[3]; // reset PT LUT clock manager
    assign pt_reset_rldram    = !control_reg[4]; // reset PT LUT memory chips
    wire pt_mrs_command       = control_reg[5]; // MRS command for PT LUT
    wire pt_wr_command        = control_reg[6]; // PT LUT write command
    wire pt_rd_command        = control_reg[7]; // PT LUT read command
    wire pt_iddr_psen         = control_reg[8];
    wire pt_iddr_psinc        = control_reg[9];
    
    wire in_delay_ce          = control_reg[10];
    wire in_delay_inc_dec     = control_reg[11];
    wire in_delay_reset       = control_reg[12];
    wire io_reset             = control_reg[13];
    wire test_patterns_output = control_reg[14];
    wire rxbufreset           = control_reg[15];
    wire lat_test_en          = control_reg[16];
    wire daq_reset            = control_reg[17];
    wire force_oos            = control_reg[18];
    wire mpc_links_hr_en      = control_reg[19]; // enable mpc link reset on hard reset
    wire amc13_txresetdone    = control_reg[20]; // tell AMC13 module that TX is reset
    wire flag_reset           = control_reg[21]; // error flags reset for persisting errors in links
    wire pcie_or_cnt_reset    = control_reg[22]; // TTC commands via PCIE, for debugging
    wire pcie_ev_cnt_reset    = control_reg[23];
    wire pcie_bc0             = control_reg[24];
    wire ge11_link_reset      = control_reg[25];
    
    
	wire [8:0] daq_delay; // daq delay line depth
	
	wire [63:0] fiber_enable;
	
	
	// precise phi and theta of best tracks
	// [best_track_num]
	wire [bw_fph-1:0] bt_phi [2:0];
	wire [bw_th-1:0] 	bt_theta [2:0];
	// [best_track_num][station]
	wire [3:0] 		bt_cpattern [2:0][3:0];
	// ph and th deltas from best stations
	// [best_track_num], last index: 0=12, 1=13, 2=14, 3=23, 4=24, 5=34
	wire [bw_fph-1:0] bt_delta_ph [2:0][5:0];
	wire [bw_th-1:0] 	bt_delta_th [2:0][5:0]; 
	wire [5:0] 		bt_sign_ph[2:0];
	wire [5:0] 		bt_sign_th[2:0];
	// ranks [best_track_num]
	(* mark_debug = "TRUE" *) wire [bwr:0] 		bt_rank [2:0];
	
	// segment IDs
	// [best_track_num][station 0-3]
	reg [seg_ch-1:0] bt_vi [2:0][4:0]; // valid
	reg [1:0] 		bt_hi [2:0][4:0]; // bx index
	reg [3:0] 		bt_ci [2:0][4:0]; // chamber
	reg [4:0] 		bt_si [2:0]; // segment

	wire [bw_fph-1:0] bt_phi_d [2:0];
    (* mark_debug = "TRUE" *) wire [bw_th-1:0]  bt_theta_d [2:0];
    // ph and th deltas from best stations
    // [best_track_num]; last index: 0=12; 1=13; 2=14; 3=23; 4=24; 5=34
    wire [5:0]        bt_sign_ph_d[2:0];
    // ranks [best_track_num]
    (* mark_debug = "TRUE" *) wire [bwr:0]      bt_rank_d [2:0];
    // segment IDs
    // [best_track_num][station 0-3]
    wire [seg_ch-1:0] bt_vi_d [2:0][4:0]; // valid
    wire [1:0]        bt_hi_d [2:0][4:0]; // bx index
    wire [3:0]        bt_ci_d [2:0][4:0]; // chamber
    wire [4:0]        bt_si_d [2:0]; // segment

	(* mark_debug = "TRUE" *)  wire [29:0] ptlut_addr_d [2:0]; // delayed ptlut memory addresses formed by core
	(* mark_debug = "TRUE" *) wire [7:0] gmt_phi_d [2:0]; // phi for gmt
    (* mark_debug = "TRUE" *) wire [8:0] gmt_eta_d [2:0]; // eta for gmt
    (* mark_debug = "TRUE" *) wire [3:0] gmt_qlt_d [2:0]; // quality for gmt
    (* mark_debug = "TRUE" *) wire [2:0] gmt_crg_d; // charge for gmt


    // combined track stub values for injection
    reg [23:0] stub [5:0][8:0][seg_ch-1:0];
    // two stubs for one chamber
    reg [63:0] chamber [5:0][8:0];
    // format of the stub:
    // {q[3:0], cpat[3:0], 1'b0, wg[6:0], hstr[7:0]}

    // [station][chamber][stub], station = 5 is neighbor sector
	wire [8:0] bc0 [5:0];
	wire [8:0] bx0 [5:0];
	wire [8:0] syer [5:0];
	
	wire [25:0] stub_rate [5:0][8:0]; // [station][chamber]

	wire inj_enable;
	wire [63:0] ptlut_config;
	wire [7:0] amc13_to_counter;
	wire [11:0] bxn_tx_offset;
	(* mark_debug = "FALSE" *) wire [15:0] daq_orbit_count;
    (* mark_debug = "FALSE" *) wire [11:0] daq_bxn_counter;

    wire [3071:0] inject_data;
    reg [3071:0] spy_data;
	wire spy_l1a, spy_valid, spy_rank, spy_bc0_err;
	wire [1023:0] mpc_spy_data;
    reg [1023:0] mpc_spy_data_r, mpc_spy_data_rr, mpc_spy_data_rrr;
    reg [7:0] mpc_record; 
    reg mpc_record_or;
    wire [8:0] inj_addr;
    reg ttc_mpc_inject_rx, ttc_or_cnt_reset_rx, ttc_ev_cnt_reset_rx, ttc_bc0_rx, ttc_resync_rx, ttc_l1a_rx, ttc_hard_reset_rx;
    wire [63:0] core_config;


	wire mpc_inject = ttc_mpc_inject_rx && mpc_inj_enable;

    // LCT interfaces [station][chamber][stub]
    //csc_lct core_input_lct [5:0][8:0][1:0]();
    csc_lct inject_lct     [5:0][8:0][1:0]();
    csc_lct mpc_lct        [5:0][8:0][1:0]();

	// GEM interfaces [schamber][layer][cluster]
	ge11_cluster ge11_cl [6:0][1:0][7:0]();

    
    wire en_single;
    (* mark_debug *) wire gem_single_hit;
    (* mark_debug *) wire [bw_fph-1:0] gem_ph_single;
    (* mark_debug *) wire [bw_th-1:0]  gem_th_single;
    
	// connect MPC data or inject data to logic's inputs
	//assign core_input_lct = inj_enable ? inject_lct : mpc_lct; 


    control_to_core_slave_axi ctoc 
    (
        .m_axi (m_axi),
        .m_axo (s_axi_or),
		
		.ext_clk_in   (ext_clk_in  ),
		.ext_data_in  (ext_data_in ),
		.ext_clk_out  (ext_clk_out ),
		.ext_data_out (ext_data_out),
		
		.core_phase_inc (core_phase_inc)
    );

	localparam CORE_LINK_MEM_OFF = 32'h80000; // must match core link memory offset in control FPGA
	localparam AP_BEG = (CORE_LINK_MEM_OFF >> 3); // memory offset in 64-bit words
    (* mark_debug *) wire [11:0] mgtb_addr;
    (* mark_debug *) wire mgtb_en, mgtb_en_r;
    (* mark_debug *) wire [31:0] drpt_drpdo_w = drpt.drpdo;

    core_params_axi #(.BA(AP_BEG + 32'h0)) cp
    (
        .s_axi (m_axi),
        .s_axo (s_axi[0]),
        
        .cs (cs),
        .sel (sel),
        .addr (addr),
        .r_in (r_in), // input data for memory or register
        .r_out (r_out_or), // output data from memory or register
        .we (we), // write enable for memory or register

        .mgtb_addr (mgtb_addr),
        .mgtb_en   (mgtb_en),
        .mgtb_en_r (mgtb_en_r)
    );

	assign drpt.drpaddr = mgtb_addr;// addr;
	assign drpt.drpdi   = r_in;
	assign drpt.drpen   = mgtb_en;
	assign drpt.drpwe   = we;
	assign drpt.int_reg = 1'b0;
	assign r_out[2]     = mgtb_en_r ? drpt.drpdo : 64'h0;
	assign drprdy       = drpt.drprdy;


    wire [63:0] mpc_link_use_bc0_ch1;
    wire [63:0] gth_rx_reset;

/*
    inject_mem_axi_64 #(.BA(AP_BEG + 32'h8000)) bm2
    (
        .s_axi (m_axi),
        .s_axo (s_axi[1]),

        .clk40 (clk40),
        .inject (mpc_inject || local_inject),
        .dout (inject_data),
        .din  (spy_data)
    );
*/

	wire [8*5+9-1:0] bc0_err_period_i; // all bc0 period errors combined


    spy_mem_axi #
	(
		.BA(AP_BEG + 32'h10000)
	) mpc_spy_mem
    (
        .s_axi (m_axi),
        .s_axo (s_axi[2]),
        
        .clkb (clk_160),
		.inject (mpc_inject || local_inject), // start recording on mpc_inject command from TTC or local inject command
        .dout (),
        .din  (mpc_spy_data_rrr),
		
		.daq_delay (daq_delay),
		.l1a (ttc_l1a_rx),
		.rank_valid (bt_rank[0] != 7'h0),
		.inj_addr (inj_addr),
		.spy_reset (spy_reset),
		.spy_l1a (spy_l1a),
		.spy_valid (spy_valid),
		.spy_rank (spy_rank),
		.bc0_err_period_i (bc0_err_period_i),
		.spy_bc0_err (spy_bc0_err),
		.mpc_link_use_bc0_ch1 (mpc_link_use_bc0_ch1),
        .gth_rx_reset (gth_rx_reset)

    );

	//                     [mpc]
	wire [8*16-1:0] mpc_rxdata [4:0];
    wire [8*2-1:0]  mpc_rxdisperr [4:0];
    wire [8*2-1:0]  mpc_rxnotintable [4:0];
	
	wire [9*16-1:0] mpcn_rxdata;
	(* mark_debug = "FALSE" *) wire [23:0] daq_l1a_count;
	reg [63:0] out_word_ser [1:0];
	wire [31:0] amc13_status_cnt;
	wire [63:0] daq_state_cnt;

	assign mpc_spy_data = 
	{
	    bc0_err_period_i,
		out_word_ser[1],
		out_word_ser[0],

		mpc_rxdisperr[4],
		mpc_rxdisperr[3],
		mpc_rxdisperr[2],
		mpc_rxdisperr[1],
		mpc_rxdisperr[0],

		mpc_rxnotintable[4],
		mpc_rxnotintable[3],
		mpc_rxnotintable[2],
		mpc_rxnotintable[1],
		mpc_rxnotintable[0],

//		mpcn_rxdata,
		mpc_rxdata[4],
		mpc_rxdata[3],
		mpc_rxdata[2],
		mpc_rxdata[1],
		mpc_rxdata[0]
	};
	
	// simplified logic for MPC spy memory recording trigger
	always @(posedge clk_160)
	begin
		mpc_spy_data_rrr = mpc_spy_data_rr;
		mpc_spy_data_rr = mpc_spy_data_r;
		mpc_spy_data_r = mpc_spy_data;

//		mpc_record_or = |mpc_record;
//
//		mpc_record = 8'b0;
//		
//		for (i = 0; i < 8; i = i+1)
//		begin
//			if (mpc_rxdata[0][i] == 16'hfeed) mpc_record[i] = 1'b1;
//		end

		// front panel output for latency measurement
//		feed_fp = mpc_rxdata[0][0] == 16'hfeed;
//		feed_fp = 1'b0;
	end
	
	integer i, j, k;
	wire clk_125;

    BUFG clk125_buf (.I(clk125_nob), .O(clk_125));

	wire [4:0] clk_led;
	//                     [station]
	wire [8*10-1:0] link_id [4:0]; // csc
	wire [9*10-1:0] link_id_n; // csc-neighbor
	wire [7:0] ge11_link_id [6:0]; // ge11 [schamber=link]

	wire [7:0] bc0_u [4:0]; // bc0 flags from each chamber before AF
	wire [8:0] bc0_u_n; // bc0 flags from neighbor sector

	wire [7:0] af_delays [48:0];
	wire [7:0] bc0_err_period [4:0];
	wire [8:0] bc0_err_period_n; // bc0 period errors from neighbor sector
	wire [7:0] bc0_err_stuck [4:0];
	wire [4:0] bc0_err_chamber0;
	wire [8*5+9-1:0] rxbyteisaligned ;
	wire [4:0] bc0_err_period_id1; // bc0 errors from CSCID=1 chambers
	
	wire [4:0] rxoutclk;
	wire [2:0] prbs_sel;
    wire [7:0] prbs_err_persist [4:0];
    (* mark_debug = "TRUE" *) wire [63:0] txdata [2:0];
	wire [4:0] txoutclk_async;
	wire [7:0] rx_valid_tp; 
	wire [4:0] txcharisk_0;
	wire [5:0] ttc_bc0_delay_cppf;
	
    wire [63:0] mpc_link_use_bc0_misplaced;
    wire [23:0] hard_reset_to, mpc_link_hr_to;
    wire [1:0] tx_rx_reset_done [8*5+9-1:0];
	wire [8*5+9-1:0] cpll_lock ;
    wire [8*5+9-1:0] gth_tx_reset_done;
    wire [8*5+9-1:0] power_down;
    
    assign lat_test = rx_valid_tp[0] && lat_test_en; // send latency test pulse if any LCT from station 0 is valid, and latency test enabled
	
	genvar gi, gj;
	
	// LEDs
	led_driver ldrv0 (.low_pwr(1'b0),       .high_pwr(ttc_l1a_rx), .led(led[0]), .clk(clk40));
	led_driver ldrv1 (.low_pwr(1'b0),       .high_pwr(bt_rank[0] != 7'h0), .led(led[1]), .clk(clk40));
	led_driver ldrv2 (.low_pwr(1'b0),       .high_pwr(bt_rank[1] != 7'h0), .led(led[2]), .clk(clk40));
	led_driver ldrv3 (.low_pwr(clk_led[0]), .high_pwr(bt_rank[2] != 7'h0), .led(led[3]), .clk(clk40));

	wire [7:0] user_af_delays [48:0];
	wire [7:0] bc0_time_counts [48:0];


    (* mark_debug *) csc_lct_mpcx lct_aligned  [5:0][9:1][1:0]; // [station][CSCID][stub]
    reg ttc_bc0_del;
    (* mark_debug *) wire ttc_bc0_del_w = ttc_bc0_del;

    wire [4:0] automatic_delay [4:0][9:2]; // [station][cscid] 
    wire [4:0] automatic_delay_id1 [4:0][7:0]; // [station][cscid=1 data fragment]
    wire [4:0] automatic_delay_n [9:1]; // [chamber] 

    wire [9:2] alg_out_range  [4:0]; // alignment counter out of range [station][cscid]
    wire [7:0] alg_out_range_id1  [4:0]; // alignment counters out of range      [station][cscid=1 data fragment]
    wire [9:1] alg_out_range_n  ; // alignment counter out of range [station][chamber]

    wire [9:2] bc0_period_err [4:0]; // BC0 period is not exactly one orbit [station][cscid]
    wire [7:0] bc0_period_err_id1 [4:0]; // BC0 periods is not exactly one orbit [station][cscid=1 data fragment]
    wire [9:1] bc0_period_err_n ; // BC0 period is not exactly one orbit [station][chamber]

    wire [4:0] manual_delay [4:0][9:2]; // [station][cscid] 
    wire [4:0] manual_delay_id1 [4:0][7:0]; // [station][cscid=1 data fragment] 
    wire [4:0] manual_delay_n [9:1]; // [chamber]
    
    generate
        for (gi = 0; gi < 5; gi++) // station loop
        begin
            for (gj = 0; gj < 8; gj++) // chamber and data fragment loop
            begin
                assign manual_delay[gi][gj+2] = user_af_delays [gi*8 + gj][4:0]; // gj is chamber here
                assign bc0_time_counts [gi*8 + gj][4:0] = automatic_delay[gi][gj+2]; // gj is chamber here
            end
        end
        
        for (gj = 0; gj < 9; gj++) // chamber loop
        begin
            assign manual_delay_n[gj+1] = user_af_delays [40+gj][4:0];
            assign bc0_time_counts [40+gj][4:0] = automatic_delay_n[gj+1];
        end
    
    endgenerate 

	assign bc0_err_period_i = 
	{
	   bc0_period_err_n,
	   bc0_period_err[4],
	   bc0_period_err[3],
	   bc0_period_err[2],
	   bc0_period_err[1],
	   bc0_period_err[0]
	};  // no registers for bc0_period_err_id1, TBD
	
	assign bc0_err_stuck_i = 
	{
	   alg_out_range[4],
	   alg_out_range[3],
	   alg_out_range[2],
	   alg_out_range[1],
	   alg_out_range[0]
	}; // no registers for alg_out_range_id1 and alg_out_range_n, TBD

    // errors and link IDs from own sector
	(* mark_debug *) wire [7:0] crc_err     [4:0]; // CRC error detected [station][link]
    (* mark_debug *) wire [7:0] err_tst_pat [4:0]; // test counter error detected [station][link]
	wire [9:0] link_id_a   [4:0][7:0]; // link ID [station][link]

    // errors and link IDs from neighbor sector
	(* mark_debug *) wire [8:0] crc_err_n; // CRC error detected [link]
    (* mark_debug *) wire [8:0] err_tst_pat_n; // test counter error detected [link]
	(* mark_debug *) wire [7:0] crc_err_flag     [4:0]; // CRC error detected [station][link]
    (* mark_debug *) wire [7:0] err_tst_pat_flag [4:0]; // test counter error detected [station][link]
	(* mark_debug *) wire [8:0] crc_err_flag_n; // CRC error detected [link]
    (* mark_debug *) wire [8:0] err_tst_pat_flag_n; // test counter error detected [link]
	wire [9:0] link_id_na [8:0]; // link ID [link]

    // make link IDs compatible with old format for now
    assign link_id[0] = {link_id_a[0][7], link_id_a[0][6], link_id_a[0][5], link_id_a[0][4], link_id_a[0][3], link_id_a[0][2], link_id_a[0][1], link_id_a[0][0]};
    assign link_id[1] = {link_id_a[1][7], link_id_a[1][6], link_id_a[1][5], link_id_a[1][4], link_id_a[1][3], link_id_a[1][2], link_id_a[1][1], link_id_a[1][0]};
    assign link_id[2] = {link_id_a[2][7], link_id_a[2][6], link_id_a[2][5], link_id_a[2][4], link_id_a[2][3], link_id_a[2][2], link_id_a[2][1], link_id_a[2][0]};
    assign link_id[3] = {link_id_a[3][7], link_id_a[3][6], link_id_a[3][5], link_id_a[3][4], link_id_a[3][3], link_id_a[3][2], link_id_a[3][1], link_id_a[3][0]};
    assign link_id[4] = {link_id_a[4][7], link_id_a[4][6], link_id_a[4][5], link_id_a[4][4], link_id_a[4][3], link_id_a[4][2], link_id_a[4][1], link_id_a[4][0]};

    assign link_id_n = {link_id_na[8], link_id_na[7], link_id_na[6], link_id_na[5], link_id_na[4], link_id_na[3], link_id_na[2], link_id_na[1], link_id_na[0]};
    wire clk320;
	wire af_enable;
    wire [25:0] hmt_rate_limit;
    wire [8:0] hmt_rate_err [5:0]; // [station][chamber] hmt rate exceeded hmt_rate_limit

    // upgraded MPCX module
    emtf_mpcx_rx_all mpcx_rx_i
    (
        .mpcx_rx             (mpc_rx             ),
        .mpcx_rx_n           (mpcn_rx            ),
        .lct_aligned         (lct_aligned        ),
        .stub_rate           (stub_rate          ),
        .ttc_bc0_del         (ttc_bc0_del        ),
        .automatic_delay     (automatic_delay    ), 
        .automatic_delay_id1 (automatic_delay_id1),
        .automatic_delay_n   (automatic_delay_n  ),
        .manual_delay        (manual_delay       ),
        .manual_delay_id1    (manual_delay_id1   ),
        .manual_delay_n      (manual_delay_n     ),
        .alg_out_range       (alg_out_range      ),
        .bc0_period_err      (bc0_period_err     ),
        .alg_out_range_id1   (alg_out_range_id1  ),
        .bc0_period_err_id1  (bc0_period_err_id1 ),
        .alg_out_range_n     (alg_out_range_n    ),
        .bc0_period_err_n    (bc0_period_err_n   ),
        .en_manual           (~af_enable         ),
	    .crc_err             (crc_err            ),
        .err_tst_pat         (err_tst_pat        ),
	    .crc_err_flag        (crc_err_flag       ),
        .err_tst_pat_flag    (err_tst_pat_flag   ),
	    .link_id             (link_id_a          ),
	    .crc_err_n           (crc_err_n          ),
        .err_tst_pat_n       (err_tst_pat_n      ),
	    .crc_err_flag_n      (crc_err_flag_n     ),
        .err_tst_pat_flag_n  (err_tst_pat_flag_n ),
        .flag_reset          (flag_reset         ),
        .fiber_enable        (fiber_enable[48:0] ),
	    .link_id_n           (link_id_na         ),
        .hmt_rate_limit      (hmt_rate_limit),
        .hmt_rate_err        (hmt_rate_err), // [station][chamber] hmt rate exceeded hmt_rate_limit
        .clk40               (clk40              ),
        .pcie_clk            (pcie_clk_buf       ),
        .clk320              (clk320             )
    );

    wire [5:0] rx_clk_phase_drift;

    // this module detects clock phase drift between RX clocks and fabric clock
    clock_sync_detect clk_sync_det
    (
        .rx_clk      ({
            mpcn_rx[0].rxoutclk, 
            mpc_rx[4][0].rxoutclk, 
            mpc_rx[3][0].rxoutclk, 
            mpc_rx[2][0].rxoutclk, 
            mpc_rx[1][0].rxoutclk, 
            mpc_rx[0][0].rxoutclk}), // clocks from MPC RX, 80M
        .clk_320     (clk320), // fab clk * 8
        .phase_drift (rx_clk_phase_drift), // flags showing clock phase shift relative to fab clk
        .flag_reset  (flag_reset)// error flag resets
    );

    
    //                                        [link][frame]
    (* mark_debug *) wire  [63:0] cppf_rxd [6:0][2:0]; // rx data, 3 frames x 64 bit, for 7 links
    (* mark_debug *) wire  [6:0] cppf_rx_valid; // rx data valid flags
    (* mark_debug = "FALSE" *) wire [7:0] cppf_link_id [6:0];
    wire [6:0] cppf_crc_match;
    wire [15:0] ge11_correction_cnt [6:0];

    cppf_links cppfl
    (
        .mgtrx (cppf_rx),
        
        .rxd (cppf_rxd), // rx data, 3 frames x 64 bit, for 7 links
        .rx_valid (cppf_rx_valid), // rx data valid flags
        .link_id (cppf_link_id),
        .crc_match (cppf_crc_match),
        .clk_40 (clk40), // LHC clk
        .clk_125 (clk_125),
        
        .ttc_bc0 (ttc_bc0_rx),
        .ttc_bc0_delay_cppf (ttc_bc0_delay_cppf),
        .fiber_enable (fiber_enable[49 +: 7])
    );

    wire [233:0]      ge11_rxd [6:0]; ///< GEM rx data, 1 frame x 234 bits, for 7 links
    wire [6:0]        ge11_rx_valid;  ///< GEM data valid flags
    wire [6:0]        ge11_crc_match; ///< CRC match flags from GEM links
    wire [4:0] gem_data_del [6:0][1:0];
    
    wire [9:0] ttc_bc0_delay_gem;
    wire [4:0] automatic_delay_gem [6:0][1:0];
    wire       en_manual_gem;
    wire [1:0] alg_out_range_gem [6:0];
    wire [1:0] bc0_period_err_gem [6:0];

    gem_rx gem_rx_i
    (
        .ge11_rx    (ge11_rx), // inputs from serial links
		.ge11_cl    (ge11_cl), // decoded clusters
        .ge11_rxd       (ge11_rxd      ),
        .ge11_rx_valid  (ge11_rx_valid ), 
        .ge11_crc_match (ge11_crc_match),
		.link_id    (ge11_link_id), // link IDs
        .single_hit (gem_single_hit),
        .ph_single  (gem_ph_single),
        .th_single  (gem_th_single),
        .logic_reset      (ge11_link_reset),
        .ge11_link_status (ge11_link_status),
        .correction_cnt   (ge11_correction_cnt),
        .fiber_enable     (fiber_enable [(49+7) +: 7]),
        .gem_data_del     (gem_data_del),
        .ttc_bc0           (ttc_bc0_rx),
        .ttc_bc0_delay_gem (ttc_bc0_delay_gem  ),
        .automatic_delay   (automatic_delay_gem),
        .en_manual         (en_manual_gem      ),
        .alg_out_range     (alg_out_range_gem  ),
        .bc0_period_err    (bc0_period_err_gem ),
        .flag_reset        (flag_reset),
        .clk40             (clk40)
    );  
	
	wire clk_160_pll;
    reg psen, psen_r, psen_rr;
    wire psdone;
    wire clk120, clk200, clk400;
    wire usrclk_locked;
    reg lcd, lcdr;
    reg [15:0] unlock_cnt;
    
    usrclk_mmcm usrclk_mmcm_
	(
        .CLK_IN1  (clk40_inb),
        .CLK_OUT1 (clk_160),
        .CLK_OUT2 (clk40),
        .CLK_OUT3 (clk120),
        .CLK_OUT4 (clk200),
        .CLK_OUT5 (clk400),
        .RESET    (!m_aresetn),
        .LOCKED   (usrclk_locked)

//        .PSCLK(clk40_inb),
//        .PSEN (1'b0), //(psen), 
//        .PSINCDEC(pt_iddr_psinc),     
//        .PSDONE(),       
	);     

	always @(posedge clk40_inb)
    begin
        psen = 1'b0;
        if (psen_r && !psen_rr)
        begin
            psen = 1'b1;
        end
    
        psen_rr = psen_r;
        psen_r = pt_iddr_psen;
        
        if (lcdr && (!lcd)) unlock_cnt++;
        //if (!m_aresetn) unlock_cnt = 0;
        
        lcdr = lcd;
        lcd = usrclk_locked;
    end


    // clock forwarding for PT LUT module
    ODDR oddr_dk_p (.Q(ptclk_p_), .C(clk200), .CE(1'b1), .D1(1'b1), .D2(1'b0), .S(1'b0), .R(1'b0));
    ODDR oddr_dk_n (.Q(ptclk_n_), .C(clk200), .CE(1'b1), .D1(1'b0), .D2(1'b1), .S(1'b0), .R(1'b0));

//	BUFG clk160b (.I(rxoutclk[0]), .O(clk_160));
	assign clk_160_pll = clk_160;

	reg [31:0] pllclk_cnt;
	always @(posedge clk_160_pll) `inc(pllclk_cnt);



    always @(*)
    begin
    
        // split inject data into chambers
        for (i = 0; i < 54; i = i+1) // chamber loop
        begin
            chamber[i/9][i%9] = inject_data[i*48+: 48];
        end        
    
        for (i = 0; i < 6; i = i+1) // station loop
        begin
            for (j = 0; j < 9; j = j+1) // chamber loop
            begin
                {stub[i][j][1], stub[i][j][0]} = chamber[i][j];
                for (k = 0; k < seg_ch; k = k+1) // stub loop
                begin
                    inject_lct[i][j][k].ql = stub [i][j][k][23:20];
                    inject_lct[i][j][k].cp = stub [i][j][k][19:16];
                    inject_lct[i][j][k].wg = stub [i][j][k][14:8];
                    inject_lct[i][j][k].hs = stub [i][j][k][7:0];
                    inject_lct[i][j][k].vf = (inject_lct[i][j][k].ql != 4'b0) ? 1'b1 : 1'b0; // simulate vpf flag for injection
                end
            end
        end
    end

//                      [word][frame]
    reg [63:0] out_word [1:0][3:0];
    wire [8:0] bt_pt [2:0]; // pt values for best tracks
    (* mark_debug *) wire [8:0] bt_pt_tx [2:0]; // pt values for best tracks, as transmitted to uGMT

    // combine output data into spy word
    always @(*)
    begin
        for (i = 0; i < 3; i = i+1) // best track loop
        begin
		
			out_word[0][i] = 
			{
				bt_rank[i],
				bt_delta_th[i][1], bt_delta_th[i][0], bt_theta[i],
				bt_delta_ph[i][1], bt_delta_ph[i][0], bt_phi[i]
			};
			out_word[1][i] = 
			{
				1'h0,
				bt_pt[i],
				bt_ci[i][4], bt_ci[i][3], bt_ci[i][2], bt_ci[i][1], bt_ci[i][0],
				bt_hi[i][4], bt_hi[i][3], bt_hi[i][2], bt_hi[i][1], bt_hi[i][0],
				bt_vi[i][4], bt_vi[i][3], bt_vi[i][2], bt_vi[i][1], bt_vi[i][0],
				bt_si[i], 
				bt_sign_th[i], bt_sign_ph[i], bt_cpattern[i][0] // only take clct patter from station 1 for now
			};
		
        end
		out_word[0][3] = 64'h0;
		out_word[1][3] = 64'h0;
    end
    
	reg [1:0] out_frame = 2'h0;
	always @(posedge clk_160)
	begin
		out_word_ser[0] = out_word[0][out_frame];
		out_word_ser[1] = out_word[1][out_frame];
		`inc(out_frame);
	end

    wire [29:0] ptlut_addr [2:0]; // memory addresses for pt lut modules
    wire [31:0] ptlut_cs [2:0]; // pre-decoded chip selects
    wire [2:0] ptlut_addr_val; // valid flags for memory addresses
    wire endcap;
    wire [2:0] sector;
	wire [7:0] gmt_phi [2:0]; // phi for gmt
    wire [8:0] gmt_eta [2:0]; // eta for gmt
    wire [3:0] gmt_qlt [2:0]; // quality for gmt
    wire [2:0] gmt_crg; // charge for gmt
    (* mark_debug *) wire [2:0] hmt_out; 
	(* mark_debug *) wire [7:0] nn_pt [2:0]; // NN PT value
    (* mark_debug *) wire [2:0] nn_pt_v; // NN valid flag for PT
	wire [1:0] nn_d0 [2:0]; // NN D0 value
    wire [2:0] nn_d0_v; // NN valid flag for D0
    wire [25:0] hmt_rate [2:0];
    
`ifdef WITH_CORE    
	sp core 
	(
        .lct_i         (lct_aligned),
        .cppf_rxd      (cppf_rxd), // rx data, 3 frames x 64 bit, for 7 links
        .cppf_rx_valid (cppf_rx_valid), // rx data valid flags
		.ge11_cl       (ge11_cl),
		
		.pcs_cs   (cs[5:0]), // chamber selects for only 5 stations + neibghbor 
		.ge11_cs  (cs[6][2:1]), // parameter selects for all GE11 chambers
		.sel      (sel), 
		.addr     (addr), 
		.r_in     (r_in), 
		.r_out    (r_out[0]), 
		.we       (we),

		.bt_phi      (bt_phi),
		.bt_theta    (bt_theta),
		.bt_cpattern (bt_cpattern),
		.bt_delta_ph (bt_delta_ph),
		.bt_delta_th (bt_delta_th),
		.bt_sign_ph  (bt_sign_ph),
		.bt_sign_th  (bt_sign_th),
		.bt_rank     (bt_rank),
		.bt_vi (bt_vi), 
		.bt_hi (bt_hi), 
		.bt_ci (bt_ci), 
		.bt_si (bt_si),
		
		.ptlut_addr     (ptlut_addr),
		.ptlut_cs       (ptlut_cs),
		.ptlut_addr_val (ptlut_addr_val),
        .gmt_phi (gmt_phi),
        .gmt_eta (gmt_eta),
        .gmt_qlt (gmt_qlt),
        .gmt_crg (gmt_crg),
        .hmt_out (hmt_out),
        .hmt_rate (hmt_rate),

        .nn_pt (nn_pt),
        .nn_pt_v (nn_pt_v),
        .nn_d0 (nn_d0),
        
		.clk         (clk40),
		.clk120      (clk120),
		.control_clk (pcie_clk_buf),
		
		.endcap (endcap),
		.sector (sector),
		.core_config (core_config)
	);
`endif

    wire fp_trigger;
    output_delay od
    (
        // inputs
        .bt_phi (bt_phi),
        .bt_theta (bt_theta),
        .bt_sign_ph(bt_sign_ph),
        .bt_rank (bt_rank),
        .bt_vi (bt_vi), // valid
        .bt_hi (bt_hi), // bx index
        .bt_ci (bt_ci), // chamber
        .bt_si (bt_si), // segment
        .ptlut_addr (ptlut_addr), // memory addresses formed by core
        .gmt_phi (gmt_phi),
        .gmt_eta (gmt_eta),
        .gmt_qlt (gmt_qlt),
        .gmt_crg (gmt_crg),
   
        // delayed outputs
        .bt_phi_d (bt_phi_d),
        .bt_theta_d (bt_theta_d),
        .bt_sign_ph_d(bt_sign_ph_d),
        .bt_rank_d (bt_rank_d),
        .bt_vi_d (bt_vi_d), // valid
        .bt_hi_d (bt_hi_d), // bx index
        .bt_ci_d (bt_ci_d), // chamber
        .bt_si_d (bt_si_d), // segment
        .ptlut_addr_d (ptlut_addr_d), // memory addresses formed by core
        .gmt_phi_d (gmt_phi_d),
        .gmt_eta_d (gmt_eta_d),
        .gmt_qlt_d (gmt_qlt_d),
        .gmt_crg_d (gmt_crg_d),
        .fp_trigger (fp_trigger),
    
        .clk (clk40)
    );



    wire [25:0] track_rate [2:0];

    output_formatter of
    (
        .bc0 (ttc_bc0_rx),
   
//        .bt_theta (bt_theta_d),
//        .bt_sign_ph (bt_sign_ph_d),
        
        .bt_rank (bt_rank_d),
        .gmt_phi (gmt_phi_d),
        .gmt_eta (gmt_eta_d),
        .gmt_qlt (gmt_qlt_d),
        .gmt_crg (gmt_crg_d),
        
        .bt_vi (bt_vi_d),
        .bt_hi (bt_hi_d),
        .bt_ci (bt_ci_d),
        .bt_si (bt_si_d),
        
        .bt_pt    (bt_pt),
        .bt_pt_tx (bt_pt_tx),
        .hmt      (hmt_out),
        .nn_pt    (nn_pt),
        .nn_pt_v  (nn_pt_v),
        .nn_d0    (nn_d0),
       
        .txdata (txdata),
       
        .test_patterns_output (test_patterns_output),
        .link_id (link_id[1][9:0]),
        .endcap (endcap),
       
        .clk (clk40),
        .track_rate(track_rate),
        .hard_reset (ttc_hard_reset_rx),
        .hard_reset_to (hard_reset_to)
    );

    generate
    for (gi = 0; gi < 2; gi++)
    begin: gmt_reclock_loop
        gmt_tx_reclock gmt_tx_rc
        (
            .mgttx         (gmt_tx[gi]),
            .CPPF_7_mmcm_clk (gi == 0 ? CPPF_7_mmcm_clk : CPPF_3_mmcm_clk),
            
            .txdata        (txdata),
            .clk_40        (clk40),
            .ttc_bc0       (ttc_bc0_rx),
            .bxn_tx_offset (bxn_tx_offset),
            .link_id       (20'h12345) // need to decide what to do with link id !!!
        );
    end
    endgenerate

	`merge_mem_1(link_id_i, link_id, 10*8, 5);
	wire [8:0] ttc_bc0_delay;
	assign af_delays = bc0_time_counts;
    wire [31:0] pt_clk_word;
    wire [7:0] delayctrl_locked;
    wire [8*9*5-1:0] in_delay_tap, out_delay_tap;
    wire [8*9*5-1:0] in_delay_tap_rb, out_delay_tap_rb;
    wire [4:0] ddr_clk_del;
    wire [63:0] daq_config;
    wire [31:0] fw_date;

    wire           jtag_enable     ;
    wire           jtag_done       ;
    wire [31 : 0 ] jtag_length     ;
    wire [31 : 0 ] jtag_tms_vector ;
    wire [31 : 0 ] jtag_tdi_vector ;
    wire [31 : 0 ] jtag_tdo_vector ;

	register_bank crb
	(
		.cs (cs[6][0]),
		.sel (sel),
		.addr (addr),

		.r_in (r_in), 
		.r_out (r_out[1]), 
		.we (we), 
		.control_clk (pcie_clk_buf),
		
		.control_reg (control_reg),
		.link_id_i (link_id_i),
		.link_id_n_i (link_id_n),
		.cppf_link_id (cppf_link_id),
		.ge11_link_id (ge11_link_id),
		.cppf_crc_match (cppf_crc_match),
        .ge11_link_status (ge11_link_status),
		.fiber_enable (fiber_enable),
		.bc0_time_counts_i (bc0_time_counts),
		.user_af_delays_o (user_af_delays), 
		.inj_addr (inj_addr),
		.ttc_bc0_delay (ttc_bc0_delay),
		.ttc_bc0_delay_cppf (ttc_bc0_delay_cppf),
		.daq_delay (daq_delay),
		.spy_l1a (spy_l1a),
		.spy_valid (spy_valid),
		.spy_rank (spy_rank),
		.spy_bc0_err (spy_bc0_err),
		.af_enable (af_enable),
		.inj_enable (inj_enable),
		.mpc_inj_enable (mpc_inj_enable),
		.bc0_err_period_i (bc0_err_period_i),
		.bc0_err_stuck_i (bc0_err_stuck_i),
		.bc0_err_chamber0_i (bc0_err_chamber0),
		.rxbyteisaligned_i (rxbyteisaligned),
		.clk_cnt ({pllclk_cnt, 32'h0}),
		.pt_clk_word (pt_clk_word),
        .pt_busy (pt_busy),
        .delayctrl_locked (delayctrl_locked),
        .in_delay_tap (in_delay_tap),
        .out_delay_tap (out_delay_tap),
        .in_delay_tap_rb (in_delay_tap_rb),
        .out_delay_tap_rb (out_delay_tap_rb),
        .ddr_clk_del (ddr_clk_del),
        .ptlut_config (ptlut_config),
	    .prbs_sel (prbs_sel),
        .prbs_err_persist (prbs_err_persist),
        .stub_rate(stub_rate),
        .track_rate(track_rate),
        .endcap (endcap),
        .sector (sector),
        .daq_config (daq_config),
        .amc13_to_counter (amc13_to_counter),
        .bxn_tx_offset (bxn_tx_offset),
        .amc13_status_cnt(amc13_status_cnt),
        .daq_state_cnt (daq_state_cnt),
        .fw_date (fw_date),
		.en_single (en_single),
		.core_config (core_config),
        .mpc_link_use_bc0_ch1 (mpc_link_use_bc0_ch1),
        .mpc_link_use_bc0_misplaced (mpc_link_use_bc0_misplaced),
        .gth_rx_reset (gth_rx_reset),
        .unlock_cnt  (unlock_cnt),
        .hard_reset_to (hard_reset_to),
        .mpc_link_hr_to (mpc_link_hr_to),
        .tx_rx_reset_done (tx_rx_reset_done),
       	.cpll_lock (cpll_lock),
        .gth_tx_reset_done (gth_tx_reset_done),
        .power_down (power_down),
	    .crc_err_flag        (crc_err_flag       ),
        .err_tst_pat_flag    (err_tst_pat_flag   ),
	    .crc_err_flag_n      (crc_err_flag_n     ),
        .err_tst_pat_flag_n  (err_tst_pat_flag_n ),
        .rx_clk_phase_drift  (rx_clk_phase_drift),
        
        .jtag_enable     (jtag_enable    ),    
        .jtag_done       (jtag_done      ),      
        .jtag_length     (jtag_length    ),    
        .jtag_tms_vector (jtag_tms_vector),
        .jtag_tdi_vector (jtag_tdi_vector),
        .jtag_tdo_vector (jtag_tdo_vector),

		.automatic_delay_id1 (automatic_delay_id1),
		.manual_delay_id1    (manual_delay_id1),
		.ge11_correction_cnt (ge11_correction_cnt),
		.gem_data_del     (gem_data_del),
        .ttc_bc0_delay_gem   (ttc_bc0_delay_gem  ),
        .automatic_delay_gem (automatic_delay_gem),
        .en_manual_gem       (en_manual_gem      ),
        .alg_out_range_gem   (alg_out_range_gem  ),
        .bc0_period_err_gem  (bc0_period_err_gem ),
        .hmt_rate            (hmt_rate),
        .hmt_rate_limit  (hmt_rate_limit),
        .hmt_rate_err    (hmt_rate_err) // [station][chamber] hmt rate exceeded hmt_rate_limit
    );

	wire [8*5+9-1:0] bc0_mrg;
	// bc0 signals for link alignment. 
	assign bc0_mrg = {bc0_u_n, bc0_u[4], bc0_u[3], bc0_u[2], bc0_u[1], bc0_u[0]};
	(* mark_debug = "FALSE" *) wire ttc_bc0_w = ttc_bc0_rx;
	wire ttc_resync_w = ttc_resync_rx;
	wire [3:0] tts_data;
	wire [48:0] alignment_error;

    reg [3:0] txoutclk_async_div;
    always @(posedge DAQ_0_mmcm_clk)
        txoutclk_async_div = txoutclk_async_div + 1;

    // front panel outputs, [0] is on top of the connector
	//assign fp[0] = txcharisk_0[1];// ttc_bx0_rx
    assign fp[0] = (cppf_rxd[0][0][15:11] != 5'b11111 && cppf_rx_valid[0] == 1'b1) ? 1'b1 : 1'b0; // for RPC latency measurement
	assign fp[1] = |rx_valid_tp; // valid bits from any input link, before any deframing, for latency measurement with scope
//	assign fp[2] = bt_rank_d[0] == 7'h0 && bt_rank_d[2] == 7'h0; // output valid track flag for local trigger
	assign fp[2] = fp_trigger; // output valid track flag for local trigger
	assign fp[3] = ttc_l1a_rx; //txoutclk_async_div[3];//clk40;
	assign resync_tp = ttc_resync_rx;

	(* mark_debug *) wire ttc_l1a_w = ttc_l1a_rx;

    reg [6:0] ttc_rx [3:0];

	always @(posedge clk_160)
	begin
		
		{ttc_mpc_inject_rx, ttc_or_cnt_reset_rx, ttc_ev_cnt_reset_rx, ttc_bc0_rx, ttc_resync_rx, ttc_l1a_rx, ttc_hard_reset_rx} = ttc_rx[1] | ttc_rx[2] | ttc_rx[3];

        ttc_or_cnt_reset_rx |= pcie_or_cnt_reset;
        ttc_ev_cnt_reset_rx |= pcie_ev_cnt_reset;
        ttc_bc0_rx          |= pcie_bc0;
		
        ttc_rx[3] = ttc_rx[2];
        ttc_rx[2] = ttc_rx[1];
        ttc_rx[1] = ttc_rx[0];
        ttc_rx[0] = {ttc_mpc_inject, ttc_or_cnt_reset, ttc_ev_cnt_reset, ttc_bc0, ttc_resync, ttc_l1a, ttc_hard_reset};
	end

    // TTC BC0 delay logic
    reg [8:0] bc0_del_cnt;
    always @(posedge clk40)
    begin
        ttc_bc0_del = 1'b0;
        if (ttc_bc0_rx) bc0_del_cnt = 9'h0;
        if (bc0_del_cnt == ttc_bc0_delay) ttc_bc0_del = 1'b1;
        if (bc0_del_cnt < 9'h1ff) bc0_del_cnt++;
    end

	mtf7_ptlut
	#(
		.BA(AP_BEG + 32'h18000)
	) 
	ptlut
    (
        .s_axi (m_axi),
        .s_axo (s_axi[3]),

		// rldram interface
		.dq (pt_dq),
		.ba (pt_ba),
		.a (pt_a),
		.dk_p_ (pt_dk_p_),
		.dk_n_ (pt_dk_n_),
		.cs (pt_cs),
		.pt_ref (pt_ref),
		.we (pt_we),

		// clock chip inteface
		.leu (pt_leu), 
		.clku (pt_clku),
		.datau (pt_datau),
		.goe (pt_goe), 
		.ld (pt_ld), 
		.sync (pt_sync),
		.en (pt_clk_reset),
		.clk_word (pt_clk_word),

		.clk200 (clk200),
		.clk400	(clk400),
		
		.mrs_command (pt_mrs_command),
		.wr_command (pt_wr_command),
		.rd_command (pt_rd_command),
		.busy (pt_busy),
		
		.io_reset (io_reset),
		
		.in_delay_ce (in_delay_ce),
		.in_delay_inc_dec (in_delay_inc_dec),
		.in_delay_reset (in_delay_reset),
		.in_delay_clk (pcie_clk_buf),

		.delayctrl_locked (delayctrl_locked),
		.in_delay_tap (in_delay_tap),
		.out_delay_tap (out_delay_tap),
		.in_delay_tap_rb (in_delay_tap_rb),
		.out_delay_tap_rb (out_delay_tap_rb),
		.ddr_clk_del (ddr_clk_del),
		.ptlut_config (ptlut_config),
		
		.clk_del (clk_del),
		
        .core_addr (ptlut_addr), // memory addresses formed by core
        .core_val (ptlut_addr_val), // valid flags
        .core_cs (ptlut_cs), // pre-decoded chip selects
        .core_pt (bt_pt), // pt values from memory
        .clk40 (clk40), // core clock 

		.lhc_clk_good (lhc_clk_good)
	);


	wire [63:0] daq_data;
    wire daq_valid;
    wire daq_first;
    wire daq_last;
    wire amc13_ready;
    wire resync_and_empty;
    wire clk_80;

    mtf7_daq daq
    (
        // CSC data
		 .lct_i    (lct_aligned), //(core_input_lct),
		 .bc0_err_period (alignment_error), // send alignment error to DAQ as link error
		 .bc0_err_period_id1 (5'h0),
		 // RPC data from CPPF
         .cppf_rxd (cppf_rxd), // rx data, 3 frames x 64 bit, for 7 links
         .cppf_rx_valid (cppf_rx_valid), // rx data valid flags
         .fiber_enable (fiber_enable),
         .cppf_crc_match (cppf_crc_match),
    
		 .ge11_cl       (ge11_cl), // decoded clusters
         .gem_rx_valid  (ge11_rx_valid ), 
         .gem_crc_match (ge11_crc_match),
         .gem_alg_out_range     (alg_out_range_gem  ),
         .gem_bc0_period_err    (bc0_period_err_gem ),

         // track
         .bt_pt (bt_pt_tx),
         .bt_phi (bt_phi_d),
         .bt_rank (bt_rank_d),
         .bt_vi (bt_vi_d), 
         .bt_hi (bt_hi_d), 
         .bt_ci (bt_ci_d), 
         .bt_si (bt_si_d),
         .ptlut_addr (ptlut_addr_d),
         .nn_pt (nn_pt),
         .nn_pt_v (nn_pt_v),
         .nn_d0    (nn_d0),

         .gmt_phi (gmt_phi_d),
         .gmt_eta (gmt_eta_d),
         .gmt_qlt (gmt_qlt_d),
         .gmt_crg (gmt_crg_d),
         .hmt     (hmt_out),    
         .clk (clk40),
    
         .daq_config (daq_config),
         
         .l1a_in (ttc_l1a_rx),
         .ttc_resync (ttc_resync_rx),
         .ttc_bc0 (ttc_bc0_rx),
         .ttc_ev_cnt_reset (ttc_ev_cnt_reset_rx),
         .ttc_or_cnt_reset (ttc_or_cnt_reset_rx),
         
         .daq_data (daq_data), 
         .daq_valid (daq_valid),
         .daq_first (daq_first),
         .daq_last (daq_last),
         .clk_80 (clk_80),
         .amc13_ready (amc13_ready),
         .amc13_to_counter (amc13_to_counter),
         .tts_data (tts_data), 
         
         .sp_addr (5'd1), // slot is unknown so far, needs to arrive from MMC
         .sp_ts ({endcap, sector}),
         .reset (daq_reset),
         .daq_state_cnt(daq_state_cnt),
         .resync_and_empty (resync_and_empty),
         .fw_date (fw_date),
         .af_delays (af_delays),
         .orbit_count (daq_orbit_count),
         .bxn_counter (daq_bxn_counter),
         .l1a_count   (daq_l1a_count),
         .force_oos (force_oos)
         
     );
    
     amc13_link_tx amc13_link_tx_
     (
         
         .mgttx         (daq_tx),
         .DAQ_0_mmcm_clk (DAQ_0_mmcm_clk),

         // inputs from receiver in control FPGA
         .k_rxresetdone (k_rxresetdone),
         .k_rxnotintable (k_rxnotintable),
         .k_rxchariscomma (k_rxchariscomma),
         .k_rxcharisk (k_rxcharisk),
         .k_rxdata (k_rxdata),
         .k_rx_clk (k_rx_clk),
         
         // TTS interface (aka FMM)
         .tts_clk (clk_80),
//         .tts_clk (clk40), 
         .tts_data (tts_data), 
         .resync_and_empty (resync_and_empty),
     
         // DAQ data interface
         .ev_data_clk (clk_80), // in  ;
//         .ev_data_clk (clk40), // in  ;
         .ev_data_valid (daq_valid), // in  ; // used as data write enable
         .ev_data_header (daq_first), // in  ; // first data word
         .ev_data_trailer (daq_last), // in  ; // last data word
         .ev_data (daq_data), // in   (63 : 0);
         .daq_ready (amc13_ready),
         .amc13_status_cnt (amc13_status_cnt),
         
         .gt0_txresetdone_i (amc13_txresetdone),
         .reset (!m_aresetn),
         .cnt_reset (daq_reset)
         
     );

    dbg dbg_i
    (
        .pcie_clk        (pcie_clk_buf   ),
        .reset           ((!m_aresetn) | soft_reset),
        .jtag_enable     (jtag_enable    ),    
        .jtag_done       (jtag_done      ),      
        .jtag_length     (jtag_length    ),    
        .jtag_tms_vector (jtag_tms_vector),
        .jtag_tdi_vector (jtag_tdi_vector),
        .jtag_tdo_vector (jtag_tdo_vector)
    );

    dbg_probes_switch dbg_ps
    (
        // [station][chamber][segment] station 5 = neighbor sector, all stations
        .lct_i (lct_aligned),
		.ge11_cl    (ge11_cl), // decoded clusters
		.ge11_rxd   (ge11_rxd),
        .clk40 (clk40)
    );


    wire ttc_mpc_inject_rx_w   = ttc_mpc_inject_rx  ; 
    wire ttc_or_cnt_reset_rx_w = ttc_or_cnt_reset_rx; 
    wire ttc_ev_cnt_reset_rx_w = ttc_ev_cnt_reset_rx; 
    (* mark_debug *) wire ttc_bc0_rx_w          = ttc_bc0_rx         ; 
    wire ttc_resync_rx_w       = ttc_resync_rx      ; 
    wire ttc_l1a_rx_w          = ttc_l1a_rx         ;

    (* mark_debug = "FALSE" *) wire [bwr:0]      bt_rank_dw [2:0];
    assign bt_rank_dw[0] = bt_rank_d[0];
    assign bt_rank_dw[1] = bt_rank_d[1];
    assign bt_rank_dw[2] = bt_rank_d[2];

	(* mark_debug = "FALSE" *) wire [29:0] ptlut_addr_dw [2:0]; // delayed ptlut memory addresses formed by core
	assign ptlut_addr_dw[0] = ptlut_addr_d[0];
	assign ptlut_addr_dw[1] = ptlut_addr_d[1];
	assign ptlut_addr_dw[2] = ptlut_addr_d[2];

    (* mark_debug = "FALSE" *) wire [8:0] bt_pt_w [2:0]; // pt values for best tracks
    assign bt_pt_w[0] = bt_pt[0];
    assign bt_pt_w[1] = bt_pt[1];
    assign bt_pt_w[2] = bt_pt[2];

endmodule
