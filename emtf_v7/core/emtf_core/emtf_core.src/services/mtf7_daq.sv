module mtf7_daq
(

    csc_lct lct_i [5:0][8:0][seg_ch-1:0],
    input [48:0] bc0_err_period,
    input [4:0] bc0_err_period_id1,
    input [63:0] cppf_rxd [6:0][2:0], // cppf rx data, 3 frames x 64 bit, for 7 links
    input [6:0] cppf_rx_valid, // cprx data valid flags
    input [63:0] fiber_enable, // enable flags for input fibers
    input [6:0] cppf_crc_match, // CRC match flags from CPPF links
							  								   
	// precise phi and eta of best tracks
	// [best_track_num]
	input [8:0] bt_pt [2:0],
	input [bw_fph-1:0] bt_phi [2:0],
	// ranks [best_track_num]
	input [bwr:0] 		bt_rank [2:0],
	// segment IDs
	// [best_track_num][station 0-3]
	input [seg_ch-1:0]  bt_vi [2:0][4:0], // valid
	input [1:0] 		bt_hi [2:0][4:0], // bx index
	input [3:0] 		bt_ci [2:0][4:0], // chamber
	input [4:0] 		bt_si [2:0], // segment
	input [29:0] ptlut_addr [2:0], // pt lut address
	input [7:0] gmt_phi [2:0],
    input [8:0] gmt_eta [2:0],
    input [3:0] gmt_qlt [2:0],
    input [2:0] gmt_crg,

    // clock
    input 				clk,

	input [55:0] daq_config,
	
	input l1a_in,
	input ttc_resync,
	input ttc_bc0,
	input ttc_ev_cnt_reset,
	input ttc_or_cnt_reset,

	output reg [63:0] daq_data,
	output reg daq_valid,
	output reg daq_first,
	output reg daq_last,
	output clk_80,
	input amc13_ready,
    output reg [7:0] amc13_to_counter = 8'h0,
    output reg [3:0] tts_data,

	input [4:0] sp_addr, // uTCA slot number
	input [3:0] sp_ts, // Trigger sector ME+ = 0..5, ME- = 8..13
	
	input reset,
	output [63:0] daq_state_cnt,
	output resync_and_empty,
	input [31:0] fw_date,
	
	input [7:0] af_delays [48:0],
	
	output reg [15:0] orbit_count,
    output reg [11:0] bxn_counter,
    output reg [23:0] l1a_count,
    input force_oos    
	
 );

