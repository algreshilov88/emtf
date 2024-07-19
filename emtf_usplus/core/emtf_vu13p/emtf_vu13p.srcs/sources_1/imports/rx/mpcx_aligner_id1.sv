// alignment module for CSCID 1
// since CSCID=1 chamber is transmitted in chunks via 8 links, need to align each chunk separately
// using its own BC0 marker 
// + some error detection

`include "mpcx_interface.sv"

module mpcx_aligner_id1
(
    input            csc_lct_mpcx lct_i [1:0], // input LCTs from chamber
    output           csc_lct_mpcx lct_o [1:0], // aligned LCTs
    input      [7:0] cscid1_bc0, // separate bc0 markers from CSCID=1 coming in each link
	input      [3:0] cscid1_vf [1:0], // separate valid flags from cid=1 coming in each link [lct0,1][link]
    input            ttc_bc0_del, // delayed BC0 from TTC to align to
    output reg [4:0] automatic_delay [7:0], // calculated delays, per link fragment
    input      [4:0] manual_delay [7:0], // manually applied delays, per link fragment
    input            en_manual, // enable manual delay
    output     [7:0] alg_out_range, // alignment counter out of range, per fragment
    output reg [7:0] bc0_period_err, // BC0 period is not exactly one orbit, per fragment
    input     [11:0] bxn, // BX counter for BC0 period error detection
    input            clk
);

    // split input data into link fragments
    wire [8:0] fragment_i [7:0]; // input chamber data fragments from each link
    assign fragment_i[0] = {cscid1_vf[0][0], lct_i[0].hs};
    assign fragment_i[1] = {cscid1_vf[0][1], lct_i[0].wg, lct_i[0].lr};
    assign fragment_i[2] = {cscid1_vf[0][2], lct_i[0].ql, lct_i[0].cp};
    assign fragment_i[3] = {cscid1_vf[0][3], lct_i[0].cid, lct_i[0].bx0, lct_i[0].ser};
    assign fragment_i[4] = {cscid1_vf[1][0], lct_i[1].hs};                                                 
    assign fragment_i[5] = {cscid1_vf[1][1], lct_i[1].wg, lct_i[1].lr};                                   
    assign fragment_i[6] = {cscid1_vf[1][2], lct_i[1].ql, lct_i[1].cp};                                   
    assign fragment_i[7] = {cscid1_vf[1][3], lct_i[1].cid, lct_i[1].bx0, lct_i[1].ser};

    wire [4:0] applied_delay [7:0] = (en_manual == 'b1) ? manual_delay : automatic_delay;

    reg  [8:0] fragment_o [7:0]; // output chamber data fragments
    wire [8:0] fragment_d [7:0]; // delayed chamber data fragments
	reg  [3:0] cscid1_vf_d [1:0]; // delayed valid flags from cid=1 coming in each link [lct0,1][link]
    // if alignment delay is 0, feed inputs directly to outputs
    integer i;
    always @(*)
    begin
        for (i = 0; i < 8; i++) // fragment loop
        begin
            if (applied_delay[i] == 'b0) fragment_o[i] = fragment_i[i];
            else                         fragment_o[i] = fragment_d[i]; 
        end        
        // assemble delayed fragments back into structures
        {cscid1_vf_d[0][0], lct_o[0].hs}                              = fragment_o[0];
        {cscid1_vf_d[0][1], lct_o[0].wg, lct_o[0].lr}                 = fragment_o[1];
        {cscid1_vf_d[0][2], lct_o[0].ql, lct_o[0].cp}                 = fragment_o[2];
        {cscid1_vf_d[0][3], lct_o[0].cid, lct_o[0].bx0, lct_o[0].ser} = fragment_o[3];
        {cscid1_vf_d[1][0], lct_o[1].hs}                              = fragment_o[4];                                                 
        {cscid1_vf_d[1][1], lct_o[1].wg, lct_o[1].lr}                 = fragment_o[5];                                   
        {cscid1_vf_d[1][2], lct_o[1].ql, lct_o[1].cp}                 = fragment_o[6];                                   
        {cscid1_vf_d[1][3], lct_o[1].cid, lct_o[1].bx0, lct_o[1].ser} = fragment_o[7];
        
        // if valid flag is missing in any of the fragments, invalidate entire LCT 
        lct_o[0].vf = &(cscid1_vf_d[0]);
        lct_o[1].vf = &(cscid1_vf_d[1]);
        
         lct_o[0].bc0 = ttc_bc0_del;
         lct_o[1].bc0 = ttc_bc0_del;

    end
    

    reg [4:0] cnt [7:0] = '{8{'h0}};
    
    wire [7:0] lct_bc0 = cscid1_bc0; // BC0 coming from link, without delay
    reg  [7:0] lct_bc0_r;
    reg  [11:0] bc0_bxn [7:0]; // BX number when BC0 came
    reg  [7:0] cnt_run = 8'h0;
    
    always @(posedge clk)
    begin
        for (i = 0; i < 8; i++)
        begin
            if (lct_bc0[i])
            begin 
                cnt[i] = 'h0; // reset counter when BC0 came from link
                cnt_run[i] = 1'b1; // enable counter at BC0 from link
            end
            else
                if (cnt[i] < 'h1f && cnt_run[i] == 1'b1) 
                    cnt[i]++; // count if no BC0        
        
            if (ttc_bc0_del)
            begin 
                automatic_delay[i] = cnt[i]; // lock delay value when delayed TTC BC0 comes
                cnt_run[i] = 1'b0; // disable counter at delayed TTC BC0 
            end
            
            if (!lct_bc0_r[i] && lct_bc0[i]) // BC0 edge
            begin
                bc0_period_err[i] = 1'b1;
                if (bc0_bxn[i] == bxn) bc0_period_err[i] = 1'b0; // bc0 came in time, no errors
                bc0_bxn[i] = bxn; // remember when BC0 came
            end
        end
        lct_bc0_r = lct_bc0; // LCT BC0 history
    end
    
    genvar gi;
    generate
        for (gi = 0; gi < 8; gi++)
        begin: dyn_shift_loop
            dyn_shift #(.SELWIDTH(5), .BW (9)) ds 
            (
                .CLK (clk), 
                .CE  ('b1), 
                .SEL (applied_delay[gi] - 5'b1), // value of 0 gives delay of 1
                .SI  (fragment_i[gi]), 
                .DO  (fragment_d[gi])
            );
            assign alg_out_range[gi] = (cnt[gi] == 5'h1f); // counter reached terminal value = alignment out of range, or BC0 did not come
        end
    endgenerate

endmodule

