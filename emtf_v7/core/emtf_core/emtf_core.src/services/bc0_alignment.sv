`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:00:12 08/22/2014 
// Design Name: 
// Module Name:    bc0_alignment 
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
`include "../core/vppc_macros.sv"

module bc0_alignment #(parameter FC = 8*5+9) // count of fibers
(
	input ttc_bc0, // bc0 signal from TTC
	input [8:0] ttc_bc0_delay, // ttc bc0 delay, to create alignment bc0, in 40 MHz clocks
	input [FC-1:0] bc0,
	output [7:0] time_counts [FC-1:0],
	output reg [FC-1:0] alignment_error,
	input [7:0] user_af_delays [FC-1:0],
	input af_enable,
	input clk_160, 
	input clk_40
);

	integer i;
	reg [7:0] cnt [FC-1:0]; // idividual time counters for each fiber
	reg [7:0] cnt_r [FC-1:0]; // idividual time counters for each fiber
	assign time_counts = cnt_r; 
	reg [15:0] to = 16'h0; // timeout counter
	reg [FC-1:0] stopped = 49'h1ffffffffffff; // flags showing which counters have been stopped
	reg [1:0] clk_phase_cnt; // 40 M clock phase indicator
	reg clk_40_r;
	reg ttc_bc0_r, ttc_bc0_rr, ttc_bc0_rrr;
	reg [FC-1:0] bc0_r;
	reg [8:0] ttc_bc0_cnt;
	reg ttc_bc0_del;


	always @(posedge clk_160)
	begin
	
		// delay ttc bc0 to make alignment signal
		// this signal should come a little later than the latest bc0 from fibers

		ttc_bc0_del = 1'b0;
		
		if (ttc_bc0_rr && !ttc_bc0_rrr) // ttc_bc0 just rose
		begin
			ttc_bc0_cnt = ttc_bc0_delay; // reset counter
		end
		if (ttc_bc0_cnt == 9'h1) // delay expired
		begin
			stopped = 49'h1ffffffffffff; // stop all counters
			ttc_bc0_del = 1'b1;
			// update all counters in the output register
			for (i = 0; i < FC; i = i+1)
			begin
				cnt_r[i] = cnt[i];
//				alignment_error[i] = (cnt_r[i] == 8'hff) ? 1'b1 : 1'b0; // detect error if alignment did not run
				alignment_error[i] = (cnt_r[i] < 8'h0a || cnt_r[i] > 8'h3a) ? 1'b1 : 1'b0; // alignment out of bounds
				cnt[i] = 8'hff; // this is to prevent the counter from keeping old value forever if BC0s from chamber stop coming 
			end
		end
		if (ttc_bc0_cnt != 9'h0) ttc_bc0_cnt = ttc_bc0_cnt - 9'h1;
		ttc_bc0_rrr = ttc_bc0_rr;
		ttc_bc0_rr = ttc_bc0_r;
		ttc_bc0_r = ttc_bc0;

		// count clocks from each fiber's bc0 to alignment signal
		for (i = 0; i < FC; i = i+1)
		begin
			// increment counter if not stopped
			if (!stopped[i]) cnt[i] = cnt[i] + 8'h1; 

			if (bc0[i] && !bc0_r[i]) // bc0 from fiber just rose 
			begin
				cnt[i] = 8'h0; // reset fiber counter at bc0
				stopped[i] = 1'b0; // remove stopped flag
				
			end
			
			if (!af_enable)
				cnt_r[i] = user_af_delays[i]; // use user-supplied fixed values if AF is disabled
		end
		
		bc0_r = bc0;
	
	end


endmodule
