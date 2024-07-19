`include "vppc_macros.sv"

module find_segment
(
 ph_pat_p,
 ph_pat_q_p,
 ph_seg_p,
 ph_seg_v_p,
 th_seg_p,
 cpat_seg_p,
 vid,
 hid,
 cid,
 sid,
 ph_match,
 th_match,
 cpat_match,
 clk
);

`include "spbits.sv"
	`param zone_cham = 6; // 6 chambers in this zone and station
	`param zone_seg = 2; // segments per chamber in this zone and station

    // max phi difference between pattern and segment
    `localpar max_ph_diff = station == 1 ? 13'd496 : // width of pattern in ME1 + rounding error 15*32+16
  //                          station == 2 ? 13'd16 : // just rounding error for ME2 (pattern must match ME2 hit phi if there was one)
                            13'd240; // width of pattern in ME3,4 + rounding error 7*32+16
//    `localpar bw_phdiff = station == 1 ? 9 : station == 2 ? 5 : 8; // ph difference bit width
    `localpar bw_phdiff = station == 1 ? 9 : 8; // ph difference bit width
   
	`localpar tot_diff = max_drift*zone_cham*seg_ch;
	// sorter stages
	`localpar stage1 = tot_diff / 3 + 1; // 9 or 15
	`localpar stage2 = (stage1 == 9) ? 3 : 6;
	`localpar stage3 = stage2 / 3; // 1 or 2
//    `localpar nodiff = station == 1 ? 9'h1ff : station == 2 ? 5'h1f : 8'hff; // invalid difference
    `localpar nodiff = station == 1 ? 9'h1ff : 8'hff; // invalid difference
	
	// history order: (X, current, -1)
	// Sorting order in sw: (current, -1, X)
	localparam int sorting_bx_mapping[max_drift] = {1, 2, 0}; // {0,1,2}; to go back

	input [bpow:0] ph_pat_p; // ph detected in pattern
	input [5:0]	   ph_pat_q_p; // pattern valid
	// ph from segments [bx_history][chamber][segment]
	// segments are coming from chambers in the interesting zone only
	// for example, in zone 0 ME1 segments should come from chambers
	// subsector1: 1,2,3, subsector2: 1,2,3
	input [bw_fph-1:0] ph_seg_p [max_drift-1:0][zone_cham-1:0][seg_ch-1:0];
	// valid flags for segments
	input [seg_ch-1:0] ph_seg_v_p [max_drift-1:0][zone_cham-1:0];
	input [bw_th-1:0]  th_seg_p [max_drift-1:0][zone_cham-1:0][zone_seg-1:0]; // theta
	input [3:0] 	   cpat_seg_p [max_drift-1:0][zone_cham-1:0][seg_ch-1:0]; // patterns

	// indexes of best match
	output reg [seg_ch-1:0] vid; // match valid, each flag shows validity of th coord
	output reg [1:0]  hid; // history id
	output reg [2:0]  cid; // chamber id
	output reg 		  sid; // segment id
	output reg [bw_fph-1:0] ph_match; // ph from matching segment
	// all th's from matching chamber, we don't know which one will fit best
	// rework per Jia Fu request 2016-10-18
	output reg [bw_th-1:0] 	th_match [seg_ch-1:0]; 
	output reg [3:0] cpat_match; // pattern from matching segment

	input 			  clk;
	
	
	`int i,j,k,di;
	reg [bw_fph-1:0] ph_pat; // ph detected in pattern
	reg 		 ph_pat_v; // pattern valid
	reg [bw_fph-1:0] ph_seg [max_drift-1:0][zone_cham-1:0][seg_ch-1:0];
	reg [seg_ch-1:0] ph_seg_v [max_drift-1:0][zone_cham-1:0];
	reg [bw_th-1:0]  th_seg [max_drift-1:0][zone_cham-1:0][zone_seg-1:0];
	reg [3:0] 		 cpat_seg [max_drift-1:0][zone_cham-1:0][seg_ch-1:0];
    reg [bw_fph-1:0] ph_segr;
	reg [bw_fph-1:0] ph_diff_tmp;
	reg [bw_phdiff-1:0] ph_diff [tot_diff+3-1:0]; // create longer array here to provide padding for 3-input comparators
	reg [1:0] 	 rcomp;

	reg [5:0] 	 diffi0      [tot_diff+3-1:0]; // create longer array here to provide padding for 3-input comparators
	reg [bw_phdiff-1:0] cmp1 [stage1-1:0];
	reg [5:0] 	 diffi1      [stage1-1:0];
	reg [bw_phdiff-1:0] cmp2 [stage2-1:0];
	reg [5:0] 	 diffi2      [stage2-1:0];
	reg [bw_phdiff-1:0] cmp3 [stage3-1:0];
	reg [5:0] 	 diffi3      [stage3-1:0];
	reg [bw_phdiff-1:0] cmp4;
	reg [5:0] 	 diffi4;
	reg [1:0] 	 ri;
	reg [2:0] 	 rj;
	reg 		 rk;

