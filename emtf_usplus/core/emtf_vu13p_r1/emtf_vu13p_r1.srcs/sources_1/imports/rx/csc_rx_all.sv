`include "csc_interfaces.sv"
`include "mgt_gty_interfaces.sv"

module csc_rx_all
(
    // data from MGTs
	mgt_gty_rx.out csc_outer_rx [`CSC_LINKS_OUTER-1:0], // {MEN[4:0], ME4[5:0], ME3[5:0], ME2[5:0], ME1b[5:0], ME1a[5:0]}
	// links are interleaved like this: {2,1,2,1,2,1, etc}
	mgt_gty_rx.out csc_inner_rx [`CSC_LINKS_INNER-1:0], // {MEN[7:0], ME4[5:0], ME3[5:0], ME2[5:0], ME1b[5:0], ME1a[5:0]} two links per chamber

	// deformatted and aligned data
    output csc_outer_deformatted csc_outer_df [`CSC_OUTER-1:0], // {MEN[4:0], ME4[5:0], ME3[5:0], ME2[5:0], ME1b[5:0], ME1a[5:0]} 
    output csc_inner_deformatted csc_inner_df [`CSC_INNER-1:0], // {MEN[3:0], ME4[2:0], ME3[2:0], ME2[2:0], ME1b[2:0], ME1a[2:0]} 

    input ttc_bc0_del, // delayed BC0 from TTC to align to

    // all link controls
    input csc_link_control link_control_outer [`CSC_LINKS_OUTER-1:0], 
    input csc_link_control link_control_inner [`CSC_LINKS_INNER-1:0], 

    // monitorable values for each link    
    output csc_link_monitor link_monitor_outer [`CSC_LINKS_OUTER-1:0],
    output csc_link_monitor link_monitor_inner [`CSC_LINKS_INNER-1:0],

    input        flag_reset, // reset persisting flags

    input en_manual, // enable manual delays

	input  clk40,
    input  pcie_clk,
	output clk320
);

    reg [11:0] bxn;

    genvar gi;
    generate
        for (gi = 0; gi < `CSC_INNER; gi++)
        begin: inner_rx_loop
            csc_rx_single #(.CSC_OUTER("FALSE"), .INNER_LINK(1)) csc_rx_single_l1
            (
                .csc_rx          (csc_inner_rx[gi*2]), // links are interleaved like this: {2,1,2,1,2,1, etc}
                .csc_inner_df_l1 (csc_inner_df[gi].l1[gi]),
                .ttc_bc0_del     (ttc_bc0_del), // delayed BC0 from TTC to align to
                .bxn             (bxn),
                .link_control    (link_control_inner[gi*2]), 
                .link_monitor    (link_monitor_inner[gi*2]),
                .flag_reset      (flag_reset), // reset persisting flags
                .en_manual       (en_manual), // enable manual delays
                .clk40           (clk40),
                .clk320          (clk320),
                .pcie_clk        (pcie_clk)
            );
            csc_rx_single #(.CSC_OUTER("FALSE"), .INNER_LINK(2)) csc_rx_single_l2
            (
                .csc_rx          (csc_inner_rx[gi*2+1]), // links are interleaved like this: {2,1,2,1,2,1, etc}
                .csc_inner_df_l2 (csc_inner_df[gi].l2[gi]),
                .ttc_bc0_del     (ttc_bc0_del), // delayed BC0 from TTC to align to
                .bxn             (bxn),
                .link_control    (link_control_inner[gi*2+1]), 
                .link_monitor    (link_monitor_inner[gi*2+1]),
                .flag_reset      (flag_reset), // reset persisting flags
                .en_manual       (en_manual), // enable manual delays
                .clk40           (clk40),
                .clk320          (clk320),
                .pcie_clk        (pcie_clk)
            );
            
        end
        for (gi = 0; gi < `CSC_OUTER; gi++)
        begin: outer_rx_loop
            csc_rx_single #(.CSC_OUTER("TRUE"), .INNER_LINK(0)) csc_rx_single_i
            (
                .csc_rx       (csc_outer_rx[gi]),
                .csc_outer_df (csc_outer_df[gi]),
                .ttc_bc0_del  (ttc_bc0_del), // delayed BC0 from TTC to align to
                .bxn          (bxn),
                .link_control (link_control_outer[gi]), 
                .link_monitor (link_monitor_outer[gi]),
                .flag_reset   (flag_reset), // reset persisting flags
                .en_manual    (en_manual), // enable manual delays
                .clk40        (clk40),
                .clk320       (clk320),
                .pcie_clk     (pcie_clk)
            );
        end
    endgenerate

    always @(posedge clk40)
    begin
        // free-running BX counter for BC0 period error detection
        // does not need resetting
        bxn++;
        if (bxn == 12'd3564) bxn = 12'h0;
    end

    csc_mmcm csc_mmcm_i
    (
        .clk_in1  (clk40 ),
        .clk_out1 (clk320)
    );    

    `MK_UNION(csc_outer_deformatted, cod_u[`CSC_OUTER-1:0]);
    `MK_UNION(csc_inner_deformatted, cid_u[`CSC_INNER-1:0]);
    generate
        for (gi = 0; gi < `CSC_OUTER; gi++)
        begin: outer_u_loop
            assign cod_u[gi].s = csc_outer_df[gi]; 
        end
        for (gi = 0; gi < `CSC_INNER; gi++)
        begin: inner_u_loop
            assign cid_u[gi].s = csc_inner_df[gi]; 
        end
    endgenerate

    csc_ila csc_ila_i 
    (
        .clk     (clk40), // input wire clk
        .probe0  (cid_u[0 ].comb), // input wire [151:0]  probe0   
        .probe1  (cid_u[1 ].comb), // input wire [151:0]  probe1   
        .probe2  (cid_u[2 ].comb), // input wire [151:0]  probe2   
        .probe3  (cid_u[3 ].comb), // input wire [151:0]  probe3   
        .probe4  (cid_u[4 ].comb), // input wire [151:0]  probe4   
        .probe5  (cid_u[5 ].comb), // input wire [151:0]  probe5   
        .probe6  (cid_u[6 ].comb), // input wire [151:0]  probe6   
        .probe7  (cid_u[7 ].comb), // input wire [151:0]  probe7   
        .probe8  (cid_u[8 ].comb), // input wire [151:0]  probe8   
        .probe9  (cid_u[9 ].comb), // input wire [151:0]  probe9   
        .probe10 (cid_u[10].comb), // input wire [151:0]  probe10  
        .probe11 (cid_u[11].comb), // input wire [151:0]  probe11  
        .probe12 (cid_u[12].comb), // input wire [151:0]  probe12  
        .probe13 (cid_u[13].comb), // input wire [151:0]  probe13  
        .probe14 (cid_u[14].comb), // input wire [151:0]  probe14  
        .probe15 (cid_u[15].comb), // input wire [151:0]  probe15  
        .probe16 (cid_u[16].comb), // input wire [151:0]  probe16  
        .probe17 (cid_u[17].comb), // input wire [151:0]  probe17  
        .probe18 (cid_u[18].comb), // input wire [151:0]  probe18  
        .probe19 (cod_u[0 ].comb), // input wire [113:0]  probe19  
        .probe20 (cod_u[1 ].comb), // input wire [113:0]  probe20  
        .probe21 (cod_u[2 ].comb), // input wire [113:0]  probe21  
        .probe22 (cod_u[3 ].comb), // input wire [113:0]  probe22  
        .probe23 (cod_u[4 ].comb), // input wire [113:0]  probe23  
        .probe24 (cod_u[5 ].comb), // input wire [113:0]  probe24  
        .probe25 (cod_u[6 ].comb), // input wire [113:0]  probe25  
        .probe26 (cod_u[7 ].comb), // input wire [113:0]  probe26  
        .probe27 (cod_u[8 ].comb), // input wire [113:0]  probe27  
        .probe28 (cod_u[9 ].comb), // input wire [113:0]  probe28  
        .probe29 (cod_u[10].comb), // input wire [113:0]  probe29  
        .probe30 (cod_u[11].comb), // input wire [113:0]  probe30  
        .probe31 (cod_u[12].comb), // input wire [113:0]  probe31  
        .probe32 (cod_u[13].comb), // input wire [113:0]  probe32  
        .probe33 (cod_u[14].comb), // input wire [113:0]  probe33  
        .probe34 (cod_u[15].comb), // input wire [113:0]  probe34  
        .probe35 (cod_u[16].comb), // input wire [113:0]  probe35
        .probe36 (cod_u[17].comb), // input wire [113:0]  probe36
        .probe37 (cod_u[18].comb), // input wire [113:0]  probe37
        .probe38 (cod_u[19].comb), // input wire [113:0]  probe38
        .probe39 (cod_u[20].comb), // input wire [113:0]  probe39
        .probe40 (cod_u[21].comb), // input wire [113:0]  probe40
        .probe41 (cod_u[22].comb), // input wire [113:0]  probe41
        .probe42 (cod_u[23].comb), // input wire [113:0]  probe42
        .probe43 (cod_u[24].comb), // input wire [113:0]  probe43
        .probe44 (cod_u[25].comb), // input wire [113:0]  probe44
        .probe45 (cod_u[26].comb), // input wire [113:0]  probe45
        .probe46 (cod_u[27].comb), // input wire [113:0]  probe46
        .probe47 (cod_u[28].comb), // input wire [113:0]  probe47
        .probe48 (cod_u[29].comb), // input wire [113:0]  probe48
        .probe49 (cod_u[30].comb), // input wire [113:0]  probe49
        .probe50 (cod_u[31].comb), // input wire [113:0]  probe50
        .probe51 (cod_u[32].comb), // input wire [113:0]  probe51
        .probe52 (cod_u[33].comb), // input wire [113:0]  probe52
        .probe53 (cod_u[34].comb)  // input wire [113:0]  probe53
    );
    

endmodule
