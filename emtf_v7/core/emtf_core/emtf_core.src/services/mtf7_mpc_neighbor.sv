`timescale 1ns / 1ps
`include "../core/vppc_macros.sv"
module mtf7_mpc_neighbor #
(parameter FC = 9) // fiber count 
(

	input [FC-1:0] sync_ref_clk,
	input clk_40,
	input clk_160,
	input [FC-1:0] rxn,
	input [FC-1:0] rxp,
	output [FC-1:0] txn,
	output [FC-1:0] txp,
	input soft_reset,
	input rxbufreset,
	input [FC-1:0] tx_inv_mask,
	input [FC-1:0] rx_inv_mask,
	
	output reg [FC*16-1:0] rxdata_o,
	
	output reg [FC*10-1:0] link_id_o,

	// deframed output data
	(* async_reg = "TRUE" *) csc_lct lct_o [FC-1:0][1:0],
	output [FC-1:0] bc0_o,
	output [FC-1:0] bx0_o,
	output [FC-1:0] syer_o,
	
	// deframed bc0 before AF for alignment
	// one from each fiber
	output reg [FC-1:0] bc0_u_af,


	input [FC-1:0] fiber_enable,
	input [7:0] af_delays [FC-1:0],
	input resync,
	// bc0 error flags
	output reg [FC-1:0] bc0_err_period,
	output reg [FC-1:0] bc0_err_stuck,
	output [FC-1:0] rxbyteisaligned,
	output rxoutclk_o,
	
	input [2:0] prbs_sel,
	output reg [FC-1:0] prbs_err_persist,
	
    output reg [25:0] stub_rate [FC-1:0],
    
	input [8:0] mpc_link_use_bc0_ch1,
    input [8:0] mpc_link_use_bc0_misplaced,
    input [7:0] gth_rx_reset,
	output [1:0] tx_rx_reset_done [FC-1:0],
 	output [FC-1:0] cpll_lock,
    output [FC-1:0] gth_tx_reset_done,
    input  [FC-1:0] power_down
   
    
);
	localparam LHC_LAST_CLK= 14'h37af; //(3564 * 4 - 1);
	integer i, j;

	wire [FC-1:0] prbs_err;
	
	wire [FC-1:0] txoutclk;
	wire [15:0] rxdata [FC-1:0];
	reg [15:0] rxdata_r [FC-1:0];
	wire [15:0] rxdata_w [FC-1:0];
	wire [1:0] rxcharisk [FC-1:0];
	reg [1:0] rxcharisk_fr [FC-1:0];
	wire [1:0] rxcharisk_fw [FC-1:0];
    wire [FC-1:0] rxbyterealign;
    wire [FC-1:0] rxcommadet;
	

	wire [FC-1:0] rx_reset;

	reg [9:0] link_id [FC-1:0];
	`merge_mem_1_n(link_id_o, link_id, 10, FC);

	reg [FC-1:0] af_rd_en, af_wr_en;
	reg [15:0] rxdata_af [FC-1:0];
	wire [15:0] rxdata_af_t [FC-1:0];
	`merge_mem_1_n(rxdata_o, rxdata_r, 16, FC);
	reg [FC-1:0] rxcharisk_af;
	wire [FC-1:0] rxcharisk_af_t;
	wire [5:0] af_data_count [FC-1:0];
	wire [FC-1:0] af_reset;
	wire [FC-1:0] rxoutclk;
	reg [25:0] rate_period;
	reg [25:0] rate_counter [FC-1:0];
	reg [FC-1:0] idle_received;
    reg [FC-1:0] bc0_u, bc01_u, bc0_u_misp, bc01_u_misp;
	
	assign rxoutclk_o = rxoutclk[0];

	genvar gi, gj;
	generate
	begin : serial

		for (gi = 0; gi < FC; gi = gi+1)
		begin: rx
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
                .rxbyteisaligned (rxbyteisaligned[gi]),
                .rxbyterealign (rxbyterealign[gi]),
                .rxcommadet (rxcommadet[gi]),
                .soft_reset (soft_reset),
                .rxbufreset (rxbufreset || idle_received[gi]), // reset rx buffer on user command or IDLE
                .tx_rx_reset_done (tx_rx_reset_done[gi]),
                .rx_reset (rx_reset[gi]),
                .resync (resync),
                .rxoutclk (rxoutclk[gi]),
                .gth_rx_reset (gth_rx_reset[gi]),
              	.cpll_lock (cpll_lock[gi]),
                .gth_tx_reset_done (gth_tx_reset_done[gi]),
                .power_down (power_down)
            );
        end
    end
	endgenerate

	

