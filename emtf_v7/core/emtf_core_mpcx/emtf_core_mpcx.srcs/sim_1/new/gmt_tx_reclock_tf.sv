`timescale 1ns / 1ps

`include "mgt_interfaces.sv"
module gmt_tx_reclock_tf;

    mgt_tx gmt_tx();

    reg CPPF_7_mmcm_clk = 0; // mgttx.txoutclk BUFGed
    
    reg [63:0] txdata [2:0];
    reg clk_40 = 0;
    reg ttc_bc0;
    reg [11:0] bxn_tx_offset;
    reg [19:0] link_id;


    gmt_tx_reclock uut
    (
        .mgttx           (gmt_tx),
        .CPPF_7_mmcm_clk (CPPF_7_mmcm_clk), // mgttx.txoutclk BUFGed
        
        .txdata        (txdata),
        .clk_40        (clk_40),
        .ttc_bc0       (ttc_bc0),
        .bxn_tx_offset (bxn_tx_offset),
        .link_id       (link_id)
    );
    
    always 
    begin
        #2 
        CPPF_7_mmcm_clk = ~CPPF_7_mmcm_clk;
    end
    
    reg [63:0] cnt = 64'b0;
    
    always 
    begin
        #12.5
        clk_40 = ~clk_40;
        if (clk_40 == 1)
        begin
            txdata[0] = cnt;
            txdata[1] = cnt;
            txdata[2] = cnt;
            cnt++;
        end
    end
    
    initial
    begin
    end

endmodule
