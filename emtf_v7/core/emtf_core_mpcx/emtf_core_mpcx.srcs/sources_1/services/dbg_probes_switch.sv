`include "mpcx_interface.sv"
`include "interfaces.sv"

module dbg_probes_switch
(
    // [station][chamber][segment] station 5 = neighbor sector, all stations
    input csc_lct_mpcx lct_i [5:0][8:0][seg_ch-1:0],
    input [233:0]      ge11_rxd [6:0],
	ge11_cluster.in ge11_cl [6:0][1:0][7:0], // [schamber][layer][cluster]
    input clk40
);
`include "spbits.sv"

    (* mark_debug *) csc_lct_mpcx lct_sel [2:0][seg_ch-1:0]; // selected LCTs
    (* mark_debug *) ge11_cluster_struct ge11_sel [2:0];
    (* mark_debug *) wire [233:0] ge11_rxd_sel;
    ge11_cluster_struct ge11_cl_in [6:0][1:0][7:0]; // [schamber][layer][cluster]

    genvar gi, gj, gk;
    generate
        for (gi = 0; gi < 7; gi++)
            for (gj = 0; gj < 2; gj++)
                for (gk = 0; gk < 8; gk++)
                begin
                    assign ge11_cl_in[gi][gj][gk].str = ge11_cl[gi][gj][gk].str;
                    assign ge11_cl_in[gi][gj][gk].prt = ge11_cl[gi][gj][gk].prt;
                    assign ge11_cl_in[gi][gj][gk].csz = ge11_cl[gi][gj][gk].csz;
                    assign ge11_cl_in[gi][gj][gk].vf  = ge11_cl[gi][gj][gk].vf ;
                end
            
    endgenerate

    wire [2:0] sel_station [2:0];
    wire [3:0] sel_chamber [2:0];
    wire [2:0] gsel_schamber [2:0];
    wire [2:0] gsel_layer ;
    wire [2:0] gsel_cluster [2:0];
    
    assign lct_sel[0] = lct_i[sel_station[0]][sel_chamber[0]];
    assign lct_sel[1] = lct_i[sel_station[1]][sel_chamber[1]];
    assign lct_sel[2] = lct_i[sel_station[2]][sel_chamber[2]];
    
    assign ge11_sel[0] = ge11_cl_in [gsel_schamber[0]][gsel_layer[0]][ gsel_cluster[0]];
    assign ge11_sel[1] = ge11_cl_in [gsel_schamber[1]][gsel_layer[1]][ gsel_cluster[1]];
    assign ge11_sel[2] = ge11_cl_in [gsel_schamber[2]][gsel_layer[2]][ gsel_cluster[2]];
    
    assign ge11_rxd_sel = ge11_rxd[gsel_schamber[0]];
    
    mpcx_dbg_vio mpcx_vio 
    (
        .clk        (clk40),           
        .probe_out0 (sel_station[0]),  
        .probe_out1 (sel_station[1]),  
        .probe_out2 (sel_station[2]),  
        
        .probe_out3 (sel_chamber[0]),  
        .probe_out4 (sel_chamber[1]),  
        .probe_out5 (sel_chamber[2]),  

        .probe_out6  (gsel_schamber[0]),
        .probe_out7  (gsel_schamber[1]),
        .probe_out8  (gsel_schamber[2]),

        .probe_out9  (gsel_layer[0]),   
        .probe_out10 (gsel_layer[1]),   
        .probe_out11 (gsel_layer[2]),   

        .probe_out12 (gsel_cluster[0]), 
        .probe_out13 (gsel_cluster[1]), 
        .probe_out14 (gsel_cluster[2])  

    );
    

endmodule

