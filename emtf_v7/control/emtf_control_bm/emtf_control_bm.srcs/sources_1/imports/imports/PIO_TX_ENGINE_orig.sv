//-----------------------------------------------------------------------------
// Project    : Virtex-6 Integrated Block for PCI Express
// File       : PIO_64_TX_ENGINE.v
// Version    : 2.4
//-- Description: 64 bit Local-Link Transmit Unit.
//-- Madorsky: added Bus Mastering
//--------------------------------------------------------------------------------

`timescale 1ns/1ns

// macro for byte order correction 
`define swizzle(a) {a[7:0], a[15:8], a[23:16], a[31:24]}

module PIO_64_TX_ENGINE    #(
  // RX/TX interface data width
  parameter C_DATA_WIDTH = 64,
  parameter TCQ = 1,

  // KEEP width
  parameter KEEP_WIDTH = C_DATA_WIDTH / 8
)(

  input 						clk,
  input 						rst_n,

  // AXIS
  input 						s_axis_tx_tready,
  output reg [C_DATA_WIDTH-1:0] s_axis_tx_tdata,
  output reg [KEEP_WIDTH-1:0] 	s_axis_tx_tkeep,
  output reg 					s_axis_tx_tlast,
  output reg 					s_axis_tx_tvalid,
  output 						tx_src_dsc,

  input 						req_compl_i,
  input 						req_compl_wd_i,
  output reg 					compl_done_o,

  input [2:0] 					req_tc_i,
  input 						req_td_i,
  input 						req_ep_i,
  input [1:0] 					req_attr_i,
  input [9:0] 					req_len_i,
  input [15:0] 					req_rid_i,
  input [7:0] 					req_tag_i,
  input [7:0] 					req_be_i,
  input [31:0] 					req_addr_i,

  output [31:0] 				rd_addr_o,
  output [3:0] 					rd_be_o,
  input [63:0] 					rd_data_i,
  output reg 					rd_en_o,

  input [15:0] 					completer_id_i,
  input 						cfg_bus_mstr_enable_i,
  input [15:0] 					cfg_dcommand, 
  input 						beam,
  input 						req_beam,
  input [31:0] 					beam_addr_i,
  input [63:0] 					beam_data_i,
  input [31:0] 					beam_cnt_i,
  output reg 					beaming_in_progress,
  input busy

);

localparam PIO_64_CPLD_FMT_TYPE = 7'b10_01010;
localparam PIO_64_CPL_FMT_TYPE  = 7'b00_01010;
	
localparam PIO_64_TX_RST_STATE  = 6'b000000;
localparam PIO_64_TX_CPLD_QW1   = 6'b000001;
localparam BM_SEND_HEAD         = 6'b000010;
localparam BM_SEND_ADDR         = 6'b000100;
localparam BM_SEND_DATA         = 6'b001000;
    // Local registers


    reg [11:0]              byte_count;
    wire [06:0] 			lower_addr = 7'b0;

    reg                     req_compl_q;
    reg                     req_compl_wd_q;

    reg [5:0]               state;
	reg [4:0] 				tag;
	reg [31:0] 				beam_addr;
	reg [10:0] 				wcnt; // single transfer counter
	reg [31:0] 				tcnt; // total transfer counter
	reg [31:0] 				beam_datah_r; // delayed higher data word, because of 32-bit TLP structure
	reg 					one_more_tlp; // shows that one more TLP needs to be beamed
	reg [31:0] 				tmp;
	
    // Local wires

    // Unused discontinue
    assign tx_src_dsc = 1'b0;

    /*
     * Present address and byte enable to memory module
     */

    assign rd_addr_o = req_addr_i;
    assign rd_be_o =   req_be_i[3:0];

    /*
     * Calculate byte count based on byte enable
     */

    always @ (rd_be_o) begin

      casex (rd_be_o[3:0])

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

    /*
     * Calculate lower address based on  byte enable
     */
