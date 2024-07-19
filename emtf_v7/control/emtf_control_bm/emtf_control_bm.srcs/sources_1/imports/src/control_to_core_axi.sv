`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:42:47 05/09/2014 
// Design Name: 
// Module Name:    control_to_core_axi 
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
module control_to_core_axi # 
(
	parameter SB = 5, // how many bits to serialize
	parameter AW = 32, // address width
	parameter DW = 64  // data width
)
(
  input s_aclk,
  input s_aresetn,
  input [5:0]s_axi_awid,
  input [AW-1:0]s_axi_awaddr,
  input [7:0]s_axi_awlen,
  input [2:0]s_axi_awsize,
  input [1:0]s_axi_awburst,
  input s_axi_awvalid,
  output s_axi_awready,
  input [DW-1:0]s_axi_wdata,
  input [7:0]s_axi_wstrb,
  input s_axi_wlast,
  input s_axi_wvalid,
  output s_axi_wready,
  output reg [5:0]s_axi_bid,
  output reg [1:0]s_axi_bresp,
  output reg s_axi_bvalid,
  input s_axi_bready,
  input [5:0]s_axi_arid,
  input [AW-1:0]s_axi_araddr,
  input [7:0]s_axi_arlen,
  input [2:0]s_axi_arsize,
  input [1:0]s_axi_arburst,
  input s_axi_arvalid,
  output s_axi_arready,
  output [5:0]s_axi_rid,
  output reg [DW-1:0]s_axi_rdata,
  output [1:0]s_axi_rresp,
  output reg s_axi_rlast,
  output reg s_axi_rvalid,
  input s_axi_rready,
  
  input control_phase_inc,
  
  input ext_clk_in,
  input [13:0] ext_data_in,
  output ext_clk_out,
  output [13:0] ext_data_out

);

	assign s_axi_arready = 1'b1;
	assign s_axi_wready = 1'b1;
	assign s_axi_awready = 1'b1;
	assign s_axi_rid = 6'b0;
	assign s_axi_rresp = 2'h0;

	wire [69:0] data_in;
	reg [69:0] data_out = 70'h1;
	reg [69:0] data_out_r;
	wire clk_div;
	wire clk_625M_in, clk_125M_in, clk_625M_out, clk_125M_out;
	wire data_in_valid;
	wire [68:0] data_in_cd;
	
	assign ext_clk_out = s_aclk; // output data clock is pcie clock

	reg wvalid_r;

	wire ext_clk_in_b;
	IBUFG ext_clk_buf (.I(ext_clk_in), .O(ext_clk_in_b));
	
	integer i;
	reg [15:0] trn_pat_cnt;
	
	always @(posedge s_aclk)
	begin
	
		data_out_r = data_out;
		wvalid_r = s_axi_wvalid;
	
	  if (locked_in && locked_out)
	  begin
		// combine all output bits into data_out bus
		// assign dedicated bits first

//		data_out = {data_out[68:0], data_out[69]};

		// bit 69 shows that there is any valid data
		data_out[69] = s_axi_awvalid || s_axi_wlast || s_axi_wvalid || s_axi_arvalid;
		data_out[68] = s_axi_awvalid;
		data_out[67] = s_axi_wlast;
		data_out[66] = s_axi_wvalid;
		data_out[65] = s_axi_arvalid;
	
		if (s_axi_awvalid)
		begin
			// send write address and other information
			data_out[64:0] = 
			{
				s_axi_awid,
				s_axi_awaddr,
				s_axi_awlen,
				s_axi_awsize,
				s_axi_awburst
			};
		end
		
		if (s_axi_arvalid)
		begin
			// send read address and other information
			data_out[64:0] = 
			{
				s_axi_arid,
				s_axi_araddr,
				s_axi_arlen,
				s_axi_arsize,
				s_axi_arburst
			};
		end
		
		if (s_axi_wvalid)
		begin	
			// send data
			data_out[64:0] = s_axi_wdata;
		end

		// send training pattern after reset 
		if (trn_pat_cnt != 16'hffff)
		begin
			data_out = {14{5'h1}};
			trn_pat_cnt =  trn_pat_cnt + 16'h1;
		end
		
		
		// split input bits into AXI signals
		// dedicated bits first
		s_axi_bvalid = data_in_cd[68];
		s_axi_rlast  = data_in_cd[67];
		s_axi_rvalid = data_in_cd[66];
		
		if (s_axi_bvalid)
		begin
			{s_axi_bid, s_axi_bresp} = data_in_cd[7:0];
		end
		if (s_axi_rvalid)
		begin
			s_axi_rdata = data_in_cd[63:0];
		end
	  end
	  else
	  begin
		data_out = 70'h0;
		s_axi_bvalid = 1'b0;
		s_axi_rlast = 1'b0;
		s_axi_rvalid = 1'b0;
		{s_axi_bid, s_axi_bresp} = 8'h0;
		s_axi_rdata = 64'h0;
		trn_pat_cnt = 16'h0;
	  end
	end

	reg psen;
	wire psdone;
	// mmcm for rx clock
	ctoc_mmcm_in ctoc_mmcm_in_
	(
		.clk_125M_in(ext_clk_in_b), 
		.clk_625M(clk_625M_in),  
		.clk_125M(clk_125M_in),  
		.psclk(s_aclk),// IN
		.psen(psen), // IN
		.psincdec(1'b1),     // IN
		.psdone(psdone),       // OUT
		.reset(~s_aresetn),
		.input_clk_stopped(),
		.locked(locked_in)
	);      


	localparam RX_PHASE = 12; // fine phase for RX MMCM
	localparam RX_PH_CLK = RX_PHASE * 16;
	reg [9:0] rx_ph_cnt;
	reg control_phase_inc_r, control_phase_inc_rr;
	reg phase_done;

	// MMCM phase adjustment logic
	always @(posedge s_aclk)
	begin
		psen = 1'b0;
	
		if (!locked_in)
		begin
			// mmcm is still locking
			rx_ph_cnt = 10'h0; // reset counter
			phase_done = 1'b0;
		end
		else
		begin

			if (rx_ph_cnt < RX_PH_CLK)
			begin
				if (rx_ph_cnt[3:0] == 4'h0) // every 16-th clock
					psen = 1'b1; // increase MMCM phase
					
				rx_ph_cnt = rx_ph_cnt + 10'h1; // increase counter
			end
			else
				phase_done = 1'b1;

			// debug
			if (!control_phase_inc_rr && control_phase_inc_r)
			begin
				psen = 1'b1;
//				phase_done = 1'b0;
			end
			// end debug
//			if (psdone)
//				phase_done = 1'b1;			
		end
		control_phase_inc_rr = control_phase_inc_r;
		control_phase_inc_r = control_phase_inc;
	
	end

	// mmcm for tx clock
	ctoc_mmcm ctoc_mmcm_out
	(
		.clk_125M_in(s_aclk), 
		.clk_625M(clk_625M_out),
		.clk_125M(clk_125M_out), 
		.reset(~s_aresetn),
		.input_clk_stopped(), 
		.locked(locked_out)
	);      

	reg rst_isd, rst_osd, rst_isd_r, rst_isd_t;
	reg locked_in_r, locked_in_rr;
	reg locked_out_r, locked_out_rr;
	reg [13:0] bitslip;
	
	localparam BS_IDLE = 2'h0;
	localparam BS_CHECK = 2'h1;
	localparam BS_PAUSE = 2'h2;
	
	reg [1:0] bs_st = BS_IDLE;
	reg [2:0] bs_cnt, bs_bits;
	
	reg phase_done_t, phase_done_tt, phase_done_ttt;
	
	always @(posedge clk_125M_in)
	begin
		rst_isd_t = rst_isd;
		rst_isd = ~(locked_in_rr & locked_out_rr);
		locked_in_rr = locked_in_r;
		locked_in_r = locked_in;
		locked_out_rr = locked_out_r;
		locked_out_r = locked_out;
		
		bitslip = 14'h0;
		// bit slip state machine, aligns all ISERDESs using training pattern
		case (bs_st)
			BS_IDLE:
			begin
				// after ISERDES reset goes down, wait a bit and then go to start
				bs_cnt = 3'h0;
				bs_bits = 3'h0;
//				if (!rst_isd && rst_isd_t) bs_st = BS_PAUSE;
				if (phase_done_tt && !phase_done_ttt) bs_st = BS_PAUSE;
			end
			
			BS_CHECK:
			begin
				// check if iserdes output matches training pattern
				for (i = 0; i < 14; i = i+1)
				begin
					if (data_in[i*SB +: 5] != 5'h1)
					begin
						bitslip[i] = 1'b1; // if does not match, set bitslip bit
					end
				end
				
				bs_cnt = 3'h0;
				bs_st = BS_PAUSE;
				// finish at maximum count of bit slips
				if (bs_bits == 3'h4) bs_st = BS_IDLE;
				bs_bits = bs_bits + 3'h1;
			end
			
			BS_PAUSE:
			begin
				// wait some time to let bitslip operation take effect
				if (bs_cnt == 3'h7) bs_st = BS_CHECK;
				bs_cnt = bs_cnt + 3'h1;
			end
		endcase
		phase_done_ttt = phase_done_tt;
		phase_done_tt = phase_done_t;
		phase_done_t = phase_done;
		
	end

	always @(posedge clk_125M_out)
	begin
		rst_osd = rst_isd_r;
		rst_isd_r = rst_isd;
	end


	genvar gi;
	generate
		for (gi = 0; gi < 14; gi = gi+1)
		begin: serdes_loop
			ISERDESE2 #
			(
				.DATA_RATE ("SDR"),
				.DATA_WIDTH (5),
				.INTERFACE_TYPE ("NETWORKING")
			)
			isd
			(
				.Q1 (data_in[gi*SB + 4]),
				.Q2 (data_in[gi*SB + 3]),
				.Q3 (data_in[gi*SB + 2]),
				.Q4 (data_in[gi*SB + 1]),
				.Q5 (data_in[gi*SB + 0]),
				.Q6 (),
				.Q7 (),
				.Q8 (),
				.O  (),
				.SHIFTOUT1 (),
				.SHIFTOUT2 (),
				.D  (ext_data_in[gi]),
				.DDLY (1'b0),
				.CLK (clk_625M_in),
				.CLKB (~clk_625M_in),
				.CE1 (1'b1),
				.CE2 (1'b1),
				.RST (rst_isd),
				.CLKDIV (clk_125M_in),
				.CLKDIVP (1'b0),
				.OCLK (1'b0),
				.OCLKB (1'b0),
				.BITSLIP (bitslip[gi]),
				.SHIFTIN1 (1'b0),
				.SHIFTIN2 (1'b0),
				.OFB (1'b0),
				.DYNCLKDIVSEL (1'b0),
				.DYNCLKSEL (1'b0)
				
			);
			
			OSERDESE2
			# (
				 .DATA_RATE_OQ   ("SDR"),
				 .DATA_RATE_TQ   ("SDR"),
				 .DATA_WIDTH     (5),
				 .TRISTATE_WIDTH (1),
				 .SERDES_MODE    ("MASTER")
			)
			osd 
			(
				.D1             (data_out[gi*SB + 0]),
				.D2             (data_out[gi*SB + 1]),
				.D3             (data_out[gi*SB + 2]),
				.D4             (data_out[gi*SB + 3]),
				.D5             (data_out[gi*SB + 4]),
				.D6             (1'b0),
				.D7             (1'b0),
				.D8             (1'b0),
				.T1             (1'b0),
				.T2             (1'b0),
				.T3             (1'b0),
				.T4             (1'b0),
				.SHIFTIN1       (1'b0),
				.SHIFTIN2       (1'b0),
				.SHIFTOUT1      (),
				.SHIFTOUT2      (),
//				.OCE            (locked_in & locked_out),
				.OCE            (1'b1),
				.CLK            (clk_625M_out),
				.CLKDIV         (clk_125M_out),
				.OQ             (ext_data_out[gi]),
				.TQ             (),
				.OFB            (),
				.TFB            (),
				.TBYTEIN        (1'b0),
				.TBYTEOUT       (),
				.TCE            (1'b0),
//				.RST            (~(locked_in & locked_out))
				.RST            (rst_osd)
			);
			
			
		end
	endgenerate

	// logic below fills two cells in RX fifo to prevent that fifo from going empty because of close clock edges
	reg empty_r, empty_rr;
	wire empty;
	always @(posedge s_aclk)
	begin
		empty_rr = empty_r;
		empty_r = empty;
	end


	// clock domain crossing fifo for rx data
	ctoc_ififo ctoc_ififo_
	(
		.rst    (psdone), // input rst
//		.rst    (~phase_done),
		.wr_clk (clk_125M_in), // input wr_clk
		.din    (data_in[68:0]), // input [68 : 0] din
		.wr_en  (1'b1),
		
		.rd_clk (s_aclk), // input rd_clk
		.rd_en  (!empty_rr), // input rd_en
		.dout   (data_in_cd), // output [68 : 0] dout
		.full   (), // output full
		.empty  (empty), // output empty
		.valid  (data_in_valid) // output valid
	);


endmodule
