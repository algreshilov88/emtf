`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2014 11:44:48 AM
// Design Name: 
// Module Name: core_link
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module core_link #
(
	// Base address registers, should be set from above, matching PCIe core
	 parameter BAR0 = 32'hffffff00, // memory access 
	 parameter BAR1 = 32'hffffff00, // register access
	 parameter REG_OFF = 32'h0, // initial register offset
	 parameter MEM_OFF = 32'h0, // initial memory offset
	 parameter MEM_RANGE = 32'h100000 // memory window size, bytes 
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
	 input [9:0]       wr_req_len,
	 
	 // command outputs
	 output reg beam,

	 // beaming interface
	 output reg [31:0] beam_addr_o, // memory address to beam to
	 output [63:0] 	   beam_data_o, // data
	 output [31:0] beam_cnt_o, // beam word count
	 input 			   beaming_in_progress,
	 output busy,
     output reg eng_busy,
     input config_busy, // configuration access happened recently
	 
	 input idelay_ref_clk, // reference clock for IDELAYs inside AXI
	 input phy_clk, // physical interface clock
	 output axi_resetn,
	 output core_phase_inc,

	  input ext_clk_in,
	  input [13:0] ext_data_in,
	  output ext_clk_out,
	  output [13:0] ext_data_out
);

	reg [31:0] beam_cnt; // beam word count
	assign beam_cnt_o = beam_cnt;
	// aperture masks
	localparam AP0_MASK = ~(BAR0 & 32'hfffffff0);
	localparam AP1_MASK = ~(BAR1 & 32'hfffffff0);
	
	// register addresses
	localparam BEAM_LENGTH   = REG_OFF + 32'h0; // beaming length, bytes
	localparam BEAM_FROM     = REG_OFF + 32'h4; // address to beam from, bytes
	localparam BEAM_TO       = REG_OFF + 32'h8; // physical address in host memory.
	localparam BEAM_START    = REG_OFF + 32'hc; // beam start command register
	
	localparam BSTAT         = REG_OFF + 32'h10; // AXI write response, reset control
	localparam RESET_REG     = REG_OFF + 32'h14; // reset register

	// memory aperture, shifted by 3 because loopback memory is 64-bit wide
	localparam LOOP_AP_BEG = ((MEM_OFF) >> 3);
	localparam LOOP_AP_END = ((MEM_OFF + MEM_RANGE-1) >> 3);

	wire [31:0] 	   reg_wr_addr, reg_rd_addr;
	wire [31:0] 	   mem_wr_addr;
	assign reg_wr_addr = wr_addr_i & AP1_MASK; // address of the register user is writing
	assign reg_rd_addr = rd_addr_i & AP1_MASK; // address of the register user is reading
	assign mem_wr_addr = wr_addr_i & AP0_MASK; // memory address the user is writing

	reg [31:0] 		   test_register [1:0];
	wire [63:0] 	   lb_data;
	 reg [31:0] 		   lb_addra;
	 reg [31:0] lb_addrb;

	// beaming component identifiers
	reg 			   loopback_beam;

	reg 			   bipr;
	reg 			   loop_wr_en;
	reg [63:0] 		   lb_wr_data;

	wire [5 : 0] s_axi_bid;
	wire [1 : 0] s_axi_bresp;
	wire [5 : 0] s_axi_rid;
	wire [1 : 0] s_axi_rresp;
	wire s_axi_bvalid;
	wire s_axi_rvalid;
	reg [1:0] s_axi_resp;
	wire wlast = loop_wr_en && (!wr_en_i); // last word flag
    reg arvalid;

    assign axi_resetn = test_register[0][0];
	assign core_phase_inc = test_register[0][1];
	wire   control_phase_inc = test_register[0][2];
    
    wire [31:0] inst_waddr = mem_wr_addr[31:3]; // memory is 64-bit wide
    wire mem_adr_hit = (inst_waddr >= LOOP_AP_BEG && inst_waddr <= LOOP_AP_END && bar_hit == 1'b0) ? 1'b1 : 1'b0;
    wire mem_adr_valid = wr_addr_valid && mem_adr_hit; // address valid and address is in this module

	
	// make instant busy signal. This is needed because when addr and data are available, RX_engine is already in wait state.
     wire inst_busy = mem_adr_valid;
     reg  wr_busy = 1'b0; 
     reg  rd_busy = 1'b0;
    assign busy = inst_busy | wr_busy | rd_busy; // actual busy signal is superposition of instant and delayed 
	 reg awvalid;
     reg axi_start_read;
    reg [28:0] beam_from_addr;

    // AXI states
    localparam AXI_IDLE = 0;
    localparam AXI_READ = 1;
    reg axi_state = AXI_IDLE;
    reg [14:0] buf_mem_addr;
	wire rlast;
    wire wready;
    wire arready, awready;
    wire [31:0] awaddr = lb_addra;
    reg [31:0] araddr;
	wire [7:0] awlen = wr_req_len[8:1]-8'h1; // length field is actual transfer length -1
    wire [7:0] arlen = beam_cnt[8:1]-8'h1; // length field is actual transfer length -1
    reg [19:0] rd_busy_to, wr_busy_to;
    reg rlast_r = 1'b0;
	reg rd_to_error, wr_to_error;
	reg [31:0] beam_addr_r;
	
     
	always @(posedge clk)
	begin
		if (!rst_n)
		begin
			beam = 1'b0;
			beam_addr_o = 32'h0;
			beam_cnt = 32'h0;
			loopback_beam = 1'b0;
			bipr = 1'b0;
			loop_wr_en = 1'b0;
			axi_start_read = 1'b0;
			arvalid = 1'b0;
			rd_busy = 1'b0;
			rd_busy_to = 20'd0;
			wr_busy = 1'b0;
            wr_busy_to = 20'd0;
			eng_busy = 1'b0;
 		end
		else
		begin
			if (s_axi_bvalid) // lock write response when valid
			begin
				s_axi_resp = s_axi_bresp;
			end
			if (s_axi_rvalid) // lock read response when valid
			begin
				s_axi_resp = s_axi_resp | s_axi_rresp; // OR all response codes
			end
		
			beam = 0;

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
						BEAM_START:
							begin
                            end
						BEAM_LENGTH:
							begin
								// writing beam length register
								beam_cnt = wr_data_i[31:2]; // count of w32
								eng_busy = 1'b1; // engine is busy from the moment the first doorbell reg is written
							end
						BEAM_FROM:
							begin
								// writing address to beam from
								beam_from_addr = wr_data_i[31:3]; // set loopback memory read address, in w64
								
							end
						BEAM_TO:
							begin
								// beam command
								beam_addr_o = wr_data_i[31:0]; // set system memory destination address
								beam_addr_r = beam_addr_o; // remember this address for later confirmation readout
                                
								axi_start_read = 1'b1;       
                                rd_busy = 1'b1; // set busy to delay completion   
                                rd_busy_to = 20'd1000000; // timout counter      
                                rd_to_error = 1'b0;
							end
				        RESET_REG:
							begin
							    test_register[0] = wr_data_i[31:0];
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
					BSTAT:
						begin
							rd_data_o = s_axi_resp; // write and read response statuses
						end
					BEAM_LENGTH:
						begin
							rd_data_o = {beam_cnt, 2'b0};
						end
					BEAM_FROM:
						begin
							rd_data_o = {beam_from_addr, 3'b0};
						end
					BEAM_TO:
						begin
                            rd_data_o[31:2] = beam_addr_r[31:2];
							rd_data_o[1:0] = s_axi_resp; // two lower bits used for response code						
						end
			        RESET_REG:
			         begin
			             rd_data_o = test_register[0];
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
				beam_addr_o = 32'h0;
				beam_cnt = 32'h0;
			end
			
			// process loopback memory read address
			// read enable does not depend on bar_hit or address because it's created by beaming
			if (rd_en_i && loopback_beam)
			begin
				lb_addrb = lb_addrb + 32'h1;
			end
			

			// delay loopback data to match wr enable
			lb_wr_data = wr_data_i; 
			
			// delay address valid flag to match address
			awvalid = mem_adr_valid;

//	        arvalid = (!bipr) && beaming_in_progress; 
			bipr = beaming_in_progress; // history FF
			
			if (awvalid)
			begin 
			     wr_busy = 1'b1; // write started, set busy
			     wr_busy_to = 20'd1000000;
				 wr_to_error = 1'b0;
			end
			if (s_axi_bvalid)
			begin 
			     wr_busy = 1'b0; // received confirmation, remove busy
			     wr_busy_to = 20'd0;
			end

            // AXI reading state machine
        
            case (axi_state)
                AXI_IDLE:
                begin
                    if (axi_start_read && (!config_busy)) // start only if config read timout expired
                    begin
                        // set up address and valid flag
                        arvalid = 1'b1;
                        araddr = beam_from_addr;
                        axi_state = AXI_READ; // move to READ state
                        buf_mem_addr = 15'h0; // reset buffer memory writing address
                    end
                    else
                    begin
                        arvalid = 1'b0;
                    end
                end
        
                AXI_READ:
                begin
                    axi_start_read = 1'b0; // remove start flag
                    if (arready)
                    begin
                        // ctoc accepted address
                        arvalid = 1'b0; // remove addr valid flag
						s_axi_resp = 2'h0; // reset ORed response
                    end
                    if (s_axi_rvalid) // valid data coming out
                    begin
                        // increment address on each valid data word
                        // buffer memory will write word on rvalid vlag
                        buf_mem_addr = buf_mem_addr + 15'h1; 
                    end
                    if (rlast && !rlast_r) // rlast just rose. Need to look for edge because rlast is often left high after transaction
                    begin
                        // last word received 
                        beam = 1'b1; // set beam pulse so TX module starts beaming
                        loopback_beam = 1'b1; 
                        lb_addrb = 32'h0; // reset buffer memory reading address
                        axi_state = AXI_IDLE;
                        rd_busy = 1'b0; // remove busy flag. Completion will still be delayed until beaming is done
                        rd_busy_to = 20'd0;
						eng_busy = 1'b0; // remove engine busy
                    end
                end
                
            endcase
            
            // timeout circuitry to prevent busy from being stuck forever if ctoc is not working properly
            if (rd_busy)
            begin 
                if (rd_busy_to == 20'd1) 
				begin
					rd_busy = 1'b0; // time is up
					// also reset AXI reading state machine
					rd_to_error = 1'b1;
					axi_state = AXI_IDLE;
				end
                rd_busy_to = rd_busy_to - 20'd1;
            end
            
            if (wr_busy)
            begin 
                if (wr_busy_to == 20'd1) 
				begin
					wr_busy = 1'b0; // time is up
					wr_to_error = 1'b1;
				end
                wr_busy_to = wr_busy_to - 20'd1;
            end
		end // else: !if(!rst_n)
		
		rlast_r = rlast;
		        
	end	


	assign beam_data_o = (loopback_beam) ? lb_data : 64'h0;

	reg [14:0] adrr;
// buffer memory
    reg [63:0] lb_mem [8191:0];
    wire [63:0] rdata;
// synthesis attribute ram_style of lb_mem is block
	always @(posedge clk)
	begin
		if (s_axi_rvalid) lb_mem[buf_mem_addr] = rdata;
		if (rd_en_i) adrr = lb_addrb[14:0];
	end
	
	assign lb_data = lb_mem[adrr];

	control_to_core_axi ctoc 
	(
	  .s_aclk (clk),                                              // input wire s_aclk
	  .s_aresetn(axi_resetn),                                          // input wire s_aresetn
//      .s_aresetn(pcie_rst_n),
	  .s_axi_awid(6'h0),                                          // input wire [5 : 0] s_axi_awid
	  .s_axi_awaddr(awaddr),                                    // input wire [31 : 0] s_axi_awaddr
	  .s_axi_awlen(awlen),                                   // input wire [7 : 0] s_axi_awlen
	  .s_axi_awsize(3'h3), // 64 bit                              // input wire [2 : 0] s_axi_awsize
	  .s_axi_awburst(2'h1), // INCR                               // input wire [1 : 0] s_axi_awburst
	  .s_axi_awvalid(awvalid),                            // input wire s_axi_awvalid
	  .s_axi_awready(awready),                                           // output wire s_axi_awready
//	  .s_axi_wuser(test_register[0][3:0]),                        // input wire [3 : 0] s_axi_wuser
	  .s_axi_wdata(lb_wr_data),                                    // input wire [63 : 0] s_axi_wdata
	  .s_axi_wstrb(8'hff),  // all bytes valid always             // input wire [7 : 0] s_axi_wstrb
	  .s_axi_wlast(wlast),                                        // input wire s_axi_wlast
	  .s_axi_wvalid(loop_wr_en),                                  // input wire s_axi_wvalid
	  .s_axi_wready(wready),                                            // output wire s_axi_wready
	  
	  .s_axi_bid(s_axi_bid),                                      // output wire [5 : 0] s_axi_bid
	  .s_axi_bresp(s_axi_bresp),                                  // output wire [1 : 0] s_axi_bresp
	  .s_axi_bvalid(s_axi_bvalid),                                // output wire s_axi_bvalid
	  .s_axi_bready(1'b1),                                        // input wire s_axi_bready
	  
	  .s_axi_arid(6'h0),                                          // input wire [5 : 0] s_axi_arid
	  .s_axi_araddr(araddr),                                    // input wire [31 : 0] s_axi_araddr
	  .s_axi_arlen(arlen), // in w64                   // input wire [7 : 0] s_axi_arlen
	  .s_axi_arsize(3'h3),           // 64 bit                    // input wire [2 : 0] s_axi_arsize
	  .s_axi_arburst(2'h1), // INCR                               // input wire [1 : 0] s_axi_arburst
	  .s_axi_arvalid(arvalid),                                    // input wire s_axi_arvalid
	  .s_axi_arready(arready),                                           // output wire s_axi_arready
	  .s_axi_rid(s_axi_rid),                                      // output wire [5 : 0] s_axi_rid
	  .s_axi_rdata(rdata),                                       // output wire [63 : 0] s_axi_rdata
	  .s_axi_rresp(s_axi_rresp),                                  // output wire [1 : 0] s_axi_rresp
	  .s_axi_rlast(rlast),                                        // output wire s_axi_rlast
	  .s_axi_rvalid(s_axi_rvalid),                                // output wire s_axi_rvalid
	  .s_axi_rready(1'b1),      // always ready                   // input wire s_axi_rready
	  .control_phase_inc (control_phase_inc),
	  
		.ext_clk_in (ext_clk_in),
		.ext_data_in (ext_data_in),
		.ext_clk_out (ext_clk_out),
		.ext_data_out (ext_data_out)

	);
	
	
endmodule

