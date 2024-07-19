module rx_deframer
(
    input reset,
    output [63:0] rxdata_o [2:0], // three frames of deframed data
    output valid_o, // shows when rx data are valid 
    input [31:0] rxdata_in, // async data input
    input [3:0] rxcharisk_in, // async K input
    output reg [7:0] link_id, // link ID,
    output reg crc_match,
    
    input clk_40,
    input clk_250, 
    input clk_240,
    input ttc_bc0_del
);

    
    (* ASYNC_REG = "TRUE" *) reg [63:0] rxdata [2:0]; // three frames of deframed data
    (* ASYNC_REG = "TRUE" *) reg valid; // shows when rx data are valid 
    (* ASYNC_REG = "TRUE" *) reg [63:0] rxdata_a [2:0];
    (* ASYNC_REG = "TRUE" *) reg [7:0] rxcharisk_a [2:0];
    (* ASYNC_REG = "TRUE" *) reg [63:0] rxdata_s [2:0];
    (* ASYNC_REG = "TRUE" *) reg [7:0] rxcharisk_s [2:0];
    (* ASYNC_REG = "TRUE" *) reg valid_a, valid_s;
    reg [3:0] adata_del = 0, adata_del_cnt = 0;
    wire [31:0] rxdata_del; // async data delayed
    wire [3:0] rxcharisk_del; // async K delayed
    reg [31:0] rxdata_in_r; 
    reg [3:0] rxcharisk_in_r;
    reg clk_40_r, clk_40_rr, adel_count = 0;
    reg k_r, k_rr, k_rrr;
    reg [2:0] frm;
    reg [4:0] kh;
    assign rxdata_o = rxdata;
    assign valid_o = valid;
    reg [31:0] crc_rx;
    reg [31:0] crc_calc;
    reg crc_calc_val;

    (* mark_debug = "FALSE" *) wire [63:0] rxdata_w0, rxdata_w1, rxdata_w2; // three frames of deframed data
    (* mark_debug = "FALSE" *) wire [63:0] rxdata_a_w0, rxdata_a_w1, rxdata_a_w2; // three frames of deframed data
    (* mark_debug = "FALSE" *) wire [63:0] rxdata_s_w0, rxdata_s_w1, rxdata_s_w2; // three frames of deframed data
    (* mark_debug = "FALSE" *) wire [31:0] rxdata_del_w = rxdata_del;
    (* mark_debug = "FALSE" *) wire [3:0] rxcharisk_del_w = rxcharisk_del;
    (* mark_debug = "FALSE" *) wire [31:0] rxdata_in_w = rxdata_in;
    (* mark_debug = "FALSE" *) wire [3:0] rxcharisk_in_w = rxcharisk_in;
    (* mark_debug = "FALSE" *) wire [3:0] adata_del_w = adata_del;
    (* mark_debug = "FALSE" *) wire valid_w = valid;
    (* mark_debug = "FALSE" *) wire [2:0] k_r_w = {k_rrr, k_rr, k_r};
    (* mark_debug = "FALSE" *) wire [1:0] clk_40_r_w = {clk_40_rr, clk_40_r};
    (* mark_debug = "FALSE" *) wire [3:0] adata_del_cnt_w = adata_del_cnt;
    (* mark_debug = "FALSE" *) wire adel_count_w = adel_count;
    (* mark_debug = "FALSE" *) wire [2:0] frm_w = frm;
    (* mark_debug = "TRUE" *) wire [31:0] crc_rx_w = crc_rx;
    (* mark_debug = "TRUE" *) wire [31:0] crc_calc_w = crc_calc;
    (* mark_debug = "TRUE" *) wire crc_calc_val_w = crc_calc_val;
    
    assign rxdata_w0 = rxdata[0];
    assign rxdata_w1 = rxdata[1];
    assign rxdata_w2 = rxdata[2];

    assign rxdata_a_w0 = rxdata_a[0];
    assign rxdata_a_w1 = rxdata_a[1];
    assign rxdata_a_w2 = rxdata_a[2];

    assign rxdata_s_w0 = rxdata_s[0];
    assign rxdata_s_w1 = rxdata_s[1];
    assign rxdata_s_w2 = rxdata_s[2];
    

    // CRC calculator
    tx_crc rx_crc_
    (
        .d (rxdata_del),
        .k (rxcharisk_del),
        .dout (crc_calc), // calculated crc
        .kout (),
        .tx_crc_r (crc_calc_val), // calculated crc valid
        .clk (clk_250)
    );

    reg rx_fifo_wr_en;
    (* mark_debug = "FALSE" *) reg bc0_r, valid_r, valid_rr;
    (* mark_debug = "FALSE" *) reg data_del;
    reg [63:0] rxdata_r [2:0];
    reg [63:0] rxdata_rr [2:0];

    always @(posedge clk_40)
    begin
        rxdata_rr = rxdata_r; // one BX history of data
        rxdata_r = rxdata_s; // lock deframed data to outputs
        valid_rr = valid_r;
        valid_r = valid_s;
        
        if (data_del == 1'b0)
        begin 
            rxdata = rxdata_r; // no delay
            valid = valid_r;
        end 
        else
        begin                  
            rxdata = rxdata_rr; // one BX delay
            valid = valid_rr;
        end
        
        // refresh data_del on each orbit
        if (ttc_bc0_del && !bc0_r) // bc0 just rose
        begin
            if (valid_r && !valid_rr) // valid bit also just rose
            begin
                data_del = 1'b1;// need to delay, data early by one BX
            end
            else
            begin
                data_del = 1'b0;// no need to delay
            end
        end

        bc0_r = ttc_bc0_del;
    end

    // input data delay line to match 40 MHz clock phase
    dyn_shift #(.SELWIDTH(4), .BW(36)) data_sh 
    (
        .CLK(clk_250), 
        .CE(1'b1), 
        .SEL(adata_del), 
        .SI({rxdata_in_r, rxcharisk_in_r}), 
        .DO({rxdata_del, rxcharisk_del})
    );

    // clock domain crossing logic
    always @(posedge clk_250)
    begin
    
        // deframe delayed input data
        if (rxcharisk_del == 4'b0000) // process normally if it's neither padding nor trailer
        begin
            // put frames into data words
            rxdata_a    [frm[2:1]][(frm[0] ? 32:0) +: 32] = rxdata_del;
            rxcharisk_a [frm[2:1]][(frm[0] ? 4:0)  +: 4] = rxcharisk_del;
            valid_a = 1'b1;
            
            // update frame counter
            frm = frm + 3'h1;
            if (frm == 3'h6) // last frame
            begin 
            
                frm = 3'h0; // reset counter
                rxdata_s = rxdata_a; // place data into transfer register
                rxcharisk_s = rxcharisk_a;
                valid_s = valid_a;
            end
        end
        else
        if (rxcharisk_del == 4'b0001) // it's trailer
        begin
            frm = 3'h0; // reset frame
            valid_a = 1'b0;
            valid_s = 1'b0;
        end
        
        // process delay counter, only if not padding
        if (adel_count == 1'b1 && rxcharisk_in_r != 4'b1111) 
		  adata_del_cnt = adata_del_cnt + 4'h1; 
        
        if (!clk_40_rr && clk_40_r && k_r && k_rr && k_rrr) // LHC clock just rose and trailer is in progress
        begin
            adel_count = 1'b1; // start delay counter
            adata_del_cnt = 4'h1; // reset delay counter
        end
        
        if (!k_r && k_rr && k_rrr) // trailer end: no K now, but was two Ks before that
        begin
            adel_count = 1'b0; // stop delay counter
            adata_del = 4'd9 - adata_del_cnt; // lock delay counter
        end


        
        // LHC clock history
        clk_40_rr = clk_40_r;
        clk_40_r = clk_40;
        
        // K history
	    if (rxcharisk_in_r != 4'b1111) // shift history only if not padding
		begin
			k_rrr = k_rr;
			k_rr = k_r;
			k_r = (rxcharisk_in_r == 4'b0001);
        end

        // process link IDs and CRCs
        if (reset)
        begin
            link_id = 8'h0;
        end
        else
	    if (rxcharisk_del != 4'b1111) // shift K history only if not padding
		begin
            kh = {kh[3:0], rxcharisk_del[0]}; // update K[0] history
            if (kh == 5'b00010) // CRC time
            begin
                crc_rx = rxdata_del;
            end
            if (kh == 5'b00100) // Link ID time
            begin
                link_id = {rxdata_del[17:16], rxdata_del[10:8], rxdata_del[2:0]}; // Endcap, Sector, Link
            end
        end

        if (crc_calc_val) // calculated CRC is valid this clock
        begin
            crc_match = (crc_calc == crc_rx); // update crc match flag
        end

        rxdata_in_r = rxdata_in;
        rxcharisk_in_r = rxcharisk_in;
    end

endmodule