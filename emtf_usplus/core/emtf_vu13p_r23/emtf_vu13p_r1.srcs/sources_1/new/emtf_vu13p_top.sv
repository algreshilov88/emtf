`timescale 1ns / 1ps
`include "mgt_gty_interfaces.sv"
`include "csc_interfaces.sv"
`include "cstlp_interface.sv"
module emtf_vu13p_top
(
    
    input  wire [1:0] c2c_rxn,
    input  wire [1:0] c2c_rxp,
    output wire [1:0] c2c_txn,
    output wire [1:0] c2c_txp,

	input [47:0] refclk_p,
	input [47:0] refclk_n
);

    wire        drp_clk;
	drp #(.AW(13)) drp_gty_i (); // AW parameter must match AW_QUAD parameter in top serial module

    wire [3:0]drp_we;
//    assign drp_gth_i.int_reg = 1'b0;

//    wire refclk5, refclk5_bufg;
    wire c2c_refclk;
    wire c2c_refclk_b;
    
    (* mark_debug *) wire [7:0] lb_gbt_tx_ready            ;
    (* mark_debug *) wire [7:0] lb_gbt_tx_had_not_ready    ;
    (* mark_debug *) wire [7:0] lb_gbt_rx_ready            ;
    (* mark_debug *) wire [7:0] lb_gbt_rx_had_not_ready    ;
    (* mark_debug *) wire [7:0] lb_gbt_rx_header_locked    ;
    (* mark_debug *) wire [7:0] lb_gbt_rx_header_had_unlock;
                     wire [7:0] lb_gbt_rx_gearbox_ready    ;
    (* mark_debug *) wire [7:0] lb_gbt_correction_flag     ;
    (* mark_debug *) wire [15:0] lb_gbt_correction_cnt [7:0]      ;


    (* mark_debug *) wire [233:0] lb_gbt_rx_frame [7:0] ;
    (* mark_debug *) wire [233:0] lb_gbt_tx_frame [7:0] ;

    
    // vio
    wire logic_reset;
    wire tx_ready, rx_ready;
    
    wire clk40; // from mmcm
    wire clk_tx; // should be 320 M

