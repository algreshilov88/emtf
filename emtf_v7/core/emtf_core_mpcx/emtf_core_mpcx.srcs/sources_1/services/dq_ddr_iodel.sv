// file: dq_ddr_iodel.v
// (c) Copyright 2009 - 2011 Xilinx, Inc. All rights reserved.
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
//----------------------------------------------------------------------------
// User entered comments
//----------------------------------------------------------------------------
// None
//----------------------------------------------------------------------------

`timescale 1ps/1ps

(* CORE_GENERATION_INFO = "dq_ddr_iodel,selectio_wiz_v4_1,{component_name=dq_ddr_iodel,bus_dir=BIDIR,\
bus_sig_type=SINGLE,bus_io_std=LVCMOS12,use_serialization=false,use_phase_detector=false,serialization_factor=4,\
enable_bitslip=false,enable_train=false,system_data_width=9,bus_in_delay=NONE,bus_out_delay=NONE,\
clk_sig_type=SINGLE,clk_io_std=LVCMOS18,clk_buf=BUFIO2,active_edge=RISING,clk_delay=FIXED,\
v6_bus_in_delay=VAR_LOADABLE,v6_bus_out_delay=VAR_LOADABLE,v6_clk_buf=BUFIO,v6_active_edge=DDR,\
v6_ddr_alignment=SAME_EDGE_PIPELINED,v6_oddr_alignment=SAME_EDGE,ddr_alignment=C0,v6_interface_type=NETWORKING,\
interface_type=NETWORKING,v6_bus_in_tap=0,v6_bus_out_tap=0,v6_clk_io_std=LVCMOS12,v6_clk_sig_type=SINGLE}" *)

module dq_ddr_iodel
   // width of the data for the system
 #(parameter sys_w = 9,
   // width of the data for the device
   parameter dev_w = 18)
 (
  inout  [sys_w-1:0] DATA_TO_AND_FROM_PINS,
  output [dev_w-1:0] DATA_IN_TO_DEVICE,
  // From the device out to the system
  input  [dev_w-1:0] DATA_OUT_FROM_DEVICE,
  input              DELAY_CLK,
  input              IN_DELAY_RESET,                        // Active high synchronous reset for input delay
  input  [sys_w -1 :0] IN_DELAY_DATA_CE,                      // Enable signal for delay
  input  [sys_w -1 :0] IN_DELAY_DATA_INC,                     // Delay increment (high), decrement (low) signal
  input              OUT_DELAY_RESET,                       // Active high synchronous reset for output delay
  input  [sys_w -1 :0] OUT_DELAY_DATA_CE,                     // Enable signal for delay
  input  [sys_w -1 :0] OUT_DELAY_DATA_INC,                    // Delay increment (high), decrement (low) signal
  input  [5*sys_w -1:0]       IN_DELAY_TAP_IN,      // Dynamically loadable delay tap value for input delay
  output [5*sys_w -1:0]       IN_DELAY_TAP_OUT,     // Delay tap value for monitoring input delay
  input  [5*sys_w -1:0]       OUT_DELAY_TAP_IN,     // Dynamically loadable delay tap value for output delay
  output [5*sys_w -1:0]       OUT_DELAY_TAP_OUT,    // Delay tap value for monitoring output delay
  input              REF_CLOCK,      // Reference clock for IDELAYCTRL. Has to come from BUFG.
  input              TRISTATE_OUTPUT,
  input              CLK_IN,        // Single ended clock from IOB
  input 			 clk200, // fabric clock
  output             CLK_OUT,
  input              IO_RESET);
  // Signal declarations
  ////------------------------------
  wire               clock_enable = 1'b1;
  // After the buffer
  wire   [sys_w-1:0] data_in_from_pins_int;
  // Between the delay and serdes
  wire [sys_w-1:0]  data_in_from_pins_delay;
  // Before the buffer
  wire   [sys_w-1:0] data_out_to_pins_int;
  // Between the delay and serdes
  wire   [sys_w-1:0] data_out_to_pins_predelay;
  // Before the buffer
  wire   [sys_w-1:0] tristate_int;
  // Between the delay and serdes
  wire   [sys_w-1:0] tristate_predelay;
  wire [sys_w-1:0] in_delay_ce;
  wire [sys_w-1:0] in_delay_inc_dec;
  wire [4:0]  in_delay_tap_in_int[0:sys_w - 1];   // fills in starting with 0
  wire [4:0]  in_delay_tap_out_int[0:sys_w - 1];   // fills in starting with 0
  wire [sys_w-1:0] out_delay_ce;
  wire [sys_w-1:0] out_delay_inc_dec;
  wire [4:0]  out_delay_tap_in_int[0:sys_w - 1];   // fills in starting with 0
  wire [4:0]  out_delay_tap_out_int[0:sys_w - 1];   // fills in starting with 0
   assign in_delay_ce = {                      IN_DELAY_DATA_CE[8],
                     IN_DELAY_DATA_CE[7],
                     IN_DELAY_DATA_CE[6],
                     IN_DELAY_DATA_CE[5],
                     IN_DELAY_DATA_CE[4],
                     IN_DELAY_DATA_CE[3],
                     IN_DELAY_DATA_CE[2],
                     IN_DELAY_DATA_CE[1],
                     IN_DELAY_DATA_CE[0]};
   assign in_delay_inc_dec = {                      IN_DELAY_DATA_INC[8],
                     IN_DELAY_DATA_INC[7],
                     IN_DELAY_DATA_INC[6],
                     IN_DELAY_DATA_INC[5],
                     IN_DELAY_DATA_INC[4],
                     IN_DELAY_DATA_INC[3],
                     IN_DELAY_DATA_INC[2],
                     IN_DELAY_DATA_INC[1],
                     IN_DELAY_DATA_INC[0]};
   assign in_delay_tap_in_int[0] = IN_DELAY_TAP_IN[5*(0 + 1) -1:5*(0)] ;
   assign in_delay_tap_in_int[1] = IN_DELAY_TAP_IN[5*(1 + 1) -1:5*(1)] ;
   assign in_delay_tap_in_int[2] = IN_DELAY_TAP_IN[5*(2 + 1) -1:5*(2)] ;
   assign in_delay_tap_in_int[3] = IN_DELAY_TAP_IN[5*(3 + 1) -1:5*(3)] ;
   assign in_delay_tap_in_int[4] = IN_DELAY_TAP_IN[5*(4 + 1) -1:5*(4)] ;
   assign in_delay_tap_in_int[5] = IN_DELAY_TAP_IN[5*(5 + 1) -1:5*(5)] ;
   assign in_delay_tap_in_int[6] = IN_DELAY_TAP_IN[5*(6 + 1) -1:5*(6)] ;
   assign in_delay_tap_in_int[7] = IN_DELAY_TAP_IN[5*(7 + 1) -1:5*(7)] ;
   assign in_delay_tap_in_int[8] = IN_DELAY_TAP_IN[5*(8 + 1) -1:5*(8)] ;
   assign IN_DELAY_TAP_OUT[5*(0 + 1) -1:5*(0)] = in_delay_tap_out_int[0];
   assign IN_DELAY_TAP_OUT[5*(1 + 1) -1:5*(1)] = in_delay_tap_out_int[1];
   assign IN_DELAY_TAP_OUT[5*(2 + 1) -1:5*(2)] = in_delay_tap_out_int[2];
   assign IN_DELAY_TAP_OUT[5*(3 + 1) -1:5*(3)] = in_delay_tap_out_int[3];
   assign IN_DELAY_TAP_OUT[5*(4 + 1) -1:5*(4)] = in_delay_tap_out_int[4];
   assign IN_DELAY_TAP_OUT[5*(5 + 1) -1:5*(5)] = in_delay_tap_out_int[5];
   assign IN_DELAY_TAP_OUT[5*(6 + 1) -1:5*(6)] = in_delay_tap_out_int[6];
   assign IN_DELAY_TAP_OUT[5*(7 + 1) -1:5*(7)] = in_delay_tap_out_int[7];
   assign IN_DELAY_TAP_OUT[5*(8 + 1) -1:5*(8)] = in_delay_tap_out_int[8];
   assign out_delay_ce = {                      OUT_DELAY_DATA_CE[8],
                     OUT_DELAY_DATA_CE[7],
                     OUT_DELAY_DATA_CE[6],
                     OUT_DELAY_DATA_CE[5],
                     OUT_DELAY_DATA_CE[4],
                     OUT_DELAY_DATA_CE[3],
                     OUT_DELAY_DATA_CE[2],
                     OUT_DELAY_DATA_CE[1],
                     OUT_DELAY_DATA_CE[0]};
   assign out_delay_inc_dec = {                      OUT_DELAY_DATA_INC[8],
                     OUT_DELAY_DATA_INC[7],
                     OUT_DELAY_DATA_INC[6],
                     OUT_DELAY_DATA_INC[5],
                     OUT_DELAY_DATA_INC[4],
                     OUT_DELAY_DATA_INC[3],
                     OUT_DELAY_DATA_INC[2],
                     OUT_DELAY_DATA_INC[1],
                     OUT_DELAY_DATA_INC[0]};
   assign out_delay_tap_in_int[0] = OUT_DELAY_TAP_IN[5*(0 + 1) -1:5*(0)];
   assign out_delay_tap_in_int[1] = OUT_DELAY_TAP_IN[5*(1 + 1) -1:5*(1)];
   assign out_delay_tap_in_int[2] = OUT_DELAY_TAP_IN[5*(2 + 1) -1:5*(2)];
   assign out_delay_tap_in_int[3] = OUT_DELAY_TAP_IN[5*(3 + 1) -1:5*(3)];
   assign out_delay_tap_in_int[4] = OUT_DELAY_TAP_IN[5*(4 + 1) -1:5*(4)];
   assign out_delay_tap_in_int[5] = OUT_DELAY_TAP_IN[5*(5 + 1) -1:5*(5)];
   assign out_delay_tap_in_int[6] = OUT_DELAY_TAP_IN[5*(6 + 1) -1:5*(6)];
   assign out_delay_tap_in_int[7] = OUT_DELAY_TAP_IN[5*(7 + 1) -1:5*(7)];
   assign out_delay_tap_in_int[8] = OUT_DELAY_TAP_IN[5*(8 + 1) -1:5*(8)];
   assign OUT_DELAY_TAP_OUT[5*(0 + 1) -1:5*(0)] = out_delay_tap_out_int[0];
   assign OUT_DELAY_TAP_OUT[5*(1 + 1) -1:5*(1)] = out_delay_tap_out_int[1];
   assign OUT_DELAY_TAP_OUT[5*(2 + 1) -1:5*(2)] = out_delay_tap_out_int[2];
   assign OUT_DELAY_TAP_OUT[5*(3 + 1) -1:5*(3)] = out_delay_tap_out_int[3];
   assign OUT_DELAY_TAP_OUT[5*(4 + 1) -1:5*(4)] = out_delay_tap_out_int[4];
   assign OUT_DELAY_TAP_OUT[5*(5 + 1) -1:5*(5)] = out_delay_tap_out_int[5];
   assign OUT_DELAY_TAP_OUT[5*(6 + 1) -1:5*(6)] = out_delay_tap_out_int[6];
   assign OUT_DELAY_TAP_OUT[5*(7 + 1) -1:5*(7)] = out_delay_tap_out_int[7];
   assign OUT_DELAY_TAP_OUT[5*(8 + 1) -1:5*(8)] = out_delay_tap_out_int[8];
  // Create the clock logic

	wire clk_div;
// High Speed BUFIO clock buffer
/*
 BUFIO bufio_inst
   (.O(clk_in_int_buf),
    .I(clk_in_int_delay));

  
   // BUFR generates the slow clock
   BUFR
    #(.SIM_DEVICE("7SERIES"),
    .BUFR_DIVIDE("BYPASS"))
    clkout_buf_inst
    (.O (clk_div),
     .CE(),
     .CLR(),
     .I (clk_in_int_delay));
*/
	assign clk_div = CLK_IN;

   assign CLK_OUT = clk_div; // This is regional clock;

  // We have multiple bits- step over every bit, instantiating the required elements
  genvar pin_count;
  generate for (pin_count = 0; pin_count < sys_w; pin_count = pin_count + 1) begin: pins
    // Instantiate the buffers
    ////------------------------------
    // Instantiate a buffer for every bit of the data bus
    IOBUF
      #(.IOSTANDARD ("LVCMOS12"))
     iobuf_inst
       (.IO         (DATA_TO_AND_FROM_PINS[pin_count]),
        .I          (data_out_to_pins_int [pin_count]),
        .O          (data_in_from_pins_int[pin_count]),
        .T          (tristate_int         [pin_count]));

    // Instantiate the delay primitive
    ////-------------------------------

//     (* IODELAY_GROUP = "dq_ddr_iodel_group" *)
     IDELAYE2
       # (
         .CINVCTRL_SEL           ("FALSE"),                            // TRUE, FALSE
         .DELAY_SRC              ("IDATAIN"),                          // IDATAIN, DATAIN
         .HIGH_PERFORMANCE_MODE  ("FALSE"),                            // TRUE, FALSE
         .IDELAY_TYPE            ("VAR_LOAD"),              // FIXED, VARIABLE, or VAR_LOADABLE
         .IDELAY_VALUE           (0),                  // 0 to 31
         .REFCLK_FREQUENCY       (200.0),
         .PIPE_SEL               ("FALSE"),
         .SIGNAL_PATTERN         ("DATA"))                             // CLOCK, DATA
       idelaye2_bus
           (
         .DATAOUT                (data_in_from_pins_delay[pin_count]),
         .DATAIN                 (1'b0),                               // Data from FPGA logic
         .C                      (DELAY_CLK),
         .CE                     (in_delay_ce[pin_count]), //(IN_DELAY_DATA_CE),
         .INC                    (in_delay_inc_dec[pin_count]), //IN_DELAY_DATA_INC),
         .IDATAIN                (data_in_from_pins_int  [pin_count]), // Driven by IOB
         .LD                     (IN_DELAY_RESET),
         .REGRST                 (IO_RESET),
         .LDPIPEEN               (1'b0),
         .CNTVALUEIN             (in_delay_tap_in_int[pin_count]), //IN_DELAY_TAP_IN),
         .CNTVALUEOUT            (in_delay_tap_out_int[pin_count]), //IN_DELAY_TAP_OUT),
         .CINVCTRL               (1'b0)
         );

//     (* IODELAY_GROUP = "dq_ddr_iodel_group" *)
     ODELAYE2
       # (
         .CINVCTRL_SEL           ("FALSE"),                            // TRUE, FALSE
         .DELAY_SRC              ("ODATAIN"),                          // ODATAIN, CLKIN
         .HIGH_PERFORMANCE_MODE  ("FALSE"),                            // TRUE, FALSE
         .ODELAY_TYPE            ("VAR_LOAD"),             // FIXED, VARIABLE, or VAR_LOADABLE
         .ODELAY_VALUE           (0),                 // 0 to 31
         .REFCLK_FREQUENCY       (200.0),
         .PIPE_SEL               ("FALSE"),
         .SIGNAL_PATTERN         ("DATA")                              // CLOCK, DATA
         )
       odelaye2_bus (
         .DATAOUT                (data_out_to_pins_int[pin_count]),
         .CLKIN                  (1'b0),
         .C                      (DELAY_CLK),
         .CE                     (out_delay_ce[pin_count]), //OUT_DELAY_DATA_CE),
         .INC                    (out_delay_inc_dec[pin_count]), //OUT_DELAY_DATA_INC),
         .ODATAIN                (data_out_to_pins_predelay[pin_count]), // Driven by OLOGIC/OSERDES
         .LD                     (OUT_DELAY_RESET),
         .REGRST                 (IO_RESET),
         .LDPIPEEN               (1'b0),
         .CNTVALUEIN             (out_delay_tap_in_int[pin_count]), //OUT_DELAY_TAP_IN),
         .CNTVALUEOUT            (out_delay_tap_out_int[pin_count]), //OUT_DELAY_TAP_OUT),
         .CINVCTRL               (1'b0)
         );

           assign tristate_int[pin_count] = tristate_predelay[pin_count];
    // Connect the delayed data to the fabric
    ////--------------------------------------
   // DDR register instantation
    IDDR
     #(.DDR_CLK_EDGE   ("SAME_EDGE_PIPELINED"), //"OPPOSITE_EDGE", "SAME_EDGE, "SAME_EDGE_PIPELINED
       .INIT_Q1        (1'b0),
       .INIT_Q2        (1'b0),
       .SRTYPE         ("ASYNC"))
     iddr_inst
      (.Q1             (DATA_IN_TO_DEVICE[pin_count]),
       .Q2             (DATA_IN_TO_DEVICE[sys_w + pin_count]),
       .C              (clk_div),
       .CE             (clock_enable),
       .D              (data_in_from_pins_delay[pin_count]),
       .R              (IO_RESET),
       .S              (1'b0));

    ODDR
     #(.DDR_CLK_EDGE   ("SAME_EDGE"), //"OPPOSITE_EDGE"  "SAME_EDGE
       .INIT           (1'b0),
       .SRTYPE         ("ASYNC"))
     oddr_inst
      (.D1             (DATA_OUT_FROM_DEVICE[pin_count]),
       .D2             (DATA_OUT_FROM_DEVICE[sys_w + pin_count]),
       .C              (clk200),
       .CE             (clock_enable),
       .Q              (data_out_to_pins_predelay[pin_count]),
       .R              (IO_RESET),
       .S              (1'b0));

    ODDR
     #(.DDR_CLK_EDGE   ("SAME_EDGE"), //"OPPOSITE_EDGE" "SAME_EDGE
       .INIT           (1'b0),
       .SRTYPE         ("ASYNC"))
     oddr_tri_inst
      (.D1             (TRISTATE_OUTPUT),
       .D2             (TRISTATE_OUTPUT),
       .C              (clk200),
       .CE             (clock_enable),
       .Q              (tristate_predelay[pin_count]),
       .R              (IO_RESET),
       .S              (1'b0));
  end
  endgenerate

// IDELAYCTRL is needed for calibration
//(* IODELAY_GROUP = "dq_ddr_iodel_group" *)
//  IDELAYCTRL
//    delayctrl (
//     .RDY    (DELAY_LOCKED),
//     .REFCLK (REF_CLOCK),
//     .RST    (IO_RESET));
endmodule
