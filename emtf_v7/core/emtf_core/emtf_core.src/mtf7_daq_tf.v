`include "vppc_macros.v"
module mtf7_daq_tf;

`include "spbits.v"

    reg [3:0]        q0    [11:0][seg_ch-1:0];
    reg [bw_wg-1:0]  wg0   [11:0][seg_ch-1:0];
    reg [bw_hs-1:0]  hstr0 [11:0][seg_ch-1:0];
    reg [3:0] 	   cpat0 [11:0][seg_ch-1:0];

    reg [3:0]        q1    [8:0][seg_ch-1:0];
    reg [bw_wg-1:0]  wg1   [8:0][seg_ch-1:0];
    reg [bw_hs-1:0]  hstr1 [8:0][seg_ch-1:0];
    reg [3:0] 	   cpat1 [8:0][seg_ch-1:0];

    reg [3:0]        q2    [10:0][seg_ch-1:0];
    reg [bw_wg-1:0]  wg2   [10:0][seg_ch-1:0];
    reg [bw_hs-1:0]  hstr2 [10:0][seg_ch-1:0];
    reg [3:0] 	   cpat2 [10:0][seg_ch-1:0];

    reg [3:0]        q3    [10:0][seg_ch-1:0];
    reg [bw_wg-1:0]  wg3   [10:0][seg_ch-1:0];
    reg [bw_hs-1:0]  hstr3 [10:0][seg_ch-1:0];
    reg [3:0] 	   cpat3 [10:0][seg_ch-1:0];

    reg [3:0]        q4    [10:0][seg_ch-1:0];
    reg [bw_wg-1:0]  wg4   [10:0][seg_ch-1:0];
    reg [bw_hs-1:0]  hstr4 [10:0][seg_ch-1:0];
    reg [3:0] 	   cpat4 [10:0][seg_ch-1:0];

   
	// precise phi and theta of best tracks
	// [best_track_num]
	reg [8:0] bt_pt [2:0];
	reg [bw_fph-1:0] bt_phi [2:0];
	reg [bw_th-1:0] 	bt_theta [2:0];
	reg [3:0] 		bt_cpattern [2:0];
	// ph and th deltas from best stations
	// [best_track_num], last index: [0] - best pair of stations, [1] - second best pair
	reg [bw_fph-1:0] bt_delta_ph [2:0][1:0];
	reg [bw_th-1:0] 	bt_delta_th [2:0][1:0]; 
	reg [1:0] 		bt_sign_ph[2:0];
	reg [1:0] 		bt_sign_th[2:0];
	// ranks [best_track_num]
	reg [bwr:0] 		bt_rank [2:0];
	// segment IDs
	// [best_track_num][station 0-3]
	reg [seg_ch-1:0] bt_vi [2:0][4:0]; // valid
	reg [1:0] 		bt_hi [2:0][4:0]; // bx index
	reg [3:0] 		bt_ci [2:0][4:0]; // chamber
	reg [4:0] 		bt_si [2:0]; // segment

    // clock
    reg 				clk;
	reg 				control_clk;

    reg [7:0] l1a_delay;
	reg [2:0] l1a_window; // how many BXs to report on each L1A
	reg [7:0] valor_delay;
	reg [2:0] valor_window;
	reg l1a_in;
	reg [11:0] bxn_counter;
	reg daq_reset;
	reg [15:0] board_id;
	reg ttc_resync;
	reg ttc_bc0;

	wire [63:0] daq_data;
	wire daq_first;
	wire daq_last;
	reg amc13_ready;
	
	reg [4:0] sp_addr; // uTCA slot number
	reg [3:0] sp_ts; // Trigger sector ME+ = 1..6, ME- = 7..12

	reg [11:0] me1a_en;
	reg [8:0]  me1b_en;
	reg [10:0] me2_en;
	reg [10:0] me3_en;
	reg [10:0] me4_en;	

   mtf7_daq uut
   (
      // chamber data
      .q0 (q0), 
	  .wg0 (wg0), 
	  .hstr0 (hstr0), 
	  .cpat0 (cpat0),
	  
      .q1 (q1), 
	  .wg1 (wg1), 
	  .hstr1 (hstr1), 
	  .cpat1 (cpat1),
	  
      .q2 (q2), 
	  .wg2 (wg2), 
	  .hstr2 (hstr2), 
	  .cpat2 (cpat2),
	  
      .q3 (q3), 
	  .wg3 (wg3), 
	  .hstr3 (hstr3), 
	  .cpat3 (cpat3),
	  
      .q4 (q4), 
	  .wg4 (wg4), 
	  .hstr4 (hstr4), 
	  .cpat4 (cpat4),
	  
      // tracks
	  .bt_pt (bt_pt),
      .bt_phi (bt_phi),
      .bt_theta (bt_theta),
      .bt_cpattern (bt_cpattern),
      .bt_delta_ph (bt_delta_ph),
      .bt_delta_th (bt_delta_th),
      .bt_sign_ph (bt_sign_ph),
      .bt_sign_th (bt_sign_th),
      .bt_rank (bt_rank),
	  .bt_vi (bt_vi), 
      .bt_hi (bt_hi), 
      .bt_ci (bt_ci), 
      .bt_si (bt_si),
	  
      .clk (clk),
      .control_clk (control_clk),
	  
      .l1a_delay (l1a_delay),

	  .l1a_window (l1a_window),
	  .valor_delay (valor_delay),
	  .valor_window (valor_window),
	 
	  .l1a_in (l1a_in),
	  .bxn_counter (bxn_counter), 
	  .board_id (board_id),
	  .daq_reset (daq_reset),
	  
	  .ttc_resync (ttc_resync),
	  .ttc_bc0 (ttc_bc0),

	  .daq_data (daq_data), 
	  .daq_first (daq_first),
	  .daq_last (daq_last),
	  .amc13_ready (amc13_ready),

	  .sp_addr (sp_addr),
	  .sp_ts (sp_ts),
		 
	  .me1a_en (me1a_en),
	  .me1b_en (me1b_en),
	  .me2_en (me2_en),
	  .me3_en (me3_en),
	  .me4_en (me4_en)	  
   );


   integer n, c;
   integer i,j,k;
   integer all_wc_int;
   
   initial
	 begin
		l1a_delay = 1;//10;
		 l1a_window = 7;
		 valor_delay = 3;
		 valor_window = 2; // means 3
		 
		 l1a_in = 0;
		 daq_reset = 0;
		 amc13_ready = 1;

		 sp_addr = 5; // slot
		 sp_ts = 12; // trigger sector
		 
		 me1a_en = 12'hfff;
		 me1b_en = 9'h1ff;
		 me2_en  = 11'h7ff;
		 me3_en  = 11'h7ff;
		 me4_en  = 11'h7ff;

		for (n = 0; n < 100; n = n+1)
		  begin
			bxn_counter = bxn_counter + 1;
			
			if (n < 2) daq_reset = 1;
			else daq_reset = 0;
			
			if (n == 8 || n == 28) bt_rank[0] = 1;
			else bt_rank[0] = 0;
	
			l1a_in = 0;
			if (n == 18) l1a_in = 1; // valid track
			if (n == 25 || n == 27) l1a_in = 1; // no track
			if (n == 38) l1a_in = 1; // valid track

			for (j = 0; j < 3; j = j+1) // best track
			begin
				bt_phi[j] = n;
				bt_theta[j] = j;
			end


			 for (j = 0; j < 12; j = j+1) // chamber
			   begin
				  for (k = 0; k < seg_ch; k = k+1) // segment
					begin
					   q0[j][k] = 0;
					   wg0[j][k] = j;
					   hstr0[j][k] = n;
					   cpat0[j][k] = k;
					end
			   end
			 
			 for (j = 0; j < 9; j = j+1) // chamber
			   begin
				  for (k = 0; k < seg_ch; k = k+1) // segment
					begin
					   q1[j][k] = 1;
					   wg1[j][k] = j;
					   hstr1[j][k] = n+1;
					   cpat1[j][k] = k;
					end
			   end
			 
			 for (j = 0; j < 11; j = j+1) // chamber
			   begin
				  for (k = 0; k < seg_ch; k = k+1) // segment
					begin
					   q2[j][k] = 2;
					   wg2[j][k] = j;
					   hstr2[j][k] = n;
					   cpat2[j][k] = k;
					end
			   end
			 
			 for (j = 0; j < 11; j = j+1) // chamber
			   begin
				  for (k = 0; k < seg_ch; k = k+1) // segment
					begin
					   q3[j][k] = 3;
					   wg3[j][k] = j;
					   hstr3[j][k] = n;
					   cpat3[j][k] = k;
					end
			   end
			 
			 for (j = 0; j < 11; j = j+1) // chamber
			   begin
				  for (k = 0; k < seg_ch; k = k+1) // segment
					begin
					   q4[j][k] = 4;
					   wg4[j][k] = j;
					   hstr4[j][k] = n;
					   cpat4[j][k] = k;
					end
			   end
			 
		   for (c = 0; c < 2; c = c+1)
			 begin
				`clk_drive(clk, c);
				`__top_module__
			 end
			 
			 $write ("%h %b %b\n", daq_data, daq_first, daq_last);
			 
