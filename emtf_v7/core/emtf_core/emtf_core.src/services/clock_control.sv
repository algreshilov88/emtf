`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/31/2014 01:28:21 PM
// Design Name: 
// Module Name: clock_control
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module clock_control ( CLK, CLKuWire, DATAuWire, LEuWire, ld, en, done, clk_word);

	
	input CLK;				// Input FPGA Clock
    
	/// Serial MICROWIRE Interface 	
	output reg CLKuWire = 1'b0;	// MICROWIRE Clock 
	output reg DATAuWire = 1'b0;	// MICROWIRE Data 
	output reg LEuWire = 1'b0;	// MICROWIRE Latch Enable 
	input ld; // lock detect
	input en; // enable input
	input [31:0] clk_word; // control word from user
	output reg done = 1'b0; // output showing that power up init is done (inverted)
	
	parameter MAX_REGS = 17;
	parameter STEP1_REGS = 15;
	parameter REG_SIZE = 32;

	reg [REG_SIZE-1:0] DATAreg;	// Shift Register for uWire Data
	
	reg [REG_SIZE-1:0] mw_regs[MAX_REGS-1:0];	// Array of LMK03806 registers
	
	reg [5:0] reg_addr = 6'd0; 	// Registers address counter
	
	integer i;
	
		
	initial 
	begin
		$readmemh("mtf7_ptlut_steps12.txt", mw_regs);
	end
	
	wire clk_div; // divided clock
	wire clk_w = clk_div;
	wire clku_w = CLKuWire;
	wire data_w = DATAuWire;
	wire le_w = LEuWire;
	wire ld_w = ld;
	wire done_w = done;
	wire [5:0] reg_addr_w = reg_addr;
	wire en_w = en;
	
	
	localparam START = 3'h0; 
	localparam SETD = 3'h1;
	localparam SETC = 3'h2;
	localparam PAU1 = 3'h3;
	localparam SETL = 3'h4;
	localparam STOP = 3'h5;
	localparam WAIT_LD = 3'h6;
	
	reg [2:0] st = STOP;
	wire [2:0] st_w = st;

	reg [5:0] bn; // bit number
	reg [11:0] clk_div_b = 12'b0; 
		
	
	always @(posedge CLK)
		clk_div_b = clk_div_b + 12'b1;
	
		
	BUFG bg (.I(clk_div_b[11]), .O(clk_div));
		
	reg [31:0] clk_word_r, clk_word_rr, clk_word_rrr;
	initial
	begin
		clk_word_r = 32'hffffffff;
		clk_word_rr = 32'hffffffff;
		clk_word_rrr = 32'hffffffff;
	end
		
	reg en_r;
	/* uWire programming */	
	always @(posedge clk_div)
	begin

		CLKuWire = 1'b0;
		LEuWire = 1'b0;
		case (st)
			START:
			begin
				DATAreg = mw_regs[reg_addr]; // put word into shift register
				bn = 6'd32; // set bit counter
				st = SETD; // go to set data bit state
			end

			SETD:
			begin
				DATAuWire = DATAreg[31]; // data bit to data output
				DATAreg = {DATAreg[30:0], 1'b0}; // shift to next bit
				st = SETC; // go to set clock state
			end
			
			SETC:
			begin
				CLKuWire = 1'b1; //  set clock
				st = PAU1; // go to pause state
			end
			
			PAU1:
			begin
				bn = bn - 6'd1; // update bit counter
				if (bn == 6'd0) // last bit
					st = SETL; // go to LE pulse
				else
					st = SETD; // next bit
			end
			
			SETL:
			begin
				LEuWire = 1'b1; // set LE
				reg_addr = reg_addr + 6'h1; // next register
				if (reg_addr == STEP1_REGS) // step 1 programming done
				begin
					st = WAIT_LD; // need to wait for LD before proceeding
				end
				else
				if (reg_addr >= MAX_REGS) // all registers done
				begin
					done = 1'b1; // done configuring
					st = STOP; // go to stop state
				end
				else
				begin
					st = START; // program next register
				end
			end
			
			STOP:
			begin
				if (en && !en_r) // enable went up
				begin
					st = START; 
					reg_addr = 6'd0;
					done = 1'b0; 
				end
				if (clk_word_rrr[3:0] != clk_word_rr[3:0])
				begin
					// user writing a register
					DATAreg = clk_word_r; // place user's value 
					reg_addr = 6'd17; // so only one register is written
					bn = 6'd32; // set bit counter
					st = SETD; // go to set data bit state
				end
				
			end
			
			WAIT_LD:
			begin
				if (ld == 1'b1) // lock detected
				begin
					st = START; // continue
				end
			end
			
		endcase
		
		en_r = en;
		clk_word_rrr = clk_word_rr;
		clk_word_rr = clk_word_r;
		clk_word_r = clk_word;
	end
	
endmodule
