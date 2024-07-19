`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:32:57 01/29/2015 
// Design Name: 
// Module Name:    mtf7_ptlut 
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



module mtf7_ptlut #
(
    parameter AW = 13, // address width port A
    parameter DW = 64, // data width port A
	
	parameter BA = 32'h0 // base address
)
(
    axi_in.slave  s_axi,
    axi_out.slave s_axo,

	// rldram interface
	inout	[71:0]	dq,
	output reg	[3:0]	ba,
	output reg	[19:0]	a,
	output 	[7:0]	dk_p_,
	output	[7:0]	dk_n_,
	output reg	[31:0]	cs,
	output reg	[3:0]	pt_ref,
	output reg	[3:0]	we,

	// clock chip inteface
	output leu, 
	output clku,
	inout datau,
	output goe, 
	input ld, 
	output sync,
	input en,
	input [31:0] clk_word,

	input clk200,
	input clk400,
	
	input mrs_command,
	input wr_command,
	input rd_command,
	output reg busy,
	
	input io_reset,

	input in_delay_ce,
	input in_delay_inc_dec,
	input in_delay_reset,
	input in_delay_clk,

	output [7:0] delayctrl_locked,
	
	input [8*9*5-1:0] in_delay_tap,
	input [8*9*5-1:0] out_delay_tap,
	output [8*9*5-1:0] in_delay_tap_rb,
	output [8*9*5-1:0] out_delay_tap_rb,
	input [4:0] ddr_clk_del,
	input [63:0] ptlut_config,
	
	inout clk_del,
	
	// core interface
	input [29:0] core_addr [2:0], // memory addresses formed by core
	input [2:0] core_val, // valid flags
	input [31:0] core_cs [2:0], // pre-decoded chip selects
	(* async_reg = "TRUE" *) output reg [8:0] core_pt [2:0], // pt value from memory
	input clk40, // core clock 
	input lhc_clk_good
);

	
	assign goe = 1'b1; // enable clock chip outputs
	assign sync = 1'b1; // remove sync
	
	wire [11:0] wr_term_count, rd_term_count;
	wire [5:0] wr_latency, rd_latency;
	wire [4:0] qr_sel, qw_sel, we_sel;
	wire wr_shift, rd_shift;
	wire refresh_en;
	wire wr_bswap;
	wire [2:0] wait_after_refresh;
	wire [2:0] wait_after_read;
	wire [2:0] core_req_mask;
	assign 
	{
	    core_req_mask,
	    wait_after_refresh,
	    wait_after_read,
		wr_bswap,
		refresh_en,
		qr_sel, 
		qw_sel, 
		we_sel,
		rd_shift, 
		wr_shift, 
		rd_latency, 
		wr_latency, 
		rd_term_count, 
		wr_term_count
	} = ptlut_config;
	
	clock_control cc
	( 
		.CLK (clk200), 
		.CLKuWire (clku), 
		.DATAuWire (datau), 
		.LEuWire (leu), 
		.ld (ld),
		.en (en), 
		.done (),
		.clk_word (clk_word)
	);	


    assign s_axo.bid = 6'h0;
    assign s_axo.rid = 6'h0;
    


     reg [AW-1:0] addr_cnt; 
     reg [7:0] xfer_cnt;
    
    localparam IDLE = 2'h0;
    localparam WRITE = 2'h1;
    localparam READ = 2'h2;
    reg [1:0] state = IDLE;
    
    reg wlast_r;
	
	reg rvalid_e, rlast_e;
	wire [31:0] base_addr = BA;
	reg ba_we, ba_re, ba_re_e;
	wire [DW-1:0] rdata [1:0];
	reg ra_msb;
    (* async_reg = "TRUE" *) reg [8:0] core_pt_r [2:0];

    always @(posedge s_axi.s_aclk)
    begin
        if (!s_axi.s_aresetn)
        begin
            state = IDLE;
        end
        else
        begin
    
			// need to delay rvalid and rlast to compensate for BRAM latency
			s_axo.rvalid = rvalid_e;
			s_axo.rlast = rlast_e;
			ba_re = ba_re_e;
			ra_msb = addr_cnt[10];
	
            case (state)
                IDLE:
                begin
                    s_axo.awready = 1'b1; // ready for write address
                    s_axo.arready = 1'b1; // ready for read address
                    s_axo.wready = 1'b0; // not ready for data
                    rvalid_e = 1'b0; // no read data
                    s_axo.bvalid = 1'b0; // confirmation
                    rlast_e = 1'b0;
					ba_we = 1'b0;
					ba_re_e = 1'b0;
					s_axo.bresp = 2'h0;
					s_axo.rresp = 2'h0;

                    if (s_axi.awvalid)
                    begin
                        // valid write address arrived
						
						// check for base address match
						if (s_axi.awaddr[31:AW] == base_addr[31:AW])
							ba_we = 1'b1;
						else
							s_axo.bresp = 2'b10; // slave error
							
						addr_cnt = s_axi.awaddr[AW-1:0]; // put address into counter
						s_axo.awready = 1'b0; // not ready for write address
						s_axo.arready = 1'b0; // not ready for read address
						s_axo.wready = 1'b1; // ready for data
						state = WRITE;
                    end
                    if (s_axi.arvalid)
                    begin
                        // valid read address
						if (s_axi.araddr[31:AW] == base_addr[31:AW]) // base address match
							ba_re_e = 1'b1;
						else
							s_axo.rresp = 2'b10; // slave error

						addr_cnt = s_axi.araddr[AW-1:0] - 1; // put address into counter
						xfer_cnt = s_axi.arlen; // transfer length into counter
						state = READ;
                    end
                end
                
                WRITE:
                begin
                    s_axo.awready = 1'b0; // not ready for write address
                    s_axo.arready = 1'b0; // not ready for read address
                    s_axo.wready = 1'b1; // ready for data
                    if (s_axi.wvalid)
                    begin 
                        addr_cnt = addr_cnt + 1; // increment address on each valid flag
                    end
                    if (s_axi.wlast && !wlast_r)
                    begin 
                        state = IDLE; // last word, get out
                        s_axo.bvalid = 1'b1; // confirmation
                    end       
                end
                
                READ:
                begin
                    s_axo.awready = 1'b0; // not ready for write address
                    s_axo.arready = 1'b0; // not ready for read address
                    rvalid_e = 1'b1; // data valid
                    if (xfer_cnt == 8'h0) // last transfer
                        rlast_e = 1'b1;
                    else 
                        rlast_e = 1'b0;
                    if (s_axi.rready) // master accepted data beat
                    begin
                        addr_cnt = addr_cnt + 1; // increment address
                        if (rlast_e) state = IDLE; // return to idle when last beat and it's accepted
                        xfer_cnt = xfer_cnt - 8'h1; // decrement transfer counter
                    end            
                end
            endcase
    
            wlast_r = s_axi.wlast;
        end
    end

    wire we_axi = (s_axo.wready && s_axi.wvalid && ba_we); // write only if base address matches
	assign s_axo.rdata = (ba_re) ? rdata[ra_msb] : 64'h0; // output data only if base address matches

	reg [11:0] am_addr; 
	reg [9:0] dm_addr;
	wire [31:0] am_dout;
	wire [35:0] dm_dout;
	wire [31:0] am_cs_dout;
	reg [35:0] dm_din;
	reg [35:0] core_din;
	reg dm_we; 
	wire dm_we_r;
	// unused bits in rdata[0]
	assign rdata[0][31:18] = 14'h0;
	assign rdata[0][63:50] = 14'h0;
	
	wire clk200_iddr = clk200;
	
	reg [29:0] core_rd_addr;

	ptlut_data_mem pt_data_mem
    (
        .clka(s_axi.s_aclk),    // input wire clka
        .wea(we_axi & (!addr_cnt[10])),      // input wire [0 : 0] wea
        .addra(addr_cnt[9:0]),  // input wire [9 : 0] addra
        .dina({s_axi.wdata[49:32], s_axi.wdata[17:0]}),    // input wire [35 : 0] dina
        .douta({rdata[0][49:32], rdata[0][17:0]}),  // output wire [35 : 0] douta
        
        .clkb(clk200),    // input wire clkb
        .web(dm_we_r),      // input wire [0 : 0] web
        .addrb(dm_addr),  // input wire [9 : 0] addrb
		.dinb(dm_din),  // [35:0]
        .doutb(dm_dout)  // output wire [35 : 0] doutb
    );

	ptlut_mem pt_addr_mem
    (
        .clka(s_axi.s_aclk),    // input wire clka
        .wea(we_axi & addr_cnt[10]),      // input wire [0 : 0] wea
        .addra(addr_cnt[9:0]),  // input wire [9 : 0] addra
        .dina(s_axi.wdata),    // input wire [63 : 0] dina
        .douta(rdata[1]),  // output wire [63 : 0] douta
        
        .clkb(clk200),    // input wire clkb
        .web(1'b0),      // input wire [0 : 0] web
        .addrb(am_addr),  // input wire [10 : 0] addrb
		.dinb(32'h0),  // [31:0]
        .doutb(am_dout)  // output wire [31 : 0] doutb
    );

    
    reg [31:0] pre_dec_cs [1:0];
    reg pt_cs_wea;
    reg [9:0] pt_cs_addra;
    
    always @(posedge s_axi.s_aclk)
    begin
        // pre-decode cs here
        pre_dec_cs[0] = 32'hffffffff;
        pre_dec_cs[1] = 32'hffffffff;
        pre_dec_cs[0][{s_axi.wdata[28:25], s_axi.wdata[29]}] = 1'b0;
        pre_dec_cs[1][{s_axi.wdata[60:57], s_axi.wdata[61]}] = 1'b0;
        
        // delay the rest of pt_cs_mem port A inputs to match data input
        pt_cs_wea = we_axi & addr_cnt[10];
        pt_cs_addra = addr_cnt[9:0];
    end
    // separate memory for pre-decoded cs storage, not enough time to decode cs on the fly
	ptlut_mem pt_cs_mem 
    (
        .clka(s_axi.s_aclk),    // input wire clka
        .wea(pt_cs_wea),      // input wire [0 : 0] wea
        .addra(pt_cs_addra),  // input wire [9 : 0] addra
        .dina({pre_dec_cs[1], pre_dec_cs[0]}),    // input wire [63 : 0] dina
        .douta(),  // output wire [63 : 0] douta
        
        .clkb(clk200),    // input wire clkb
        .web(1'b0),      // input wire [0 : 0] web
        .addrb(am_addr),  // input wire [10 : 0] addrb
		.dinb(32'h0),  // [31:0]
        .doutb(am_cs_dout)  // output wire [31 : 0] doutb
    );

	wire [35:0] dq_in [3:0];
	wire  [35:0] dq_in_r [3:0];
	reg  [35:0] dq_out [3:0];
	reg  [3:0] dq_tri, dq_tri_r;
	wire clk_del_oddr, clk_in_from_pin, clk_in_int, clk_in_int_delay;
	
	// clk200 is forwarded to a dummy pin clk_del, then looped back to dq_ddr so we can adjust clock delay
	IOBUF #(.IOSTANDARD ("LVCMOS12")) iobuf_clk_del (.IO(clk_del), .I(clk_del_oddr), .O(clk_in_from_pin), .T(1'b0));
	ODDR oddr_clk_del (.Q(clk_del_oddr), .C(clk200), .CE(1'b1), .D1(1'b1), .D2(1'b0), .S(1'b0), .R(1'b0));

	
	genvar gi;
	generate
		// clock forwarding for dk pins
		for (gi = 0; gi < 8; gi = gi+1)
		begin: oddr_loop
			ODDR oddr_dk_p (.Q(dk_p_[gi]), .C(clk200), .CE(1'b1), .D1(1'b1), .D2(1'b0), .S(1'b0), .R(1'b0));
			ODDR oddr_dk_n (.Q(dk_n_[gi]), .C(clk200), .CE(1'b1), .D1(1'b0), .D2(1'b1), .S(1'b0), .R(1'b0));
		end

		// ODDR and IDDR for dq pins
		for (gi = 0; gi < 8; gi = gi+1)
		begin: dq_loop

			dq_ddr_iodel
			// width of the data for the system
			#(.sys_w(9), .dev_w(18))
			dqddr
			(
				.DATA_TO_AND_FROM_PINS (dq[gi*9 +: 9]),
				.DATA_IN_TO_DEVICE (dq_in[gi/2][(gi%2)*18 +: 18]),
				// From the device out to the system
				.DATA_OUT_FROM_DEVICE (dq_out[gi/2][(gi%2)*18 +: 18]),
				.DELAY_CLK (in_delay_clk),
				.IN_DELAY_RESET (in_delay_reset),                        // Active high synchronous reset for input delay
				.IN_DELAY_DATA_CE ({9{in_delay_ce}}),                      // Enable signal for delay
				.IN_DELAY_DATA_INC (9'b0),                     // Delay increment (high), decrement (low) signal
				.OUT_DELAY_RESET (in_delay_reset),                       // Active high synchronous reset for output delay
				.OUT_DELAY_DATA_CE ({9{in_delay_ce}}),                     // Enable signal for delay
				.OUT_DELAY_DATA_INC (9'b0),                    // Delay increment (high), decrement (low) signal
				.IN_DELAY_TAP_IN (in_delay_tap[gi*5*9 +: 5*9]),      // Dynamically loadable delay tap value for input delay
				.IN_DELAY_TAP_OUT (in_delay_tap_rb[gi*5*9 +: 5*9]),     // Delay tap value for monitoring input delay
				.OUT_DELAY_TAP_IN (out_delay_tap[gi*5*9 +: 5*9]),     // Dynamically loadable delay tap value for output delay
				.OUT_DELAY_TAP_OUT (out_delay_tap_rb[gi*5*9 +: 5*9]),    // Delay tap value for monitoring output delay
				.REF_CLOCK (clk200),      // Reference clock for IDELAYCTRL. Has to come from BUFG.
				.TRISTATE_OUTPUT (dq_tri_r[gi/2]),
				.CLK_IN (clk_in_int),        // Single ended clock from IOB
				.clk200 (clk200),
				.CLK_OUT (),
				.IO_RESET (io_reset)
			);
			
		end
	endgenerate
	
	reg in_fifo_re;
	wire in_fifo_empty;
	reg in_fifo_empty_r, in_fifo_empty_rr;
	// clock domain crossing fifo for input data

	rldram_in_fifo rif 
	(
		.rst(io_reset), // input rst
		.wr_clk(clk_in_int), // input wr_clk
//		.rd_clk(clk200), // input rd_clk
		.rd_clk(clk400),
		.din({dq_in[3], dq_in[2], dq_in[1], dq_in[0]}), // input [143 : 0] din
		.wr_en(1'b1), // input wr_en
//		.rd_en(!in_fifo_empty_rr), // input rd_en
		.rd_en(1'b1),
		.dout({dq_in_r[3], dq_in_r[2], dq_in_r[1], dq_in_r[0]}), // output [143 : 0] dout
		.full(), // output full
		.empty(in_fifo_empty) // output empty
	);


  // delay the input clock
//	(* IODELAY_GROUP = "dq_ddr_iodel_group" *)
	IDELAYE2
	# (
		.CINVCTRL_SEL           ("FALSE"),            // TRUE, FALSE
		.DELAY_SRC              ("IDATAIN"),        // IDATAIN, DATAIN
		.HIGH_PERFORMANCE_MODE  ("FALSE"),             // TRUE, FALSE
		.IDELAY_TYPE            ("VAR_LOAD"),          // FIXED, VARIABLE, or VAR_LOADABLE
		.IDELAY_VALUE           (0),                // 0 to 31
		.REFCLK_FREQUENCY       (200.0),
		.PIPE_SEL               ("FALSE"),
		.SIGNAL_PATTERN         ("CLOCK"))           // CLOCK, DATA
	idelaye2_clk
	(
		.DATAOUT                (clk_in_int_delay),  // Delayed clock
		.DATAIN                 (1'b0),              // Data from FPGA logic
		.C                      (in_delay_clk),
		.CE                     (in_delay_ce),
		.INC                    (1'b0),
		.IDATAIN                (clk_in_from_pin),
		.LD                     (in_delay_reset),
		.LDPIPEEN               (1'b0),
		.REGRST                 (1'b0),
		.CNTVALUEIN             (ddr_clk_del),
		.CNTVALUEOUT            (),
		.CINVCTRL               (1'b0)
	);
		
	BUFG bufg_clk_inst
     (.I          (clk_in_int_delay),
      .O          (clk_in_int));		


	localparam PT_IDLE = 4'h0;
	localparam PT_MRS = 4'h1;
	localparam PT_RD_WR_PREP  = 4'h2;
	localparam PT_RD_WR  = 4'h3;
	localparam PT_CORE_RD_1 = 4'h4;
	localparam PT_CORE_RD_2 = 4'h5;
	localparam PT_CORE_RD_3 = 4'h6;
	
	reg [3:0] st = PT_IDLE;
	reg mrs_command_r, mrs_command_rr, mrs_command_rrr;
	reg wr_command_r, wr_command_rr, wr_command_rrr;
	reg rd_command_r, rd_command_rr, rd_command_rrr;
	reg [1:0] quad; 
	wire [1:0] quad_r, quad_wr;

	wire clk200_w = clk200;
	wire clk40_w = clk40;
	

	wire [31:0] cs_w = cs;
	wire [3:0] we_w = we;
	wire [3:0] ref_w = pt_ref;
	wire [3:0] ba_w = ba;
	wire [19:0] a_w = a;
	wire mrs_command_w = mrs_command_r;
	wire wr_command_w = wr_command_r;
	wire [1:0] quad_w = quad;
	wire [1:0] quad_r_w = quad_r;
	wire [11:0] am_addr_w = am_addr; 
	wire [9:0] dm_addr_w  = dm_addr;
	wire [35:0] dm_din_w = dm_din;
	wire [35:0] dm_dout_w = dm_dout;
	wire dm_we_r_w = dm_we_r;

	wire [35:0] dq_in_0_w = dq_in_r[0];
	wire [35:0] dq_out_0_w = dq_out[0];
	wire [35:0] dq_in_1_w = dq_in_r[1];
	wire [35:0] dq_out_1_w = dq_out[1];
	wire [35:0] dq_in_2_w = dq_in_r[2];
	wire [35:0] dq_out_2_w = dq_out[2];
	wire [35:0] dq_in_3_w = dq_in_r[3];
	wire [35:0] dq_out_3_w = dq_out[3];
	
	reg rd_op;
	reg mem_lat_cnt;
	
	reg [6:0] refresh_cnt = 7'h0;
	reg [3:0] refresh_bank = 4'h0;
	reg mrs_req, wr_req, rd_req;
	reg [2:0] refresh_tm;
	reg [35:0] dm_dout_d;
	reg [17:0] dq_in_msb_d [3:0];
	reg [2:0] core_req; // request to read from core
	reg [2:0] core_val_r;
	reg [29:0] core_addr_r [2:0]; // core addresses locked
	reg [31:0] core_cs_r [2:0]; // pre-decoded chip selects locked
	reg [2:0] pt_valid;
	wire [2:0] pt_valid_r;
	wire [1:0] core_rd_alsb; // two delayed lower bits of read address, needed to decide which byte to take
    integer i;
    reg [2:0] rl_counter; 
    reg [3:0] refresh_req;
   reg [2:0]  core_req_cnt [2:0]; // core request time counters
   reg refresh_exec;
   reg lhc_good_r, lhc_good_rr;
   reg [19:0] clk_to_cnt;
    
	
	always @(posedge clk40)
    begin
		core_pt = core_pt_r; // lock pt outputs to core clock
    end        
	
	// RLDRAM state machine
	always @(posedge clk200)
	begin
	
		in_fifo_empty_rr = in_fifo_empty_r;
		in_fifo_empty_r = in_fifo_empty;
	
		dq_tri_r = dq_tri;

		case (st)
			PT_IDLE:
			begin
				cs = 32'hffffffff;
				we = 4'hf;
				pt_ref = 4'hf;
				ba = 4'h0;
				a = 20'h0;
				dq_tri = 4'hf; // tristate data bus
				dm_we = 1'b0;
				am_addr = 12'h0;
				dm_addr = 12'h0;
				mem_lat_cnt = 1'h1;
				busy = 1'b0;
				pt_valid = 3'h0;
				if (mrs_req) st = PT_MRS; // request to write configuration registers
				if (wr_req) // request to write data from PCIe
				begin
					dm_addr = 10'h0 - {4'h0, wr_latency}; // write latency
					rd_op = 1'b0;
					busy = 1'b1;
					st = PT_RD_WR_PREP;
				end
				else
				if (rd_req) // request to read data from PCIe
				begin
					dm_addr = 10'h0 - {4'h0, rd_latency}; // read latency
					rd_op = 1'b1;
					busy = 1'b1;
					st = PT_RD_WR_PREP;
				end
				else
                // core read request
                // ignore if rl_counter did not expire - this is temporary
                if (core_req != 3'h0 && rl_counter >= wait_after_refresh) // core read request
                begin
                    busy = 1'b1;
                    st = PT_CORE_RD_1;
                end 
				else
				// refresh request
				
				if (refresh_exec == 1'b1) // convert refresh request into single bit flag to improve timing trom refresh_req to cs
				begin
                    
                    // issue refresh right here, no separate state
					ba = refresh_bank;
					`inc(refresh_bank);
					// refresh command selection for all chips
					we = 4'hf;
					pt_ref = 4'h0;
					cs = 32'h0; // all chips
					refresh_req = refresh_req - 4'h1;
					rl_counter = 3'h0; 
				end
				
				// ignore refresh request if rl_counter did not expire or if LHC clock just changed status
				if (refresh_req > 4'h0 && refresh_en && rl_counter >= wait_after_read && clk_to_cnt == 20'h0) 
				    refresh_exec = 1'b1;
				else
				    refresh_exec = 1'b0;
			end
			
			
			PT_MRS:
			begin
				// set address bus and command code up front