`include "../core/vppc_macros.sv"
`include "../core/spbits.sv"



    // chamber enable flags. Linkless chambers are enabled only when all links carrying them are enabled.
	wire [11:0] me1a_en = {fiber_enable[42:40], fiber_enable[ 7: 0], &(fiber_enable[ 7: 0])}; 
	wire [8:0]  me1b_en = {                     fiber_enable[15: 8], &(fiber_enable[15: 8])};
	wire [10:0] me2_en  = {fiber_enable[44:43], fiber_enable[23:16], &(fiber_enable[23:16])};
	wire [10:0] me3_en  = {fiber_enable[46:45], fiber_enable[31:24], &(fiber_enable[31:24])};
	wire [10:0] me4_en  = {fiber_enable[48:47], fiber_enable[39:32], &(fiber_enable[39:32])};
	wire [6:0] cppf_en  = fiber_enable[55:49];
	wire endcap = sp_ts[3]; // endcap number


   // width of input data (q, wg, hstr, cpat, lr, vp) * 2 segments * 9 chambers * 6 stations (incl. neighbor) + link statuses
   `localpar INP_DEL_BW = ((4+bw_wg+bw_hs+4+1+1)*seg_ch*(9*6)+49+5);
   
   // width of RPC input data (7 links by 3 frames by 64 bits each, plus 7 valid bits, plus 7 CRC match bits)
   `localpar RPC_INP_DEL_BW = 64*3*7 + 7 + 7; 

   // width of output data (bt_*, gmt_*)
   `localpar OUT_DEL_BW = ((9+bw_fph+9+4)*3 + (seg_ch+2+4)*3*5 + 5*3 + 30*3 + 3*3 + 8*3 + 4*3 + 1*3);
	
	// data width for ring buffer
    `localpar RING_BW = INP_DEL_BW + OUT_DEL_BW + RPC_INP_DEL_BW;

    wire [7:0] l1a_delay;
	wire [2:0] l1a_window; // how many BXs to report on each L1A
	wire [7:0] valor_delay;
	wire [2:0] valor_window;
	wire [11:0] bxn_offset;
	wire [15:0] board_id;
	wire stress; // stress test
	wire amc13_easy_en; // enable reducing payload if AMC13 gets full 
	wire report_wo_track; // if =1 DAQ will report events that don't contain valid tracks but contain LCTs
	wire [2:0] rpc_late_by_bxs; // by how many BXs RPC data is late relative to CSC
	
    assign {rpc_late_by_bxs, report_wo_track, amc13_easy_en, stress, board_id, bxn_offset, valor_window, valor_delay, l1a_window, l1a_delay} = daq_config;


   wire [3:0] bt_q [2:0];
   genvar gi;
   generate
        // convert rank into quality
       for (gi = 0; gi < 3; gi = gi+1)
       begin: rank_q
           assign bt_q[gi] = {bt_rank[gi][5], bt_rank[gi][3], bt_rank[gi][1:0]};
       end
   endgenerate 

   wire [7:0] 			core_latency = 8'd12; // 8'd13; reduced because zones and extenders now combinatorial. Check core latency in coord_delay
   wire [7:0] 			ptlut_latency = 8'd4; // including address formation
   wire [7:0]           rpc_late_by = {5'h0, rpc_late_by_bxs}; // cppf data are late by this many clocks
   
   
   // first index in the declarations below is daq_bank word
    reg [3:0]        q_d    [7:0][5:0][8:0][seg_ch-1:0];
    reg [bw_wg-1:0]  wg_d   [7:0][5:0][8:0][seg_ch-1:0];
    reg [bw_hs-1:0]  hstr_d [7:0][5:0][8:0][seg_ch-1:0];
    reg [3:0] 	     cpat_d [7:0][5:0][8:0][seg_ch-1:0];
	reg [seg_ch-1:0] lr_d   [7:0][5:0][8:0];
	reg [seg_ch-1:0] vp_d   [7:0][5:0][8:0];
								   								   
	reg [8:0]        bt_pt_d [7:0][2:0];
	reg [bw_fph-1:0] bt_phi_d [7:0][2:0];
	reg [8:0] 	     gmt_eta_d [7:0][2:0];
	reg [7:0] 	     gmt_phi_d [7:0][2:0];
	reg [3:0] 	     gmt_qlt_d [7:0][2:0];
	reg [2:0] 	     gmt_crg_d [7:0];
	reg [3:0] 		 bt_q_d [7:0][2:0];
	// segment IDs
	// [best_track_num][station 0-3]
	reg [seg_ch-1:0] bt_vi_d [7:0][2:0][4:0]; // valid
	reg [1:0] 		 bt_hi_d [7:0][2:0][4:0]; // bx index
	reg [3:0] 		 bt_ci_d [7:0][2:0][4:0]; // chamber
	reg [4:0] 		 bt_si_d [7:0][2:0]; // segment
	reg [2:0] bxn_counter_d [7:0][2:0];
	reg [29:0] ptlut_addr_d [7:0][2:0];

   
   reg [7:0] 		  id_addrr;
   wire [7:0] 		  od_addrr;
   wire [7:0] 		  id_addrw;
   wire [7:0] 		  rpc_id_addrw;
   wire [7:0] 		  od_addrw;

	assign id_addrw = id_addrr + l1a_delay + core_latency + ptlut_latency;
	assign rpc_id_addrw = id_addrr + l1a_delay + core_latency + ptlut_latency - rpc_late_by; // rpc delay reduced to compensate data coming late
	assign od_addrw = od_addrr + l1a_delay;// + ptlut_latency;
	assign od_addrr = id_addrr;
   

   integer ind = 0;
   integer i,j,k,l;
   integer pos, mew, rpc_pos, rpc_ring_pos, rpcw;
   integer out_pos, out_ring_pos;
   reg [INP_DEL_BW-1:0]  inp_del_in;
   wire [INP_DEL_BW-1:0]  inp_del_out;
   
   reg [RPC_INP_DEL_BW-1:0]  rpc_inp_del_in;
   wire [RPC_INP_DEL_BW-1:0]  rpc_inp_del_out;

   reg [OUT_DEL_BW-1:0]  out_del_in;
   wire [OUT_DEL_BW-1:0]  out_del_out;

	`localpar lng = 4 + bw_wg + bw_hs + 4 + 1 + 1;
	`localpar out_lng = OUT_DEL_BW/3;

	`localpar me_data_wc = 9*6*2; // count of all possible segments from ME
	`localpar rpc_data_wc = 7*3*4; // count of all possible RPC hits
	
	reg [RING_BW-1:0] daq_bank [7:0]; 
    reg [2:0] daq_bank_cnt;

	// ME and RPC data records  [time_bin][segment]
	reg [63:0] me_data [7:0][me_data_wc-1:0];
	reg [63:0] rpc_data [7:0][rpc_data_wc-1:0];
	// track data record [time_bin][best track][word-two words per track]
	reg [63:0] track_data [7:0][2:0][1:0];
	reg [3:0] csc_id;
	reg [2:0] tbin;
	reg [2:0] station_;
    reg [5:0] me1id;
    reg [2:0] me1tbin;
    reg [4:0] me2id, me3id, me4id;
    reg [2:0] me2tbin, me3tbin, me4tbin;
    reg bt_valid, lct_valid;
    reg [59:0] af_del_w [6:0]; // words for alignment fifo delays 
    reg [63:0] af_del_daq [6:0]; // words for alignment fifo delays with field ID inserted
    reg [4:0] le_id1_d; // links errors CSCID=1 delayed 
    reg [48:0] le_d; // link errors delayed

    // [daq_bank][link][frame][hit in frame]
    reg [10:0] rpc_ph_d [7:0][6:0][2:0][3:0]; // 
    reg [4:0]  rpc_th_d [7:0][6:0][2:0][3:0]; // 
    reg [6:0] cppf_rx_valid_d [7:0]; // cprx data valid flags
    reg [6:0] cppf_crc_match_d [7:0]; // cprx crc match
    reg [1:0] rpc_frm, rpc_frw;
    reg rpc_val;
    reg [3:0] gmt_qlt_i [2:0];
    reg [2:0] gmt_crg_i;
    reg [2:0] gmt_cvl_i;
    reg [8:0] gmt_eta_abs [2:0];
    reg [8:0] bt_pt_tx [2:0];


	// pack data into delay lines' inputs, unpack the outputs of ring buffer
   always @(*)
	 begin
		pos = 0;
		mew = 0;
		lct_valid = 1'b0;

        for (station_ = 0; station_ < 3'd6; station_ = station_+1) // station loop
        begin
		  for (j = 0; j < 9; j = j+1) // chamber loop
		  begin
			 for (k = 0; k < seg_ch; k = k+1) // segment loop
			   begin
			      lct_valid = lct_valid | lct_i[station_][j][k].vf;
			      // pack delay line inputs
				  inp_del_in[pos+: lng] = 
				  {
				    lct_i[station_][j][k].ql, 
				    lct_i[station_][j][k].wg, 
				    lct_i[station_][j][k].hs, 
				    lct_i[station_][j][k].cp, 
				    lct_i[station_][j][k].lr, 
				    lct_i[station_][j][k].vf
				  };
				  for (i = 0; i < 8; i = i+1) // daq_bank word loop
				  begin
				    // unpack ring buffer outputs (from daq bank)
					{
					   q_d    [i][station_][j][k], 
					   wg_d   [i][station_][j][k], 
					   hstr_d [i][station_][j][k], 
					   cpat_d [i][station_][j][k], 
					   lr_d   [i][station_][j][k], 
					   vp_d   [i][station_][j][k]
					} = daq_bank[i][pos+: lng];
					csc_id = j; csc_id = csc_id + 4'h1; // chamber ID starts from 1
					tbin = i;
					
					// make one LCT in each station valid in case of stress test
					if (stress == 1'b1) vp_d[0][station_][0][0] = 1'b1;
					
					// pack ME LCT into daq word
					me_data[i][mew] = {1'h0, 8'h0, station_, vp_d[i][station_][j][k], tbin, 
									   1'b0, 3'b0, 12'h0, 
									   1'b1, 2'h0, lr_d[i][station_][j][k], csc_id, hstr_d[i][station_][j][k], 
									   1'b1, wg_d[i][station_][j][k], q_d[i][station_][j][k], cpat_d[i][station_][j][k]};
				  end
				  mew = mew + 1;
				  pos = pos + lng;
			   end
		  end
		end

        // add link statuses to delay line
        inp_del_in[pos+: 54] = {bc0_err_period_id1, bc0_err_period};
        // unpack link statuses
        // take statuses only at BX0
        {le_id1_d, le_d} = daq_bank[0][pos+: 54];
        pos = pos + 54;

		rpc_pos = 0;
		rpc_ring_pos = INP_DEL_BW + OUT_DEL_BW; // rpc data in daq_bank start after CSC inputs and track outputs
		rpcw = 0;
        // pack/unpack RPC data
        for (station_ = 0; station_ < 3'd7; station_ = station_+1) // rpc sub-sector loop
        begin
          for (j = 0; j < 3; j = j+1) // frame
          begin
             rpc_inp_del_in[rpc_pos +: 64] = cppf_rxd[station_][j];
             for (k = 0; k < 4; k = k+1) // hit in frame loop
             begin
			     for (i = 0; i < 8; i = i+1) // daq_bank word loop
                 begin
                    {rpc_th_d[i][station_][j][k], rpc_ph_d[i][station_][j][k]} = daq_bank[i][rpc_ring_pos +: 16];
                    // pack RPC data into daq word
                    rpc_frm = j; // frame 
                    rpc_frw = k; // word in frame
                    tbin = i; // timebin
                    rpc_val = rpc_th_d[i][station_][j][k] != 5'b11111;
                    rpc_data[i][rpcw] = {
                        1'b0, 11'b0, rpc_val, tbin,
                        1'b1, 1'b0, 2'b0, 12'h0,
                        1'b0, station_, rpc_frm, rpc_frw, 3'h0, rpc_th_d[i][station_][j][k], 
                        1'b0, 4'b0, rpc_ph_d[i][station_][j][k]
                    };
                 end
                 rpc_pos = rpc_pos + 16;
                 rpc_ring_pos = rpc_ring_pos + 16;
                 rpcw = rpcw + 1;
             end
          end
        end
        
        rpc_inp_del_in[rpc_pos +: 14] = {cppf_crc_match, cppf_rx_valid};
       
        
	    for (i = 0; i < 8; i = i+1) // daq_bank word loop
        begin
           {cppf_crc_match_d[i], cppf_rx_valid_d[i]} = daq_bank[i][rpc_ring_pos +: 14];
        end
        
        // pack/unpack output data
		out_pos = 0;
		out_ring_pos = INP_DEL_BW; // output bits in daq_bank words start after CSC input bits
		for (j = 0; j < 3; j = j+1) // best track loop
            begin
            
            // modifications for 2mu+LCT trigger, synchronous with output_formatter
            // qcode is bt_q in this code
            // bt_pt already contains bt_pt_tx from output_formatter
            // qcode == 0 -> no track, Pt = 0
            // qcode == 1 -> single LCT, Pt = 1
            gmt_qlt_i[j] = gmt_qlt[j];
            gmt_crg_i[j] = gmt_crg[j];
            bt_pt_tx[j] = bt_pt[j];
            
            // single LCT track logic according to Andrew's message from 2017-08-09
            if (bt_q[j] == 4'b1) // single LCT track
            begin
                // gmt_qlt_i initially carries CLCT pattern
                gmt_crg_i[j] = (gmt_qlt_i[j] == 4'd10) ? 1'b0 : 
                               (endcap == 1'b0) ? gmt_qlt_i[j][0] : ~gmt_qlt_i[j][0]; 
                gmt_qlt_i[j] = {2'b0, gmt_qlt[j][3:2]}; // quality is CLCT pattern/4
            end
		  // end of 2mu+LCT logic
		
			out_del_in[out_pos +: out_lng] = 
			{
				bxn_counter[2:0],
				ptlut_addr [j],
				bt_pt_tx [j],
				bt_phi [j], 
				gmt_phi [j],
				gmt_eta [j], 
				gmt_qlt_i [j], 
				gmt_crg_i [j],
				bt_q [j],
				bt_vi [j][4], bt_vi [j][3], bt_vi [j][2], bt_vi [j][1], bt_vi [j][0],
				bt_hi [j][4], bt_hi [j][3], bt_hi [j][2], bt_hi [j][1], bt_hi [j][0],
				bt_ci [j][4], bt_ci [j][3], bt_ci [j][2], bt_ci [j][1], bt_ci [j][0],
				bt_si [j]
			};
			for (i = 0; i < 8; i = i+1) // daq_bank word loop
			begin
				{
					bxn_counter_d [i][j],
					ptlut_addr_d [i][j],
					bt_pt_d [i][j],
					bt_phi_d [i][j], 
					gmt_phi_d [i][j],
					gmt_eta_d [i][j], 
					gmt_qlt_d [i][j], 
    				gmt_crg_d [i][j],
					bt_q_d [i][j],
					bt_vi_d [i][j][4], bt_vi_d [i][j][3], bt_vi_d [i][j][2], bt_vi_d [i][j][1], bt_vi_d [i][j][0],
					bt_hi_d [i][j][4], bt_hi_d [i][j][3], bt_hi_d [i][j][2], bt_hi_d [i][j][1], bt_hi_d [i][j][0],
					bt_ci_d [i][j][4], bt_ci_d [i][j][3], bt_ci_d [i][j][2], bt_ci_d [i][j][1], bt_ci_d [i][j][0],
					bt_si_d [i][j]
				} = daq_bank[i][out_ring_pos +: out_lng]; 
				
				// reformat IDs from ME1 into single field
				if (bt_vi_d[i][j][0]) // ME1a is valid
				begin
				    me1id = {1'b0, bt_ci_d[i][j][0], bt_si_d[i][j][0]};
				    me1tbin = {1'b0, bt_hi_d[i][j][0]};
				end
				else if (bt_vi_d[i][j][1]) // ME1b is valid
				begin
                    me1id = {1'b1, bt_ci_d[i][j][1], bt_si_d[i][j][1]};
				    me1tbin = {1'b0, bt_hi_d[i][j][1]};
                end
                else 
                begin
                    me1id = 6'h0;
                    me1tbin = 3'h0;
                end				
                
				if (bt_vi_d[i][j][2]) // ME2 is valid
				begin
				    me2id = {bt_ci_d[i][j][2], bt_si_d[i][j][2]};
				    me2tbin = {1'b0, bt_hi_d[i][j][2]};
				end
                else 
                begin
                    me2id = 5'h0;
                    me2tbin = 3'h0;
                end                
                
				if (bt_vi_d[i][j][3]) // ME3 is valid
                begin
                    me3id = {bt_ci_d[i][j][3], bt_si_d[i][j][3]};
                    me3tbin = {1'b0, bt_hi_d[i][j][3]};
                end
                else 
                begin
                    me3id = 5'h0;
                    me3tbin = 3'h0;
                end                
                
				if (bt_vi_d[i][j][4]) // ME4 is valid
                begin
                    me4id = {bt_ci_d[i][j][4], bt_si_d[i][j][4]};
                    me4tbin = {1'b0, bt_hi_d[i][j][4]};
                end
                else 
                begin
                    me4id = 5'h0;
                    me4tbin = 3'h0;
                end                
                
                
                bt_valid = bt_q_d[i][j] != 4'h0;
                if (i == 0 && j == 0 && stress == 1'b1) bt_valid = 1'b1; // make one track valid for stress test 
				
				track_data[i][j][0] = 
				{
				    1'b0, // d15
				    me1id,
				    bt_pt_d[i][j],
				
				    1'b1, // d15
				    bxn_counter_d [i][j][1:0], // mistake in specs, need to fix
				    bt_q_d[i][j],
				    gmt_eta_d[i][j],
				    
				    1'b0, // d15
				    bt_valid, 
				    1'b0, // se
				    ttc_bc0,
				    gmt_qlt_d[i][j],
				    gmt_phi_d[i][j], 
				    
				    1'b1, // d15
				    1'b0, // hl
				    gmt_crg_d[i][j], 
				    bt_phi_d[i][j]
				};
				
				track_data[i][j][1] = 
                {
                    1'b0, // d15
                    ptlut_addr_d[i][j][29:15],

                    1'b1, // d15
                    ptlut_addr_d[i][j][14:0],
                    
                    1'b1, // d15
                    i[2:0], // track time bin
                    me4tbin,
                    me3tbin,
                    me2tbin,
                    me1tbin,
                    
                    1'b0, // d15
                    me4id,
                    me3id,
                    me2id
                };
			end
						
			out_pos = out_pos + out_lng;
			out_ring_pos = out_ring_pos + out_lng;
		end

        for (j = 0; j < 49; j = j+1) // af delay loop
        begin
            k = j / 7; // 64-bit word number
            l = j % 7; // word 6-bit section number   
            af_del_w[k][l*8 +: 8] = af_delays[j]; // put delay into word section
        end
        
        // now add field IDs
        for (j = 0; j < 7; j = j+1) // word loop
        begin
            af_del_w[j][59:56] = j[3:0]; // add word number
            af_del_daq[j] = 
            {
                1'b0, af_del_w[j][59:45], 
                1'b1, af_del_w[j][44:30], 
                1'b1, af_del_w[j][29:15], 
                1'b1, af_del_w[j][14:0]
            };
        end

	 end

    wire [INP_DEL_BW-1:0] inp_del_dib = 0;
   // CSC input data delay line

   blk_mem #(.AW(8), .DW(INP_DEL_BW)) input_delay
   (
      .clka (clk),
      .clkb (clk),
      .ena (1'b1),
      .enb (1'b1),
      .wea (1'b1),
      .web (1'b0),
      .addra (id_addrw),
      .addrb (id_addrr),
      .dia (inp_del_in),
      .dib (inp_del_dib),
	  .doa (),
      .dob (inp_del_out)
   );

    wire [RPC_INP_DEL_BW-1:0] rpc_inp_del_dib = 0;
  // RPC input data delay line

  blk_mem #(.AW(8), .DW(RPC_INP_DEL_BW)) rpc_input_delay
  (
     .clka (clk),
     .clkb (clk),
     .ena (1'b1),
     .enb (1'b1),
     .wea (1'b1),
     .web (1'b0),
     .addra (rpc_id_addrw),
     .addrb (id_addrr),
     .dia (rpc_inp_del_in),
     .dib (rpc_inp_del_dib),
     .doa (),
     .dob (rpc_inp_del_out)
  );


    wire [OUT_DEL_BW-1:0] out_del_dib = 0;
	// output data delay line
	// all outputs are supposed to be provided timed to bt_pt, 
	// so inputs to PT LUT need to be delayed in the core by PT LUT latency
   blk_mem #(.AW(8), .DW(OUT_DEL_BW)) output_delay
   (
      .clka (clk),
      .clkb (clk),
      .ena (1'b1),
      .enb (1'b1),
      .wea (1'b1),
      .web (1'b0),
      .addra (od_addrw),
      .addrb (od_addrr),
      .dia (out_del_in),
      .dib (out_del_dib),
	  .doa (),
      .dob (out_del_out)
   );

	reg ring_we;
	reg [11:0] ring_addrw, ring_addrr;
	wire [RING_BW-1:0] ring_in = {rpc_inp_del_out, out_del_out, inp_del_out};
	wire [RING_BW-1:0] ring_out;
	wire [RING_BW-1:0] ring_dib = 0;

	// ring memory that stores data to report
	blk_mem #(.AW(12), .DW(RING_BW)) ring_buffer
	(
      .clka (clk),
      .clkb (clk_80),
      .ena (1'b1),
      .enb (1'b1),
      .wea (ring_we),
      .web (1'b0),
      .addra (ring_addrw),
      .addrb (ring_addrr),
      .dia (ring_in),
      .dib (ring_dib),
	  .doa (),
      .dob (ring_out)
	);
   
	wire [23:0] l1a_countf;
	reg ring_full = 1'b0;;
	wire ring_fullf;
	wire [11:0] ring_addrwf;
	reg l1a_proc, l1a_fifo_re;
	wire l1a_fifo_empty, l1a_fifo_full;
	reg l1a_r, l1a_rr;
	wire valor, valorf;
	reg [11:0] val_l1a_count;
	wire [11:0] bxn_counterf;
	reg [15:0] orbit_countf;
	wire l1a_fifo_valid;
   
    localparam l1a_fifo_dw = 16 + 12 + 1 + 24 + 1 + 12;
   
	wire [l1a_fifo_dw-1:0] l1a_fifo_din = {orbit_count,  bxn_counter,  valor,  l1a_count,  ring_full,  ring_addrw };
	wire [l1a_fifo_dw-1:0] l1a_fifo_dout;
	assign                                {orbit_countf, bxn_counterf, valorf, l1a_countf, ring_fullf, ring_addrwf} = l1a_fifo_dout;

    wire [15:0] l1a_fifo_data_count;
	reg tw, resync_req, resync_proc;
    
    l1a_fifo_gen l1a_fifo
    (
        .rst(resync_proc | reset),   // reset on resync request, in IDLE and OOS state only
        .wr_clk(clk),  // input wire wr_clk
        .rd_clk(clk_80),  // input wire rd_clk
        .din(l1a_fifo_din),        // input wire [65 : 0] din
        .wr_en(l1a_proc),    // input wire wr_en
        .rd_en(l1a_fifo_re),    // input wire rd_en
        .dout(l1a_fifo_dout),      // output wire [65 : 0] dout
        .full(l1a_fifo_full),      // output wire full
        .empty(l1a_fifo_empty),    // output wire empty
        .valid(l1a_fifo_valid),    // output wire valid
        .rd_data_count(l1a_fifo_data_count) 
    );

   // valid track exists if:
   // rank of best track is valid (at least one collision track is present) OR
   // single-LCT track is in index [2] 
	wire val = (bt_rank[0] != 0) | (bt_rank[2] != 0); 
   
	// this delay line provides a valid track bit in time with each L1A
	// valid bit is an OR of valid tracks over a time window
	valid_delay val_del
	(
		.val (val),
	    .val_lct (lct_valid),
        .core_latency (core_latency),
		.valor (valor),
		.delay (valor_delay),
		.window (valor_window),
		.stress (stress),
	    .report_wo_track (report_wo_track),
		.clk (clk)

	);   
   
	reg [3:0] l1a_window_cnt;
	wire l1a_rising = l1a_r && !l1a_rr;
	
	`localpar IDLE = 4'h0;
	`localpar L1A_FIFO_LAT = 4'h1;
	`localpar RD_L1A = 4'h2;
	`localpar TX_EMPTY = 4'h3;
	`localpar RD_DATA = 4'h4;
	`localpar RING_LAT = 4'h5;
	`localpar SEND_HEAD = 4'h6;
	`localpar SEND_ME = 4'h7;
	`localpar SEND_RPC = 4'h8;
	`localpar SEND_TRACKS = 4'h9;
	`localpar SEND_TRAIL = 4'ha;

	`localpar one_wc = RING_BW/64;

    // see this document for TTS details:
    // http://cmsdoc.cern.ch/cms/TRIDAS/horizontal/RUWG/DAQ_IF_guide/DAQ_IF_guide.html
    localparam TTS_RDY = 4'h8;
    localparam TTS_WOF = 4'h1;
    localparam TTS_BSY = 4'h4;
    localparam TTS_OOS = 4'h2;
    localparam TTS_ERR = 4'hc;
    localparam TTS_DIS = 4'hf;


	wire skip = 0; 
	wire rdy, bsy, osy, wof;
	assign rdy = (tts_data == TTS_RDY) ? 1'b1 : 1'b0;
	assign bsy = (tts_data == TTS_BSY) ? 1'b1 : 1'b0;
	assign osy = (tts_data == TTS_OOS) ? 1'b1 : 1'b0;
	assign wof = (tts_data == TTS_WOF) ? 1'b1 : 1'b0;

	reg ddm=1, spa=1, rpca=0;
	reg [19:0] data_lgth;
	
	reg [3:0] st = IDLE;
	wire [63:0] head_trail [2:0];
	// header/trailer for empty event
	assign head_trail[0] = {8'h0, l1a_countf, bxn_counterf, 20'h3}; // length is set to 3
	assign head_trail[1] = {28'h1234567, 2'h0, l1a_fifo_empty,l1a_fifo_full,orbit_countf, board_id};
	assign head_trail[2] = {32'h0, l1a_countf[7:0], 4'h0, 20'h3}; // length is set to 3
	
	wire [2:0] sp_ersv; // record structure version
	assign sp_ersv = 0;
	wire [63:0] daq_head [13:0]; // daq header including amc13, sp, block of counters, af_delays
	
	// header for valid event
	assign daq_head[0] = {8'h0, l1a_countf, bxn_counterf, 20'hfffff}; // amc13 header, length set to all 1s since we don't know it
	assign daq_head[1] = {32'h87654321, orbit_countf, board_id}; // amc13
	assign daq_head[2] = {4'h9, bxn_counterf, 4'h9, 12'h0, 4'h9, l1a_countf[23:12], 4'h9, l1a_countf[11:0]}; //sp
	assign daq_head[3] = {4'ha, me1a_en, 4'ha, 1'b0, l1a_window, ddm, spa, rpca, skip, rdy, bsy, osy, wof, 4'ha, sp_ts, sp_ersv, sp_addr, 4'ha, 12'h0}; //sp
	
	assign daq_head[4] = {
	   1'h0, 1'h0, cppf_crc_match_d[0][6:4], me4_en, 
	   1'h0, cppf_crc_match_d[0][3:0], me3_en, 
	   1'h0, 1'h0, cppf_en[6:4], me2_en, 
	   1'h1, cppf_en[3:0], 2'h0, me1b_en}; //sp
	
	assign daq_head[5] = {1'h0, 6'h0, le_id1_d, le_d[48:45], 1'h0, le_d[44:30], 1'h1, le_d[29:15], 1'h0, le_d[14:0]}; // link errors
	assign daq_head[6]  = af_del_daq[0];
	assign daq_head[7]  = af_del_daq[1];
	assign daq_head[8]  = af_del_daq[2];
	assign daq_head[9]  = af_del_daq[3];
	assign daq_head[10] = af_del_daq[4];
	assign daq_head[11] = af_del_daq[5];
	assign daq_head[12] = af_del_daq[6];
	
	// trailer for valid event
	wire [63:0] daq_trail [2:0];
	
	// decode fw date and time
    wire [5:0] second = fw_date [5:0];
    wire [5:0] minute = fw_date [11:6];
    wire [4:0] hour   = fw_date [16:12];
    wire [5:0] year   = fw_date [22:17];
    wire [3:0] month  = fw_date [26:23];
    wire [4:0] day    = fw_date [31:27];
	
	assign daq_trail[0] = {4'hf, 12'habc, 4'hf, 2'h0, year, month, 4'hf, l1a_fifo_data_count[7:4], l1a_fifo_full, 3'h7, 4'hf, 4'hf, l1a_fifo_data_count[3:0], l1a_countf[7:0]}; // sp
	assign daq_trail[1] = {4'he, 12'h0, 4'he, 12'h0, 4'he, second, minute, 4'he, 2'h0, hour, day}; // sp
	assign daq_trail[2] = {32'h0, l1a_countf[7:0], 4'h0, data_lgth}; // amc13 trailer, last field is the real data lenth
	
	reg [3:0] wc;
    reg ttc_bc0_r, ttc_bc0_rr;
   
	localparam LHC_ORBIT_LAST_CLK = 12'd3563;
	
	wire [3:0] l1a_window_ext;
	assign l1a_window_ext = {1'b0, l1a_window} + 4'h1;
	reg [3:0] daq_bank_cnt_ext;
	reg [6:0] mewc;
	reg [3:0] tbc;
	reg amc13_go_easy;
   
    assign resync_and_empty = resync_proc; // tell AMC13 that we're done sending last event

   
	always @(posedge clk)
	begin
		
        if (!ttc_bc0_rr && ttc_bc0_r) 
        begin
            bxn_counter = bxn_offset;
        end
        else
        begin
            if (bxn_counter == LHC_ORBIT_LAST_CLK)
            begin 
                bxn_counter = 12'h0;
                orbit_count = orbit_count + 16'h1; // increment orbit count when bx wraps, not at BC0
            end
            else bxn_counter = bxn_counter + 12'h1;
        end
		
		
		if (ttc_or_cnt_reset) orbit_count = 16'h0;            

	
		if (reset)
		begin
			ring_addrw = 0;
			ring_we = 0;
			val_l1a_count = 0;
			id_addrr = 0;
		end
		else
		begin

		   if (resync_req)
		   begin 
		       ring_addrw = 0;
    	       id_addrr = 0;
		   end
			 
			ring_we = 0;

			if (l1a_window_cnt > 4'h1)
			begin
				ring_we = 1'b1;
			end

			if (l1a_window_cnt > 4'h0)
			begin
				// if the counter did not expire, continue recording into ring buffer
				l1a_window_cnt = l1a_window_cnt - 4'h1;
				ring_addrw = ring_addrw + 1;
			end

		
			if (l1a_proc && valor)
			begin
				// start recording into ring buffer at l1a only if there is valid track

				l1a_window_cnt = l1a_window_ext;
				ring_we = 1'b1;
			end
		end		

		// delay lines address increment
		id_addrr = id_addrr + 1;

		// detect rising edge on l1a
		l1a_proc = 1'b0;
		if (l1a_rising) 
		begin
			l1a_proc = 1'b1; // store this l1a 
			if (valor) val_l1a_count = val_l1a_count + 12'h1; // count valid l1as only
			l1a_count = l1a_count + 24'h1; // this counter counts all l1as
		end

        if (ttc_ev_cnt_reset)
        begin
            l1a_count = 24'h0; // first event marked with id=1
        end

        ttc_bc0_rr = ttc_bc0_r;
        ttc_bc0_r = ttc_bc0;

		l1a_rr = l1a_r;
        l1a_r = l1a_in;
	end
	
	always @(posedge clk_80)
	begin
	   if (reset)
	   begin
			resync_proc = 1'b0;
			ring_addrr = 0;
			amc13_go_easy = 1'b0;
			st = IDLE;
	   end
	   else
	   begin

		// DAQ state machine
		l1a_fifo_re = 1'b0;
		daq_valid = 1'b0;
		daq_data = 64'h0;
		daq_first = 1'b0;
		daq_last = 1'b0;
        resync_proc = 1'b0;
		case (st)
			IDLE: 
			begin
                if (resync_req)
                begin
                    // process resync request only in IDLE state
                    // we're in OOS, so reset all buffers
 //                   ring_addrw = 0;
                    ring_addrr = 0;
                    val_l1a_count = 0;
//                    id_addrr = 0;
                    resync_proc = 1'b1; // now reset l1a fifo and TTS
                    amc13_go_easy = 1'b0;
                end			
                else
                begin
                    if (!l1a_fifo_empty) // l1a is in FIFO
                    begin
                    
                        if (amc13_ready)
                        begin
                           l1a_fifo_re = 1'b1; // read 1 L1A
                           st = L1A_FIFO_LAT;
                           // start readout only if amc13 is ready
                        end
                        else
                        begin
                            amc13_go_easy = amc13_easy_en;
                        end
                    end
                    else
                    begin
                        if (amc13_ready)
                            amc13_go_easy = 1'b0;
                    end
				end
			end
			
			L1A_FIFO_LAT:
			begin
				// l1a fifo latency
				st = RD_L1A;
			end
			
			RD_L1A:
			begin
				if (valorf) // this l1a is for valid track
				begin
					val_l1a_count = val_l1a_count - 12'h1; // update count of valid l1as in data fifos
					daq_bank_cnt = 3'h0; // read bank counter reset
					daq_bank_cnt_ext = 4'b0;
					ring_addrr = ring_addrwf; // start address for data from this L1A
					if (amc13_go_easy)
					begin
					    // AMC13 may topple soon, send empty event
                        wc = 4'h0;
                        st = TX_EMPTY;
					end
					else
					begin
					    st = RING_LAT;
					end
				end
				else
				begin
					// no valid data, send empty header/trailer
					wc = 4'h0;
					st = TX_EMPTY;
				end
			end
			
			TX_EMPTY: // send empty header/trailer
			begin
				if (amc13_ready) // amc13 ready
				begin
					daq_valid = 1'b1;
					daq_data = head_trail[wc];
					daq_first = (wc == 4'h0) ? 1'b1 : 1'b0;
					daq_last = (wc == 4'h2) ? 1'b1 : 1'b0;
					
					if (wc == 4'h2) st = IDLE;
					wc = wc + 4'h1;
				end
				else
                begin
                    amc13_go_easy = amc13_easy_en;
                end
			end
			
			RING_LAT: // ring memory latency
			begin
				ring_addrr = ring_addrr + 1;
				st = RD_DATA;
			end
			
			RD_DATA: // read data for this L1A into register bank, so we can analyze them before forming DAQ stream
			begin
				daq_bank[daq_bank_cnt] = ring_out;
				daq_bank_cnt = daq_bank_cnt + 3'h1;
				daq_bank_cnt_ext = daq_bank_cnt_ext + 4'h1;
				ring_addrr = ring_addrr + 1;
                data_lgth = 20'h1; // reset length, start with 1 because last word transmits value-1
				if (daq_bank_cnt_ext == l1a_window_ext) // end of window reached
				begin
				    wc = 4'h0;
					st = SEND_HEAD;
				end
			end
			
			SEND_HEAD: // amc13 and sp header + block of counters
			begin
				if (amc13_ready)
				begin
					daq_valid = 1'b1;
					daq_data = daq_head[wc];
					daq_first = (wc == 4'h0) ? 1'b1 : 1'b0;
					data_lgth = data_lgth + 20'h1; // update length counter
					
					if (wc == 4'd5) // exclude AF delays for now 
					begin
						mewc = 7'h0;
						tbc = 4'h0;
						st = SEND_ME;
					end
					wc = wc + 4'h1;
				end				
				else
				begin
				    amc13_go_easy = amc13_easy_en;
				end
			end
			
			SEND_ME:
			begin
				// proceed with output of each LCT if:
				// amc13_ready and LCT is valid, or
				// LCT is invalid. In this case, we don't care about AMC13 since daq_valid = 0
				if (amc13_ready || !me_data[tbc][mewc][51])
				begin
					daq_valid = me_data[tbc][mewc][51]; // valid bit, AMC13 will take the word only if set
					daq_data  = me_data[tbc][mewc]; // stub data to output even if invalid
					mewc = mewc + 7'h1; // me word counter
					if (daq_valid) data_lgth = data_lgth + 20'h1; // update length
					if (mewc == me_data_wc) 
					begin
						tbc = tbc + 4'h1; // time bin counter
						mewc = 7'h0;
						if (tbc == l1a_window_ext)
						begin
                            wc = 4'h0;
                            tbc = 4'h0;
                            tw = 1'b0;
							st = SEND_RPC;
						end
					end
				end
				
				if (!amc13_ready)
                begin
                    amc13_go_easy = amc13_easy_en;
                end
			end
			
			SEND_RPC:
            begin
                // proceed with output of each RPC if:
                // amc13_ready and RPC hit is valid, or
                // RPC hit is invalid. In this case, we don't care about AMC13 since daq_valid = 0
                if (amc13_ready || !rpc_data[tbc][mewc][51])
                begin
                    daq_valid = rpc_data[tbc][mewc][51]; // valid bit, AMC13 will take the word only if set
                    daq_data  = rpc_data[tbc][mewc]; // stub data to output even if invalid
                    mewc = mewc + 7'h1; // rpc word counter
                    if (daq_valid) data_lgth = data_lgth + 20'h1; // update length
                    if (mewc == rpc_data_wc) 
                    begin
                        tbc = tbc + 4'h1; // time bin counter
                        mewc = 7'h0;
                        if (tbc == l1a_window_ext)
                        begin
                            wc = 4'h0;
                            tbc = 4'h0;
                            tw = 1'b0;
                            st = SEND_TRACKS;
                        end
                    end
                end
                
                if (!amc13_ready)
                begin
                    amc13_go_easy = amc13_easy_en;
                end
            end
            
			SEND_TRACKS:
			begin
				// proceed with output of each track if:
                // amc13_ready and track is valid, or
                // track is invalid. In this case, we don't care about AMC13 since daq_valid = 0
                if (amc13_ready || !track_data[tbc][wc][0][30])
                begin
					daq_valid = track_data[tbc][wc][0][30]; // valid bit, AMC13 will take the word only if set
                    daq_data  = track_data[tbc][wc][tw]; // track data to output even if invalid
                    if (tw == 1'b1) wc = wc + 4'h1; // word counter
                    tw = ~tw; // word index
                    if (daq_valid) data_lgth = data_lgth + 20'h1; // update length
                    if (wc == 4'h3) 
                    begin
                        tbc = tbc + 4'h1; // time bin counter
                        wc = 4'h0;
                        if (tbc == l1a_window_ext)
                        begin
                            tbc = 4'h0;
                            wc = 4'h0;
                            st = SEND_TRAIL;
                        end
                    end
                end

				if (!amc13_ready)
                begin
                    amc13_go_easy = amc13_easy_en;
                end
			end
			
			SEND_TRAIL:
			begin
			     // send AMC13 trailer
				if (amc13_ready)
                begin
                    daq_valid = 1'b1;
                    daq_data = daq_trail[wc];
                    daq_last = 1'b0;
                    data_lgth = data_lgth + 20'h1; // update length counter
                    
                    if (wc == 4'h2) 
                    begin
                        daq_last = 1'b1;
                        st = IDLE;
                    end
                    wc = wc + 4'h1;
                end                
				else
                begin
                    amc13_go_easy = amc13_easy_en;
                end
			end
		endcase // case (st)
	   end // else: !if(reset)
	   
	end
    
       
    // thresholds, somewhat arbitrary
    localparam L1A_TO_WOF  = 16'd32000; 
    localparam L1A_OUT_WOF = 16'd30000; 
    localparam L1A_TO_BSY  = 16'd42000;
    localparam L1A_OUT_BSY = 16'd40000;
    localparam L1A_TO_OOS  = 16'd50000;
    
    localparam RING_TO_WOF  = 12'd3000; 
    localparam RING_OUT_WOF = 12'd2900; 
    localparam RING_TO_BSY  = 12'd4000;
    localparam RING_OUT_BSY = 12'd3900;
    localparam RING_TO_OOS  = 12'd4090;

    wire [11:0] ring_data_count = ring_addrw - ring_addrr + 12'd8; // count of words in ring buffer
    // adding 8 to prevent read addr getting ahead of write address due to latency compensation
    
    reg [3:0] tts_data_r;
    reg [10:0] tts_wof_cnt, tts_bsy_cnt, tts_oos_cnt, tts_rdy_cnt, tts_ill_cnt;
    
    assign daq_state_cnt = {amc13_go_easy, amc13_ready, tts_data, tts_ill_cnt, tts_rdy_cnt, tts_wof_cnt, tts_bsy_cnt, tts_oos_cnt};
    
    // tts state machine, use tts_data output as state
    always @(posedge clk_80)
    begin
    
        if (reset) // complete TTS reset on system reset
        begin
            tts_wof_cnt = 16'h0;
            tts_bsy_cnt = 16'h0;
            tts_oos_cnt = 16'h0;
            tts_rdy_cnt = 16'h0;
            tts_ill_cnt = 16'h0;
            tts_data = TTS_RDY;
            tts_data_r = TTS_RDY;
        end
        else
        if (force_oos)
        begin
            tts_data = TTS_OOS; // request Resync on sw command
       	    if (ttc_resync) // only react to resync in OOS state
            begin
               resync_req = 1'b1; // resync received, set request
            end
            
        end
        else
        begin
            case (tts_data)
                TTS_RDY:
                begin
                    // increment state counter on entry only
                    if (tts_data_r != tts_data) tts_rdy_cnt = tts_rdy_cnt + 16'h1;
                    tts_data_r = tts_data;
                    if (l1a_fifo_data_count > L1A_TO_WOF || ring_data_count > RING_TO_WOF) tts_data = TTS_WOF;
                    resync_req = 1'b0;
                end
                TTS_WOF:
                begin
                    // increment state counter on entry only
                    if (tts_data_r != tts_data) tts_wof_cnt = tts_wof_cnt + 16'h1; 
                    tts_data_r = tts_data;
                    
                    if (l1a_fifo_data_count > L1A_TO_BSY || ring_data_count > RING_TO_BSY) tts_data = TTS_BSY;
                    else
                    if (l1a_fifo_data_count <= L1A_OUT_WOF && ring_data_count <= RING_OUT_WOF) tts_data = TTS_RDY;
                    resync_req = 1'b0;
                end
                TTS_BSY:
                begin
                    // increment state counter on entry only
                    if (tts_data_r != tts_data) tts_bsy_cnt = tts_bsy_cnt + 16'h1; 
                    tts_data_r = tts_data;

                    if (l1a_fifo_data_count <= L1A_OUT_BSY && ring_data_count <= RING_OUT_BSY) tts_data = TTS_WOF;
                    else
                    if (l1a_fifo_data_count > L1A_TO_OOS || ring_data_count > RING_TO_OOS) tts_data = TTS_OOS;
                    resync_req = 1'b0;
                end
                TTS_OOS:
                begin
                    // increment state counter on entry only
                    if (tts_data_r != tts_data) tts_oos_cnt = tts_oos_cnt + 16'h1;
                    tts_data_r = tts_data;

            	    if (ttc_resync) // only react to resync in OOS state
                    begin
                       resync_req = 1'b1; // resync received, set request
                    end

                    // get out of OOS only when buffers are reset
                    if (l1a_fifo_data_count <= L1A_OUT_WOF && ring_data_count <= RING_OUT_WOF) tts_data = TTS_RDY;
                    
                end
                default:
                begin
                    // increment state counter on entry only
                    if (tts_data_r != tts_data) tts_ill_cnt = tts_ill_cnt + 16'h1;
                    tts_data_r = tts_data;
                    tts_data = TTS_RDY;
                end
            endcase
        end
    end
    
    (* mark_debug = "FALSE" *) wire [63:0] daq_data_w = daq_data;
    (* mark_debug = "FALSE" *) wire daq_valid_w = daq_valid;
    (* mark_debug = "FALSE" *) wire daq_first_w = daq_first;
    (* mark_debug = "FALSE" *) wire daq_last_w = daq_last;
    (* mark_debug = "FALSE" *) wire amc13_ready_w = amc13_ready;
//    (* mark_debug = "FALSE" *) wire [8:0] vp_d0_w;
//    (* mark_debug = "FALSE" *) wire [8:0] vp_d1_w;
//    (* mark_debug = "FALSE" *) wire [8:0] vp_d2_w;
//    (* mark_debug = "FALSE" *) wire [8:0] vp_d3_w;
//    (* mark_debug = "FALSE" *) wire [8:0] vp_d4_w;
    (* mark_debug = "FALSE" *) wire [3:0] bt_q_d_w [2:0];
    (* mark_debug = "FALSE" *) wire [3:0] bt_q_w [2:0];
    (* mark_debug = "FALSE" *) wire l1a_proc_w = l1a_proc;
    (* mark_debug = "FALSE" *) wire valor_w = valor;
    (* mark_debug = "FALSE" *) wire l1a_fifo_full_w = l1a_fifo_full;
	(* mark_debug = "FALSE" *) wire l1a_fifo_valid_w = l1a_fifo_valid;
	(* mark_debug = "FALSE" *) wire [11:0] bxn_counter_w = bxn_counter;
	(* mark_debug = "FALSE" *) wire [11:0] bxn_counterf_w = bxn_counterf;
    (* mark_debug = "FALSE" *) wire [11:0] ring_data_count_w = ring_data_count;
    (* mark_debug = "FALSE" *) wire [15:0] l1a_fifo_data_count_w = l1a_fifo_data_count;
    (* mark_debug = "FALSE" *) wire [3:0] tts_data_w = tts_data;
	(* mark_debug = "FALSE" *) wire [11:0] ring_addrw_w = ring_addrw;
	(* mark_debug = "FALSE" *) wire [11:0] ring_addrr_w = ring_addrr;
	(* mark_debug = "FALSE" *) wire resync_req_w = resync_req;
	(* mark_debug = "FALSE" *) wire ttc_resync_w = ttc_resync;
	(* mark_debug = "FALSE" *) wire resync_proc_w = resync_proc;
	(* mark_debug = "FALSE" *) wire [3:0] st_w = st;
	

    genvar vi;
    generate
//        for (vi = 0; vi < 9; vi = vi+1)
//        begin: vp_debug
//            assign vp_d0_w[vi] = vp_d0[0][vi][1];
//            assign vp_d1_w[vi] = vp_d1[0][vi][1];
//            assign vp_d2_w[vi] = vp_d2[0][vi][1];
//            assign vp_d3_w[vi] = vp_d3[0][vi][1];
//            assign vp_d4_w[vi] = vp_d4[0][vi][1];
//        end
        for (vi = 0; vi < 3; vi = vi+1)
        begin: bt_debug
            assign bt_q_d_w[vi] = bt_q_d[0][vi];
        end
    endgenerate
    assign bt_q_w[0] = out_del_out[48:45];
    assign bt_q_w[1] = out_del_out[48+out_lng:45+out_lng];
    assign bt_q_w[2] = out_del_out[48+out_lng*2:45+out_lng*2];
   
    mmcm_daq mmcm_daq_
    (
        .clk_in1(clk),
        .clk_out1(clk_80),
        .reset(1'b0),
        .locked()
    );

   
endmodule