//	reg [FC-1:0] rxcharisk_r, rxcharisk_rr, rxcharisk_rrr, rxcharisk_rrrr, rxcharisk_rrrrr, rxcharisk_rrrrrr;
	reg [15:0] rxcharisk_r [FC-1:0];
	
	
	reg [1:0] vpf [FC-1:0];
	reg [1:0] lr [FC-1:0];
	reg [7:0] hs [FC-1:0][1:0];
	reg [6:0] wg [FC-1:0][1:0];
	reg [3:0] qual [FC-1:0][1:0];
	reg [3:0] cpat [FC-1:0][1:0];
	reg [FC-1:0] bc0;
	reg [FC-1:0] bx0;
	reg [FC-1:0] syer;

	reg [1:0] vpf_r [FC-1:0];
	reg [1:0] lr_r [FC-1:0];
	reg [7:0] hs_r [FC-1:0][1:0];
	reg [6:0] wg_r [FC-1:0][1:0];
	reg [3:0] qual_r [FC-1:0][1:0];
	reg [3:0] cpat_r [FC-1:0][1:0];
	reg [FC-1:0] bc0_r;
	reg [FC-1:0] bx0_r;
	reg [FC-1:0] syer_r;
	
	reg [1:0] vpf_ph [FC-1:0];
	reg [1:0] lr_ph [FC-1:0];
	reg [7:0] hs_ph [FC-1:0][1:0];
	reg [6:0] wg_ph [FC-1:0][1:0];
	reg [3:0] qual_ph [FC-1:0][1:0];
	reg [3:0] cpat_ph [FC-1:0][1:0];
	reg [FC-1:0] bc0_ph;
	reg [FC-1:0] bx0_ph;
	reg [FC-1:0] syer_ph;

	wire [1:0] vpf_rw [FC-1:0];
	wire [1:0] lr_rw [FC-1:0];
	wire [7:0] hs_rw [FC-1:0][1:0];
	wire [6:0] wg_rw [FC-1:0][1:0];
	wire [3:0] qual_rw [FC-1:0][1:0];
	wire [3:0] cpat_rw [FC-1:0][1:0];
	wire [FC-1:0] bc0_rw = bc0_r;
	wire [FC-1:0] bx0_rw = bx0_r;
	wire [FC-1:0] syer_rw = syer_r;

	assign vpf_rw = vpf_r;
    assign lr_rw = lr_r;
    assign hs_rw = hs_r;
    assign wg_rw = wg_r;
    assign qual_rw = qual_r;
    assign cpat_rw = cpat_r;

	assign bc0_o = bc0_r;
	assign bx0_o = bx0_r;
	assign syer_o = syer_r;
	
	reg [1:0] frame_cnt [FC-1:0];
	reg [1:0] frame_cnt_u [FC-1:0];
	reg [1:0] frame_cnt_ur [FC-1:0];
	
	reg [15:0] frame [FC-1:0][3:0];
	reg [15:0] frame_r [FC-1:0][3:0];
	reg [FC-1:0] bc0_ur, bc0_urr, bc0_u0r;
	wire [FC-1:0] bc0_uw = bc0_ur;
	reg [13:0] orbit_cnt [FC-1:0];
	reg bc0_u0;
	reg [FC-1:0] byte_misalignment_4x;
	wire [FC-1:0] byte_misalignment_4x_w = byte_misalignment_4x;

	reg [FC-1:0] last_clk;
	reg [1:0] bc0_sel [7:0];


	genvar gk, gf;
	generate
		for (gk = 0; gk < FC; gk = gk+1)
		begin: frame_w_k
			assign rxdata_w[gk] = rxdata_r[gk];
			assign rxcharisk_fw[gk] = rxcharisk_fr[gk];
		end
		
		// alignment delay lines for input data, built on SRLC32E primitives
		for (gf = 0; gf < FC; gf = gf+1) // fiber loop
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
        for (i = 0; i < FC; i++)
        begin
            // BC0 selection control word
            bc0_sel[i] = {mpc_link_use_bc0_ch1[i], mpc_link_use_bc0_misplaced[i]};
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


	always @(posedge clk_160)
	begin
	   idle_received = 0;
		// logic for link ID extraction
		for (i = 0; i < FC; i = i+1) // fiber loop
		begin
			
            if (rxcharisk_r[i] == 16'b1111111111000000) // train of IDLEs followed by train of non-IDLEs
			begin
				link_id[i] = rxdata_r[i][9:0]; // capture ID
				idle_received[i] = 1'b1;
			end
			
			if (!fiber_enable[i]) link_id[i] = 10'h0; // zero IDs for disabled fibers 
			
			// only detect valid IDLEs, including data code and K bit
			rxcharisk_r[i] = {rxcharisk_r[i][14:0], (rxcharisk_fr[i] == 2'h1 && rxdata_r[i] == 16'h50bc) ? 1'b1 : 1'b0};

            rxdata_r[i] = rxdata[i];
            rxcharisk_fr[i]     = rxcharisk[i];
		end
		
		bc0_urr = bc0_ur;
		bc0_ur = bc0_u;
		bc0_u0r = bc0_u0;

		// bc0 deframer before alignment fifo, for data alignment
		for (i = 0; i < FC; i = i+1)
		begin
			frame_cnt_ur[i] = frame_cnt_u[i];
			byte_misalignment_4x[i] = 1'b0;
			if (rxcharisk[i] == 2'h0) // only if it's not comma and fiber is enabled
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
			
			// reset bc0 error flags on IDLE reception
			if (idle_received[i])
			begin
				bc0_err_period[i] = 1'b1; // start assuming that the link is not synced
				bc0_err_stuck[i] = 1'b0;
			end

		end
				
		for (i = 0; i < FC; i = i+1) // fiber loop
		begin

			// complete deframer after alignment fifo
			// track stubs are swapped 0<->1 because MPC sends best stub in index [1]
//			if (rxcharisk_af[i] == 1'h0 && bc0_err_period[i] == 1'b0 && fiber_enable[i] == 1'b1) // only if it's not comma and fiber is enabled
			if (rxcharisk_af[i] == 1'h0 && fiber_enable[i] == 1'b1) // only if it's not comma and fiber is enabled
			begin
				if (rxdata_af[i][15]) 
				begin
					frame_cnt[i] = 2'h0; // reset frame counter on Frame0 flag
				end
				
				frame[i][frame_cnt[i]] = rxdata_af[i];

				case (frame_cnt[i])
					2'h0:
					begin
						hs[i][1] = rxdata_af[i][7:0]; // halfstrip lct0
						wg[i][1] = rxdata_af[i][14:8]; // wiregroup lct0
					end
					
					2'h1:
					begin
						hs[i][0] = rxdata_af[i][7:0]; // halfstrip lct1
						wg[i][0] = rxdata_af[i][14:8]; // wiregroup lct1
					end
					
					2'h2:
					begin
						qual[i][1] = rxdata_af[i][3:0]; // quality lct0
						cpat[i][1] = rxdata_af[i][7:4]; // clct pattern lct0
						lr[i] = {rxdata_af[i][8], rxdata_af[i][9]}; // left/right for both lcts
						vpf[i] = {rxdata_af[i][10], rxdata_af[i][11]}; // valid patterns both lcts
						bc0[i] = rxdata_af[i][12]; // bc0
						bx0[i]  = rxdata_af[i][13]; // bx0
						syer[i] = rxdata_af[i][14]; // sync error
					end
					
					2'h3:
					begin
						qual[i][0] = rxdata_af[i][3:0]; // quality lct1
						cpat[i][0] = rxdata_af[i][7:4]; // clct pattern lct1
					end
				endcase
				
			end
			else
			begin
				bc0[i] = 1'b0;
				vpf[i] = 2'b00;
			end
		end

        rxdata_af = rxdata_af_t;
        rxcharisk_af = rxcharisk_af_t;

		// lock previously deframed data into registers on the correct data phase
        for (i = 0; i < FC; i = i+1) // chamber loop
        begin
            if (frame_cnt[i] == 2'h3) // last frame is decoded, store all deframed data in phase
            begin
                vpf_ph [i] = vpf[i];
                lr_ph [i] = lr[i];
                for (j = 0; j < 2; j = j+1) // lct loop
                begin
                    hs_ph [i][j] = hs[i][j];
                    wg_ph [i][j] = wg [i][j];
                    qual_ph [i][j] = qual [i][j];
                    cpat_ph [i][j] = cpat [i][j];
                end
                bc0_ph[i] = bc0[i];
                bx0_ph[i] = bx0[i];
                syer_ph[i] = syer[i];
                
            end
		    `inc(frame_cnt[i]);
        end

		
		//prbs error flags logic
		if (prbs_sel == 3'h0) prbs_err_persist = 0; // reset flags when not PRBSing
		else prbs_err_persist = prbs_err_persist | prbs_err; // keep errors for user to see

	end

	reg [FC-1:0] byte_misaligned;
	wire [FC-1:0] byte_misaligned_w = byte_misaligned;

	// lock deframed information by 40 MHz clock
	always @(posedge clk_40)
	begin
		for (i = 0; i < FC; i = i+1) // chamber loop
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
		
		
		
		for (i = 0; i < FC; i = i+1) // fiber loop
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

endmodule
