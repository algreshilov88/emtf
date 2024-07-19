`timescale 1ns / 1ps
`define DLY #1


//***********************************Entity Declaration************************
/*
module gmt_tx_reclock
(
    mgt_tx.out mgttx,
    input CPPF_7_mmcm_clk, // mgttx.txoutclk BUFGed
    
    input [63:0] txdata [2:0],
    input clk_40,
    input ttc_bc0,
    input [11:0] bxn_tx_offset,
    input [19:0] link_id
);


    `define BX_TRAILER    12'd3555 // 12'd3550
    `define BX_RESERVED_F 12'd3556 // 12'd3551
    `define BX_RESERVED_L 12'd3559
    `define TX_COMMA 32'h505050bc
    `define TX_PADDING 32'hf7f7f7f7

    `define TX_CRC 32'h0 // no CRC at this time
    `define TX_LID {6'h0, link_id[9:0], 6'h0, link_id[19:10]}
    
	localparam LHC_ORBIT_LAST_CLK = 12'd3563;
	
	
	//  Values for clk40
    reg [11:0] bxn = '0;
    wire [63:0] trailer_d [2:0];
    wire [7:0]  trailer_k [2:0];
    assign trailer_d [0] = {`TX_CRC, `TX_COMMA}; 
    assign trailer_d [1] = {`TX_COMMA, `TX_LID}; 
    assign trailer_d [2] = {`TX_COMMA, `TX_COMMA};
    assign trailer_k [0] = 8'b00000001; 
    assign trailer_k [1] = 8'b00010000; 
    assign trailer_k [2] = 8'b00010001; 
    
    
    // Values for clk250
    reg [31:0] txdata_word;
    reg [3:0] txcharisk_word;


    // Data registers for txdata and txcharisk
    reg [63:0] txdata_r40 [2:0];
    reg [7:0] txcharisk_r40 [2:0];

    // Asynchronous data registers after crossing domain
    (* ASYNC_REG = "TRUE" *) reg [63:0] txdata_async [2:0];
    (* ASYNC_REG = "TRUE" *) reg [7:0] txcharisk_async [2:0];
    
    // Asynchronous clock tracker
    (* ASYNC_REG = "TRUE" *) reg [12:0] clk40_ff_async;
    
    
    reg [63:0] txdata_r250 [2:0];
    reg [7:0] txcharisk_r250 [2:0];
    
    

    // CRC calculator
    tx_crc tx_crc_
    (
        .d (txdata_word),
        .k (txcharisk_word),
        .dout (mgttx.txdata),
        .kout (mgttx.txcharisk),
        .tx_crc_r (),
        .clk (CPPF_7_mmcm_clk)
    );

    reg clk40_ff = 1'b0;



    // tx format logic (clk40 domain)
    always @(negedge clk_40)
    begin

        for (int i=0; i<3; i=i+1) begin
            if (bxn ==  `BX_TRAILER) begin // send trailer                   
                txdata_r40[i] <= trailer_d[i];
                txcharisk_r40[i] <= trailer_k[i];     
            end
            else if (bxn >= `BX_RESERVED_F && bxn <= `BX_RESERVED_L) begin // send reserved words
                txdata_r40[i] <= trailer_d[2];
                txcharisk_r40[i] <= trailer_k[2];  
            end
            else begin // send data
                txdata_r40[i] <= txdata[i];
                txcharisk_r40[i] <= 4'b0000;
            end
        end

        // process BXN
        if (ttc_bc0) 
            bxn <= bxn_tx_offset;
        else
        begin 
            if (bxn == LHC_ORBIT_LAST_CLK) 
                bxn <= 12'h0;
            else 
                bxn <= bxn + 12'h1;
        end
        
        // clk40 switch
        clk40_ff <= ~clk40_ff;
    end
    
    
    
    // 250MHz clock cycles to wait after clk40_ff changes
    localparam ASYNC_WAIT_TIME = 2;
    
    // clock domain crossing logic
    always @(posedge CPPF_7_mmcm_clk)
    begin
    
    
        // Async reg for tracking clk40 - this is working as a level synchronizer, value should always remain constant for at least 6 250MHz clock cycles (24ns)
        clk40_ff_async <= {clk40_ff_async[11:0], clk40_ff};
        
        
        // Save data to 250MHz clock
        // Wait at least 1 clock cycle to make sure the data is stable
        //   - Also need to make sure that all _async input paths are less than 4ns (8ns if ASYNC_WAIT_TIME = 2)
        if(clk40_ff_async[ASYNC_WAIT_TIME + 1] != clk40_ff_async[ASYNC_WAIT_TIME]) begin
            txdata_async <= txdata_r40;
            txcharisk_async <= txcharisk_r40;
        end
        
        
        if(clk40_ff_async[ASYNC_WAIT_TIME + 2] != clk40_ff_async[ASYNC_WAIT_TIME + 1]) begin
            txdata_r250 <= txdata_async;
            txcharisk_r250 <= txcharisk_async;
            
            txdata_word <= txdata_async[0][31:0];
            txcharisk_word <= txcharisk_async[0][3:0];
        end
        else if(clk40_ff_async[ASYNC_WAIT_TIME + 3] != clk40_ff_async[ASYNC_WAIT_TIME + 2]) begin
            txdata_word <= txdata_r250[0][63:32];
            txcharisk_word <= txcharisk_r250[0][7:4];
        end
        
        else if(clk40_ff_async[ASYNC_WAIT_TIME + 4] != clk40_ff_async[ASYNC_WAIT_TIME + 3]) begin
            txdata_word <= txdata_r250[1][31:0];
            txcharisk_word <= txcharisk_r250[1][3:0];
        end
        else if(clk40_ff_async[ASYNC_WAIT_TIME + 5] != clk40_ff_async[ASYNC_WAIT_TIME + 4]) begin
            txdata_word <= txdata_r250[1][63:32];
            txcharisk_word <= txcharisk_r250[1][7:4];
        end
        
        else if(clk40_ff_async[ASYNC_WAIT_TIME + 6] != clk40_ff_async[ASYNC_WAIT_TIME + 5]) begin
            txdata_word <= txdata_r250[2][31:0];
            txcharisk_word <= txcharisk_r250[2][3:0];
        end
        else if(clk40_ff_async[ASYNC_WAIT_TIME + 7] != clk40_ff_async[ASYNC_WAIT_TIME + 6]) begin
            txdata_word <= txdata_r250[2][63:32];
            txcharisk_word <= txcharisk_r250[2][7:4];
        end
        else begin
            // nothing to transmit, send padding
            txdata_word <= `TX_PADDING;
            txcharisk_word <= 4'hf;
        end  
    end

endmodule
*/


