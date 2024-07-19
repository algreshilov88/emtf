//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:32:56 02/01/2012 
// Design Name: 
// Module Name:    sort_zone 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
`include "vppc_macros.sv"

module zone_best
(
 rank,
 winner,
 wini,
 rankr,
 clk_nx
);

`include "spbits.sv"

	input [bwr-1:0] rank [cnr-1:0]; // input ranks
	output reg [bwr-1:0] winner; // winner
	output reg [bpow-1:0] wini; // winner index
	output reg [bwr-1:0] rankr [cnr-1:0]; // output ranks, with winner removed
	input 			clk_nx; // fast clock

	reg [bwr-1:0] 	cmp [bpow:0][cnr-1:0];
	reg [bpow-1:0] ranki [bpow:0][cnr-1:0]; // rank index
	
	`int i, j, ncomp;
	always @(posedge clk_nx)
	begin

		// put inputs into initial stage
		cmp[0] = rank;

		// assign rank indexes first stage
		for (j = 0; j < cnr; j = j+1)
			ranki[0][j] = j;
		
		for (i = 0; i < bpow; i = i+1) // comparator stage loop
		begin
			
			ncomp = (1 << (bpow - i - 1));
			for (j = 0; j < ncomp; j = j+1) // comparator loop
			begin
				// compare two ranks, advance winner and its index to next stage
				if (cmp[i][j*2] > cmp[i][j*2+1]) 
				begin
					cmp  [i+1][j] = cmp  [i][j*2];
					ranki[i+1][j] = ranki[i][j*2];
				end
				else
				begin
					cmp  [i+1][j] = cmp  [i][j*2+1];
					ranki[i+1][j] = ranki[i][j*2+1];
				end
			end
		end

		// pick up winner and index from top of the tree
		winner = cmp[bpow][0];
		wini = ranki[bpow][0];

		// put ranks to output for next stage, except the winner
		rankr = rank;
		rankr[wini] = 0;

	end
	
endmodule


