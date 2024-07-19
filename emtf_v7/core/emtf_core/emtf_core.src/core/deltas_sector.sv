`include "vppc_macros.sv"

module deltas_sector
(
	 vi, hi, ci, si,
	 ph_match,
	 th_match,
     cpat_match,
     ph_q,
     th_window,
     th_window_z0,
     two_st_tight_timing,

     phi,
     theta,
     cpattern,
     delta_ph,
     delta_th,
     sign_ph,
     sign_th,
     rank,
     vir, hir, cir, sir,
     clk
);
`include "spbits.sv"
	`param me11 = 0;
	`localpar seg1 = me11 ? th_ch11 : seg_ch; // number of segments station 1
	
	//[zone][pattern_num][station 0-3]
	input [seg_ch-1:0] vi [3:0][2:0][3:0]; // valid
	input [1:0] 	   hi [3:0][2:0][3:0]; // bx index
	input [2:0] 	   ci [3:0][2:0][3:0]; // chamber
	input [3:0] 	   si [3:0][2:0]; // segment
	input [bw_fph-1:0] ph_match [3:0][2:0][3:0]; // matching ph
	input [bw_th-1:0]  th_match   [3:0][2:0][3:0][seg_ch-1:0]; // matching th, 2 segments 
	input [3:0] 	   cpat_match [3:0][2:0][3:0]; // matching pattern
	// best ranks [zone][num]
	input [bwr-1:0]    ph_q [3:0][2:0];
	
	input [bw_th-1:0]  th_window; // max th diff
	input [bw_th-1:0]  th_window_z0; // max th diff for zone 0
	input two_st_tight_timing;

	// precise phi and theta of candidates
	// [zone][pattern_num]
	output [bw_fph-1:0] phi [3:0][2:0];
	output [bw_th-1:0] 	theta [3:0][2:0];
	// [zone][pattern_num][station]
	output [3:0] 		cpattern [3:0][2:0][3:0];
	// ph and th deltas from best stations
	// [zone][pattern_num], last index: 0=12, 1=13, 2=14, 3=23, 4=24, 5=34
	output [bw_fph-1:0] delta_ph [3:0][2:0][5:0];
	output [bw_th-1:0] 	delta_th [3:0][2:0][5:0]; 
	output [5:0] 		sign_ph[3:0][2:0];
	output [5:0] 		sign_th[3:0][2:0];
	// updated ranks [zone][pattern_num]
	output [bwr:0] 		rank [3:0][2:0];
	//[zone][pattern_num][station 0-3]
	output [seg_ch-1:0] vir [3:0][2:0][3:0]; // valid
	output [1:0] 		hir [3:0][2:0][3:0]; // bx index
	output [2:0] 		cir [3:0][2:0][3:0]; // chamber
	output [3:0] 		sir [3:0][2:0]; // segment
	
	input 				clk;

	wire [bw_th-1:0]  dummy [1:0][2:0][th_ch11-1:0];
	
	`genv i, j;
	generate
	begin: gb
		for (i = 0; i < 2; i = i+1) // zone loop
		begin: zl11
			for (j = 0; j < 3; j = j+1) // pattern loop
			begin: pl
				deltas #(.me11(0)) da // all stations now treated equally, per Jia Fu request 2016-10-18
				(
				 .vi (vi[i][j]), 
				 .hi (hi[i][j]), 
				 .ci (ci[i][j]), 
				 .si (si[i][j]),
				 .ph_match (ph_match[i][j]),
				 .th_match (th_match[i][j]),
				 .cpat_match (cpat_match[i][j]),
				 .ph_q (ph_q[i][j]),
				 .th_window ((i == 0) ? th_window_z0 : th_window), // use different window for zone 0, per Andrew 2018-4-30
				 .two_st_tight_timing (two_st_tight_timing),

				 .phi (phi[i][j]),
				 .theta (theta[i][j]),
				 .cpattern (cpattern[i][j]),
				 .delta_ph (delta_ph[i][j]),
				 .delta_th (delta_th[i][j]),
				 .sign_ph (sign_ph[i][j]),
				 .sign_th (sign_th[i][j]),
				 .rank(rank[i][j]),
				 .vir (vir[i][j]), 
				 .hir (hir[i][j]), 
				 .cir (cir[i][j]), 
				 .sir (sir[i][j]),
				 .clk (clk)
				 );
			end
		end
		
		for (i = 2; i < 4; i = i+1) // zone loop
		begin: zl
			for (j = 0; j < 3; j = j+1) // pattern loop
			begin: pl
				deltas #(.me11(0)) da
				(
				 .vi (vi[i][j]), 
				 .hi (hi[i][j]), 
				 .ci (ci[i][j]), 
				 .si (si[i][j]),
				 .ph_match (ph_match[i][j]),
				 .th_match (th_match[i][j]),
				 .cpat_match (cpat_match[i][j]),
				 .ph_q (ph_q[i][j]),
				 .th_window (th_window),
				 .two_st_tight_timing (two_st_tight_timing),

				 .phi (phi[i][j]),
				 .theta (theta[i][j]),
				 .cpattern (cpattern[i][j]),
				 .delta_ph (delta_ph[i][j]),
				 .delta_th (delta_th[i][j]),
				 .sign_ph (sign_ph[i][j]),
				 .sign_th (sign_th[i][j]),
				 .rank(rank[i][j]),
				 .vir (vir[i][j]), 
				 .hir (hir[i][j]), 
				 .cir (cir[i][j]), 
				 .sir (sir[i][j]),
				 .clk (clk)
				 );
			end
		end // block: zl
	end
	endgenerate

endmodule
