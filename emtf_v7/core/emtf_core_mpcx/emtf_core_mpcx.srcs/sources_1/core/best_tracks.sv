
//////////////////////////////////////////////////////////////////////////////////
// Company: UF
// Engineer: Madorsky
// 
// Create Date:    15:53:56 05/12/2010 
// Design Name: tf_slhc
// Module Name:    best_tracks 
// Project Name: tf_slhc
// Target Devices: V666
// Tool versions: 11.5
// Description: best track selector, selects best 3 out of 12 inputs
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
`include "vppc_macros.sv"

module best_tracks
(
     phi,
     theta,
     cpattern,
     delta_ph,
     delta_th,
     sign_ph,
     sign_th,
     rank,
	 vi, 
     hi, 
     ci, 
     si,

     bt_phi,
     bt_theta,
     bt_cpattern,
     bt_delta_ph,
     bt_delta_th,
     bt_sign_ph,
     bt_sign_th,
     bt_rank,
	 bt_vi, 
     bt_hi, 
     bt_ci, 
     bt_si,

     clk
);

`include "spbits.sv"
	// precise phi and theta of candidates
	// [zone][pattern_num]
	input [bw_fph-1:0] phi [3:0][2:0];
	input [bw_th-1:0]  theta [3:0][2:0];
	// [zone][pattern_num][station]
	input [3:0] 	   cpattern [3:0][2:0][3:0];
	// ph and th deltas from best stations
	// [zone][pattern_num], last index: 0=12, 1=13, 2=14, 3=23, 4=24, 5=34
	input [bw_fph-1:0] delta_ph [3:0][2:0][5:0];
	input [bw_th-1:0]  delta_th [3:0][2:0][5:0]; 
	input [5:0] 	   sign_ph[3:0][2:0];
	input [5:0] 	   sign_th[3:0][2:0];
	// updated ranks [zone][pattern_num]
	input [bwr:0] 	   rank [3:0][2:0];
	//[zone][pattern_num][station 0-3]
	input [seg_ch-1:0] vi [3:0][2:0][3:0]; // valid
	input [1:0] 	   hi [3:0][2:0][3:0]; // bx index
	input [2:0] 	   ci [3:0][2:0][3:0]; // chamber
	input [3:0] 	   si [3:0][2:0]; // segment
	
	// precise phi and theta of best tracks
	// [best_track_num]
	output reg [bw_fph-1:0] bt_phi [2:0];
	output reg [bw_th-1:0] 	bt_theta [2:0];
	// [best_track_num][station]
	output reg [3:0] 		bt_cpattern [2:0][3:0];
	// ph and th deltas from best stations
	// [best_track_num], last index: 0=12, 1=13, 2=14, 3=23, 4=24, 5=34
	output reg [bw_fph-1:0] bt_delta_ph [2:0][5:0];
	output reg [bw_th-1:0] 	bt_delta_th [2:0][5:0]; 
	output reg [5:0] 		bt_sign_ph[2:0];
	output reg [5:0] 		bt_sign_th[2:0];
	// ranks [best_track_num]
	output reg [bwr:0] 		bt_rank [2:0];
	//[best_track_num][station 0-3]
	output reg [seg_ch-1:0] bt_vi [2:0][4:0]; // valid
	output reg [1:0] 		bt_hi [2:0][4:0]; // bx index
	output reg [3:0] 		bt_ci [2:0][4:0]; // chamber
	output reg [4:0]		bt_si [2:0]; // segment
	
	input clk;

	// segment ids reformatted to chamber ids in sector
	//[zone][pattern_num][station 0-4]
	reg [seg_ch-1:0] cn_vi [3:0][2:0][4:0]; // valid
	reg [1:0] 		 cn_hi [3:0][2:0][4:0]; // bx index
	reg [3:0] 		 cn_ci [3:0][2:0][4:0]; // chamber
	reg  		     cn_si [3:0][2:0][4:0]; // segment


	`int bn, i, j;
	`int z, s, n;

	reg [35:0] larger [35:0];
	reg [6:0] ri, rj;
	reg [35:0] exists, kill1;
	reg [35:0] winner [2:0];
	reg gt, eq;
	reg [3:0] cham;
	reg [5:0] sum;
	reg [2:0] sh_segs;
   reg [6:0] 	  zone_to_meid_00 [127:0];
   reg [6:0] 	  zone_to_meid_01 [127:0];
   reg [6:0] 	  zone_to_meid_02 [127:0];
   reg [6:0] 	  zone_to_meid_03 [127:0];
   reg [6:0] 	  zone_to_meid_04 [127:0];
   reg [6:0] 	  zone_to_meid_05 [127:0];
   reg [6:0] 	  zone_to_meid_06 [127:0];
   reg [6:0] 	  zone_to_meid_07 [127:0];
   reg [6:0] 	  zone_to_meid_08 [127:0];
   reg [6:0] 	  zone_to_meid_09 [127:0];
   reg [6:0] 	  zone_to_meid_10 [127:0];
   reg [6:0] 	  zone_to_meid_11 [127:0];
   reg [6:0] 	  zone_to_meid_12 [127:0];
   reg [6:0] 	  zone_to_meid_13 [127:0];
   reg [6:0] 	  zone_to_meid_14 [127:0];
   reg [6:0] 	  zone_to_meid_15 [127:0];
   reg [6:0] 	  zone_to_meid_16 [127:0];
   reg [6:0] 	  zone_to_meid_17 [127:0];
   reg [6:0] 	  zone_to_meid_18 [127:0];
   reg [6:0] 	  zone_to_meid_19 [127:0];
   reg [6:0] 	  zone_to_meid_20 [127:0];
   reg [6:0] 	  zone_to_meid_21 [127:0];
   reg [6:0] 	  zone_to_meid_22 [127:0];
   reg [6:0] 	  zone_to_meid_23 [127:0];
   reg [6:0] 	  zone_to_meid_24 [127:0];
   reg [6:0] 	  zone_to_meid_25 [127:0];
   reg [6:0] 	  zone_to_meid_26 [127:0];
   reg [6:0] 	  zone_to_meid_27 [127:0];
   reg [6:0] 	  zone_to_meid_28 [127:0];
   reg [6:0] 	  zone_to_meid_29 [127:0];
   reg [6:0] 	  zone_to_meid_30 [127:0];
   reg [6:0] 	  zone_to_meid_31 [127:0];
   reg [6:0] 	  zone_to_meid_32 [127:0];
   reg [6:0] 	  zone_to_meid_33 [127:0];
   reg [6:0] 	  zone_to_meid_34 [127:0];
   reg [6:0] 	  zone_to_meid_35 [127:0];
   reg [6:0] 	  zone_to_meid_36 [127:0];
   reg [6:0] 	  zone_to_meid_37 [127:0];
   reg [6:0] 	  zone_to_meid_38 [127:0];
   reg [6:0] 	  zone_to_meid_39 [127:0];
   reg [6:0]      zone_to_meid_40 [127:0];
   reg [6:0] 	  zone_to_meid_41 [127:0];
   reg [6:0] 	  zone_to_meid_42 [127:0];
   reg [6:0] 	  zone_to_meid_43 [127:0];
   reg [6:0] 	  zone_to_meid_44 [127:0];
   reg [6:0] 	  zone_to_meid_45 [127:0];
   reg [6:0] 	  zone_to_meid_46 [127:0];
   reg [6:0] 	  zone_to_meid_47 [127:0];
   // [zone][pattern][station]
