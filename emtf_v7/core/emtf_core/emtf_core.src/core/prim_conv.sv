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

module prim_conv
(
	vpf, quality, wiregroup, hstrip, clctpat,
	ph, th, vl, phzvl, me11a, clctpat_r,
    ph_hit,
	sel, addr, r_in, r_out, we,
	clk,
    control_clk,
    endcap,
    lat_test
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
	// phi
	output reg [bw_fph-1:0] ph [seg_ch-1:0]; 
	// full precision th, but without displacement correction
	output reg [bw_th-1:0] th [seg_ch-1:0];
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
	input lat_test; // latency test mode

	reg [bw_fph-1:0] eight_str  [seg_ch-1:0]; // eighth-strip

	reg [mult_bw-1:0] mult;
	reg [bw_fph-1:0] ph_tmp;
    reg [bw_fph-1:0] ph_hit_local;

	reg [bw_wg-1:0] wg;
	`int i;
	reg [bw_th-1:0] th_tmp;
	// theta lut, takes wiregroup, returns theta

	reg [5:0] th_mem [th_mem_sz-1:0]; // make memory size such that any address will be in range

	reg [12:0] params [5:0]; // programmable parameters [0] = ph_init, [1] = th_init, [2] = ph_displacement, [3] = th_displacement
	// initial ph for this chamber scaled to 0.1333 deg/strip
	reg [bw_fph-1:0] fph [seg_ch-1:0]; 

	// signals only for ME1/1
	// have to declare them here since vppc does not support declarations in generate blocks yet
	`int j;

	reg [10:0] factor; // strip width factor
	reg [seg_ch-1:0] me11a_w; // flag showing that we're working on ME11a region

	wire [7:0] 		 pc_id; // prim converter ID
    reg [2:0] 		 clct_pat_corr; // phi correction derived from clct pattern
	reg 			 clct_pat_sign; // phi correction sign

	assign pc_id[3:0] = cscid;
	assign pc_id[7:4] = station;

   // select chamber start for this unit from the table above
   wire [bw_fph-5-1:0] ph_hard = ph_init_hard[station][cscid];
   reg 	[bw_fph-5-1:0] ph_reduced [1:0];
   reg [bw_fph-1:0]    fph_to_reduce[1:0];

	// ME11 special case
	// all other stations
	assign r_out = (sel == 2'h0) ? params[addr] : 
				   (sel == 2'h1) ? th_mem[addr] : pc_id;	

	always @(posedge control_clk)
	begin
		// th LUT and parameters access
		case (sel)
			0: begin if (we) params [addr] = r_in; end
			1: begin if (we) th_mem [addr] = r_in; end
		endcase // case (sel)
	end

	// is this chamber mounted in reverse direction?
    wire ph_reverse = (endcap == 1'b0 && station >= 3) ? 1'b1 : 
                      (endcap == 1'b1 && station <  3) ? 1'b1 : 1'b0;

	
	always @(posedge clk)
	begin

		// zero outputs
		vl = 0;
		phzvl = 0;
		for (i = 0; i < seg_ch; i = i+1) begin fph[i] = 0; th[i] = 0; clctpat_r[i] = 0; end
		ph_hit = 0;
		

		// strip width factor relative to ME234/2 
		// 1024 == 1
		factor = (station <= 1 && ((cscid >= 6 && cscid <= 8) || (cscid == 14))) ? 947 : // ME1/3
				 1024; // all other chambers

		for (i = 0; i < seg_ch; i = i+1)
		begin

			me11a_w[i] = 0;
			// clct pattern convertion array from CMSSW
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
			
			// 10 deg chambers		
			if 
			(
			    (station <= 1) || // ME1 all 10 deg
			    (station >= 2 && ((cscid >= 3 && cscid <= 8) || cscid  == 10)) // ME2,3,4 outer ring
			)
			begin
				eight_str[i]  = {2'b0, hstrip [i], 2'h0}; // full precision, uses only 2 bits of clct pattern correction
				if (clct_pat_sign == 0) eight_str[i] = eight_str[i] + clct_pat_corr[2:1];
				else
				  // fix on Jia Fu request 2016-11-10
				  if (eight_str[i] != 13'd0) eight_str[i] = eight_str[i] - clct_pat_corr[2:1];
			end
			else
			begin
				// 20 deg chambers
				eight_str[i]  = {1'b0, hstrip [i], 3'h0}; // multiply by 2, uses all 3 bits of pattern correction
				if (clct_pat_sign == 0) eight_str[i] = eight_str[i] + clct_pat_corr;
				else
				  // fix on Jia Fu request 2016-11-10
				  if (eight_str[i] != 13'd0) eight_str[i] = eight_str[i] - clct_pat_corr;
			end
			
			
			if (vpf[i])
			begin
				vl[i] = 1;
				// ph conversion
				// for factors 1024 and 2048 the multiplier should be replaced with shifts by synthesizer
				mult = eight_str[i] * factor;
				ph_tmp = mult[mult_bw-1 : 10];
				if (ph_reverse) fph[i] = params[0] - ph_tmp;
				else            fph[i] = params[0] + ph_tmp;

			    fph_to_reduce[i] = fph[i] + 13'd16; // +16 to put the rounded value into the middle of error range
			    // divide full ph by 32, subtract chamber start
			    ph_reduced[i] = fph_to_reduce[i][bw_fph-1:5] - ph_hard;
			    ph_hit[ph_reduced[i]] = 1'b1; // set hit in zone
			   
				wg = wiregroup[i];
				// th conversion
				th_tmp = th_mem[wg];
				th[i] = th_tmp + params[1];
				if (th[i] == 7'h0) th[i] = 7'h1; // protect against invalid value


				// check which zones ph hits should be applied to
				if (th[i] <= (ph_zone_bnd1 + zone_overlap)) phzvl[0] = 1;
				if (th[i] >  (ph_zone_bnd2 - zone_overlap)) phzvl[2] = 1;
				if (
					(th[i] >  (ph_zone_bnd1 - zone_overlap)) &&
					(th[i] <= (ph_zone_bnd2 + zone_overlap))
					) phzvl[1] = 1;

				clctpat_r[i] = clctpat[i]; // just propagate pattern downstream
			end 
			else
			if (lat_test == 1'b1 && cscid == 0 && i == 0)
			begin
			     // in latency test mode, generate fake stub in chamber 0
			     vl[i] = 1'b1;
			     fph[i] = 13'd2048; 
			     ph_hit[22] = 1'b1;
			     th[i] = 7'd30; // ~17 deg
			     phzvl[0] = 1;
			     
			end

			ph[i] = fph[i];
		end
		me11a = 0;
	end

endmodule
