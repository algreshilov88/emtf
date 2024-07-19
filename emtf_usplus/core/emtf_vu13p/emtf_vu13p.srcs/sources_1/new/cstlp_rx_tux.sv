`timescale 1ns / 1ps

`include "cstlp_interface.sv"
`include "mgt_gty_interfaces.sv"

module cstlp_rx_tux
# (parameter N = 22)
(
    input freerun_clk     ,
    input ttc_clk         ,
    input reset           ,
    input [N-1:0] reset_cnt_in    ,
    input [N-1:0] reset_latched_in,
    input [N-1:0] link_status_in  ,
    input [N-1:0] align_marker_sel_in,
    input [N-1:0] align_marker_dis_in,
    input [N-1:0] disable_ICM_in,

	mgt_gty_rx.in mgtrx [N-1:0],

    output [63:0] unscrambled_data_out [N-1:0],
    output [N-1:0] valid_bit_out,
    output [N-1:0] rx_datavalid_out,
    
    input  rxram_pointer_t rxram_pointer_ctrl_in [N-1:0],
    output lword rxdata_out [N-1:0],
    output linkRxMetadata_t rxMetadata_out [N-1:0],
    output linkStatusInfo_t linkStatusInfo_out [N-1:0]    
);

    rxram_pointer_u rxram_pointer_ctrl_in_u [N-1:0];
    lword_u rxdata_out_u [N-1:0];
    linkRxMetadata_u rxMetadata_out_u [N-1:0];
    linkStatusInfo_u linkStatusInfo_out_u [N-1:0];

    wire [`LWORD_WIDTH-1:0] rx_data [N-1:0];    
    localparam integer NWORDS_10B = `LWORD_WIDTH / 10; // count of 10-bit words in LWORD

    genvar i, j;
    generate
        for (i = 0; i < N; i++)
        begin

            // when 8b/10b is disabled, data is received via rxdata and rxctrl* buses
            // see Table 4-50 in UG578 
            for (j = 0; j < NWORDS_10B; j++) // 10-bit section loop
            begin
                assign rx_data [i][j*10 +  9] = mgtrx[i].rxctrl1 [j];
                assign rx_data [i][j*10 +  8] = mgtrx[i].rxctrl0 [j];
                assign rx_data [i][j*10 +: 8] = mgtrx[i].rxdata  [j*8 +: 8];
            end
            assign rx_data [i][NWORDS_10B*10 +: 4] = mgtrx[i].rxdata  [NWORDS_10B*8 +: 4]; // remaining 4 high bits not covered by loop above

            assign rxram_pointer_ctrl_in_u[i].s = rxram_pointer_ctrl_in[i];
            assign rxdata_out[i] = rxdata_out_u[i].s;
            assign rxMetadata_out[i] = rxMetadata_out_u[i].s;
            assign linkStatusInfo_out[i] = linkStatusInfo_out_u[i].s;
            
            cstlp_rx cstlp_rx_i
            (
                .freerun_clk             (freerun_clk               ), 
                .ttc_clk                 (ttc_clk                   ), 
                .rxusrclk                (mgtrx[i].rxoutclk         ), 
                .reset                   (reset                     ), 
                .reset_cnt_in            (reset_cnt_in           [i]), 
                .reset_latched_in        (reset_latched_in       [i]), 
                .link_status_in          (link_status_in         [i]), 
                .rx_data_in              (rx_data                [i]), 
                .rx_header_in            (mgtrx[i].rxheader         ), 
                .rx_datavalid_in         (mgtrx[i].rxdatavalid      ), 
                .align_marker_sel_in     (align_marker_sel_in    [i]), 
                .align_marker_dis_in     (align_marker_dis_in    [i]), 
                .disable_ICM_in          (disable_ICM_in         [i]), 
                .rxram_pointer_ctrl_in_c (rxram_pointer_ctrl_in_u[i].comb), 
                .unscrambled_data_out    (unscrambled_data_out   [i]), 
                .valid_bit_out           (valid_bit_out          [i]), 
                .rx_datavalid_out        (rx_datavalid_out       [i]), 
                .rxdata_out_c            (rxdata_out_u[i].comb           ),            
                .rxMetadata_out_c        (rxMetadata_out_u[i].comb       ), 
                .linkStatusInfo_out_c    (linkStatusInfo_out_u[i].comb   ) 
            );
        end
    endgenerate

    // placing ILA to prevent logic being optimized away
    cstlp_ila ila 
    (
        .clk     (ttc_clk    ), // input wire clk
        .probe0  (rxdata_out_u[0 ].comb), // input wire [68:0]  probe0  
        .probe1  (rxdata_out_u[1 ].comb), // input wire [68:0]  probe1 
        .probe2  (rxdata_out_u[2 ].comb), // input wire [68:0]  probe2 
        .probe3  (rxdata_out_u[3 ].comb), // input wire [68:0]  probe3 
        .probe4  (rxdata_out_u[4 ].comb), // input wire [68:0]  probe4 
        .probe5  (rxdata_out_u[5 ].comb), // input wire [68:0]  probe5 
        .probe6  (rxdata_out_u[6 ].comb), // input wire [68:0]  probe6 
        .probe7  (rxdata_out_u[7 ].comb), // input wire [68:0]  probe7 
        .probe8  (rxdata_out_u[8 ].comb), // input wire [68:0]  probe8 
        .probe9  (rxdata_out_u[9 ].comb), // input wire [68:0]  probe9 
        .probe10 (rxdata_out_u[10].comb), // input wire [68:0]  probe10 
        .probe11 (rxdata_out_u[11].comb), // input wire [68:0]  probe11 
        .probe12 (rxdata_out_u[12].comb), // input wire [68:0]  probe12 
        .probe13 (rxdata_out_u[13].comb), // input wire [68:0]  probe13 
        .probe14 (rxdata_out_u[14].comb), // input wire [68:0]  probe14 
        .probe15 (rxdata_out_u[15].comb), // input wire [68:0]  probe15 
        .probe16 (rxdata_out_u[16].comb), // input wire [68:0]  probe16 
        .probe17 (rxdata_out_u[17].comb), // input wire [68:0]  probe17 
        .probe18 (rxdata_out_u[18].comb), // input wire [68:0]  probe18 
        .probe19 (rxdata_out_u[19].comb), // input wire [68:0]  probe19 
        .probe20 (rxdata_out_u[20].comb), // input wire [68:0]  probe20 
        .probe21 (rxdata_out_u[21].comb)  // input wire [68:0]  probe21
    );
    

endmodule
