`timescale 1ns / 1ps
`include "../core/vppc_macros.sv"
module output_formatter
(
    input bc0,

    // ph and th deltas from best stations
    // [best_track_num], last index: 0=12, 1=13, 2=14, 3=23, 4=24, 5=34
    input [5:0]        bt_sign_ph[2:0],
    // ranks [best_track_num]
    input [bwr:0]      bt_rank [2:0],
    // track parameters in gmt scales
	input [7:0] gmt_phi [2:0],
    input [8:0] gmt_eta [2:0],
    input [3:0] gmt_qlt [2:0],
    input [2:0] gmt_crg,
    // segment IDs
    // [best_track_num][station 0-3]
    input [seg_ch-1:0] bt_vi [2:0][4:0], // valid
    input [1:0]        bt_hi [2:0][4:0], // bx index
    input [3:0]        bt_ci [2:0][4:0], // chamber
    input [4:0]        bt_si [2:0], // segment
    
    input [8:0] bt_pt [2:0], // pt values for best tracks
    output reg [8:0] bt_pt_tx [2:0], // pt values for best tracks as transmitted to uGMT
    
    output reg [63:0] txdata [2:0],
    
    input test_patterns_output,
    input [9:0] link_id,
    input endcap,
    
    input clk,
    
    output reg [25:0] track_rate [2:0],
    input hard_reset,
    input [23:0] hard_reset_to
);

