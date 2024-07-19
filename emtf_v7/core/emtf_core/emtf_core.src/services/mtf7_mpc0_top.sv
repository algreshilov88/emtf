`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:42:59 06/19/2014 
// Design Name: 
// Module Name:    mtf7_mpc0_top 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
`include "../core/vppc_macros.sv"
module mtf7_mpc #
(parameter MPC_ID = 0)
(

	input [7:0] sync_ref_clk,
	input async_ref_clk,
	input clk_40,
	input clk_160,
	input [7:0] rxn,
	input [7:0] rxp,
	output [7:0] txn,
	output [7:0] txp,
	output reg clk_led,
	input soft_reset,
	input hard_reset,
	input rxbufreset,
	input [7:0] tx_inv_mask,
	input [7:0] rx_inv_mask,
	
	output reg [8*16-1:0] rxdata_o,
    output reg [8*2-1:0]  rxdisperr_o,
    output reg [8*2-1:0]  rxnotintable_o,
	
	output reg [8*10-1:0] link_id_o,

	// deframed output data
	(* async_reg = "TRUE" *) csc_lct lct_o [8:0][1:0],
	output [8:0] bc0_o,
	output [8:0] bx0_o,
	output [8:0] syer_o,
	
	// deframed bc0 before AF for alignment
	// one from each fiber, chamber 1 is not here
	output reg [7:0] bc0_u_af,


	input [7:0] fiber_enable,
	input [7:0] af_delays [7:0],
	input resync,
	// bc0 error flags
	output [7:0] bc0_err_period_o,
	output bc0_err_period_id1,

	output reg [7:0] bc0_err_stuck,
	output reg bc0_err_chamber0,
	output [7:0] rxbyteisaligned,
	output rxoutclk_o,
	
	input [2:0] prbs_sel,
	output reg [7:0] prbs_err_persist,
	
	input [63:0] txdata [2:0],
	input ttc_bc0,
	output txoutclk_async,
	input [11:0] bxn_tx_offset,

    output reg [25:0] stub_rate [8:0],
    
    output rx_valid_tp,
    output txcharisk_0,
    
	input [8:0] mpc_link_use_bc0_ch1,
    input [8:0] mpc_link_use_bc0_misplaced,
    input [7:0] gth_rx_reset,
	output [1:0] tx_rx_reset_done [7:0],
	output [7:0] cpll_lock,
    output [7:0] gth_tx_reset_done,
    input  [7:0] power_down
);

	localparam LHC_LAST_CLK = 14'h37af; //(3564 * 4 - 1);
	integer i, j;

	wire [7:0] prbs_err;
	
	wire [7:0] fcr;
	wire [7:0] txoutclk;
	wire [1:0] txusrclk;
	wire [7:0] txmmcm_reset;
	wire txoutclk_mmcm0_locked;
	wire [15:0] rxdata [7:0];
    wire [1:0]  rxdisperr [7:0];
    wire [1:0]  rxnotintable [7:0];
	reg [15:0] rxdata_r [7:0];
    reg [1:0]  rxdisperr_r [7:0];
    reg [1:0]  rxnotintable_r [7:0];
	(* mark_debug = "FALSE" *) wire [15:0] rxdata_w [7:0];
	wire [1:0] rxcharisk [7:0];
	reg [1:0] rxcharisk_fr [7:0];
	(* mark_debug = "FALSE" *) wire [1:0] rxcharisk_fw [7:0];
    wire [7:0] rxbyterealign;
    wire [7:0] rxcommadet;
	

	wire [7:0] rx_reset;

	reg [9:0] link_id [7:0];
	`merge_mem_1_n(link_id_o, link_id, 10, 8);

	reg [7:0] af_rd_en, af_wr_en;
	reg [15:0] rxdata_af [7:0];
	(* mark_debug = "FALSE" *) wire [15:0] rxdata_af_w [7:0];
	wire [15:0] rxdata_af_t [7:0];
	`merge_mem_1_n(rxdata_o, rxdata_r, 16, 8);
	`merge_mem_1_n(rxdisperr_o, rxdisperr_r, 2, 8);
	`merge_mem_1_n(rxnotintable_o, rxnotintable_r, 2, 8);
	reg  [7:0] rxcharisk_af;
	wire [7:0] rxcharisk_af_t;
	wire [5:0] af_data_count [7:0];
	wire [7:0] af_reset;
	wire [7:0] rxoutclk;
	reg [25:0] rate_period;
	reg [25:0] rate_counter [8:0];
	reg [7:0] idle_received;
	(* mark_debug = "FALSE" *) wire [7:0] idle_received_w = idle_received;
	(* mark_debug = "FALSE" *)  wire [5:0] af_delays_w [7:0];
	reg [7:0] bc0_err_period1;
	reg [7:0] bc0_err_period;
	assign bc0_err_period_id1 = |bc0_err_period1; // for CSCID=1 BC0s on all links must be valid
	
	assign rxoutclk_o = rxoutclk[0];

	genvar gi, gj;
	generate
	begin : serial

        for (gi = 0; gi < 8; gi = gi+1)
        begin: af_del
            assign af_delays_w[gi] = af_delays[gi];
        end

		for (gi = 0; gi < 8; gi = gi+1)
		begin: rx
		    if (MPC_ID == 1 && gi == 7)
                // MPC receiver combined with 10 Gb transmitter
                mtf7_combo_link_exdes gc 
                (
                    .sync_ref_clk (sync_ref_clk[gi]),
                    .async_ref_clk (async_ref_clk),
                    .RXN_IN (rxn[gi]),
                    .RXP_IN (rxp[gi]),
                    .TXN_OUT (txn[gi]),
                    .TXP_OUT (txp[gi]),
                    .tx_inv_mask (tx_inv_mask[gi]),
                    .rx_inv_mask (rx_inv_mask[gi]),
                    .prbs_sel (prbs_sel),
                    .prbs_err (prbs_err[gi]),
                    .clk_160 (clk_160),
                
                    .rxdata (rxdata[gi]),
                    .rxcharisk (rxcharisk[gi]),
                    .rxdisperr (rxdisperr[gi]),
                    .rxnotintable (rxnotintable[gi]),

                    
                    .rxbyteisaligned (rxbyteisaligned[gi]),
                    .rxbyterealign (rxbyterealign[gi]),
                    .rxcommadet (rxcommadet[gi]),   
                    .soft_reset (soft_reset),
                    .hard_reset (hard_reset),
                    .rxbufreset (rxbufreset || idle_received[gi]), // reset rx buffer on user command or IDLE
                    .tx_rx_reset_done (tx_rx_reset_done[gi]),
                    
                    .txdata (txdata),
                    .clk_40 (clk_40),
                    .ttc_bc0 (ttc_bc0),
                    .txoutclk (txoutclk_async),
                    .link_id ({link_id[1], link_id[0]}),
                    .bxn_tx_offset (bxn_tx_offset),
                    .txcharisk_0 (txcharisk_0),
                    .gth_rx_reset(gth_rx_reset[gi]),
                	.cpll_lock (cpll_lock[gi]),
                    .gth_tx_reset_done (gth_tx_reset_done[gi])
                    
                );

		    else
                // regular MPC receiver
                single_rx_tx_exdes g
                (
                    .sync_ref_clk (sync_ref_clk[gi]),
                    .DRP_CLK_IN (clk_40),
                    .RXN_IN (rxn[gi]),
                    .RXP_IN (rxp[gi]),
                    .TXN_OUT (txn[gi]),
                    .TXP_OUT (txp[gi]),
                    .tx_inv_mask (tx_inv_mask[gi]),
                    .rx_inv_mask (rx_inv_mask[gi]),
                    .prbs_sel (prbs_sel),
                    .prbs_err (prbs_err[gi]),
                    .txoutclk (txoutclk[gi]),
                    .txusrclk (clk_160),
                    
                    .rxdata (rxdata[gi]),
                    .rxcharisk (rxcharisk[gi]),
                    .rxdisperr (rxdisperr[gi]),
                    .rxnotintable (rxnotintable[gi]),
                    .rxbyteisaligned (rxbyteisaligned[gi]),
                    .rxbyterealign (rxbyterealign[gi]),
                    .rxcommadet (rxcommadet[gi]),
                    .soft_reset (soft_reset | hard_reset),
                    .rxbufreset (rxbufreset || idle_received[gi]), // reset rx buffer on user command or IDLE
                    .tx_rx_reset_done (tx_rx_reset_done[gi]),
                    .rx_reset (rx_reset[gi]),
                    .resync (resync),
                    .rxoutclk (rxoutclk[gi]),
                    .gth_rx_reset(gth_rx_reset[gi]),
                	.cpll_lock (cpll_lock[gi]),
                    .gth_tx_reset_done (gth_tx_reset_done[gi]),
                    .power_down (power_down[gi])
                );


		end
	end
	endgenerate

	

