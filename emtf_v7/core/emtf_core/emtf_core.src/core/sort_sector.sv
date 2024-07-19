
//////////////////////////////////////////////////////////////////////////////////
// Company: UF
// Engineer: Madorsky
// 
// Create Date:    01:36:08 03/19/2010 
// Design Name: tf_slch
// Module Name:    sort_sector
// Project Name: tf_slch
// Target Devices: V6
// Tool versions: 11.4
// Description: pattern sorter for entire sector
//
// Dependencies: sorter
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
`include "vppc_macros.sv"

module sort_sector
(
	ph_rank,
	ph_num,
	ph_q,
	clk
);
`include "spbits.sv"

	// ph pattern ranks [zone][key_ph]
	input [bwr-1:0] ph_rank [3:0][ph_raw_w-1:0]; 

	// numbers of best ranks [zone][num]
	output [bpow:0] ph_num [3:0][2:0]; 

	// best ranks [zone][num]
	output [bwr-1:0] ph_q [3:0][2:0]; 

	input clk;
	
	`genv i;
	generate
		begin: gb
			for (i = 0; i < 4; i = i+1)
			begin: ph_zone
				zone_best3 zb3
				(
				 .rank_ex (ph_rank[i]),
				 .winner (ph_q[i]),
				 .wini (ph_num[i]),
				 .clk_nx (clk)
				);
			end
		end
	endgenerate

endmodule

