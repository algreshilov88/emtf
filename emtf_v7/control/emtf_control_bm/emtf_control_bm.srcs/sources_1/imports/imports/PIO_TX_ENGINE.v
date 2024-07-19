//-----------------------------------------------------------------------------
// Project    : Series-7 Integrated Block for PCI Express
// File       : PIO_TX_ENGINE.v
// Version    : 3.3

`timescale 1ps/1ps

// macro for byte order correction 
`define swizzle(a) {a[7:0], a[15:8], a[23:16], a[31:24]}

(* DowngradeIPIdentifiedWarnings = "yes" *)
module PIO_TX_ENGINE    #(
  // RX/TX interface data width
  parameter C_DATA_WIDTH = 64,
  parameter TCQ = 1,

  // TSTRB width
  parameter KEEP_WIDTH = C_DATA_WIDTH / 8
)(

  input             clk,
  input             rst_n,

  // AXIS
  input                           s_axis_tx_tready,
  output  reg [C_DATA_WIDTH-1:0]  s_axis_tx_tdata,
  output  reg [KEEP_WIDTH-1:0]    s_axis_tx_tkeep,
  output  reg                     s_axis_tx_tlast,
  output  reg                     s_axis_tx_tvalid,
  output                          tx_src_dsc,

  input                           req_compl,
  input                           req_compl_wd,
  output reg                      compl_done,

  input [2:0]                     req_tc,
  input                           req_td,
  input                           req_ep,
  input [1:0]                     req_attr,
  input [9:0]                     req_len,
  input [15:0]                    req_rid,
  input [7:0]                     req_tag,
  input [7:0]                     req_be,
  input [31:0]                    req_addr,

  output [31:0]                   rd_addr,
  output reg [3:0]                rd_be,
  input  [63:0]                   rd_data,
  output reg                      rd_en,
  
  input [15:0]                    completer_id,

  input                  cfg_bus_mstr_enable,
  input [15:0]           cfg_dcommand, 
  input                  beam,
  input [31:0]           beam_addr,
  input [63:0]           beam_data,
  input [31:0]           beam_cnt,
  output reg             beaming_in_progress,
  input                  busy,

  output reg tx_eng_busy

);

localparam PIO_CPLD_FMT_TYPE      = 7'b10_01010;
localparam PIO_CPL_FMT_TYPE       = 7'b00_01010;
localparam PIO_TX_RST_STATE       = 3'b000;
localparam PIO_TX_CPLD_QW1_FIRST  = 3'b001;
localparam PIO_TX_CPLD_QW1_TEMP   = 3'b010;
localparam PIO_TX_CPLD_QW1        = 3'b011;
localparam BM_SEND_HEAD           = 3'b100;
localparam BM_SEND_ADDR           = 3'b101;
localparam BM_SEND_DATA           = 3'b110;

  // Local registers

  reg [11:0]              byte_count;
  reg [6:0]               lower_addr;

  reg                     req_compl_q;
  reg                     req_compl_wd_q;

  reg                     compl_busy_i;
 
  // Local wires

  wire                    compl_wd;

	reg [4:0] 				tag;
	reg [31:0] 				beam_addr_r;
	reg [10:0] 				wcnt; // single transfer counter
	reg [31:0] 				tcnt; // total transfer counter
	reg [31:0] 				beam_datah_r; // delayed higher data word, because of 32-bit TLP structure
	reg 					one_more_tlp; // shows that one more TLP needs to be beamed
	reg [31:0] 				tmp;
	reg [C_DATA_WIDTH-1:0]  s_axis_tx_tdata_r;

  // Unused discontinue
  assign tx_src_dsc = 1'b0;

  // Present address and byte enable to memory module

  assign rd_addr = req_addr;
 
  always @(posedge clk) begin
    if (!rst_n)
    begin
     rd_be <=  0;
    end else begin
     rd_be <=  req_be[3:0];
    end
  end

  // Calculate byte count based on byte enable

  always @ (rd_be) begin
    casex (rd_be[3:0])
      4'b1xx1 : byte_count = 12'h004;
      4'b01x1 : byte_count = 12'h003;
      4'b1x10 : byte_count = 12'h003;
      4'b0011 : byte_count = 12'h002;
      4'b0110 : byte_count = 12'h002;
      4'b1100 : byte_count = 12'h002;
      4'b0001 : byte_count = 12'h001;
      4'b0010 : byte_count = 12'h001;
      4'b0100 : byte_count = 12'h001;
      4'b1000 : byte_count = 12'h001;
      4'b0000 : byte_count = 12'h001;
    endcase
  end

	always @ ( posedge clk ) begin
		if (!rst_n ) 
		begin
			req_compl_q      <=  1'b0;
			req_compl_wd_q   <=  1'b1;
		end // if !rst_n
		else
		begin
			req_compl_q      <=  req_compl;
			req_compl_wd_q   <=  req_compl_wd; // completion with data flag
		end // if rst_n
	end

    always @ (rd_be or req_addr or compl_wd) begin
		casex ({compl_wd, rd_be[3:0]})
			5'b1_0000 : lower_addr = {req_addr[6:2], 2'b00};
			5'b1_xxx1 : lower_addr = {req_addr[6:2], 2'b00};
			5'b1_xx10 : lower_addr = {req_addr[6:2], 2'b01};
			5'b1_x100 : lower_addr = {req_addr[6:2], 2'b10};
			5'b1_1000 : lower_addr = {req_addr[6:2], 2'b11};
			5'b0_xxxx : lower_addr = 8'h0;
		endcase // casex ({compl_wd, rd_be[3:0]})
    end

	//  Generate Completion with 1 DW Payload
    
    reg         [2:0]            state;

    assign compl_wd = req_compl_wd_q;


