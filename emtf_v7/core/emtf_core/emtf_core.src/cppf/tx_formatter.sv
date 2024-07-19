module tx_formatter
(
    input [63:0] txdata [2:0], // three frames of data to transmit
    output [31:0] txdata_out, // async data output
    output [3:0] txcharisk_out, // async K output
    
    input [19:0] link_id,
    input [11:0] bxn, 
    
    input clk_40,
    input clk_250
);

    (* ASYNC_REG = "TRUE" *) reg [31:0] txdata_async;
    (* ASYNC_REG = "TRUE" *) reg [3:0] txcharisk_async;
    
    `define BX_TRAILER    12'd3555// 12'd3550
    `define BX_RESERVED_F 12'd3556// 12'd3551
    `define BX_RESERVED_L 12'd3559
    `define TX_COMMA   32'h505050bc 
    `define TX_PADDING 32'hf7f7f7f7

    `define TX_CRC 32'h0 // placeholder for CRC
    `define TX_LID {6'h0, link_id[9:0], 6'h0, link_id[19:10]}
    
    // trailer sequence
    wire [63:0] trailer_d [2:0];
    wire [7:0]  trailer_k [2:0];
    assign trailer_d [0] = {`TX_CRC, `TX_COMMA}; 
    assign trailer_d [1] = {`TX_COMMA, `TX_LID}; 
    assign trailer_d [2] = {`TX_COMMA, `TX_COMMA};
    assign trailer_k [0] = 8'b00000001; 
    assign trailer_k [1] = 8'b00010000; 
    assign trailer_k [2] = 8'b00010001; 

    reg [63:0] txdata_r [2:0];
    (* ASYNC_REG = "TRUE" *) reg [63:0] txdata_a [2:0];
    reg [7:0] txcharisk_r [2:0];
    (* ASYNC_REG = "TRUE" *) reg [7:0] txcharisk_a [2:0];
    (* ASYNC_REG = "TRUE" *) reg [6:0] clk40_s;
    
    (* mark_debug = "FALSE" *) wire [31:0] txdata_out_w = txdata_out; // async data output
    (* mark_debug = "FALSE" *) wire [3:0] txcharisk_out_w = txcharisk_out; // async K output
    

    // CRC calculator
    tx_crc tx_crc_
    (
        .d (txdata_async),
        .k (txcharisk_async),
        .dout (txdata_out),
        .kout (txcharisk_out),
        .clk (clk_250)
    );


    // clock domain crossing logic
    always @(posedge clk_250)
    begin

        if (clk40_s[1:0] == 2'b01) // clk_40 rose 1 clock ago
        begin
            txdata_a = txdata_r; // store entire data word
            txcharisk_a = txcharisk_r; 
            txdata_async = txdata_a[0][31:0];
            txcharisk_async = txcharisk_a[0][3:0];
        end
        else
        if (clk40_s[2:1] == 2'b01) // clk_40 rose 2 clocks ago
        begin
            txdata_async = txdata_a[0][63:32];
            txcharisk_async = txcharisk_a[0][7:4];
        end
        else
        if (clk40_s[3:2] == 2'b01) // clk_40 rose 3 clocks ago
        begin
            txdata_async = txdata_a[1][31:0];
            txcharisk_async = txcharisk_a[1][3:0];
        end
        else
        if (clk40_s[4:3] == 2'b01) // clk_40 rose 4 clocks ago
        begin
            txdata_async = txdata_a[1][63:32];
            txcharisk_async = txcharisk_a[1][7:4];
        end
        else
        if (clk40_s[5:4] == 2'b01) // clk_40 rose 5 clocks ago
        begin
            txdata_async = txdata_a[2][31:0];
            txcharisk_async = txcharisk_a[2][3:0];
        end
        else
        if (clk40_s[6:5] == 2'b01) // clk_40 rose 6 clocks ago
        begin
            txdata_async = txdata_a[2][63:32];
            txcharisk_async = txcharisk_a[2][7:4];
        end
        else
        begin
            // nothing to transmit, send padding
            txdata_async = `TX_PADDING;
            txcharisk_async = 4'hf;
        end    
    
        clk40_s = {clk40_s[5:0], !clk_40}; // slow clock shift line
    end

    integer i;
    // tx format logic
    always @(negedge clk_40)
    begin

        if (bxn == `BX_TRAILER) // send trailer
        begin
            for (i = 0; i < 3; i = i+1)
            begin
                txdata_r[i] = trailer_d[i];
                txcharisk_r[i] = trailer_k[i];
            end
        end
        else if (bxn >= `BX_RESERVED_F && bxn <= `BX_RESERVED_L) // send reserved words
        begin
            // only transmit commas here
            for (i = 0; i < 3; i = i+1)
            begin
                txdata_r[i] = trailer_d[2];
                txcharisk_r[i] = trailer_k[2];
            end
        end
        else // send payload
        begin
            for (i = 0; i < 3; i = i+1)
            begin
                txdata_r[i] = txdata[i];
                txcharisk_r[i] = 4'b0000;
            end
        end

    end

endmodule