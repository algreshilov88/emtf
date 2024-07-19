// alignment module for GEM
// simple shift register with adjustable length, 
// + some error detection
// + alignment to BC0, automatic and manual

module gem_aligner
(
    input            [111:0] frame_i, // input frame
    output           [111:0] frame_o, // aligned frame
    input            ttc_bc0_del, // delayed BC0 from TTC to align to
    input            lct_bc0, // BC0 input from this chamber
    output           bc0, // aligned BC0
    input            link_id_flag, // link ID flag
    output           link_id_flag_o, // aligned link ID flag
    output reg [4:0] automatic_delay, // calculated delay
    input      [4:0] manual_delay, // manually applied delay
    input            en_manual, // enable manual delay
    output           alg_out_range, // alignment counter out of range
    output reg       bc0_period_err, // BC0 period is not exactly one orbit
    input     [11:0] bxn, // BX counter for BC0 period error detection
    input            clk
);

    wire [4:0] applied_delay = (en_manual == 'b1) ? manual_delay : automatic_delay;

    wire [111:0] frame_d;
    wire bc0_d;
    wire link_id_flag_d;
    // if alignment delay is 0, feed inputs directly to outputs
    assign frame_o = (applied_delay == 'b0) ? frame_i : frame_d;
    assign bc0     = (applied_delay == 'b0) ? lct_bc0 : bc0_d;
    assign link_id_flag_o = (applied_delay == 'b0) ? link_id_flag : link_id_flag_d;


    reg [4:0] cnt = 'h0;
    assign alg_out_range = (cnt == 5'h1f); // counter reached terminal value = alignment out of range, or BC0 did not come
    
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
    
    dyn_shift #(.SELWIDTH(5), .BW (114)) ds 
    (
        .CLK (clk), 
        .CE  ('b1), 
        .SEL (applied_delay - 5'b1), // value of 0 gives delay of 1
        .SI  ({frame_i, lct_bc0, link_id_flag}), 
        .DO  ({frame_d,   bc0_d, link_id_flag_d})
    );

endmodule
