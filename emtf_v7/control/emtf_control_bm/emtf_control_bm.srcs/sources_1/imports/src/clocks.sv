`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/01/2014 03:25:15 PM
// Design Name: 
// Module Name: clocks
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


module clocks
(
    // LHC clock input
    input lhc_clk_p,
    input lhc_clk_n,
    // clock selected for dejittering
    output bpclk_p,
    output bpclk_n,
    
    input clk50_p,
    input clk50_n,
    output clk50,

    input clk40_p,
    input clk40_n,
    output clk40,

	output lhc_clk,
    
    // sync clock
    output s_clk,
    output s_data,
    output s_le,
    input  s_lock,
    output s_sync,
	input s_en,
	output s_done,
    
    output reg clk_config_done = 1'b1,
    input [31:0] clk_word,
    
    output lhc_clk_good

);

   
    // just feed LHC clock directly to cleaner
    OBUFDS bpclk_buf (.I(lhc_clk), .O(bpclk_p), .OB(bpclk_n));

    wire [3:0] clk_stop, clk_oor, clk_glitch;
    wire lhc_locked, lhc_clk_mmcm;

    lhc_clk_det lhc_clk_monitor
    (
        .s_axi_aclk      (1'b0),        // input s_axi_aclk                        
        .s_axi_aresetn   (1'b1),     // input s_axi_aresetn,                                                          
        .s_axi_awaddr    (11'b0),      // input [10 : 0] s_axi_awaddr,                              
        .s_axi_awvalid   (1'b0),     // input s_axi_awvalid,                                                          
        .s_axi_awready   (),     // output s_axi_awready,                                                         
        .s_axi_wdata     (32'b0),       // input [31 : 0] s_axi_wdata,                             
        .s_axi_wstrb     (4'b0),       // input [3 : 0] s_axi_wstrb,                         
        .s_axi_wvalid    (1'b0),      // input s_axi_wvalid,                                                         
        .s_axi_wready    (),      // output s_axi_wready,                                                        
        .s_axi_bresp     (),       // output [1 : 0] s_axi_bresp,                                               
        .s_axi_bvalid    (),      // output s_axi_bvalid,                                                        
        .s_axi_bready    (1'b0),      // input s_axi_bready,                                                         
        .s_axi_araddr    (11'b0),      // input [10 : 0] s_axi_araddr,                              
        .s_axi_arvalid   (1'b0),     // input s_axi_arvalid,                                                          
        .s_axi_arready   (),     // output s_axi_arready,                                                         
        .s_axi_rdata     (),       // output [31 : 0] s_axi_rdata,                            
        .s_axi_rresp     (),       // output [1 : 0] s_axi_rresp,                                               
        .s_axi_rvalid    (),      // output s_axi_rvalid,                                                        
        .s_axi_rready    (1'b0),      // input s_axi_rready,                                                         
     
        
        .ref_clk  (clk50),                  // input ref_clk,
        
        .clk_stop (clk_stop),                 // output clk_stop,
        .clk_oor (clk_oor),                   // output clk_oor,
        .clk_glitch (clk_glitch),             // output clk_glitch,
        .interrupt (),               // output interrupt,
        // Clock out ports
        .clk_out1(lhc_clk_mmcm),     // output clk_out1
        // Status and control signals
        .locked(lhc_locked),       // output locked
        // Clock in ports
        .clk_in1_p(lhc_clk_p),    // input clk_in1_p
        .clk_in1_n(lhc_clk_n)
    );    // input clk_in1_n

    assign lhc_clk_good = lhc_locked && !clk_stop[0] && !clk_oor[0];

    // use lhc clock only if not stopped, not out of range, and mmcm is locked
    BUFGMUX bmux (.I0(1'b0), .I1(lhc_clk_mmcm), .O(lhc_clk), .S(lhc_clk_good));


    // input clock buffers
	wire clk40_b;
    IBUFDS clk50_buf (.I(clk50_p), .IB(clk50_n), .O(clk50));
	
//    IBUFDS clk40_ibuf (.I(clk40_p), .IB(clk40_n), .O(clk40_b));
	IBUFDS_GTE2 clk40_ibuf (.I(clk40_p), .IB(clk40_n), .O(clk40_b), .CEB(1'b0), .ODIV2());
	BUFG clk40_buf (.I(clk40_b), .O(clk40));

    reg s_done_r, s_en_r = 1'b0;
    // sync clock module control

    clock_control #(.MAX_REGS(26)) sync_clock 
    ( 
        .CLK(clk50), 
        .CLKuWire(s_clk), 
        .DATAuWire(s_data), 
        .LEuWire(s_le), 
        .sync(s_sync),
        .en (s_en_r || s_en), 
        .done (s_done),
        .clk_word (clk_word)
    );

	reg [25:0] reset_cnt = 26'h3ffffff; // about 1.2 sec delay
	reg reset_go = 1'b0;
	
	localparam S_CNF = 3'h0;
	localparam S_WAIT = 3'h1;
	localparam PCIE_CNF = 3'h2;
	localparam STOP = 3'h3;
	reg [2:0] state = S_CNF;
	
	always @(posedge clk50)
	begin
		case (state)
			S_CNF: 
			begin
				if (reset_cnt > 26'h0)
					reset_cnt = reset_cnt - 26'h1;
				else
				begin
					s_en_r = 1'b1;
					state = S_WAIT;
					reset_cnt = 26'h3ffffff;
				end
			end
			
			S_WAIT:
			begin
				if (s_done) 
				begin
					state = PCIE_CNF;
					s_en_r = 1'b0;
				end
			end
						
			PCIE_CNF:
			begin
				if (reset_cnt > 26'h0)
					reset_cnt = reset_cnt - 26'h1;
				else
				begin
					clk_config_done = 1'b0;
					state = STOP;
				end
			end
			
			STOP:
			begin
				clk_config_done = 1'b1;
			end
		endcase
		
	end
	

endmodule
