
//////////////////////////////////////////////////////////////////////////////////
// Company: UF
// Engineer: Madorsky
// 
// Create Date:    01:23:48 03/27/2010 
// Design Name: tf_slhc
// Module Name:    extend_sector 
// Project Name: tf_slhc
// Target Devices: V6
// Tool versions: 11.4
// Description: raw hit extender for entire sector
//
// Dependencies: extender
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
`include "vppc_macros.sv"

module extend_sector
(
    ph_zone,
    ph_ext,
    drifttime,
    clk
);

`include "spbits.sv"
	// ph zones [zone][station]
	input [ph_raw_w-1:0] ph_zone [3:0][4:1];

	// ph extended zones [zone][station]
	output [ph_raw_w-1:0] ph_ext [3:0][4:1];
	input [2:0] 		  drifttime;
	
	input 				  clk;

	`genv i, j;
	generate
		begin: genblk
			for (i = 0; i < 4; i = i+1)
			begin: ph_zone_blk
				for (j = 1; j < 5; j = j+1)
				begin: station
					extender #(.bit_w(ph_raw_w)) ext (.inp(ph_zone[i][j]), .outp(ph_ext[i][j]), .drifttime(drifttime), .clk(clk));
				end
			end
		end
	endgenerate
	
endmodule
	
	
