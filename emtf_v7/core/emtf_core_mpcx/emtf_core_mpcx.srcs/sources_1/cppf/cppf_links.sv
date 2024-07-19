module cppf_links
(
    mgt_rx.out mgtrx [6:0],
    
    //               [link][frame]
    output [63:0] rxd [6:0][2:0], // rx data, 3 frames x 64 bit, for 7 links
    output [6:0] rx_valid, // rx data valid flag
    output [7:0] link_id [6:0],
    output [6:0] crc_match,
    input clk_40, // LHC clk
    input clk_125,
    input ttc_bc0,
    input [5:0] ttc_bc0_delay_cppf,
    input [6:0] fiber_enable
);
    //                [link]
    wire [31:0] txdata [6:0];
    assign txdata[0] = 32'h0;
    assign txdata[1] = 32'h0;
    assign txdata[2] = 32'h0;
    assign txdata[3] = 32'h0;
    assign txdata[4] = 32'h0;
    assign txdata[5] = 32'h0;
    assign txdata[6] = 32'h0;
    wire [3:0] txcharisk [6:0];
    assign txcharisk[0] = 4'h0;
    assign txcharisk[1] = 4'h0;
    assign txcharisk[2] = 4'h0;
    assign txcharisk[3] = 4'h0;
    assign txcharisk[4] = 4'h0;
    assign txcharisk[5] = 4'h0;
    assign txcharisk[6] = 4'h0;
    
    (* mark_debug *) wire [31:0] rxdata [6:0];
    (* mark_debug *) wire [3:0] rxcharisk [6:0];
    wire [6:0] rxoutclk;
    
    wire [6:0] refclk;
    wire clk_250, clk_240;

    wire  [2:0] qpll_lock;
    wire  [2:0] qpll_refclklost;
    wire  [2:0] qpll_outclk;
    wire  [2:0] qpll_outrefclk;
    wire  [6:0] qpll_reset;
    wire ttc_bc0_del;
    

    // [link] = qpll
    integer qi [6:0];
    assign qi[0] = 0;
    assign qi[1] = 1;
    assign qi[2] = 1;
    assign qi[3] = 2;
    assign qi[4] = 2;
    assign qi[5] = 2;
    assign qi[6] = 2;
    
    wire [63:0] rxdb [6:0][2:0];
    wire [7:0] link_idb [6:0];
    wire rxvb [6:0]; // separate bit array is needed because bit-select using lm is illegal
    wire [6:0] crc_matchb;
    wire [63:0] emp [2:0]; // empty data frames
    assign emp[0] = 64'hffffffffffffffff;
    assign emp[1] = 64'hffffffffffffffff;
    assign emp[2] = 64'hffffffffffffffff;

    // mapping links to 10-deg sub-sectors
    assign rxd[2] = fiber_enable[2] ? rxdb[0] : emp; assign link_id[2] = link_idb[0]; 
    assign rxd[3] = fiber_enable[3] ? rxdb[1] : emp; assign link_id[3] = link_idb[1]; 
    assign rxd[6] = fiber_enable[6] ? rxdb[2] : emp; assign link_id[6] = link_idb[2]; 
    assign rxd[4] = fiber_enable[4] ? rxdb[3] : emp; assign link_id[4] = link_idb[3]; 
    assign rxd[5] = fiber_enable[5] ? rxdb[4] : emp; assign link_id[5] = link_idb[4]; 
    assign rxd[1] = fiber_enable[1] ? rxdb[5] : emp; assign link_id[1] = link_idb[5]; 
    assign rxd[0] = fiber_enable[0] ? rxdb[6] : emp; assign link_id[0] = link_idb[6]; 
    
    assign rx_valid[2] = rxvb[0] & fiber_enable[2]; assign crc_match[2] = crc_matchb[0];
    assign rx_valid[3] = rxvb[1] & fiber_enable[3]; assign crc_match[3] = crc_matchb[1];
    assign rx_valid[6] = rxvb[2] & fiber_enable[6]; assign crc_match[6] = crc_matchb[2];
    assign rx_valid[4] = rxvb[3] & fiber_enable[4]; assign crc_match[4] = crc_matchb[3];
    assign rx_valid[5] = rxvb[4] & fiber_enable[5]; assign crc_match[5] = crc_matchb[4];
    assign rx_valid[1] = rxvb[5] & fiber_enable[1]; assign crc_match[1] = crc_matchb[5];
    assign rx_valid[0] = rxvb[6] & fiber_enable[0]; assign crc_match[0] = crc_matchb[6];
     
    genvar gi, gj;
    generate

        // GTH links
        for (gi = 0; gi < 7; gi = gi+1) // link loop
        begin: ql
                
             assign rxdata    [gi] = mgtrx[gi].rxdata;
             assign rxcharisk [gi] = mgtrx[gi].rxcharisk;
             assign rxoutclk  [gi] = mgtrx[gi].rxoutclk;

            // RX data deframer
            rx_deframer rxdf
            (
                .reset        (1'b0), // not really needed
                .rxdata_o     (rxdb[gi]), // three frames of deframed data
                .valid_o      (rxvb[gi]), // shows when rx data are valid 
                .rxdata_in    (rxdata [gi]), // async data input
                .rxcharisk_in (rxcharisk [gi]), // async K input
                .link_id      (link_idb[gi]),
                .crc_match    (crc_matchb[gi]),
                
                .clk_40       (clk_40),
                .clk_250      (rxoutclk[gi]), // using rx clocks from each link
                .clk_240      (clk_240),
                .ttc_bc0_del  (ttc_bc0_del)
            );
            
        end
        
        
    endgenerate

    mmcm_async mmcm_250
    (
        .clk_in1(clk_125),
        .clk_out1(clk_250),
        .reset(1'b0),
        .locked()
    );  

    mmcm_sync mmcm_240
    (
        .clk_in1(clk_40), 
        .clk_out1(clk_240),
        .reset(1'b0), 
        .locked()
    );      

    // generate delayed bc0 for alignment
    dyn_shift #(.BW(1), .SELWIDTH(6)) bc0_del (.CLK(clk_40), .CE(1'b1), .SEL(ttc_bc0_delay_cppf), .SI(ttc_bc0), .DO(ttc_bc0_del));

endmodule