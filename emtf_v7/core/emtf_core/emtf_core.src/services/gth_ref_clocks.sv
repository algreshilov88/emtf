`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:06:15 08/19/2014 
// Design Name: 
// Module Name:    gth_ref_clocks 
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
module gth_ref_clocks
(
	// ref clock inputs
	input [7:0] ref_clk_in_p,
	input [7:0] ref_clk_in_n,
	
	// ref clock outputs for each MPC
	output [7:0] mpc0_ref_clk,
	output [7:0] mpc1_ref_clk,
	output [7:0] mpc2_ref_clk,
	output [7:0] mpc3_ref_clk,
	output [7:0] mpc4_ref_clk,
	output [8:0] mpcn_ref_clk,

	// async clock for 10G tx
	input [7:0] async_ref_clk_n,
	input [7:0] async_ref_clk_p,
	
	output async_ref_clk,
	output daq_ref_clk,
	output [2:0] cppf_ref_clk,
	output clk_125

);

	wire [7:0] rc, arc;
	// instantiate buffers
	genvar gi;
	generate
		for (gi = 0; gi < 8; gi = gi+1)
		begin: ref_clk_gen
			IBUFDS_GTE2 ib_refclk  
			(
				.O               (rc[gi]),
				.ODIV2           (),
				.CEB             (1'b0),
				.I               (ref_clk_in_p[gi]),
				.IB              (ref_clk_in_n[gi])
			);

            IBUFDS_GTE2 ib_async_refclk  
            (
                .O               (arc[gi]),
                .ODIV2           (),
                .CEB             (1'b0),
                .I               (async_ref_clk_p[gi]),
                .IB              (async_ref_clk_n[gi])
            );
		end
	endgenerate

	// send appropriate clocks to each MPC GTH RX
	// see gth_inversion.xlsx, Sheet 4, "clock index" column for details
	assign mpc0_ref_clk = {rc[7], rc[7], rc[3], rc[3], rc[7], rc[7], rc[3], rc[3]};
	assign mpc1_ref_clk = {rc[7], rc[7], rc[3], rc[3], rc[7], rc[7], rc[3], rc[3]};
	assign mpc2_ref_clk = {rc[6], rc[7], rc[2], rc[2], rc[7], rc[7], rc[2], rc[2]};
	assign mpc3_ref_clk = {rc[6], rc[6], rc[2], rc[2], rc[6], rc[7], rc[2], rc[2]};
	assign mpc4_ref_clk = {rc[5], rc[6], rc[2], rc[2], rc[6], rc[6], rc[2], rc[2]};
	assign mpcn_ref_clk = {rc[1], rc[5], rc[5], rc[1], rc[1], rc[5], rc[5], rc[1], rc[1]};
	
    assign async_ref_clk = arc[7]; // clock for GMT output
    assign daq_ref_clk = arc[0]; // clock for DAQ
    // clocks for cppf rx
    assign cppf_ref_clk = {arc[1], arc[5], arc[6]};
    BUFG clk125_bufg (.I(arc[2]), .O(clk_125)); // take unused async refclk for FPGA fabric
    

endmodule