//	reg [7:0] rxcharisk_r, rxcharisk_rr, rxcharisk_rrr, rxcharisk_rrrr, rxcharisk_rrrrr, rxcharisk_rrrrrr;
	reg [15:0] rxcharisk_r [7:0];
	reg [16:0] af_mem [7:0][63:0]; // alignment fifo memory
	reg [5:0] af_rd_addr [7:0]; // af read pointer
	reg [5:0] af_wr_addr [7:0]; // af write pointer
	
	
	reg [1:0] vpf [8:0];
	reg [1:0] lr [8:0];
	reg [7:0] hs [8:0][1:0];
	reg [6:0] wg [8:0][1:0];
	reg [3:0] qual [8:0][1:0];
	reg [3:0] cpat [8:0][1:0];
	reg [8:0] bc0;
	reg [8:0] bx0;
	reg [8:0] syer;

	reg [1:0] vpf_r [8:0];
	reg [1:0] lr_r [8:0];
	reg [7:0] hs_r [8:0][1:0];
	reg [6:0] wg_r [8:0][1:0];
	reg [3:0] qual_r [8:0][1:0];
	reg [3:0] cpat_r [8:0][1:0];
	reg [8:0] bc0_r;
	reg [8:0] bx0_r;
	reg [8:0] syer_r;
	
	reg [1:0] vpf_ph [8:0];
	reg [1:0] lr_ph [8:0];
	reg [7:0] hs_ph [8:0][1:0];
	reg [6:0] wg_ph [8:0][1:0];
	reg [3:0] qual_ph [8:0][1:0];
	reg [3:0] cpat_ph [8:0][1:0];
	reg [8:0] bc0_ph;
	reg [8:0] bx0_ph;
	reg [8:0] syer_ph;

	wire [1:0] vpf_rw [8:0];
	wire [1:0] lr_rw [8:0];
	wire [7:0] hs_rw [8:0][1:0];
	wire [6:0] wg_rw [8:0][1:0];
	wire [3:0] qual_rw [8:0][1:0];
	wire [3:0] cpat_rw [8:0][1:0];
	(* mark_debug = "TRUE" *) wire [8:0] bc0_rw = bc0_r;
	(* mark_debug = "TRUE" *) wire [8:0] bx0_rw = bx0_r;
	wire [8:0] syer_rw = syer_r;

	reg [7:0] bx0_u, bc01_u;
	wire [7:0] bx0_uw = bx0_u;


	assign vpf_rw = vpf_r;
    assign lr_rw = lr_r;
    assign hs_rw = hs_r;
    assign wg_rw = wg_r;
    assign qual_rw = qual_r;
    assign cpat_rw = cpat_r;

	assign bc0_o = bc0_r;
	assign bx0_o = bx0_r;
	assign syer_o = syer_r;
	
	reg [1:0] frame_cnt [7:0];
	reg [1:0] frame_cnt_u [7:0];
	reg [1:0] frame_cnt_ur [7:0];
	
	reg [15:0] frame [7:0][3:0];
	reg [15:0] frame_r [7:0][3:0];
	reg [7:0] bc0_u, bc0_ur, bc0_urr, bc0_u0r, bc01_ur, bc01_urr;
	reg [7:0] bc0_u_misp, bc01_u_misp;
	(* mark_debug = "TRUE" *) wire [7:0] bc0_uw = bc0_ur;
	(* mark_debug = "TRUE" *) wire [7:0] bc01_uw = bc01_ur;
	reg [13:0] orbit_cnt [7:0];
	reg [13:0] orbit_cnt1 [7:0];
    (* mark_debug = "FALSE" *) wire [7:0] bc0_err_period_w = bc0_err_period_o;

	reg bc0_u0;
	reg [7:0] byte_misalignment_4x;
	wire [7:0] byte_misalignment_4x_w = byte_misalignment_4x;

	wire [15:0] frame_w7 [3:0];
	reg [7:0] last_clk, last_clk1;
	reg [1:0] bc0_sel [7:0];
	
	
	genvar gk, gf;
	generate
		for (gk = 0; gk < 8; gk = gk+1)
		begin: frame_w_k
			assign rxdata_w[gk] = rxdata_r[gk];
			assign rxdata_af_w[gk] = rxdata_af[gk];
			assign rxcharisk_fw[gk] = rxcharisk_fr[gk];
		end
		
		for (gk = 0; gk < 4; `inc(gk))
		begin: frame_w_g
			assign frame_w7[gk] = frame[7][gk];
		end
		
		// alignment delay lines for input data, built on SRLC32E primitives
		for (gf = 0; gf < 8; gf = gf+1) // fiber loop
		begin: dyn_shift_fl
          dyn_shift #(.SELWIDTH(6), .BW(17)) dsd
          (
              .CLK(clk_160), 
              .CE(1'b1), 
              .SEL(af_delays[gf][5:0]), 
              .SI({rxcharisk[gf][0], rxdata[gf]}), 
              .DO({rxcharisk_af_t[gf], rxdata_af_t[gf]})
          );


        end
		      
	endgenerate

    // BC0 selection logic
    always @(*)
    begin
        for (i = 0; i < 8; i++)
        begin
            // BC0 selection control word
            bc0_sel[i] = {mpc_link_use_bc0_ch1[i+1], mpc_link_use_bc0_misplaced[i+1]};
            case (bc0_sel[i])
                2'b00: begin bc0_u_af[i] = bc0_u[i]; end // manual main bc0

                2'b10: begin bc0_u_af[i] = bc01_u[i]; end // manual CSCID=1 BC0

                2'b01, 2'b11: // automatic
                begin
                    bc0_u_af[i] = (bc0_err_period[i] == 1'b0) ? bc0_u[i] : // if BC0 from main chamber in the link comes in time get that BC0
                                  bc01_u[i]; // main chamber broken, try CSCID=1 BC0
                end
            endcase
        end
    end

    // report link error only when no BC0s are received from both the main chamber and CSCID=1
    assign bc0_err_period_o = bc0_err_period & bc0_err_period1;  

	always @(posedge clk_160)
	begin
	   idle_received = 8'h0;
		// logic for link ID extraction
		for (i = 0; i <= 7; i = i+1) // fiber loop
		begin
			
            if (rxcharisk_r[i] == 16'b1111111111000000) // train of IDLEs followed by train of non-IDLEs
			begin
				link_id[i] = rxdata_r[i][9:0]; // capture ID
				idle_received[i] = 1'b1;
			end
			
			// only detect valid IDLEs, including data code and K bit
			rxcharisk_r[i] = {rxcharisk_r[i][14:0], (rxcharisk_fr[i] == 2'h1 && rxdata_r[i] == 16'h50bc) ? 1'b1 : 1'b0};

			rxdata_r[i] = rxdata[i];
            rxdisperr_r [i]    = rxdisperr [i];
            rxnotintable_r [i] = rxnotintable [i];
			
			rxcharisk_fr[i]     = rxcharisk[i];
		end
		
		bc0_urr = bc0_ur;
		bc0_ur = bc0_u;
		bc01_urr = bc01_ur;
        bc01_ur = bc01_u;
		bc0_u0r = bc0_u0;

		// bc0 deframer before alignment fifo, for data alignment
		for (i = 0; i <= 7; i = i+1)
		begin
			frame_cnt_ur[i] = frame_cnt_u[i];
			byte_misalignment_4x[i] = 1'b0;
			if (rxcharisk[i] == 2'h0) // only if it's not comma 
			begin
				if (rxdata[i][15]) frame_cnt_u[i] = 2'h0; // reset frame counter on Frame0 flag
				
				if (frame_cnt_u[i] == 2'h1) // frame 1 all fibers
				begin
					bc0_u_misp[i] = rxdata[i][12]; // misplaced bc0
					bc01_u_misp[i] = rxdata[i][13]; // misplaced bc0 from chamber 1
				end

				if (frame_cnt_u[i] == 2'h2) // frame 2 all fibers
                begin
                    bc0_u[i] = rxdata[i][12]; // bc0
                    bc01_u[i] = rxdata[i][13]; // bc0 from chamber 1
                end
				
				frame_cnt_u[i] = frame_cnt_u[i] + 2'h1;
			end
			else
			begin
				bc0_u[i] = 1'b0;
				bc01_u[i] = 1'b0;
				bc0_u_misp[i] = 1'b0;
                bc01_u_misp[i] = 1'b0;
			end

			if ((frame_cnt_ur[i] + 2'h1) != frame_cnt_u[i])
			begin
				byte_misalignment_4x[i] = 1'b1;
			end

			// bc0 sanity check
			if (orbit_cnt[i] == 14'h0) // check that this bc0 is coming once per orbit
			begin
			    if (last_clk[i] == 1'b1) // previous clk was last LHC orbit clk
                    bc0_err_period[i] = 1'b0; // no error
                else
    			    bc0_err_period[i] = 1'b1; // bc0 did not come in time from this fiber
            end
                
            if (orbit_cnt[i] == LHC_LAST_CLK) last_clk[i] = 1'b1;
            else last_clk[i] = 1'b0;
            
			if (bc0_ur[i] && !bc0_urr[i]) // bc0 from fiber just rose 
				orbit_cnt[i] = 14'h0; // reset orbit counter
			else
    			`inc(orbit_cnt[i]);
			
			// bc0 chamber 1 sanity check
            if (orbit_cnt1[i] == 14'h0) // check that this bc0 is coming once per orbit
            begin
                if (last_clk1[i] == 1'b1) // previous clk was last LHC orbit clk
                    bc0_err_period1[i] = 1'b0; // no error
                else
                    bc0_err_period1[i] = 1'b1; // bc0 did not come in time from this fiber
            end
                
            if (orbit_cnt1[i] == LHC_LAST_CLK) last_clk1[i] = 1'b1;
            else last_clk1[i] = 1'b0;
            
            if (bc01_ur[i] && !bc01_urr[i]) // bc0 from fiber just rose 
                orbit_cnt1[i] = 14'h0; // reset orbit counter
            else
                `inc(orbit_cnt1[i]);

			// reset bc0 error flags on byte alignment
			if (idle_received[i])
			begin
				bc0_err_period[i] = 1'b1; // start assuming that the link is not synced
				bc0_err_period1[i] = 1'b1; // start assuming that the link is not synced
				bc0_err_stuck[i] = 1'b0;
			end

		end

		// logic for detecting chamber 0 bc0 out of time
		if (rxcharisk[6] == 2'h0 && bc0_err_period[i] == 1'b0) // only if it's not comma and fiber is enabled
		begin
			if (frame_cnt_u[6] == 2'h0) // frame 3 fiber 6 (frame cnt[6] is already incremented earlier)
				bc0_u0 = rxdata[6][12]; // bc0 from chamber 0
				
		end
		else
		begin
			bc0_u0 = 1'b0;
		end
		// reset bc0 error flags on byte alignment
		if (idle_received[i])
		begin
			bc0_err_chamber0 = 1'b0;
		end
		else
		if ((bc0_ur[6] ^ bc0_u0r) != 1'b0) // bc0 from chamber 0 does not match chamber 6 (on the same fiber)
		begin
			bc0_err_chamber0 = 1'b1;
		end
		
		for (i = 0; i < 8; i = i+1) // fiber loop
		begin

			// complete deframer after alignment fifo
			// tracks stubs are swapped 0<->1 because MPC sends best stub in index [1]
			if (rxcharisk_af[i] == 1'h0) // only if it's not comma 
			begin
				if (rxdata_af[i][15]) 
				begin
					frame_cnt[i] = 2'h0; // reset frame counter on Frame0 flag
				end
				
				frame[i][frame_cnt[i]] = rxdata_af[i];

				case (frame_cnt[i])
					2'h0:
					begin
						hs[i+1][1] = rxdata_af[i][7:0]; // halfstrip lct0
						wg[i+1][1] = rxdata_af[i][14:8]; // wiregroup lct0
					end
					
					2'h1:
					begin
						hs[i+1][0] = rxdata_af[i][7:0]; // halfstrip lct1
						wg[i+1][0] = rxdata_af[i][14:8]; // wiregroup lct1
					end
					
					2'h2:
					begin
						qual[i+1][1] = rxdata_af[i][3:0]; // quality lct0
						cpat[i+1][1] = rxdata_af[i][7:4]; // clct pattern lct0
						lr[i+1] = {rxdata_af[i][8], rxdata_af[i][9]}; // left/right for both lcts
						vpf[i+1] = {rxdata_af[i][10], rxdata_af[i][11]}; // valid patterns both lcts
						bc0[i+1] = rxdata_af[i][12]; // bc0
						bx0[i+1]  = rxdata_af[i][13]; // bx0
						syer[i+1] = rxdata_af[i][14]; // sync error
					end
					
					2'h3:
					begin
						qual[i+1][0] = rxdata_af[i][3:0]; // quality lct1
						cpat[i+1][0] = rxdata_af[i][7:4]; // clct pattern lct1
						// unpack fields for chamber 0, spread through all 8 fibers
						case (i)
							0:
							begin
								wg[0][1] = rxdata_af[i][14:8];
							end
							
							1:
							begin
								wg[0][0] = rxdata_af[i][14:8];
							end
							
							2:
							begin
								hs[0][1][6:0] = rxdata_af[i][14:8];
							end
							
							3:
							begin
								hs[0][0][6:0] = rxdata_af[i][14:8];
							end
							
							4:
							begin
								qual[0][1] = rxdata_af[i][11:8];
								lr[0][1] = rxdata_af[i][12];
								vpf[0][1] = rxdata_af[i][13];
								hs[0][1][7] = rxdata_af[i][14];
							end
							
							5:
							begin
								qual[0][0] = rxdata_af[i][11:8];
								lr[0][0] = rxdata_af[i][12];
								vpf[0][0] = rxdata_af[i][13];
								hs[0][0][7] = rxdata_af[i][14];
							end
							
							6:
							begin
								cpat[0][1] = rxdata_af[i][11:8];
								bc0[0] = rxdata_af[i][12];
								bx0[0] = rxdata_af[i][13];
								syer[0] = rxdata_af[i][14];
							end
							
							7:
							begin
								cpat[0][0] = rxdata_af[i][11:8];
							end
							
						endcase
					end
				endcase
			
			    // if no valid BC0s from link, remove LCTs
//			    if ((bc0_err_period[i] == 1'b1 && bc0_err_period1[i] == 1'b1) || fiber_enable[i] == 1'b0)
			    if (fiber_enable[i] == 1'b0)
				begin
                    bc0[i+1] = 1'b0;
                    vpf[i+1] = 2'b00;
                    bc0[0] = 1'b0;
                    vpf[0] = 2'b00;
                end
                
			end
			else
			begin
				bc0[i+1] = 1'b0;
				vpf[i+1] = 2'b00;
				if (i == 6) bc0[0] = 1'b0;
				if (i == 5) vpf[0][1] = 1'b0;
				if (i == 4) vpf[0][0] = 1'b0;
			end
		end

        rxdata_af = rxdata_af_t;
        rxcharisk_af = rxcharisk_af_t;

		// lock previously deframed data into registers on the correct data phase
        if (frame_cnt[6] == 2'h3) // lock chamber 0 here, since bc0 is transmitted on fiber 6
        begin
            vpf_ph [0] = vpf[0];
            lr_ph [0] = lr[0];
            for (j = 0; j < 2; j = j+1) // lct loop
            begin
                hs_ph [0][j] = hs[0][j];
                wg_ph [0][j] = wg [0][j];
                qual_ph [0][j] = qual [0][j];
                cpat_ph [0][j] = cpat [0][j];
            end
            bc0_ph[0] = bc0[0];
            bx0_ph[0] = bx0[0];
            syer_ph[0] = syer[0];
        
        end
       

        for (i = 0; i < 8; i = i+1) // chamber loop
        begin
            if (frame_cnt[i] == 2'h3) // last frame is decoded, store all deframed data in phase
            begin
                vpf_ph [i+1] = vpf[i+1];
                lr_ph [i+1] = lr[i+1];
                for (j = 0; j < 2; j = j+1) // lct loop
                begin
                    hs_ph [i+1][j] = hs[i+1][j];
                    wg_ph [i+1][j] = wg [i+1][j];
                    qual_ph [i+1][j] = qual [i+1][j];
                    cpat_ph [i+1][j] = cpat [i+1][j];
                end
                bc0_ph[i+1] = bc0[i+1];
                bx0_ph[i+1] = bx0[i+1];
                syer_ph[i+1] = syer[i+1];
                
            end
		    `inc(frame_cnt[i]);
        end

		
		//prbs error flags logic
		if (prbs_sel == 3'h0) prbs_err_persist = 8'h0; // reset flags when not PRBSing
		else prbs_err_persist = prbs_err_persist | prbs_err; // keep errors for user to see

	end

	reg [7:0] byte_misaligned;
	wire [7:0] byte_misaligned_w = byte_misaligned;

	// lock deframed information by 40 MHz clock
	always @(posedge clk_40)
	begin
		for (i = 0; i < 9; i = i+1) // chamber loop
		begin
			for (j = 0; j < 2; j = j+1) // lct loop
			begin
                lct_o[i][j].vf = vpf_ph[i][j];
                lct_o[i][j].lr = lr_ph[i][j];
				lct_o[i][j].hs = hs_ph[i][j];
				lct_o[i][j].wg = wg_ph [i][j];
				lct_o[i][j].ql = qual_ph [i][j];
				lct_o[i][j].cp = cpat_ph [i][j];
			end
			
			// rate counter update
			if (lct_o[i][0].vf != 1'h0 && rate_counter[i] != 26'h3ffffff) rate_counter[i] = rate_counter[i] + 26'h1;
		end
		bc0_r = bc0_ph;
		bx0_r = bx0_ph;
		syer_r = syer_ph;
		
		
		
		for (i = 0; i < 8; i = i+1) // fiber loop
		begin

			// logic for detecting byte misalignment
			byte_misaligned[i] = 1'b0;
			if ({frame_r[i][3][15], frame_r[i][2][15], frame_r[i][1][15], frame_r[i][0][15]} != 4'b0001)
			begin
				byte_misaligned[i] = 1'b1;
			end
			
			for (j = 0; j < 4; j = j+1) // frame loop
			begin
				frame_r[i][j] = frame[i][j];
			end
		end
		
		if (rate_period == 26'd40078700) // 1 sec 
		begin
		  // rate period expired, store and reset all counters
		  for (i = 0; i < 9; i = i+1)
		  begin
		      stub_rate[i] = rate_counter[i]; 
		      rate_counter[i] = 26'h0;
		  end
		  rate_period = 26'h0;
		end
		else 
		  rate_period = rate_period + 26'h1;
	end
	

   reg [26:0] clk_div = 0;

   reg [5:0] rx_valid_dl;

    wire rx_valid_or = 
        ((rxdata[0][11] | rxdata[0][10]) && bc0_err_period[0] == 1'b0); 
//        | 
//        ((rxdata[1][11] | rxdata[1][10]) & fiber_enable[1]) | 
//        ((rxdata[2][11] | rxdata[2][10]) & fiber_enable[2]) | 
//        ((rxdata[3][11] | rxdata[3][10]) & fiber_enable[3]) | 
//        ((rxdata[4][11] | rxdata[4][10]) & fiber_enable[4]) | 
//        ((rxdata[5][11] | rxdata[5][10]) & fiber_enable[5]) | 
//        ((rxdata[6][11] | rxdata[6][10]) & fiber_enable[6]) | 
//        ((rxdata[7][11] | rxdata[7][10]) & fiber_enable[7]);

   always @(posedge clk_160)
   begin
          if (clk_div >= 27'd40000000)
                begin
                   clk_div = 27'h0;
                   clk_led = ~clk_led;

                end
          else
                clk_div = clk_div + 27'h1;
                
        rx_valid_dl = {rx_valid_dl[4:0], rx_valid_or};                
                
   end

    assign rx_valid_tp = |rx_valid_dl;

	(* mark_debug = "TRUE" *) wire [1:0] vpf_w [8:0];
	(* mark_debug = "TRUE" *) wire [7:0] hs_w [8:0][1:0];

    genvar wi, wj;
    generate
        for (wi = 0; wi < 9; wi = wi+1)
        begin
            for (wj = 0; wj < 2; wj = wj+1)
            begin
                assign vpf_w[wi][wj] = lct_o[wi][wj].vf;
                assign hs_w[wi][wj] = lct_o[wi][wj].hs;
            end
        end
    endgenerate

endmodule
