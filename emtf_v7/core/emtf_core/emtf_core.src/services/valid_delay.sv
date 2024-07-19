`timescale 1ns / 1ps

module valid_delay
(
	val,
	val_lct,
	core_latency,
	valor,
	delay,
	window,
	stress,
	report_wo_track,
	clk
);

	input val;
	input val_lct;
	input [7:0] core_latency;
	output reg valor = 0;
	input [7:0] delay;
	input [2:0] window;
	input stress;
	input report_wo_track;
	input clk;

    wire [7:0] lct_delay = delay + core_latency; // lct valid flag extra delayed for core latency
	wire vald, vald_lct;
	reg val_comb;
	dyn_shift_1 dsh_bt  (.CLK (clk), .CE (1'b1), .SEL (delay),     .SI (val),     .DO (vald)); // best track valid delay
	dyn_shift_1 dsh_lct (.CLK (clk), .CE (1'b1), .SEL (lct_delay), .SI (val_lct), .DO (vald_lct)); // lct valid delay
	
	reg [7:0] val_line = 0;
	always @(posedge clk)
	begin
	
	    val_comb = vald | (vald_lct && report_wo_track);
	
		val_line = {val_comb, val_line[7:1]};
		
		case (window)
			3'h0: begin valor = val_line[0]; end
			3'h1: begin valor = |val_line[1:0]; end
			3'h2: begin valor = |val_line[2:0]; end
			3'h3: begin valor = |val_line[3:0]; end
			3'h4: begin valor = |val_line[4:0]; end
			3'h5: begin valor = |val_line[5:0]; end
			3'h6: begin valor = |val_line[6:0]; end
			3'h7: begin valor = |val_line[7:0]; end
		endcase
		
		valor = valor | stress; // if stress-testing, valid all the time
	end

endmodule
