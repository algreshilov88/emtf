`include "vppc_macros.sv"

module best_delta
(
 dth,
 sth,
 dvl,
 bth,
 bsg,
 bvl,
 bnm
);
`include "spbits.sv"
	`param nseg = seg_ch * seg_ch; // number of input deltas, could be 4 or 8
	`localpar bw_num = (nseg == seg_ch * seg_ch) ? 2 : 3;
	`localpar nodiff = ((1 << (bw_th)) - 1);

	input [bw_th-1:0] dth [nseg-1:0];
	input [nseg-1:0] sth;
	input [nseg-1:0] dvl;
	output reg [bw_th-1:0] bth; // smallest delta
	output reg 			   bsg; // sign of bth
	output reg 			   bvl; // valid flag
	output reg [bw_num-1:0] bnm; // winner number

	reg 				   one_val;

	`int i;
	reg [bw_th-1:0]    cmp1 [nseg/2-1:0];
	reg [bw_th-1:0]    cmp2 [nseg/4-1:0];
	reg [nseg/2-1:0] sig1;
	reg [nseg/4-1:0] sig2;
	reg [bw_num-1:0] num1 [nseg/2-1:0];
	reg [bw_num-1:0] num2 [nseg/4-1:0];
	
	always @(*)
	begin
		// first comparator stage
		for (i = 0; i < nseg/2; i = i+1)
		begin
		    // no valid flag analysis here
		    // we need to take all thetas into account
		    // differences from invalid thetas are set to max value, so they will not pass sorting
			if (dth[i*2] < dth[i*2+1])
			begin
				cmp1[i] = dth[i*2];
				sig1[i] = sth[i*2];
				num1[i] = i*2;
			end
			else
			begin 
				cmp1[i] = dth[i*2+1];
				sig1[i] = sth[i*2+1];
				num1[i] = i*2+1;
			end
		end

		// second comparator stage
		for (i = 0; i < nseg/4; i = i+1)
		begin
			if (cmp1[i*2] < cmp1[i*2+1])
			begin
				cmp2[i] = cmp1[i*2];
				sig2[i] = sig1[i*2];
				num2[i] = num1[i*2];
			end
			else
			begin 
				cmp2[i] = cmp1[i*2+1];
				sig2[i] = sig1[i*2+1];
				num2[i] = num1[i*2+1];
			end
		end

		// third comparator stage if needed
		if (nseg/4 > 1)
		begin
			if (cmp2[0] < cmp2[1])
			begin
				bth = cmp2[0];
				bsg = sig2[0];
				bnm = num2[0];
			end
			else
			begin 
				bth = cmp2[1];
				bsg = sig2[1];
				bnm = num2[1];
			end
		end
		else
		begin
			bth = cmp2[0];
			bsg = sig2[0];
			bnm = num2[0];
		end

		// output valid if one or more inputs are valid
		bvl = |(dvl);
	end
endmodule
