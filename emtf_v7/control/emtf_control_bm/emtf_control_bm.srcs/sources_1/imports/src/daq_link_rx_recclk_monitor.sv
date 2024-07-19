//////////////////////////////////////////////////////////////////////////////////
//   ____  ____ 
//  /   /\/   / 
// /___/  \  /    Vendor: Xilinx 
// \   \   \/     Version : 2.2
//  \   \         Application : 7 Series FPGAs Transceivers Wizard 
//  /   /         Filename : daq_link_rx_recclk_monitor.v
// /___/   /\     
// \   \  /  \ 
//  \___\/\___\ 
//
//
//  Description :     This module is the ppm monitor between the
//  		      GT RxRecClk and the reference clock	 
//
//                    This module will declare that the Rx RECCLK is stable if the 
//                    recovered clock is within +/-5000PPM of the reference clock.
//
// 
//                    There are 3 counters running on local clocks for both 
//                    recovered clocks and one for the reference clock.  The
//                    COUNTER_UPPER_VALUE parameter is the width of these
//                    counters. The PPM offset is checked when these counters 
//                    roll over.
//                    
//                    There is also a counter running on the system clock.
//                    This can be running at a much lower frequency and is
//                    running on a BUFG.  
//
//                    To set the parameters correctly here is what you need to
//                    do.  Lets assume taht the reference and recovered
//                    clocks are running at 156MHz and the system clock is
//                    running at 50MHz.
//
//                    To ensure that the interval is long enough we want to
//                    to make the COUNTER_UPPER_VALUE to be reasonable.  The
//                    CLOCK_PULSES is the number of sytem clock cycles we can
//                    expect to be off based on these frequencies:
//
//                    Example: Rec Clk and Ref Clk 156MHz, System clock 50MHz
//                             PPM Offset to tolerate +/- 5000PPM
//
//                    COUNTER_UPPER_VALUE = 15 -> 2^15 counter = 32768
//                    GCLK_COUNTER_UPPER_VALUE = 15 -> 2^15 counter = 32768
//
//                    PPM OFFSET = 5000 => 32768 * 5000/1000000 = 164
//
//                    Now we are using the system clock to do the
//                    calculations, therfore we need to scale the PPM_OFFSET
//                    accordingly.
//
//                    CLOCK_PULSES = PPM_OFFSET * sysclk_freq/refclk_freq 
//                                 = 164 * 50/156 = 52
//
//                    
//                    When the counters are checked if they are off by less
//                    than 52, we can delcare that the particular RECCLK is
//                    stable. 
//
//                    All FFs that have the _meta are metastability FFs and
//                    can be ignored from a timing perspective. The following
//                    constraint can be added to the UCF to ensure that they
//                    are ignored:
//                    
//                    INST "*_meta" TNM = "METASTABILITY_FFS";
//                    TIMESPEC "TS_METASTABILITY" = FROM FFS TO "METASTABILITY_FFS" TIG;
//
// Module daq_link_rx_RECCLK_MONITOR
// Generated by Xilinx 7 Series FPGAs Transceivers Wizard
// 
// 
// (c) Copyright 2010-2012 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES. 


//*******************************************************************************


`timescale 1ns / 1ps
`define DLY #1


module daq_link_rx_RECCLK_MONITOR #
(
   parameter COUNTER_UPPER_VALUE       = 20, //ppm counter. For 2^20 counter. 
   parameter GCLK_COUNTER_UPPER_VALUE  = 20, //ppm counter. For 2^20 counter. 
   parameter CLOCK_PULSES 	       = 5000,
   parameter EXAMPLE_SIMULATION        = 0
)
(
   input  wire            GT_RST,               // Active high async reset.
   input  wire		  REF_CLK,    
   input  wire 		  RX_REC_CLK0,
   input  wire		  SYSTEM_CLK,
   input  wire		  PLL_LK_DET,
   output wire		  RECCLK_STABLE,
   output reg             EXEC_RESTART
);


//===============================================================================
// Register/Wire declaration
//===============================================================================
localparam WAIT_FOR_LOCK = 6'b00_0001;
localparam REFCLK_EVENT  = 6'b00_0010;
localparam CALC_PPM_DIFF = 6'b00_0100;
localparam CHECK_SIGN    = 6'b00_1000;
localparam COMP_CNTR     = 6'b01_0000;
localparam RESTART       = 6'b10_0000;

reg [COUNTER_UPPER_VALUE -1 :0] ref_clk_cnt;
reg [COUNTER_UPPER_VALUE -1 :0] rec_clk0_cnt;
reg [2:1] rec_clk0_msb; 
reg [2:1] ref_clk_msb;
reg       rec_clk_0_msb_meta /*synthesis syn_keep = 1 */;
reg       ref_clk_msb_meta /*synthesis syn_keep = 1 */;
reg [GCLK_COUNTER_UPPER_VALUE -1 :0] sys_clk_counter; 
reg [GCLK_COUNTER_UPPER_VALUE -1 :0] rec_clk0_compare_cnt_latch; 
reg [GCLK_COUNTER_UPPER_VALUE -1 :0] ref_clk_compare_cnt_latch; 

