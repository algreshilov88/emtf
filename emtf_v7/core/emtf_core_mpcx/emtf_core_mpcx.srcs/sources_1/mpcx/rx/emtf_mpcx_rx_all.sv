`include "mpcx_interface.sv"
`include "mgt_interfaces.sv"

module emtf_mpcx_rx_all
(
	mgt_rx mpcx_rx   [4:0][7:0], // input data + clocks from own sector [station][link]
	mgt_rx mpcx_rx_n [8:0], // input data + clocks from neighbor sector [link]
	// deformatted and aligned data
    output csc_lct_mpcx lct_aligned  [5:0][9:1][1:0], // [station][CSCID][stub]
    output [25:0] stub_rate [5:0][9:1], //[station][CSCID]

    input ttc_bc0_del, // delayed BC0 from TTC to align to

    // calculated delays for all chambers in own sector, CSCIDs = 2..9
    // index [1] is only present for neighbor sector
    output [4:0] automatic_delay [4:0][9:2], // [station][cscid] 

    // calculated delays for CSCID=1 only, for each data fragment
    // unused for neighbor sector
    output [4:0] automatic_delay_id1 [4:0][7:0], // [station][cscid=1 data fragment]

    // calculated delays for all chambers in own sector, CSCIDs = 2..9
    // index [1] is only present for neighbor sector
    output [4:0] automatic_delay_n [9:1], // [chamber] 

    // manually applied delays, for all chambers that are on a single link
    input [4:0] manual_delay [4:0][9:2], // [station][cscid] 
    
    // manually applied delays, for CSCID=1, for each data fragment
    // unused for neighbor sector
    input [4:0] manual_delay_id1 [4:0][7:0], // [station][cscid=1 data fragment] 
	
    // manually applied delays, for all chambers that are on a single link
    input [4:0] manual_delay_n [9:1], // [chamber] 

    output [9:2] alg_out_range  [4:0], // alignment counter out of range [station][cscid]
    output [9:2] bc0_period_err [4:0], // BC0 period is not exactly one orbit [station][cscid]
    
    // these are for CSCID=1 only, unused for neighbor sector
    output [7:0] alg_out_range_id1  [4:0], // alignment counters out of range      [station][cscid=1 data fragment]
    output [7:0] bc0_period_err_id1 [4:0], // BC0 periods is not exactly one orbit [station][cscid=1 data fragment]

    // for neighbor sector
    output [9:1] alg_out_range_n  , // alignment counter out of range [station][chamber]
    output [9:1] bc0_period_err_n , // BC0 period is not exactly one orbit [station][chamber]

    // errors and link IDs from own sector
	output [7:0] crc_err     [4:0], // CRC error detected [station][link]
    output [7:0] err_tst_pat [4:0], // test counter error detected [station][link]
	output [7:0] crc_err_flag     [4:0], // CRC error detected, persisting
    output [7:0] err_tst_pat_flag [4:0], // test counter error detected, persisting
	output [9:0] link_id     [4:0][7:0], // link ID [station][link]

    // errors and link IDs from neighbor sector
	output [8:0] crc_err_n, // CRC error detected [link]
    output [8:0] err_tst_pat_n, // test counter error detected [link]
	output [8:0] crc_err_flag_n, // CRC error detected [link]
    output [8:0] err_tst_pat_flag_n, // test counter error detected [link]

    input        flag_reset, // reset persisting flags
    input [48:0] fiber_enable, // fiber enable flags
	output [9:0] link_id_n [8:0], // link ID [link]

    input en_manual, // enable manual delays
    input [25:0] hmt_rate_limit,
    output [8:0] hmt_rate_err [5:0], // [station][chamber] hmt rate exceeded hmt_rate_limit

	input  clk40,
    input  pcie_clk,
	output clk320
);



    genvar gi;
    generate
        for (gi = 0; gi < 5; gi++) // MPC loop
        begin: mpc_loop
            emtf_mpcx_rx #(.NEIGHBOR ("FALSE")) emtf_mpcx_rx_i
            (
                .mpcx_rx             (mpcx_rx             [gi]),
                .lct_aligned         (lct_aligned         [gi]),
                .stub_rate           (stub_rate           [gi]),
                .ttc_bc0_del         (ttc_bc0_del             ), 
                .automatic_delay     (automatic_delay     [gi]), 
                .automatic_delay_id1 (automatic_delay_id1 [gi]), 
                .manual_delay        (manual_delay        [gi]), 
                .manual_delay_id1    (manual_delay_id1    [gi]), 
                .alg_out_range       (alg_out_range       [gi]), 
                .bc0_period_err      (bc0_period_err      [gi]), 
                .alg_out_range_id1   (alg_out_range_id1   [gi]), 
                .bc0_period_err_id1  (bc0_period_err_id1  [gi]), 
                .en_manual           (en_manual               ),
	            .crc_err             (crc_err             [gi]),
                .err_tst_pat         (err_tst_pat         [gi]),
	            .crc_err_flag        (crc_err_flag        [gi]),
                .err_tst_pat_flag    (err_tst_pat_flag    [gi]),
                .flag_reset          (flag_reset              ),
	            .link_id             (link_id             [gi]),
	            .fiber_enable        (fiber_enable [gi*8 +: 8]),
                .hmt_rate_limit      (hmt_rate_limit),
                .hmt_rate_err        (hmt_rate_err        [gi]), // [station][chamber] hmt rate exceeded hmt_rate_limit
        
                .clk40               (clk40                   ),
                .clk320              (clk320                  ),
                .pcie_clk            (pcie_clk                )
            );
        end
    endgenerate

    emtf_mpcx_rx #(.NEIGHBOR ("TRUE")) emtf_mpcx_rx_n
    (
        .mpcx_rx             (mpcx_rx_n          ),
        .lct_aligned         (lct_aligned [5]    ),
        .stub_rate           (stub_rate   [5]    ),
        .ttc_bc0_del         (ttc_bc0_del        ), 
        .automatic_delay     (automatic_delay_n  ), 
        .manual_delay        (manual_delay_n     ), 
        .alg_out_range       (alg_out_range_n    ), 
        .bc0_period_err      (bc0_period_err_n   ), 
        .en_manual           (en_manual          ),
        .crc_err             (crc_err_n          ),
        .err_tst_pat         (err_tst_pat_n      ),
        .crc_err_flag        (crc_err_flag_n     ),
        .err_tst_pat_flag    (err_tst_pat_flag_n ),
        .flag_reset          (flag_reset         ),
	    .link_id             (link_id_n          ),
        .fiber_enable        (fiber_enable [48:40]),
        .hmt_rate_limit      (hmt_rate_limit),
        .hmt_rate_err        (hmt_rate_err     [5]), // [station][chamber] hmt rate exceeded hmt_rate_limit

        .clk40               (clk40              ),
        .clk320              (clk320             ),
        .pcie_clk            (pcie_clk           )
    );

    mpcx_mmcm mpcx_mmcm_i
    (
        .clk_in1  (clk40 ),
        .clk_out1 (clk320),
        .reset    (1'b0  ), 
        .locked   (      )
    );    
endmodule