module gmt_tx_reclock
(
    mgt_tx.out mgttx,
    input CPPF_7_mmcm_clk, // mgttx.txoutclk BUFGed
    
    input [63:0] txdata [2:0],
    input clk_40,
    input ttc_bc0,
    input [11:0] bxn_tx_offset,
    input [19:0] link_id
);



    reg [65:0] txdata_din; 
    wire [32:0] txdata_dout; 
    wire tx_fifo_uf;
    (* ASYNC_REG = "TRUE" *) reg [31:0] txdata_async;
    (* mark_debug = "TRUE" *) wire [31:0] txdata_async_w = txdata_async;
    (* ASYNC_REG = "TRUE" *) reg [3:0] txcharisk_async;
    wire clk_120, mmcm_120_locked;
    reg [32:0] txdata_dout_r, txdata_dout_rr;
    reg tx_fifo_uf_r, tx_fifo_uf_rr;

    reg [11:0] bxn;
    reg clk_40_r, clk_40_rr;
    reg [1:0] tx_mux;
    wire clk_40_sh;
    
    `define BX_TRAILER    12'd3555// 12'd3550
    `define BX_RESERVED_F 12'd3556// 12'd3551
    `define BX_RESERVED_L 12'd3559
    `define TX_COMMA   32'h505050bc 
    `define TX_PADDING 32'hf7f7f7f7

    `define TX_CRC 32'h0 // no CRC at this time
    `define TX_LID {6'h0, link_id[9:0], 6'h0, link_id[19:10]}
    
    wire [63:0] trailer_d [2:0];
    wire [7:0]  trailer_k [2:0];
    assign trailer_d [0] = {`TX_CRC, `TX_COMMA}; 
    assign trailer_d [1] = {`TX_COMMA, `TX_LID}; 
    assign trailer_d [2] = {`TX_COMMA, `TX_COMMA};
    assign trailer_k [0] = 8'b00000001; 
    assign trailer_k [1] = 8'b00010000; 
    assign trailer_k [2] = 8'b00010001; 

	localparam LHC_ORBIT_LAST_CLK = 12'd3563;
    
    reg [63:0] txdata_r [2:0];
    (* mark_debug = "TRUE" *) wire [63:0] txdata_rw [2:0] = txdata_r;
    (* ASYNC_REG = "TRUE" *) reg [63:0] txdata_a [2:0];
    reg [7:0] txcharisk_r [2:0];
    (* ASYNC_REG = "TRUE" *) reg [7:0] txcharisk_a [2:0];
//    (* ASYNC_REG = "TRUE" *) reg [6:0] clk40_s;
    (* ASYNC_REG = "TRUE" *) reg [12:0] clk40_ffs;

    // CRC calculator
    tx_crc tx_crc_
    (
        .d (txdata_async),
        .k (txcharisk_async),
        .dout (mgttx.txdata),
        .kout (mgttx.txcharisk),
        .tx_crc_r (),
        .clk (CPPF_7_mmcm_clk)
    );

    reg clk40_ff = 1'b0;

    // clock domain crossing logic
    always @(posedge CPPF_7_mmcm_clk)
    begin

//        if (clk40_s[1:0] == 2'b01) // clk_40 rose one clock ago
        if (clk40_ffs[7] != clk40_ffs[6])
        begin
            txdata_a = txdata_r; // store entire data word
            txcharisk_a = txcharisk_r; 
            txdata_async = txdata_a[0][31:0];
            txcharisk_async = txcharisk_a[0][3:0];
        end
        else
//        if (clk40_s[2:1] == 2'b01) // clk_40 rose two clocks ago
        if (clk40_ffs[8] != clk40_ffs[7])
        begin
            txdata_async = txdata_a[0][63:32];
            txcharisk_async = txcharisk_a[0][7:4];
        end
        else
//        if (clk40_s[3:2] == 2'b01)
        if (clk40_ffs[9] != clk40_ffs[8])
        begin
            txdata_async = txdata_a[1][31:0];
            txcharisk_async = txcharisk_a[1][3:0];
        end
        else
//        if (clk40_s[4:3] == 2'b01)
        if (clk40_ffs[10] != clk40_ffs[9])
        begin
            txdata_async = txdata_a[1][63:32];
            txcharisk_async = txcharisk_a[1][7:4];
        end
        else
//        if (clk40_s[5:4] == 2'b01)
        if (clk40_ffs[11] != clk40_ffs[10])
        begin
            txdata_async = txdata_a[2][31:0];
            txcharisk_async = txcharisk_a[2][3:0];
        end
        else
//        if (clk40_s[6:5] == 2'b01)
        if (clk40_ffs[12] != clk40_ffs[11])
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
    
//        clk40_s   = {clk40_s[5:0], !clk_40};
        clk40_ffs = {clk40_ffs[11:0], clk40_ff};
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


        // process BXN
        if (ttc_bc0) bxn = bxn_tx_offset;
        else
        begin 
            if (bxn == LHC_ORBIT_LAST_CLK) bxn = 12'h0;
            else bxn = bxn + 12'h1;
        end
        
        clk40_ff = ~clk40_ff;
    end

endmodule


    