//	reg [6:0] zm_addr [3:0][2:0][3:0];
    reg [3:0] real_ch [3:0][2:0][3:0];
    reg [2:0] real_st [3:0][2:0][3:0];
    wire [6:0] lut_out [3:0][2:0][3:0];

	(* mark_debug = "FALSE" *) wire [seg_ch-1:0] vi_w [3:0][2:0][3:0]; // valid
	(* mark_debug = "FALSE" *) wire [1:0] 	   hi_w [3:0][2:0][3:0]; // bx index
	(* mark_debug = "FALSE" *) wire [2:0] 	   ci_w [3:0][2:0][3:0]; // chamber
	(* mark_debug = "FALSE" *) wire [3:0] 	   si_w [3:0][2:0]; // segment
	
   // [zone][pattern][station]
//	(* mark_debug = "FALSE" *) wire [6:0] zm_addr_w [3:0][2:0][3:0];
    (* mark_debug = "FALSE" *) wire [3:0] real_ch_w [3:0][2:0][3:0];
    (* mark_debug = "FALSE" *) wire [2:0] real_st_w [3:0][2:0][3:0];
    
    (* mark_debug = "FALSE" *) wire  [seg_ch-1:0] cn_vi_w [3:0][2:0][4:0]; // valid
    (* mark_debug = "FALSE" *) wire  [1:0]        cn_hi_w [3:0][2:0][4:0]; // bx index
    (* mark_debug = "FALSE" *) wire  [3:0]        cn_ci_w [3:0][2:0][4:0]; // chamber
    (* mark_debug = "FALSE" *) wire               cn_si_w [3:0][2:0][4:0]; // segment

	(* mark_debug = "FALSE" *) wire  [seg_ch-1:0] bt_vi_w [2:0][4:0]; // valid
	(* mark_debug = "FALSE" *) wire  [1:0] 		bt_hi_w [2:0][4:0]; // bx index
	(* mark_debug = "FALSE" *) wire  [3:0] 		bt_ci_w [2:0][4:0]; // chamber
	(* mark_debug = "FALSE" *) wire  [4:0]		bt_si_w [2:0]; // segment

    (* mark_debug = "FALSE" *) wire [6:0] lut_out_w [3:0][2:0][3:0];

   reg [bw_fph-1:0] phi_r [3:0][2:0];
   reg [bw_th-1:0] 	theta_r [3:0][2:0];
   reg [3:0] 		cpattern_r [3:0][2:0][3:0];
   reg [bw_fph-1:0] delta_ph_r [3:0][2:0][5:0];
   reg [bw_th-1:0] 	delta_th_r [3:0][2:0][5:0]; 
   reg [5:0] 		sign_ph_r[3:0][2:0];
   reg [5:0] 		sign_th_r[3:0][2:0];
   reg [bwr:0] 		rank_r [3:0][2:0];
   reg [seg_ch-1:0] cn_vi_r [3:0][2:0][4:0]; // valid
   reg [2:0] 		cn_hi_r [3:0][2:0][4:0]; // bx index
   reg [3:0] 		cn_ci_r [3:0][2:0][4:0]; // chamber
   reg 				cn_si_r [3:0][2:0][4:0]; // segment

   reg [bw_fph-1:0] phi_rr [3:0][2:0];
   reg [bw_th-1:0] 	theta_rr [3:0][2:0];
   reg [3:0] 		cpattern_rr [3:0][2:0][3:0];
   reg [bw_fph-1:0] delta_ph_rr [3:0][2:0][5:0];
   reg [bw_th-1:0] 	delta_th_rr [3:0][2:0][5:0]; 
   reg [5:0] 		sign_ph_rr[3:0][2:0];
   reg [5:0] 		sign_th_rr[3:0][2:0];
   reg [bwr:0] 		rank_rr [3:0][2:0];
   reg [seg_ch-1:0] cn_vi_rr [3:0][2:0][4:0]; // valid
   reg [2:0] 		cn_hi_rr [3:0][2:0][4:0]; // bx index
   reg [3:0] 		cn_ci_rr [3:0][2:0][4:0]; // chamber
   reg 				cn_si_rr [3:0][2:0][4:0]; // segment

   reg [seg_ch-1:0] cn_vi_i, cn_vi_j;
   reg [2:0] 		cn_hi_i, cn_hi_j;
   reg [3:0] 		cn_ci_i, cn_ci_j;
   reg 				cn_si_i, cn_si_j;

   reg [1:0] cand_bx [3:0][2:0];
   reg [1:0] cand_bx_r [3:0][2:0];
   reg [1:0] cand_bx_rr [3:0][2:0];
   reg [2:0] h1, h2;
   reg [35:0] good_bx;
   
    genvar gz, gn, gs;
    generate
		for (gz = 0; gz < 4; gz = gz+1) // zone loop
        begin: z1
            for (gn = 0; gn < 3; gn = gn+1) // pattern number
            begin: p1
                for (gs = 0; gs < 4; gs = gs+1) // station
                begin: s1
                    assign vi_w[gz][gn][gs] = vi[gz][gn][gs];
                    assign hi_w[gz][gn][gs] = hi[gz][gn][gs];
                    assign ci_w[gz][gn][gs] = ci[gz][gn][gs];

