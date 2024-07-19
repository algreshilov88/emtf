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
	stress_prescale_code,
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
	input [1:0] stress_prescale_code;
	input report_wo_track;
	input clk;

    wire [7:0] lct_delay = delay + core_latency; // lct valid flag extra delayed for core latency
	(* mark_debug *) wire vald, vald_lct;
	reg val_comb;
	reg [7:0] val_line = 0;
	(* mark_debug *) wire val_comb_w = val_comb;
	(* mark_debug *) wire val_line_w = val_line;
	
	reg [3:0] stress_prescale = 0;
	// stress empty event rates:               30%,  20%,  10%,  0%
	wire [3:0] stress_prescale_lim [0:3] = '{4'd6, 4'd7, 4'd8, 4'd9};
	
	dyn_shift_1 dsh_bt  (.CLK (clk), .CE (1'b1), .SEL (delay),     .SI (val),     .DO (vald)); // best track valid delay
	dyn_shift_1 dsh_lct (.CLK (clk), .CE (1'b1), .SEL (lct_delay), .SI (val_lct), .DO (vald_lct)); // lct valid delay
	
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
		
		stress_prescale++;
		if (stress_prescale == 4'd10) stress_prescale = 4'b0;
		
		if (stress_prescale <= stress_prescale_lim[stress_prescale_code] && stress == 1'b1)
		    valor = 1'b1; // if stress-testing, valid 90% of the time
		    // 90% number measured by Efe from PU=40 conditions, 2022-09-01
	end

endmodule
