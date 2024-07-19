`timescale 1ns / 1ps

module output_delay
(
    // inputs
	input [bw_fph-1:0] bt_phi [2:0],
    input [bw_th-1:0]  bt_theta [2:0],
    // ph and th deltas from best stations
    // [best_track_num], last index: 0=12, 1=13, 2=14, 3=23, 4=24, 5=34
    input [5:0]        bt_sign_ph[2:0],
    // ranks [best_track_num]
    input [bwr:0]      bt_rank [2:0],
    // segment IDs
    // [best_track_num][station 0-3]
    input [seg_ch-1:0] bt_vi [2:0][4:0], // valid
    input [1:0]        bt_hi [2:0][4:0], // bx index
    input [3:0]        bt_ci [2:0][4:0], // chamber
    input [4:0]        bt_si [2:0], // segment

	input [29:0] ptlut_addr [2:0], // memory addresses formed by core
	input [7:0] gmt_phi [2:0],
    input [8:0] gmt_eta [2:0],
    input [3:0] gmt_qlt [2:0],
    input [2:0] gmt_crg,

    // delayed outputs
	output reg [bw_fph-1:0] bt_phi_d [2:0],
    output reg [bw_th-1:0]  bt_theta_d [2:0],
    // ph and th deltas from best stations
    // [best_track_num], last index: 0=12, 1=13, 2=14, 3=23, 4=24, 5=34
    output reg [5:0]        bt_sign_ph_d[2:0],
    // ranks [best_track_num]
    output reg [bwr:0]      bt_rank_d [2:0],
    // segment IDs
    // [best_track_num][station 0-3]
    output reg [seg_ch-1:0] bt_vi_d [2:0][4:0], // valid
    output reg [1:0]        bt_hi_d [2:0][4:0], // bx index
    output reg [3:0]        bt_ci_d [2:0][4:0], // chamber
    output reg [4:0]        bt_si_d [2:0], // segment

	output [29:0] ptlut_addr_d [2:0], // memory addresses formed by core
	output [7:0] gmt_phi_d [2:0],
    output [8:0] gmt_eta_d [2:0],
    output [3:0] gmt_qlt_d [2:0],
    output [2:0] gmt_crg_d,
    
    output fp_trigger,

    input clk
);

`include "../core/spbits.sv"

    
    localparam bt_bw = bw_fph*3 + bw_th*3 + 6*3 + (bwr+1)*3 + (seg_ch + 2 + 4 + 1)*3*5; // all bt_ bits
    localparam pta_bw = (30 + 8 + 9 + 4 + 1)*3; // all pt addresses and gmt phi, eta, quality, and charge
    localparam bt_delay = 4; // including address formatter
    localparam pta_delay = 3; // not including address formatter
    
    reg [bt_bw-1 : 0] comb_out_in;
    wire [bt_bw-1 : 0] comb_out_out;

`define pi(n) posi = posi + n
`define po(n) poso = poso + n
    // pack & unpack all delayed parameters
    integer i, j, posi, poso;

    always @(*)
    begin
        posi = 0; poso = 0;
        for (i = 0; i < 3; i = i+1) // best track loop
        begin
            comb_out_in[posi +: bw_fph]  = bt_phi[i];     `pi(bw_fph);
            comb_out_in[posi +: bw_th]   = bt_theta[i];   `pi(bw_th);
            comb_out_in[posi +: 6]       = bt_sign_ph[i]; `pi(6);
            comb_out_in[posi +: (bwr+1)] = bt_rank[i];    `pi(bwr+1);
            comb_out_in[posi +: 5]       = bt_si[i];      `pi(5);
            
            bt_phi_d[i]     = comb_out_out[poso +: bw_fph];  `po(bw_fph);
            bt_theta_d[i]   = comb_out_out[poso +: bw_th];   `po(bw_th);
            bt_sign_ph_d[i] = comb_out_out[poso +: 6];       `po(6);
            bt_rank_d[i]    = comb_out_out[poso +: (bwr+1)]; `po(bwr+1);
            bt_si_d[i]      = comb_out_out[poso +: 5];       `po(5);

            for (j = 0; j < 5; j = j+1) // station loop
            begin
                comb_out_in[posi +: seg_ch] = bt_vi[i][j];      `pi(seg_ch);
                comb_out_in[posi +: 2]      = bt_hi[i][j];      `pi(2);
                comb_out_in[posi +: 4]      = bt_ci[i][j];      `pi(4);

                bt_vi_d[i][j]      = comb_out_out[poso +: seg_ch]; `po(seg_ch);
                bt_hi_d[i][j]      = comb_out_out[poso +: 2];      `po(2);
                bt_ci_d[i][j]      = comb_out_out[poso +: 4];      `po(4);
            end
        end
    end

    // PT LUT latency compensator, for all bt_ parameters
    dyn_shift #(.BW(bt_bw)) bt_dl (.CLK(clk), .CE(1'b1), .SEL(bt_delay), .SI(comb_out_in), .DO(comb_out_out));

    // separate delay line for front panel trigger
    dyn_shift #(.BW(1)) fp_dl (.CLK(clk), .CE(1'b1), .SEL(bt_delay), .SI(bt_rank[0] == 7'h0 && bt_rank[2] == 7'h0), .DO(fp_trigger));

    // for pt addresses and gmt parameters
    dyn_shift #(.BW(pta_bw)) pta_dl 
    (
        .CLK(clk), 
        .CE(1'b1), 
        .SEL(pta_delay), 
        .SI
        ({
            ptlut_addr[2], ptlut_addr[1], ptlut_addr[0],
            gmt_phi[2], gmt_phi[1], gmt_phi[0], 
            gmt_eta[2], gmt_eta[1], gmt_eta[0],
            gmt_qlt[2], gmt_qlt[1], gmt_qlt[0],
            gmt_crg[2], gmt_crg[1], gmt_crg[0]
        }), 
        .DO
        ({
            ptlut_addr_d[2], ptlut_addr_d[1], ptlut_addr_d[0],
            gmt_phi_d[2], gmt_phi_d[1], gmt_phi_d[0], 
            gmt_eta_d[2], gmt_eta_d[1], gmt_eta_d[0],
            gmt_qlt_d[2], gmt_qlt_d[1], gmt_qlt_d[0],
            gmt_crg_d[2], gmt_crg_d[1], gmt_crg_d[0]
        })
    );


endmodule