//                    assign zm_addr_w[gz][gn][gs] = zm_addr[gz][gn][gs];
                    assign real_ch_w[gz][gn][gs] = real_ch[gz][gn][gs];
                    assign real_st_w[gz][gn][gs] = real_st[gz][gn][gs];
                    assign lut_out_w[gz][gn][gs] = lut_out[gz][gn][gs];
                end
                assign si_w[gz][gn] = si[gz][gn];
            end
        end

		for (gz = 0; gz < 4; gz = gz+1) // zone loop
        begin: z2
            for (gn = 0; gn < 3; gn = gn+1) // pattern number
            begin: p2
                for (gs = 0; gs < 5; gs = gs+1) // station
                begin: s2
                    
                    assign cn_vi_w[gz][gn][gs] = cn_vi[gz][gn][gs];
                    assign cn_hi_w[gz][gn][gs] = cn_hi[gz][gn][gs];
                    assign cn_ci_w[gz][gn][gs] = cn_ci[gz][gn][gs];
                    assign cn_si_w[gz][gn][gs] = cn_si[gz][gn][gs];
                end
            end
        end
    
        for (gn = 0; gn < 3; gn = gn+1) // pattern number
        begin: p3
            for (gs = 0; gs < 5; gs = gs+1) // station
            begin: s3
                assign bt_vi_w[gn][gs] = bt_vi[gn][gs];
                assign bt_hi_w[gn][gs] = bt_hi[gn][gs];
                assign bt_ci_w[gn][gs] = bt_ci[gn][gs];
            end
            assign bt_si_w[gn] = bt_si[gn];
        end
	endgenerate
    
	
	// chamber ID transcoding LUT
	initial
	begin
	   // fill chamber ID transcoder LUT
	   // contents comes from chamber_ids_zones_to_stations.xlsx
	   $readmemh("zone_to_meid.mem", zone_to_meid_00);
	   $readmemh("zone_to_meid.mem", zone_to_meid_01);
	   $readmemh("zone_to_meid.mem", zone_to_meid_02);
	   $readmemh("zone_to_meid.mem", zone_to_meid_03);
	   $readmemh("zone_to_meid.mem", zone_to_meid_04);
	   $readmemh("zone_to_meid.mem", zone_to_meid_05);
	   $readmemh("zone_to_meid.mem", zone_to_meid_06);
	   $readmemh("zone_to_meid.mem", zone_to_meid_07);
	   $readmemh("zone_to_meid.mem", zone_to_meid_08);
	   $readmemh("zone_to_meid.mem", zone_to_meid_09);
	   $readmemh("zone_to_meid.mem", zone_to_meid_10);
	   $readmemh("zone_to_meid.mem", zone_to_meid_11);
	   $readmemh("zone_to_meid.mem", zone_to_meid_12);
	   $readmemh("zone_to_meid.mem", zone_to_meid_13);
	   $readmemh("zone_to_meid.mem", zone_to_meid_14);
	   $readmemh("zone_to_meid.mem", zone_to_meid_15);
	   $readmemh("zone_to_meid.mem", zone_to_meid_16);
	   $readmemh("zone_to_meid.mem", zone_to_meid_17);
	   $readmemh("zone_to_meid.mem", zone_to_meid_18);
	   $readmemh("zone_to_meid.mem", zone_to_meid_19);
	   $readmemh("zone_to_meid.mem", zone_to_meid_20);
	   $readmemh("zone_to_meid.mem", zone_to_meid_21);
	   $readmemh("zone_to_meid.mem", zone_to_meid_22);
	   $readmemh("zone_to_meid.mem", zone_to_meid_23);
	   $readmemh("zone_to_meid.mem", zone_to_meid_24);
	   $readmemh("zone_to_meid.mem", zone_to_meid_25);
	   $readmemh("zone_to_meid.mem", zone_to_meid_26);
	   $readmemh("zone_to_meid.mem", zone_to_meid_27);
	   $readmemh("zone_to_meid.mem", zone_to_meid_28);
	   $readmemh("zone_to_meid.mem", zone_to_meid_29);
	   $readmemh("zone_to_meid.mem", zone_to_meid_30);
	   $readmemh("zone_to_meid.mem", zone_to_meid_31);
	   $readmemh("zone_to_meid.mem", zone_to_meid_32);
	   $readmemh("zone_to_meid.mem", zone_to_meid_33);
	   $readmemh("zone_to_meid.mem", zone_to_meid_34);
	   $readmemh("zone_to_meid.mem", zone_to_meid_35);
	   $readmemh("zone_to_meid.mem", zone_to_meid_36);
	   $readmemh("zone_to_meid.mem", zone_to_meid_37);
	   $readmemh("zone_to_meid.mem", zone_to_meid_38);
	   $readmemh("zone_to_meid.mem", zone_to_meid_39);
	   $readmemh("zone_to_meid.mem", zone_to_meid_40);
	   $readmemh("zone_to_meid.mem", zone_to_meid_41);
	   $readmemh("zone_to_meid.mem", zone_to_meid_42);
	   $readmemh("zone_to_meid.mem", zone_to_meid_43);
	   $readmemh("zone_to_meid.mem", zone_to_meid_44);
	   $readmemh("zone_to_meid.mem", zone_to_meid_45);
	   $readmemh("zone_to_meid.mem", zone_to_meid_46);
	   $readmemh("zone_to_meid.mem", zone_to_meid_47);
	end

	    assign lut_out[0][0][0] = zone_to_meid_00[7'h0  | ci[0][0][0][2:0]];
        assign lut_out[0][0][1] = zone_to_meid_01[7'h8  | ci[0][0][1][2:0]];
        assign lut_out[0][0][2] = zone_to_meid_02[7'h10 | ci[0][0][2][2:0]];
        assign lut_out[0][0][3] = zone_to_meid_03[7'h18 | ci[0][0][3][2:0]];
        assign lut_out[0][1][0] = zone_to_meid_04[7'h0  | ci[0][1][0][2:0]];
        assign lut_out[0][1][1] = zone_to_meid_05[7'h8  | ci[0][1][1][2:0]];
        assign lut_out[0][1][2] = zone_to_meid_06[7'h10 | ci[0][1][2][2:0]];
        assign lut_out[0][1][3] = zone_to_meid_07[7'h18 | ci[0][1][3][2:0]];
        assign lut_out[0][2][0] = zone_to_meid_08[7'h0  | ci[0][2][0][2:0]];
        assign lut_out[0][2][1] = zone_to_meid_09[7'h8  | ci[0][2][1][2:0]];
        assign lut_out[0][2][2] = zone_to_meid_10[7'h10 | ci[0][2][2][2:0]];
        assign lut_out[0][2][3] = zone_to_meid_11[7'h18 | ci[0][2][3][2:0]];
        assign lut_out[1][0][0] = zone_to_meid_12[7'h20 | ci[1][0][0][2:0]];
        assign lut_out[1][0][1] = zone_to_meid_13[7'h28 | ci[1][0][1][2:0]];
        assign lut_out[1][0][2] = zone_to_meid_14[7'h30 | ci[1][0][2][2:0]];
        assign lut_out[1][0][3] = zone_to_meid_15[7'h38 | ci[1][0][3][2:0]];
        assign lut_out[1][1][0] = zone_to_meid_16[7'h20 | ci[1][1][0][2:0]];
        assign lut_out[1][1][1] = zone_to_meid_17[7'h28 | ci[1][1][1][2:0]];
        assign lut_out[1][1][2] = zone_to_meid_18[7'h30 | ci[1][1][2][2:0]];
        assign lut_out[1][1][3] = zone_to_meid_19[7'h38 | ci[1][1][3][2:0]];
        assign lut_out[1][2][0] = zone_to_meid_20[7'h20 | ci[1][2][0][2:0]];
        assign lut_out[1][2][1] = zone_to_meid_21[7'h28 | ci[1][2][1][2:0]];
        assign lut_out[1][2][2] = zone_to_meid_22[7'h30 | ci[1][2][2][2:0]];
        assign lut_out[1][2][3] = zone_to_meid_23[7'h38 | ci[1][2][3][2:0]];
        assign lut_out[2][0][0] = zone_to_meid_24[7'h40 | ci[2][0][0][2:0]];
        assign lut_out[2][0][1] = zone_to_meid_25[7'h48 | ci[2][0][1][2:0]];
        assign lut_out[2][0][2] = zone_to_meid_26[7'h50 | ci[2][0][2][2:0]];
        assign lut_out[2][0][3] = zone_to_meid_27[7'h58 | ci[2][0][3][2:0]];
        assign lut_out[2][1][0] = zone_to_meid_28[7'h40 | ci[2][1][0][2:0]];
        assign lut_out[2][1][1] = zone_to_meid_29[7'h48 | ci[2][1][1][2:0]];
        assign lut_out[2][1][2] = zone_to_meid_30[7'h50 | ci[2][1][2][2:0]];
        assign lut_out[2][1][3] = zone_to_meid_31[7'h58 | ci[2][1][3][2:0]];
        assign lut_out[2][2][0] = zone_to_meid_32[7'h40 | ci[2][2][0][2:0]];
        assign lut_out[2][2][1] = zone_to_meid_33[7'h48 | ci[2][2][1][2:0]];
        assign lut_out[2][2][2] = zone_to_meid_34[7'h50 | ci[2][2][2][2:0]];
        assign lut_out[2][2][3] = zone_to_meid_35[7'h58 | ci[2][2][3][2:0]];
        assign lut_out[3][0][0] = zone_to_meid_36[7'h60 | ci[3][0][0][2:0]];
        assign lut_out[3][0][1] = zone_to_meid_37[7'h68 | ci[3][0][1][2:0]];
        assign lut_out[3][0][2] = zone_to_meid_38[7'h70 | ci[3][0][2][2:0]];
        assign lut_out[3][0][3] = zone_to_meid_39[7'h78 | ci[3][0][3][2:0]];
        assign lut_out[3][1][0] = zone_to_meid_40[7'h60 | ci[3][1][0][2:0]];
        assign lut_out[3][1][1] = zone_to_meid_41[7'h68 | ci[3][1][1][2:0]];
        assign lut_out[3][1][2] = zone_to_meid_42[7'h70 | ci[3][1][2][2:0]];
        assign lut_out[3][1][3] = zone_to_meid_43[7'h78 | ci[3][1][3][2:0]];
        assign lut_out[3][2][0] = zone_to_meid_44[7'h60 | ci[3][2][0][2:0]];
        assign lut_out[3][2][1] = zone_to_meid_45[7'h68 | ci[3][2][1][2:0]];
        assign lut_out[3][2][2] = zone_to_meid_46[7'h70 | ci[3][2][2][2:0]];
        assign lut_out[3][2][3] = zone_to_meid_47[7'h78 | ci[3][2][3][2:0]];
	
	
	always @(posedge clk)
	begin

		// zero segment numbers
		for (z = 0; z < 4; z = z+1) // zone loop
		begin
			for (n = 0; n < 3; n = n+1) // pattern number
			begin
				for (s = 0; s < 5; s = s+1) // station
				begin
					cn_vi[z][n][s] = 0;
					cn_hi[z][n][s] = 0;
					cn_si[z][n][s] = 0;
					cn_ci[z][n][s] = 0;
				end
			end
		end
		
		// calculate real station and chamber numbers

		
		// input segment numbers are in terms of chambers in zone
		// convert them back into chamber ids in sector
		for (z = 0; z < 4; z = z+1) // zone loop
		begin
			for (n = 0; n < 3; n = n+1) // pattern number
			begin
			   h2 = 3'h0;
			   h1 = 3'h0;
				for (s = 0; s < 4; s = s+1) // station
				begin
				    					
					real_st[z][n][s] = lut_out[z][n][s][6:4]; 
					real_ch[z][n][s] = lut_out[z][n][s][3:0];
					
					cn_vi[z][n][real_st[z][n][s]] = vi[z][n][s];
					cn_hi[z][n][real_st[z][n][s]] = hi[z][n][s];
					cn_si[z][n][real_st[z][n][s]] = si[z][n][s];
					cn_ci[z][n][real_st[z][n][s]] = real_ch[z][n][s];

				    // analyze stub delays, use each track only at the time of second-earliest stub
				   if (vi[z][n][s])
				   begin
					  if (hi[z][n][s] == 2'd2) h2 = h2 + 3'h1; // count stubs delayed by 2 BX
					  if (hi[z][n][s] >= 2'd1) h1 = h1 + 3'h1; // count stubs delayed by 1 BX or more
				   end
				end // for (s = 0; s < 4; s = s+1)

			   // determine proper BX for this track
			   if (h2 >= 3'h2) cand_bx[z][n] = 2'd0; // two stubs in earliest BX, analyze immediately
			   else if (h1 >= 3'h2) cand_bx[z][n] = 2'd1; // second-earliest stub one BX late
			   else cand_bx[z][n] = 2'd2; // second-earliest stub two BXs late
			end
		end
	
	   
	
		// zero outputs initially
		for (n = 0; n < 3; n = n+1)
		begin
			winner[n] = 0;
			bt_rank [n] = 0;
			bt_phi[n] = 0;
			bt_theta[n] = 0;
			for (s = 0; s < 4; s = s+1) // station loop
			    bt_cpattern[n][s] = 0;
			    
			for (s = 0; s < 6; s = s+1) // delta loop
			begin
				bt_delta_ph [n][s] = 0;
				bt_sign_ph  [n][s] = 0; 
				bt_delta_th [n][s] = 0; 
				bt_sign_th  [n][s] = 0; 
			end
			
			for (s = 0; s < 5; s = s+1) // station loop
			begin
				bt_vi[n][s] = 0;
				bt_hi[n][s] = 0;
				bt_si[n][s] = 0;
				bt_ci[n][s] = 0;
			end
		end
	
		for (i = 0; i < 36; i = i+1)
		begin
			larger[i] = 0;
		end

	   good_bx = 36'h0;
	   
		// simultaneously compare each rank with each
		for (i = 0; i < 36; i = i+1)
		begin
//			larger[i] = 0;
			larger[i][i] = 1; // result of comparison with itself
		   // first index loops zone, second loops candidate. Zone loops faster, so we give equal priority to zones
		    if      (i <  12)
			begin
			   ri = rank  [i%4][i/4];
			   if (cand_bx[i%4][i/4] == 2'h0 ) good_bx[i] = 1'b1; // kill this rank if it's not the right BX
			end
		    else if (i >= 24)
		    begin
			   ri = rank_rr  [(i-24)%4][(i-24)/4];
			   if (cand_bx_rr[(i-24)%4][(i-24)/4] == 2'h2 ) good_bx[i] = 1'b1; // kill this rank if it's not the right BX
		    end
		    else
			begin
               ri = rank_r  [(i-12)%4][(i-12)/4];
			   if (cand_bx_r[(i-12)%4][(i-12)/4] == 2'h1 ) good_bx[i] = 1'b1; // kill this rank if it's not the right BX
			end

			for (j = i+1; j < 36; j = j+1)
			begin
		       if      (j <  12) rj = rank  [j%4][j/4];
		       else if (j >= 24) rj = rank_rr [(j-24)%4][(j-24)/4];
		       else				 rj = rank_r  [(j-12)%4][(j-12)/4];

			   // compare ranks
				if (ri >= rj) larger[i][j] = 1;
 			    else          larger[j][i] = 1;
			end
			// "larger" array shows the result of comparison for each rank

			// track exists if quality != 0 
			exists[i] = (ri != 0);
		end

		// ghost cancellation, over 3 BXs
		kill1 = 0;
		
		for (i = 0; i < 36; i = i+1) // candidate loop
		begin
			  for (j = i+1; j < 36; j = j+1) // comparison candidate loop
			  begin
				 sh_segs = 0;
				 // count shared segments

				 for (s = 0; s < 5; s = s+1) // station loop
				 begin
					if (i < 12)
		   			begin
					   cn_vi_i = cn_vi[i%4][i/4][s]; 
					   cn_ci_i = cn_ci[i%4][i/4][s]; 
					   cn_si_i = cn_si[i%4][i/4][s]; 
					   cn_hi_i = cn_hi[i%4][i/4][s]; 
					end
					else if (i >= 24)
					begin
					   cn_vi_i = cn_vi_rr[(i-24)%4][(i-24)/4][s]; 
					   cn_ci_i = cn_ci_rr[(i-24)%4][(i-24)/4][s]; 
					   cn_si_i = cn_si_rr[(i-24)%4][(i-24)/4][s]; 
					   cn_hi_i = cn_hi_rr[(i-24)%4][(i-24)/4][s]; 
					end
					else
					begin
					   cn_vi_i = cn_vi_r[(i-12)%4][(i-12)/4][s]; 
					   cn_ci_i = cn_ci_r[(i-12)%4][(i-12)/4][s]; 
					   cn_si_i = cn_si_r[(i-12)%4][(i-12)/4][s]; 
					   cn_hi_i = cn_hi_r[(i-12)%4][(i-12)/4][s]; 
					end

					if (j < 12)
					begin
					   cn_vi_j = cn_vi[j%4][j/4][s]; 
					   cn_ci_j = cn_ci[j%4][j/4][s]; 
					   cn_si_j = cn_si[j%4][j/4][s]; 
					   cn_hi_j = cn_hi[j%4][j/4][s]; 
					end
					else if (j >= 24)
					begin
					   cn_vi_j = cn_vi_rr[(j-24)%4][(j-24)/4][s]; 
					   cn_ci_j = cn_ci_rr[(j-24)%4][(j-24)/4][s]; 
					   cn_si_j = cn_si_rr[(j-24)%4][(j-24)/4][s]; 
					   cn_hi_j = cn_hi_rr[(j-24)%4][(j-24)/4][s]; 
					end
					else
					begin
					   cn_vi_j = cn_vi_r[(j-12)%4][(j-12)/4][s]; 
					   cn_ci_j = cn_ci_r[(j-12)%4][(j-12)/4][s]; 
					   cn_si_j = cn_si_r[(j-12)%4][(j-12)/4][s]; 
					   cn_hi_j = cn_hi_r[(j-12)%4][(j-12)/4][s]; 
					end
			   
					if (cn_vi_i && cn_vi_j && // both segments valid
						cn_ci_i == cn_ci_j && // from same chamber
						cn_si_i == cn_si_j && // same segment
						cn_hi_i == cn_hi_j // same delay
						) 
					  sh_segs = sh_segs + 3'b1; // increment shared segment counter
				 end // for (s = 0; s < 5; s = s+1)

				 if (sh_segs > 0) // a single shared segment means it's ghost
				 begin
					// kill candidate that has lower rank
					if (larger[i][j]) kill1[j] = 1;
					else kill1[i] = 1;
				 end
			  end // for (j = i+1; j < 36; j = j+1)
		   
		end // for (i = 0; i < 36; i = i+1)
	   
		// remove ghosts according to kill mask
		exists = exists & (~kill1);

	    // remove tracks that are not at correct BX number
	    exists = exists & good_bx;
	   
		for (i = 0; i < 36; i = i+1)
		begin
			if  (exists[i]) larger[i] = larger[i] | (~exists); // if this track exists make it larger than all non-existing tracks
			else  larger[i] = 0; // else make it smaller than anything

			// count zeros in the comparison results. The best track will have none, the next will have one, the third will have two.
			sum = 0;
			for (j = 0; j < 36; j = j+1) if (larger[i][j] == 0) sum = sum + 1; 
			
			if (sum < 3) winner[sum][i] = 1; // assign positional winner codes
		end
	
		// multiplex best tracks to outputs according to winner signals
		for (n = 0; n < 3; n = n+1) // output loop
		begin
			for (i = 0; i < 12; i = i+1) // winner bit loop
			begin
				if (winner[n][i])
				begin
					bt_rank [n] = bt_rank [n] | rank [i%4][i/4];
					bt_phi[n]   = bt_phi[n]   | phi[i%4][i/4];
					bt_theta[n] = bt_theta[n] | theta[i%4][i/4];
					
					for (s = 0; s < 4; s = s+1) // station loop
					begin
					   bt_cpattern[n][s] = bt_cpattern[n][s] | cpattern[i%4][i/4][s];
					end
					
					for (s = 0; s < 6; s = s+1) // delta loop
					begin
						bt_delta_ph [n][s] = bt_delta_ph [n][s] | delta_ph [i%4][i/4][s];
						bt_sign_ph  [n][s] = bt_sign_ph  [n][s] | sign_ph  [i%4][i/4][s];
						bt_delta_th [n][s] = bt_delta_th [n][s] | delta_th [i%4][i/4][s];
						bt_sign_th  [n][s] = bt_sign_th  [n][s] | sign_th  [i%4][i/4][s];
					end
					
					for (s = 0; s < 5; s = s+1) // station loop
					begin
						bt_vi[n][s] = bt_vi[n][s] | cn_vi[i%4][i/4][s];
						bt_hi[n][s] = bt_hi[n][s] | cn_hi[i%4][i/4][s];
						bt_ci[n][s] = bt_ci[n][s] | cn_ci[i%4][i/4][s];
						bt_si[n][s] = bt_si[n][s] | cn_si[i%4][i/4][s];
					end              
				end
			end
			for (i = 0; i < 12; i = i+1) // winner bit loop
			begin
				if (winner[n][i+12])
				begin
					bt_rank [n] = bt_rank [n] | rank_r [i%4][i/4];
					bt_phi[n]   = bt_phi[n]   | phi_r[i%4][i/4];
					bt_theta[n] = bt_theta[n] | theta_r[i%4][i/4];
					
					for (s = 0; s < 4; s = s+1) // station loop
					begin
					   bt_cpattern[n][s] = bt_cpattern[n][s] | cpattern_r[i%4][i/4][s];
					end
					
					for (s = 0; s < 6; s = s+1) // delta loop
					begin
						bt_delta_ph [n][s] = bt_delta_ph [n][s] | delta_ph_r [i%4][i/4][s];
						bt_sign_ph  [n][s] = bt_sign_ph  [n][s] | sign_ph_r  [i%4][i/4][s];
						bt_delta_th [n][s] = bt_delta_th [n][s] | delta_th_r [i%4][i/4][s];
						bt_sign_th  [n][s] = bt_sign_th  [n][s] | sign_th_r  [i%4][i/4][s];
					end
					
					for (s = 0; s < 5; s = s+1) // station loop
					begin
						bt_vi[n][s] = bt_vi[n][s] | cn_vi_r[i%4][i/4][s];
						bt_hi[n][s] = bt_hi[n][s] | (cn_hi_r[i%4][i/4][s] - 3'h1); // correct stub delay back to original value
						bt_ci[n][s] = bt_ci[n][s] | cn_ci_r[i%4][i/4][s];
						bt_si[n][s] = bt_si[n][s] | cn_si_r[i%4][i/4][s];
					end              
				end
			end
			for (i = 0; i < 12; i = i+1) // winner bit loop
			begin
				if (winner[n][i+24])
				begin
					bt_rank [n] = bt_rank [n] | rank_rr [i%4][i/4];
					bt_phi[n]   = bt_phi[n]   | phi_rr[i%4][i/4];
					bt_theta[n] = bt_theta[n] | theta_rr[i%4][i/4];
					
					for (s = 0; s < 4; s = s+1) // station loop
					begin
					   bt_cpattern[n][s] = bt_cpattern[n][s] | cpattern_rr[i%4][i/4][s];
					end
					
					for (s = 0; s < 6; s = s+1) // delta loop
					begin
						bt_delta_ph [n][s] = bt_delta_ph [n][s] | delta_ph_rr [i%4][i/4][s];
						bt_sign_ph  [n][s] = bt_sign_ph  [n][s] | sign_ph_rr  [i%4][i/4][s];
						bt_delta_th [n][s] = bt_delta_th [n][s] | delta_th_rr [i%4][i/4][s];
						bt_sign_th  [n][s] = bt_sign_th  [n][s] | sign_th_rr  [i%4][i/4][s];
					end
					
					for (s = 0; s < 5; s = s+1) // station loop
					begin
						bt_vi[n][s] = bt_vi[n][s] | cn_vi_rr[i%4][i/4][s];
						bt_hi[n][s] = bt_hi[n][s] | (cn_hi_rr[i%4][i/4][s] - 3'h2); // correct stub delay back to original value
						bt_ci[n][s] = bt_ci[n][s] | cn_ci_rr[i%4][i/4][s];
						bt_si[n][s] = bt_si[n][s] | cn_si_rr[i%4][i/4][s];
					end              
				end
			end
		end

	   // keep two-clk history of all inputs
       phi_rr = 	    phi_r; 	  
       theta_rr =  	theta_r;  
       cpattern_rr =   cpattern_r; 
       delta_ph_rr =   delta_ph_r; 
       delta_th_rr =   delta_th_r; 
       sign_ph_rr = 	sign_ph_r;
       sign_th_rr = 	sign_th_r;
       rank_rr =   	rank_r;
	   cn_vi_rr =  	cn_vi_r; 
       cn_ci_rr =  	cn_ci_r;	  
       cn_si_rr =      cn_si_r;
	   cand_bx_rr = cand_bx_r;

       phi_r = 	    phi; 	  
       theta_r =  	theta;  
       cpattern_r =   cpattern; 
       delta_ph_r =   delta_ph; 
       delta_th_r =   delta_th; 
       sign_ph_r = 	sign_ph;
       sign_th_r = 	sign_th;
       rank_r =   	rank;
	   cn_vi_r =  	cn_vi; 
       cn_ci_r =  	cn_ci;	  
       cn_si_r =      cn_si;  
	   cand_bx_r = cand_bx;

	   // history of delays for each stub
		for (z = 0; z < 4; z = z+1) // zone loop
		begin
			for (n = 0; n < 3; n = n+1) // pattern number
			begin
				for (s = 0; s < 5; s = s+1) // station
				begin
				   // increase delay of each stub to show by how much it was delayed in total
				   cn_hi_rr[z][n][s] = cn_hi_r [z][n][s] + 3'd1; 
				   cn_hi_r [z][n][s] = cn_hi   [z][n][s] + 3'd1;	  
				end
			end
		end

	   
	end

endmodule