//	(* mark_debug = "FALSE" *) wire [bpow:0] ph_pat_w = ph_pat; // ph detected in pattern
//	(* mark_debug = "FALSE" *) wire 		 ph_pat_v_w = ph_pat_v; // pattern valid
//	(* mark_debug = "FALSE" *) wire [bw_fph-1:0] ph_seg_w [max_drift-1:0][zone_cham-1:0][seg_ch-1:0];
//	(* mark_debug = "FALSE" *) wire [seg_ch-1:0] ph_seg_v_w [max_drift-1:0][zone_cham-1:0];
//	(* mark_debug = "FALSE" *) wire [bw_th-1:0]  th_seg_w [max_drift-1:0][zone_cham-1:0][zone_seg-1:0];

//    genvar gi, gj, gk;
//    generate
//        for (gi = 0; gi < max_drift; gi = gi+1)
//        begin
//            for (gj = 0; gj < zone_cham; gj = gj+1)
//            begin
//                assign ph_seg_v_w[gi][gj] = ph_seg_v[gi][gj]; 
//                for (gk = 0; gk < seg_ch; gk = gk+1)
//                begin
//                    assign ph_seg_w[gi][gj][gk] = ph_seg[gi][gj][gk]; 
//                end
//                for (gk = 0; gk < zone_seg; gk = gk+1)
//                begin
//                    assign th_seg_w[gi][gj][gk] = th_seg[gi][gj][gk]; 
//                end
//            end
//        end
//    endgenerate
	
	always @(posedge clk)
	begin
		ph_pat = {ph_pat_p, 5'h0}; // add missing 5 lower bits to pattern phi
		ph_pat_v = ph_pat_q_p != 0; // non-zero quality means valid pattern
		ph_seg = ph_seg_p;
		ph_seg_v = ph_seg_v_p;
		th_seg = th_seg_p;
		cpat_seg = cpat_seg_p;
		
		// fill unused differences with max values
		ph_diff[tot_diff+2] = nodiff;
		ph_diff[tot_diff+1] = nodiff;
		ph_diff[tot_diff  ] = nodiff;
		diffi0 [tot_diff+2] = 6'h3f; // invalid
		diffi0 [tot_diff+1] = 6'h3f; // invalid
		diffi0 [tot_diff  ] = 6'h3f; // invalid

		// calculate abs differences
		di = 0;
		for (i = 0; i < max_drift; i = i+1) // history loop
		begin
			for (j = 0; j < zone_cham; j = j+1) // chamber loop
			begin
				for (k = 0; k < seg_ch; k = k+1) // segment loop
				begin
				    ph_segr = ph_seg[sorting_bx_mapping[i]][j][k];

					// get abs difference
					if (ph_seg_v[sorting_bx_mapping[i]][j][k] && ph_pat_v)
 					    ph_diff_tmp = (ph_pat > ph_segr) ? ph_pat - ph_segr : ph_segr - ph_pat;
					else
						ph_diff_tmp = nodiff; // if segment invalid put max value into diff

				    if (ph_diff_tmp > max_ph_diff)
 					    ph_diff[i*zone_cham*seg_ch + j*seg_ch + k] = nodiff; // difference is too high, cannot be the same pattern
				    else
				 	    ph_diff[i*zone_cham*seg_ch + j*seg_ch + k] = ph_diff_tmp[bw_phdiff-1:0];
				   
					ri = sorting_bx_mapping[i] ;
					rj = j;
					rk = k;
					// diffi variables carry track indexes
					diffi0[i*zone_cham*seg_ch + j*seg_ch + k] = {ri, rj, rk};
				end
			end
		end // for (i = 0; i < max_drift; i = i+1)

		// sort differences
		// first stage
		for (i = 0; i < stage1; i = i+1)
		begin
			// compare 3 values
			rcomp = comp3(ph_diff[i*3], ph_diff[i*3+1], ph_diff[i*3+2]);
			// fill outputs
			case (rcomp)
				0: begin cmp1[i] = ph_diff[i*3+0]; diffi1[i] = diffi0[i*3+0]; end
				1: begin cmp1[i] = ph_diff[i*3+1]; diffi1[i] = diffi0[i*3+1]; end
				2: begin cmp1[i] = ph_diff[i*3+2]; diffi1[i] = diffi0[i*3+2]; end
			endcase
		end

		// second stage
		for (i = 0; i < (stage2 == 6 ? 5 : stage2); i = i+1)
		begin
			// compare 3 values
			rcomp = comp3(cmp1[i*3], cmp1[i*3+1], cmp1[i*3+2]);
			// fill outputs
			case (rcomp)
				0: begin cmp2[i] = cmp1[i*3+0]; diffi2[i] = diffi1[i*3+0]; end
				1: begin cmp2[i] = cmp1[i*3+1]; diffi2[i] = diffi1[i*3+1]; end
				2: begin cmp2[i] = cmp1[i*3+2]; diffi2[i] = diffi1[i*3+2]; end
			endcase
		end

        // fill unused comparator output in case of 7-chamber unit 
        if (stage2 == 6)
        begin 
            cmp2[5] = nodiff;
            diffi2[5] = 6'h3f;
        end 

		// third stage
		for (i = 0; i < stage3; i = i+1)
		begin
			// compare 3 values
            rcomp = comp3(cmp2[i*3], cmp2[i*3+1], cmp2[i*3+2]);
            // fill outputs
            case (rcomp)
                0: begin cmp3[i] = cmp2[i*3+0]; diffi3[i] = diffi2[i*3+0]; end
                1: begin cmp3[i] = cmp2[i*3+1]; diffi3[i] = diffi2[i*3+1]; end
                2: begin cmp3[i] = cmp2[i*3+2]; diffi3[i] = diffi2[i*3+2]; end
            endcase
		end

		// last stage depends on number of input segments
		if (stage3 > 1)
		begin
			// compare 2 values
			rcomp[0] = cmp3[0] >= cmp3[1];
			// fill outputs
			case (rcomp[0])
				0: begin cmp4 = cmp3[0]; diffi4 = diffi3[0]; end
				1: begin cmp4 = cmp3[1]; diffi4 = diffi3[1]; end
			endcase
		end
		else
		begin
			cmp4 = cmp3[0]; 
			diffi4 = diffi3[0];
		end

		{hid, cid, sid} = diffi4;
		vid = ph_seg_v[hid][cid][sid];
		// if pattern invalid or all differences invalid remove valid flags 
		if (!ph_pat_v || cmp4 == nodiff) vid = 0;
		
        ph_match = ph_seg[hid][cid][sid]; // route best matching phi to output
          // rework of th_match to remove unphysical thetas, per Jia Fu request 2016-10-18
        if (zone_seg == seg_ch) // not ME1/1
        begin
            th_match[0] = th_seg[hid][cid][0]; // route all th coords from matching chamber to output
            th_match[1] = th_seg[hid][cid][1]; // route all th coords from matching chamber to output
        end
        else
        begin // ME1/1
            for (i = 0; i < seg_ch; i = i+1)
            begin
               th_match[i] = th_seg[hid][cid][sid*seg_ch+i]; // route 2 th coords from matching chamber to output
            end    
        end
		cpat_match = cpat_seg[hid][cid][sid]; // route pattern to output
	end

	
	function [1:0] comp3;
		input [bw_phdiff-1:0] a, b, c;
		reg [2:0] 	   r;
		begin
			r[2] = a <= b;
			r[1] = b <= c;
			r[0] = c <= a;

			case (r)
				0 : comp3 = 2'h3; // invalid
				1 : comp3 = 2'h2; // c
				2 : comp3 = 2'h1; // b
				3 : comp3 = 2'h1; // b
				4 : comp3 = 2'h0; // a
				5 : comp3 = 2'h2; // c
				6 : comp3 = 2'h0; // a
				7 : comp3 = 2'h0; // a
			endcase
		end
	endfunction
	
endmodule