/*
    always @ (rd_be_o or req_addr_i or req_compl_wd_q) begin

      casex ({req_compl_wd_q, rd_be_o[3:0]})

        5'b0_xxxx : lower_addr = 8'h0;
        5'bx_0000 : lower_addr = {req_addr_i[6:2], 2'b00};
        5'bx_xxx1 : lower_addr = {req_addr_i[6:2], 2'b00};
        5'bx_xx10 : lower_addr = {req_addr_i[6:2], 2'b01};
        5'bx_x100 : lower_addr = {req_addr_i[6:2], 2'b10};
        5'bx_1000 : lower_addr = {req_addr_i[6:2], 2'b11};

      endcase

    end
*/

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

	
    /*
     *  Generate Completion with 1 DW Payload
	 *  and Bus Mastering 
     */

    always @ ( posedge clk ) begin

        if (!rst_n ) begin

          s_axis_tx_tlast   <=  1'b0;
          s_axis_tx_tvalid  <=  1'b0;
          s_axis_tx_tdata   <=  {C_DATA_WIDTH{1'b0}};
          s_axis_tx_tkeep   <=  {KEEP_WIDTH{1'b1}};

          compl_done_o      <=  1'b0;
			tag <= 5'b0;
			beam_addr = 32'h0;
			one_more_tlp = 1'b0;
			beaming_in_progress = 1'b0;
          req_compl_q <=  1'b0;
          req_compl_wd_q <=  1'b1;
			
          state             <=  PIO_64_TX_RST_STATE;

        end else begin

			if (req_compl_i) // need to remember completion request for delayed completion after beaming
				req_compl_q <=  1'b1;
			
			req_compl_wd_q <=  req_compl_wd_i;

			rd_en_o = 1'b0;
          case ( state )

            PIO_64_TX_RST_STATE : begin

			  if (beam && cfg_bus_mstr_enable_i) // bus mastering requested
			  begin
				  beam_addr = beam_addr_i; // system memory address for transfer
				  
				  tcnt = beam_cnt_i; // total transfer length
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
				  rd_en_o = 1'b1; // set read enable up front, to let memory read data
				  beaming_in_progress = 1'b1; // beaming started
				  state <= BM_SEND_HEAD;
			  end
			  else
				// completion waits until beaming is done
				// also waits for modules to become ready to complete
              if (req_compl_q && !beaming_in_progress && !busy) 
			  begin // completion needed for read TLP

                s_axis_tx_tlast  <=  1'b0;
                s_axis_tx_tvalid <=  1'b1;
                // Swap DWORDS for AXI
                s_axis_tx_tdata  <=  {                      // Bits
                                      completer_id_i,           // 16
                                      {3'b0},                   // 3
                                      {1'b0},                   // 1
                                      byte_count,               // 12
                                      {1'b0},                   // 1
                                      (req_compl_wd_q ?
                                      PIO_64_CPLD_FMT_TYPE :
                                      PIO_64_CPL_FMT_TYPE),     // 7
                                      {1'b0},                   // 1
                                      req_tc_i,                 // 3
                                      {4'b0},                   // 4
                                      req_td_i,                 // 1
                                      req_ep_i,                 // 1
                                      req_attr_i,               // 2
                                      {2'b0},                   // 2
                                      req_len_i                 // 10
                                      };
                s_axis_tx_tkeep   <=  8'hFF;

                // Wait in this state if the PCIe core does not accept
                // the first beat of the packet
                if (s_axis_tx_tready)
				begin
					rd_en_o = 1'b1;
					req_compl_q <= 1'b0; // remove request
					state             <=  PIO_64_TX_CPLD_QW1;
				end
                else
                  state             <=  PIO_64_TX_RST_STATE;


              end 
			  else
			  if (one_more_tlp) // more tlps are needed for beaming
			  begin
				  // remove tlast and tvalid between sub-transfers
                  s_axis_tx_tlast   <=  1'b0;
                  s_axis_tx_tvalid  <=  1'b0;
				  rd_en_o = 1'b1; // set read enable up front, to let memory read data
				  
				  beam_addr = beam_addr + {max_payload, 2'h0}; // calculate address for new transfer
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
			  else
			  begin

                s_axis_tx_tlast   <=  1'b0;
                s_axis_tx_tvalid  <=  1'b0;
                s_axis_tx_tdata   <=  64'b0;
                s_axis_tx_tkeep   <=  8'hFF;
                compl_done_o      <=  1'b0;

                state             <=  PIO_64_TX_RST_STATE;

              end

            end

            PIO_64_TX_CPLD_QW1 : begin

              if (s_axis_tx_tready) begin

                s_axis_tx_tlast  <=  1'b1;
                s_axis_tx_tvalid <=  1'b1;
                // Swap DWORDS for AXI
				  tmp = rd_data_i[63:32];
                s_axis_tx_tdata  <=  {        // Bits
                                      `swizzle(tmp),  // 32
                                      req_rid_i,  // 16
                                      req_tag_i,  //  8
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


                compl_done_o      <=  1'b1;
                state             <=  PIO_64_TX_RST_STATE;

              end else
                state             <=  PIO_64_TX_CPLD_QW1;

            end

			BM_SEND_HEAD:
				begin

					s_axis_tx_tdata[9:0]   <= wcnt; // payload length
					s_axis_tx_tdata[23:10] <= 14'b0;
					s_axis_tx_tdata[31:24] <= 8'h40; // format & type
					s_axis_tx_tdata[39:32] <= 8'hff; // last/first byte enable
					s_axis_tx_tdata[47:40] <= {3'b0, tag}; // assign unique tag
					s_axis_tx_tdata[63:48] <= {completer_id_i[15:3], 3'b0}; // requester id
					
					s_axis_tx_tkeep <= 8'hff;
					s_axis_tx_tlast <= 1'b0;
					s_axis_tx_tvalid <= 1'b1;
					  
					if (s_axis_tx_tready) // tx took our data
					begin
						rd_en_o = 1'b1;
						state <= BM_SEND_ADDR; // next is to send address
					end // if (s_axis_tx_tready)
				end
				  
			BM_SEND_ADDR:
				begin
					if (s_axis_tx_tready) // tx took our data
					begin
						s_axis_tx_tdata[31:0]  <= beam_addr;
						tmp = beam_data_i[31:0];
						s_axis_tx_tdata[63:32] <= `swizzle(tmp);
						wcnt = wcnt - 10'h1;

						s_axis_tx_tkeep <= 8'hff;
						s_axis_tx_tlast <= 1'b0;
						s_axis_tx_tvalid <= 1'b1;

						rd_en_o = 1'b1;
						state <= BM_SEND_DATA;
					end
					else
					begin
						s_axis_tx_tvalid <= 1'b0;
					end
				end // case: BM_SEND_ADDR

			BM_SEND_DATA:
				begin
					if (s_axis_tx_tready) // tx took our data
					begin
						s_axis_tx_tdata[31:0]  <= `swizzle(beam_datah_r);
						wcnt = wcnt - 10'h1;

						rd_en_o = 1'b1;
						s_axis_tx_tvalid <= 1'b1;
						
						// remove rd_en two clocks earlier, to prevent reading extra words 
						if (wcnt <= 10'h5) rd_en_o = 1'b0; 
						
						if (wcnt == 10'h0)
						begin
							s_axis_tx_tdata[63:32] <= 32'h0;
							s_axis_tx_tkeep <= 8'h0f; // only one word in last transfer
							s_axis_tx_tlast <= 1'b1; // last transfer
							if (tcnt == 32'h0) beaming_in_progress = 1'b0; // this is also last block
							state <= PIO_64_TX_RST_STATE;
						end
						else
						begin
							tmp = beam_data_i[31:0];
							s_axis_tx_tdata[63:32] <= `swizzle(tmp);
							wcnt = wcnt - 10'h1;
							
							s_axis_tx_tkeep <= 8'hff;
							if (wcnt == 10'h0)
							begin
								s_axis_tx_tlast <= 1'b1; // last transfer
								if (tcnt == 32'h0) beaming_in_progress = 1'b0; // this is also last block
								state <= PIO_64_TX_RST_STATE;
							end
							else
								s_axis_tx_tlast <= 1'b0;
						end
						
					end // if (s_axis_tx_tready)
					else
					begin
						s_axis_tx_tvalid <= 1'b0;
					end
				end // case: BM_SEND_DATA

          endcase // case ( state )

			// high data word delay for 32-bit TLP
			beam_datah_r = beam_data_i[63:32];

        end

    end

endmodule // PIO_64_TX_ENGINE

