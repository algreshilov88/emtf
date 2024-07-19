///////////////////////////////////////////////////////////////////////////////
// Company: UF
// Engineer: Madorsky
//
// Create Date:   10:40:22 03/20/2010
// Design Name:   prim_conv_sector
// Module Name:   C:/Users/madorsky/projects/ise/tf_slhc/sp_tf.v
// Project Name:  tf_slhc
// Target Device:  V6
// Tool versions:  11.4
// Description: test fixture for entire sp design
//
// Dependencies: all sp files
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// !!!!DO NOT USE VIVADO SIMULATOR!!!! 
// THIS CODE SIMULATES OK WITH QUESTASIM OR MODELSIM
////////////////////////////////////////////////////////////////////////////////
`include "vppc_macros.sv"
`include "interfaces.sv"
`include "spbits.sv"
`ifdef SIMULATION_DAQ
    `include "mpcx_interface.sv"
`endif

module sp_tf;

    `param max_ev = 220000; //13000;

    `param endcap_p = 2;
    `param sector_p = 2;
    `param rpc_delay = 6; // delay of rpc data relative to csc
    `param ge11_delay = 3; // delay of ge11 data relative to csc
   
    csc_lct_mpcx lct_ii[5:0][8:0][seg_ch-1:0];
    // GEM interfaces [schamber][layer][cluster]
    ge11_cluster ge11_cl [6:0][1:0][7:0]();
   
   
    // io
    reg [seg_ch-1:0] vpf   [5:0][8:0];
    reg [3:0]        qi    [5:0][8:0][seg_ch-1:0];
    reg [bw_wg-1:0]  wgi   [5:0][8:0][seg_ch-1:0];
    reg [bw_hs-1:0]  hstri [5:0][8:0][seg_ch-1:0];
    reg [3:0] 		 cpati [5:0][8:0][seg_ch-1:0];
    reg [3:0] 		 hmti  [5:0][8:0][seg_ch-1:0];
    reg [3:0] 		 qsesi [5:0][8:0][seg_ch-1:0];
    reg [seg_ch-1:0] lri   [5:0][8:0];

    reg [7:0] ge11_str_i [6:0][1:0][7:0];
    reg [2:0] ge11_prt_i [6:0][1:0][7:0];
    reg [2:0] ge11_csz_i [6:0][1:0][7:0];
    reg [7:0] ge11_vf_i  [6:0][1:0];
   

   genvar 			 gi, gj, gk;
   generate
	  for (gi = 0; gi < 6; gi++) // station loop
		begin
		   for (gj = 0; gj < 9; gj++) // chamber loop
			 begin
				for (gk = 0; gk < 2; gk++) // LCT loop
				  begin
					 assign lct_ii[gi][gj][gk].vf = vpf[gi][gj][gk];
					 assign lct_ii[gi][gj][gk].ql = {qsesi[gi][gj][gk][1], qi[gi][gj][gk][2:0]}; // {1/4 strip=QS, q[2:0]}
					 assign lct_ii[gi][gj][gk].wg = wgi[gi][gj][gk];
					 assign lct_ii[gi][gj][gk].hs = hstri[gi][gj][gk];
//					 assign lct_ii[gi][gj][gk].cp = cpati[gi][gj][gk];
					 // zero out new parameters for now, TBD: need to take these from input file
					 assign lct_ii[gi][gj][gk].lr  = lri[gi][gj][gk];   // left-right flag
					 assign lct_ii[gi][gj][gk].ser = qsesi[gi][gj][gk][0];  // 1/8 strip = ES bit
					 assign lct_ii[gi][gj][gk].cid = cpati[gi][gj][gk];  // CSC ID carries CLCT pattern now
					 assign lct_ii[gi][gj][gk].bc0 = 0;  
					 if (gk == 1)
					 begin
					   // HMT bits are only in LCT1
					   assign lct_ii[gi][gj][gk].cp = {2'b00, hmti[gi][gj][gk][1], 1'b0}; // repurposed hmt[1] bit 
					   assign lct_ii[gi][gj][gk].bx0 = hmti[gi][gj][gk][0]; // repurposed hmt[0] bit
					 end
					 else
					 begin
					   assign lct_ii[gi][gj][gk].cp = 0; 
					   assign lct_ii[gi][gj][gk].bx0 = 0;
					 end
				  end
			 end
		end

	  for (gi = 0; gi < 7; gi++)
		begin
		   for (gj = 0; gj < 2; gj++)
			 begin
				for (gk = 0; gk < 8; gk++)
				  begin
					 assign ge11_cl[gi][gj][gk].str = ge11_str_i [gi][gj][gk];
					 assign ge11_cl[gi][gj][gk].prt = ge11_prt_i [gi][gj][gk];
					 assign ge11_cl[gi][gj][gk].csz = ge11_csz_i [gi][gj][gk];
					 assign ge11_cl[gi][gj][gk].vf  = ge11_vf_i [gi][gj][gk];
				  end
			 end
		end

   endgenerate

   
    // precise parameters
    /*
	 * wire [bw_phi-1:0] phi [2:0];
    wire [bw_eta-1:0] eta [2:0];
    wire [12:0] 	  pt [2:0];
    wire [2:0] 		  sign;
    wire [3:0] 		  modeMem [2:0];
    wire [4:0] 		  etaPT [2:0];
    wire [2:0] 		  FR;
	 */

	reg [1:0]         ge11_cs; // chip select for GE11 prim conv
    reg [8:0] 		  csi [5:0];
    reg [1:0] 		  seli;
    reg [bw_addr-1:0] addri;

    reg [63:0] 		  r_ini; // reg data for memory or register
    wire [63:0] 	  r_outo; // output data from memory or register
    reg 			  wei; // write enable for memory or register
	
// ph quality codes output [zone][key_strip]
    wire [5:0] 		ph_ranko [3:0][ph_raw_w-1:0];
    // [station][chamber][segment]
    wire [bw_fph-1:0] 	ph   [4:0][8:0][seg_ch-1:0];
    wire [bw_th-1:0] 	th11 [1:0][2:0][th_ch11-1:0];
    wire [bw_th-1:0] 	th   [4:0][8:0][seg_ch-1:0];
    wire [seg_ch-1:0] vl   [4:0][8:0];
    wire [2:0] 		phzvl[4:0][8:0];
	wire [seg_ch-1:0] me11a [1:0][2:0];
	wire [ph_raw_w-1:0] ph_zone [3:0][4:1];

	wire [seg_ch-1:0] 	patt_vi [3:0][2:0][3:0]; // valid
	wire [1:0] 			patt_hi [3:0][2:0][3:0]; // bx index
	wire [2:0] 			patt_ci [3:0][2:0][3:0]; // chamber
	wire [3:0] 			patt_si [3:0][2:0]; // segment

	
    reg 			  clki; // write clock

    // ph_init storage is full-precision now
	// chamber index is 0..11 to include ME11a and b
    reg [bw_fph:0] 	  ph_init0 [15:0]; 
    reg [bw_fph:0] 	  ph_init1 [15:0]; 
    reg [bw_fph:0] 	  ph_init2 [15:0]; 
    reg [bw_fph:0] 	  ph_init3 [15:0];
    reg [bw_fph:0] 	  ph_init4 [15:0]; 
    wire [bw_fph:0] 	  ph_init [4:0][15:0]; // [station][chamber]
    
	// arrays below contains values for each chamber
	// chamber count is ME1=12*2+4(n) ME2,3,4=9*3+3*2(n), total 61 including neighbor sector
    reg [bw_th-1:0]   th_init [60:0]; // chamber origins in th
    reg [bw_ph:0] 	  ph_disp [60:0]; // chamber displacements in ph
    reg [bw_th-1:0]   th_disp [60:0]; // chamber displacements in th
    
    // event storage
    reg [seg_ch-1:0]  valid     [max_ev-1:0][5:0][8:0];
    reg [3:0] 		  quality   [max_ev-1:0][5:0][8:0][seg_ch-1:0];
    reg [6:0] 		  wiregroup [max_ev-1:0][5:0][8:0][seg_ch-1:0];
    reg [bw_hs-1:0]   hstrip    [max_ev-1:0][5:0][8:0][seg_ch-1:0];
    reg [3:0] 		  clctpat   [max_ev-1:0][5:0][8:0][seg_ch-1:0];
    reg [1:0] 		  hmt       [max_ev-1:0][5:0][8:0][seg_ch-1:0];
    reg [1:0] 		  qses      [max_ev-1:0][5:0][8:0][seg_ch-1:0];
    reg [seg_ch-1:0]  lr        [max_ev-1:0][5:0][8:0];
    
    // [subsector][chamber][hit]
    reg [10:0] rpc_ph [max_ev+rpc_delay-1:0][6:0][5:0][seg_ch-1:0];
    reg [4:0]  rpc_th [max_ev+rpc_delay-1:0][6:0][5:0][seg_ch-1:0];

    // [scham=link][layer][cluster]
    reg [7:0] ge11_str [max_ev+ge11_delay-1:0][6:0][1:0][7:0];
    reg [2:0] ge11_prt [max_ev+ge11_delay-1:0][6:0][1:0][7:0];
    reg [2:0] ge11_csz [max_ev+ge11_delay-1:0][6:0][1:0][7:0];

    integer 	      iadr = 0, s = 0, i = 0, pi, j = 0, sn, c;
    reg [15:0] 		  v0, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13;
    reg [2:0] 		  pr_cnt      [6:0][8:0];
    reg [2:0] 		  pr_cnt_rpc  [6:0][8:0];
    reg [2:0] 		  pr_cnt_ge11 [6:0][8:0]; // second index wider than needed, but OK
    integer 		  _event;
	reg [9:0] 		  _bx_jitter; 		  
    reg [1:0] 		  _endcap;
    reg [2:0] 		  _sector;
    reg [1:0] 		  _subsector;
    reg [2:0] 		  _station, old_station;
    reg [3:0] 		  _cscid;
    reg [3:0] 		  _bend;
    reg [10:0] 		  _halfstrip;
    reg [1:0]		  _valid;
    reg [3:0] 		  _quality;
    reg [3:0] 		  _pattern;
    reg [6:0] 		  _wiregroup;
    reg [1:0]         _hmt;
    reg [1:0]         _qses;
    reg               _lr;
    integer 	      ist, icid, ipr, code, iev, im, iz, ir;
    reg [800-1:0] 	  line;
    integer 	      in, best_tracks, vllut_in, sim_out, best_tracks_short, nn_out;
    integer 	      stat;
    reg [31:0] 		  ev = 0;
    reg [4:0] 		  good_ev = 0;
    integer 	      good_ev_cnt = 0;
    integer 	      found_tr = 0;
    integer 	      found_cand = 0;	      
    integer 	      st;
    integer 	      st_cnt; // station count
	integer 		  iseg;
	integer 		  zi, si, ip, is;

    time 			  begin_time, end_time, elapsed_time;
    reg [11:0] 		  tphi, a, b, d;
	reg 			  pts;
	// numbers of best ranks [zone][num]
	wire [bpow:0] ph_num [3:0][2:0]; 
	// best ranks [zone][num]
	wire [bwr-1:0] ph_q [3:0][2:0]; 
	wire [bw_fph-1:0]	ph_match [3:0][2:0][3:0]; // matching ph
	wire [bw_th-1:0]	th_match   [3:0][2:0][3:0][seg_ch-1:0]; // matching th, 2 segments 
	wire [bw_th-1:0]	th_match11 [1:0][2:0][th_ch11-1:0]; // matching th for ME11 (station 0 only), 4 segments (due to th duplication)
	// precise phi and theta of best tracks
	// [best_track_num]
	wire [bw_fph-1:0] 	bt_phi [2:0];
	wire [bw_th-1:0] 	bt_theta [2:0];
	wire [3:0] 			bt_cpattern [2:0][3:0];
	// ph and th deltas from best stations
	// [best_track_num], last index: [0] - best pair of stations, [1] - second best pair
	wire [bw_fph-1:0] 	bt_delta_ph [2:0][5:0];
	wire [bw_th-1:0] 	bt_delta_th [2:0][5:0]; 
	wire [5:0] 			bt_sign_ph[2:0];
	wire [5:0] 			bt_sign_th[2:0];
	// ranks [best_track_num]
	wire [bwr:0] 		bt_rank [2:0];
	// segment IDs
	// [best_track_num][station 0-3]
	wire [seg_ch-1:0] 	bt_vi [2:0][4:0]; // valid
	wire [1:0] 			bt_hi [2:0][4:0]; // bx index
	wire [3:0] 			bt_ci [2:0][4:0]; // chamber
	wire [4:0] 			bt_si [2:0]; // segment
    reg lat_test; // latency test mode
    
    wire [7:0] gmt_phi [2:0]; // phi for gmt
    wire [8:0] gmt_eta [2:0]; // eta for gmt
    wire        en_single = 1'b0;
   
   reg [31:0] 	ptlut [536870912-1:0]; // 1/2G x 32 bits, each word carries two 9-bit values
   integer 		ptfile;
   reg [31:0] 	pt_word;
   reg [31:0] 	pt_word_rev;
   reg [8:0] 	pt_value;
`define brev(a) {a[7:0], a[15:8], a[23:16], a[31:24]}

   wire [3:0] gmt_qlt [2:0]; // quality for gmt
   wire [2:0] gmt_crg;
   wire [29:0] ptlut_addr [2:0]; // ptlut addresses for best 3 muons
   wire [31:0] ptlut_cs [2:0]; // pre-decoded chip selects
   wire [2:0]  ptlut_addr_val; // ptlut address valid flags
   reg [63:0] cppf_rxd [6:0][2:0]; // cppf rx data, 3 frames x 64 bit, for 7 links
   wire [6:0] cppf_rx_valid = 7'h7f; // cprx data valid flags, always valid

	wire [7:0] nn_pt [2:0]; // NN PT value
	wire [2:0] nn_pt_v; // NN valid flag for PT
	wire [2:0] nn_d0 [2:0]; // NN PT value
	wire [2:0] nn_d0_v; // NN valid flag for PT
   

    // IMPORTANT: modify 5 parameters below to match endcap/sector and file path
   reg       endcap = 1'b1; // 0=ME+ 1=ME-
   reg [2:0] sector = 3'd5; // sector #-1
   reg [20*8-1:0] fes_str, fest_str;
   wire [1:0] hmt_out; // {out_of_time, in_time}
`define fes fes_str
`define fest fest_str
   
