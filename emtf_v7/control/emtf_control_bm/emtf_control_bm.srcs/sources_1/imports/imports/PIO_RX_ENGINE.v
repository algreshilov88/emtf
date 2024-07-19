
//-----------------------------------------------------------------------------
// Project    : Series-7 Integrated Block for PCI Express
// File       : PIO_RX_ENGINE.v
// Version    : 3.3
//--
//-- Description: Local-Link Receive Unit.
//--
//--------------------------------------------------------------------------------

`timescale 1ps/1ps

// macro for byte order correction 
`define swizzle(a) {a[7:0], a[15:8], a[23:16], a[31:24]}

(* DowngradeIPIdentifiedWarnings = "yes" *)
module PIO_RX_ENGINE  #(
  parameter TCQ = 1,
  parameter C_DATA_WIDTH = 64,            // RX/TX interface data width

  // Do not override parameters below this line
  parameter KEEP_WIDTH = C_DATA_WIDTH / 8               // TSTRB width
) (
  input                         clk,
  input                         rst_n,

  // AXI-S
  input  [C_DATA_WIDTH-1:0]     m_axis_rx_tdata,
  input  [KEEP_WIDTH-1:0]       m_axis_rx_tkeep,
  input                         m_axis_rx_tlast,
  input                         m_axis_rx_tvalid,
  output reg                    m_axis_rx_tready,
  input    [21:0]               m_axis_rx_tuser,


  //  Memory Read data handshake with Completion
  //  transmit unit. Transmit unit reponds to
  //  req_compl assertion and responds with compl_done
  //  assertion when a Completion w/ data is transmitted.


  output reg         req_compl,
  output reg         req_compl_wd,
  input              compl_done,

  output reg [2:0]   req_tc,                        // Memory Read TC
  output reg         req_td,                        // Memory Read TD
  output reg         req_ep,                        // Memory Read EP
  output reg [1:0]   req_attr,                      // Memory Read Attribute
  output reg [9:0]   req_len,                       // Memory Read Length (1DW)
  output reg [15:0]  req_rid,                       // Memory Read Requestor ID
  output reg [7:0]   req_tag,                       // Memory Read Tag
  output reg [7:0]   req_be,                        // Memory Read Byte Enables
  output reg [31:0]  req_addr,                      // Memory Read Address


  // Memory interface used to save 1 DW data received
  // on Memory Write 32 TLP. Data extracted from
  // inbound TLP is presented to the Endpoint memory
  // unit. Endpoint memory unit reacts to wr_en
  // assertion and asserts wr_busy when it is
  // processing written information.

  output reg         bar_hit, // shows which BAR is hit 
  output reg [31:0]  wr_addr,                       // Memory Write Address
  output reg         wr_addr_valid, // address strobe
  output reg [7:0]   wr_be,                         // Memory Write Byte Enable
  output reg [63:0]  wr_data,                       // Memory Write Data
  output reg         wr_en,                         // Memory Write Enable
  input              wr_busy                        // Memory Write Busy
);

  localparam PIO_RX_MEM_RD32_FMT_TYPE = 7'b00_00000;
  localparam PIO_RX_MEM_WR32_FMT_TYPE = 7'b10_00000;
  localparam PIO_RX_MEM_RD64_FMT_TYPE = 7'b01_00000;
  localparam PIO_RX_MEM_WR64_FMT_TYPE = 7'b11_00000;
  localparam PIO_RX_IO_RD32_FMT_TYPE  = 7'b00_00010;
  localparam PIO_RX_IO_WR32_FMT_TYPE  = 7'b10_00010;

  localparam PIO_RX_RST_STATE            = 9'b000000000;
  localparam PIO_RX_MEM_RD32_DW1DW2      = 9'b000000001;
  localparam PIO_RX_MEM_WR32_DW1DW2      = 9'b000000010;
  localparam PIO_RX_MEM_RD64_DW1DW2      = 9'b000000100;
  localparam PIO_RX_MEM_WR64_DW1DW2      = 9'b000001000;
  localparam PIO_RX_MEM_WR64_DW3         = 9'b000010000;
  localparam PIO_RX_WAIT_STATE           = 9'b000100000;
  localparam PIO_RX_IO_WR_DW1DW2         = 9'b001000000;
  localparam PIO_RX_IO_MEM_WR_WAIT_STATE = 9'b010000000;
  localparam PIO_RX_MEM_WR32_QWN         = 9'b100000000; 


  // Local Registers

  reg [8:0]          state;
  reg [7:0]          tlp_type;

  wire               io_bar_hit_n;
  wire               mem32_bar_hit_n;
  wire               mem64_bar_hit_n;
  wire               erom_bar_hit_n;

  reg [1:0]          region_select;

      wire               sop;                   // Start of packet
      reg                in_packet_q;
	reg [9:0]        tcnt; // transfer counter 
	reg [31:0]        tmp;
	reg [31:0]        wr_datar; // lower word delay register, to compensate for word shift in 32-bit TLPs  
	reg          wr_enr; // wr enable delay register
	reg          local_busy;  
	reg [5:0]        local_timer;
     
      // Generate a signal that indicates if we are currently receiving a packet.
      // This value is one clock cycle delayed from what is actually on the AXIS
      // data bus.
      always@(posedge clk)
      begin
        if(!rst_n)
          in_packet_q <=  1'b0;
        else if (m_axis_rx_tvalid && m_axis_rx_tready && m_axis_rx_tlast)
          in_packet_q <=  1'b0;
        else if (sop && m_axis_rx_tready)
          in_packet_q <=  1'b1;

      end

      assign sop = !in_packet_q && m_axis_rx_tvalid;

      always @ ( posedge clk ) 
	  begin

        if (!rst_n ) 
		begin

          m_axis_rx_tready <=  1'b0;

          req_compl    <=  1'b0;
          req_compl_wd <=  1'b1;

          req_tc       <=  3'b0;
          req_td       <=  1'b0;
          req_ep       <=  1'b0;
          req_attr     <=  2'b0;
          req_len      <=  10'b0;
          req_rid      <=  16'b0;
          req_tag      <=  8'b0;
          req_be       <=  8'b0;
          req_addr     <=  32'b0;

          wr_be        <=  8'b0;
          wr_addr      <=  32'b0;
          wr_data      <=  64'b0;
          wr_datar     <=  32'b0;
          wr_en        <=  1'b0;
          wr_enr       <=  1'b0;

          state        <=  PIO_RX_RST_STATE;
          tlp_type     <=  8'b0;
			wr_addr_valid = 1'b0;
			local_busy = 1'b0;
			local_timer = 6'h0;

        end 
		else 
		begin

			// lower data word and wr_en delayed to compensate for word shift in 32-bit TLPs 
			wr_data[31:0] <= wr_datar;
			wr_en <= wr_enr;
            
			wr_enr <= 1'b0; 
			req_compl    <=  1'b0;
			wr_addr_valid = 1'b0; 
  
          case (state)

            PIO_RX_RST_STATE : begin

              m_axis_rx_tready <=  1'b1;
              req_compl_wd     <=  1'b1;


              if (sop)
              begin

                case (m_axis_rx_tdata[30:24])

                  PIO_RX_MEM_RD32_FMT_TYPE : begin

                    tlp_type     <=  m_axis_rx_tdata[31:24];
                    req_len      <=  m_axis_rx_tdata[9:0];
                    m_axis_rx_tready <=  1'b0;


                    if (m_axis_rx_tdata[9:0] == 10'b1)
                    begin

                      req_tc     <=  m_axis_rx_tdata[22:20];
                      req_td     <=  m_axis_rx_tdata[15];
                      req_ep     <=  m_axis_rx_tdata[14];
                      req_attr   <=  m_axis_rx_tdata[13:12];
                      req_len    <=  m_axis_rx_tdata[9:0];
                      req_rid    <=  m_axis_rx_tdata[63:48];
                      req_tag    <=  m_axis_rx_tdata[47:40];
                      req_be     <=  m_axis_rx_tdata[39:32];
                      state      <=  PIO_RX_MEM_RD32_DW1DW2;

                    end // if (m_axis_rx_tdata[9:0] == 10'b1)
                    else
                    begin

                      state        <=  PIO_RX_RST_STATE;

                    end // if !(m_axis_rx_tdata[9:0] == 10'b1)

                  end // PIO_RX_MEM_RD32_FMT_TYPE

                  PIO_RX_MEM_WR32_FMT_TYPE : begin

                    tlp_type     <=  m_axis_rx_tdata[31:24];
                    req_len      <=  m_axis_rx_tdata[9:0];
                    m_axis_rx_tready <=  1'b0;

                    if (m_axis_rx_tdata[9:0] == 10'b1)
                    begin

                      wr_be      <=  m_axis_rx_tdata[39:32];
                      state      <=  PIO_RX_MEM_WR32_DW1DW2;

                    end // if (m_axis_rx_tdata[9:0] == 10'b1)
                    else
                    begin

                      state      <=  PIO_RX_RST_STATE;

                    end // if !(m_axis_rx_tdata[9:0] == 10'b1)

                  end // PIO_RX_MEM_WR32_FMT_TYPE

                  PIO_RX_MEM_RD64_FMT_TYPE : begin

                    tlp_type     <=  m_axis_rx_tdata[31:24];
                    req_len      <=  m_axis_rx_tdata[9:0];
                    m_axis_rx_tready <=  1'b0;

                    if (m_axis_rx_tdata[9:0] == 10'b1)
                    begin

                      req_tc     <=  m_axis_rx_tdata[22:20];
                      req_td     <=  m_axis_rx_tdata[15];
                      req_ep     <=  m_axis_rx_tdata[14];
                      req_attr   <=  m_axis_rx_tdata[13:12];
                      req_len    <=  m_axis_rx_tdata[9:0];
                      req_rid    <=  m_axis_rx_tdata[63:48];
                      req_tag    <=  m_axis_rx_tdata[47:40];
                      req_be     <=  m_axis_rx_tdata[39:32];
                      state        <=  PIO_RX_MEM_RD64_DW1DW2;

                    end // if (m_axis_rx_tdata[9:0] == 10'b1)
                    else
                    begin

                      state      <=  PIO_RX_RST_STATE;

                    end // if !(m_axis_rx_tdata[9:0] == 10'b1)

                  end // PIO_RX_MEM_RD64_FMT_TYPE

                  PIO_RX_MEM_WR64_FMT_TYPE : begin

                    tlp_type     <=  m_axis_rx_tdata[31:24];
                    req_len      <=  m_axis_rx_tdata[9:0];

                    if (m_axis_rx_tdata[9:0] == 10'b1) begin

                      wr_be      <=  m_axis_rx_tdata[39:32];
                      state      <=  PIO_RX_MEM_WR64_DW1DW2;

                    end // if (m_axis_rx_tdata[9:0] == 10'b1)
                    else
                    begin

                      state      <=  PIO_RX_RST_STATE;

                    end // if !(m_axis_rx_tdata[9:0] == 10'b1)

                  end // PIO_RX_MEM_WR64_FMT_TYPE


                  PIO_RX_IO_RD32_FMT_TYPE : begin

                    tlp_type     <=  m_axis_rx_tdata[31:24];
                    req_len      <=  m_axis_rx_tdata[9:0];
                    m_axis_rx_tready <=  1'b0;


                    if (m_axis_rx_tdata[9:0] == 10'b1)
                    begin

                      req_tc     <=  m_axis_rx_tdata[22:20];
                      req_td     <=  m_axis_rx_tdata[15];
                      req_ep     <=  m_axis_rx_tdata[14];
                      req_attr   <=  m_axis_rx_tdata[13:12];
                      req_len    <=  m_axis_rx_tdata[9:0];
                      req_rid    <=  m_axis_rx_tdata[63:48];
                      req_tag    <=  m_axis_rx_tdata[47:40];
                      req_be     <=  m_axis_rx_tdata[39:32];
                      state      <=  PIO_RX_MEM_RD32_DW1DW2;

                    end // if (m_axis_rx_tdata[9:0] == 10'b1)
                    else
                    begin

                      state      <=  PIO_RX_RST_STATE;

                    end // if !(m_axis_rx_tdata[9:0] == 10'b1)

                  end // PIO_RX_IO_RD32_FMT_TYPE

                  PIO_RX_IO_WR32_FMT_TYPE : begin

                    tlp_type     <=  m_axis_rx_tdata[31:24];
                    req_len      <=  m_axis_rx_tdata[9:0];
                    m_axis_rx_tready <=  1'b0;

                    if (m_axis_rx_tdata[9:0] == 10'b1)
                    begin

                      req_tc     <=  m_axis_rx_tdata[22:20];
                      req_td     <=  m_axis_rx_tdata[15];
                      req_ep     <=  m_axis_rx_tdata[14];
                      req_attr   <=  m_axis_rx_tdata[13:12];
                      req_len    <=  m_axis_rx_tdata[9:0];
                      req_rid    <=  m_axis_rx_tdata[63:48];
                      req_tag    <=  m_axis_rx_tdata[47:40];
                      req_be     <=  m_axis_rx_tdata[39:32];
                      wr_be      <=  m_axis_rx_tdata[39:32];
                      state      <=  PIO_RX_IO_WR_DW1DW2;

                    end //if (m_axis_rx_tdata[9:0] == 10'b1)
                    else
                    begin

                      state        <=  PIO_RX_RST_STATE;

                    end //if !(m_axis_rx_tdata[9:0] == 10'b1)

                  end // PIO_RX_IO_WR32_FMT_TYPE


                  default : begin // other TLPs

                    state        <=  PIO_RX_RST_STATE;

                  end // default

                endcase

              end // if (sop)
              else
                  state <=  PIO_RX_RST_STATE;

            end // PIO_RX_RST_STATE

            PIO_RX_MEM_RD32_DW1DW2 : begin

              if (m_axis_rx_tvalid)
              begin

                m_axis_rx_tready <=  1'b0;
                req_addr     <=  {region_select[1:0],m_axis_rx_tdata[10:2], 2'b00};
                req_compl    <=  1'b1;
                req_compl_wd <=  1'b1;
                state        <=  PIO_RX_WAIT_STATE;

              end // if (m_axis_rx_tvalid)
              else
                state        <=  PIO_RX_MEM_RD32_DW1DW2;

            end // PIO_RX_MEM_RD32_DW1DW2


            PIO_RX_MEM_WR32_DW1DW2 : begin

              if (m_axis_rx_tvalid)
              begin

                wr_data      <=  m_axis_rx_tdata[63:32];
                wr_en        <=  1'b1;
                m_axis_rx_tready <=  1'b0;
                wr_addr      <=  {region_select[1:0],m_axis_rx_tdata[10:2]};
                state        <=   PIO_RX_WAIT_STATE;

              end // if (m_axis_rx_tvalid)
              else
                state        <=  PIO_RX_MEM_WR32_DW1DW2;

            end // PIO_RX_MEM_WR32_DW1DW2


            PIO_RX_MEM_RD64_DW1DW2 : begin

              if (m_axis_rx_tvalid)
              begin

                req_addr     <=  {region_select[1:0],m_axis_rx_tdata[42:34], 2'b00};
                req_compl    <=  1'b1;
                req_compl_wd <=  1'b1;
                m_axis_rx_tready <=  1'b0;
                state        <=  PIO_RX_WAIT_STATE;

              end // if (m_axis_rx_tvalid)
              else
                state        <=  PIO_RX_MEM_RD64_DW1DW2;

            end // PIO_RX_MEM_RD64_DW1DW2


            PIO_RX_MEM_WR64_DW1DW2 : begin

              if (m_axis_rx_tvalid)
              begin

                m_axis_rx_tready <=  1'b0;
                wr_addr        <=  {region_select[1:0],m_axis_rx_tdata[42:34]};
                state          <=   PIO_RX_MEM_WR64_DW3;

              end // if (m_axis_rx_tvalid)
              else
                state          <=  PIO_RX_MEM_WR64_DW1DW2;

            end // PIO_RX_MEM_WR64_DW1DW2


            PIO_RX_MEM_WR64_DW3 : begin

              if (m_axis_rx_tvalid)
              begin

                wr_data      <=  m_axis_rx_tdata[31:0];
                wr_en        <=  1'b1;
                m_axis_rx_tready <=  1'b0;
                state        <=  PIO_RX_WAIT_STATE;

              end // if (m_axis_rx_tvalid)
              else
                 state        <=  PIO_RX_MEM_WR64_DW3;

            end // PIO_RX_MEM_WR64_DW3


            PIO_RX_IO_WR_DW1DW2 : begin

              if (m_axis_rx_tvalid)
              begin

                wr_data         <=  m_axis_rx_tdata[63:32];
                wr_en           <=  1'b1;
                m_axis_rx_tready  <=  1'b0;
                wr_addr         <=  {region_select[1:0],m_axis_rx_tdata[10:2]};
                req_compl       <=  1'b1;
                req_compl_wd    <=  1'b0;
                state             <=   PIO_RX_WAIT_STATE;

              end // if (m_axis_rx_tvalid)
              else
                state             <=  PIO_RX_IO_WR_DW1DW2;
            end // PIO_RX_IO_WR_DW1DW2

            PIO_RX_WAIT_STATE : begin

              wr_en      <=  1'b0;
              req_compl  <=  1'b0;

              if ((tlp_type == PIO_RX_MEM_WR32_FMT_TYPE) && (!wr_busy))
              begin

                m_axis_rx_tready <=  1'b1;
                state        <=  PIO_RX_RST_STATE;

              end // if ((tlp_type == PIO_RX_MEM_WR32_FMT_TYPE) && (!wr_busy))
              else if ((tlp_type == PIO_RX_IO_WR32_FMT_TYPE) && (!wr_busy))
              begin

                m_axis_rx_tready <=  1'b1;
                state        <=  PIO_RX_RST_STATE;

              end // if ((tlp_type == PIO_RX_IO_WR32_FMT_TYPE) && (!wr_busy))
              else if ((tlp_type == PIO_RX_MEM_WR64_FMT_TYPE) && (!wr_busy))
              begin

                m_axis_rx_tready <=  1'b1;
                state        <=  PIO_RX_RST_STATE;

              end // if ((tlp_type == PIO_RX_MEM_WR64_FMT_TYPE) && (!wr_busy))
              else if ((tlp_type == PIO_RX_MEM_RD32_FMT_TYPE) && (compl_done))
              begin

                m_axis_rx_tready <=  1'b1;
                state        <=  PIO_RX_RST_STATE;

              end // if ((tlp_type == PIO_RX_MEM_RD32_FMT_TYPE) && (compl_done))
              else if ((tlp_type == PIO_RX_IO_RD32_FMT_TYPE) && (compl_done))
              begin

                m_axis_rx_tready <=  1'b1;
                state        <=  PIO_RX_RST_STATE;

              end // if ((tlp_type == PIO_RX_IO_RD32_FMT_TYPE) && (compl_done))
              else if ((tlp_type == PIO_RX_MEM_RD64_FMT_TYPE) && (compl_done))
              begin

                m_axis_rx_tready <=  1'b1;
                state        <=  PIO_RX_RST_STATE;

              end // if ((tlp_type == PIO_RX_MEM_RD64_FMT_TYPE) && (compl_done))
              else
                state        <=  PIO_RX_WAIT_STATE;

            end // PIO_RX_WAIT_STATE

            default : begin
              // default case stmt
              state        <=  PIO_RX_RST_STATE;
            end // default

          endcase

        end

      end
    

assign    mem64_bar_hit_n = 1'b1;
assign    io_bar_hit_n = 1'b1;
assign    mem32_bar_hit_n = ~(m_axis_rx_tuser[2]);
assign    erom_bar_hit_n  = ~(m_axis_rx_tuser[8]);


  always @*
  begin
    case ({io_bar_hit_n, mem32_bar_hit_n, mem64_bar_hit_n, erom_bar_hit_n})

      4'b0111 : begin
        region_select <=  2'b00;    // Select IO region
      end // 4'b0111

      4'b1011 : begin
        region_select <=  2'b01;    // Select Mem32 region
      end // 4'b1011

      4'b1101 : begin
        region_select <=  2'b10;    // Select Mem64 region
      end // 4'b1101

      4'b1110 : begin
        region_select <=  2'b11;    // Select EROM region
      end // 4'b1110

      default : begin
        region_select <=  2'b00;    // Error selection will select IO region
      end // default

    endcase // case ({io_bar_hit_n, mem32_bar_hit_n, mem64_bar_hit_n, erom_bar_hit_n})

  end

  // synthesis translate_off
  reg  [8*20:1] state_ascii;
  always @(state)
  begin
    case (state)
      PIO_RX_RST_STATE              : state_ascii <=  "RX_RST_STATE";
      PIO_RX_MEM_RD32_DW1DW2        : state_ascii <=  "RX_MEM_RD32_DW1DW2";
      PIO_RX_MEM_WR32_DW1DW2        : state_ascii <=  "RX_MEM_WR32_DW1DW2";
      PIO_RX_MEM_RD64_DW1DW2        : state_ascii <=  "RX_MEM_RD64_DW1DW2";
      PIO_RX_MEM_WR64_DW1DW2        : state_ascii <=  "RX_MEM_WR64_DW1DW2";
      PIO_RX_MEM_WR64_DW3           : state_ascii <=  "RX_MEM_WR64_DW3";
      PIO_RX_WAIT_STATE             : state_ascii <=  "RX_WAIT_STATE";
      PIO_RX_IO_WR_DW1DW2           : state_ascii <=  "RX_IO_WR_DW1DW2";
      PIO_RX_IO_MEM_WR_WAIT_STATE   : state_ascii <=  "RX_IO_MEM_WR_WAIT_STATE";
      default                       : state_ascii <=  "PIO 128 STATE ERR";
    endcase

  end
  // synthesis translate_on

endmodule // PIO_RX_ENGINE

