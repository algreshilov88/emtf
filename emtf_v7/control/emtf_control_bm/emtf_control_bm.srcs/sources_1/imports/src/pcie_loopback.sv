`timescale 1ns / 1ps

// loopback control module. It decodes commands coming from PCIe, and
// reads/writes registers as directed. Also can pulse beam outputs
// to initiate certain actions (like beaming)
// Includes loopback memory for tests

module pcie_loopback #
	(
	// Base address registers, should be set from above, matching PCIe core
	 parameter BAR0 = 32'hffffff00, // memory access 
	 parameter BAR1 = 32'hffffff00, // register access
	 parameter REG_OFF = 32'h0, // initial register offset
	 parameter MEM_OFF = 32'h0 // initial memory offset
	 )
	(
	 input 			   clk,
	 input 			   rst_n,

	 // read port (only for BAR1)
	 input [31:0] 	   rd_addr_i,
	 output reg [63:0] rd_data_o,
	 input 			   rd_en_i,

	 // write port
	 input 			   bar_hit, // shows which BAR is hit
	 input [31:0] 	   wr_addr_i,
	 input 			   wr_addr_valid,
	 input [63:0] 	   wr_data_i,
	 input 			   wr_en_i,
	 
	 // command outputs
	 output reg beam,

	 // beaming interface
	 output reg [31:0] beam_addr_o, // memory address to beam to
	 output [63:0] 	   beam_data_o, // data
	 output reg [31:0] beam_cnt_o, // beam word count
	 input 			   beaming_in_progress,
	 output reg beam_prep,
	 output busy,
	 
	 input [31:0] lhc_cnt,
	 input [31:0] pll_cnt,
	 input [11:0] bc0_period,
	 input [19:0] resync_cnt,
	 input [19:0] hr_cnt,
	 output l1a_internal,
	 output [31:0] clk_word,
	 input [2:0] clk_status

	 // register inputs
	 );

	reg [31:0] pll_cnt_lock;
	integer year, month, day;
	wire [31:0] fw_date;

	assign busy = 1'b0;
	// aperture masks
	localparam AP0_MASK = ~(BAR0 & 32'hfffffff0);
	localparam AP1_MASK = ~(BAR1 & 32'hfffffff0);
	
	// register addresses
	localparam BEAM_LENGTH   = REG_OFF + 32'h0; // beaming length, bytes
	localparam BEAM_FROM     = REG_OFF + 32'h4; // address to beam from, bytes
	localparam BEAM_TO       = REG_OFF + 32'h8; // physical address in host memory. Write into this register starts beaming

	localparam TEST_REG1     = REG_OFF + 32'hc; // test register
	localparam TEST_REG2     = REG_OFF + 32'h10; // test register
	
	localparam LHC_CNT_REG = REG_OFF + 32'h14; // counter on LHC clock
	localparam PLL_CNT_REG = REG_OFF + 32'h18; // counter on PLL clock
	
	localparam FW_DATE = REG_OFF + 32'h1c; // firmware date code

	// memory aperture, shifted by 3 because loopback memory is 64-bit wide
	localparam LOOP_AP_BEG = ((MEM_OFF + 32'h00000) >> 3);
	localparam LOOP_AP_END = ((MEM_OFF + 32'h3ffff) >> 3);

	// command bit masks
	localparam BEAM_CMD = 32'h1;

	wire [31:0] 	   reg_wr_addr, reg_rd_addr;
	wire [31:0] 	   mem_wr_addr;
	assign reg_wr_addr = wr_addr_i & AP1_MASK; // address of the register user is writing
	assign reg_rd_addr = rd_addr_i & AP1_MASK; // address of the register user is reading
	assign mem_wr_addr = wr_addr_i & AP0_MASK; // memory address the user is writing

	reg [31:0] 		   test_register [1:0];
	wire [63:0] 	   lb_data;
	reg [31:0] 		   lb_addra, lb_addrb;

	// beaming component identifiers
	reg 			   loopback_beam;

	reg 			   bipr;
	reg 			   loop_wr_en;
	reg [63:0] 		   lb_wr_data;
	
	assign l1a_internal = test_register[1][0];
	assign clk_word = test_register[0];
    reg s_lock_r, s_lock_rr;
    reg [15:0] unlock_counter;
    wire s_lock = clk_status[0];
	reg [31:0] beam_addr_save;
	
	always @(posedge clk)
	begin
		if (!rst_n)
		begin
			beam = 1'b0;
			beam_addr_o = 32'h0;
			beam_cnt_o = 32'h0;
			loopback_beam = 1'b0;
			bipr = 1'b0;
			loop_wr_en = 1'b0;
			test_register[0] = 32'hffffffff;
//			unlock_counter = 16'h0;
 		end
		else
		begin
			beam = 1'h0;
			beam_prep = 1'b0;

			if (wr_addr_valid) // wr address received
			begin
				lb_addra = mem_wr_addr[31:3]; // loopback mem is 64-bit wide
			end

			// increment loopback mem wr address if written on previous clock
			if (loop_wr_en) 
				lb_addra = lb_addra + 32'h1;

			loop_wr_en = 1'b0;
			
			if (wr_en_i) // wr data received
			begin
				if (bar_hit == 1'b1) // register write
				begin
					case (reg_wr_addr)
						TEST_REG1:
							begin
								// writing test register
								test_register[0] = wr_data_i[31:0];
							end
						TEST_REG2:
							begin
								// writing test register
								test_register[1] = wr_data_i[31:0];
							end
						BEAM_LENGTH:
							begin
								// writing beam length register
								beam_cnt_o = wr_data_i[31:2]; // count of w32
								beam_prep = 1'b1; // beaming preparation has started
							end
						BEAM_FROM:
							begin
								// writing address to beam from
								lb_addrb = wr_data_i[31:3]; // set loopback memory read address, in w64
							end
						BEAM_TO:
							begin
								// beam command
								beam_addr_o = wr_data_i[31:0]; // set system memory destination address
								beam = 1'b1; // set beam pulse so TX module starts beaming
								loopback_beam = 1'b1; // tell loopback fifo to receive read enables
							end
					endcase
				end // if (wr_en_i && bar_hit == 1'b1)
				else
				begin // memory write
					if (lb_addra >= LOOP_AP_BEG && lb_addra <= LOOP_AP_END)
					begin
						loop_wr_en = 1'b1;
					end
					
				end
			end

			if (bar_hit == 1'b1 && (!beaming_in_progress)) // register read
			begin
				case (reg_rd_addr)
					TEST_REG1:
						begin
							rd_data_o = {hr_cnt[12:0], clk_status, unlock_counter};
//							unlock_counter = 16'h0;
						end
					TEST_REG2:
						begin
							rd_data_o = {resync_cnt, bc0_period};
						end
					LHC_CNT_REG:
						begin
							pll_cnt_lock = pll_cnt; // lock value of pll counter so it matches lhc counter
							rd_data_o = lhc_cnt;
						end
					PLL_CNT_REG:
						begin
							rd_data_o = pll_cnt_lock;
						end
					FW_DATE:
						begin
							rd_data_o = fw_date;
						end
					BEAM_LENGTH:
						begin
							rd_data_o = {beam_cnt_o, 2'b0};
						end
					BEAM_FROM:
						begin
							rd_data_o = {lb_addrb, 3'b0};
						end
					BEAM_TO:
						begin
							rd_data_o = beam_addr_save;
						end
					default: // if no register is hit, need to zero out the bus
						begin
							rd_data_o = 64'h0;
						end
				endcase
			end // if (bar_hit == 1'b1)

			// remove beaming identifiers when TX is done beaming
			if (bipr && !beaming_in_progress)
			begin
				loopback_beam = 1'b0;
				// zero out all outputs
				beam_addr_save = beam_addr_o; // preserve beam addr for reporting to driver later
				beam_addr_o = 32'h0;
				beam_cnt_o = 32'h0;
			end
			
			// process loopback memory read address
			// read enable does not depend on bar_hit or address because it's created by beaming
			if (rd_en_i && loopback_beam)
			begin
				lb_addrb = lb_addrb + 32'h1;
			end
			
			bipr = beaming_in_progress; // history FF

			// delay loopback data to match wr enable
			lb_wr_data = wr_data_i; 
			
		end // else: !if(!rst_n)

        // unlock counter for external pll
		if (s_lock_rr && !s_lock_r && unlock_counter != 16'hffff)
          unlock_counter = unlock_counter + 16'h1;
        
        s_lock_rr = s_lock_r;
        s_lock_r  = s_lock;
		
	end


	assign beam_data_o = (loopback_beam) ? lb_data : 64'h0;

	reg [14:0] adrr;
	// loopback memory
    reg [63:0] lb_mem [8191:0];
	// synthesis attribute ram_style of lb_mem is block
	always @(posedge clk)
	begin
		if (loop_wr_en) lb_mem[lb_addra[14:0]] = lb_wr_data;
		if (rd_en_i) adrr = lb_addrb[14:0];
	end
	
	assign lb_data = lb_mem[adrr];

	USR_ACCESSE2 usr_access
	(
		.DATA ( fw_date ),
		.CFGCLK (),
		.DATAVALID ()
	);

	(* mark_debug = "TRUE" *) wire [14:0] adrr_w = adrr;
	(* mark_debug = "TRUE" *) wire loopback_beam_w = loopback_beam;
	(* mark_debug = "TRUE" *) wire [63:0] beam_data_w = beam_data_o;
	
endmodule