//`define dpath "/exports/uftrig01b/madorsky/projects/modelsim/emtf_data/"
//`define dpath "/home/madorsky/github/emtf/emtf_v7/core/emtf_data/" 
`define dpath "C:/github/emtf/emtf_v7/core/emtf_data/" 
//"/home/madorsky/cernbox/projects/modelsim/emtf_data/"

   wire [63:0] 	  core_config;
	assign core_config[bw_th-1:0] = 8;// wire [bw_th-1:0] th_window
    assign core_config[11:8]      = 9;// wire [3:0] delay_two_mu
    assign core_config[12]        = 0;// wire en_single
    assign core_config[13]        = 0;// wire en_two_mu
    assign core_config[14]        = 0;// wire low_th_promote
    assign core_config[15]        = 1;// wire use_rpc
	assign core_config[22:16]     = 4;// wire [bw_th-1:0] th_window_z0
    assign core_config[23]        = 1;// wire two_st_tight_timing
    assign core_config[30:27]     = 5; // HMT delay
	
	integer 	   ibx,ich,isg, ii, kp;
    // Instantiate the Unit Under Test (UUT)
    sp uut 
		(
		 .lct_i (lct_ii),
		 .ge11_cl (ge11_cl),
		 .cppf_rxd (cppf_rxd),
		 .cppf_rx_valid (cppf_rx_valid),
		 .pcs_cs   (csi), 
		 .ge11_cs  (ge11_cs),
		 .sel      (seli), 
		 .addr     (addri), 
		 .r_in     (r_ini), 
		 .r_out    (r_outo), 
		 .we       (wei),

		 .bt_phi (bt_phi),
		 .bt_theta (bt_theta),
		 .bt_cpattern (bt_cpattern),
		 .bt_delta_ph (bt_delta_ph),
		 .bt_delta_th (bt_delta_th),
		 .bt_sign_ph (bt_sign_ph),
		 .bt_sign_th (bt_sign_th),
		 .bt_rank (bt_rank),
		 .bt_vi (bt_vi), 
		 .bt_hi (bt_hi), 
		 .bt_ci (bt_ci), 
		 .bt_si (bt_si),

		 .ptlut_addr (ptlut_addr),
		 .ptlut_cs (ptlut_cs),
		 .ptlut_addr_val (ptlut_addr_val),
		 
		 .gmt_phi (gmt_phi),
		 .gmt_eta (gmt_eta),
		 .gmt_qlt (gmt_qlt),
		 .gmt_crg (gmt_crg),
         .hmt_out (hmt_out),

	     .nn_pt   (nn_pt  ), // NN PT value
	     .nn_pt_v (nn_pt_v), // NN valid flag for PT
	     .nn_d0   (nn_d0  ), // NN D0 value
	     .nn_d0_v (nn_d0_v), // NN valid flag for D0

		 .clk      (clki),
		 .control_clk(clki), // use main clock for control as well
		 .endcap (endcap),
		 .sector (sector),
		 .lat_test (lat_test),
		 .core_config (core_config) // en_2mu, en_single, delay_2mu, th_window 
//		 .core_config ({1'b0, 1'b0, 4'h9, 8'h8}) // en_2mu, en_single, delay_2mu, th_window 
		 );


    // temporary LUTs for th_mem, data need to be reformatted for actual storage in firmware LUTs
    reg [7:0] ge11_th_tmp [111:0]; // 112 words by 8 bit = 14 words by 64 bits
    reg [63:0] ge11_th_u64;
    integer wi, wj;
   
   `int 	   ph_high_prec, ph_low_prec, ph_zone_phi;
    `int k;
    `int gz, gn, gs, f, stb;
   integer 			   first_stub, station_cnt;
   integer tmb_revert[5:0][8:0];// [station][chamber]

    reg [3:0] nn_mode_r [2:0];
    reg [2:0] nn_valid_in;
    reg [1:0] mux_phase_print [2:0] = '{2'h2, 2'h0, 2'h1};
    reg [17:0] nn_input [2:0][22:0] = '{
        '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
    };

    initial 
		begin
			//sim_out = $fopen("sp_tf.out","w");
			sim_out = $fopen({`dpath,"/sp_tf_2nd.out"}, "w");//
			//sim_out = $fopen("/home/hvuser/mrcarver/ConvTest/S1R1_closer.out", "w");//


		   endcap = endcap_p - 1;
		   sector = sector_p - 1;
		   $sformat (fes_str , "_endcap_%0d_sec_%0d_", endcap_p, sector_p);
		   $sformat (fest_str, "_endcap_%0d_sect_%0d", endcap_p, sector_p);
		   
		   $fwrite (sim_out, "endcap: %d sector: %d strings: %s %s\n", endcap, sector, `fes, `fest);
		   
            // write parameters to primitive converters
	`include "fill_params.sv"
	`include "fill_params_ge11.sv"
//   	tmb_revert[0][0] = uut.pcs.station11[0].csc11[0].pc11.tmb_revert;
//	tmb_revert[0][1] = uut.pcs.station11[0].csc11[1].pc11.tmb_revert;
//	tmb_revert[0][2] = uut.pcs.station11[0].csc11[2].pc11.tmb_revert;
//	tmb_revert[1][0] = uut.pcs.station11[1].csc11[0].pc11.tmb_revert;
//	tmb_revert[1][1] = uut.pcs.station11[1].csc11[1].pc11.tmb_revert;
//	tmb_revert[1][2] = uut.pcs.station11[1].csc11[2].pc11.tmb_revert;
		        		                  
	tmb_revert[0][3] = uut.pcs.station12[0].csc12[3].pc12.tmb_revert;
	tmb_revert[0][4] = uut.pcs.station12[0].csc12[4].pc12.tmb_revert;
	tmb_revert[0][5] = uut.pcs.station12[0].csc12[5].pc12.tmb_revert;
	tmb_revert[0][6] = uut.pcs.station12[0].csc12[6].pc12.tmb_revert;
	tmb_revert[0][7] = uut.pcs.station12[0].csc12[7].pc12.tmb_revert;
	tmb_revert[0][8] = uut.pcs.station12[0].csc12[8].pc12.tmb_revert;
	tmb_revert[1][3] = uut.pcs.station12[1].csc12[3].pc12.tmb_revert;
	tmb_revert[1][4] = uut.pcs.station12[1].csc12[4].pc12.tmb_revert;
	tmb_revert[1][5] = uut.pcs.station12[1].csc12[5].pc12.tmb_revert;
	tmb_revert[1][6] = uut.pcs.station12[1].csc12[6].pc12.tmb_revert;
	tmb_revert[1][7] = uut.pcs.station12[1].csc12[7].pc12.tmb_revert;
	tmb_revert[1][8] = uut.pcs.station12[1].csc12[8].pc12.tmb_revert;

	tmb_revert[2][0] = uut.pcs.station234[2].csc[0].pc.tmb_revert;
	tmb_revert[2][1] = uut.pcs.station234[2].csc[1].pc.tmb_revert;
	tmb_revert[2][2] = uut.pcs.station234[2].csc[2].pc.tmb_revert;
	tmb_revert[2][3] = uut.pcs.station234[2].csc[3].pc.tmb_revert;
	tmb_revert[2][4] = uut.pcs.station234[2].csc[4].pc.tmb_revert;
	tmb_revert[2][5] = uut.pcs.station234[2].csc[5].pc.tmb_revert;
	tmb_revert[2][6] = uut.pcs.station234[2].csc[6].pc.tmb_revert;
	tmb_revert[2][7] = uut.pcs.station234[2].csc[7].pc.tmb_revert;
	tmb_revert[2][8] = uut.pcs.station234[2].csc[8].pc.tmb_revert;
	tmb_revert[3][0] = uut.pcs.station234[3].csc[0].pc.tmb_revert;
	tmb_revert[3][1] = uut.pcs.station234[3].csc[1].pc.tmb_revert;
	tmb_revert[3][2] = uut.pcs.station234[3].csc[2].pc.tmb_revert;
	tmb_revert[3][3] = uut.pcs.station234[3].csc[3].pc.tmb_revert;
	tmb_revert[3][4] = uut.pcs.station234[3].csc[4].pc.tmb_revert;
	tmb_revert[3][5] = uut.pcs.station234[3].csc[5].pc.tmb_revert;
	tmb_revert[3][6] = uut.pcs.station234[3].csc[6].pc.tmb_revert;
	tmb_revert[3][7] = uut.pcs.station234[3].csc[7].pc.tmb_revert;
	tmb_revert[3][8] = uut.pcs.station234[3].csc[8].pc.tmb_revert;
	tmb_revert[4][0] = uut.pcs.station234[4].csc[0].pc.tmb_revert;
	tmb_revert[4][1] = uut.pcs.station234[4].csc[1].pc.tmb_revert;
	tmb_revert[4][2] = uut.pcs.station234[4].csc[2].pc.tmb_revert;
	tmb_revert[4][3] = uut.pcs.station234[4].csc[3].pc.tmb_revert;
	tmb_revert[4][4] = uut.pcs.station234[4].csc[4].pc.tmb_revert;
	tmb_revert[4][5] = uut.pcs.station234[4].csc[5].pc.tmb_revert;
	tmb_revert[4][6] = uut.pcs.station234[4].csc[6].pc.tmb_revert;
	tmb_revert[4][7] = uut.pcs.station234[4].csc[7].pc.tmb_revert;
	tmb_revert[4][8] = uut.pcs.station234[4].csc[8].pc.tmb_revert;
	tmb_revert[4][0] = uut.pcs.station234[4].csc[0].pc.tmb_revert;

    
//    tmb_revert[5][0] = uut.pcs.pcn11.tmb_revert;
    tmb_revert[5][1] = uut.pcs.cscn[1].pcn.tmb_revert;
    tmb_revert[5][2] = uut.pcs.cscn[2].pcn.tmb_revert;
    tmb_revert[5][3] = uut.pcs.cscn[3].pcn.tmb_revert;
    tmb_revert[5][4] = uut.pcs.cscn[4].pcn.tmb_revert;
    tmb_revert[5][5] = uut.pcs.cscn[5].pcn.tmb_revert;
    tmb_revert[5][6] = uut.pcs.cscn[6].pcn.tmb_revert;
    tmb_revert[5][7] = uut.pcs.cscn[7].pcn.tmb_revert;
    tmb_revert[5][8] = uut.pcs.cscn[8].pcn.tmb_revert;

		   // read PT LUT
		   ptfile = $fopen ({`dpath, "/ptlut.dat"}, "rb");
		   //$fread (ptlut, ptfile);
		   $fclose (ptfile);
			
			// initialize event storage
			for (iev = 0; iev < max_ev; iev=iev+1)
			begin
				for (ist = 0; ist < 6; ist=ist+1) 
					for (icid = 0; icid < 9; icid=icid+1)
						for (ipr = 0; ipr < seg_ch; ipr=ipr+1)
						begin
							valid    [iev][ist][icid][ipr] = 1'b0;
							quality  [iev][ist][icid][ipr] = 4'b0;
							wiregroup[iev][ist][icid][ipr] = 7'b0;
							hstrip   [iev][ist][icid][ipr] = 8'b0;
							qses     [iev][ist][icid][ipr] = 2'b0;
							lr       [iev][ist][icid][ipr] = 1'b0;
							clctpat  [iev][ist][icid][ipr] = 4'b0;
							hmt      [iev][ist][icid][ipr] = 2'b0;
						end

				for (ist = 0; ist < 7; ist=ist+1) // rpc subsector
					for (icid = 0; icid < 6; icid=icid+1) // rpc chamber
						for (ipr = 0; ipr < seg_ch; ipr=ipr+1) // hit
						begin
							rpc_ph [iev+rpc_delay][ist][icid][ipr] = 11'h7ff;
							rpc_th [iev+rpc_delay][ist][icid][ipr] = 5'h1f;
						end
			   
				for (ist = 0; ist < 7; ist=ist+1) // ge11 schamber
					for (icid = 0; icid < 2; icid=icid+1) // ge11 layer
						for (ipr = 0; ipr < 8; ipr=ipr+1) // ge11 cluster
						begin
							ge11_str [iev+ge11_delay][ist][icid][ipr] = 8'hff;
							ge11_prt [iev+ge11_delay][ist][icid][ipr] = 3'h7;
							ge11_csz [iev+ge11_delay][ist][icid][ipr] = 3'h7;
						end
			end
			// read events
//			in = $fopen({`dpath, "/NikhilInputs.txt"}, "r");
			in = $fopen({`dpath, "/data.dat"}, "r");
			//in = $fopen("Event609207399.txt","r");
			//in = $fopen("/home/hvuser/mrcarver/ConvTest/St1R1_2_fix.txt", "r");
			
			if (in == 0) 
			begin
			     $fwrite(sim_out, "cannot open input file\n");
			     $finish;
			end
			_event = 0;
			//			$fwrite(sim_out, "in: %h _event: %h\n", in, _event);
			while (!$feof(in) && _event < max_ev)
			begin
				// read line
				code = $fgets(line, in);
				//                $fwrite (sim_out, "%h\n", line);
				// read values
				v0 = 0; v1 = 0; v2 = 0; v3 = 0; v4 = 0; v5 = 0; v6 = 0; v7 = 0; v8 = 0; v9 = 0; v10 = 0; v11 = 0; v12 = 0; v13 = 0;
				sn = $sscanf(line, "%d %d %d %d %d %d %d %d %d %d %d %d %d %d", 
							 v0, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13);
//				$fwrite(sim_out, "code %d read %d items %d %d %d %d %d %d %d %d %d %d %d %d %d\n", code, sn,
//					    v0, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12);
				case (sn)
					1: 
						begin	// end of event
							// clean primitive counters
							for (i = 0; i < 7; i=i+1) 
							     for (j = 0; j < 9; j=j+1)
							     begin
								    pr_cnt[i][j] = 0;
								    pr_cnt_rpc[i][j] = 0;
								    pr_cnt_ge11[i][j] = 0;
							     end
							j = 0;
							_event = _event + 1;
							first_stub = 1;
							station_cnt = 0;
							//$fwrite(sim_out, "End of event %d\n", _event);
						end
					12, 14: 
						begin	// primitive
						    //$fwrite (sim_out, "entering primitive *****************************************\n");
							_hmt = v0;	
							_endcap = v1;
							_sector = v2;
							_subsector = v3;
							_station = v4;
							if (_station == 1 && _subsector == 1) _station = 0;
							_valid = v5;	
							_quality = v6;
							_pattern = v7;
							_wiregroup = v8;
							_cscid = v9;	
							_bend = v10;
							_halfstrip = v11;
							if (sn == 14) _qses = v12; // updated format with qs, es, lr bits
							else _qses = 0;
							if (sn == 14) _lr = v13; // updated format with qs, es, lr bits
							else _lr = 0;

							// code that adds jitter, for BXA checks
							if (first_stub == 1) old_station = _station;
							first_stub = 0;
							
							if (old_station != _station)
								station_cnt = station_cnt+1;

							_bx_jitter = 2;
							if (station_cnt <= 1)
							begin
								//								_bx_jitter = 0;
							end

							// increase stub counter only when station changes
							old_station = _station;
							// end of BX jitter code

							//$fwrite(sim_out, "primitive: subsec: %d  stat: %d  val: %d  hs: %h  wg: %h  q: %h\n",
							//		_subsector, _station, _valid, _halfstrip, _wiregroup, _quality);
							
							// copy data to the corresponding input

							if (_endcap == endcap_p && _sector == sector_p)
							begin
								if (_valid == 1) // csc
								begin
									_cscid = _cscid-1; // CSC IDs start from 1 in the input files
									if (_station > 5) $fwrite(sim_out, "bad station: %d, event: %d\n", _station, _event);
									else 
										if (_cscid > 8) $fwrite(sim_out, "bad cscid: %d, station: %d, event: %d\n", _cscid, _station, _event);
										else
//											if (_cscid == 0) $fwrite(sim_out, "removing cscid=1: %d, station: %d, event: %d\n", _cscid, _station, _event);
//											else 
												if (pr_cnt[_station][_cscid] >= seg_ch)
												begin
													$fwrite(sim_out, "bad segment index. event: %d, index: %d, station: %d, cscid: %d\n",
															_event, pr_cnt[_station][_cscid], _station, _cscid);
												end
												else
												begin
													valid    [_event + _bx_jitter][_station][_cscid][pr_cnt[_station][_cscid]] = _valid;
													quality  [_event + _bx_jitter][_station][_cscid][pr_cnt[_station][_cscid]] = _quality;
													wiregroup[_event + _bx_jitter][_station][_cscid][pr_cnt[_station][_cscid]] = _wiregroup;
													hstrip   [_event + _bx_jitter][_station][_cscid][pr_cnt[_station][_cscid]] = _halfstrip;
													qses     [_event + _bx_jitter][_station][_cscid][pr_cnt[_station][_cscid]] = _qses;
													lr       [_event + _bx_jitter][_station][_cscid][pr_cnt[_station][_cscid]] = _lr;
													clctpat  [_event + _bx_jitter][_station][_cscid][pr_cnt[_station][_cscid]] = _pattern;
													hmt      [_event + _bx_jitter][_station][_cscid][1] = _hmt; // HMT always and only in LCT1, see CMS note DN-20-016
													// increase primitive counter
													pr_cnt[_station][_cscid] = pr_cnt[_station][_cscid] + 1;
												end // else: !if(pr_cnt[_station][_cscid] >= seg_ch)
								end // if (_valid == 1)
								else if (_valid == 2) // rpc
								begin
									if (pr_cnt_rpc[_station][_cscid] >= seg_ch)
									begin
//										$fwrite(sim_out, "bad RPC segment index. event: %d, index: %d, station: %d, cscid: %d\n",
//												_event, pr_cnt_rpc[_station][_cscid], _station, _cscid);
									end
									else
									begin
//										$fwrite (sim_out, "rpc hit: st: %d ch: %d phi: %d th: %d\n", _station, _cscid, _halfstrip, _wiregroup);
										rpc_ph [_event + _bx_jitter + rpc_delay][_station][_cscid][pr_cnt_rpc[_station][_cscid]] = _halfstrip; // actually carries phi
										rpc_th [_event + _bx_jitter + rpc_delay][_station][_cscid][pr_cnt_rpc[_station][_cscid]] = _wiregroup; // actually carries theta
										// increase primitive counter
										pr_cnt_rpc[_station][_cscid] = pr_cnt_rpc[_station][_cscid] + 1;
									end // else: !if(pr_cnt_rpc[_station][_cscid] >= seg_ch)
								end // if (_valid == 2)
								else if (_valid == 3) // GE11
								begin
									if (pr_cnt_ge11[_station][_cscid] >= 2) // can only use two clusters per chamber
									begin
										$fwrite(sim_out, "bad GE11 segment index. event: %4d, index: %1d, schamber: %1d, layer: %1d\n",
												_event, pr_cnt_rpc[_station][_cscid], _station, _cscid);
									end
									else
									begin
//										$fwrite (sim_out, "GE11 hit: sch: %d ly: %d str: %d prt: %d csz: %d\n", _station, _cscid, _halfstrip, _wiregroup, _pattern);
//                                                                                 [schamber][ layer][         cluster               ]
										ge11_str [_event + _bx_jitter + ge11_delay][_station][_cscid][pr_cnt_ge11[_station][_cscid]*4] = _halfstrip; // actually carries strip
										ge11_prt [_event + _bx_jitter + ge11_delay][_station][_cscid][pr_cnt_ge11[_station][_cscid]*4] = _wiregroup; // actually carries partition
										ge11_csz [_event + _bx_jitter + ge11_delay][_station][_cscid][pr_cnt_ge11[_station][_cscid]*4] = _pattern;   // actually carries cluster size
										// cluster indexes above are filled 0, then 4, because GE11 fills clusters like that. Current EMTF logic can only use 0 and 4, so ignore all others
										// increase cluster counter
										pr_cnt_ge11[_station][_cscid]++;
									end // else: !if(pr_cnt_rpc[_station][_cscid] >= seg_ch)
								end // if (_valid == 2)
							end // if (_endcap == endcap_p || _sector == sector_p)
							
						end
				endcase
			end

			seli = 0;
			addri = 0;
			r_ini = 0;
			wei = 0;
			clki = 0;

			elapsed_time = 0;

			best_tracks = $fopen({`dpath, "/best_tracks_2nd.out"}, "w");
			nn_out      = $fopen({`dpath, "/nn.out"}, "w");
			best_tracks_short = $fopen({`dpath, "/best_tracks_short_2nd.out"}, "w");

            // give MMCM time to start, around 4.6 uS 
			for (i = 0; i < 250; i = i+1)
			begin
				for (j = 0; j < 2; j = j+1)
				begin
					`clk_drive(clki, j);
					`__top_module__
						end
            end
			
			for (i = 0; i < 200 + max_ev-1; i = i+1)
			begin

				wei = 0;
				for (k = 0; k < 5; k = k+1)
				begin
					
					csi[k] = 0;
					for (j = 0; j < 9; j = j+1)
					begin
						for (si = 0; si < seg_ch; si = si+1)
						begin
							qi[k][j][si] = 0;
							wgi[k][j][si] = 0;
							hstri[k][j][si] = 0;
							cpati[k][j][si] = 0;
							hmti[k][j][si] = 0;
							qsesi[k][j][si] = 0;
							lri[k][j][si] = 0;
						end
					end
				end


				// read params registers
				if (i == 1)
				begin
				    /*
				    $fwrite (sim_out, "ph_init0: ");
				    for (pi = 0; pi <= 15; pi++)
				        $fwrite (sim_out, "%h ", ph_init0[pi]);
				    $fwrite (sim_out, "\n");
				
				    $fwrite (sim_out, "ph_init[0]: ");
                    for (pi = 0; pi <= 15; pi++)
                        $fwrite (sim_out, "%h ", ph_init[0][pi]);
                    $fwrite (sim_out, "\n");*/
