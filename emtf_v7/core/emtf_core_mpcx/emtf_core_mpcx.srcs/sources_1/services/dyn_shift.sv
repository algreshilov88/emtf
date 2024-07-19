`timescale 1ns / 1ps

// this module infers cascaded SRLC32E primitives
// copied from XST manual
module dyn_shift_1 (CLK, CE, SEL, SI, DO);
	parameter SELWIDTH = 8;
	input CLK, CE, SI;
	input [SELWIDTH-1:0] SEL;
	output DO;
	localparam DATAWIDTH = (1 << SELWIDTH); //2**SELWIDTH;
	reg [DATAWIDTH-1:0] data;
	assign DO = data[SEL];

	always @(posedge CLK)
	begin
		if (CE == 1'b1)
			data = {data[DATAWIDTH-2:0], SI};
	end
endmodule