// decode max payload, in 32-bit words
	reg [9:0] max_payload;
	always @ (cfg_dcommand[7:5])
	begin
		case (cfg_dcommand[7:5])
			3'd0: max_payload = 10'd32;
			3'd1: max_payload = 10'd64;
			3'd2: max_payload = 10'd128;
			3'd3: max_payload = 10'd256;
			3'd4: max_payload = 10'd512;
			3'd5: max_payload = 10'd0; // means 1024
			default: max_payload = 10'd0;
		endcase
	end

	reg [15:0] req_compl_cnt = 0;
	reg [15:0] compl_done_cnt = 0;
	reg [31:0] compl_time_cnt;
	reg [31:0] compl_max_time = 0;
	wire axi_resetn; // connected on top level

    always @ ( posedge clk ) begin

		tx_eng_busy = 1'b1;
        if (!rst_n ) 
        begin
			s_axis_tx_tlast   <=  1'b0;
			s_axis_tx_tvalid  <=  1'b0;
			s_axis_tx_tdata   <=  {C_DATA_WIDTH{1'b0}};
			s_axis_tx_tkeep   <=  {KEEP_WIDTH{1'b0}};
			
			compl_done        <=  1'b0;
			compl_busy_i      <=  1'b0;
			state             <=  PIO_TX_RST_STATE;
			
        end // if (!rst_n ) 
        else
        begin

			compl_done        <=  1'b0;
			// -- Generate compl_busy signal...
			if (req_compl_q )
			begin
				compl_busy_i <= 1'b1;
				req_compl_cnt = req_compl_cnt + 1;
				compl_time_cnt = 0;
			end
			else
			begin
				compl_time_cnt = compl_time_cnt + 1;
			end

			if (!axi_resetn) compl_max_time = 0;

			case ( state )
				PIO_TX_RST_STATE : begin

					if (beam && cfg_bus_mstr_enable) // bus mastering requested
					begin
						beam_addr_r = beam_addr; // system memory address for transfer
						
						s_axis_tx_tlast   <=  1'b0;
						s_axis_tx_tvalid  <=  1'b0;

						tcnt = beam_cnt; // total transfer length
						if (tcnt > max_payload)
						begin
							wcnt = max_payload; // single transfer length
							tcnt = tcnt - wcnt; // reduce total length
							one_more_tlp = 1'b1; // need more transfers
						end
						else
						begin
							wcnt = tcnt; // just one transfer is enough
							tcnt = 32'h0;
						end

						tag <= tag + 5'b1; // next tag
						rd_en = 1'b1; // set read enable up front, to let memory read data
						beaming_in_progress = 1'b1; // beaming started
						state <= BM_SEND_HEAD;
					end
					else if (one_more_tlp) // more tlps are needed for beaming
					begin
						// remove tlast and tvalid between sub-transfers
						s_axis_tx_tlast   <=  1'b0;
						s_axis_tx_tvalid  <=  1'b0;
						rd_en = 1'b1; // set read enable up front, to let memory read data
						
						beam_addr_r = beam_addr_r + {max_payload, 2'h0}; // calculate address for new transfer
						if (tcnt > max_payload)
						begin
							wcnt = max_payload; // single transfer length
							tcnt = tcnt - wcnt; // reduce total length
						end
						else
						begin
							wcnt = tcnt;
							tcnt = 32'h0;
							one_more_tlp = 1'b0; // this is last transfer
						end
						
						tag <= tag + 5'b1; // next tag
						state <= BM_SEND_HEAD;
					end
					else if (compl_busy_i && !beaming_in_progress && !busy) 
					begin
						
						s_axis_tx_tdata   <=  {C_DATA_WIDTH{1'b0}};
						s_axis_tx_tkeep   <=  8'hFF;
						s_axis_tx_tlast   <=  1'b0;
						s_axis_tx_tvalid  <=  1'b0;
						if (s_axis_tx_tready)
							state             <=  PIO_TX_CPLD_QW1_FIRST;
						else
							state             <=  PIO_TX_RST_STATE;
					end
					else
					begin

						s_axis_tx_tlast   <=  1'b0;
						s_axis_tx_tvalid  <=  1'b0;
						s_axis_tx_tdata   <=  64'b0;
						s_axis_tx_tkeep   <=  8'hFF;
						compl_done        <=  1'b0;
						// keep engine busy if anything is going on
						tx_eng_busy = compl_busy_i || beaming_in_progress || busy;
						state             <=  PIO_TX_RST_STATE;

					end // if !(compl_busy) 
				end // PIO_TX_RST_STATE

				PIO_TX_CPLD_QW1_FIRST : begin
					if (s_axis_tx_tready) begin

						s_axis_tx_tlast  <=  1'b0;
						s_axis_tx_tdata  <=  {                      // Bits
																	completer_id,             // 16
																	{3'b0},                   // 3
																	{1'b0},                   // 1
																	byte_count,               // 12
																	{1'b0},                   // 1
																	(req_compl_wd_q ?
																	 PIO_CPLD_FMT_TYPE :
																	 PIO_CPL_FMT_TYPE),        // 7
																	{1'b0},                   // 1
																	req_tc,                   // 3
																	{4'b0},                   // 4
																	req_td,                   // 1
																	req_ep,                   // 1
																	req_attr,                 // 2
																	{2'b0},                   // 2
																	req_len                   // 10
																	};
						s_axis_tx_tkeep   <=  8'hFF;

						state             <=  PIO_TX_CPLD_QW1_TEMP;
					end
					else
						state             <=  PIO_TX_RST_STATE;

				end //PIO_TX_CPLD_QW1_FIRST


				PIO_TX_CPLD_QW1_TEMP : begin   
					s_axis_tx_tvalid <=  1'b1;
					state             <=  PIO_TX_CPLD_QW1;
				end


				PIO_TX_CPLD_QW1 : begin

					if (s_axis_tx_tready)
					begin

						s_axis_tx_tlast  <=  1'b1;
						s_axis_tx_tvalid <=  1'b1;
						// Swap DWORDS for AXI
						tmp = rd_data[31:0];
						s_axis_tx_tdata  <=  {        // Bits
													  `swizzle(tmp),    // 32
													  req_rid,    // 16
													  req_tag,    //  8
													  {1'b0},     //  1
													  lower_addr  //  7
													  };

						// Here we select if the packet has data or
						// not.  The strobe signal will mask data
						// when it is not needed.  No reason to change
						// the data bus.
						if (req_compl_wd_q)
							s_axis_tx_tkeep <=  8'hFF;
						else
							s_axis_tx_tkeep <=  8'h0F;


						compl_done        <=  1'b1;
						compl_done_cnt = compl_done_cnt + 1;
						if (compl_time_cnt > compl_max_time)
							compl_max_time = compl_time_cnt; // remember max completion time
						compl_busy_i      <=  1'b0;
						state             <=  PIO_TX_RST_STATE;

					end // if (s_axis_tx_tready)
					else
						state             <=  PIO_TX_CPLD_QW1;

				end // PIO_TX_CPLD_QW1

				BM_SEND_HEAD:
					begin

						s_axis_tx_tdata[9:0]   <= wcnt; // payload length
						s_axis_tx_tdata[23:10] <= 14'b0;
						s_axis_tx_tdata[31:24] <= 8'h40; // format & type
						s_axis_tx_tdata[39:32] <= 8'hff; // last/first byte enable
						s_axis_tx_tdata[47:40] <= {3'b0, tag}; // assign unique tag
						s_axis_tx_tdata[63:48] <= {completer_id[15:3], 3'b0}; // requester id
						
						s_axis_tx_tkeep <= 8'hff;
						s_axis_tx_tlast <= 1'b0;
						s_axis_tx_tvalid <= 1'b0;
						
						if (s_axis_tx_tready) // tx took our data
						begin
							rd_en = 1'b1;
							s_axis_tx_tvalid <= 1'b1;
							state <= BM_SEND_ADDR; // next is to send address
						end // if (s_axis_tx_tready)
						else
						begin
							rd_en = 1'b0;
						end
					end
				
				BM_SEND_ADDR:
					begin
						if (s_axis_tx_tready) // tx took our data
						begin
							s_axis_tx_tdata_r <= s_axis_tx_tdata;

							s_axis_tx_tdata[31:0]  <= beam_addr_r;
							tmp = beam_data[31:0];
							s_axis_tx_tdata[63:32] <= `swizzle(tmp);
							wcnt = wcnt - 10'h1;

							s_axis_tx_tkeep <= 8'hff;
							s_axis_tx_tlast <= 1'b0;
							s_axis_tx_tvalid <= 1'b1;

							rd_en = 1'b1;
							state <= BM_SEND_DATA;
						end
						else
						begin
							rd_en = 1'b0;
							s_axis_tx_tvalid <= 1'b0;
						end
					end // case: BM_SEND_ADDR

				BM_SEND_DATA:
					begin
						if (s_axis_tx_tready) // tx took our data
						begin
							s_axis_tx_tdata_r <= s_axis_tx_tdata;

							s_axis_tx_tdata[31:0]  <= `swizzle(beam_datah_r);
							wcnt = wcnt - 10'h1;

							rd_en = 1'b1;
							s_axis_tx_tvalid <= 1'b1;
							
							// remove rd_en two clocks earlier, to prevent reading extra words 
							if (wcnt <= 10'h5) rd_en = 1'b0; 
							
							if (wcnt == 10'h0)
							begin
								s_axis_tx_tdata[63:32] <= 32'h0;
								s_axis_tx_tkeep <= 8'h0f; // only one word in last transfer
								s_axis_tx_tlast <= 1'b1; // last transfer
								if (tcnt == 32'h0) beaming_in_progress = 1'b0; // this is also last block
								state <= PIO_TX_RST_STATE;
							end
							else
							begin
								tmp = beam_data[31:0];
								s_axis_tx_tdata[63:32] <= `swizzle(tmp);
								wcnt = wcnt - 10'h1;
								
								s_axis_tx_tkeep <= 8'hff;
								if (wcnt == 10'h0)
								begin
									s_axis_tx_tlast <= 1'b1; // last transfer
									if (tcnt == 32'h0) beaming_in_progress = 1'b0; // this is also last block
									state <= PIO_TX_RST_STATE;
								end
								else
									s_axis_tx_tlast <= 1'b0;
							end
							
						end // if (s_axis_tx_tready)
						else
						begin
							rd_en = 1'b0;
							s_axis_tx_tvalid <= 1'b0;
						end
					end // case: BM_SEND_DATA


				default : begin
					// case default stmt
					state             <=  PIO_TX_RST_STATE;
				end

			endcase
			// high data word delay for 32-bit TLP
			beam_datah_r = beam_data[63:32];
			
        end // if rst_n
    end

	(* mark_debug = "TRUE" *) wire [15:0] req_compl_cnt_w = req_compl_cnt;
	(* mark_debug = "TRUE" *) wire [15:0] compl_done_cnt_w = compl_done_cnt;
	(* mark_debug = "TRUE" *) wire one_more_tlp_w = one_more_tlp;
	(* mark_debug = "TRUE" *) wire [2:0] tx_state_w = state;
	(* mark_debug = "TRUE" *) wire [31:0] compl_max_time_w = compl_max_time;
	(* mark_debug = "TRUE" *) wire [31:0] compl_time_cnt_w = compl_time_cnt;

	(* mark_debug = "TRUE" *) wire [C_DATA_WIDTH-1:0]  s_axis_tx_tdata_r_w = s_axis_tx_tdata_r;
	(* mark_debug = "TRUE" *) wire [C_DATA_WIDTH-1:0]  s_axis_tx_tdata_w = s_axis_tx_tdata;

endmodule // PIO_TX_ENGINE