reg       g_clk_rst_meta /*synthesis syn_keep = 1 */;
reg       g_clk_rst_sync;
reg       gt_pll_locked_meta /*synthesis syn_keep = 1 */;
reg       gt_pll_locked_sync;

reg       reset_logic_rec0_meta /*synthesis syn_keep = 1 */;
reg       reset_logic_rec0_sync;
reg       reset_logic_ref_meta /*synthesis syn_keep = 1 */;
reg       reset_logic_ref_sync;


reg [5:0] state;

reg        rec_clk0_edge_event;	
reg [1:0]  ref_clk_edge_event;
reg [GCLK_COUNTER_UPPER_VALUE -1 : 0] ppm0;
reg        recclk_stable0_int;
reg        recclk_stable0;
reg  [3:0] reset_logic;
wire       rec_clk0_edge;
wire       ref_clk_edge;
reg  [1:0] ref_clk_edge_rt;

wire       g_clk_rst;


//===============================================================================
// Main Logic 
//===============================================================================
always @ (posedge RX_REC_CLK0) begin
   reset_logic_rec0_meta <= `DLY  reset_logic[3];
   reset_logic_rec0_sync <= `DLY  reset_logic_rec0_meta;
end

always @ (posedge RX_REC_CLK0) begin
	if (reset_logic_rec0_sync) begin
	   rec_clk0_cnt <= `DLY  'h0;
	end
	else begin
	   rec_clk0_cnt <= `DLY  rec_clk0_cnt +1;
	end
end


always @ (posedge REF_CLK) begin
   reset_logic_ref_meta <= `DLY  reset_logic[3];
   reset_logic_ref_sync <= `DLY  reset_logic_ref_meta;
end

always @ (posedge REF_CLK) begin
	if (reset_logic_ref_sync) 
	   ref_clk_cnt <= `DLY  'h0;
	else begin
	   ref_clk_cnt <= `DLY  ref_clk_cnt +1;
	end
end
//===============================================================================
// PPM Monitor
//===============================================================================
/*
We will also need 3 counters running on a global clock, one corresponding to each of the local counters.  For this example I will use a 50MHz clock, but it can be anything.  We use the global clock to sample the 20th bit of the local counter, it has to be sampled twice for metastability.  Whenever we detect a falling edge on that signal, it means that the counter has rolled over.  We use this to latch the current count value to FFs and reset the counter.  Now you have the amount of time it took to count ~1M clock cycles.  In an ideal world, this would be 6.7ms or 335,602 50MHz clock periods.  You would do the same for the reference clock and then you could compare both counts and ensure that the difference is less than 1,678 (33.55us), if its not then you know you?ve exceeded your PPM limit.  All the counts could be set as parameters and could easily be adjusted based on the global clock frequency and the PPM offset required.
*/

// Synchronize reset to global Clock domain
always @ (posedge SYSTEM_CLK) begin	
  g_clk_rst_meta <= `DLY  GT_RST;
  g_clk_rst_sync <= `DLY  g_clk_rst_meta;

  gt_pll_locked_meta <= `DLY  PLL_LK_DET;
  gt_pll_locked_sync <= `DLY  gt_pll_locked_meta;

end

assign g_clk_rst = g_clk_rst_sync;
assign gt_pll_locked = gt_pll_locked_sync;

generate
if (EXAMPLE_SIMULATION==0 ) 
begin : HW_CIRCUITRY

