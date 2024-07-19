module mpcx_tx
(
`ifdef SPARTAN6
    output [37:0] tx_data_gtp,
`else
    mgt_tx.out mgttx,
`endif
    input tx_clk, // tx clock common for several MGTs fed by the same refclk
    input [75:0] tx_data_76,
    input rst,
	input clk40,
	input clk320 // 320M clock derived from tx_clk
);

    (* mark_debug *) wire [37:0] tx_data_38_s, tx_data_38;
    (* mark_debug *) wire tx_gb_rdy;
    (* mark_debug *) wire frame_0;
    (* mark_debug *) wire [1:0] tx_header;
    reg [5:0] tx_header_cnt;

`ifdef SPARTAN6
    assign tx_data_gtp = {tx_header, tx_data_38_s};
`else    
    assign {
        mgttx.txdata         [31:24],
        mgttx.txchardispmode [2],
        mgttx.txchardispval  [2],
        mgttx.txdata         [23:16],
        mgttx.txchardispmode [1],
        mgttx.txchardispval  [1],
        mgttx.txdata         [15:8],
        mgttx.txchardispmode [0],
        mgttx.txchardispval  [0],
        mgttx.txdata         [7:0]
    } = tx_data_38_s;

    assign {
        mgttx.txchardispmode [3],
        mgttx.txchardispval  [3]
    } = tx_header;
`endif

    // transmit frame_0 marker only once per 64 BX, to prevent unlocking frame alignment in RX
    assign tx_header = 
        (rst == 1'b1) ? 2'b00 : // this is for header alignment tests on rx side 
        (frame_0 == 1'b1 && tx_header_cnt == 6'h0) ? 2'b10 : // frame_0 header
        2'b01; // regular header

    // count frame_0 markers
    always @(posedge tx_clk) if (frame_0 == 1'b1) tx_header_cnt = tx_header_cnt + 1;

    reg [37:0] tx_test;
    reg [19:0] cnt;
    always @(posedge tx_clk)
    begin
        tx_test = {cnt[19:1], cnt[19:1]};
        cnt = cnt + 1;
    end

    mpc_scrambler mpc_s 
    (
        .dtx (tx_data_38), // TX data to scramble
//        .dtx (tx_test),
        .stx (tx_data_38_s), // scrambled TX data
        .clk (tx_clk),
//        .rst (!tx_gb_rdy)
        .rst (1'b0)
    );
    
    tx_reclock txr
    (
        .din     (tx_data_76),
        .clk40   (clk40), 
        .dout    (tx_data_38),
        .frame_0 (frame_0),
        .clk80   (tx_clk),
        .clk320  (clk320) 
    );
        
    // local error check logic for predefined pattern (19-bit counters)
    reg [37:0] tx_r, tx_rr;
    wire [37:0] tx_next = tx_rr == 38'h3fffffffff ? 38'h0 : tx_rr + 38'b0000000000000000001_0000000000000000001;
    reg [1:0] err;
    (* mark_debug *) wire [1:0] err_w = err;
    always @(posedge tx_clk)
    begin
        err = 2'b0;
        if (tx_data_38 == tx_r) // same counter value in this word and previous
        begin
            // check if value changed as expected
            if (tx_r != tx_next)
            begin
                err[0] = 1'b1;
            end
        end
        else
        begin
            if (tx_rr != tx_r) // two previous values must match
                err[1] = 1'b1;
        end
        
        // keep history of the old rx word
        tx_rr = tx_r;
        tx_r = tx_data_38;
    end


    
//    txGearbox 
//    #(
//        .c_clockRatio  (2), // Clock ratio is clock_out / clock_in (shall be an integer)
//        .c_inputWidth  (76), // Bus size of the input word
//        .c_outputWidth (38), // Bus size of the output word (Warning: c_clockRatio/(c_inputWidth/c_outputWidth) shall be an integer)
//        .c_reset_dly   (4)    
//    )
//    tx_gb 
//    (
//        .clk_inClk_i    (clk40), // Input clock (frame clock)
//        .clk_clkEn_i    (1'b1), // Input clock enable when multicycle path or '1'
//        .clk_outClk_i   (tx_clk), // Output clock (from the MGT)

//        .rst_gearbox_i  (rst), // Reset signal

//        .dat_inFrame_i  (tx_data_76), // Input data
//        .dat_outFrame_o (tx_data_38), // Output data
//        .frame_0        (frame_0),

//        .sta_gbRdy_o    (tx_gb_rdy) // Ready signal
//    );
    

endmodule
