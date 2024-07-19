`timescale 1ns / 1ps

`include "vppc_macros.sv"
`include "spbits.sv"

// neural net tux, IOs are matching SP core
module nn_tux
(
    // precise phi and theta of best tracks
    // [best_track_num]
    input [bw_fph-1:0] bt_phi [2:0],
    input [bw_th-1:0]  bt_theta [2:0],
    // [best_track_num][station]
    input [3:0]        bt_cpattern [2:0][3:0],
    // ph and th deltas from best stations
    // [best_track_num], last index: 0=12, 1=13, 2=14, 3=23, 4=24, 5=34
    input [bw_fph-1:0] bt_delta_ph [2:0][5:0],
    input [bw_th-1:0]  bt_delta_th [2:0][5:0], 
    input [5:0]        bt_sign_ph[2:0],
    input [5:0]        bt_sign_th[2:0],
    // ranks [best_track_num]
    input [bwr:0]      bt_rank [2:0],
    // segment IDs
    // [best_track_num][station 0-3]
    input [seg_ch-1:0] bt_vi [2:0][4:0], // valid
    input [1:0]        bt_hi [2:0][4:0], // bx index
    input [3:0]        bt_ci [2:0][4:0], // chamber
    input [4:0]        bt_si [2:0], // segment
    
    output reg [7:0] pt_out [2:0],
    output reg [2:0] pt_valid,
    output reg [1:0] d0_out [2:0],
    output reg [2:0] d0_valid,
    // clock
    input clk,
    input clk_120,
    
    input endcap,
    input [2:0] sector

);

    logic [3:0] mode [2:0];
    logic [1:0] mux_phase = 2'h0;
    logic [1:0] mux_phase_out [2:0] = '{2'd0, 2'd2, 2'd1}; // output multiplexor depends on exact NN latency.

    assign mode[0] = {bt_rank[0][5], bt_rank[0][3], bt_rank[0][1], bt_rank[0][0]};
    assign mode[1] = {bt_rank[1][5], bt_rank[1][3], bt_rank[1][1], bt_rank[1][0]};
    assign mode[2] = {bt_rank[2][5], bt_rank[2][3], bt_rank[2][1], bt_rank[2][0]};
    

    logic [7:0] PT;
    logic [6:0] dXY;
    logic track_v;
    
    reg [7:0] pt_r [2:0];
    reg [1:0] d0_r [2:0];
    reg [2:0] valid_track_r;

    always @(posedge clk)
    begin 
        // Register module outputs at 40MHz
        pt_out <= pt_r;
        d0_out <= d0_r;
        d0_valid <= valid_track_r;
        pt_valid <= valid_track_r;
        
    end
    
    
    always @(posedge clk_120)
    begin
    
        // Register nn_wrapper outputs at 120MHz
        pt_r[mux_phase_out[mux_phase]] <= PT;
        d0_r [mux_phase_out[mux_phase]] <= dXY[6:5];
        valid_track_r[mux_phase_out[mux_phase]] <=  track_v;
        
        // Cycle through tracks being put into NN, doesn't matter what order they are input, just that mux_phase_out is set correctly
        if (mux_phase >= 2'h2)
            mux_phase <= 2'h0;
        else
            mux_phase <= mux_phase + 1;

    end


    emtfnn_wrapper dxy_nn (
            .ap_clk(clk_120),
            .ap_rst(1'b0),
            
            .delta_phi0_V(bt_delta_ph[mux_phase][0]),
            .delta_phi1_V(bt_delta_ph[mux_phase][1]),
            .delta_phi2_V(bt_delta_ph[mux_phase][2]),
            .delta_phi3_V(bt_delta_ph[mux_phase][3]),
            .delta_phi4_V(bt_delta_ph[mux_phase][4]),
            .delta_phi5_V(bt_delta_ph[mux_phase][5]),
            .sign_phi0_V (bt_sign_ph[mux_phase][0]),
            .sign_phi1_V (bt_sign_ph[mux_phase][1]),
            .sign_phi2_V (bt_sign_ph[mux_phase][2]),
            .sign_phi3_V (bt_sign_ph[mux_phase][3]),
            .sign_phi4_V (bt_sign_ph[mux_phase][4]),
            .sign_phi5_V (bt_sign_ph[mux_phase][5]),
            
            .delta_th0_V(bt_delta_th[mux_phase][0]),
            .delta_th1_V(bt_delta_th[mux_phase][1]),
            .delta_th2_V(bt_delta_th[mux_phase][2]),
            .delta_th3_V(bt_delta_th[mux_phase][3]),
            .delta_th4_V(bt_delta_th[mux_phase][4]),
            .delta_th5_V(bt_delta_th[mux_phase][5]),
            .sign_th0_V (bt_sign_th[mux_phase][0]),
            .sign_th1_V (bt_sign_th[mux_phase][1]),
            .sign_th2_V (bt_sign_th[mux_phase][2]),
            .sign_th3_V (bt_sign_th[mux_phase][3]),
            .sign_th4_V (bt_sign_th[mux_phase][4]),
            .sign_th5_V (bt_sign_th[mux_phase][5]),
            
            .cpattern_0_V(bt_cpattern [mux_phase][0]),
            .cpattern_1_V(bt_cpattern [mux_phase][1]),
            .cpattern_2_V(bt_cpattern [mux_phase][2]),
            .cpattern_3_V(bt_cpattern [mux_phase][3]),
            
            .theta_V(bt_theta[mux_phase]),
     
            .mode_V(mode[mux_phase]),
            
            .pT_V(PT),
            .dxy_V(dXY),
            .valid_track_V(track_v)
    );
    

endmodule

