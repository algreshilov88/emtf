`include "vppc_macros.sv"

module zone_best3
(
 rank_ex,
 winner,
 wini,
 clk_nx
);
`include "spbits.sv"
	input [bwr-1:0] rank_ex [cnrex-1:0]; // input ranks
	output reg [bwr-1:0] winner [2:0]; // winners
	output reg [bpow:0] wini [2:0]; // winner indexes one bit longer than in internal sorters
	input 			clk_nx; // fast clock

	wire [bwr-1:0] rankr [3:0][cnr-1:0]; // rank connections between stages

	// delay lines for early winners
	reg [bwr-1:0]  winnerd [1:0][2:0];
	reg [bpow-1:0] winid [1:0][2:0];
	reg [bwr-1:0]  winnerw [2:0];
	reg [bpow-1:0] winiw [2:0];
	reg [cnrex-1:0]  valid [2:0]; // valid flags

	`int j;
	
	`genv i;
	generate
	begin: gb
		// implement pair OR between neighboring input ranks.
		// neighbors cannot contain valid ranks because of ghost cancellation
		for (i = 0; i < cnrex/2; i = i+1)
		begin: rank_assign_loop
			assign rankr[0][i] = rank_ex[i*2] | rank_ex[i*2+1];
		end

		// unused inputs
		for (i = cnrex/2; i < cnr; i = i+1)
			assign rankr[0][i] = 0;
		
		for (i = 0; i < 3; i = i+1) // generate 3 sorters in chain
		begin: zone_best_loop
			zone_best zb
			(
			 .rank	 (rankr[i]),
			 .winner (winnerw[i]),
			 .wini	 (winiw[i]),
			 .rankr	 (rankr[i+1]),
			 .clk_nx (clk_nx)
			);
		end
	end
	endgenerate

	// winner delay line
	always @(posedge clk_nx)
	begin


		// assign winner outputs from delay lines for each winner
		// delay lines are of different length to compensate for sorter stages
		winner[0] = winnerd[1][0]; wini[0][bpow:1] = winid[1][0];
		winner[1] = winnerd[0][1]; wini[1][bpow:1] = winid[0][1];
		winner[2] = winnerw[2];    wini[2][bpow:1] = winiw[2];

		wini[0][0] = 0;
		wini[1][0] = 0;
		wini[2][0] = 0;
		
		// find LSBs of wini outputs using valid bits
        for (j = 0; j < 3; j = j+1)
        begin
            if (winner[j] > 0)
                wini[j][0] = !valid[2][wini[j]];
            else
                wini[j] = 7'b1111111;
        end        

		// winner delay line
		winnerd[1] = winnerd[0];   winid[1] = winid[0];
		winnerd[0] = winnerw;      winid[0] = winiw;

		// delay line for valid bits
		valid[2] = valid[1];
		valid[1] = valid[0];
		for (j = 0; j < cnrex; j = j+1)
			valid[0][j] = rank_ex[j] != 0;
	end
endmodule
