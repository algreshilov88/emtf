`include "interfaces.sv"

module gem_rx
(
	mgt_rx.out ge11_rx [6:0],
	ge11_cluster.out ge11_cl [6:0][1:0][7:0], // [schamber][layer][cluster]
    output [233:0]      ge11_rxd [6:0], ///< GEM rx data, 1 frame x 234 bits, for 7 links
    output [6:0]        ge11_rx_valid,  ///< GEM data valid flags
    output [6:0]        ge11_crc_match, ///< CRC match flags from GEM links
	output reg [7:0] link_id [6:0], // [schamber=link]
	output reg single_hit,
    output reg [bw_fph-1:0] ph_single,
    output reg [bw_th-1:0]  th_single,
    input logic_reset,
    output [63:0] ge11_link_status,
    output [15:0] correction_cnt [6:0],
    input  [6:0] fiber_enable,
    input  [4:0] gem_data_del [6:0][1:0], // manual gem data delay for alignment [schamber=link][layer]
    // these delays should be set so that GEM data emerges from gem_sh delay line at the same time as RPC data
    input ttc_bc0,
    input [9:0] ttc_bc0_delay_gem,
    output [4:0] automatic_delay [6:0][1:0], // automatic alignment delay caluculated [schamber=link][layer]
    input en_manual,
    output [1:0] alg_out_range [6:0], // [schamber=link][layer]
    output [1:0] bc0_period_err [6:0], // [schamber=link][layer]
    input        flag_reset,

	input clk40
);

`include "spbits.sv"

    wire tx_ready = 1'b1; 
    wire rx_ready = 1'b1; 

    wire [6:0] lb_gbt_tx_ready             ;
    wire [6:0] lb_gbt_tx_had_not_ready     ;
    wire [6:0] lb_gbt_rx_ready             ;
    wire [6:0] lb_gbt_rx_had_not_ready     ;
    wire [6:0] lb_gbt_rx_header_had_unlock ;
    wire [6:0] lb_gbt_rx_gearbox_ready     ;
    (* mark_debug *) wire [6:0] lb_gbt_correction_flag      ;
    (* mark_debug *) wire [6:0] lb_gbt_rx_header_locked     ;
    (* mark_debug *) wire [15:0] lb_gbt_correction_cnt [6:0];
    assign correction_cnt = lb_gbt_correction_cnt;
    (* mark_debug *) wire ttc_bc0_del;

    reg [2:0] dupl_detect_cnt [6:0][1:0][7:0]; // [schamber][layer][cluster]
    reg [7:0] dupl_str [6:0][1:0][7:0];
    reg [7:0] dupl_flag [6:0][1:0];
    (* mark_debug *) wire [7:0] dupl_flag_w [6:0][1:0] = dupl_flag;
    
    assign ge11_link_status = 
    {
        lb_gbt_tx_ready             ,
        lb_gbt_tx_had_not_ready     ,
        lb_gbt_rx_ready             ,
        lb_gbt_rx_had_not_ready     ,
        lb_gbt_rx_header_had_unlock ,
        lb_gbt_rx_gearbox_ready     ,
        lb_gbt_correction_flag      ,
        lb_gbt_rx_header_locked
    };


    (* mark_debug *) wire [233:0] lb_gbt_rx_frame[6:0] ;
    wire  [233:0] lb_gbt_rx_frame_r[6:0] ;
    assign ge11_rxd = lb_gbt_rx_frame;
    assign ge11_rx_valid = lb_gbt_rx_header_locked;
    assign ge11_crc_match = 7'b1111111;
    reg  [233:0] r [11:0][6:0] ;

    (* mark_debug *) wire [1:0] bc0 [6:0]; //[schamber][layer]
    (* mark_debug *) wire [1:0] lct_bc0 [6:0];
    (* mark_debug *) wire [6:0] link_id_flag; // [schamber]
    //(* mark_debug *) wire [3:0] cluster_cnt [6:0][1:0]; //[schamber][layer]
    (* mark_debug *) wire [13:0] cluster [6:0][1:0][7:0]; // [schamber][layer][cluster]
    (* mark_debug *) wire gem_single_hit = single_hit;
    (* mark_debug *) wire [bw_fph-1:0] gem_ph_single = ph_single;
    (* mark_debug *) wire [bw_th-1:0]  gem_th_single = th_single;
    (* mark_debug *) wire [1:0] link_id_flag_r [6:0];
    
    reg [11:0] bxn;

    integer i, j, k;
    always @(posedge clk40)
    begin

        // temprorary single-hit trigger logic
        single_hit = 0;
        ph_single = 0;
        th_single = 0;
        for (i = 0; i < 7; i++) // link (superchamber) loop
        begin
			// invalidate all clusters initially
			for (j = 0; j < 2; j++) // layer loop
			begin
				for (k = 0; k < 8; k++) // cluster loop
				begin
					ge11_cl[i][j][k].str = 8'hff;
					ge11_cl[i][j][k].prt = 3'h7;
					ge11_cl[i][j][k].csz = 3'h0;
					ge11_cl[i][j][k].vf  = 1'b0;
				end
			end

            if (fiber_enable[i] == 1'b1) // fiber enabled and link is up
            begin
                for (j = 0; j < 2; j++) // layer loop
                begin
                    if (link_id_flag_r[i][j] == 1'b0) // not Link ID
                    begin
                        if (bc0_period_err[i][j] == 1'b0 && alg_out_range[i][j] == 1'b0) // decode clusters only if no BC0 errors and alignment is good
                        begin
//                            if (cluster_cnt[i][j] > 4'h0) // count of clusters more than 0
//                            begin
//                                single_hit = 1;
//                            end
                            
                            // scan clusters
                            for (k = 0; k < 8; k++) // cluster loop
                            begin
                            
                                if (cluster[i][j][k][7:0] != 8'hff) // valid cluster
                                begin
                                    // GE11 cluster format:
                                    // [7:0] - strip 0..191, 0xff is invalid
                                    // [10:8] - partition
                                    // [13:11] - cluster size
                                    // [14] - special_bit
        
                                    // GE21 cluster format:
                                    // [8:0] - strip 0..383, 0x1ff is invalid
                                    // [9] - partition
                                    // [12:10] - cluster size
                                    // [13] - reserved
                                    // [14] - special_bit
        
                                    // decode cluster
                                    ge11_cl[i][j][k].str = cluster[i][j][k][7:0];
                                    ge11_cl[i][j][k].prt = cluster[i][j][k][10:8];
                                    ge11_cl[i][j][k].csz = cluster[i][j][k][13:11];
                                    // cluster valid if strip code is not 'hff
                                    ge11_cl[i][j][k].vf  = 1'b1;
                                
                                    ph_single = {i[2:0], cluster[i][j][k][7:0]}; // chamber and strip number as phy
                                    th_single = {i[2:0], cluster[i][j][k][10:8]}; // chamber and partition as theta
                                    
                                    // duplicate detector logic
                                    if (dupl_detect_cnt[i][j][k] == 3'h7) // seven in a row
                                        dupl_flag [i][j][k] = 1'b1;
                                    
                                    if (dupl_str[i][j][k] == cluster[i][j][k][7:0]) // strip code matches previous cluster
                                        dupl_detect_cnt[i][j][k]++; // increase count
                                    else
                                        dupl_detect_cnt[i][j][k] = 3'b0; // reset, different cluster
                                        
                                    dupl_str[i][j][k] = cluster[i][j][k][7:0]; // remember strip code
                                end
                                else
                                begin
                                    dupl_detect_cnt[i][j][k] = 3'b0; // reset duplicate detector counter
                                    dupl_flag[i][j][k] = 1'b0; // reset flag
                                end
                            end
                        end
                    end
                    else
                    begin
                       // link ID is transmitted
                        // no clusters in this link, lock link ID
                        if (j == 0) // take ID value only from layer 0 flag, layer 1 may have different alignment  
                            link_id[i] = cluster[i][0][0][7:0]; // link ID value is in lower bits of first cluster

                        dupl_detect_cnt[i][j] = '{8{3'b0}}; // reset duplicate detector counters
                        dupl_flag[i][j] = 8'b0; // reset duplicate flags
    	       			
                    end      
                end
            end
            else
            begin
                link_id[i] = 8'hAB; // link disabled, show invalid ID
            end
        end
    end

    genvar gi, gj, gk;
    generate
        for (gi = 0; gi < 7; gi++)
        begin: gem_lnk_loop
        
            lpgbt_loopback_test i_lbgbt_test_core  
            (
                .reset_i                (logic_reset),
                
                .clk40_i                (clk40), // 40 M sync clock
                .mgt_tx_usrclk_i        (ge11_rx[gi].rxoutclk), // no TX, using RX clock here for now
                .mgt_rx_usrclk_i        (ge11_rx[gi].rxoutclk),
                
                .mgt_tx_ready_i         (tx_ready),
                .mgt_rx_ready_i         (rx_ready),
                .mgt_rx_slide_o         (ge11_rx[gi].rxslide),
                .mgt_tx_data_o          (),
                .mgt_rx_data_i          (ge11_rx[gi].rxdata),
                
                .tx_data_i              (234'h0), // nothing to transmit
                .rx_data_o              (lb_gbt_rx_frame [gi]),
                .tx_ready_o             (lb_gbt_tx_ready [gi]),
                .tx_had_not_ready_o     (lb_gbt_tx_had_not_ready [gi]),
                .rx_ready_o             (lb_gbt_rx_ready [gi]),
                .rx_had_not_ready_o     (lb_gbt_rx_had_not_ready [gi]),
                .rx_header_locked_o     (lb_gbt_rx_header_locked [gi]),
                .rx_header_had_unlock_o (lb_gbt_rx_header_had_unlock [gi]),
                .rx_gearbox_ready_o     (lb_gbt_rx_gearbox_ready [gi]),
                .rx_correction_cnt_o    (lb_gbt_correction_cnt [gi]),
                .rx_correction_flag_o   (lb_gbt_correction_flag [gi]),
                .flag_reset             (flag_reset)
            );

            gem_aligner gem_aligner_layer_1
            (
                .frame_i         (lb_gbt_rx_frame   [gi][121:10]), // input frame
                .frame_o         (lb_gbt_rx_frame_r [gi][121:10]), // aligned frame
                .ttc_bc0_del     (ttc_bc0_del), // delayed BC0 from TTC to align to
                .lct_bc0         (lct_bc0[gi][0]), // BC0 from this chamber
                .bc0             (bc0[gi][0]), // aligned BC0
                .link_id_flag    (link_id_flag[gi]), // link ID flag
                .link_id_flag_o  (link_id_flag_r[gi][0]), // aligned link ID flag
                .automatic_delay (automatic_delay [gi][0]), // calculated delay
                .manual_delay    (gem_data_del[gi][0]), // manually applied delay
                .en_manual       (en_manual), // enable manual delay
                .alg_out_range   (alg_out_range [gi][0]), // alignment counter out of range
                .bc0_period_err  (bc0_period_err [gi][0]), // BC0 period is not exactly one orbit
                .bxn             (bxn), // BX counter for BC0 period error detection
                .clk             (clk40)
            );            
            
            gem_aligner gem_aligner_layer_2
            (
                .frame_i         (lb_gbt_rx_frame   [gi][233:122]), // input frame
                .frame_o         (lb_gbt_rx_frame_r [gi][233:122]), // aligned frame
                .ttc_bc0_del     (ttc_bc0_del), // delayed BC0 from TTC to align to
                .lct_bc0         (lct_bc0[gi][1]), // BC0 from this chamber
                .bc0             (bc0[gi][1]), // aligned BC0
                .link_id_flag    (link_id_flag[gi]), // link ID flag
                .link_id_flag_o  (link_id_flag_r[gi][1]), // aligned link ID flag
                .automatic_delay (automatic_delay [gi][1]), // calculated delay
                .manual_delay    (gem_data_del[gi][1]), // manually applied delay
                .en_manual       (en_manual), // enable manual delay
                .alg_out_range   (alg_out_range [gi][1]), // alignment counter out of range
                .bc0_period_err  (bc0_period_err [gi][1]), // BC0 period is not exactly one orbit
                .bxn             (bxn), // BX counter for BC0 period error detection
                .clk             (clk40)
            );            

            // data decoder according to "GEM Trigger Data Format Proposal"
            for (gj = 0; gj < 2; gj++) // layer loop
            begin: layer_loop
                for (gk = 0; gk < 8; gk++) // cluster loop
                begin: cluster_loop
                
                    assign cluster[gi][gj][gk] = lb_gbt_rx_frame_r[gi][112*gj + 14*gk + 10 +: 14];
                end
                
                // this is incorrect, cluster count bits are not filled in lb_gbt_rx_frame_r
                //assign cluster_cnt[gi][gj] = lb_gbt_rx_frame_r[gi][4*gj + 2 +: 4];
                
                // decode BC0 bits from input frame for alignment (note missing _r at the end)
                assign lct_bc0[gi][gj] = lb_gbt_rx_frame[gi][gj];

            end
            assign link_id_flag[gi] = lb_gbt_rx_frame[gi][9:2] == 8'hff ? 1'b1 : 1'b0;
        end
    endgenerate;

    // generate delayed bc0 for alignment
    dyn_shift #(.BW(1), .SELWIDTH(10)) bc0_del (.CLK(clk40), .CE(1'b1), .SEL(ttc_bc0_delay_gem), .SI(ttc_bc0), .DO(ttc_bc0_del));
    always @(posedge clk40)
    begin
        // free-running BX counter for BC0 period error detection
        // does not need resetting
        bxn++;
        if (bxn == 12'd3564) bxn = 12'h0;
    end


endmodule