/*           
					$fwrite(sim_out, "st: 0  cid: 0  "); for (si=0; si<6; si++) $fwrite(sim_out, "%d ", uut.pcs.station11[0].csc11[0].pc11.params[si]);$fwrite(sim_out, "\n");
					$fwrite(sim_out, "st: 0  cid: 1  "); for (si=0; si<6; si++) $fwrite(sim_out, "%d ", uut.pcs.station11[0].csc11[1].pc11.params[si]);$fwrite(sim_out, "\n");
					$fwrite(sim_out, "st: 0  cid: 2  "); for (si=0; si<6; si++) $fwrite(sim_out, "%d ", uut.pcs.station11[0].csc11[2].pc11.params[si]);$fwrite(sim_out, "\n");
					$fwrite(sim_out, "st: 1  cid: 0  "); for (si=0; si<6; si++) $fwrite(sim_out, "%d ", uut.pcs.station11[1].csc11[0].pc11.params[si]);$fwrite(sim_out, "\n");
					$fwrite(sim_out, "st: 1  cid: 1  "); for (si=0; si<6; si++) $fwrite(sim_out, "%d ", uut.pcs.station11[1].csc11[1].pc11.params[si]);$fwrite(sim_out, "\n");
					$fwrite(sim_out, "st: 1  cid: 2  "); for (si=0; si<6; si++) $fwrite(sim_out, "%d ", uut.pcs.station11[1].csc11[2].pc11.params[si]);$fwrite(sim_out, "\n");

					$fwrite(sim_out, "st: 0  cid: 3  "); for (si=0; si<4; si++) $fwrite(sim_out, "%d ", uut.pcs.station12[0].csc12[3].pc12.params[si]);$fwrite(sim_out, "\n");
					$fwrite(sim_out, "st: 0  cid: 4  "); for (si=0; si<4; si++) $fwrite(sim_out, "%d ", uut.pcs.station12[0].csc12[4].pc12.params[si]);$fwrite(sim_out, "\n");
					$fwrite(sim_out, "st: 0  cid: 5  "); for (si=0; si<4; si++) $fwrite(sim_out, "%d ", uut.pcs.station12[0].csc12[5].pc12.params[si]);$fwrite(sim_out, "\n");
					$fwrite(sim_out, "st: 0  cid: 6  "); for (si=0; si<4; si++) $fwrite(sim_out, "%d ", uut.pcs.station12[0].csc12[6].pc12.params[si]);$fwrite(sim_out, "\n");
					$fwrite(sim_out, "st: 0  cid: 7  "); for (si=0; si<4; si++) $fwrite(sim_out, "%d ", uut.pcs.station12[0].csc12[7].pc12.params[si]);$fwrite(sim_out, "\n");
					$fwrite(sim_out, "st: 0  cid: 8  "); for (si=0; si<4; si++) $fwrite(sim_out, "%d ", uut.pcs.station12[0].csc12[8].pc12.params[si]);$fwrite(sim_out, "\n");
					$fwrite(sim_out, "st: 1  cid: 3  "); for (si=0; si<4; si++) $fwrite(sim_out, "%d ", uut.pcs.station12[1].csc12[3].pc12.params[si]);$fwrite(sim_out, "\n");
					$fwrite(sim_out, "st: 1  cid: 4  "); for (si=0; si<4; si++) $fwrite(sim_out, "%d ", uut.pcs.station12[1].csc12[4].pc12.params[si]);$fwrite(sim_out, "\n");
					$fwrite(sim_out, "st: 1  cid: 5  "); for (si=0; si<4; si++) $fwrite(sim_out, "%d ", uut.pcs.station12[1].csc12[5].pc12.params[si]);$fwrite(sim_out, "\n");
					$fwrite(sim_out, "st: 1  cid: 6  "); for (si=0; si<4; si++) $fwrite(sim_out, "%d ", uut.pcs.station12[1].csc12[6].pc12.params[si]);$fwrite(sim_out, "\n");
					$fwrite(sim_out, "st: 1  cid: 7  "); for (si=0; si<4; si++) $fwrite(sim_out, "%d ", uut.pcs.station12[1].csc12[7].pc12.params[si]);$fwrite(sim_out, "\n");
					$fwrite(sim_out, "st: 1  cid: 8  "); for (si=0; si<4; si++) $fwrite(sim_out, "%d ", uut.pcs.station12[1].csc12[8].pc12.params[si]);$fwrite(sim_out, "\n");

					$fwrite(sim_out, "st: 2 cid: 0	"); for (si=0; si<4; si++) $fwrite(sim_out, "%d ", uut.pcs.station234[2].csc[0].pc.params[si]);$fwrite(sim_out, "\n");
					$fwrite(sim_out, "st: 2	cid: 1	"); for (si=0; si<4; si++) $fwrite(sim_out, "%d ", uut.pcs.station234[2].csc[1].pc.params[si]);$fwrite(sim_out, "\n");
					$fwrite(sim_out, "st: 2	cid: 2	"); for (si=0; si<4; si++) $fwrite(sim_out, "%d ", uut.pcs.station234[2].csc[2].pc.params[si]);$fwrite(sim_out, "\n");
					$fwrite(sim_out, "st: 2	cid: 3	"); for (si=0; si<4; si++) $fwrite(sim_out, "%d ", uut.pcs.station234[2].csc[3].pc.params[si]);$fwrite(sim_out, "\n");
					$fwrite(sim_out, "st: 2	cid: 4	"); for (si=0; si<4; si++) $fwrite(sim_out, "%d ", uut.pcs.station234[2].csc[4].pc.params[si]);$fwrite(sim_out, "\n");
					$fwrite(sim_out, "st: 2	cid: 5	"); for (si=0; si<4; si++) $fwrite(sim_out, "%d ", uut.pcs.station234[2].csc[5].pc.params[si]);$fwrite(sim_out, "\n");
					$fwrite(sim_out, "st: 2	cid: 6	"); for (si=0; si<4; si++) $fwrite(sim_out, "%d ", uut.pcs.station234[2].csc[6].pc.params[si]);$fwrite(sim_out, "\n");
					$fwrite(sim_out, "st: 2	cid: 7	"); for (si=0; si<4; si++) $fwrite(sim_out, "%d ", uut.pcs.station234[2].csc[7].pc.params[si]);$fwrite(sim_out, "\n");
					$fwrite(sim_out, "st: 2	cid: 8	"); for (si=0; si<4; si++) $fwrite(sim_out, "%d ", uut.pcs.station234[2].csc[8].pc.params[si]);$fwrite(sim_out, "\n");
					$fwrite(sim_out, "st: 3	cid: 0	"); for (si=0; si<4; si++) $fwrite(sim_out, "%d ", uut.pcs.station234[3].csc[0].pc.params[si]);$fwrite(sim_out, "\n");
					$fwrite(sim_out, "st: 3	cid: 1	"); for (si=0; si<4; si++) $fwrite(sim_out, "%d ", uut.pcs.station234[3].csc[1].pc.params[si]);$fwrite(sim_out, "\n");
					$fwrite(sim_out, "st: 3	cid: 2	"); for (si=0; si<4; si++) $fwrite(sim_out, "%d ", uut.pcs.station234[3].csc[2].pc.params[si]);$fwrite(sim_out, "\n");
					$fwrite(sim_out, "st: 3	cid: 3	"); for (si=0; si<4; si++) $fwrite(sim_out, "%d ", uut.pcs.station234[3].csc[3].pc.params[si]);$fwrite(sim_out, "\n");
					$fwrite(sim_out, "st: 3	cid: 4	"); for (si=0; si<4; si++) $fwrite(sim_out, "%d ", uut.pcs.station234[3].csc[4].pc.params[si]);$fwrite(sim_out, "\n");
					$fwrite(sim_out, "st: 3	cid: 5	"); for (si=0; si<4; si++) $fwrite(sim_out, "%d ", uut.pcs.station234[3].csc[5].pc.params[si]);$fwrite(sim_out, "\n");
					$fwrite(sim_out, "st: 3	cid: 6	"); for (si=0; si<4; si++) $fwrite(sim_out, "%d ", uut.pcs.station234[3].csc[6].pc.params[si]);$fwrite(sim_out, "\n");
					$fwrite(sim_out, "st: 3	cid: 7	"); for (si=0; si<4; si++) $fwrite(sim_out, "%d ", uut.pcs.station234[3].csc[7].pc.params[si]);$fwrite(sim_out, "\n");
					$fwrite(sim_out, "st: 3	cid: 8	"); for (si=0; si<4; si++) $fwrite(sim_out, "%d ", uut.pcs.station234[3].csc[8].pc.params[si]);$fwrite(sim_out, "\n");
					$fwrite(sim_out, "st: 4	cid: 0	"); for (si=0; si<4; si++) $fwrite(sim_out, "%d ", uut.pcs.station234[4].csc[0].pc.params[si]);$fwrite(sim_out, "\n");
					$fwrite(sim_out, "st: 4	cid: 1	"); for (si=0; si<4; si++) $fwrite(sim_out, "%d ", uut.pcs.station234[4].csc[1].pc.params[si]);$fwrite(sim_out, "\n");
					$fwrite(sim_out, "st: 4	cid: 2	"); for (si=0; si<4; si++) $fwrite(sim_out, "%d ", uut.pcs.station234[4].csc[2].pc.params[si]);$fwrite(sim_out, "\n");
					$fwrite(sim_out, "st: 4	cid: 3	"); for (si=0; si<4; si++) $fwrite(sim_out, "%d ", uut.pcs.station234[4].csc[3].pc.params[si]);$fwrite(sim_out, "\n");
					$fwrite(sim_out, "st: 4	cid: 4	"); for (si=0; si<4; si++) $fwrite(sim_out, "%d ", uut.pcs.station234[4].csc[4].pc.params[si]);$fwrite(sim_out, "\n");
					$fwrite(sim_out, "st: 4	cid: 5	"); for (si=0; si<4; si++) $fwrite(sim_out, "%d ", uut.pcs.station234[4].csc[5].pc.params[si]);$fwrite(sim_out, "\n");
					$fwrite(sim_out, "st: 4	cid: 6	"); for (si=0; si<4; si++) $fwrite(sim_out, "%d ", uut.pcs.station234[4].csc[6].pc.params[si]);$fwrite(sim_out, "\n");
					$fwrite(sim_out, "st: 4	cid: 7	"); for (si=0; si<4; si++) $fwrite(sim_out, "%d ", uut.pcs.station234[4].csc[7].pc.params[si]);$fwrite(sim_out, "\n");
					$fwrite(sim_out, "st: 4	cid: 8	"); for (si=0; si<4; si++) $fwrite(sim_out, "%d ", uut.pcs.station234[4].csc[8].pc.params[si]);$fwrite(sim_out, "\n");
					$fwrite(sim_out, "st: 4	cid: 0	"); for (si=0; si<4; si++) $fwrite(sim_out, "%d ", uut.pcs.station234[4].csc[0].pc.params[si]);$fwrite(sim_out, "\n");

                    $fwrite(sim_out, "neighbor sector:\n");
                    $fwrite(sim_out, "st: 5 cid: 0  "); for (si=0; si<6; si++) $fwrite(sim_out, "%d ", uut.pcs.pcn11.params[si]);$fwrite(sim_out, "\n");
                    $fwrite(sim_out, "st: 5 cid: 1  "); for (si=0; si<4; si++) $fwrite(sim_out, "%d ", uut.pcs.cscn[1].pcn.params[si]);$fwrite(sim_out, "\n");
                    $fwrite(sim_out, "st: 5 cid: 2  "); for (si=0; si<4; si++) $fwrite(sim_out, "%d ", uut.pcs.cscn[2].pcn.params[si]);$fwrite(sim_out, "\n");
                    $fwrite(sim_out, "st: 5 cid: 3  "); for (si=0; si<4; si++) $fwrite(sim_out, "%d ", uut.pcs.cscn[3].pcn.params[si]);$fwrite(sim_out, "\n");
                    $fwrite(sim_out, "st: 5 cid: 4  "); for (si=0; si<4; si++) $fwrite(sim_out, "%d ", uut.pcs.cscn[4].pcn.params[si]);$fwrite(sim_out, "\n");
                    $fwrite(sim_out, "st: 5 cid: 5  "); for (si=0; si<4; si++) $fwrite(sim_out, "%d ", uut.pcs.cscn[5].pcn.params[si]);$fwrite(sim_out, "\n");
                    $fwrite(sim_out, "st: 5 cid: 6  "); for (si=0; si<4; si++) $fwrite(sim_out, "%d ", uut.pcs.cscn[6].pcn.params[si]);$fwrite(sim_out, "\n");
                    $fwrite(sim_out, "st: 5 cid: 7  "); for (si=0; si<4; si++) $fwrite(sim_out, "%d ", uut.pcs.cscn[7].pcn.params[si]);$fwrite(sim_out, "\n");
                    $fwrite(sim_out, "st: 5 cid: 8  "); for (si=0; si<4; si++) $fwrite(sim_out, "%d ", uut.pcs.cscn[8].pcn.params[si]);$fwrite(sim_out, "\n");
                 
				   $fwrite (sim_out, "th_init:\n");
				   $fwrite(sim_out, "%h ", uut.pcs.station234[2].csc[0].pc.params[1]);
				   $fwrite(sim_out, "%h ", uut.pcs.station234[2].csc[1].pc.params[1]);
				   $fwrite(sim_out, "%h ", uut.pcs.station234[2].csc[2].pc.params[1]);
				   $fwrite(sim_out, "%h ", uut.pcs.station234[2].csc[3].pc.params[1]);
				   $fwrite(sim_out, "%h ", uut.pcs.station234[2].csc[4].pc.params[1]);
				   $fwrite(sim_out, "%h ", uut.pcs.station234[2].csc[5].pc.params[1]);
				   $fwrite(sim_out, "%h ", uut.pcs.station234[2].csc[6].pc.params[1]);
				   $fwrite(sim_out, "%h ", uut.pcs.station234[2].csc[7].pc.params[1]);
				   $fwrite(sim_out, "%h ", uut.pcs.station234[2].csc[8].pc.params[1]);
				   $fwrite(sim_out, "\n");
				   $fwrite (sim_out, "th_lut 2 1:\n");
				   for (si=0; si<128; si++) $fwrite(sim_out, "%h ", uut.pcs.station234[2].csc[1].pc.th_mem[si]);$fwrite(sim_out, "\n");
				   $fwrite (sim_out, "th_lut 4 1:\n");
				   for (si=0; si<128; si++) $fwrite(sim_out, "%h ", uut.pcs.station234[3].csc[1].pc.th_mem[si]);$fwrite(sim_out, "\n");
				   $fwrite (sim_out, "th_lut 4 1:\n");
				   for (si=0; si<128; si++) $fwrite(sim_out, "%h ", uut.pcs.station234[4].csc[1].pc.th_mem[si]);$fwrite(sim_out, "\n");
*/				   
				end

			   
				if (i > 0)
				begin
					good_ev = 0;
					st_cnt = 0;
					for (ist = 0; ist < 6; ist=ist+1) // station
					begin
						for (icid = 0; icid < 9; icid=icid+1) // chamber id
						begin
							for (si = 0; si < seg_ch; si = si+1) // stub
							  begin
								 vpf  [ist][icid][si] = valid    [ev][ist][icid][si];
								 qi   [ist][icid][si] = quality  [ev][ist][icid][si];
								 wgi  [ist][icid][si] = wiregroup[ev][ist][icid][si];
								 hstri[ist][icid][si] = hstrip   [ev][ist][icid][si];
								 cpati[ist][icid][si] = clctpat  [ev][ist][icid][si];
								 hmti [ist][icid][si] = hmt      [ev][ist][icid][si];
								 qsesi[ist][icid][si] = qses     [ev][ist][icid][si];
								 lri  [ist][icid][si] = lr       [ev][ist][icid][si];
								 if (vpf [ist][icid][si] == 1'b1)
								 begin
								 
									$fwrite(sim_out, "CSC_RAW: ev: %4d st: %1d ch: %1d q: %h wg: %3d hs: %3d hmt: %h qses: %h tmb_revert: %1d\n",
								 			ev, ist, icid, qi [ist][icid][si], wgi [ist][icid][si], hstri [ist][icid][si], hmti [ist][icid][si],
								 			qsesi[ist][icid][si], tmb_revert[ist][icid]);
								 end
								// check if there is chamber data, update good event station mask
								if (qi  [ist][icid][si] > 0) good_ev[ist] = 1;
							end
						end // for (icid = 0; icid < 9; icid=icid+1)
						// count stations in this event
						if (good_ev[ist]) st_cnt = st_cnt + 1;
					end

					for (ist = 0; ist < 7; ist=ist+1) // subsector
					begin
						for (icid = 0; icid <= 5; icid=icid+1) // rpc chamber
						begin
							for (si = 0; si < seg_ch; si = si+1) // hit
							begin
							   f = icid/2; // frame
							   stb = ((icid%2)*2+si); // stub
							   cppf_rxd[ist][f][stb*16 +: 16] = {rpc_th [ev][ist][icid][si], rpc_ph [ev][ist][icid][si]};
//							   cppf_rxd[ist][f][stb*16 +: 16] = 16'hffff;
							   
							end
						end // for (icid = 0; icid < 9; icid=icid+1)
						// count stations in this event
						if (good_ev[ist]) st_cnt = st_cnt + 1;
					end

					for (ist = 0; ist < 7; ist=ist+1) // schamber
					begin
						for (icid = 0; icid < 2; icid=icid+1) // layer
						begin
							for (si = 0; si < 8; si = si+1) // cluster
							  begin
								    ge11_str_i [ist][icid][si] = ge11_str [ev][ist][icid][si];
								    ge11_prt_i [ist][icid][si] = ge11_prt [ev][ist][icid][si];
								    ge11_csz_i [ist][icid][si] = ge11_csz [ev][ist][icid][si];
								    ge11_vf_i  [ist][icid][si] = ge11_str [ev][ist][icid][si] != 8'hff;
                                     if (ge11_vf_i [ist][icid][si] == 1'b1)
                                     begin
                                        $fwrite(sim_out, "GEM_RAW: ev: %4d sch: %1d ly: %1d cls: %1h str: %h prt: %h\n",
                                                ev, ist, icid, si, ge11_str_i [ist][icid][si], ge11_prt_i [ist][icid][si]);
                                     end
						      end
						end
				    end



					ev = ev + 1;
					// count event as good if more than 2 stations, other than 3-4
					if (good_ev != 0 && good_ev != 1 && good_ev != 2 && good_ev != 4 && good_ev != 8 && 
						good_ev != 16 && good_ev != 24) 
					  good_ev_cnt = good_ev_cnt+1;
					if (good_ev == 24) st_cnt = 7; // 3-4 tracks marked as having 7 stations
					begin_time = $time;
				end
				
//				if (i == 210 || i == 220) lat_test = 1'b1;
//				else lat_test = 1'b0;
				
				
//				for (j = 0; j < 2; j = j+1)
//				begin
//					`clk_drive(clki, 1-j);
//					`__top_module__
//			    end

               
                clki = 1'b0;
                #10
                clki = 1'b1;
                #10 
				
				if (i > 0)
				begin

					iev = i;
					$fwrite(sim_out, "event: %d\n", iev);

					//$fwrite(sim_out, "ph: %d %d %d %d %d\n", 
					//		uut.ph[0][3][0], uut.ph[1][3][0], uut.ph[2][3][0], uut.ph[3][3][0], uut.ph[4][3][0]);
/*
					for (si = 0; si < 7; si = si+1) // subsector
					begin
						for (j = 0; j < 3; j = j+1) // frame
						  begin
							 if (cppf_rxd[si][j] != 64'hffffffffffffffff)
							   $fwrite (sim_out, "CPPF: lnk: %d fr: %d d: %x\n", si, j, cppf_rxd[si][j]);
						end
					end
*/
/*				   
					for (si = 0; si < 4; si = si+1)
					for (ip = 0; ip < 6; ip = ip+1)
					begin
						for (j = 0; j < 9; j = j+1)
						begin
							for (k = 0; k < 2; k = k+1)
							  begin
								 if (uut.cpatd[si][ip][j][k] == 4'h0 && uut.vld[si][ip][j][k] == 1'h1) // RPC stub
								   begin
									  $fwrite (sim_out, "RPC: hi: %d st: %d ch: %d seg: %d ph: %d th: %d\n",
											   si, ip, j, k, uut.phd[si][ip][j][k], uut.thd[si][ip][j][k]);
								   end
								 if (uut.cpatd[si][ip][j][k] != 4'h0 && uut.vld[si][ip][j][k] == 1'h1) // ME stub
								   begin
									  $fwrite (sim_out, "ME : hi: %d st: %d ch: %d seg: %d ph: %d th: %d\n",
											   si, ip, j, k, uut.phd[si][ip][j][k], uut.thd[si][ip][j][k]);
								   end
							end
						end
					end
*/

					for (ip = 0; ip < 6; ip = ip+1) // station
					begin
						for (j = 0; j < 9; j = j+1) // chamber
						begin
							for (k = 0; k < 2; k = k+1) // segment
							begin
								if (uut.vl[ip][j][k] != 0)
								begin
								
								    //$fwrite (sim_out, "STUB valid: st: %d ch: %d seg: %d\n", ip, j, k);
								
									if (ip <= 1 && j < 3) // ME11
								    begin
										$fwrite(sim_out, "CSC_STUB: st: %1d ch: %1d ph: %d  th: %d %d\n", 
												ip, j, uut.ph[ip][j][k], uut.th11[ip][j][k*2], uut.th11[ip][j][k*2+1]);
										 ph_high_prec = uut.ph[ip][j][k];
									end
									else if (ip == 5 && j == 0) // ME11 neighbor
                                        $fwrite(sim_out, "CSC_STUB: st: %1d ch: %1d ph: %d  th: %d %d\n", 
												ip, j, uut.ph[ip][j][k], uut.th11[2][0][k*2], uut.th11[2][0][k*2+1]);
									else
									begin
										$fwrite(sim_out, "CSC_STUB: st: %1d ch: %1d ph: %d  th: %d ph_hit: %d ph_zone: %d\n", 
												ip, j, uut.ph[ip][j][k], uut.th[ip][j][k],5,5);//uut.ph_hit[ip][j][k],uut.ph_zone[ip][j][k]);
										 ph_high_prec = uut.ph[ip][j][k];
									end
								end
							end
						end
					end // for (ip = 0; ip < 6; ip = ip+1)

					for (ip = 0; ip < 7; ip = ip+1) // schamber
					begin
						for (j = 0; j < 2; j = j+1) // layer
						begin
							for (k = 0; k < 8; k = k+1) // cluster
							begin
							
//							    if (uut.pcs_ge11.ge11_scham_loop[ip].ge11_layer_loop[j].ge11_cluster_loop[k].pcge11.cl.vf != 0)
//                                if (uut.ge11_cl[ip][j][k].vf != 0)
//							    begin
//								    $fwrite(sim_out, "GE11: sch: %1d ly: %1d cluster: %1d\n",
//								            ip, j, k);
//							    end
							
							    if (uut.ge11_vl[ip][j][k] != 0)
							    begin
								    $fwrite(sim_out, "GEM_STUB: sch: %1d ly: %1d cluster: %1d ph: %h th: %h\n",
								            ip, j, k, uut.ge11_ph[ip][j][k], uut.ge11_th[ip][j][k]);
	                            end
	                        end
	                    end
	                end

/*
				   if (uut.ph_zone[0][1] != 0)
				   begin
					 //$fwrite(sim_out, "%b\n", uut.ph_zone[2][1]);
					  for (si = 0; si < ph_raw_w; si = si+1)
						begin
						   if (uut.ph_zone[0][1][si] == 1)
							 begin
								ph_low_prec = si*32;
								ph_zone_phi = si;
							 end
						end
					  $fwrite (sim_out, "ph_zone_phi: %d ph_low_prec: %d ph_high_prec: %d ph_high_low_diff: %d\n", 
							   ph_zone_phi, ph_low_prec, ph_high_prec, ph_high_prec - ph_low_prec);
					  
				   end
*/				   
                    /*
					for (zi = 4; zi >= 1; zi = zi-1) // zone loop
					begin
						$fwrite(sim_out, "zone: %d\n", zi);
						for (si = 4; si >= 1; si = si-1) // station loop (4 stations only here)
						begin
							$fwrite(sim_out, "%b\n", uut.ph_ext[zi-1][si]);
						end
					end
                    */
				   /*
				   $fwrite (sim_out, "q86: %b st1: %b st2: %b st3: %b st4: %b bx: %b \n", 
							uut.phps.gb.ph_pat_zone[0].ph_pat_hit[86].php.qcode_best,
							uut.phps.gb.ph_pat_zone[0].ph_pat_hit[86].php.st1,
							uut.phps.gb.ph_pat_zone[0].ph_pat_hit[86].php.st2,
							uut.phps.gb.ph_pat_zone[0].ph_pat_hit[86].php.st3,
							uut.phps.gb.ph_pat_zone[0].ph_pat_hit[86].php.st4,
							uut.phps.gb.ph_pat_zone[0].ph_pat_hit[86].php.bx
							);

					$fwrite (sim_out, "q92: %b st1: %b st2: %b st3: %b st4: %b bx: %b \n", 
							uut.phps.gb.ph_pat_zone[0].ph_pat_hit[92].php.qcode_best,
							uut.phps.gb.ph_pat_zone[0].ph_pat_hit[92].php.st1,
							uut.phps.gb.ph_pat_zone[0].ph_pat_hit[92].php.st2,
							uut.phps.gb.ph_pat_zone[0].ph_pat_hit[92].php.st3,
							uut.phps.gb.ph_pat_zone[0].ph_pat_hit[92].php.st4,
							uut.phps.gb.ph_pat_zone[0].ph_pat_hit[92].php.bx
							);
*/
/*				   
					for (iz = 0; iz < 4; iz = iz+1)
					begin
						for (ist = ph_raw_w; ist > 0; ist = ist - 1)
						begin
							if (uut.ph_rank[iz][ist-1] > 0)
								$fwrite(sim_out, "pattern: z: %d ph: %d q: %h ly: %b%b%b str: %b%b%b\n", 
									   iz, ist, uut.ph_rank[iz][ist-1],
									   uut.ph_rank[iz][ist-1][4], uut.ph_rank[iz][ist-1][2], uut.ph_rank[iz][ist-1][0],
									   uut.ph_rank[iz][ist-1][5], uut.ph_rank[iz][ist-1][3], uut.ph_rank[iz][ist-1][1]
									   );
						end
					end // for (iz = 0; iz < 4; iz = iz+1)
*/
					for (iz = 0; iz < 4; iz = iz+1) // zone loop
					begin
						for (ir = 0; ir < 3; ir = ir+1) // sorted pattern number
						begin
							if (uut.ph_q[iz][ir] > 0)
								$fwrite(sim_out, "PATTERN BEST: zone: %1d best_index: %1d ph_num: %3d rank: %2h ly: %b%b%b str: %b%b%b\n", 
								iz, ir, uut.ph_num[iz][ir], uut.ph_q[iz][ir],
								uut.ph_q[iz][ir][4], uut.ph_q[iz][ir][2], uut.ph_q[iz][ir][0], 
								uut.ph_q[iz][ir][5], uut.ph_q[iz][ir][3], uut.ph_q[iz][ir][1]
								);
						end
					end // for (iz = 0; iz < 4; iz = iz+1)

//				   $fwrite (sim_out, "csc ME2 ch 5: vl: %d th: %d cpat: %d\n", 
//							uut.cdl.vlo_csc[2][4][0], uut.cdl.tho_csc[2][4][0], uut.cdl.cpato_csc[2][4][0]);
//				   $fwrite (sim_out, "csc ME4 ch 5: vl: %d th: %d cpat: %d\n", 
//							uut.cdl.vlo_csc[4][4][0], uut.cdl.tho_csc[4][4][0], uut.cdl.cpato_csc[4][4][0]);

//				   $fwrite (sim_out, "dl0 ME2 ch 5: vl: %d th: %d cpat: %d\n", 
//							uut.cdl.vlo[0][2][4][0], uut.cdl.tho[0][2][4][0], uut.cdl.cpato[0][2][4][0]);
//				   $fwrite (sim_out, "dl0 ME4 ch 5: vl: %d th: %d cpat: %d\n", 
//							uut.cdl.vlo[0][4][4][0], uut.cdl.tho[0][4][4][0], uut.cdl.cpato[0][4][4][0]);

					for (iz = 0; iz < 4; iz = iz+1) // zone loop
					begin
						for (ir = 0; ir < ph_raw_w; ir = ir+1) // key strip loop
						  begin
						      if (uut.ph_rank[iz][ir] > 0)
							     $fwrite(sim_out, "PATTERN: zone: %1d phi_num: %3d rank: %2h\n", iz, ir, uut.ph_rank[iz][ir]);
						  end
					end
/*
				   $fwrite(sim_out, "valid: %b %b %b %d\n",
						   uut.srts.gb.ph_zone[0].zb3.wini[0],
						   uut.srts.gb.ph_zone[0].zb3.wini[1],
						   uut.srts.gb.ph_zone[0].zb3.wini[2],
						   cnrex
						   );
*/				   
/*
					for (iz = 0; iz < uut.mphseg.fs_loop[0].fs_00.tot_diff; iz = iz+1)
					begin
//						for (ip = 0; ip < 3; ip = ip+1)
						begin
							if (uut.mphseg.fs_loop[0].fs_00.ph_diff[iz] != 511)
								$fwrite(sim_out, "iz: %d ip: %d fs_00 ph_diff: %d\n", iz, ip, uut.mphseg.fs_loop[0].fs_00.ph_diff[iz]);

							if (uut.mphseg.fs_loop[0].fs_01.ph_diff[iz] != 31)
								$fwrite(sim_out, "iz: %d ip: %d fs_01 ph_diff: %d\n", iz, ip, uut.mphseg.fs_loop[0].fs_01.ph_diff[iz]);

							if (uut.mphseg.fs_loop[0].fs_02.ph_diff[iz] != 255)
								$fwrite(sim_out, "iz: %d ip: %d fs_02 ph_diff: %d\n", iz, ip, uut.mphseg.fs_loop[0].fs_02.ph_diff[iz]);

							if (uut.mphseg.fs_loop[0].fs_03.ph_diff[iz] != 255)
								$fwrite(sim_out, "iz: %d ip: %d fs_03 ph_diff: %d\n", iz, ip, uut.mphseg.fs_loop[0].fs_03.ph_diff[iz]);
						end
					end
*/
 /*
				   if (uut.mphseg.fs_loop[0].fs_00.vid != 2'b0) 
					 $fwrite (sim_out, "fs_00 ph_match: %d\n", uut.mphseg.fs_loop[0].fs_00.ph_match);
				   if (uut.mphseg.fs_loop[0].fs_01.vid != 2'b0) 
					 $fwrite (sim_out, "fs_01 ph_match: %d\n", uut.mphseg.fs_loop[0].fs_01.ph_match);
				   if (uut.mphseg.fs_loop[0].fs_02.vid != 2'b0) 
					 $fwrite (sim_out, "fs_02 ph_match: %d\n", uut.mphseg.fs_loop[0].fs_02.ph_match);
				   if (uut.mphseg.fs_loop[0].fs_03.vid != 2'b0) 
					 $fwrite (sim_out, "fs_03 ph_match: %d\n", uut.mphseg.fs_loop[0].fs_03.ph_match);
				   
					for (ibx = 0; ibx < max_drift; ibx = ibx+1) // history
						for (ist = 0; ist < 5; ist = ist+1) // station
							for (ich = 0; ich < 9; ich = ich+1) // chamber
								for (isg = 0; isg < 2; isg = isg+1) // segment
									if (uut.vld[ibx][ist][ich][isg]) $fwrite(sim_out, "delayed stub: bx:%d st:%d ch:%d sg:%d  ph: %d\n", 
																			 ibx,ist,ich,isg, uut.phd[ibx][ist][ich][isg]);
*/

					for (iz = 0; iz < 4; iz = iz+1) // zone loop
					begin
						for (ip = 0; ip < 3; ip = ip+1) // best pattern number
						begin
							for (ist = 0; ist < 4; ist = ist + 1) // station
							begin
								if (uut.patt_ph_vi[iz][ip][ist] > 0)
								begin
//									if (iz < 2 && ist == 0)
//										$fwrite(sim_out, "match seg: z: %d pat: %d st: %d   vi: %b hi: %d ci: %d si: %d ph: %d  th11: %d %d %d %d\n", 
//											   iz, ip, ist, uut.patt_ph_vi[iz][ip][ist], uut.patt_ph_hi[iz][ip][ist], uut.patt_ph_ci[iz][ip][ist], 
//												uut.patt_ph_si[iz][ip][ist], uut.ph_match[iz][ip][ist],
//											   uut.th_match11[iz][ip][0], uut.th_match11[iz][ip][1], 
//												uut.th_match11[iz][ip][2], uut.th_match11[iz][ip][3]);
//									else
										$fwrite(sim_out, "match seg: z: %d pat: %d st: %d   vi: %b hi: %d ci: %d si: %d ph: %d  th  : %d %d\n", 
											   iz, ip, ist, uut.patt_ph_vi[iz][ip][ist], uut.patt_ph_hi[iz][ip][ist], uut.patt_ph_ci[iz][ip][ist], 
												uut.patt_ph_si[iz][ip][ist], uut.ph_match[iz][ip][ist],
											    uut.th_match[iz][ip][ist][0], uut.th_match[iz][ip][ist][1]);
										
								end
							end // for (ist = 0; ist < 4; ist = ist + 1)
						end
					end // for (iz = 0; iz < 4; iz = iz+1)

/*
					for (ip = 0; ip < 6; ip = ip+1)
					begin
						for (j = 0; j < 9; j = j+1)
						begin
							for (k = 0; k < 2; k = k+1)
							begin
								if (uut.twom.vlo[0][ip][j][k] != 0)
								begin
//									$fwrite(sim_out, "stub: st: %d ch: %d qi: %d wgi: %d hstri: %d\n", 
//											ip, j, qi[ip][j][k], wgi[ip][j][k], hstri[ip][j][k]);
									$fwrite(sim_out, "2mu stub: st: %d ch: %d stub: %d\n", 
											ip, j, k);
								end
							end
						end
					end // for (ip = 0; ip < 6; ip = ip+1)
*/
				   if (uut.twom.bt_rank_i[0] != 0)
					 $fwrite (sim_out, "2mu track: rank: %d\n", uut.twom.bt_rank_i[0]);
				   
				   if ( uut.ds.gb.zl11[0].pl[0].da.bd12.dth[0] != 0)
					 begin
						/*
						$fwrite(sim_out, "ds: vi[0]: %b vi[1]: %b\n" ,
						   uut.ds.vi[0][0][0],
						   uut.ds.vi[0][0][1]
						   );
						
						$fwrite(sim_out, "da: vi[0]: %b vi[1]: %b\n" ,
						   uut.ds.gb.zl11[0].pl[0].da.vi[0],
						   uut.ds.gb.zl11[0].pl[0].da.vi[1]
						   );
						
						$fwrite(sim_out, "dth:  %d %d %d %d %d %d %d %d dvl: %b\n" ,
						   uut.ds.gb.zl11[0].pl[0].da.bd12.dth[0],
						   uut.ds.gb.zl11[0].pl[0].da.bd12.dth[1],
						   uut.ds.gb.zl11[0].pl[0].da.bd12.dth[2],
						   uut.ds.gb.zl11[0].pl[0].da.bd12.dth[3],
						   uut.ds.gb.zl11[0].pl[0].da.bd12.dth[4],
						   uut.ds.gb.zl11[0].pl[0].da.bd12.dth[5],
						   uut.ds.gb.zl11[0].pl[0].da.bd12.dth[6],
						   uut.ds.gb.zl11[0].pl[0].da.bd12.dth[7],
						   uut.ds.gb.zl11[0].pl[0].da.bd12.dvl
						   );

						$fwrite(sim_out, "cmp1: %d %d %d %d\n" ,
						   uut.ds.gb.zl11[0].pl[0].da.bd12.cmp1[0],
						   uut.ds.gb.zl11[0].pl[0].da.bd12.cmp1[1],
						   uut.ds.gb.zl11[0].pl[0].da.bd12.cmp1[2],
						   uut.ds.gb.zl11[0].pl[0].da.bd12.cmp1[3]
						   );
						$fwrite(sim_out, "cmp2: %d %d\n" ,
						   uut.ds.gb.zl11[0].pl[0].da.bd12.cmp2[0],
						   uut.ds.gb.zl11[0].pl[0].da.bd12.cmp2[1]
						   );
						$fwrite(sim_out, "bth:  %d\n" ,
						   uut.ds.gb.zl11[0].pl[0].da.bd12.bth,
						   );
						 */
					 end
					
/* -----\/----- EXCLUDED -----\/-----
					$fwrite(sim_out, "vstat: %b vi: %d%d%d%d vir: %d%d%d%d\n", 
							uut.ds.gb.zl[2].pl[0].da.vstat,
							uut.ds.gb.zl[2].pl[0].da.vi[0],
							uut.ds.gb.zl[2].pl[0].da.vi[1],
							uut.ds.gb.zl[2].pl[0].da.vi[2],
							uut.ds.gb.zl[2].pl[0].da.vi[3],
							uut.ds.gb.zl[2].pl[0].da.vir[0],
							uut.ds.gb.zl[2].pl[0].da.vir[1],
							uut.ds.gb.zl[2].pl[0].da.vir[2],
							uut.ds.gb.zl[2].pl[0].da.vir[3]
							);

					$fwrite(sim_out, "exists: %b  kill1: %b\n", uut.bt.exists, uut.bt.kill1);

					$fwrite(sim_out, "?i\n");
					for (ip = 0; ip < 4; ip = ip+1) // zone
					begin
						for (j = 0; j < 3; j = j+1) // pattern
						begin
							for (kp = 0; kp < 4; kp = kp+1) // station
							begin
								$fwrite(sim_out, "zone: %d pat: %d st: %d vi: %d hi: %d ci: %d si: %d\n", ip, j, kp,
										uut.bt.vi[ip][j][kp], uut.bt.hi[ip][j][kp], uut.bt.ci[ip][j][kp], uut.bt.si[ip][j][kp]);
							end
						end
					end
					$fwrite(sim_out, "cn_?i\n");
					for (ip = 0; ip < 4; ip = ip+1) // zone
					begin
						for (j = 0; j < 3; j = j+1) // pattern
						begin
							for (kp = 0; kp < 5; kp = kp+1) // station
							begin
								$fwrite(sim_out, "zone: %d pat: %d st: %d vi: %d hi: %d ci: %d si: %d\n", ip, j, kp,
										uut.bt.cn_vi[ip][j][kp], uut.bt.cn_hi[ip][j][kp], uut.bt.cn_ci[ip][j][kp], uut.bt.cn_si[ip][j][kp]);
							end
						end
					end
					
 -----/\----- EXCLUDED -----/\----- */
 
//                    if (uut.mphseg.ph_match[0][0][1] != 4'hf)
//                        $fwrite (sim_out, "segment match: ph: %d\n", uut.mphseg.ph_match[0][0][1]);
 
                    
                    
/*                    
				    for (ip = 0; ip < 3; ip = ip+1) // best track
				      begin
						 
				        $fwrite (sim_out, "best_track_i: %d bt_stA: %d chA: %d\n", ip, uut.pta.bt_stA[ip], uut.pta.chA[ip]);
				    end
 */
				   /*
				   $fwrite (sim_out, "stA: %d stB: %d chA: %d, chB: %d\n", uut.pta.stA, uut.pta.stB, uut.pta.chA, uut.pta.chB);
				   */
/*
				   for (iz = 0; iz < 4; iz = iz+1) // zone loop
				   begin
					 for (ip = 0; ip < 3; ip = ip+1) // pattern loop
					 begin
						for (is = 0; is < 5; is = is+1) // station loop
						begin
							 if (uut.bt.cn_vi[iz][ip][is] != 0)
							   $fwrite (sim_out, "bt zone: %d pat: %d station: %d vi: %d ci: %d si: %d hi: %d cand_bx: %d\n",
										iz, ip, is,
										uut.bt.cn_vi[iz][ip][is],uut.bt.cn_ci[iz][ip][is], uut.bt.cn_si[iz][ip][is], uut.bt.cn_hi[iz][ip][is],
										uut.bt.cand_bx[iz][ip]
										);
						end
					 end
				   end // for (iz = 0; iz < 4; iz = iz+1)
*/
 /*				   
				   if (uut.bt.exists != 0) $fwrite (sim_out, "exists: %b_%b_%b\n", uut.bt.exists[35:24], uut.bt.exists[23:12], uut.bt.exists[11:0]);
				   if (uut.bt.kill1  != 0) $fwrite (sim_out, "kill1:  %b_%b_%b\n", uut.bt.kill1[35:24], uut.bt.kill1[23:12], uut.bt.kill1[11:0]);
				   
				   if (uut.ds.gb.zl11[0].pl[0].da.vstat != 0) $fwrite (sim_out, "pre  delta vsat[%d][%d] = %b\n", 0, 0, uut.ds.gb.zl11[0].pl[0].da.vstat);
				   if (uut.ds.gb.zl  [2].pl[0].da.vstat != 0) $fwrite (sim_out, "pre  delta vsat[%d][%d] = %b\n", 2, 0, uut.ds.gb.zl  [2].pl[0].da.vstat);
				   if (uut.ds.gb.zl11[0].pl[1].da.vstat != 0) $fwrite (sim_out, "pre  delta vsat[%d][%d] = %b\n", 0, 1, uut.ds.gb.zl11[0].pl[1].da.vstat);
				   if (uut.ds.gb.zl  [2].pl[1].da.vstat != 0) $fwrite (sim_out, "pre  delta vsat[%d][%d] = %b\n", 2, 1, uut.ds.gb.zl  [2].pl[1].da.vstat);
				   if (uut.ds.gb.zl11[0].pl[2].da.vstat != 0) $fwrite (sim_out, "pre  delta vsat[%d][%d] = %b\n", 0, 2, uut.ds.gb.zl11[0].pl[2].da.vstat);
				   if (uut.ds.gb.zl  [2].pl[2].da.vstat != 0) $fwrite (sim_out, "pre  delta vsat[%d][%d] = %b\n", 2, 2, uut.ds.gb.zl  [2].pl[2].da.vstat);
				   if (uut.ds.gb.zl11[1].pl[0].da.vstat != 0) $fwrite (sim_out, "pre  delta vsat[%d][%d] = %b\n", 1, 0, uut.ds.gb.zl11[1].pl[0].da.vstat);
				   if (uut.ds.gb.zl  [3].pl[0].da.vstat != 0) $fwrite (sim_out, "pre  delta vsat[%d][%d] = %b\n", 3, 0, uut.ds.gb.zl  [3].pl[0].da.vstat);
				   if (uut.ds.gb.zl11[1].pl[1].da.vstat != 0) $fwrite (sim_out, "pre  delta vsat[%d][%d] = %b\n", 1, 1, uut.ds.gb.zl11[1].pl[1].da.vstat);
				   if (uut.ds.gb.zl  [3].pl[1].da.vstat != 0) $fwrite (sim_out, "pre  delta vsat[%d][%d] = %b\n", 3, 1, uut.ds.gb.zl  [3].pl[1].da.vstat);
				   if (uut.ds.gb.zl11[1].pl[2].da.vstat != 0) $fwrite (sim_out, "pre  delta vsat[%d][%d] = %b\n", 1, 2, uut.ds.gb.zl11[1].pl[2].da.vstat);
				   if (uut.ds.gb.zl  [3].pl[2].da.vstat != 0) $fwrite (sim_out, "pre  delta vsat[%d][%d] = %b\n", 3, 2, uut.ds.gb.zl  [3].pl[2].da.vstat);

 /*
 
				   for (iz = 0; iz < 4; iz = iz+1) // zone loop
				   begin
					   for (ip = 0; ip < 3; ip = ip+1) // pattern loop
					   begin
							if (uut.ph_qr[iz][ip] != 0)
							  $fwrite (sim_out, "pre  delta rank[%d][%d] = %b\n", iz, ip, uut.ph_qr[iz][ip]);
							if (uut.rank[iz][ip] != 0)
							  $fwrite (sim_out, "post delta rank[%d][%d] = %b\n", iz, ip, uut.rank[iz][ip]);
					   end
				   end

					for (iz = 0; iz < 4; iz = iz+1)
					begin
						for (ip = 0; ip < 3; ip = ip+1)
						begin
//							if (uut.rank[iz][ip] != 0)
								$fwrite(sim_out, "z: %d pat: %d ph_deltas: %d %d %d %d %d %d th_deltas: %d %d %d %d %d %d th_match: %d %d %d %d\n", 
										iz, ip,
										uut.delta_ph[iz][ip][0], uut.delta_ph[iz][ip][1], uut.delta_ph[iz][ip][2], uut.delta_ph[iz][ip][3], uut.delta_ph[iz][ip][4], uut.delta_ph[iz][ip][5], 
										uut.delta_th[iz][ip][0], uut.delta_th[iz][ip][1], uut.delta_th[iz][ip][2], uut.delta_th[iz][ip][3], uut.delta_th[iz][ip][4], uut.delta_th[iz][ip][5],
										uut.th_match[iz][ip][0][0], uut.th_match[iz][ip][1][0], uut.th_match[iz][ip][2][0], uut.th_match[iz][ip][3][0] 
										);
						end
					end
*/

//                    if (nn_valid_in != 3'b0) $fwrite (nn_out, "ev: %4d valid_all: %03b\n", iev, nn_valid_in);

					for (ip = 0; ip < 3; ip = ip+1)
					begin
					
					   if (uut.ptlut_addr_val[0])
						 begin
							// get PT from table
							pt_word = ptlut[uut.ptlut_addr[ip]/2]; // pt_word contains two pt values
							pt_word_rev = `brev(pt_word); // bytes are reversed for some reason, unreverse
							pt_value = uut.ptlut_addr[ip][0] == 1'b1 ? 
									   pt_word_rev[17:9] : pt_word_rev[8:0]; // low bit of address selects value
					        $fwrite(sim_out, " track pt address: %b %h pt: %h\n", uut.ptlut_addr[ip], uut.ptlut_addr[ip], pt_value);
/*							
							$fwrite (sim_out, "m15_theta: %d m15_r2_rpc: %d clct_2b_A: %d clct_is_0: %d n_rpc: %d m15_r1_rpc: %d m15_r1_rpc_clct1: %d m15_theta_rem3: %d ring1_2: %d\n", 
									 uut.pta.m15_theta[ip], uut.pta.m15_r2_rpc[ip], uut.pta.clct_2b_A[ip], uut.pta.clct_is_0[ip], uut.pta.n_rpc[ip], 
									 uut.pta.m15_r1_rpc[ip], uut.pta.m15_r1_rpc_clct1[ip], uut.pta.m15_theta_rem3[ip], uut.pta.ring1_2[ip]);

							$fwrite (sim_out, "bt_theta: %d theta_7b: %d theta_5b: %d\n",
									 uut.pta.bt_theta[ip], uut.pta.theta_7b[ip], uut.pta.theta_5b[ip]);
*/							
					        $fwrite(best_tracks, "ev: %d track pt address: %h pt_word: %h pt: %h\n", 
								   iev, uut.ptlut_addr[ip], pt_word_rev, pt_value);

						 end
/*					       
					   if (uut.ptlut_addr_val[ip])
                           $fwrite(sim_out, " GMT charge: %d\n", uut.gmt_crg[ip]);
*/					
					
					    if (hmt_out != 0)
					    begin
					       $fwrite (sim_out, "HMT trigger: %b\n", hmt_out);
					    end
					
						if (bt_rank[ip] != 0)
						begin
/*
							$fwrite(sim_out, "i: %d sign_th: %d %d %d %d %d %d delta_th: %d %d %d %d %d %d dth_red: %d\n",
									ip,
									uut.pta.bt_sign_th[ip][0], uut.pta.bt_sign_th[ip][1], uut.pta.bt_sign_th[ip][2], uut.pta.bt_sign_th[ip][3], 
									uut.pta.bt_sign_th[ip][4], uut.pta.bt_sign_th[ip][5], 
									uut.pta.bt_delta_th[ip][0], uut.pta.bt_delta_th[ip][1], uut.pta.bt_delta_th[ip][2], uut.pta.bt_delta_th[ip][3], 
									uut.pta.bt_delta_th[ip][4], uut.pta.bt_delta_th[ip][5],
									uut.pta.dth_red[ip]
									);
 */
							$fwrite(sim_out, "ME ");
							if (bt_rank[ip][5]) $fwrite(sim_out, "-1");
							if (bt_rank[ip][3]) $fwrite(sim_out, "-2");
							if (bt_rank[ip][1]) $fwrite(sim_out, "-3");
							if (bt_rank[ip][0]) $fwrite(sim_out, "-4");
							$fwrite(sim_out, " track: %d  rank: %h ly: %d ph_deltas: %d %d %d %d %d %d th_deltas: %d %d %d %d %d %d phi: %d,  theta: %d cpat: %d\n", 
									ip, bt_rank[ip],
									{bt_rank[ip][5], bt_rank[ip][3], bt_rank[ip][1], bt_rank[ip][0]},
									bt_delta_ph[ip][0], bt_delta_ph[ip][1], bt_delta_ph[ip][2], bt_delta_ph[ip][3], bt_delta_ph[ip][4], bt_delta_ph[ip][5], 
									bt_delta_th[ip][0], bt_delta_th[ip][1], bt_delta_th[ip][2], bt_delta_th[ip][3], bt_delta_th[ip][4], bt_delta_th[ip][5], 
									bt_phi[ip], bt_theta[ip], bt_cpattern[ip][0]);

							$fwrite(best_tracks, "ev: %d ME ", iev);
						    if (bt_rank[ip][5]) $fwrite(best_tracks, "-1"); else $fwrite(best_tracks, "  ");
						    if (bt_rank[ip][3]) $fwrite(best_tracks, "-2"); else $fwrite(best_tracks, "  ");
						    if (bt_rank[ip][1]) $fwrite(best_tracks, "-3"); else $fwrite(best_tracks, "  ");
						    if (bt_rank[ip][0]) $fwrite(best_tracks, "-4"); else $fwrite(best_tracks, "  ");
							$fwrite(best_tracks, " track: %d  rank: %h ly: %d ph_deltas: %d %d %d %d %d %d th_deltas: %d %d %d %d %d %d phi: %d,  theta: %d cpat: %d hcs:", 
									ip, bt_rank[ip], 
									{bt_rank[ip][5], bt_rank[ip][3], bt_rank[ip][1], bt_rank[ip][0]},
									bt_delta_ph[ip][0], bt_delta_ph[ip][1], bt_delta_ph[ip][2], bt_delta_ph[ip][3], bt_delta_ph[ip][4], bt_delta_ph[ip][5], 
									bt_delta_th[ip][0], bt_delta_th[ip][1], bt_delta_th[ip][2], bt_delta_th[ip][3], bt_delta_th[ip][4], bt_delta_th[ip][5], 
									bt_phi[ip], bt_theta[ip], bt_cpattern[ip][0]);
						   for (j = 0; j < 5; j = j+1)
						   begin
							  if (bt_vi[ip][j] == 1'b1)
								$fwrite(best_tracks, " %d%h%d", bt_hi[ip][j], bt_ci[ip][j], bt_si[ip][j]);
							  else 
								$fwrite(best_tracks, " ---");
                           end
                           $fwrite (best_tracks, "\n");

							//$fwrite(best_tracks_short, "ev: %d ", iev);
							$fwrite(best_tracks_short, " track: %d rank: %h phi: %d theta: %d\n", 
									ip, bt_rank[ip], bt_phi[ip], bt_theta[ip]);

						end
						
//                        nn_mode_r = uut.nn.mode;
//                        if (nn_mode_r[ip] != 0)
//                        begin
//                            $fwrite (nn_out, "ev: %4d ip: %1d mode: %1h ", iev, ip, nn_mode_r[ip]);
//                            for (j = 0; j < 23; j++)
//                            begin
//                                $fwrite (nn_out, " %05x", nn_input[ip][j]);
//                                nn_input[ip][j] = 0;
//                            end
////                            nn_valid_in[ip] = 0;
//                            $fwrite (nn_out, "\n");
//                        end
//                        $fflush (nn_out);
                        #1 // to let 120M clock print inputs first
                        if (nn_pt_v[ip] != 1'b0 || uut.nn.pt_unconv_valid[ip] != 1'b0) // converted or unconverted value valid  
//                        if (uut.nn.pt_unconv[ip] != 12'h14d || nn_pt[ip] != 8'h4 || nn_pt_v[ip] != 1'b0) // 0ec seems to be an output value when all inputs = 0 
//                        if (nn_pt[ip] != 8'h6) // 6 seems to be an output value when all inputs = 0 
                        begin
                          $fwrite (nn_out, "ev: %4d track: %1d NN_pt: %h NN_d0: %h NN_PT_V: %h NN_D0_V: %h pt_unconv: %h d0_unconv: %h\n", 
                                   iev, ip, nn_pt[ip], nn_d0[ip], nn_pt_v[ip], nn_d0_v[ip], uut.nn.pt_unconv[ip], uut.nn.d0_unconv[ip]);
                          $fflush (nn_out);

                          $fwrite (sim_out, "ev: %4d track: %1d NN_pt: %h NN_d0: %h NN_PT_V: %h NN_D0_V: %h pt_unconv: %h d0_unconv: %h\n", 
                                   iev, ip, nn_pt[ip], nn_d0[ip], nn_pt_v[ip], nn_d0_v[ip], uut.nn.pt_unconv[ip], uut.nn.d0_unconv[ip]);
                          $fflush (sim_out);
                        end

/*					   
						for (j = 0; j < 5; j = j+1)
						begin
						  if (bt_vi[ip][j] == 1'b1)
                            $fwrite(sim_out, "track segments: st: %d v: %d h: %d c: %d s: %d\n", j, bt_vi[ip][j], bt_hi[ip][j], bt_ci[ip][j], bt_si[ip][j]);
                        end
*/
 //                        $fwrite(sim_out, "\n");
						
//						if (gmt_eta[ip] != 239)
//						  $fwrite (sim_out, " gmt_phi: %d, gmt_eta: %d\n", gmt_phi[ip], gmt_eta[ip]);
					end // for (ip = 0; ip < 3; ip = ip+1)
/*					
		            for (gz = 0; gz < 4; gz = gz+1) // zone loop
                    begin
                        for (gn = 0; gn < 3; gn = gn+1) // pattern number
                        begin
                            if (uut.rank[gz][gn] > 0)
                                $fwrite(sim_out, "cand. rank: z: %d pat: %d rank: %h\n", gz, gn, uut.rank[gz][gn]);
                        
                            for (gs = 0; gs < 5; gs = gs+1) // station
                            begin
                              if (uut.bt.cn_vi_w[gz][gn][gs] == 1'b1)
                                  $fwrite(sim_out, "cand. segments: zone: %d pat: %d st: %d v: %d h: %d c: %d s: %d\n", 
                                  gz, gn, gs, 
                                  uut.bt.cn_vi_w[gz][gn][gs], 
                                  uut.bt.cn_hi_w[gz][gn][gs], 
                                  uut.bt.cn_ci_w[gz][gn][gs], 
                                  uut.bt.cn_si_w[gz][gn][gs]);
                            end
                        end
                    end
*/					
					
/* -----\/----- EXCLUDED -----\/-----


					for (iz = 0; iz < 5; iz = iz+1)
					begin
						for (ip = 0; ip < 9; ip = ip+1)
						begin
							if (uut.mphseg.vl[0][iz][ip][0] > 0)
								$fwrite(sim_out, "ph[%d][%d][0] = %d\n", iz, ip, uut.mphseg.ph[0][iz][ip][0]);
							if (uut.mphseg.vl[0][iz][ip][1] > 0)
								$fwrite(sim_out, "ph[%d][%d][1] = %d\n", iz, ip, uut.mphseg.ph[0][iz][ip][1]);
						end
					end
					
					
					$fwrite(sim_out, "ph_pat: %d\n", uut.mphseg.gb.fs_loop[0].fs_30.ph_pat);
					

					for (ip = 0; ip < 4; ip = ip+1)
					begin
						for (j = 0; j < 3; j = j+1)
						begin
							for (ist = 0; ist < 4; ist = ist + 1)
							begin
								//$fwrite(sim_out, "%d:%d:%d:%d ", uut.vir[ip][j][ist], uut.hir[ip][j][ist], uut.cir[ip][j][ist], uut.sir[ip][j][ist]);
								$fwrite(sim_out, "%d:%d:%d:%d ", uut.patt_ph_vi[ip][j][ist], uut.patt_ph_hi[ip][j][ist], uut.patt_ph_ci[ip][j][ist], uut.patt_ph_si[ip][j][ist]);
							end
							$fwrite(sim_out, "\n");
						end
						$fwrite(sim_out, "\n");
					end
					$fwrite(sim_out, "\n");

//					$fwrite(sim_out, "q: %d  ph: %d  th: %d  vl: %d\n", qi[0][3][0], uut.ph[0][3][0], uut.th[0][3][0], uut.vl[0][3][0]);
					
*/


//					for (iz = 0; iz < 4; iz = iz+1) // zone loop
//						for (ist = 0; ist < 3; ist = ist + 1) // best pattern loop
//							if (uut.ph_q[iz][ist] > 0)
//								$fwrite(sim_out, "winner pattern: z: %d ph_num: %d ph_q: %h\n",
//									   iz, uut.ph_num[iz][ist], uut.ph_q[iz][ist]);
/*
					$fwrite(sim_out, "winners: ");
					for (iz = 0; iz < 3; iz = iz+1)
						$fwrite(sim_out, "%h ", uut.srts.gb.ph_zone[0].zb3.winnerw[iz]);
					$fwrite(sim_out, "\n");

//					$fwrite(sim_out, "winners: %h %h %h\n", uut.bt.winner[0], uut.bt.winner[1], uut.bt.winner[2]);
					
*/					
/*
//					$fwrite(sim_out, "ph matching segments:\n");

					$fwrite(sim_out, "bnm: %b %b %b %b %b %b   bvl: %b %b %b %b %b %b\n",
							uut.ds.zl11[1].pl[0].da.bnm12,
							uut.ds.zl11[1].pl[0].da.bnm13,
							uut.ds.zl11[1].pl[0].da.bnm14,
							uut.ds.zl11[1].pl[0].da.bnm23,
							uut.ds.zl11[1].pl[0].da.bnm24,
							uut.ds.zl11[1].pl[0].da.bnm34,
							uut.ds.zl11[1].pl[0].da.bvl12,
							uut.ds.zl11[1].pl[0].da.bvl13,
							uut.ds.zl11[1].pl[0].da.bvl14,
							uut.ds.zl11[1].pl[0].da.bvl23,
							uut.ds.zl11[1].pl[0].da.bvl24,
							uut.ds.zl11[1].pl[0].da.bvl34
							);


 //					if (uut.ds.zl11[0].pl[0].da.dvalid != 0)
						$fwrite(sim_out, "z: %d pat: %d  min th deltas: %d %d %d  vstat: %b bvl: %b%b%b thA: %d  thB: %d  dth: %d\n",
								0, 0,	uut.ds.zl11[1].pl[0].da.bth23, uut.ds.zl11[1].pl[0].da.bth24, uut.ds.zl11[1].pl[0].da.bth34, uut.ds.zl11[1].pl[0].da.vstat,
								uut.ds.zl11[1].pl[0].da.bvl23, uut.ds.zl11[1].pl[0].da.bvl24, uut.ds.zl11[1].pl[0].da.bvl34,
								uut.ds.zl11[1].pl[0].da.thA, uut.ds.zl11[1].pl[0].da.thB, uut.ds.zl11[1].pl[0].da.dth);

					$fwrite(sim_out, "dth23, dvl23:\n");
					for (ip = 0; ip < 4; ip = ip+1)
						$fwrite(sim_out, "%d %b  ", uut.ds.zl11[1].pl[0].da.bd23.dth[ip], uut.ds.zl11[1].pl[0].da.bd23.dvl[ip]);
					$fwrite(sim_out, "\n");

					$fwrite(sim_out, "bd23.dth, dvl:\n");
					for (ip = 0; ip < 2; ip = ip+1)
						$fwrite(sim_out, "%d %b  ", uut.ds.zl11[1].pl[0].da.bd23.cmp1[ip], uut.ds.zl11[1].pl[0].da.bd23.cmp1[ip]);
					$fwrite(sim_out, "\n");

					$fwrite(sim_out, "th_match:\n");
					for (iz = 1; iz < 4; iz = iz+1)
					begin
						for (ip = 0; ip < 2; ip = ip+1)
						begin
							$fwrite(sim_out, "%d ", uut.ds.zl11[1].pl[0].da.th_match[iz][ip]);
						end
					end
					$fwrite(sim_out, "\n");
					
					if (uut.ds.zl11[0].pl[1].da.dvalid)
						$fwrite(sim_out, "z: %d pat: %d  min th deltas: %d %d %d  vmask: %b\n",
								0, 1,	uut.ds.zl11[0].pl[1].da.bthAB, uut.ds.zl11[0].pl[1].da.bthBC, uut.ds.zl11[0].pl[1].da.bthCD, uut.ds.zl11[0].pl[1].da.vmask);
					if (uut.ds.zl11[0].pl[2].da.dvalid)
						$fwrite(sim_out, "z: %d pat: %d  min th deltas: %d %d %d  vmask: %b\n",
								0, 2,	uut.ds.zl11[0].pl[2].da.bthAB, uut.ds.zl11[0].pl[2].da.bthBC, uut.ds.zl11[0].pl[2].da.bthCD, uut.ds.zl11[0].pl[2].da.vmask);
					if (uut.ds.zl11[1].pl[0].da.dvalid)
						$fwrite(sim_out, "z: %d pat: %d  min th deltas: %d %d %d  vmask: %b\n",
								1, 0,	uut.ds.zl11[1].pl[0].da.bthAB, uut.ds.zl11[1].pl[0].da.bthBC, uut.ds.zl11[1].pl[0].da.bthCD, uut.ds.zl11[1].pl[0].da.vmask);
					if (uut.ds.zl11[1].pl[1].da.dvalid)
						$fwrite(sim_out, "z: %d pat: %d  min th deltas: %d %d %d  vmask: %b\n",
								1, 1,	uut.ds.zl11[1].pl[1].da.bthAB, uut.ds.zl11[1].pl[1].da.bthBC, uut.ds.zl11[1].pl[1].da.bthCD, uut.ds.zl11[1].pl[1].da.vmask);
					if (uut.ds.zl11[1].pl[2].da.dvalid)
						$fwrite(sim_out, "z: %d pat: %d  min th deltas: %d %d %d  vmask: %b\n",
								1, 2,	uut.ds.zl11[1].pl[2].da.bthAB, uut.ds.zl11[1].pl[2].da.bthBC, uut.ds.zl11[1].pl[2].da.bthCD, uut.ds.zl11[1].pl[2].da.vmask);
					
					if (uut.ds.zl[2].pl[0].da.dvalid)
						$fwrite(sim_out, "z: %d pat: %d  min th deltas: %d %d %d  vmask: %b\n",
								2, 0,	uut.ds.zl[2].pl[0].da.bthAB, uut.ds.zl[2].pl[0].da.bthBC, uut.ds.zl[2].pl[0].da.bthCD, uut.ds.zl[2].pl[0].da.vmask);
					if (uut.ds.zl[2].pl[1].da.dvalid)
						$fwrite(sim_out, "z: %d pat: %d  min th deltas: %d %d %d  vmask: %b\n",
								2, 1,	uut.ds.zl[2].pl[1].da.bthAB, uut.ds.zl[2].pl[1].da.bthBC, uut.ds.zl[2].pl[1].da.bthCD, uut.ds.zl[2].pl[1].da.vmask);
					if (uut.ds.zl[2].pl[2].da.dvalid)
						$fwrite(sim_out, "z: %d pat: %d  min th deltas: %d %d %d  vmask: %b\n",
								2, 2,	uut.ds.zl[2].pl[2].da.bthAB, uut.ds.zl[2].pl[2].da.bthBC, uut.ds.zl[2].pl[2].da.bthCD, uut.ds.zl[2].pl[2].da.vmask);
					if (uut.ds.zl[3].pl[0].da.dvalid)
						$fwrite(sim_out, "z: %d pat: %d  min th deltas: %d %d %d  vmask: %b\n",
								3, 0,	uut.ds.zl[3].pl[0].da.bthAB, uut.ds.zl[3].pl[0].da.bthBC, uut.ds.zl[3].pl[0].da.bthCD, uut.ds.zl[3].pl[0].da.vmask);
					if (uut.ds.zl[3].pl[1].da.dvalid)
						$fwrite(sim_out, "z: %d pat: %d  min th deltas: %d %d %d  vmask: %b\n",
								3, 1,	uut.ds.zl[3].pl[1].da.bthAB, uut.ds.zl[3].pl[1].da.bthBC, uut.ds.zl[3].pl[1].da.bthCD, uut.ds.zl[3].pl[1].da.vmask);
					if (uut.ds.zl[3].pl[2].da.dvalid)
						$fwrite(sim_out, "z: %d pat: %d  min th deltas: %d %d %d  vmask: %b\n",
								3, 2,	uut.ds.zl[3].pl[2].da.bthAB, uut.ds.zl[3].pl[2].da.bthBC, uut.ds.zl[3].pl[2].da.bthCD, uut.ds.zl[3].pl[2].da.vmask);


					
					if (uut.ds.zl11[0].pl[0].da.vmask != 0)
						$fwrite(sim_out, "z: %d pat: %d  min th deltas: %d %d %d  vmask: %b  lw: %b%b%b  bvl: %b%b%b\n",
								0, 0,	uut.ds.zl11[0].pl[0].da.bthAB, uut.ds.zl11[0].pl[0].da.bthBC, uut.ds.zl11[0].pl[0].da.bthCD, uut.ds.zl11[0].pl[0].da.vmask,
								uut.ds.zl11[0].pl[0].da.lwAB, uut.ds.zl11[0].pl[0].da.lwBC, uut.ds.zl11[0].pl[0].da.lwCD,
								uut.ds.zl11[0].pl[0].da.bvlAB, uut.ds.zl11[0].pl[0].da.bvlBC, uut.ds.zl11[0].pl[0].da.bvlCD
								);
					if (uut.ds.zl11[0].pl[1].da.vmask)
						$fwrite(sim_out, "z: %d pat: %d  min th deltas: %d %d %d  vmask: %b\n",
								0, 1,	uut.ds.zl11[0].pl[1].da.bthAB, uut.ds.zl11[0].pl[1].da.bthBC, uut.ds.zl11[0].pl[1].da.bthCD, uut.ds.zl11[0].pl[1].da.vmask);
					if (uut.ds.zl11[0].pl[2].da.vmask)
						$fwrite(sim_out, "z: %d pat: %d  min th deltas: %d %d %d  vmask: %b\n",
								0, 2,	uut.ds.zl11[0].pl[2].da.bthAB, uut.ds.zl11[0].pl[2].da.bthBC, uut.ds.zl11[0].pl[2].da.bthCD, uut.ds.zl11[0].pl[2].da.vmask);
					if (uut.ds.zl11[1].pl[0].da.vmask)
						$fwrite(sim_out, "z: %d pat: %d  min th deltas: %d %d %d  vmask: %b\n",
								1, 0,	uut.ds.zl11[1].pl[0].da.bthAB, uut.ds.zl11[1].pl[0].da.bthBC, uut.ds.zl11[1].pl[0].da.bthCD, uut.ds.zl11[1].pl[0].da.vmask);
					if (uut.ds.zl11[1].pl[1].da.vmask)
						$fwrite(sim_out, "z: %d pat: %d  min th deltas: %d %d %d  vmask: %b\n",
								1, 1,	uut.ds.zl11[1].pl[1].da.bthAB, uut.ds.zl11[1].pl[1].da.bthBC, uut.ds.zl11[1].pl[1].da.bthCD, uut.ds.zl11[1].pl[1].da.vmask);
					if (uut.ds.zl11[1].pl[2].da.vmask)
						$fwrite(sim_out, "z: %d pat: %d  min th deltas: %d %d %d  vmask: %b\n",
								1, 2,	uut.ds.zl11[1].pl[2].da.bthAB, uut.ds.zl11[1].pl[2].da.bthBC, uut.ds.zl11[1].pl[2].da.bthCD, uut.ds.zl11[1].pl[2].da.vmask);
					
					if (uut.ds.zl[2].pl[0].da.vmask)
						$fwrite(sim_out, "z: %d pat: %d  min th deltas: %d %d %d  vmask: %b\n",
								2, 0,	uut.ds.zl[2].pl[0].da.bthAB, uut.ds.zl[2].pl[0].da.bthBC, uut.ds.zl[2].pl[0].da.bthCD, uut.ds.zl[2].pl[0].da.vmask);
					if (uut.ds.zl[2].pl[1].da.vmask)
						$fwrite(sim_out, "z: %d pat: %d  min th deltas: %d %d %d  vmask: %b\n",
								2, 1,	uut.ds.zl[2].pl[1].da.bthAB, uut.ds.zl[2].pl[1].da.bthBC, uut.ds.zl[2].pl[1].da.bthCD, uut.ds.zl[2].pl[1].da.vmask);
					if (uut.ds.zl[2].pl[2].da.vmask)
						$fwrite(sim_out, "z: %d pat: %d  min th deltas: %d %d %d  vmask: %b\n",
								2, 2,	uut.ds.zl[2].pl[2].da.bthAB, uut.ds.zl[2].pl[2].da.bthBC, uut.ds.zl[2].pl[2].da.bthCD, uut.ds.zl[2].pl[2].da.vmask);
					if (uut.ds.zl[3].pl[0].da.vmask)
						$fwrite(sim_out, "z: %d pat: %d  min th deltas: %d %d %d  vmask: %b\n",
								3, 0,	uut.ds.zl[3].pl[0].da.bthAB, uut.ds.zl[3].pl[0].da.bthBC, uut.ds.zl[3].pl[0].da.bthCD, uut.ds.zl[3].pl[0].da.vmask);
					if (uut.ds.zl[3].pl[1].da.vmask)
						$fwrite(sim_out, "z: %d pat: %d  min th deltas: %d %d %d  vmask: %b\n",
								3, 1,	uut.ds.zl[3].pl[1].da.bthAB, uut.ds.zl[3].pl[1].da.bthBC, uut.ds.zl[3].pl[1].da.bthCD, uut.ds.zl[3].pl[1].da.vmask);
					if (uut.ds.zl[3].pl[2].da.vmask)
						$fwrite(sim_out, "z: %d pat: %d  min th deltas: %d %d %d  vmask: %b\n",
								3, 2,	uut.ds.zl[3].pl[2].da.bthAB, uut.ds.zl[3].pl[2].da.bthBC, uut.ds.zl[3].pl[2].da.bthCD, uut.ds.zl[3].pl[2].da.vmask);
 -----/\----- EXCLUDED -----/\----- */
					
/* -----\/----- EXCLUDED -----\/-----
					for (iz = 0; iz < 4; iz = iz+1)
						for (ist = 0; ist < 3; ist = ist + 1)
							if (uut.ph_q[iz][ist] > 0)
								$fwrite(sim_out, "z: %d ph_num: %d ph_q: %h\n",
									   iz, uut.ph_num[iz][ist], uut.ph_q[iz][ist]);

					$fwrite(sim_out, "\n");

					$fwrite(sim_out, "mph: %h %h\n", uut.mphseg.ph_seg_v_z0_s1[2][0][0], uut.mphseg.ph_seg___z0_s1[2][0][0]);
					$fwrite(sim_out, "fs : %h %h\n", uut.mphseg.fs_loop[0].fs_03.ph_seg_v_p[2][0][0], uut.mphseg.fs_loop[0].fs_03.ph_seg_p[2][0][0]);
					$fwrite(sim_out, "fs : %h %h\n", uut.mphseg.fs_loop[0].fs_03.ph_pat_q_p, uut.mphseg.fs_loop[0].fs_03.ph_pat_p);
					
	input [bpow:0] ph_pat_p; // ph detected in pattern
	input 		   ph_pat_v_p; // pattern valid
	input [bw_fph-1:0] ph_seg_p [max_drift-1:0][zone_cham-1:0][seg_ch-1:0];
	// valid flags for segments
	input [seg_ch-1:0] ph_seg_v_p [max_drift-1:0][zone_cham-1:0];

					






					
//					$fwrite(sim_out, "ph_tmp: %h params[0]: %h\n", 
//						   uut.pcs.genblk.station[2].csc[0].pc.ph_tmp, uut.pcs.genblk.station[2].csc[0].pc.params[0]);
					
					for (ist = 0; ist < 5; ist=ist+1)
					begin
						
						for (icid = 0; icid < 9; icid=icid+1)
						begin

							for (iseg = 0; iseg < 2; iseg = iseg+1)
							begin
								$fwrite(sim_out, "station: %d ", ist);
								$fwrite(sim_out, "chamber: %d ", icid+1);
								$fwrite(sim_out, "seg: %d ", iseg+1);
								
								if (ist < 2 && icid < 3)
									$fwrite(sim_out, "%h %h %h %h %h\n", ph[ist][icid][iseg], th11[ist][icid][iseg*2], th11[ist][icid][iseg*2+1], 
										   me11a[ist][icid][iseg], vl[ist][icid][iseg]);
								else
									$fwrite(sim_out, "%h %h %h\n", ph[ist][icid][iseg], th[ist][icid][iseg],  
										   vl[ist][icid][iseg]);
							end
						end
						$fwrite(sim_out, "\n");
					end



					end_time = $time;
					elapsed_time = elapsed_time + (end_time - begin_time);

					for (ist = 0; ist < 5; ist=ist+1)
					begin
						$fwrite(sim_out, "qd[0]: ");
						for (icid = 0; icid < 9; icid=icid+1)
							$fwrite(sim_out, "%d %d  ", uut.qd[ist][0][icid][0], uut.qd[ist][0][icid][1]);
						$fwrite(sim_out, "\n");
					end
					$fwrite(sim_out, "\n");

					for (ist = 0; ist < 5; ist=ist+1)
					begin
						$fwrite(sim_out, "wgd[0]: ");
						for (icid = 0; icid < 9; icid=icid+1)
							$fwrite(sim_out, "%d %d  ", uut.wgd[ist][0][icid][0], uut.wgd[ist][0][icid][1]);
						$fwrite(sim_out, "\n");
					end
					$fwrite(sim_out, "\n");

					for (ist = 0; ist < 5; ist=ist+1)
					begin
						$fwrite(sim_out, "hstrd[0]: ");
						for (icid = 0; icid < 9; icid=icid+1)
							$fwrite(sim_out, "%d %d  ", uut.hstrd[ist][0][icid][0], uut.hstrd[ist][0][icid][1]);
						$fwrite(sim_out, "\n");
					end
					$fwrite(sim_out, "\n");

					$fwrite(sim_out, "event: %d  good_ev_cnt: %d\n", ev, good_ev_cnt);
					$fwrite(sim_out, "station count: %d\n", st_cnt);

					for (ist = 0; ist < 2; ist=ist+1)
					begin
						$fwrite(sim_out, "me11a[0]: ");
						for (icid = 0; icid < 3; icid=icid+1)
							$fwrite(sim_out, "%d %d  ", uut.me11ad[0][ist][icid][0], uut.me11ad[0][ist][icid][1]);
						//							$fwrite(sim_out, "%d %d  ", uut.me11a[ist][icid][0], uut.me11a[ist][icid][1]);
						$fwrite(sim_out, "\n");
					end
					
					for (ist = 0; ist < 5; ist=ist+1)
					begin
						$fwrite(sim_out, "ph[1]: ");
						for (icid = 0; icid < 9; icid=icid+1)
							$fwrite(sim_out, "%d %d  ", uut.phd[1][ist][icid][0], uut.phd[1][ist][icid][1]);
						$fwrite(sim_out, "th[1]: ");
						for (icid = 0; icid < 9; icid=icid+1)
						begin
							if (ist < 2 && icid < 3)
								$fwrite(sim_out, "%d %d  ", uut.th11d[1][ist][icid][0], uut.th11d[1][ist][icid][1]);
							else
								$fwrite(sim_out, "%d %d  ", uut.thd[1][ist][icid][0], uut.thd[1][ist][icid][1]);
						end
						$fwrite(sim_out, "\n");
					end
					$fwrite(sim_out, "\n");

					for (ist = 0; ist < 2; ist=ist+1)
					begin
						$fwrite(sim_out, "me11a[1]: ");
						for (icid = 0; icid < 3; icid=icid+1)
							$fwrite(sim_out, "%d %d  ", uut.me11ad[1][ist][icid][0], uut.me11ad[1][ist][icid][1]);
						$fwrite(sim_out, "\n");
					end
					
					for (ist = 0; ist < 5; ist=ist+1)
					begin
						$fwrite(sim_out, "ph[2]: ");
						for (icid = 0; icid < 9; icid=icid+1)
							$fwrite(sim_out, "%d %d  ", uut.phd[2][ist][icid][0], uut.phd[2][ist][icid][1]);
						$fwrite(sim_out, "th[2]: ");
						for (icid = 0; icid < 9; icid=icid+1)
						begin
							if (ist < 2 && icid < 3)
								$fwrite(sim_out, "%d %d  ", uut.th11d[2][ist][icid][0], uut.th11d[2][ist][icid][1]);
							else
								$fwrite(sim_out, "%d %d  ", uut.thd[2][ist][icid][0], uut.thd[2][ist][icid][1]);
						end
						$fwrite(sim_out, "\n");
					end
					$fwrite(sim_out, "\n");
					//				$fwrite(sim_out, "ph_zone[2][1]: \n%h\n%h\n%h\n", uut.zns.ph_zone[2][1], uut.ph_zone[2][1], ph_zone[2][1]);

					for (ist = 0; ist < 2; ist=ist+1)
					begin
						$fwrite(sim_out, "me11a[2]: ");
						for (icid = 0; icid < 3; icid=icid+1)
							$fwrite(sim_out, "%d %d  ", uut.me11ad[2][ist][icid][0], uut.me11ad[2][ist][icid][1]);
						$fwrite(sim_out, "\n");
					end
					
					

		    		$fwrite(sim_out, "ph zone valid flags\n");
					for (ist = 0; ist < 5; ist=ist+1)
					begin
						$fwrite(sim_out, "phzvl: ");
						for (icid = 0; icid < 9; icid=icid+1)
							$fwrite(sim_out, "%b ", uut.phzvl[ist][icid]);
						$fwrite(sim_out, "\n");
					end

					$fwrite(sim_out, "\n");
					$fwrite(sim_out, "ph zones:\n");
					for (iz = 0; iz < 4; iz = iz+1)
					begin
						for (ist = 1; ist <= 4; ist = ist + 1)
						begin
							$fwrite(sim_out, "%h\n", uut.ph_ext[iz][ist]);
						end
						$fwrite(sim_out, "\n");
					end
 -----/\----- EXCLUDED -----/\----- */


					/*
					 * $fwrite(sim_out, "th zones:\n");
					 for (iz = 0; iz < 6; iz = iz+1)
					 begin
					 for (ist = 1; ist <= 4; ist = ist + 1)
					 begin
					 $fwrite(sim_out, "%h\n", uut.th_ext[iz][ist]);
						end
					 $fwrite(sim_out, "\n");
					end
					 */

//					$fwrite(sim_out, "th_hito[2][8]: %h\n", uut.th_hito[2][8]);
					
					/*
					 $fwrite(sim_out, "th zones padded:\n");
					 for (iz = 0; iz < 6; iz = iz+1)
					 begin
					 $fwrite(sim_out, "%b\n", uut.thps.stp[iz][0]);
					 $fwrite(sim_out, "   %b\n", uut.thps.st [iz][2]);
					 $fwrite(sim_out, "%b\n", uut.thps.stp[iz][1]);
					 $fwrite(sim_out, "%b\n", uut.thps.stp[iz][2]);
					 $fwrite(sim_out, "\n");
				end


					 $fwrite(sim_out, "%b\n   %b\n%b\n%b     %d %d %b\n", 
					 uut.thps.gb.th_pat_zone[2].th_pat_hit[49].thp.p1,  
					 uut.thps.gb.th_pat_zone[2].th_pat_hit[49].thp.st2,  
					 uut.thps.gb.th_pat_zone[2].th_pat_hit[49].thp.p3,  
					 uut.thps.gb.th_pat_zone[2].th_pat_hit[49].thp.p4, 
					 uut.thps.gb.th_pat_zone[2].th_pat_hit[49].thp.bx[0][0],
					 uut.thps.gb.th_pat_zone[2].th_pat_hit[49].thp.bx[1][0],
					 uut.thps.gb.th_pat_zone[2].th_pat_hit[49].thp.lyhits);
					 */				
					//				$fwrite(sim_out, "bx: %d drifftime: %d\n", uut.phps.gb.ph_pat_zone[0].ph_pat_hit[12].php.bx[1][0], uut.phps.gb.ph_pat_zone[0].ph_pat_hit[12].php.drifttime);

					

					
/* -----\/----- EXCLUDED -----\/-----
					$fwrite(sim_out, "th qualities and patterns:\n");
					for (iz = 0; iz < 6; iz = iz+1)
					begin
						for (ist = th_raw_w; ist > 0; ist = ist - 1)
						begin
							if (uut.th_rank[iz][ist-1] > 0)
								$fwrite(sim_out, "z: %d th: %d q: %h\n", iz, ist, uut.th_rank[iz][ist-1]);
						end
					end
					

					$fwrite(sim_out, "ph sorting results\n");
					for (iz = 0; iz < 4; iz = iz+1)
					begin
						for (ir = 0; ir < 3; ir = ir+1)
						begin
							if (uut.ph_q[iz][ir] > 0)
								$fwrite(sim_out, "z: %d r: %d ph_num: %d ph_q: %h\n", iz, ir, uut.ph_num[iz][ir], uut.ph_q[iz][ir]);
						end
					end

					$fwrite(sim_out, "th sorting results\n");
					for (iz = 0; iz < 6; iz = iz+1)
					begin
						for (ir = 0; ir < 3; ir = ir+1)
						begin
							if (uut.th_q[iz][ir] > 0)
								$fwrite(sim_out, "z: %d r: %d th_num: %d th_q: %h\n", iz, ir, uut.th_num[iz][ir], uut.th_q[iz][ir]);
						end
					end
					
					
					$fwrite(sim_out, "track candidates\n");
					for (iz = 0; iz < 4; iz = iz+1)	for (ir = 0; ir < 3; ir = ir+1)	
					begin
						$fwrite(sim_out, " %h ", uut.tc_q[iz][ir]);
						if (uut.tc_q[iz][ir] > 0) found_cand = found_cand+1;
					end
					$fwrite(sim_out, "\n");
					for (iz = 0; iz < 4; iz = iz+1)	for (ir = 0; ir < 3; ir = ir+1)	$fwrite(sim_out, "%d ", uut.tc_ph[iz][ir]);
					$fwrite(sim_out, "\n");
					for (iz = 0; iz < 4; iz = iz+1)	for (ir = 0; ir < 3; ir = ir+1)	$fwrite(sim_out, "%d ", uut.tc_th[iz][ir]);
					$fwrite(sim_out, "\n");
					for (iz = 0; iz < 4; iz = iz+1)	for (ir = 0; ir < 3; ir = ir+1)	$fwrite(sim_out, "  %d ", uut.tc_tz[iz][ir]);
					$fwrite(sim_out, "\n");
					
					for (st = 0; st < 5; st = st+1)
					begin
						$fwrite(sim_out, "ph segments for station %d\n", st);
						for (iz = 0; iz < 4; iz = iz+1)	for (ir = 0; ir < 3; ir = ir+1)	$fwrite(sim_out, "  %d ", uut.patt_ph_hi[iz][ir][st]);
						$fwrite(sim_out, "\n");
						for (iz = 0; iz < 4; iz = iz+1)	for (ir = 0; ir < 3; ir = ir+1)	$fwrite(sim_out, " %d ", uut.patt_ph_ch[iz][ir][st]);
						$fwrite(sim_out, "\n");
						for (iz = 0; iz < 4; iz = iz+1)	for (ir = 0; ir < 3; ir = ir+1)	$fwrite(sim_out, "  %d ", uut.patt_ph_si[iz][ir][st]);
						$fwrite(sim_out, "\n");
						$fwrite(sim_out, "th segments for station %d\n", st);
						for (iz = 0; iz < 4; iz = iz+1)	for (ir = 0; ir < 3; ir = ir+1)	$fwrite(sim_out, "  %d ", uut.patt_th_hi[iz][ir][st]);
						$fwrite(sim_out, "\n");
						for (iz = 0; iz < 4; iz = iz+1)	for (ir = 0; ir < 3; ir = ir+1)	$fwrite(sim_out, " %d ", uut.patt_th_ch[iz][ir][st]);
						$fwrite(sim_out, "\n");
						for (iz = 0; iz < 4; iz = iz+1)	for (ir = 0; ir < 3; ir = ir+1)	$fwrite(sim_out, "  %d ", uut.patt_th_si[iz][ir][st]);
						$fwrite(sim_out, "\n");
					end
					
					$fwrite(sim_out, "best tracks:\n  q  ph  th  phi eta    pt s md eP FR int_mode\n");
					for (ir = 0; ir < 3; ir = ir+1)	$fwrite(sim_out, " %d %d %d %d %d %d %d %d %d %d %d\n", 
															uut.bt_q[ir], uut.bt_ph[ir], uut.bt_th[ir],
															phi[ir], eta[ir], pt[ir], sign[ir], modeMem[ir],
															etaPT[ir], FR[ir], uut.pps.mode[ir]);

					if (modeMem[0] > 0)
					begin
						$fwrite(best_tracks, "%d %d %d %d\n", i, modeMem[0], modeMem[1], modeMem[2]);
					end

					if (modeMem[1] > 0) $fwrite(sim_out, "two or more tracks\n");
					$fwrite(sim_out, "best tracks - phi from stations compared to detected phi: \n");
					for (ir = 0; ir < 3; ir = ir+1)
					begin
						for (iz = 0; iz < 5; iz = iz+1) $fwrite(sim_out, "%d ", uut.pps.phi_av[ir][iz]);
						// print also best track reduced precision phi converted to full precision for comparison
						tphi = ((uut.bt_ph[ir] * 16 - 60) * 1101) / 1000; // - 1 deg and * scale factor
						$fwrite(sim_out, "    %d", tphi);
						// print pt output split into diffs
						if (modeMem[ir] <= 5 && modeMem[ir] >= 2) 
						begin
							// two differences
							a = 0;
							b = 0;
							{pts, b[7:4], a[8:1]} = pt[ir];
							$fwrite(sim_out, "  pts: %d  a: %d  b: %d", s, a, b);
						end
						else
							if (modeMem[ir] > 5) 
							begin
								// one difference
								{pts, d} = pt[ir];
								$fwrite(sim_out, "  pts: %d  d: %d", s, d);
							end
						
						$fwrite(sim_out, "\n");
					end
					/-*
					 $fwrite(sim_out, "best tracks - ph_tmp from stations: \n");
					 for (ir = 0; ir < 3; ir = ir+1)
					 begin
					     for (iz = 0; iz < 5; iz = iz+1) $fwrite(sim_out, "%d ", uut.pps.gb.best[ir].station[iz].prp.ph_tmp);
					     $fwrite(sim_out, "\n");
		             end
					 *-/
					for (st = 0; st < 5; st = st+1)
					begin
						$fwrite(sim_out, "ph segments for station %d\n", st);
						for (ir = 0; ir < 3; ir = ir+1)	$fwrite(sim_out, "  %d ", uut.bt_ph_hi[ir][st]);
						$fwrite(sim_out, "\n");
						for (ir = 0; ir < 3; ir = ir+1)	$fwrite(sim_out, " %d ", uut.bt_ph_ch[ir][st]);
						$fwrite(sim_out, "\n");
						for (ir = 0; ir < 3; ir = ir+1)	$fwrite(sim_out, "  %d ", uut.bt_ph_si[ir][st]);
						$fwrite(sim_out, "\n");
						$fwrite(sim_out, "th segments for station %d\n", st);
						for (ir = 0; ir < 3; ir = ir+1)	$fwrite(sim_out, "  %d ", uut.bt_th_hi[ir][st]);
						$fwrite(sim_out, "\n");
						for (ir = 0; ir < 3; ir = ir+1)	$fwrite(sim_out, " %d ", uut.bt_th_ch[ir][st]);
						$fwrite(sim_out, "\n");
						for (ir = 0; ir < 3; ir = ir+1)	$fwrite(sim_out, "  %d ", uut.bt_th_si[ir][st]);
						$fwrite(sim_out, "\n");
					end
					
					if (uut.bt_q[0] > 0) found_tr = found_tr+1;
					$fwrite(sim_out, "found candidates: %d  tracks: %d\n", found_cand, found_tr);
 -----/\----- EXCLUDED -----/\----- */
					
				end
			end

			$fwrite (sim_out, "elapsed_time: %t\n", elapsed_time);
			$fclose (best_tracks);
			$fclose (best_tracks_short);
			$fclose (sim_out);
			$fclose (nn_out);

		end

    
    integer it, jt;
    reg nn_input_val;
    integer true_mux[2:0] = '{2,0,1};
    always @(posedge uut.nn.clk_120)
    begin
        nn_input_val = 0;
        for (jt = 0; jt < 23; jt++) // input loop
        begin
            if (uut.nn.input1_V[jt] != 0) nn_input_val = 1; 
        end
        if (nn_input_val)
        begin

            $fwrite (nn_out, "mux: %1d ", true_mux[uut.nn.mux_phase]);
            for (jt = 0; jt < 23; jt++) // input loop
            begin
                $fwrite (nn_out, "%05h ", uut.nn.input1_V[jt]); 
            end
            $fwrite (nn_out, "\n");
        end
        $fflush (nn_out);
    end
/*    
    always @(posedge uut.nn.clk_120)
    begin
        // NN inputs
        if (nn_mode_r[0] != 0 || nn_mode_r[1] != 0 || nn_mode_r[2] != 0)
        begin
            $fwrite (nn_out, "ev: %4d track: %1d inputs: ", iev, mux_phase_print[uut.nn.mux_phase]);
//            $fwrite (nn_out, " rank: %h ph_deltas: %d %d %d %d %d %d th_deltas: %d %d %d %d %d %d phi: %d, theta: %d cpat: %d sign_ph: %d sign_th: %d\n", 
//                    bt_rank[ip], 
//                    bt_delta_ph[ip][0], bt_delta_ph[ip][1], bt_delta_ph[ip][2], bt_delta_ph[ip][3], bt_delta_ph[ip][4], bt_delta_ph[ip][5], 
//                    bt_delta_th[ip][0], bt_delta_th[ip][1], bt_delta_th[ip][2], bt_delta_th[ip][3], bt_delta_th[ip][4], bt_delta_th[ip][5], 
//                    bt_phi[ip], bt_theta[ip], bt_cpattern[ip][0], bt_sign_ph[ip], bt_sign_th[ip]
//                    );
            for (i = 0; i < 23; i++)
                $fwrite (nn_out, " %05x", uut.nn.input1_V[i]);
            $fwrite (nn_out, "\n");
            $fflush (nn_out);
        end
        
        nn_mode_r = uut.nn.mode;
     end
*/  
endmodule

