`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/22/2015 11:06:05 AM
// Design Name: 
// Module Name: amc13_link_tx_top
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


module amc13_link_tx
(
    // serial link
    input  refclk,
    input  drp_clk,
    input  RXN_IN,
    input  RXP_IN,
    output TXN_OUT,
    output TXP_OUT,
    
    // inputs from receiver in control FPGA
    input k_rxresetdone,
    input [1:0] k_rxnotintable,
    input [1:0] k_rxchariscomma,
    input [1:0] k_rxcharisk,
    input [15:0] k_rxdata,
    input k_rx_clk,
    
    // TTS interface (aka FMM)
    input tts_clk, 
    input [3:0] tts_data,
    input resync_and_empty,

    // DAQ data interface
    input ev_data_clk, // in  ;
    input ev_data_valid, // in  ; // used as data write enable
    input ev_data_header, // in  ; // first data word
    input ev_data_trailer, // in  ; // last data word
    input [63:0] ev_data, // in   (63 : 0);
    output daq_ready,
    
    output [31:0] amc13_status_cnt,
    
    input reset,
    input cnt_reset
);

    wire usr_clk;
    (* mark_debug = "FALSE" *) wire [1:0] txcharisk;
    (* mark_debug = "FALSE" *) wire [15:0] txdata;
    wire reset_w = reset;
    wire k_rxresetdone_w = k_rxresetdone;

    (* mark_debug = "FALSE" *) wire [1:0] k_rxnotintable_r;
    (* mark_debug = "FALSE" *) wire [1:0] k_rxchariscomma_r;
    (* mark_debug = "FALSE" *) wire [1:0] k_rxcharisk_r;
    (* mark_debug = "FALSE" *) wire [15:0] k_rxdata_r;
    
    (* mark_debug = "FALSE" *) reg [1:0] k_rxnotintable_rr;
    (* mark_debug = "FALSE" *) reg [1:0] k_rxchariscomma_rr;
    (* mark_debug = "FALSE" *) reg [1:0] k_rxcharisk_rr;
    (* mark_debug = "FALSE" *) reg [15:0] k_rxdata_rr;

    reg [1:0] k_rxnotintable_t;
    reg [1:0] k_rxchariscomma_t;
    reg [1:0] k_rxcharisk_t;
    reg [15:0] k_rxdata_t;
    
    reg [1:0] k_rxnotintable_tt;
    reg [1:0] k_rxchariscomma_tt;
    reg [1:0] k_rxcharisk_tt;
    reg [15:0] k_rxdata_tt;
    
    (* mark_debug = "FALSE" *) wire [1:0] k_rxnotintable_tw = k_rxnotintable_t;
    (* mark_debug = "FALSE" *) wire [1:0] k_rxchariscomma_tw = k_rxchariscomma_t;
    (* mark_debug = "FALSE" *) wire [1:0] k_rxcharisk_tw = k_rxcharisk_t;
    (* mark_debug = "FALSE" *) wire [15:0] k_rxdata_tw = k_rxdata_t;
    
    wire gt0_txresetdone_i;
    
    (* mark_debug = "FALSE" *) wire full, empty, underflow;
    
    reg [2:0] usr_clk_cnt;
    (* mark_debug = "FALSE" *) wire usr_clk_div = usr_clk_cnt[2];
    always @(posedge usr_clk) usr_clk_cnt = usr_clk_cnt + 1;
    
    wire k_rx_clk_b;
//    IBUFG k_rx_bufg (.I(k_rx_clk), .O(k_rx_clk_b));


    wire almost_full, ready;
    reg [15:0] almost_full_cnt, ready_cnt;
    assign daq_ready = ready && (!almost_full);

    daq_link_tx_exdes gth_tx
    (
        .Q0_CLK1_GTREFCLK (refclk),
        .drp_clk (drp_clk),
        .RXN_IN (RXN_IN),
        .RXP_IN (RXP_IN),
        .TXN_OUT (TXN_OUT),
        .TXP_OUT (TXP_OUT),
    
        .gt0_txcharisk_i (txcharisk),
        .gt0_txdata_i (txdata),
        .gt0_txusrclk_i (usr_clk),
        
        .soft_reset_i (reset),
        .gt0_txresetdone_i (gt0_txresetdone_i)
         
    );

    DAQ_LINK_7S #(.SIMULATION(1'B0)) DAQ_LINK_7S_I
    ( 
        .RESET (!gt0_txresetdone_i), // IN ASYNCHRONOUS RESET, ASSERT RESET UNTIL GTX REFCLK STABLE
        .USE_TRIGGER_PORT (1'B0), // IN
        // MGT SIGNALS
        .USRCLK (usr_clk), // IN  ; // IT MUST HAVE A FREQUENCY OF 250MHZ
        .CPLLLOCK (gt0_txresetdone_i), // IN  ;
        .RXRESETDONE (k_rxresetdone), // IN  ;
        .TXFSMRESETDONE (gt0_txresetdone_i), // IN  ;
        
        .RXNOTINTABLE (k_rxnotintable_rr), // IN   (1 : 0);
        .RXCHARISCOMMA (k_rxchariscomma_rr), // IN   (1 : 0);
        .RXCHARISK (k_rxcharisk_rr), // IN   (1 : 0);
        .RXDATA (k_rxdata_rr), // IN   (15 : 0);
        
        .TXCHARISK (txcharisk), // OUT   (1 : 0);
        .TXDATA (txdata), // OUT   (15 : 0);
        
        // TRIGGER PORT
        .TTCCLK (tts_clk), // IN  ;
        .BCNTRES (1'B0), // IN  ;
        .TRIG (8'H0), // IN   (7 : 0);
        // TTS PORT
        .TTSCLK (tts_clk), // IN  ; // CLOCK SOURCE WHICH CLOCKS TTS SIGNALS
        .TTS (tts_data), // IN   (3 : 0);
        .ReSyncAndEmpty (resync_and_empty),
        // DATA PORT
        .EVENTDATACLK (ev_data_clk), // IN  ;
        .EVENTDATA_VALID (ev_data_valid), // IN  ; // USED AS DATA WRITE ENABLE
        .EVENTDATA_HEADER (ev_data_header), // IN  ; // FIRST DATA WORD
        .EVENTDATA_TRAILER (ev_data_trailer), // IN  ; // LAST DATA WORD
        .EVENTDATA (ev_data), // IN   (63 : 0);
        .ALMOSTFULL (almost_full), // OUT  ; // BUFFER ALMOST FULL
        .READY (ready), // OUT  ;
        .SYSCLK (usr_clk), // IN  ;
        .L1A_DATA_WE (), // OUT  ; // LAST DATA WORD
        .L1A_DATA () // OUT   (15 : 0)
    );    

    reg daq_rx_fifo_we; 

    always @(posedge k_rx_clk_b)
    begin
        k_rxnotintable_tt = k_rxnotintable_t;
        k_rxchariscomma_tt = k_rxchariscomma_t;
        k_rxcharisk_tt = k_rxcharisk_t;
        k_rxdata_tt = k_rxdata_t;
        daq_rx_fifo_we = !(k_rxdata_t == 16'hdcfb && k_rxcharisk_t == 2'h3); // don't write clock correction

        k_rxnotintable_t = k_rxnotintable;
        k_rxchariscomma_t = k_rxchariscomma;
        k_rxcharisk_t = k_rxcharisk;
        k_rxdata_t = k_rxdata;


    end

    assign amc13_status_cnt = {almost_full_cnt, ready_cnt};
    reg almost_full_rr, almost_full_r, ready_rr, ready_r;

    always @(posedge usr_clk)
    begin
        if (underflow)
        begin
            // in case of fifo underflow, fill with clock correction
            {k_rxnotintable_rr, k_rxchariscomma_rr, k_rxcharisk_rr, k_rxdata_rr} = 
            {2'h0, 2'h0, 3'h3, 16'hdcfb};
        end
        else
        begin
            {k_rxnotintable_rr, k_rxchariscomma_rr, k_rxcharisk_rr, k_rxdata_rr} = 
            {k_rxnotintable_r, k_rxchariscomma_r, k_rxcharisk_r, k_rxdata_r};
        end
        
        if (cnt_reset)
        begin
            // reset AMC13 status counters on core link reset
            almost_full_cnt = 16'h0;
            ready_cnt = 16'h0;
        end
        else
        begin
            if (!almost_full_rr && almost_full_r) // almost full flag just rose
                almost_full_cnt = almost_full_cnt + 16'h1;
                
            if (ready_rr && !ready_r) // ready flag just fell
                ready_cnt = ready_cnt + 16'h1; 
        end
        almost_full_rr = almost_full_r;
        almost_full_r = almost_full;
        ready_rr = ready_r;
        ready_r = ready;
    end


    daq_rx_fifo drf 
    (
        .rst(reset),                // input wire rst
        .wr_clk(k_rx_clk_b),          // input wire wr_clk
        .rd_clk(usr_clk),          // input wire rd_clk
        .din({k_rxnotintable_tt, k_rxchariscomma_tt, k_rxcharisk_tt, k_rxdata_tt}),                // input wire [21 : 0] din
        .wr_en(daq_rx_fifo_we),            // input wire wr_en
        .rd_en(1'b1),            // input wire rd_en
        .dout({k_rxnotintable_r, k_rxchariscomma_r, k_rxcharisk_r, k_rxdata_r}),              // output wire [21 : 0] dout
        .full(full),              // output wire full
        .empty(empty),            // output wire empty
        .underflow(underflow)  // output wire underflow
    );

    k_rx_mmcm_ip k_rx_mmcm
    (
        .clk_in1(k_rx_clk),
        .clk_out1(k_rx_clk_b),
        .reset(reset),
        .locked()
    );      


endmodule