`include "../core/spbits.sv"

    integer i, j;

    reg [11:0] bxn;
    
    (* mark_debug = "TRUE" *) wire [63:0] txdata_w [2:0] = txdata;

    reg [3:0] qcode [2:0];
    reg [25:0] rate_counter [2:0];
    reg [25:0] rate_period;
    reg [3:0] trk_id [3:0];
    reg [3:0] gmt_qlt_i [2:0];
    reg [2:0] gmt_crg_i;
    reg [2:0] gmt_cvl_i;
	reg [8:0] gmt_eta_abs [2:0];
    reg [23:0] hr_cnt;

    always @(*)
    begin
        for (i = 0; i < 3; i = i+1)
        begin
        
            // format track IDs
            trk_id[0] = 4'd0;
            trk_id[1] = 4'd0;
            trk_id[2] = 4'd0;
            trk_id[3] = 4'd0;
            if (bt_vi[i][0]) // ME1a is valid
            begin
                trk_id[0][0] = bt_si[i][0];
                // select only chambers that overlap with neighbor sectors
                case (bt_ci[i][0])
                    10: begin trk_id[0][3:1] = 3'd1; end
                    11: begin trk_id[0][3:1] = 3'd2; end
                    12: begin trk_id[0][3:1] = 3'd3; end
                endcase
            end
            else if (bt_vi[i][1]) // ME1b is valid
            begin
                trk_id[0][0] = bt_si[i][1];
                // select only chambers that overlap with neighbor sectors
                case (bt_ci[i][1])
                    3:  begin trk_id[0][3:1] = 3'd4; end
                    6:  begin trk_id[0][3:1] = 3'd5; end
                    9:  begin trk_id[0][3:1] = 3'd6; end
                endcase
            end
            
            for (j = 1; j <= 3; j = j+1) // ME2,3,4 loop
            begin
                if (bt_vi[i][j+1]) // ME2 (or 3 or 4) is valid
                begin
                    trk_id[j][0] = bt_si[i][j+1]; // stub ID
                    // select only chambers that overlap with neighbor sectors
                    case (bt_ci[i][j+1])
                        10:  begin trk_id[j][3:1] = 3'd1; end
                        11:  begin trk_id[j][3:1] = 3'd2; end
                        3:   begin trk_id[j][3:1] = 3'd3; end
                        9:   begin trk_id[j][3:1] = 3'd4; end
                    endcase
                end
            end

        
            // modifications for 2mu+LCT trigger, synchronous with daq module
            qcode[i] = {bt_rank[i][5], bt_rank[i][3], bt_rank[i][1:0]}; // simulation of quality - just chamber bits
            // qcode == 0 -> no track, Pt = 0
            // qcode == 1 -> single LCT, Pt = 1
            gmt_qlt_i[i] = gmt_qlt[i];
            gmt_crg_i[i] = gmt_crg[i];
            gmt_cvl_i[i] = 1'b1;
            bt_pt_tx[i] = (qcode[i] == 4'h0) ? 9'h0 : bt_pt[i];
            
            // single LCT track logic according to Andrew's message from 2017-08-09
            if (qcode[i] == 4'b1) // single LCT track
            begin
                // gmt_qlt_i initially carries CLCT pattern
                gmt_crg_i[i] = (gmt_qlt_i[i] == 4'd10) ? 1'b0 : 
                               (endcap == 1'b0) ? gmt_qlt_i[i][0] : ~gmt_qlt_i[i][0]; 
                gmt_cvl_i[i] = (gmt_qlt_i[i] == 4'd10) ? 1'b0 : 1'b1;
                gmt_qlt_i[i] = {2'b0, gmt_qlt[i][3:2]}; // quality is CLCT pattern/4
				if (endcap == 1'b1) gmt_eta_abs[i] = ~gmt_eta[i]; // get back the original positive eta in Z-
				else                gmt_eta_abs[i] =  gmt_eta[i];
                bt_pt_tx[i] = 9'd10 - gmt_eta_abs[i][8:5];
            end
            // end of 2mu+LCT logic
            txdata[i][8:0] = bt_pt_tx[i]; 
            txdata[i][12:9] = gmt_qlt_i[i];
            txdata[i][22] = 1'b0; // halo bit is 0 at this time
            txdata[i][32] = gmt_crg_i[i]; // finally proper charge
            txdata[i][33] = gmt_cvl_i[i]; 
            txdata[i][30:23] = gmt_phi[i]; // phi
            txdata[i][62:34] = {bxn[10:0], i[1:0], trk_id[3], trk_id[2], trk_id[1], trk_id[0]}; // track addresses
            txdata[i][21:13] = gmt_eta[i]; // eta
            
            
        end
        // remove outputs if there was HR recently
        if (hr_cnt > 24'h0)
        begin
            txdata[0] = 0;
            txdata[1] = 0;
            txdata[2] = 0;
        end

        txdata[0][31] = bc0;
        txdata[0][63] = 1'b0; // sync error is not set at this time
        txdata[1][31] = bxn[0];
        txdata[1][63] = bxn[1];
        txdata[2][31] = bxn[2];
        txdata[2][63] = 1'b0; // reserved

    end

    always @(posedge clk)
    begin
        for (i = 0; i < 3; i = i+1)
        begin
//            if (txdata[i][12:9] != 4'h0 && rate_counter[i] != 26'h3ffffff) rate_counter[i] = rate_counter[i] + 26'h1;
            // need to use quality here, because gmt_qlt can be ==0 for single-LCT tracks
            if (qcode[i] != 4'h0 && rate_counter[i] != 26'h3ffffff) rate_counter[i] = rate_counter[i] + 26'h1;
        end

		if (rate_period == 26'd40078700) // 1 sec 
		begin
		  // rate period expired, store and reset all counters
		  for (i = 0; i < 3; i = i+1)
		  begin
              track_rate[i] = rate_counter[i]; 
		      rate_counter[i] = 26'h0;
		  end
		  rate_period = 26'h0;
		end
		else 
		  rate_period = rate_period + 26'h1;

        if (bc0) bxn = 12'h0;
        else `inc(bxn);
        
        // logic for disabling outputs during hard reset, to prevent rate spikes
        if (hard_reset == 1'b1)
            hr_cnt = hard_reset_to;
        else 
        if (hr_cnt > 24'h0)
            hr_cnt--;
    end
endmodule