//    tcds_mmcm tcds_mmcm_i
//    (
//        .clk_out1 (clk40),
//        .reset    (1'b0),
//        .locked   (),
//        .clk_in1  (clk_tx)
//    );     
    
    reg [8:0] cnt;
    always @(posedge clk40) cnt++;

    wire c2c_channel_up;
    wire c2c_init_clk;
    wire c2c_mmcm_unlocked;
    wire c2c_phy_clk;
    wire c2c_pma_init;
    
    wire [31:0] c2c_rx_data;
    wire        c2c_rx_valid;
    
    wire        c2c_tx_ready;
    wire [31:0] c2c_tx_tdata;
    wire        c2c_tx_tvalid;
    wire        c2c_do_cc;
    wire [2:0]  c2c_rxbufstatus;
    wire [1:0]  c2c_rxclkcorcnt;
    wire        c2c_link_reset;

    wire [31:0] mgt_rx_data;
    wire [3:0]  mgt_rx_k   ;
    wire [31:0] mgt_tx_data;
    wire [3:0]  mgt_tx_k   ;
    wire [1:0]  realigned1_aligned0;
    
    wire [8191:0] control;
    wire [8191:0] status;

    apex_blk_wrapper apex_blk_w
    (
        .c2c_channel_up    (c2c_channel_up   ),
        .c2c_init_clk      (c2c_init_clk     ),
        .c2c_mmcm_unlocked (c2c_mmcm_unlocked),
        .c2c_phy_clk       (c2c_phy_clk      ),
        .c2c_pma_init      (c2c_pma_init     ),
        .c2c_rx_data       (c2c_rx_data      ),
        .c2c_rx_valid      (c2c_rx_valid     ),
        .c2c_tx_ready      (c2c_tx_ready     ),
        .c2c_tx_tdata      (c2c_tx_tdata     ),
        .c2c_tx_tvalid     (c2c_tx_tvalid    ),
        .c2c_do_cc         (c2c_do_cc        ),
        .c2c_rxbufstatus   (c2c_rxbufstatus  ),
        .c2c_rxclkcorcnt   (c2c_rxclkcorcnt  ),
        .c2c_link_reset    (c2c_link_reset   ),

        .mgt_rx_data (mgt_rx_data),
        .mgt_rx_k    (mgt_rx_k   ),
        .mgt_tx_data (mgt_tx_data),
        .mgt_tx_k    (mgt_tx_k   ),
        .realigned1_aligned0 (realigned1_aligned0),

        .drp_clk         (drp_clk),
        .drp_addr        (drp_gty_i.drpaddr),
        .drp_di          (drp_gty_i.drpdi  ),
        .drp_do          (drp_gty_i.drpdo  ),
        .drp_en          (drp_gty_i.drpen  ),
        .drp_we          (drp_gty_i.drpwe  ),
        
        .control         (control),
        .status          (status)
    );
    
    wire [47:0] refclk, refclk_odiv, refclk_odiv_b;
    
    c2c_gty_tux c2c_gty_i
    (
        .mgtrefclk0_x0y6_int (refclk[4]),
        .mgtrefclk_odiv2_b   (refclk_odiv[4]),
        .gtyrxn_int (c2c_rxn),
        .gtyrxp_int (c2c_rxp),
        .gtytxn_int (c2c_txn),
        .gtytxp_int (c2c_txp),
        
        .mgt_rx_data (mgt_rx_data),
        .mgt_rx_k    (mgt_rx_k   ),
        .mgt_tx_data (mgt_tx_data),
        .mgt_tx_k    (mgt_tx_k   ),
        .realigned1_aligned0 (realigned1_aligned0),
        
        .c2c_channel_up    (c2c_channel_up   ),
        .c2c_init_clk      (c2c_init_clk     ),
        .c2c_mmcm_unlocked (c2c_mmcm_unlocked),
        .c2c_phy_clk       (c2c_phy_clk      ),
        .c2c_pma_init      (c2c_pma_init     ),
        .c2c_rx_data       (c2c_rx_data      ),
        .c2c_rx_valid      (c2c_rx_valid     ),
        .c2c_tx_ready      (c2c_tx_ready     ),
        .c2c_tx_tdata      (c2c_tx_tdata     ),
        .c2c_tx_tvalid     (c2c_tx_tvalid    ),
        .c2c_do_cc         (c2c_do_cc        ),
        .c2c_rxbufstatus   (c2c_rxbufstatus  ),
        .c2c_rxclkcorcnt   (c2c_rxclkcorcnt  ),
        .c2c_link_reset    (c2c_link_reset   )
    );
    
	mgt_gty_rx csc_outer [`CSC_LINKS_OUTER-1:0]();
	mgt_gty_rx csc_inner [`CSC_LINKS_INNER-1:0]();

	mgt_gty_rx rpc       [7:0]();
	mgt_gty_rx gem       [13:0]();

	mgt_gty_tx daq       [0:0]();
	mgt_gty_tx gmt       [24:0]();

	wire cstlp_23_mmcm_clk;
	wire cstlp_17_mmcm_clk;
	wire cstlp_19_mmcm_clk;
	wire slink_17_mmcm_clk;
	wire cstlp_21_mmcm_clk;


    emtf_vu13p_gty_serial_io serial_io
    (
        .drp_gty_fif       (drp_gty_i        ),
        .drpclk            (drp_clk          ),
        .refclk_p          (refclk_p         ),
        .refclk_n          (refclk_n         ),
        .tmb_outer         (csc_outer        ),
        .rpc               (rpc              ),
        .tmb_inner         (csc_inner        ),
        .gem               (gem              ),
        .daq               (daq              ),
        .gmt               (gmt              ),
        .cstlp_23_mmcm_clk (cstlp_23_mmcm_clk),
        .cstlp_17_mmcm_clk (cstlp_17_mmcm_clk),
        .cstlp_19_mmcm_clk (cstlp_19_mmcm_clk),
        .slink_17_mmcm_clk (slink_17_mmcm_clk),
        .cstlp_21_mmcm_clk (cstlp_21_mmcm_clk),
        .refclk            (refclk           ),
        .refclk_odiv       (refclk_odiv_b    )
    );


    BUFG_GT mgtrefclk_bufg [47:0]
    (
        .O       (refclk_odiv), 
        .CE      (1'b1),        
        .CEMASK  (1'b0),        
        .CLR     (1'b0),        
        .CLRMASK (1'b0),        
        .DIV     (3'h0),        
        .I       (refclk_odiv_b)
    );

    csc_outer_deformatted csc_outer_df [`CSC_OUTER-1:0];  
    csc_inner_deformatted csc_inner_df [`CSC_INNER-1:0];  
    wire ttc_bc0_del;
    csc_link_control csc_link_ctrl_outer [`CSC_LINKS_OUTER-1:0];
    csc_link_monitor csc_link_mntr_outer [`CSC_LINKS_OUTER-1:0];
    csc_link_control csc_link_ctrl_inner [`CSC_LINKS_INNER-1:0];
    csc_link_monitor csc_link_mntr_inner [`CSC_LINKS_INNER-1:0];
    wire csc_flag_reset; // reset persisting flags
    wire csc_en_manual; // enable manual delays

    csc_rx_all csc_rx
    (
        // data from MGTs
        .csc_outer_rx       (csc_outer),    // {MEN[4:0], ME4[5:0], ME3[5:0], ME2[5:0], ME1b[5:0], ME1a[5:0]}
        .csc_inner_rx       (csc_inner),    // {MEN[7:0], ME4[5:0], ME3[5:0], ME2[5:0], ME1b[5:0], ME1a[5:0]} two links per chamber
        .csc_outer_df       (csc_outer_df), // {MEN[4:0], ME4[5:0], ME3[5:0], ME2[5:0], ME1b[5:0], ME1a[5:0]}
        .csc_inner_df       (csc_inner_df), // {MEN[3:0], ME4[2:0], ME3[2:0], ME2[2:0], ME1b[2:0], ME1a[2:0]}
        .ttc_bc0_del        (ttc_bc0_del), // delayed BC0 from TTC to align to
        .link_control_outer (csc_link_ctrl_outer), 
        .link_monitor_outer (csc_link_mntr_outer),
        .link_control_inner (csc_link_ctrl_inner), 
        .link_monitor_inner (csc_link_mntr_inner),
        .flag_reset         (csc_flag_reset),  // reset persisting flags
        .en_manual          (csc_en_manual),   // enable manual delays
        .clk40              (clk40),
        .pcie_clk           (drp_clk),
        .clk320             ()
    );
        
    localparam CSTLP_LINK_N = 22; // $size(gem) + $size(rpc) - $size does not seem to work on arrays of interfaces
    wire reset           ;
    wire [CSTLP_LINK_N-1:0] reset_cnt_in    ;
    wire [CSTLP_LINK_N-1:0] reset_latched_in;
    wire [CSTLP_LINK_N-1:0] link_status_in  ;
    wire [CSTLP_LINK_N-1:0] align_marker_sel_in;
    wire [CSTLP_LINK_N-1:0] align_marker_dis_in;
    wire [CSTLP_LINK_N-1:0] disable_ICM_in;

    wire [63:0] unscrambled_data_out [CSTLP_LINK_N-1:0];
    wire [CSTLP_LINK_N-1:0] valid_bit_out;
    wire [CSTLP_LINK_N-1:0] rx_datavalid_out;
    
    wire rxram_pointer_t rxram_pointer_ctrl_in [CSTLP_LINK_N-1:0];
    wire lword rxdata_out [CSTLP_LINK_N-1:0];
    wire linkRxMetadata_t rxMetadata_out [CSTLP_LINK_N-1:0];
    wire linkStatusInfo_t linkStatusInfo_out [CSTLP_LINK_N-1:0];   
    wire ttc_clk_360M; 

    // CSTLP decoders for GEM and RPC
    cstlp_rx_tux 
    #(
        .N           (CSTLP_LINK_N)
    ) cstlp_rx
    (
        .freerun_clk           (drp_clk              ),
        .ttc_clk               (ttc_clk_360M         ), // must come from TCDS
        .reset                 (reset                ),
        .reset_cnt_in          (reset_cnt_in         ),
        .reset_latched_in      (reset_latched_in     ),
        .link_status_in        (link_status_in       ),
        .align_marker_sel_in   (align_marker_sel_in  ),
        .align_marker_dis_in   (align_marker_dis_in  ),
        .disable_ICM_in        (disable_ICM_in       ),
        
        .mgtrx                 ({gem, rpc}           ),
    
        .unscrambled_data_out  (unscrambled_data_out ),
        .valid_bit_out         (valid_bit_out        ),
        .rx_datavalid_out      (rx_datavalid_out     ),
        
        .rxram_pointer_ctrl_in (rxram_pointer_ctrl_in),
        .rxdata_out            (rxdata_out           ),
        .rxMetadata_out        (rxMetadata_out       ),
        .linkStatusInfo_out    (linkStatusInfo_out   )
    );    

    // temporary replacement for TCDS endpoint
    ttc_clk_mmcm ttc_clk
    (
        .clk_out1 (ttc_clk_360M),
        .clk_out2 (clk40),
        .clk_in1  (refclk_odiv [35]) // refclk[35] is 40M LHC clk from backplane
    );     
    
    wire [31:0] freq [47:0];
    freq_meter #(.REF_F (32'd50000000), .N (48)) fm
    (
        .ref_clk (drp_clk),
        .f       (refclk_odiv),
        .freq    (freq)
    );

    vio_freq vio_fm
    (
        .clk        (drp_clk),
        .probe_in0  (freq [0 ]),
        .probe_in1  (freq [1 ]),
        .probe_in2  (freq [2 ]),
        .probe_in3  (freq [3 ]),
        .probe_in4  (freq [4 ]),
        .probe_in5  (freq [5 ]),
        .probe_in6  (freq [6 ]),
        .probe_in7  (freq [7 ]),
        .probe_in8  (freq [8 ]),
        .probe_in9  (freq [9 ]),
        .probe_in10 (freq [10]),
        .probe_in11 (freq [11]),
        .probe_in12 (freq [12]),
        .probe_in13 (freq [13]),
        .probe_in14 (freq [14]),
        .probe_in15 (freq [15]),
        .probe_in16 (freq [16]),
        .probe_in17 (freq [17]),
        .probe_in18 (freq [18]),
        .probe_in19 (freq [19]),
        .probe_in20 (freq [20]),
        .probe_in21 (freq [21]),
        .probe_in22 (freq [22]),
        .probe_in23 (freq [23]),
        .probe_in24 (freq [24]),
        .probe_in25 (freq [25]),
        .probe_in26 (freq [26]),
        .probe_in27 (freq [27]),
        .probe_in28 (freq [28]),
        .probe_in29 (freq [29]),
        .probe_in30 (freq [30]),
        .probe_in31 (freq [31])
    );

endmodule