//				{ba, a[17:0]} = am_dout[21:0]; // MRS command at location 0 in addr_mem
				a = {2'h0, am_dout[17:0]};
				ba = am_dout[21:18];
				// MRS command selection for all chips
				we = 4'h0;
				pt_ref = 4'h0;
				cs = ~dm_dout[31:0]; // cs mask in location 0 in data_mem, 1=chip selected
				mrs_req = 1'b0;
				st = PT_IDLE;
			end
			
			PT_RD_WR_PREP: // this state compensates for pt_data_mem and pt_addr_mem latency
			begin
				`inc(am_addr);
				`inc(dm_addr);
				if (mem_lat_cnt == 1'h0) st = PT_RD_WR;
				mem_lat_cnt = 1'b0;
			end
			
			PT_RD_WR:
			begin
				
				cs = 32'hffffffff;
				dm_we = 1'b0;
				// set cs only for the length of the buffer + buffer memory latency (2 clk)
				if (am_addr <= 12'h401)	
				begin
//					cs[{am_dout[28:25], am_dout[29]}] = 1'b0; // one chip only
                    cs = am_cs_dout; // use pre-decoded cs 
					if (rd_op) dm_we = 1'b1; // set WE for buffer memory
				end
					
				quad = am_dout[28:27];
				// set address bus and command code
				{a, ba} = am_dout[24:1]; // set address
				we = 4'hf;
				pt_ref = 4'hf;
				if (wr_shift) // shift the bytes by one
				begin
					// this means swapping them and delaying MS bytes by 1 clock
//					dq_out[quad_wr] = {dm_dout[18+:9], dm_dout_d[27+:9], dm_dout[0+:9], dm_dout_d[9+:9]}; // drive data to selected quad
					dq_out[0] = {dm_dout[18+:9], dm_dout_d[27+:9], dm_dout[0+:9], dm_dout_d[9+:9]}; // drive data to selected quad
					dq_out[1] = {dm_dout[18+:9], dm_dout_d[27+:9], dm_dout[0+:9], dm_dout_d[9+:9]}; // drive data to selected quad
					dq_out[2] = {dm_dout[18+:9], dm_dout_d[27+:9], dm_dout[0+:9], dm_dout_d[9+:9]}; // drive data to selected quad
					dq_out[3] = {dm_dout[18+:9], dm_dout_d[27+:9], dm_dout[0+:9], dm_dout_d[9+:9]}; // drive data to selected quad
				end
				else
				begin
//					dq_out[quad_wr] = dm_dout; // drive data to selected quad
					dq_out[0] = dm_dout; // drive data to selected quad
					dq_out[1] = dm_dout; // drive data to selected quad
					dq_out[2] = dm_dout; // drive data to selected quad
					dq_out[3] = dm_dout; // drive data to selected quad
				end
				if (!rd_op) 
				begin
					we[quad] = 1'b0; // set we for RLDRAM
					dq_tri = 4'h0; // drive data bus
				end

//				if (rd_shift)
//				begin
//					dm_din = {dq_in_r[quad_r][17:0], dq_in_msb_d[quad_r]}; // data from selected quad to buffer memory
//				end
//				else
//				begin
					dm_din = dq_in_r[quad_r]; // data from selected quad to buffer memory
//				end

				if (am_addr == wr_term_count && !rd_op) // terminal count = buffer size + write latency
				begin
					wr_req = 1'b0;
					st = IDLE;
				end
				if (am_addr == rd_term_count && rd_op) // terminal count = buffer size + read latency
				begin
					rd_req = 1'b0;
					st = IDLE;
				end
				`inc(am_addr);
				`inc(dm_addr);
			end

			PT_CORE_RD_1: // reading best track here
			begin
				
				cs = 32'hffffffff;
				dm_we = 1'b0;
				pt_valid = 3'h0;
				
				// analyze core read requests
				if (core_req[0])
				begin
				    core_rd_addr = core_addr_r[0]; // take requested address
				    cs = core_cs_r[0]; // and cs
				    core_req[0] = 1'b0; // remove request
    				pt_valid = 3'h1;
				end
				quad = core_rd_addr[29:28]; // select quad
				{a, ba} = core_rd_addr[25:2]; // set address
                rl_counter = 3'h0; 
                refresh_exec = 1'b0;
    		    if (core_req[1] || core_req[2]) st = PT_CORE_RD_2; // if more requests keep reading
                else st = IDLE; // no more requests
			end

			PT_CORE_RD_2: // reading worst track here. It can be killed by RLDRAM banking rules, making this slot free
			begin
				
				cs = 32'hffffffff;
				dm_we = 1'b0;
				pt_valid = 3'h0;
				
				// analyze core read requests
				if (core_req[2])
                begin
                    core_rd_addr = core_addr_r[2]; // take requested address
				    cs = core_cs_r[2]; // and cs
                    core_req[2] = 1'b0; // remove request
    				pt_valid = 3'h4;
                end

				quad = core_rd_addr[29:28]; // select quad
				{a, ba} = core_rd_addr[25:2]; // set address
                rl_counter = 3'h0; 
                refresh_exec = 1'b0;
			    if (core_req[1]) st = PT_CORE_RD_3; // if more requests keep reading
                else st = IDLE; // no more requests
			end

			PT_CORE_RD_3: // reading second best 
			begin
				
				cs = 32'hffffffff;
				dm_we = 1'b0;
				pt_valid = 3'h0;
				
				// analyze core read requests
				if (core_req[1])
                begin
                    core_rd_addr = core_addr_r[1]; // take requested address
                    cs = core_cs_r[1]; // and cs
                    pt_valid = 3'h2;
                    core_req[1] = 1'b0; // remove request
                end

				quad = core_rd_addr[29:28]; // select quad
				{a, ba} = core_rd_addr[25:2]; // set address
                rl_counter = 3'h0; 
                refresh_exec = 1'b0;
                st = IDLE; // no more requests
			end
		endcase

		case (pt_valid_r) // valid data coming out of memory now
		  // put requested byte into the appropriate output
		  3'h1: begin core_pt_r[0] = core_din[core_rd_alsb*9 +: 9]; end
		  3'h2: begin core_pt_r[1] = core_din[core_rd_alsb*9 +: 9]; end
		  3'h4: begin core_pt_r[2] = core_din[core_rd_alsb*9 +: 9]; end
		endcase
			
//        if (rd_shift)
//        begin
//            core_din = {dq_in_r[quad_r][17:0], dq_in_msb_d[quad_r]}; // data from selected quad have arrived
//        end
//        else
//        begin
            core_din = dq_in_r[quad_r]; // data from selected quad have arrived
//        end
			
		dm_dout_d = dm_dout;
		dq_in_msb_d[0] = dq_in_r[0][35:18];
		dq_in_msb_d[1] = dq_in_r[1][35:18];
		dq_in_msb_d[2] = dq_in_r[2][35:18];
		dq_in_msb_d[3] = dq_in_r[3][35:18];

        // process commands, set corresponding requests for state machine
		if (!mrs_command_rrr && mrs_command_rr) mrs_req = 1'b1;
		if (!wr_command_rrr && wr_command_rr) wr_req = 1'b1;
		if (!rd_command_rrr && rd_command_rr) rd_req = 1'b1;
		
`define REFRESH_PERIOD 7'd97 // this is by datasheet		
		
		// refresh request is set periodically
		if (refresh_cnt == `REFRESH_PERIOD && refresh_req < 4'hf)
		begin
		   refresh_req = refresh_req + 1'b1;
		   refresh_cnt = 0;
		end
	    else
		  `inc(refresh_cnt);

		mrs_command_rrr = mrs_command_rr;
		mrs_command_rr = mrs_command_r;
		mrs_command_r = mrs_command;
		
		wr_command_rrr = wr_command_rr;
		wr_command_rr = wr_command_r;
		wr_command_r = wr_command;
		
		rd_command_rrr = rd_command_rr;
		rd_command_rr = rd_command_r;
		rd_command_r = rd_command;

        for (i = 0; i < 3; i = i+1) // best track loop
        begin
            if (core_val[i] && core_req_cnt[i] == 3'h0) // valid flag for this track is set and core request can be set again
            begin
                core_req[i] = 1'b1; // set request
                core_addr_r[i] = core_addr[i]; // latch address
                core_cs_r[i] = core_cs[i]; // and cs
			    core_req_cnt[i] = 3'h4; // set time counter for this track. core_req for each track cannot be set more than once every 5 clocks
			   
            end
		    else
			begin
		       // process core request counters
 		       if (core_req_cnt[i] != 3'h0) core_req_cnt[i] = core_req_cnt[i] - 1'h1;
			end
        end
	    
	   
        core_req = core_req & core_req_mask; // disable some of the requests, needed for debugging
    
        core_val_r = core_val;
        if (rl_counter < 3'h7) rl_counter = rl_counter + 3'h1;
        
        if (!lhc_good_r && lhc_good_rr) // LHC clock just disappeared
        begin
            clk_to_cnt = 20'd1000000; // 5 ms
        end
        else
        if (lhc_good_r && !lhc_good_rr) // LHC clock just appeared
        begin
            clk_to_cnt = 20'd1000000; // 5 ms
        end
        else
        begin
            if (clk_to_cnt > 20'd0) clk_to_cnt--;
        end
        
       lhc_good_rr = lhc_good_r;
	   lhc_good_r = lhc_clk_good;	
	end
	
	
	dyn_shift #(.BW(2)) quad_rdl (.CLK(clk200), .CE(1'b1), .SEL(qr_sel), .SI(quad ), .DO(quad_r ));
	dyn_shift #(.BW(2)) quad_wdl (.CLK(clk200), .CE(1'b1), .SEL(qw_sel), .SI(quad ), .DO(quad_wr));
	dyn_shift #(.BW(1)) dmwe_dl  (.CLK(clk200), .CE(1'b1), .SEL(we_sel), .SI(dm_we), .DO(dm_we_r));
	dyn_shift #(.BW(3)) ptvl_dl  (.CLK(clk200), .CE(1'b1), .SEL(qr_sel+5'h1), .SI(pt_valid), .DO(pt_valid_r));
	dyn_shift #(.BW(2)) alsb_dl  (.CLK(clk200), .CE(1'b1), .SEL(qr_sel+5'h1), .SI(core_rd_addr[1:0]), .DO(core_rd_alsb));

// IDELAYCTRL is needed for calibration
//    (* IODELAY_GROUP = "dq_ddr_iodel_group" *)
    generate
        for (gi = 0; gi < 6; gi = gi+1)
        begin: idelayctrl_loop
            IDELAYCTRL delayctrl 
            (
                .RDY    (delayctrl_locked[gi]),
                .REFCLK (clk200),
                .RST    (io_reset)
            );
        end
    endgenerate

    (* mark_debug = "FALSE" *) wire [29:0] core_addr_w [2:0];
    assign core_addr_w[0] = core_addr[0];
    assign core_addr_w[1] = core_addr[1];
    assign core_addr_w[2] = core_addr[2];
    (* mark_debug = "FALSE" *) wire [31:0] core_cs_w [2:0];
    assign core_cs_w[0] = core_cs[0];
    assign core_cs_w[1] = core_cs[1];
    assign core_cs_w[2] = core_cs[2];
    (* mark_debug = "FALSE" *) wire [29:0] core_addr_rw [2:0];
    assign core_addr_rw[0] = core_addr_r[0];
    assign core_addr_rw[1] = core_addr_r[1];
    assign core_addr_rw[2] = core_addr_r[2];
    (* mark_debug = "FALSE" *) wire [31:0] core_cs_rw [2:0];
    assign core_cs_rw[0] = core_cs_r[0];
    assign core_cs_rw[1] = core_cs_r[1];
    assign core_cs_rw[2] = core_cs_r[2];
    (* mark_debug = "FALSE" *) wire [2:0] core_val_w = core_val;
    (* mark_debug = "FALSE" *) wire [2:0] pt_valid_w = pt_valid;
    (* mark_debug = "FALSE" *) wire [2:0] pt_valid_rw = pt_valid_r;
    (* mark_debug = "FALSE" *) wire [35:0] core_din_w = core_din;
    (* mark_debug = "FALSE" *) wire [8:0] core_pt_w [2:0];
    assign core_pt_w[0] = core_pt[0]; 
    assign core_pt_w[1] = core_pt[1]; 
    assign core_pt_w[2] = core_pt[2];
    (* mark_debug = "FALSE" *) wire [2:0] core_req_w = core_req; 
    (* mark_debug = "FALSE" *) wire [3:0] st_w = st;
    (* mark_debug = "FALSE" *) wire [1:0] core_rd_alsb_w = core_rd_alsb;
    (* mark_debug = "FALSE" *) wire [8:0] core_pt_rw [2:0];
    assign core_pt_rw[0] = core_pt_r[0]; 
    assign core_pt_rw[1] = core_pt_r[1]; 
    assign core_pt_rw[2] = core_pt_r[2];
    (* mark_debug = "FALSE" *) wire [3:0] refresh_req_w = refresh_req;
    (* mark_debug = "FALSE" *) wire [3:0] refresh_bank_w = refresh_bank; 

endmodule