// Main FSM
always @ (posedge SYSTEM_CLK) 
begin
	if (g_clk_rst) begin
		state <= `DLY   WAIT_FOR_LOCK;
		ppm0 <= `DLY  {GCLK_COUNTER_UPPER_VALUE-1 {1'b1}};
		recclk_stable0 <= `DLY  1'b0;
                EXEC_RESTART   <= `DLY  1'b0;
	end
	else begin
                EXEC_RESTART   <= `DLY  1'b0;
		case (state)
			WAIT_FOR_LOCK: begin
				if (gt_pll_locked) begin
					if (ref_clk_edge_event == 2'b01) state <= `DLY  REFCLK_EVENT;
					else state <= `DLY  WAIT_FOR_LOCK;
				end
				else begin 
					state <= `DLY  WAIT_FOR_LOCK;
				end
			end
			REFCLK_EVENT: begin
				if (ref_clk_edge_event == 2'b11) begin // two reference couter periods
					state <= `DLY  CALC_PPM_DIFF;
				end
				else begin
					state <= `DLY  REFCLK_EVENT;
				end
			end
			CALC_PPM_DIFF: begin
				if (rec_clk0_edge_event) begin
					ppm0 <= `DLY  rec_clk0_compare_cnt_latch + ref_clk_compare_cnt_latch;			
				end
				state <= `DLY  CHECK_SIGN;
				
			end
			CHECK_SIGN: begin
				//check the sign bit - if 1'b1, then convert to binary.
				if (ppm0[GCLK_COUNTER_UPPER_VALUE-1]) ppm0 <= `DLY  ~ppm0 +1;
				state <= `DLY  COMP_CNTR;

			end
			COMP_CNTR: begin
				if (ppm0 < CLOCK_PULSES) 
				   recclk_stable0 <= `DLY  1'b1; 
			        else
				   recclk_stable0 <= `DLY  1'b0; 

			        state <= `DLY  RESTART;	
			end
			RESTART: begin
				state         <= `DLY  WAIT_FOR_LOCK;
                                EXEC_RESTART   <= `DLY  1'b1;
			end
			default: begin
	       	           state <= `DLY   WAIT_FOR_LOCK;
		           ppm0 <= `DLY  {GCLK_COUNTER_UPPER_VALUE-1 {1'b1}};
		           recclk_stable0 <= `DLY  1'b0;
			end
		endcase
	end

end


// On clock roll-over, latch counter value once and event occurance.
always @ (posedge SYSTEM_CLK)
begin
	if (reset_logic[3]) begin
	        rec_clk0_edge_event <= `DLY  1'b0;
	        ref_clk_edge_event <= `DLY   2'b00;
		rec_clk0_compare_cnt_latch <= `DLY  'h0;
		ref_clk_compare_cnt_latch <= `DLY  'h0;
		ref_clk_edge_rt <= `DLY  2'b00;
	end
	else begin
		if (rec_clk0_edge & (~rec_clk0_edge_event) ) begin 
	        	rec_clk0_edge_event <= `DLY  1'b1;	
			rec_clk0_compare_cnt_latch <= `DLY  sys_clk_counter; 
		end
		if (ref_clk_edge) begin
	        	ref_clk_edge_event <= `DLY  {ref_clk_edge_event,1'b1};
			//only latch it the first time around
		        if (~ref_clk_edge_event[0])	
  			   ref_clk_compare_cnt_latch <= `DLY  sys_clk_counter; 
		end
                ref_clk_edge_rt <= `DLY  {ref_clk_edge_rt[0],ref_clk_edge};
		//take the 2's complement number after we latched it
		if ((ref_clk_edge_event == 2'b01) && (ref_clk_edge_rt==2'b01))
			ref_clk_compare_cnt_latch <= `DLY  (~ref_clk_compare_cnt_latch) +1;
	end
end

// increment clock counters'
always @ (posedge SYSTEM_CLK)
begin
	if (reset_logic[3]) begin
		sys_clk_counter <= `DLY  {GCLK_COUNTER_UPPER_VALUE{1'b0}};
	end
	else begin
		sys_clk_counter <= `DLY  sys_clk_counter + 1;
	end
end

always @ (posedge SYSTEM_CLK)
begin
	if (reset_logic[3]) begin
		
           rec_clk_0_msb_meta <= `DLY  1'b0;
           ref_clk_msb_meta   <= `DLY  1'b0;
	   rec_clk0_msb       <= `DLY  2'b00;
	   ref_clk_msb        <= `DLY  2'b00;
	end
	else begin // double flop msb count bit to system clock domain
		rec_clk_0_msb_meta <= `DLY  rec_clk0_cnt[COUNTER_UPPER_VALUE-1];
		rec_clk0_msb <= `DLY  {rec_clk0_msb[1],rec_clk_0_msb_meta};

		ref_clk_msb_meta <= `DLY  ref_clk_cnt[COUNTER_UPPER_VALUE-1];
		ref_clk_msb <= `DLY  {ref_clk_msb[1],ref_clk_msb_meta};
	end
end
//falling edge detect
assign rec_clk0_edge = (rec_clk0_msb[2] && ~rec_clk0_msb[1]);
assign ref_clk_edge = (ref_clk_msb[2] && ~ref_clk_msb[1]);

// Manage counter reset/restart
always @ (posedge SYSTEM_CLK)
begin
	if (g_clk_rst) begin
		reset_logic <= `DLY  'hf;
	end
	else begin
		if (state == RESTART) reset_logic <= `DLY  4'b1111;
		else reset_logic <= `DLY  reset_logic << 1;

	end

end

   assign RECCLK_STABLE = recclk_stable0;

end
endgenerate

generate
    if (EXAMPLE_SIMULATION == 1)
    begin:sim

    //This Generate-branch is ONLY FOR SIMULATION and is not implemented in HW.
    //The whole purpose of this shortcut-branch is to avoid huge simulation-
    //times.
    always @(posedge SYSTEM_CLK)
    begin
        if( GT_RST)
          recclk_stable0_int <= `DLY  1'b0;
        else
          recclk_stable0_int <= `DLY  PLL_LK_DET;
    end

    assign RECCLK_STABLE = recclk_stable0_int;
    
    end    
endgenerate


endmodule

