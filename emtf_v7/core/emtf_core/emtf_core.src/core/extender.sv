//////////////////////////////////////////////////////////////////////////////////
// Company: UF
// Engineer: Madorsky
// 
// Create Date:    14:24:00 03/12/2010 
// Design Name: tf_slhc
// Module Name:    extender 
// Project Name: tf_slhc
// Target Devices: V6
// Tool versions: 11.4
// Description: pulse extender
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//////////////////////////////////////////////////////////////////////////////////
`include "vppc_macros.sv"

module extender (inp, outp, drifttime, clk);
	// io bit width 
	`param bit_w = 240;

	input [bit_w-1:0] inp;
	output reg [bit_w-1:0] outp = 0;
	input [2:0] drifttime;
	input clk;

    //build delay lines for each bit
    reg [bit_w-1:0] d1, d2, d3, d4;
    always @(posedge clk)
    begin
//        d4 = d3;
//        d3 = d2;
        d2 = d1;
        d1 = inp;
    end
    
    // output logic combinatorial, to reduce latency
    always @(*)
    begin
        outp = inp | d1 | d2;
    end
endmodule
