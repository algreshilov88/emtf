// alignment module for CSCIDs 2..9
// simple shift register with adjustable length, 
// + some error detection
// + alignment to BC0, automatic and manual

`include "mpcx_interface.sv"

module mpcx_aligner_id2_9
(
    input            csc_lct_mpcx lct_i [1:0], // input LCTs from chamber
    output           csc_lct_mpcx lct_o [1:0], // aligned LCTs
    input            ttc_bc0_del, // delayed BC0 from TTC to align to
    output reg [4:0] automatic_delay, // calculated delay
    input      [4:0] manual_delay, // manually applied delay
    input            en_manual, // enable manual delay
    output           alg_out_range, // alignment counter out of range
    output reg       bc0_period_err, // BC0 period is not exactly one orbit
    input     [11:0] bxn, // BX counter for BC0 period error detection
    input            clk
);

    wire [4:0] applied_delay = (en_manual == 'b1) ? manual_delay : automatic_delay;

    csc_mpcx_u csc_i;
    assign csc_i.lcts.lct0 = lct_i[0];
    assign csc_i.lcts.lct1 = lct_i[1];

    csc_mpcx_u csc_o;
    // if alignment delay is 0, feed inputs directly to outputs
    assign lct_o[0] = (applied_delay == 'b0) ? lct_i[0] : csc_o.lcts.lct0;
    assign lct_o[1] = (applied_delay == 'b0) ? lct_i[1] : csc_o.lcts.lct1;


    reg [4:0] cnt = 'h0;
    assign alg_out_range = (cnt == 5'h1f); // counter reached terminal value = alignment out of range, or BC0 did not come
    
    wire lct_bc0 = lct_i[0].bc0; // BC0 coming from link, without delay
    reg lct_bc0_r;
    reg [11:0] bc0_bxn; // BX number when BC0 came
    reg cnt_run = 1'b0;
    reg [1:0] orbit_cnt;
    
    integer i;
    always @(posedge clk)
    begin
        if (lct_bc0)
        begin 
            cnt = 'h0; // reset counter when BC0 came from link
            cnt_run = 1'b1; // enable counter
            orbit_cnt = 2'h0; // reset orbit count on each BC0 from link
        end
        else
            if (cnt < 'h1f && cnt_run == 1'b1) 
                cnt++; // count if no BC0        
    
        if (ttc_bc0_del)
        begin 
            automatic_delay = cnt; // lock delay value when delayed TTC BC0 comes
            cnt_run = 1'b0; // disable counter
            if (orbit_cnt == 2'h3) // BC0 from link did not come during last 3 orbits
                bc0_period_err = 1'b1;
            orbit_cnt++; // count orbits for missing BC0 detector
        end
        
        if (!lct_bc0_r && lct_bc0) // BC0 edge
        begin
            bc0_period_err = 1'b1;
            if (bc0_bxn == bxn) bc0_period_err = 1'b0;
            bc0_bxn = bxn; // remember when BC0 came
        end
        
        lct_bc0_r = lct_bc0; // LCT BC0 history
    end
    
    dyn_shift #(.SELWIDTH(5), .BW (64)) ds 
    (
        .CLK (clk), 
        .CE  ('b1), 
        .SEL (applied_delay - 5'b1), // value of 0 gives delay of 1
        .SI  (csc_i.comb), 
        .DO  (csc_o.comb)
    );

endmodule
