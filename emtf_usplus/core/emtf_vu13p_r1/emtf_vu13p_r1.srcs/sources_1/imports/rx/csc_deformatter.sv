`include "csc_interfaces.sv"

// deformatter for inner chambers
module csc_deformatter 
#(
    parameter CSC_OUTER = "TRUE",
    parameter INNER_LINK = 1 // link 1 or 2 from inner chamber
)
(
    input [N_FRAMES*38-1:0] rx_data_o, 
    
    output csc_outer_deformatted csc_outer_df,
    output csc_inner_deformatted_l1 csc_inner_df_l1,
    output csc_inner_deformatted_l2 csc_inner_df_l2,
	output reg [25:0] stub_rate,

	output csc_link_id link_id,
	input clk40
);

    localparam N_FRAMES = CSC_OUTER == "TRUE" ? 3 : 2;

	reg [1:0] rsv;
	reg [1:0] crc;
    reg [8:0] lnk_val;
    reg [1:0] crc_rx;
	wire [N_FRAMES*38-1:0] rx_data_o_r;
	integer i, j;
	reg [3:0] dum4_1;
	reg [3:0] dum4_2;
	reg [3:0] cnt_4;
	reg [1:0] lctvf;
	reg [25:0] rate_period;
	reg [25:0] rate_counter;
	
	// dummy frames
    `MK_UNION(csc_dummy_frame, csc_d_u[N_FRAMES-1:0]);
    
    `MK_UNION(csc_outer_deformatted, cod_u); // outer chamber, all 3 frames
    assign csc_outer_df    = cod_u.s;
    `MK_UNION(csc_inner_deformatted_l1, cid_l1_u); // inner chamber link 1, two frames
    assign csc_inner_df_l1 = cid_l1_u.s;
    `MK_UNION(csc_inner_deformatted_l2, cid_l2_u); // inner chamber link 2, two frames
    assign csc_inner_df_l2 = cid_l2_u.s;
    
    assign rx_data_o_r = rx_data_o;

    always @(posedge clk40)
    begin
        if (!lnk_val) // if data is not valid, decode dummy frames
        begin
            if (N_FRAMES == 3)
                {csc_d_u[2].comb, csc_d_u[1].comb, csc_d_u[0].comb} = rx_data_o_r;
            else
                {csc_d_u[1].comb, csc_d_u[0].comb} = rx_data_o_r;
             
             // check and lock test counter
//             if (cnt_19 [i] != rx_data_76_r[i][56:38]) err_tst_pat[i] = 1'b1; 
//             cnt_19 [i] = rx_data_76_r[i][56:38];
        end
        cnt_4 ++;
    
        // rate counter update
//        if (lct_o[0].vf != 1'h0 && rate_counter != 26'h3ffffff) 
//            rate_counter++;
    
        if (rate_period == 26'd40078700) // 1 sec 
        begin
          // rate period expired, store and reset all counters
          for (i = 0; i < 9; i = i+1) // chamber loop
          begin
              stub_rate[i] = rate_counter[i]; 
              rate_counter[i] = 26'h0;
          end
          rate_period = 26'h0;
        end
        else 
          rate_period++;
    end

    reg [8:0] cscid1_bc0;
    reg [8:0] cscid1_vpf;

    always @(*)
    begin
        // determine if some of the frames are valid
        if (CSC_OUTER == "TRUE")
        begin
            cod_u.comb = rx_data_o_r; // place data word into format union
            lnk_val  = cod_u.s.f0.clct1.vf | cod_u.s.f1.clct2.vf; 
            lnk_val |= cod_u.s.f0.alct1.vf | cod_u.s.f1.alct2.vf;
            lnk_val |= cod_u.s.f2.hmt != 4'b0; 
            lnk_val |= cod_u.s.f0.bc0 | cod_u.s.f1.bc0 | cod_u.s.f2.bc0;
        end
        else
        begin
            if (INNER_LINK == 1)
            begin
                cid_l1_u.comb = rx_data_o_r; // place data word into format union
                lnk_val  = cid_l1_u.s.f0.clct1.vf | cid_l1_u.s.f1.clct2.vf; 
                lnk_val |= cid_l1_u.s.f0.alct1.vf;
                lnk_val |= cid_l1_u.s.f1.hmt != 4'b0; 
                lnk_val |= cid_l1_u.s.f0.bc0 | cid_l1_u.s.f1.bc0;
            end
            else
            begin
                cid_l2_u.comb = rx_data_o_r; // place data word into format union
                lnk_val  = cid_l2_u.s.f0.clct3.vf | cid_l2_u.s.f1.clct4.vf; 
                lnk_val |= cid_l2_u.s.f0.alct2.vf;
                lnk_val |= cid_l2_u.s.f0.bc0 | cid_l2_u.s.f1.bc0;
            end
        end
    end

endmodule
