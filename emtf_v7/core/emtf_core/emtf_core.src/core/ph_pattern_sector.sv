//////////////////////////////////////////////////////////////////////////////////
// Company: UF
// Engineer: Madorsky
// 
// Create Date:    08:02:04 03/10/2010 
// Design Name: tf_slhc
// Module Name:    ph_pattern_sector
// Project Name: tf_slhc
// Target Devices: V6
// Tool versions: 11.4
// Description: ph pattern detection for entire sector
//
// Dependencies: ph_pattern
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
`include "vppc_macros.sv"

module ph_pattern_sector
(
    st,
    drifttime,
	foldn,
    qcode,
    clk
);

`include "spbits.sv"

	// ph zones [zone][station]
	input [ph_raw_w-1:0] st [3:0][4:1];

    input [2:0] drifttime;
	// number of current fold 
	input [2:0] foldn;
	// quality codes output [zone][key_strip]
    output reg [5:0] qcode [3:0][ph_raw_w-1:0];
	// quality code pattern numbers [zone][key_strip]

    input clk;

	// copy of stations with padding of zeroes on sides, so it's easier to pass to detectors
	// station numbering is different here:
	// 0 == st1
	// 1 == st3
	// 2 == st4
	// st 2 does not need padding
	wire [ph_raw_w + padding_w_st1*2-1:0] stp [3:0][2:0];
	`genv i, z;
	// quality codes from pattern detectors [zone][key_strip]
    wire [5:0] qcode_p [3:0][ph_raw_w-1:0];
	// quality code pattern numbers [zone][key_strip]
	
	`int zi, ri;
	// left, right and center qualities
    reg [5:0] ql, qr, qc;

`static
	generate
	begin : gb_stat
		for (z = 0; z < 4; z = z+1)
		begin: padding
			// fill padding with zeroes	
			assign stp [z][0][padding_w_st1-1 : 0] = 0;
			assign stp [z][0][ph_raw_w + padding_w_st1*2-1 : ph_raw_w + padding_w_st1] = 0;
			
			assign stp [z][1][padding_w_st3-1 : 0] = 0;
			assign stp [z][1][ph_raw_w + padding_w_st3*2-1 : ph_raw_w + padding_w_st3] = 0;
			
			assign stp [z][2][padding_w_st3-1 : 0] = 0;
			assign stp [z][2][ph_raw_w + padding_w_st3*2-1 : ph_raw_w + padding_w_st3] = 0;
		end
	end
	endgenerate
`endstatic

	generate
	begin: gb 
		for (z = 0; z < 4; z = z+1)
		begin: padding
			// put station inputs into padded copy
			assign stp [z][0][ph_raw_w + padding_w_st1-1 : padding_w_st1] = st[z][1];
			assign stp [z][1][ph_raw_w + padding_w_st3-1 : padding_w_st3] = st[z][3];
			assign stp [z][2][ph_raw_w + padding_w_st3-1 : padding_w_st3] = st[z][4];
		end

		for (z = 0; z < 4; z = z+1)
		begin: ph_pat_zone
			for (i = 0; i < ph_raw_w; i = i+1)
			begin : ph_pat_hit
				ph_pattern php
				(
					 .st1 	    (stp [z][0][i+full_pat_w_st1-1 : i]),
					 .st2 	    (st  [z][2][i]),
					 .st3 	    (stp [z][1][i+full_pat_w_st3-1 : i]),
					 .st4	    (stp [z][2][i+full_pat_w_st3-1 : i]),
					 .drifttime (drifttime),
					 .foldn	    (foldn),
					 .qcode	    (qcode_p[z][i]),
					 .clk       (clk)
				);
			end // block: ph_pat_hit
		end
	end
	endgenerate

	
	always @(*)
	begin
		// ghost cancellation logic
		for (zi = 0; zi < 4; zi = zi+1) // zone loop
		begin
			for (ri = 0; ri < ph_raw_w; ri = ri+1) // pattern detector loop
			begin
				qc = qcode_p[zi][ri]; // center quality is the current one

				if (ri == 0) // right end - special case
				begin
					ql = qcode_p[zi][ri+1];
					qr = 0; // nothing to the right
				end
				else
				if (ri == ph_raw_w-1) // left end - special case
				begin
					ql = 0; // nothing to the left
					qr = qcode_p[zi][ri-1];
				end
				else // all other patterns
				begin
					ql = qcode_p[zi][ri+1];
					qr = qcode_p[zi][ri-1];
				end

				// cancellation conditions
				if (qc <=  ql || qc <  qr) // this pattern is lower quality than neighbors
				begin
					qc = 0; // cancel
				end

				// put the results into outputs
				qcode[zi][ri] = qc;
			end
		end
	end

endmodule
