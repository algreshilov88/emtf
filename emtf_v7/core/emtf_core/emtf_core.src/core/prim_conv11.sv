//////////////////////////////////////////////////////////////////////////////////
// Company: UF
// Engineer: Madorsky
// 
// Create Date:    17:17:10 03/12/2010 
// Design Name: tf_slhc
// Module Name:    prim_conv 
// Project Name: tf_slhc
// Target Devices: V6
// Tool versions: 11.4
// Description: primitive converter into angular values
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
`include "vppc_macros.sv"

module prim_conv11
(
	vpf, quality, wiregroup, hstrip, clctpat,
	ph, th, vl, phzvl, me11a, clctpat_r,
    ph_hit, 
	sel, addr, r_in, r_out, we,
	clk,
    control_clk,
    endcap
);

`include "spbits.sv"
`include "ph_init_hard.sv"

	// input parameters from MPC
	input [seg_ch-1:0] vpf; // valid flags
	input [3:0]       quality   [seg_ch-1:0]; // quality inputs
	input [bw_wg-1:0] wiregroup [seg_ch-1:0]; // wiregroup numbers
	input [bw_hs-1:0] hstrip    [seg_ch-1:0]; // halfstrip numbers
	input [3:0] 	  clctpat   [seg_ch-1:0]; // clct pattern numbers

	// outputs
	// low-precision ph, only for detection
	// high-precision ph with displacement correction will be calculated when 
	// 3 best tracks are found.
	output reg [bw_fph-1:0] ph [seg_ch-1:0]; 
	// full precision th, but without displacement correction, takes th duplication into account
	output reg [bw_th-1:0] th [th_ch-1:0];
	// one-bit valid flags
	output reg [seg_ch-1:0] vl;
	output reg [2:0] 		phzvl; // raw hit valid flags for up to 3 ph zones
	output reg [seg_ch-1:0] me11a;
	output reg [3:0] 		clctpat_r [seg_ch-1:0]; // clct pattern numbers

	// ph and th raw hits
	output reg [ph_hit_w-1:0] ph_hit;
	
	input [1:0] sel; // binary address of the register or memory to access
	input [bw_addr-1:0] addr; // address in memory to access. For registers, set to 0
	input  [12:0] r_in; // input data for memory or register
	output [12:0] r_out; // output data from memory or register
	input we; // write enable for memory or register
	input clk; // write clock
	input control_clk; // control interface clock
	input endcap;

    `localpar th_coverage = 7'd46; // Jia Fu request 2016-11-03 
    `localpar th_negative = 7'd50; 

	reg [bw_fph-1:0] eight_str  [seg_ch-1:0]; // eighth-strip

	reg [mult_bw-1:0] mult;
   //reg [bw_wg + 5-1:0] wg_mult;
	reg [bw_fph-1:0] ph_tmp;

	reg [bw_wg-1:0] wg;
	`int i;
	reg [bw_th-1:0] th_tmp, thf;
	// theta lut, takes wiregroup, returns theta

	reg [5:0] th_mem [th_mem_sz-1:0]; // make memory size such that any address will be in range

	// programmable parameters 
	// [0] = ph_init_b
	// [1] = ph_displacement_b
	// [2] = ph_init_a 
	// [3] = ph_displacement_a 
	// [4] = th_init 
	// [5] = th_displacement
	reg [12:0] params [5:0]; 
	// initial ph for this chamber scaled to 0.1333 deg/strip
	reg [bw_fph-1:0] fph [seg_ch-1:0]; 

	// signals only for ME1/1
	// have to declare them here since vppc does not support declarations in generate blocks yet
	`int j;
	reg [3:0] th_corr;
	reg [bw_ds+1:0] index;
	reg [5:0] th_orig;
	// theta correction lut, for me1/1 only
	// takes index = {wiregroup(2 MS bits), dblstrip}, returns theta correction for tilted wires
	reg [3:0] th_corr_mem [th_corr_mem_sz-1:0];

	reg [10:0] factor [seg_ch-1:0]; // strip width factors for each segment
	reg [seg_ch-1:0] me11a_w; // flag showing that we're working on ME11a region

	wire [7:0] 		  pc_id; // prim converter ID
    reg [2:0] 		  clct_pat_corr; // phi correction derived from clct pattern
	reg 			  clct_pat_sign; // phi correction sign
	reg [2:0] 		  ph_init_ix; // parameter index for ph_init 
	
	reg [6:0] th_tmp1[1:0];

   // select chamber start for this unit from the table above
   wire [bw_fph-5-1:0] ph_hard = ph_init_hard[station][cscid];
   reg 	[bw_fph-5-1:0] ph_reduced [1:0];
   reg [bw_fph-1:0]    fph_to_reduce[1:0];

	
	assign pc_id[3:0] = cscid;
	assign pc_id[7:4] = station;


	
	assign r_out = (sel == 2'h0) ? params[addr] : 
				   (sel == 2'h1) ? th_mem[addr] : 
				   (sel == 2'h2) ? th_corr_mem[addr] : pc_id;	

	always @(posedge control_clk)
	begin
		// th LUT and parameters access
		case (sel)
			0: begin if (we) params     [addr] = r_in; end
			1: begin if (we) th_mem     [addr] = r_in; end
			2: begin if (we) th_corr_mem[addr] = r_in[3:0]; end
		endcase
	end
	
	// is this chamber mounted in reverse direction?
    wire ph_reverse = (endcap == 1'b0 && station >= 3) ? 1'b1 : 
                      (endcap == 1'b1 && station <  3) ? 1'b1 : 1'b0;
	
	
	always @(posedge clk)
	begin

		// zero outputs
		vl = 0;
		phzvl = 0;
		for (i = 0; i < seg_ch; i = i+1) begin fph[i] = 0; clctpat_r[i] = 0; end
		for (i = 0; i < th_ch;  i = i+1) th[i] = 0;
		ph_hit = 0;

	    // calculate eight_str and me11a_w parameters upfront
	    // bug found by Jia Fu on 2016-09-16
		for (i = 0; i < seg_ch; i = i+1)
		begin
			factor[i] = (station <= 1 && (cscid <= 2 || cscid == 12) && hstrip[i] > 127) ? 1707 : // ME1/1a
				 1301; // ME1/1b

			//{0.0, 0.0, -0.60,  0.60, -0.64,  0.64, -0.23,  0.23, -0.21,  0.21, 0.0}
			// 0    0    -5      +5    -5      +5    -2      +2    -2      +2    0
			case (clctpat[i])
				0  : begin clct_pat_corr = 3'h0; clct_pat_sign = 0; end
				1  : begin clct_pat_corr = 3'h0; clct_pat_sign = 0; end
				2  : begin clct_pat_corr = 3'h5; clct_pat_sign = 1; end
				3  : begin clct_pat_corr = 3'h5; clct_pat_sign = 0; end
				4  : begin clct_pat_corr = 3'h5; clct_pat_sign = 1; end
				5  : begin clct_pat_corr = 3'h5; clct_pat_sign = 0; end
				6  : begin clct_pat_corr = 3'h2; clct_pat_sign = 1; end
				7  : begin clct_pat_corr = 3'h2; clct_pat_sign = 0; end
				8  : begin clct_pat_corr = 3'h2; clct_pat_sign = 1; end
				9  : begin clct_pat_corr = 3'h2; clct_pat_sign = 0; end
				10 : begin clct_pat_corr = 3'h0; clct_pat_sign = 0; end
				default: begin clct_pat_corr = 3'h0; clct_pat_sign = 0; end
			endcase

			// reverse clct pattern correction if chamber is reversed
//			if (ph_reverse) clct_pat_sign = ~clct_pat_sign;

			
		    // convert into 1/8 strips and remove ME1/1a offset (512=128*4)
		    me11a_w[i] = (station <= 1 && (cscid <= 2 || cscid == 12) && hstrip[i] > 127);
		    eight_str[i]  = {2'b0, hstrip [i], 2'h0} - (me11a_w[i] ? 512 : 0);

			// clct pattern correction
			if (clct_pat_sign == 0) eight_str[i] = eight_str[i] + clct_pat_corr[2:1];
			else
			begin
			   if (eight_str[i] != 13'd0) // fix on Jia Fu request 2016-11-10
				 eight_str[i] = eight_str[i] - clct_pat_corr[2:1];
			end
		end
	   
		for (i = 0; i < seg_ch; i = i+1)
		begin


			if (vpf[i])
			begin
				vl[i] = 1;
				// ph conversion
				// for factors 1024 and 2048 the multiplier should be replaced with shifts by synthesizer
				mult = eight_str[i] * factor[i];
				ph_tmp = mult[mult_bw-1 : 10];
				ph_init_ix =  me11a_w[i] ? 3'd2 : 3'd0; // index of ph_init parameter to apply (different for ME11a and b)
				
				if (ph_reverse) fph[i] = params[ph_init_ix] - ph_tmp;
				else            fph[i] = params[ph_init_ix] + ph_tmp;

			    fph_to_reduce[i] = fph[i] + 13'd16; // +16 to put the rounded value into the middle of error range
			    // divide full ph by 32, subtract chamber start
			    ph_reduced[i] = fph_to_reduce[i][bw_fph-1:5] - ph_hard;
			    ph_hit[ph_reduced[i]] = 1'b1; // set hit in zone
			   
				wg = wiregroup[i];
				// th conversion
				// call appropriate LUT, it returns th[i] relative to wg0 of that chamber
				th_orig = th_mem[wg];


				// need th duplication here
				for (j = 0; j < seg_ch; j = j+1)
				begin
					if (vpf[j])
					begin
					   // calculate correction for each strip number
					   // index is: {wiregroup(2 MS bits), dblstrip(5-bit for these chambers)}
					   // rework on Jia Fu request, 2016-11-03
					   // wg_mult = wg * 5'd21;
					   if (me11a_w[j])
					   begin
						  mult = eight_str[j] * 9'd341; // 341/256 =~ 1.333
						  // index = {wg_mult[9:8], mult[16:12]};
						  index = {wg[5:4], mult[16:12]};
					   end
					   else
					   begin 
						 // index = {wg_mult[9:8], eight_str[j][8:4]};
						 index = {wg[5:4], eight_str[j][8:4]};
					   end
					   th_corr = th_corr_mem[index];

					   // apply correction to the corresponding output
					   th_tmp = (th_orig + th_corr);

					   th_tmp1[j] = th_tmp;

					   // check that correction did not make invalid value outside chamber coverage

					   if (wg == 7'h0)
						 th_tmp = 7'h0; // limit at the bottom

					   if (th_tmp > th_coverage)
						 th_tmp = th_coverage; // limit at the top

                        // apply initial th value for that chamber
					    thf = th_tmp + params[4];
                        if (thf == 7'h0) thf = 7'h1; // protect against invalid value
                        th[j*seg_ch+i] = thf; // indexes switched i<-->j per Jia Fu request 2016-10-18
                        
                        // check which zones ph hits should be applied to
                        if (thf <= (ph_zone_bnd1 + zone_overlap)) phzvl[0] = 1;
                        if (thf >  (ph_zone_bnd2 - zone_overlap)) phzvl[2] = 1;
                        if (
                            (thf >  (ph_zone_bnd1 - zone_overlap)) &&
                            (thf <= (ph_zone_bnd2 + zone_overlap))
                            ) phzvl[1] = 1;
                        
					end
				end
				clctpat_r[i] = clctpat[i]; // just propagate pattern downstream
			end 
			
			ph[i] = fph[i];
			
		end // for (i = 0; i < seg_ch; i = i+1)
		me11a = me11a_w;
	end

endmodule