//			 if (uut.st == uut.SIZE_CALC)
//			 begin
//				for (j = 0; j < 8; j = j+1)
//					$write ("%h\n", uut.daq_bank[j]);
//			 end
//
//			if (uut.ring_we)
//				$write ("%h %h w\n",uut.ring_in, uut.ring_addrw);
//
//			if (uut.st == uut.RING_LAT || uut.st == uut.RD_DATA)
//				$write ("%h %h r\n",uut.ring_out, uut.ring_addrr);
//
//			if (n == 10)
//			begin
//				all_wc_int = uut.RING_BW;
//				$write ("RING_BW = %d\n", all_wc_int);
//			end
			 
//			 $write ("l1a: %b l1a_r: %b l1a_proc: %b l1a_fifo_re:%b ring_addw: %h l1a_fifo_empty: %b val: %b valor: %b valorf: %b vald: %b val_line: %b daq: %h daq_1st:%b daq_last: %b\n",
//						l1a_in, uut.l1a_r, uut.l1a_proc, uut.l1a_fifo_re, uut.ring_addrw, uut.l1a_fifo_empty, uut.val_del.val, uut.valor, uut.valorf, 
//						uut.val_del.vald, uut.val_del.val_line, daq_data, daq_first, daq_last);
			 

/*			
			 for (j = 0; j < 9; j = j+1) // chamber
			   begin
				  for (k = 0; k < seg_ch; k = k+1) // segment
					begin
					   $write("n: %d s: %d c: %d sg: %d q: %h wg: %h hs: %h pt: %h  q: %h wg: %h hs: %h pt: %h\n",
							  n, i, j, k,
							  uut.q_d1[j][k],
							  uut.wg_d1[j][k],
							  uut.hstr_d1[j][k],
							  uut.cpat_d1[j][k],
							  q1[j][k],
							  wg1[j][k],
							  hstr1[j][k],
							  cpat1[j][k]
							  );
					end
			   end
			 for (j = 0; j < 3; j = j+1) // best track 
			 begin
				$write ("n: %d bt: %d phi: %h th: %h\n", n, j, uut.bt_phi_d[j], uut.bt_theta_d[j]);
			 end
*/			 
			 
		 end

		
	 end
   
endmodule

