`include "mpcx_interface.sv"
`include "mgt_interfaces.sv"


module emtf_mpcx_rx #(parameter NEIGHBOR = "FALSE")
(
	mgt_rx mpcx_rx [nlinks-1:0], // input data + clocks
	// deformatted and aligned data
    output csc_lct_mpcx lct_aligned   [9:1][1:0], // [CSCID][stub]
	output [25:0] stub_rate [8:0],
    
    input ttc_bc0_del, // delayed BC0 from TTC to align to

    // calculated delays for all chambers
    // index [1] is only present for neighbor sector
    output [4:0] automatic_delay [9 : low_ind], 

    // calculated delays for CSCID=1 only, for each data fragment
    // unused for neighbor sector
    output [4:0] automatic_delay_id1 [7:0], 

    // manually applied delays, for all chambers that are on a single link
    input [4:0] manual_delay [9 : low_ind], 
    
    // manually applied delays, for CSCID=1, for each data fragment
    // unused for neighbor sector
    input [4:0] manual_delay_id1 [7:0], 
	
    output [9 : low_ind] alg_out_range, // alignment counter out of range
    output [9 : low_ind] bc0_period_err, // BC0 period is not exactly one orbit
    
    // these are for CSCID=1 only, unused for neighbor sector
    output [7:0] alg_out_range_id1, // alignment counters out of range
    output [7:0] bc0_period_err_id1, // BC0 periods is not exactly one orbit
    
    input en_manual, // enable manual delays

	output [nlinks-1:0] crc_err, // CRC error detected
    output [nlinks-1:0] err_tst_pat, // test counter error detected
	output [nlinks-1:0] crc_err_flag, // CRC error detected, persisting
    output [nlinks-1:0] err_tst_pat_flag, // test counter error detected, persisting
    input               flag_reset, // reset persisting flags
	output [9:0] link_id [nlinks-1:0], // link ID
	input  [nlinks-1:0] fiber_enable,
    input [25:0] hmt_rate_limit,
    output [8:0] hmt_rate_err, // [chamber] hmt rate exceeded hmt_rate_limit

	input clk40,
	input clk320,
    input pcie_clk
);

    localparam nlinks =  NEIGHBOR == "TRUE" ? 9 : 8; // 9 links are coming from NEIGHBOR sector
    localparam low_ind = ((NEIGHBOR == "TRUE") ? 1 : 2); // low index for I/O

    (* mark_debug *) wire [75:0] rx_data_76 [nlinks-1:0];
    // always 9 chambers from each RX, neighbor or not
    csc_lct_mpcx lct_unaligned [9:1][1:0]; // [CSCID][stub]
	wire [7:0] cscid1_bc0; // separate bc0 markers from CSCID=1 coming in each link
	wire [3:0] cscid1_vf [1:0]; // separate valid flags from cid=1 coming in each link [lct0,1][link]
    reg [11:0] bxn;

    genvar gi;
    generate
        for (gi = 0; gi < nlinks; gi++)
        begin: rx_loop
            // deframer and reclocker for each link
            mpcx_rx mpcx_rx_i
            (
                .mgtrx         (mpcx_rx[gi]),
                .rx_data_76    (rx_data_76[gi]), // deframed and reclocked data word
                .rx_fa_reset   (1'b0), // reset frame alignment and everything else - not really needed
                .fiber_enable  (fiber_enable[gi]),
                .clk40         (clk40), // clk40, 80, and 320 must have relative phase=0
                .clk320        (clk320),
                .pcie_clk      (pcie_clk)
            );
        end

        if (NEIGHBOR == "TRUE")
        begin // neighbor sector
            mpcx_deformatter_neighbor mpcx_df_n
            (
                .rx_data_76 (rx_data_76),
                .lct_o      (lct_unaligned),
                .stub_rate  (stub_rate),
                .hmt_rate_limit      (hmt_rate_limit),
                .hmt_rate_err        (hmt_rate_err  ), // hmt rate exceeded hmt_rate_limit
            
                .crc_err      (crc_err),
                .crc_err_flag (crc_err_flag),
                .link_id      (link_id),
                .err_tst_pat  (err_tst_pat),
                .err_tst_pat_flag  (err_tst_pat_flag),
                .flag_reset   (flag_reset),
                .clk40        (clk40)
            );

            for (gi = 1; gi <= 9; gi++)
            begin: align29_n_loop
                mpcx_aligner_id2_9 aligner29
                (
                    .lct_i           (lct_unaligned[gi]  ), // input LCTs from chamber
                    .lct_o           (lct_aligned[gi]    ), // aligned LCTs
                    .ttc_bc0_del     (ttc_bc0_del        ), // delayed BC0 from TTC to align to
                    .automatic_delay (automatic_delay[gi]), // calculated delay
                    .manual_delay    (manual_delay[gi]   ), // manually applied delay
                    .en_manual       (en_manual          ), // enable manual delay
                    .alg_out_range   (alg_out_range[gi]  ), // alignment counter out of range
                    .bc0_period_err  (bc0_period_err[gi] ), // BC0 period is not exactly one orbit
                    .bxn             (bxn                ), // BX counter for BC0 period error detection
                    .clk             (clk40       )
                );
            end
        end
        else
        begin // regular station
            mpcx_deformatter mpcx_df
            (
                .rx_data_76 (rx_data_76),
                .lct_o      (lct_unaligned),
                .stub_rate  (stub_rate),
                .hmt_rate_limit      (hmt_rate_limit),
                .hmt_rate_err        (hmt_rate_err  ), // hmt rate exceeded hmt_rate_limit
            
                .cid1_bc0     (cscid1_bc0), // separate bc0 markers from CSCID=1 coming in each link
                .cid1_vf      (cscid1_vf),
                .crc_err      (crc_err   ),
                .crc_err_flag (crc_err_flag),
                .link_id      (link_id   ),
                .err_tst_pat  (err_tst_pat),
                .err_tst_pat_flag  (err_tst_pat_flag),
                .flag_reset   (flag_reset),
                .clk40        (clk40)
            );

            // aligner for CSCID=1
            mpcx_aligner_id1 aligner1
            (
                .lct_i           (lct_unaligned[1]   ), // input LCTs from chamber
                .lct_o           (lct_aligned[1]     ), // aligned LCTs
                .cscid1_bc0      (cscid1_bc0         ), // separate bc0 markers from CSCID=1 coming in each link
                .cscid1_vf       (cscid1_vf),
                .ttc_bc0_del     (ttc_bc0_del        ), // delayed BC0 from TTC to align to
                .automatic_delay (automatic_delay_id1), // calculated delay
                .manual_delay    (manual_delay_id1   ), // manually applied delay
                .en_manual       (en_manual          ), // enable manual delay
                .alg_out_range   (alg_out_range_id1  ), // alignment counter out of range
                .bc0_period_err  (bc0_period_err_id1 ), // BC0 period is not exactly one orbit
                .bxn             (bxn                ), // BX counter for BC0 period error detection
                .clk             (clk40       )
            );
        
            // aligners for CSCIDs = 2..9
            for (gi = 2; gi <= 9; gi++)
            begin: align29_loop
                mpcx_aligner_id2_9 aligner29
                (
                    .lct_i           (lct_unaligned[gi]  ), // input LCTs from chamber
                    .lct_o           (lct_aligned[gi]    ), // aligned LCTs
                    .ttc_bc0_del     (ttc_bc0_del        ), // delayed BC0 from TTC to align to
                    .automatic_delay (automatic_delay[gi]), // calculated delay
                    .manual_delay    (manual_delay[gi]   ), // manually applied delay
                    .en_manual       (en_manual          ), // enable manual delay
                    .alg_out_range   (alg_out_range[gi]  ), // alignment counter out of range
                    .bc0_period_err  (bc0_period_err[gi] ), // BC0 period is not exactly one orbit
                    .bxn             (bxn                ), // BX counter for BC0 period error detection
                    .clk             (clk40      )
                );
            end
        end
    
    endgenerate

    always @(posedge clk40)
    begin
        // free-running BX counter for BC0 period error detection
        // does not need resetting
        bxn++;
        if (bxn == 12'd3564) bxn = 12'h0;
    end

endmodule
