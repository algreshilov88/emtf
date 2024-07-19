`include "csc_interfaces.sv"
`include "mgt_gty_interfaces.sv"

module csc_rx_single
#(
    parameter CSC_OUTER = "TRUE",
    parameter INNER_LINK = 1 // link 1 or 2 from inner chamber
)
(
    // data from MGT
	mgt_gty_rx csc_rx, 

	// deformatted and aligned data
	// only one output is used depending on CSC_OUTER parameter
    output csc_outer_deformatted csc_outer_df, 
    output csc_inner_deformatted_l1 csc_inner_df_l1,
    output csc_inner_deformatted_l2 csc_inner_df_l2,
     
    input ttc_bc0_del, // delayed BC0 from TTC to align to
    input [11:0] bxn,

    // all link controls
    input csc_link_control link_control, 

    // monitorable values for link    
    output csc_link_monitor link_monitor,

    input        flag_reset, // reset persisting flags

    input en_manual, // enable manual delays

	input  clk40,
	input  clk320,
    input  pcie_clk
);


    localparam N_FRAMES = CSC_OUTER == "TRUE" ? 3 : 2;
    (* mark_debug *) wire [N_FRAMES*38-1:0] rx_data_o; // deframed
    // always 9 chambers from each RX, neighbor or not
	wire [7:0] cscid1_bc0; // separate bc0 markers from CSCID=1 coming in each link
	wire [3:0] cscid1_vf [1:0]; // separate valid flags from cid=1 coming in each link [lct0,1][link]

    // deframer
    csc_deframer #(.N_FRAMES (N_FRAMES)) csc_deframer_i
    (
        .mgtrx         (csc_rx),
        .rx_data_o     (rx_data_o), // deframed and reclocked data word
        .crc_err       (link_monitor.crc_err     ),
        .crc_err_flag  (link_monitor.crc_err_flag),
        .flag_reset    (flag_reset),
        .rx_fa_reset   (1'b0), // reset frame alignment and everything else - not really needed
        .fiber_enable  (link_control.fiber_enable),
        .clk40         (clk40), // clk40, 80, and 320 must have relative phase=0
        .clk320        (clk320),
        .pcie_clk      (pcie_clk)
    );

    generate    
        if (CSC_OUTER == "TRUE")
        begin
            csc_deformatter #(.CSC_OUTER (CSC_OUTER), .INNER_LINK(INNER_LINK)) csc_df
            (
                .rx_data_o       (rx_data_o),
                .csc_outer_df    (csc_outer_df),
                .stub_rate       (link_monitor.stub_rate),
                .link_id         (link_monitor.link_id),
                .clk40           (clk40)
            );
        end
        else
        begin
            if (INNER_LINK == 1)
            begin
                csc_deformatter #(.CSC_OUTER (CSC_OUTER), .INNER_LINK(INNER_LINK)) csc_df
                (
                    .rx_data_o       (rx_data_o),
                    .csc_inner_df_l1 (csc_inner_df_l1),
                    .stub_rate       (link_monitor.stub_rate),
                    .link_id         (link_monitor.link_id),
                    .clk40           (clk40)
                );
            end
            else
            begin
                csc_deformatter #(.CSC_OUTER (CSC_OUTER), .INNER_LINK(INNER_LINK)) csc_df
                (
                    .rx_data_o       (rx_data_o),
                    .csc_inner_df_l2 (csc_inner_df_l2),
                    .stub_rate       (link_monitor.stub_rate),
                    .link_id         (link_monitor.link_id),
                    .clk40           (clk40)
                );
            end
        end
    endgenerate

//                mpcx_aligner_id2_9 aligner29
//                (
//                    .lct_i           (lct_unaligned[gi]  ), // input LCTs from chamber
//                    .lct_o           (lct_aligned[gi]    ), // aligned LCTs
//                    .ttc_bc0_del     (ttc_bc0_del        ), // delayed BC0 from TTC to align to
//                    .automatic_delay (automatic_delay[gi]), // calculated delay
//                    .manual_delay    (manual_delay[gi]   ), // manually applied delay
//                    .en_manual       (en_manual          ), // enable manual delay
//                    .alg_out_range   (alg_out_range[gi]  ), // alignment counter out of range
//                    .bc0_period_err  (bc0_period_err[gi] ), // BC0 period is not exactly one orbit
//                    .bxn             (bxn                ), // BX counter for BC0 period error detection
//                    .clk             (clk40       )
//                );
endmodule
