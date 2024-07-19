// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.1 (lin64) Build 2902540 Wed May 27 19:54:35 MDT 2020
// Date        : Thu Mar  3 13:24:44 2022
// Host        : endcap-tf2 running 64-bit Ubuntu 18.04.6 LTS
// Command     : write_verilog -force -mode funcsim -rename_top ge11_rx_fifo -prefix
//               ge11_rx_fifo_ ge11_rx_fifo_sim_netlist.v
// Design      : ge11_rx_fifo
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7vx690tffg1927-2
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "ge11_rx_fifo,fifo_generator_v13_2_5,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "fifo_generator_v13_2_5,Vivado 2020.1" *) 
(* NotValidForBitStream *)
module ge11_rx_fifo
   (rst,
    wr_clk,
    rd_clk,
    din,
    wr_en,
    rd_en,
    dout,
    full,
    empty,
    valid,
    wr_rst_busy,
    rd_rst_busy);
  input rst;
  (* x_interface_info = "xilinx.com:signal:clock:1.0 write_clk CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME write_clk, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.000, INSERT_VIP 0" *) input wr_clk;
  (* x_interface_info = "xilinx.com:signal:clock:1.0 read_clk CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME read_clk, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.000, INSERT_VIP 0" *) input rd_clk;
  (* x_interface_info = "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE WR_DATA" *) input [255:0]din;
  (* x_interface_info = "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE WR_EN" *) input wr_en;
  (* x_interface_info = "xilinx.com:interface:fifo_read:1.0 FIFO_READ RD_EN" *) input rd_en;
  (* x_interface_info = "xilinx.com:interface:fifo_read:1.0 FIFO_READ RD_DATA" *) output [255:0]dout;
  (* x_interface_info = "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE FULL" *) output full;
  (* x_interface_info = "xilinx.com:interface:fifo_read:1.0 FIFO_READ EMPTY" *) output empty;
  output valid;
  output wr_rst_busy;
  output rd_rst_busy;

  wire [255:0]din;
  wire [255:0]dout;
  wire empty;
  wire full;
  wire rd_clk;
  wire rd_en;
  wire rd_rst_busy;
  wire rst;
  wire valid;
  wire wr_clk;
  wire wr_en;
  wire wr_rst_busy;
  wire NLW_U0_almost_empty_UNCONNECTED;
  wire NLW_U0_almost_full_UNCONNECTED;
  wire NLW_U0_axi_ar_dbiterr_UNCONNECTED;
  wire NLW_U0_axi_ar_overflow_UNCONNECTED;
  wire NLW_U0_axi_ar_prog_empty_UNCONNECTED;
  wire NLW_U0_axi_ar_prog_full_UNCONNECTED;
  wire NLW_U0_axi_ar_sbiterr_UNCONNECTED;
  wire NLW_U0_axi_ar_underflow_UNCONNECTED;
  wire NLW_U0_axi_aw_dbiterr_UNCONNECTED;
  wire NLW_U0_axi_aw_overflow_UNCONNECTED;
  wire NLW_U0_axi_aw_prog_empty_UNCONNECTED;
  wire NLW_U0_axi_aw_prog_full_UNCONNECTED;
  wire NLW_U0_axi_aw_sbiterr_UNCONNECTED;
  wire NLW_U0_axi_aw_underflow_UNCONNECTED;
  wire NLW_U0_axi_b_dbiterr_UNCONNECTED;
  wire NLW_U0_axi_b_overflow_UNCONNECTED;
  wire NLW_U0_axi_b_prog_empty_UNCONNECTED;
  wire NLW_U0_axi_b_prog_full_UNCONNECTED;
  wire NLW_U0_axi_b_sbiterr_UNCONNECTED;
  wire NLW_U0_axi_b_underflow_UNCONNECTED;
  wire NLW_U0_axi_r_dbiterr_UNCONNECTED;
  wire NLW_U0_axi_r_overflow_UNCONNECTED;
  wire NLW_U0_axi_r_prog_empty_UNCONNECTED;
  wire NLW_U0_axi_r_prog_full_UNCONNECTED;
  wire NLW_U0_axi_r_sbiterr_UNCONNECTED;
  wire NLW_U0_axi_r_underflow_UNCONNECTED;
  wire NLW_U0_axi_w_dbiterr_UNCONNECTED;
  wire NLW_U0_axi_w_overflow_UNCONNECTED;
  wire NLW_U0_axi_w_prog_empty_UNCONNECTED;
  wire NLW_U0_axi_w_prog_full_UNCONNECTED;
  wire NLW_U0_axi_w_sbiterr_UNCONNECTED;
  wire NLW_U0_axi_w_underflow_UNCONNECTED;
  wire NLW_U0_axis_dbiterr_UNCONNECTED;
  wire NLW_U0_axis_overflow_UNCONNECTED;
  wire NLW_U0_axis_prog_empty_UNCONNECTED;
  wire NLW_U0_axis_prog_full_UNCONNECTED;
  wire NLW_U0_axis_sbiterr_UNCONNECTED;
  wire NLW_U0_axis_underflow_UNCONNECTED;
  wire NLW_U0_dbiterr_UNCONNECTED;
  wire NLW_U0_m_axi_arvalid_UNCONNECTED;
  wire NLW_U0_m_axi_awvalid_UNCONNECTED;
  wire NLW_U0_m_axi_bready_UNCONNECTED;
  wire NLW_U0_m_axi_rready_UNCONNECTED;
  wire NLW_U0_m_axi_wlast_UNCONNECTED;
  wire NLW_U0_m_axi_wvalid_UNCONNECTED;
  wire NLW_U0_m_axis_tlast_UNCONNECTED;
  wire NLW_U0_m_axis_tvalid_UNCONNECTED;
  wire NLW_U0_overflow_UNCONNECTED;
  wire NLW_U0_prog_empty_UNCONNECTED;
  wire NLW_U0_prog_full_UNCONNECTED;
  wire NLW_U0_s_axi_arready_UNCONNECTED;
  wire NLW_U0_s_axi_awready_UNCONNECTED;
  wire NLW_U0_s_axi_bvalid_UNCONNECTED;
  wire NLW_U0_s_axi_rlast_UNCONNECTED;
  wire NLW_U0_s_axi_rvalid_UNCONNECTED;
  wire NLW_U0_s_axi_wready_UNCONNECTED;
  wire NLW_U0_s_axis_tready_UNCONNECTED;
  wire NLW_U0_sbiterr_UNCONNECTED;
  wire NLW_U0_underflow_UNCONNECTED;
  wire NLW_U0_wr_ack_UNCONNECTED;
  wire [4:0]NLW_U0_axi_ar_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_ar_rd_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_ar_wr_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_aw_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_aw_rd_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_aw_wr_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_b_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_b_rd_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_b_wr_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_r_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_r_rd_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_r_wr_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_w_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_w_rd_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_w_wr_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axis_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axis_rd_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axis_wr_data_count_UNCONNECTED;
  wire [5:0]NLW_U0_data_count_UNCONNECTED;
  wire [31:0]NLW_U0_m_axi_araddr_UNCONNECTED;
  wire [1:0]NLW_U0_m_axi_arburst_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_arcache_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_arid_UNCONNECTED;
  wire [7:0]NLW_U0_m_axi_arlen_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_arlock_UNCONNECTED;
  wire [2:0]NLW_U0_m_axi_arprot_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_arqos_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_arregion_UNCONNECTED;
  wire [2:0]NLW_U0_m_axi_arsize_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_aruser_UNCONNECTED;
  wire [31:0]NLW_U0_m_axi_awaddr_UNCONNECTED;
  wire [1:0]NLW_U0_m_axi_awburst_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_awcache_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_awid_UNCONNECTED;
  wire [7:0]NLW_U0_m_axi_awlen_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_awlock_UNCONNECTED;
  wire [2:0]NLW_U0_m_axi_awprot_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_awqos_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_awregion_UNCONNECTED;
  wire [2:0]NLW_U0_m_axi_awsize_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_awuser_UNCONNECTED;
  wire [63:0]NLW_U0_m_axi_wdata_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_wid_UNCONNECTED;
  wire [7:0]NLW_U0_m_axi_wstrb_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_wuser_UNCONNECTED;
  wire [7:0]NLW_U0_m_axis_tdata_UNCONNECTED;
  wire [0:0]NLW_U0_m_axis_tdest_UNCONNECTED;
  wire [0:0]NLW_U0_m_axis_tid_UNCONNECTED;
  wire [0:0]NLW_U0_m_axis_tkeep_UNCONNECTED;
  wire [0:0]NLW_U0_m_axis_tstrb_UNCONNECTED;
  wire [3:0]NLW_U0_m_axis_tuser_UNCONNECTED;
  wire [5:0]NLW_U0_rd_data_count_UNCONNECTED;
  wire [0:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [0:0]NLW_U0_s_axi_buser_UNCONNECTED;
  wire [63:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [0:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;
  wire [0:0]NLW_U0_s_axi_ruser_UNCONNECTED;
  wire [5:0]NLW_U0_wr_data_count_UNCONNECTED;

  (* C_ADD_NGC_CONSTRAINT = "0" *) 
  (* C_APPLICATION_TYPE_AXIS = "0" *) 
  (* C_APPLICATION_TYPE_RACH = "0" *) 
  (* C_APPLICATION_TYPE_RDCH = "0" *) 
  (* C_APPLICATION_TYPE_WACH = "0" *) 
  (* C_APPLICATION_TYPE_WDCH = "0" *) 
  (* C_APPLICATION_TYPE_WRCH = "0" *) 
  (* C_AXIS_TDATA_WIDTH = "8" *) 
  (* C_AXIS_TDEST_WIDTH = "1" *) 
  (* C_AXIS_TID_WIDTH = "1" *) 
  (* C_AXIS_TKEEP_WIDTH = "1" *) 
  (* C_AXIS_TSTRB_WIDTH = "1" *) 
  (* C_AXIS_TUSER_WIDTH = "4" *) 
  (* C_AXIS_TYPE = "0" *) 
  (* C_AXI_ADDR_WIDTH = "32" *) 
  (* C_AXI_ARUSER_WIDTH = "1" *) 
  (* C_AXI_AWUSER_WIDTH = "1" *) 
  (* C_AXI_BUSER_WIDTH = "1" *) 
  (* C_AXI_DATA_WIDTH = "64" *) 
  (* C_AXI_ID_WIDTH = "1" *) 
  (* C_AXI_LEN_WIDTH = "8" *) 
  (* C_AXI_LOCK_WIDTH = "1" *) 
  (* C_AXI_RUSER_WIDTH = "1" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_AXI_WUSER_WIDTH = "1" *) 
  (* C_COMMON_CLOCK = "0" *) 
  (* C_COUNT_TYPE = "0" *) 
  (* C_DATA_COUNT_WIDTH = "6" *) 
  (* C_DEFAULT_VALUE = "BlankString" *) 
  (* C_DIN_WIDTH = "256" *) 
  (* C_DIN_WIDTH_AXIS = "1" *) 
  (* C_DIN_WIDTH_RACH = "32" *) 
  (* C_DIN_WIDTH_RDCH = "64" *) 
  (* C_DIN_WIDTH_WACH = "1" *) 
  (* C_DIN_WIDTH_WDCH = "64" *) 
  (* C_DIN_WIDTH_WRCH = "2" *) 
  (* C_DOUT_RST_VAL = "0" *) 
  (* C_DOUT_WIDTH = "256" *) 
  (* C_ENABLE_RLOCS = "0" *) 
  (* C_ENABLE_RST_SYNC = "1" *) 
  (* C_EN_SAFETY_CKT = "1" *) 
  (* C_ERROR_INJECTION_TYPE = "0" *) 
  (* C_ERROR_INJECTION_TYPE_AXIS = "0" *) 
  (* C_ERROR_INJECTION_TYPE_RACH = "0" *) 
  (* C_ERROR_INJECTION_TYPE_RDCH = "0" *) 
  (* C_ERROR_INJECTION_TYPE_WACH = "0" *) 
  (* C_ERROR_INJECTION_TYPE_WDCH = "0" *) 
  (* C_ERROR_INJECTION_TYPE_WRCH = "0" *) 
  (* C_FAMILY = "virtex7" *) 
  (* C_FULL_FLAGS_RST_VAL = "0" *) 
  (* C_HAS_ALMOST_EMPTY = "0" *) 
  (* C_HAS_ALMOST_FULL = "0" *) 
  (* C_HAS_AXIS_TDATA = "1" *) 
  (* C_HAS_AXIS_TDEST = "0" *) 
  (* C_HAS_AXIS_TID = "0" *) 
  (* C_HAS_AXIS_TKEEP = "0" *) 
  (* C_HAS_AXIS_TLAST = "0" *) 
  (* C_HAS_AXIS_TREADY = "1" *) 
  (* C_HAS_AXIS_TSTRB = "0" *) 
  (* C_HAS_AXIS_TUSER = "1" *) 
  (* C_HAS_AXI_ARUSER = "0" *) 
  (* C_HAS_AXI_AWUSER = "0" *) 
  (* C_HAS_AXI_BUSER = "0" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_AXI_RD_CHANNEL = "1" *) 
  (* C_HAS_AXI_RUSER = "0" *) 
  (* C_HAS_AXI_WR_CHANNEL = "1" *) 
  (* C_HAS_AXI_WUSER = "0" *) 
  (* C_HAS_BACKUP = "0" *) 
  (* C_HAS_DATA_COUNT = "0" *) 
  (* C_HAS_DATA_COUNTS_AXIS = "0" *) 
  (* C_HAS_DATA_COUNTS_RACH = "0" *) 
  (* C_HAS_DATA_COUNTS_RDCH = "0" *) 
  (* C_HAS_DATA_COUNTS_WACH = "0" *) 
  (* C_HAS_DATA_COUNTS_WDCH = "0" *) 
  (* C_HAS_DATA_COUNTS_WRCH = "0" *) 
  (* C_HAS_INT_CLK = "0" *) 
  (* C_HAS_MASTER_CE = "0" *) 
  (* C_HAS_MEMINIT_FILE = "0" *) 
  (* C_HAS_OVERFLOW = "0" *) 
  (* C_HAS_PROG_FLAGS_AXIS = "0" *) 
  (* C_HAS_PROG_FLAGS_RACH = "0" *) 
  (* C_HAS_PROG_FLAGS_RDCH = "0" *) 
  (* C_HAS_PROG_FLAGS_WACH = "0" *) 
  (* C_HAS_PROG_FLAGS_WDCH = "0" *) 
  (* C_HAS_PROG_FLAGS_WRCH = "0" *) 
  (* C_HAS_RD_DATA_COUNT = "0" *) 
  (* C_HAS_RD_RST = "0" *) 
  (* C_HAS_RST = "1" *) 
  (* C_HAS_SLAVE_CE = "0" *) 
  (* C_HAS_SRST = "0" *) 
  (* C_HAS_UNDERFLOW = "0" *) 
  (* C_HAS_VALID = "1" *) 
  (* C_HAS_WR_ACK = "0" *) 
  (* C_HAS_WR_DATA_COUNT = "0" *) 
  (* C_HAS_WR_RST = "0" *) 
  (* C_IMPLEMENTATION_TYPE = "2" *) 
  (* C_IMPLEMENTATION_TYPE_AXIS = "1" *) 
  (* C_IMPLEMENTATION_TYPE_RACH = "1" *) 
  (* C_IMPLEMENTATION_TYPE_RDCH = "1" *) 
  (* C_IMPLEMENTATION_TYPE_WACH = "1" *) 
  (* C_IMPLEMENTATION_TYPE_WDCH = "1" *) 
  (* C_IMPLEMENTATION_TYPE_WRCH = "1" *) 
  (* C_INIT_WR_PNTR_VAL = "0" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_MEMORY_TYPE = "1" *) 
  (* C_MIF_FILE_NAME = "BlankString" *) 
  (* C_MSGON_VAL = "1" *) 
  (* C_OPTIMIZATION_MODE = "0" *) 
  (* C_OVERFLOW_LOW = "0" *) 
  (* C_POWER_SAVING_MODE = "0" *) 
  (* C_PRELOAD_LATENCY = "2" *) 
  (* C_PRELOAD_REGS = "1" *) 
  (* C_PRIM_FIFO_TYPE = "512x72" *) 
  (* C_PRIM_FIFO_TYPE_AXIS = "1kx18" *) 
  (* C_PRIM_FIFO_TYPE_RACH = "512x36" *) 
  (* C_PRIM_FIFO_TYPE_RDCH = "1kx36" *) 
  (* C_PRIM_FIFO_TYPE_WACH = "512x36" *) 
  (* C_PRIM_FIFO_TYPE_WDCH = "1kx36" *) 
  (* C_PRIM_FIFO_TYPE_WRCH = "512x36" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL = "2" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_AXIS = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_RACH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_RDCH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_WACH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_WDCH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_WRCH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_NEGATE_VAL = "3" *) 
  (* C_PROG_EMPTY_TYPE = "0" *) 
  (* C_PROG_EMPTY_TYPE_AXIS = "0" *) 
  (* C_PROG_EMPTY_TYPE_RACH = "0" *) 
  (* C_PROG_EMPTY_TYPE_RDCH = "0" *) 
  (* C_PROG_EMPTY_TYPE_WACH = "0" *) 
  (* C_PROG_EMPTY_TYPE_WDCH = "0" *) 
  (* C_PROG_EMPTY_TYPE_WRCH = "0" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL = "61" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_AXIS = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_RACH = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_RDCH = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_WACH = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_WDCH = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_WRCH = "1023" *) 
  (* C_PROG_FULL_THRESH_NEGATE_VAL = "60" *) 
  (* C_PROG_FULL_TYPE = "0" *) 
  (* C_PROG_FULL_TYPE_AXIS = "0" *) 
  (* C_PROG_FULL_TYPE_RACH = "0" *) 
  (* C_PROG_FULL_TYPE_RDCH = "0" *) 
  (* C_PROG_FULL_TYPE_WACH = "0" *) 
  (* C_PROG_FULL_TYPE_WDCH = "0" *) 
  (* C_PROG_FULL_TYPE_WRCH = "0" *) 
  (* C_RACH_TYPE = "0" *) 
  (* C_RDCH_TYPE = "0" *) 
  (* C_RD_DATA_COUNT_WIDTH = "6" *) 
  (* C_RD_DEPTH = "64" *) 
  (* C_RD_FREQ = "1" *) 
  (* C_RD_PNTR_WIDTH = "6" *) 
  (* C_REG_SLICE_MODE_AXIS = "0" *) 
  (* C_REG_SLICE_MODE_RACH = "0" *) 
  (* C_REG_SLICE_MODE_RDCH = "0" *) 
  (* C_REG_SLICE_MODE_WACH = "0" *) 
  (* C_REG_SLICE_MODE_WDCH = "0" *) 
  (* C_REG_SLICE_MODE_WRCH = "0" *) 
  (* C_SELECT_XPM = "0" *) 
  (* C_SYNCHRONIZER_STAGE = "2" *) 
  (* C_UNDERFLOW_LOW = "0" *) 
  (* C_USE_COMMON_OVERFLOW = "0" *) 
  (* C_USE_COMMON_UNDERFLOW = "0" *) 
  (* C_USE_DEFAULT_SETTINGS = "0" *) 
  (* C_USE_DOUT_RST = "1" *) 
  (* C_USE_ECC = "0" *) 
  (* C_USE_ECC_AXIS = "0" *) 
  (* C_USE_ECC_RACH = "0" *) 
  (* C_USE_ECC_RDCH = "0" *) 
  (* C_USE_ECC_WACH = "0" *) 
  (* C_USE_ECC_WDCH = "0" *) 
  (* C_USE_ECC_WRCH = "0" *) 
  (* C_USE_EMBEDDED_REG = "3" *) 
  (* C_USE_FIFO16_FLAGS = "0" *) 
  (* C_USE_FWFT_DATA_COUNT = "0" *) 
  (* C_USE_PIPELINE_REG = "0" *) 
  (* C_VALID_LOW = "0" *) 
  (* C_WACH_TYPE = "0" *) 
  (* C_WDCH_TYPE = "0" *) 
  (* C_WRCH_TYPE = "0" *) 
  (* C_WR_ACK_LOW = "0" *) 
  (* C_WR_DATA_COUNT_WIDTH = "6" *) 
  (* C_WR_DEPTH = "64" *) 
  (* C_WR_DEPTH_AXIS = "1024" *) 
  (* C_WR_DEPTH_RACH = "16" *) 
  (* C_WR_DEPTH_RDCH = "1024" *) 
  (* C_WR_DEPTH_WACH = "16" *) 
  (* C_WR_DEPTH_WDCH = "1024" *) 
  (* C_WR_DEPTH_WRCH = "16" *) 
  (* C_WR_FREQ = "1" *) 
  (* C_WR_PNTR_WIDTH = "6" *) 
  (* C_WR_PNTR_WIDTH_AXIS = "10" *) 
  (* C_WR_PNTR_WIDTH_RACH = "4" *) 
  (* C_WR_PNTR_WIDTH_RDCH = "10" *) 
  (* C_WR_PNTR_WIDTH_WACH = "4" *) 
  (* C_WR_PNTR_WIDTH_WDCH = "10" *) 
  (* C_WR_PNTR_WIDTH_WRCH = "4" *) 
  (* C_WR_RESPONSE_LATENCY = "1" *) 
  (* KEEP_HIERARCHY = "soft" *) 
  ge11_rx_fifo_fifo_generator_v13_2_5 U0
       (.almost_empty(NLW_U0_almost_empty_UNCONNECTED),
        .almost_full(NLW_U0_almost_full_UNCONNECTED),
        .axi_ar_data_count(NLW_U0_axi_ar_data_count_UNCONNECTED[4:0]),
        .axi_ar_dbiterr(NLW_U0_axi_ar_dbiterr_UNCONNECTED),
        .axi_ar_injectdbiterr(1'b0),
        .axi_ar_injectsbiterr(1'b0),
        .axi_ar_overflow(NLW_U0_axi_ar_overflow_UNCONNECTED),
        .axi_ar_prog_empty(NLW_U0_axi_ar_prog_empty_UNCONNECTED),
        .axi_ar_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_ar_prog_full(NLW_U0_axi_ar_prog_full_UNCONNECTED),
        .axi_ar_prog_full_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_ar_rd_data_count(NLW_U0_axi_ar_rd_data_count_UNCONNECTED[4:0]),
        .axi_ar_sbiterr(NLW_U0_axi_ar_sbiterr_UNCONNECTED),
        .axi_ar_underflow(NLW_U0_axi_ar_underflow_UNCONNECTED),
        .axi_ar_wr_data_count(NLW_U0_axi_ar_wr_data_count_UNCONNECTED[4:0]),
        .axi_aw_data_count(NLW_U0_axi_aw_data_count_UNCONNECTED[4:0]),
        .axi_aw_dbiterr(NLW_U0_axi_aw_dbiterr_UNCONNECTED),
        .axi_aw_injectdbiterr(1'b0),
        .axi_aw_injectsbiterr(1'b0),
        .axi_aw_overflow(NLW_U0_axi_aw_overflow_UNCONNECTED),
        .axi_aw_prog_empty(NLW_U0_axi_aw_prog_empty_UNCONNECTED),
        .axi_aw_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_aw_prog_full(NLW_U0_axi_aw_prog_full_UNCONNECTED),
        .axi_aw_prog_full_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_aw_rd_data_count(NLW_U0_axi_aw_rd_data_count_UNCONNECTED[4:0]),
        .axi_aw_sbiterr(NLW_U0_axi_aw_sbiterr_UNCONNECTED),
        .axi_aw_underflow(NLW_U0_axi_aw_underflow_UNCONNECTED),
        .axi_aw_wr_data_count(NLW_U0_axi_aw_wr_data_count_UNCONNECTED[4:0]),
        .axi_b_data_count(NLW_U0_axi_b_data_count_UNCONNECTED[4:0]),
        .axi_b_dbiterr(NLW_U0_axi_b_dbiterr_UNCONNECTED),
        .axi_b_injectdbiterr(1'b0),
        .axi_b_injectsbiterr(1'b0),
        .axi_b_overflow(NLW_U0_axi_b_overflow_UNCONNECTED),
        .axi_b_prog_empty(NLW_U0_axi_b_prog_empty_UNCONNECTED),
        .axi_b_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_b_prog_full(NLW_U0_axi_b_prog_full_UNCONNECTED),
        .axi_b_prog_full_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_b_rd_data_count(NLW_U0_axi_b_rd_data_count_UNCONNECTED[4:0]),
        .axi_b_sbiterr(NLW_U0_axi_b_sbiterr_UNCONNECTED),
        .axi_b_underflow(NLW_U0_axi_b_underflow_UNCONNECTED),
        .axi_b_wr_data_count(NLW_U0_axi_b_wr_data_count_UNCONNECTED[4:0]),
        .axi_r_data_count(NLW_U0_axi_r_data_count_UNCONNECTED[10:0]),
        .axi_r_dbiterr(NLW_U0_axi_r_dbiterr_UNCONNECTED),
        .axi_r_injectdbiterr(1'b0),
        .axi_r_injectsbiterr(1'b0),
        .axi_r_overflow(NLW_U0_axi_r_overflow_UNCONNECTED),
        .axi_r_prog_empty(NLW_U0_axi_r_prog_empty_UNCONNECTED),
        .axi_r_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axi_r_prog_full(NLW_U0_axi_r_prog_full_UNCONNECTED),
        .axi_r_prog_full_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axi_r_rd_data_count(NLW_U0_axi_r_rd_data_count_UNCONNECTED[10:0]),
        .axi_r_sbiterr(NLW_U0_axi_r_sbiterr_UNCONNECTED),
        .axi_r_underflow(NLW_U0_axi_r_underflow_UNCONNECTED),
        .axi_r_wr_data_count(NLW_U0_axi_r_wr_data_count_UNCONNECTED[10:0]),
        .axi_w_data_count(NLW_U0_axi_w_data_count_UNCONNECTED[10:0]),
        .axi_w_dbiterr(NLW_U0_axi_w_dbiterr_UNCONNECTED),
        .axi_w_injectdbiterr(1'b0),
        .axi_w_injectsbiterr(1'b0),
        .axi_w_overflow(NLW_U0_axi_w_overflow_UNCONNECTED),
        .axi_w_prog_empty(NLW_U0_axi_w_prog_empty_UNCONNECTED),
        .axi_w_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axi_w_prog_full(NLW_U0_axi_w_prog_full_UNCONNECTED),
        .axi_w_prog_full_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axi_w_rd_data_count(NLW_U0_axi_w_rd_data_count_UNCONNECTED[10:0]),
        .axi_w_sbiterr(NLW_U0_axi_w_sbiterr_UNCONNECTED),
        .axi_w_underflow(NLW_U0_axi_w_underflow_UNCONNECTED),
        .axi_w_wr_data_count(NLW_U0_axi_w_wr_data_count_UNCONNECTED[10:0]),
        .axis_data_count(NLW_U0_axis_data_count_UNCONNECTED[10:0]),
        .axis_dbiterr(NLW_U0_axis_dbiterr_UNCONNECTED),
        .axis_injectdbiterr(1'b0),
        .axis_injectsbiterr(1'b0),
        .axis_overflow(NLW_U0_axis_overflow_UNCONNECTED),
        .axis_prog_empty(NLW_U0_axis_prog_empty_UNCONNECTED),
        .axis_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axis_prog_full(NLW_U0_axis_prog_full_UNCONNECTED),
        .axis_prog_full_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axis_rd_data_count(NLW_U0_axis_rd_data_count_UNCONNECTED[10:0]),
        .axis_sbiterr(NLW_U0_axis_sbiterr_UNCONNECTED),
        .axis_underflow(NLW_U0_axis_underflow_UNCONNECTED),
        .axis_wr_data_count(NLW_U0_axis_wr_data_count_UNCONNECTED[10:0]),
        .backup(1'b0),
        .backup_marker(1'b0),
        .clk(1'b0),
        .data_count(NLW_U0_data_count_UNCONNECTED[5:0]),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .din(din),
        .dout(dout),
        .empty(empty),
        .full(full),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .int_clk(1'b0),
        .m_aclk(1'b0),
        .m_aclk_en(1'b0),
        .m_axi_araddr(NLW_U0_m_axi_araddr_UNCONNECTED[31:0]),
        .m_axi_arburst(NLW_U0_m_axi_arburst_UNCONNECTED[1:0]),
        .m_axi_arcache(NLW_U0_m_axi_arcache_UNCONNECTED[3:0]),
        .m_axi_arid(NLW_U0_m_axi_arid_UNCONNECTED[0]),
        .m_axi_arlen(NLW_U0_m_axi_arlen_UNCONNECTED[7:0]),
        .m_axi_arlock(NLW_U0_m_axi_arlock_UNCONNECTED[0]),
        .m_axi_arprot(NLW_U0_m_axi_arprot_UNCONNECTED[2:0]),
        .m_axi_arqos(NLW_U0_m_axi_arqos_UNCONNECTED[3:0]),
        .m_axi_arready(1'b0),
        .m_axi_arregion(NLW_U0_m_axi_arregion_UNCONNECTED[3:0]),
        .m_axi_arsize(NLW_U0_m_axi_arsize_UNCONNECTED[2:0]),
        .m_axi_aruser(NLW_U0_m_axi_aruser_UNCONNECTED[0]),
        .m_axi_arvalid(NLW_U0_m_axi_arvalid_UNCONNECTED),
        .m_axi_awaddr(NLW_U0_m_axi_awaddr_UNCONNECTED[31:0]),
        .m_axi_awburst(NLW_U0_m_axi_awburst_UNCONNECTED[1:0]),
        .m_axi_awcache(NLW_U0_m_axi_awcache_UNCONNECTED[3:0]),
        .m_axi_awid(NLW_U0_m_axi_awid_UNCONNECTED[0]),
        .m_axi_awlen(NLW_U0_m_axi_awlen_UNCONNECTED[7:0]),
        .m_axi_awlock(NLW_U0_m_axi_awlock_UNCONNECTED[0]),
        .m_axi_awprot(NLW_U0_m_axi_awprot_UNCONNECTED[2:0]),
        .m_axi_awqos(NLW_U0_m_axi_awqos_UNCONNECTED[3:0]),
        .m_axi_awready(1'b0),
        .m_axi_awregion(NLW_U0_m_axi_awregion_UNCONNECTED[3:0]),
        .m_axi_awsize(NLW_U0_m_axi_awsize_UNCONNECTED[2:0]),
        .m_axi_awuser(NLW_U0_m_axi_awuser_UNCONNECTED[0]),
        .m_axi_awvalid(NLW_U0_m_axi_awvalid_UNCONNECTED),
        .m_axi_bid(1'b0),
        .m_axi_bready(NLW_U0_m_axi_bready_UNCONNECTED),
        .m_axi_bresp({1'b0,1'b0}),
        .m_axi_buser(1'b0),
        .m_axi_bvalid(1'b0),
        .m_axi_rdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .m_axi_rid(1'b0),
        .m_axi_rlast(1'b0),
        .m_axi_rready(NLW_U0_m_axi_rready_UNCONNECTED),
        .m_axi_rresp({1'b0,1'b0}),
        .m_axi_ruser(1'b0),
        .m_axi_rvalid(1'b0),
        .m_axi_wdata(NLW_U0_m_axi_wdata_UNCONNECTED[63:0]),
        .m_axi_wid(NLW_U0_m_axi_wid_UNCONNECTED[0]),
        .m_axi_wlast(NLW_U0_m_axi_wlast_UNCONNECTED),
        .m_axi_wready(1'b0),
        .m_axi_wstrb(NLW_U0_m_axi_wstrb_UNCONNECTED[7:0]),
        .m_axi_wuser(NLW_U0_m_axi_wuser_UNCONNECTED[0]),
        .m_axi_wvalid(NLW_U0_m_axi_wvalid_UNCONNECTED),
        .m_axis_tdata(NLW_U0_m_axis_tdata_UNCONNECTED[7:0]),
        .m_axis_tdest(NLW_U0_m_axis_tdest_UNCONNECTED[0]),
        .m_axis_tid(NLW_U0_m_axis_tid_UNCONNECTED[0]),
        .m_axis_tkeep(NLW_U0_m_axis_tkeep_UNCONNECTED[0]),
        .m_axis_tlast(NLW_U0_m_axis_tlast_UNCONNECTED),
        .m_axis_tready(1'b0),
        .m_axis_tstrb(NLW_U0_m_axis_tstrb_UNCONNECTED[0]),
        .m_axis_tuser(NLW_U0_m_axis_tuser_UNCONNECTED[3:0]),
        .m_axis_tvalid(NLW_U0_m_axis_tvalid_UNCONNECTED),
        .overflow(NLW_U0_overflow_UNCONNECTED),
        .prog_empty(NLW_U0_prog_empty_UNCONNECTED),
        .prog_empty_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_empty_thresh_assert({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_empty_thresh_negate({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_full(NLW_U0_prog_full_UNCONNECTED),
        .prog_full_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_full_thresh_assert({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_full_thresh_negate({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .rd_clk(rd_clk),
        .rd_data_count(NLW_U0_rd_data_count_UNCONNECTED[5:0]),
        .rd_en(rd_en),
        .rd_rst(1'b0),
        .rd_rst_busy(rd_rst_busy),
        .rst(rst),
        .s_aclk(1'b0),
        .s_aclk_en(1'b0),
        .s_aresetn(1'b0),
        .s_axi_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arburst({1'b0,1'b0}),
        .s_axi_arcache({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arid(1'b0),
        .s_axi_arlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arlock(1'b0),
        .s_axi_arprot({1'b0,1'b0,1'b0}),
        .s_axi_arqos({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arready(NLW_U0_s_axi_arready_UNCONNECTED),
        .s_axi_arregion({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arsize({1'b0,1'b0,1'b0}),
        .s_axi_aruser(1'b0),
        .s_axi_arvalid(1'b0),
        .s_axi_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awburst({1'b0,1'b0}),
        .s_axi_awcache({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awid(1'b0),
        .s_axi_awlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awlock(1'b0),
        .s_axi_awprot({1'b0,1'b0,1'b0}),
        .s_axi_awqos({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awready(NLW_U0_s_axi_awready_UNCONNECTED),
        .s_axi_awregion({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awsize({1'b0,1'b0,1'b0}),
        .s_axi_awuser(1'b0),
        .s_axi_awvalid(1'b0),
        .s_axi_bid(NLW_U0_s_axi_bid_UNCONNECTED[0]),
        .s_axi_bready(1'b0),
        .s_axi_bresp(NLW_U0_s_axi_bresp_UNCONNECTED[1:0]),
        .s_axi_buser(NLW_U0_s_axi_buser_UNCONNECTED[0]),
        .s_axi_bvalid(NLW_U0_s_axi_bvalid_UNCONNECTED),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[63:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_ruser(NLW_U0_s_axi_ruser_UNCONNECTED[0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wid(1'b0),
        .s_axi_wlast(1'b0),
        .s_axi_wready(NLW_U0_s_axi_wready_UNCONNECTED),
        .s_axi_wstrb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wuser(1'b0),
        .s_axi_wvalid(1'b0),
        .s_axis_tdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axis_tdest(1'b0),
        .s_axis_tid(1'b0),
        .s_axis_tkeep(1'b0),
        .s_axis_tlast(1'b0),
        .s_axis_tready(NLW_U0_s_axis_tready_UNCONNECTED),
        .s_axis_tstrb(1'b0),
        .s_axis_tuser({1'b0,1'b0,1'b0,1'b0}),
        .s_axis_tvalid(1'b0),
        .sbiterr(NLW_U0_sbiterr_UNCONNECTED),
        .sleep(1'b0),
        .srst(1'b0),
        .underflow(NLW_U0_underflow_UNCONNECTED),
        .valid(valid),
        .wr_ack(NLW_U0_wr_ack_UNCONNECTED),
        .wr_clk(wr_clk),
        .wr_data_count(NLW_U0_wr_data_count_UNCONNECTED[5:0]),
        .wr_en(wr_en),
        .wr_rst(1'b0),
        .wr_rst_busy(wr_rst_busy));
endmodule

(* DEST_SYNC_FF = "2" *) (* INIT_SYNC_FF = "0" *) (* REG_OUTPUT = "1" *) 
(* SIM_ASSERT_CHK = "0" *) (* SIM_LOSSLESS_GRAY_CHK = "0" *) (* VERSION = "0" *) 
(* WIDTH = "6" *) (* XPM_MODULE = "TRUE" *) (* keep_hierarchy = "true" *) 
(* xpm_cdc = "GRAY" *) 
module ge11_rx_fifo_xpm_cdc_gray
   (src_clk,
    src_in_bin,
    dest_clk,
    dest_out_bin);
  input src_clk;
  input [5:0]src_in_bin;
  input dest_clk;
  output [5:0]dest_out_bin;

  wire [5:0]async_path;
  wire [4:0]binval;
  wire dest_clk;
  (* RTL_KEEP = "true" *) (* async_reg = "true" *) (* xpm_cdc = "GRAY" *) wire [5:0]\dest_graysync_ff[0] ;
  (* RTL_KEEP = "true" *) (* async_reg = "true" *) (* xpm_cdc = "GRAY" *) wire [5:0]\dest_graysync_ff[1] ;
  wire [5:0]dest_out_bin;
  wire [4:0]gray_enc;
  wire src_clk;
  wire [5:0]src_in_bin;

  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[0][0] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path[0]),
        .Q(\dest_graysync_ff[0] [0]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[0][1] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path[1]),
        .Q(\dest_graysync_ff[0] [1]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[0][2] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path[2]),
        .Q(\dest_graysync_ff[0] [2]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[0][3] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path[3]),
        .Q(\dest_graysync_ff[0] [3]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[0][4] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path[4]),
        .Q(\dest_graysync_ff[0] [4]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[0][5] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path[5]),
        .Q(\dest_graysync_ff[0] [5]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[1][0] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[0] [0]),
        .Q(\dest_graysync_ff[1] [0]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[1][1] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[0] [1]),
        .Q(\dest_graysync_ff[1] [1]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[1][2] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[0] [2]),
        .Q(\dest_graysync_ff[1] [2]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[1][3] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[0] [3]),
        .Q(\dest_graysync_ff[1] [3]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[1][4] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[0] [4]),
        .Q(\dest_graysync_ff[1] [4]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[1][5] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[0] [5]),
        .Q(\dest_graysync_ff[1] [5]),
        .R(1'b0));
  LUT6 #(
    .INIT(64'h6996966996696996)) 
    \dest_out_bin_ff[0]_i_1 
       (.I0(\dest_graysync_ff[1] [0]),
        .I1(\dest_graysync_ff[1] [2]),
        .I2(\dest_graysync_ff[1] [4]),
        .I3(\dest_graysync_ff[1] [5]),
        .I4(\dest_graysync_ff[1] [3]),
        .I5(\dest_graysync_ff[1] [1]),
        .O(binval[0]));
  LUT5 #(
    .INIT(32'h96696996)) 
    \dest_out_bin_ff[1]_i_1 
       (.I0(\dest_graysync_ff[1] [1]),
        .I1(\dest_graysync_ff[1] [3]),
        .I2(\dest_graysync_ff[1] [5]),
        .I3(\dest_graysync_ff[1] [4]),
        .I4(\dest_graysync_ff[1] [2]),
        .O(binval[1]));
  LUT4 #(
    .INIT(16'h6996)) 
    \dest_out_bin_ff[2]_i_1 
       (.I0(\dest_graysync_ff[1] [2]),
        .I1(\dest_graysync_ff[1] [4]),
        .I2(\dest_graysync_ff[1] [5]),
        .I3(\dest_graysync_ff[1] [3]),
        .O(binval[2]));
  LUT3 #(
    .INIT(8'h96)) 
    \dest_out_bin_ff[3]_i_1 
       (.I0(\dest_graysync_ff[1] [3]),
        .I1(\dest_graysync_ff[1] [5]),
        .I2(\dest_graysync_ff[1] [4]),
        .O(binval[3]));
  LUT2 #(
    .INIT(4'h6)) 
    \dest_out_bin_ff[4]_i_1 
       (.I0(\dest_graysync_ff[1] [4]),
        .I1(\dest_graysync_ff[1] [5]),
        .O(binval[4]));
  FDRE \dest_out_bin_ff_reg[0] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(binval[0]),
        .Q(dest_out_bin[0]),
        .R(1'b0));
  FDRE \dest_out_bin_ff_reg[1] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(binval[1]),
        .Q(dest_out_bin[1]),
        .R(1'b0));
  FDRE \dest_out_bin_ff_reg[2] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(binval[2]),
        .Q(dest_out_bin[2]),
        .R(1'b0));
  FDRE \dest_out_bin_ff_reg[3] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(binval[3]),
        .Q(dest_out_bin[3]),
        .R(1'b0));
  FDRE \dest_out_bin_ff_reg[4] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(binval[4]),
        .Q(dest_out_bin[4]),
        .R(1'b0));
  FDRE \dest_out_bin_ff_reg[5] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[1] [5]),
        .Q(dest_out_bin[5]),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \src_gray_ff[0]_i_1 
       (.I0(src_in_bin[1]),
        .I1(src_in_bin[0]),
        .O(gray_enc[0]));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \src_gray_ff[1]_i_1 
       (.I0(src_in_bin[2]),
        .I1(src_in_bin[1]),
        .O(gray_enc[1]));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \src_gray_ff[2]_i_1 
       (.I0(src_in_bin[3]),
        .I1(src_in_bin[2]),
        .O(gray_enc[2]));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \src_gray_ff[3]_i_1 
       (.I0(src_in_bin[4]),
        .I1(src_in_bin[3]),
        .O(gray_enc[3]));
  LUT2 #(
    .INIT(4'h6)) 
    \src_gray_ff[4]_i_1 
       (.I0(src_in_bin[5]),
        .I1(src_in_bin[4]),
        .O(gray_enc[4]));
  FDRE \src_gray_ff_reg[0] 
       (.C(src_clk),
        .CE(1'b1),
        .D(gray_enc[0]),
        .Q(async_path[0]),
        .R(1'b0));
  FDRE \src_gray_ff_reg[1] 
       (.C(src_clk),
        .CE(1'b1),
        .D(gray_enc[1]),
        .Q(async_path[1]),
        .R(1'b0));
  FDRE \src_gray_ff_reg[2] 
       (.C(src_clk),
        .CE(1'b1),
        .D(gray_enc[2]),
        .Q(async_path[2]),
        .R(1'b0));
  FDRE \src_gray_ff_reg[3] 
       (.C(src_clk),
        .CE(1'b1),
        .D(gray_enc[3]),
        .Q(async_path[3]),
        .R(1'b0));
  FDRE \src_gray_ff_reg[4] 
       (.C(src_clk),
        .CE(1'b1),
        .D(gray_enc[4]),
        .Q(async_path[4]),
        .R(1'b0));
  FDRE \src_gray_ff_reg[5] 
       (.C(src_clk),
        .CE(1'b1),
        .D(src_in_bin[5]),
        .Q(async_path[5]),
        .R(1'b0));
endmodule

(* DEST_SYNC_FF = "2" *) (* INIT_SYNC_FF = "0" *) (* ORIG_REF_NAME = "xpm_cdc_gray" *) 
(* REG_OUTPUT = "1" *) (* SIM_ASSERT_CHK = "0" *) (* SIM_LOSSLESS_GRAY_CHK = "0" *) 
(* VERSION = "0" *) (* WIDTH = "6" *) (* XPM_MODULE = "TRUE" *) 
(* keep_hierarchy = "true" *) (* xpm_cdc = "GRAY" *) 
module ge11_rx_fifo_xpm_cdc_gray__2
   (src_clk,
    src_in_bin,
    dest_clk,
    dest_out_bin);
  input src_clk;
  input [5:0]src_in_bin;
  input dest_clk;
  output [5:0]dest_out_bin;

  wire [5:0]async_path;
  wire [4:0]binval;
  wire dest_clk;
  (* RTL_KEEP = "true" *) (* async_reg = "true" *) (* xpm_cdc = "GRAY" *) wire [5:0]\dest_graysync_ff[0] ;
  (* RTL_KEEP = "true" *) (* async_reg = "true" *) (* xpm_cdc = "GRAY" *) wire [5:0]\dest_graysync_ff[1] ;
  wire [5:0]dest_out_bin;
  wire [4:0]gray_enc;
  wire src_clk;
  wire [5:0]src_in_bin;

  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[0][0] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path[0]),
        .Q(\dest_graysync_ff[0] [0]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[0][1] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path[1]),
        .Q(\dest_graysync_ff[0] [1]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[0][2] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path[2]),
        .Q(\dest_graysync_ff[0] [2]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[0][3] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path[3]),
        .Q(\dest_graysync_ff[0] [3]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[0][4] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path[4]),
        .Q(\dest_graysync_ff[0] [4]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[0][5] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path[5]),
        .Q(\dest_graysync_ff[0] [5]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[1][0] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[0] [0]),
        .Q(\dest_graysync_ff[1] [0]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[1][1] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[0] [1]),
        .Q(\dest_graysync_ff[1] [1]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[1][2] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[0] [2]),
        .Q(\dest_graysync_ff[1] [2]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[1][3] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[0] [3]),
        .Q(\dest_graysync_ff[1] [3]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[1][4] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[0] [4]),
        .Q(\dest_graysync_ff[1] [4]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[1][5] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[0] [5]),
        .Q(\dest_graysync_ff[1] [5]),
        .R(1'b0));
  LUT6 #(
    .INIT(64'h6996966996696996)) 
    \dest_out_bin_ff[0]_i_1 
       (.I0(\dest_graysync_ff[1] [0]),
        .I1(\dest_graysync_ff[1] [2]),
        .I2(\dest_graysync_ff[1] [4]),
        .I3(\dest_graysync_ff[1] [5]),
        .I4(\dest_graysync_ff[1] [3]),
        .I5(\dest_graysync_ff[1] [1]),
        .O(binval[0]));
  LUT5 #(
    .INIT(32'h96696996)) 
    \dest_out_bin_ff[1]_i_1 
       (.I0(\dest_graysync_ff[1] [1]),
        .I1(\dest_graysync_ff[1] [3]),
        .I2(\dest_graysync_ff[1] [5]),
        .I3(\dest_graysync_ff[1] [4]),
        .I4(\dest_graysync_ff[1] [2]),
        .O(binval[1]));
  LUT4 #(
    .INIT(16'h6996)) 
    \dest_out_bin_ff[2]_i_1 
       (.I0(\dest_graysync_ff[1] [2]),
        .I1(\dest_graysync_ff[1] [4]),
        .I2(\dest_graysync_ff[1] [5]),
        .I3(\dest_graysync_ff[1] [3]),
        .O(binval[2]));
  LUT3 #(
    .INIT(8'h96)) 
    \dest_out_bin_ff[3]_i_1 
       (.I0(\dest_graysync_ff[1] [3]),
        .I1(\dest_graysync_ff[1] [5]),
        .I2(\dest_graysync_ff[1] [4]),
        .O(binval[3]));
  LUT2 #(
    .INIT(4'h6)) 
    \dest_out_bin_ff[4]_i_1 
       (.I0(\dest_graysync_ff[1] [4]),
        .I1(\dest_graysync_ff[1] [5]),
        .O(binval[4]));
  FDRE \dest_out_bin_ff_reg[0] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(binval[0]),
        .Q(dest_out_bin[0]),
        .R(1'b0));
  FDRE \dest_out_bin_ff_reg[1] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(binval[1]),
        .Q(dest_out_bin[1]),
        .R(1'b0));
  FDRE \dest_out_bin_ff_reg[2] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(binval[2]),
        .Q(dest_out_bin[2]),
        .R(1'b0));
  FDRE \dest_out_bin_ff_reg[3] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(binval[3]),
        .Q(dest_out_bin[3]),
        .R(1'b0));
  FDRE \dest_out_bin_ff_reg[4] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(binval[4]),
        .Q(dest_out_bin[4]),
        .R(1'b0));
  FDRE \dest_out_bin_ff_reg[5] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[1] [5]),
        .Q(dest_out_bin[5]),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \src_gray_ff[0]_i_1 
       (.I0(src_in_bin[1]),
        .I1(src_in_bin[0]),
        .O(gray_enc[0]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \src_gray_ff[1]_i_1 
       (.I0(src_in_bin[2]),
        .I1(src_in_bin[1]),
        .O(gray_enc[1]));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \src_gray_ff[2]_i_1 
       (.I0(src_in_bin[3]),
        .I1(src_in_bin[2]),
        .O(gray_enc[2]));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \src_gray_ff[3]_i_1 
       (.I0(src_in_bin[4]),
        .I1(src_in_bin[3]),
        .O(gray_enc[3]));
  LUT2 #(
    .INIT(4'h6)) 
    \src_gray_ff[4]_i_1 
       (.I0(src_in_bin[5]),
        .I1(src_in_bin[4]),
        .O(gray_enc[4]));
  FDRE \src_gray_ff_reg[0] 
       (.C(src_clk),
        .CE(1'b1),
        .D(gray_enc[0]),
        .Q(async_path[0]),
        .R(1'b0));
  FDRE \src_gray_ff_reg[1] 
       (.C(src_clk),
        .CE(1'b1),
        .D(gray_enc[1]),
        .Q(async_path[1]),
        .R(1'b0));
  FDRE \src_gray_ff_reg[2] 
       (.C(src_clk),
        .CE(1'b1),
        .D(gray_enc[2]),
        .Q(async_path[2]),
        .R(1'b0));
  FDRE \src_gray_ff_reg[3] 
       (.C(src_clk),
        .CE(1'b1),
        .D(gray_enc[3]),
        .Q(async_path[3]),
        .R(1'b0));
  FDRE \src_gray_ff_reg[4] 
       (.C(src_clk),
        .CE(1'b1),
        .D(gray_enc[4]),
        .Q(async_path[4]),
        .R(1'b0));
  FDRE \src_gray_ff_reg[5] 
       (.C(src_clk),
        .CE(1'b1),
        .D(src_in_bin[5]),
        .Q(async_path[5]),
        .R(1'b0));
endmodule

(* DEST_SYNC_FF = "5" *) (* INIT_SYNC_FF = "0" *) (* SIM_ASSERT_CHK = "0" *) 
(* SRC_INPUT_REG = "0" *) (* VERSION = "0" *) (* XPM_MODULE = "TRUE" *) 
(* keep_hierarchy = "true" *) (* xpm_cdc = "SINGLE" *) 
module ge11_rx_fifo_xpm_cdc_single
   (src_clk,
    src_in,
    dest_clk,
    dest_out);
  input src_clk;
  input src_in;
  input dest_clk;
  output dest_out;

  wire dest_clk;
  wire src_in;
  (* RTL_KEEP = "true" *) (* async_reg = "true" *) (* xpm_cdc = "SINGLE" *) wire [4:0]syncstages_ff;

  assign dest_out = syncstages_ff[4];
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "SINGLE" *) 
  FDRE \syncstages_ff_reg[0] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(src_in),
        .Q(syncstages_ff[0]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "SINGLE" *) 
  FDRE \syncstages_ff_reg[1] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(syncstages_ff[0]),
        .Q(syncstages_ff[1]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "SINGLE" *) 
  FDRE \syncstages_ff_reg[2] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(syncstages_ff[1]),
        .Q(syncstages_ff[2]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "SINGLE" *) 
  FDRE \syncstages_ff_reg[3] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(syncstages_ff[2]),
        .Q(syncstages_ff[3]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "SINGLE" *) 
  FDRE \syncstages_ff_reg[4] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(syncstages_ff[3]),
        .Q(syncstages_ff[4]),
        .R(1'b0));
endmodule

(* DEST_SYNC_FF = "5" *) (* INIT_SYNC_FF = "0" *) (* ORIG_REF_NAME = "xpm_cdc_single" *) 
(* SIM_ASSERT_CHK = "0" *) (* SRC_INPUT_REG = "0" *) (* VERSION = "0" *) 
(* XPM_MODULE = "TRUE" *) (* keep_hierarchy = "true" *) (* xpm_cdc = "SINGLE" *) 
module ge11_rx_fifo_xpm_cdc_single__2
   (src_clk,
    src_in,
    dest_clk,
    dest_out);
  input src_clk;
  input src_in;
  input dest_clk;
  output dest_out;

  wire dest_clk;
  wire src_in;
  (* RTL_KEEP = "true" *) (* async_reg = "true" *) (* xpm_cdc = "SINGLE" *) wire [4:0]syncstages_ff;

  assign dest_out = syncstages_ff[4];
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "SINGLE" *) 
  FDRE \syncstages_ff_reg[0] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(src_in),
        .Q(syncstages_ff[0]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "SINGLE" *) 
  FDRE \syncstages_ff_reg[1] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(syncstages_ff[0]),
        .Q(syncstages_ff[1]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "SINGLE" *) 
  FDRE \syncstages_ff_reg[2] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(syncstages_ff[1]),
        .Q(syncstages_ff[2]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "SINGLE" *) 
  FDRE \syncstages_ff_reg[3] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(syncstages_ff[2]),
        .Q(syncstages_ff[3]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "SINGLE" *) 
  FDRE \syncstages_ff_reg[4] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(syncstages_ff[3]),
        .Q(syncstages_ff[4]),
        .R(1'b0));
endmodule

(* DEF_VAL = "1'b1" *) (* DEST_SYNC_FF = "5" *) (* INIT = "1" *) 
(* INIT_SYNC_FF = "0" *) (* SIM_ASSERT_CHK = "0" *) (* VERSION = "0" *) 
(* XPM_MODULE = "TRUE" *) (* keep_hierarchy = "true" *) (* xpm_cdc = "SYNC_RST" *) 
module ge11_rx_fifo_xpm_cdc_sync_rst
   (src_rst,
    dest_clk,
    dest_rst);
  input src_rst;
  input dest_clk;
  output dest_rst;

  wire dest_clk;
  wire src_rst;
  (* RTL_KEEP = "true" *) (* async_reg = "true" *) (* xpm_cdc = "SYNC_RST" *) wire [4:0]syncstages_ff;

  assign dest_rst = syncstages_ff[4];
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "SYNC_RST" *) 
  FDRE #(
    .INIT(1'b1)) 
    \syncstages_ff_reg[0] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(src_rst),
        .Q(syncstages_ff[0]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "SYNC_RST" *) 
  FDRE #(
    .INIT(1'b1)) 
    \syncstages_ff_reg[1] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(syncstages_ff[0]),
        .Q(syncstages_ff[1]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "SYNC_RST" *) 
  FDRE #(
    .INIT(1'b1)) 
    \syncstages_ff_reg[2] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(syncstages_ff[1]),
        .Q(syncstages_ff[2]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "SYNC_RST" *) 
  FDRE #(
    .INIT(1'b1)) 
    \syncstages_ff_reg[3] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(syncstages_ff[2]),
        .Q(syncstages_ff[3]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "SYNC_RST" *) 
  FDRE #(
    .INIT(1'b1)) 
    \syncstages_ff_reg[4] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(syncstages_ff[3]),
        .Q(syncstages_ff[4]),
        .R(1'b0));
endmodule

(* DEF_VAL = "1'b1" *) (* DEST_SYNC_FF = "5" *) (* INIT = "1" *) 
(* INIT_SYNC_FF = "0" *) (* ORIG_REF_NAME = "xpm_cdc_sync_rst" *) (* SIM_ASSERT_CHK = "0" *) 
(* VERSION = "0" *) (* XPM_MODULE = "TRUE" *) (* keep_hierarchy = "true" *) 
(* xpm_cdc = "SYNC_RST" *) 
module ge11_rx_fifo_xpm_cdc_sync_rst__2
   (src_rst,
    dest_clk,
    dest_rst);
  input src_rst;
  input dest_clk;
  output dest_rst;

  wire dest_clk;
  wire src_rst;
  (* RTL_KEEP = "true" *) (* async_reg = "true" *) (* xpm_cdc = "SYNC_RST" *) wire [4:0]syncstages_ff;

  assign dest_rst = syncstages_ff[4];
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "SYNC_RST" *) 
  FDRE #(
    .INIT(1'b1)) 
    \syncstages_ff_reg[0] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(src_rst),
        .Q(syncstages_ff[0]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "SYNC_RST" *) 
  FDRE #(
    .INIT(1'b1)) 
    \syncstages_ff_reg[1] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(syncstages_ff[0]),
        .Q(syncstages_ff[1]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "SYNC_RST" *) 
  FDRE #(
    .INIT(1'b1)) 
    \syncstages_ff_reg[2] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(syncstages_ff[1]),
        .Q(syncstages_ff[2]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "SYNC_RST" *) 
  FDRE #(
    .INIT(1'b1)) 
    \syncstages_ff_reg[3] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(syncstages_ff[2]),
        .Q(syncstages_ff[3]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "SYNC_RST" *) 
  FDRE #(
    .INIT(1'b1)) 
    \syncstages_ff_reg[4] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(syncstages_ff[3]),
        .Q(syncstages_ff[4]),
        .R(1'b0));
endmodule

(* DEF_VAL = "1'b0" *) (* DEST_SYNC_FF = "3" *) (* INIT = "0" *) 
(* INIT_SYNC_FF = "0" *) (* ORIG_REF_NAME = "xpm_cdc_sync_rst" *) (* SIM_ASSERT_CHK = "0" *) 
(* VERSION = "0" *) (* XPM_MODULE = "TRUE" *) (* keep_hierarchy = "true" *) 
(* xpm_cdc = "SYNC_RST" *) 
module ge11_rx_fifo_xpm_cdc_sync_rst__parameterized2
   (src_rst,
    dest_clk,
    dest_rst);
  input src_rst;
  input dest_clk;
  output dest_rst;

  wire dest_clk;
  wire src_rst;
  (* RTL_KEEP = "true" *) (* async_reg = "true" *) (* xpm_cdc = "SYNC_RST" *) wire [2:0]syncstages_ff;

  assign dest_rst = syncstages_ff[2];
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "SYNC_RST" *) 
  FDRE #(
    .INIT(1'b0)) 
    \syncstages_ff_reg[0] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(src_rst),
        .Q(syncstages_ff[0]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "SYNC_RST" *) 
  FDRE #(
    .INIT(1'b0)) 
    \syncstages_ff_reg[1] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(syncstages_ff[0]),
        .Q(syncstages_ff[1]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "SYNC_RST" *) 
  FDRE #(
    .INIT(1'b0)) 
    \syncstages_ff_reg[2] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(syncstages_ff[1]),
        .Q(syncstages_ff[2]),
        .R(1'b0));
endmodule

module ge11_rx_fifo_blk_mem_gen_generic_cstr
   (dout,
    wr_clk,
    rd_clk,
    Q,
    \DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram ,
    din,
    E,
    SR,
    tmp_ram_rd_en_d1,
    rd_en,
    out,
    ram_rd_en_d1,
    FULL_FB,
    wr_en,
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 );
  output [255:0]dout;
  input wr_clk;
  input rd_clk;
  input [5:0]Q;
  input [5:0]\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram ;
  input [255:0]din;
  input [0:0]E;
  input [0:0]SR;
  input tmp_ram_rd_en_d1;
  input rd_en;
  input out;
  input ram_rd_en_d1;
  input FULL_FB;
  input wr_en;
  input [0:0]\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ;

  wire [5:0]\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram ;
  wire [0:0]E;
  wire ENA_I;
  wire ENB_I;
  wire FULL_FB;
  wire POR_B;
  wire [5:0]Q;
  wire [0:0]SR;
  wire [255:0]din;
  wire [255:0]dout;
  wire [255:0]doutb_array;
  wire [0:0]\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ;
  wire out;
  wire ram_rd_en_d1;
  wire rd_clk;
  wire rd_en;
  wire tmp_ram_rd_en_d1;
  wire tmp_ram_rd_std;
  wire wr_clk;
  wire wr_en;

  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[0] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[0]),
        .Q(dout[0]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[100] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[100]),
        .Q(dout[100]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[101] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[101]),
        .Q(dout[101]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[102] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[102]),
        .Q(dout[102]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[103] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[103]),
        .Q(dout[103]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[104] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[104]),
        .Q(dout[104]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[105] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[105]),
        .Q(dout[105]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[106] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[106]),
        .Q(dout[106]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[107] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[107]),
        .Q(dout[107]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[108] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[108]),
        .Q(dout[108]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[109] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[109]),
        .Q(dout[109]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[10] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[10]),
        .Q(dout[10]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[110] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[110]),
        .Q(dout[110]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[111] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[111]),
        .Q(dout[111]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[112] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[112]),
        .Q(dout[112]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[113] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[113]),
        .Q(dout[113]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[114] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[114]),
        .Q(dout[114]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[115] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[115]),
        .Q(dout[115]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[116] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[116]),
        .Q(dout[116]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[117] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[117]),
        .Q(dout[117]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[118] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[118]),
        .Q(dout[118]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[119] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[119]),
        .Q(dout[119]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[11] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[11]),
        .Q(dout[11]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[120] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[120]),
        .Q(dout[120]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[121] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[121]),
        .Q(dout[121]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[122] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[122]),
        .Q(dout[122]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[123] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[123]),
        .Q(dout[123]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[124] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[124]),
        .Q(dout[124]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[125] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[125]),
        .Q(dout[125]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[126] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[126]),
        .Q(dout[126]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[127] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[127]),
        .Q(dout[127]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[128] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[128]),
        .Q(dout[128]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[129] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[129]),
        .Q(dout[129]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[12] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[12]),
        .Q(dout[12]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[130] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[130]),
        .Q(dout[130]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[131] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[131]),
        .Q(dout[131]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[132] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[132]),
        .Q(dout[132]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[133] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[133]),
        .Q(dout[133]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[134] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[134]),
        .Q(dout[134]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[135] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[135]),
        .Q(dout[135]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[136] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[136]),
        .Q(dout[136]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[137] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[137]),
        .Q(dout[137]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[138] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[138]),
        .Q(dout[138]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[139] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[139]),
        .Q(dout[139]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[13] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[13]),
        .Q(dout[13]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[140] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[140]),
        .Q(dout[140]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[141] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[141]),
        .Q(dout[141]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[142] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[142]),
        .Q(dout[142]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[143] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[143]),
        .Q(dout[143]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[144] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[144]),
        .Q(dout[144]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[145] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[145]),
        .Q(dout[145]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[146] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[146]),
        .Q(dout[146]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[147] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[147]),
        .Q(dout[147]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[148] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[148]),
        .Q(dout[148]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[149] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[149]),
        .Q(dout[149]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[14] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[14]),
        .Q(dout[14]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[150] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[150]),
        .Q(dout[150]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[151] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[151]),
        .Q(dout[151]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[152] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[152]),
        .Q(dout[152]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[153] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[153]),
        .Q(dout[153]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[154] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[154]),
        .Q(dout[154]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[155] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[155]),
        .Q(dout[155]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[156] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[156]),
        .Q(dout[156]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[157] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[157]),
        .Q(dout[157]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[158] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[158]),
        .Q(dout[158]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[159] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[159]),
        .Q(dout[159]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[15] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[15]),
        .Q(dout[15]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[160] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[160]),
        .Q(dout[160]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[161] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[161]),
        .Q(dout[161]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[162] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[162]),
        .Q(dout[162]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[163] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[163]),
        .Q(dout[163]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[164] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[164]),
        .Q(dout[164]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[165] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[165]),
        .Q(dout[165]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[166] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[166]),
        .Q(dout[166]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[167] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[167]),
        .Q(dout[167]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[168] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[168]),
        .Q(dout[168]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[169] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[169]),
        .Q(dout[169]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[16] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[16]),
        .Q(dout[16]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[170] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[170]),
        .Q(dout[170]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[171] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[171]),
        .Q(dout[171]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[172] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[172]),
        .Q(dout[172]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[173] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[173]),
        .Q(dout[173]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[174] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[174]),
        .Q(dout[174]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[175] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[175]),
        .Q(dout[175]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[176] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[176]),
        .Q(dout[176]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[177] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[177]),
        .Q(dout[177]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[178] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[178]),
        .Q(dout[178]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[179] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[179]),
        .Q(dout[179]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[17] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[17]),
        .Q(dout[17]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[180] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[180]),
        .Q(dout[180]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[181] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[181]),
        .Q(dout[181]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[182] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[182]),
        .Q(dout[182]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[183] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[183]),
        .Q(dout[183]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[184] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[184]),
        .Q(dout[184]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[185] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[185]),
        .Q(dout[185]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[186] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[186]),
        .Q(dout[186]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[187] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[187]),
        .Q(dout[187]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[188] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[188]),
        .Q(dout[188]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[189] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[189]),
        .Q(dout[189]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[18] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[18]),
        .Q(dout[18]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[190] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[190]),
        .Q(dout[190]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[191] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[191]),
        .Q(dout[191]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[192] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[192]),
        .Q(dout[192]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[193] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[193]),
        .Q(dout[193]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[194] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[194]),
        .Q(dout[194]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[195] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[195]),
        .Q(dout[195]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[196] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[196]),
        .Q(dout[196]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[197] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[197]),
        .Q(dout[197]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[198] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[198]),
        .Q(dout[198]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[199] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[199]),
        .Q(dout[199]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[19] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[19]),
        .Q(dout[19]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[1] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[1]),
        .Q(dout[1]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[200] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[200]),
        .Q(dout[200]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[201] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[201]),
        .Q(dout[201]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[202] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[202]),
        .Q(dout[202]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[203] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[203]),
        .Q(dout[203]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[204] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[204]),
        .Q(dout[204]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[205] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[205]),
        .Q(dout[205]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[206] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[206]),
        .Q(dout[206]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[207] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[207]),
        .Q(dout[207]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[208] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[208]),
        .Q(dout[208]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[209] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[209]),
        .Q(dout[209]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[20] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[20]),
        .Q(dout[20]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[210] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[210]),
        .Q(dout[210]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[211] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[211]),
        .Q(dout[211]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[212] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[212]),
        .Q(dout[212]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[213] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[213]),
        .Q(dout[213]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[214] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[214]),
        .Q(dout[214]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[215] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[215]),
        .Q(dout[215]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[216] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[216]),
        .Q(dout[216]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[217] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[217]),
        .Q(dout[217]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[218] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[218]),
        .Q(dout[218]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[219] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[219]),
        .Q(dout[219]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[21] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[21]),
        .Q(dout[21]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[220] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[220]),
        .Q(dout[220]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[221] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[221]),
        .Q(dout[221]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[222] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[222]),
        .Q(dout[222]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[223] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[223]),
        .Q(dout[223]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[224] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[224]),
        .Q(dout[224]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[225] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[225]),
        .Q(dout[225]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[226] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[226]),
        .Q(dout[226]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[227] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[227]),
        .Q(dout[227]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[228] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[228]),
        .Q(dout[228]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[229] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[229]),
        .Q(dout[229]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[22] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[22]),
        .Q(dout[22]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[230] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[230]),
        .Q(dout[230]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[231] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[231]),
        .Q(dout[231]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[232] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[232]),
        .Q(dout[232]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[233] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[233]),
        .Q(dout[233]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[234] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[234]),
        .Q(dout[234]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[235] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[235]),
        .Q(dout[235]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[236] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[236]),
        .Q(dout[236]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[237] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[237]),
        .Q(dout[237]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[238] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[238]),
        .Q(dout[238]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[239] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[239]),
        .Q(dout[239]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[23] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[23]),
        .Q(dout[23]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[240] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[240]),
        .Q(dout[240]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[241] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[241]),
        .Q(dout[241]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[242] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[242]),
        .Q(dout[242]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[243] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[243]),
        .Q(dout[243]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[244] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[244]),
        .Q(dout[244]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[245] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[245]),
        .Q(dout[245]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[246] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[246]),
        .Q(dout[246]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[247] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[247]),
        .Q(dout[247]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[248] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[248]),
        .Q(dout[248]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[249] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[249]),
        .Q(dout[249]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[24] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[24]),
        .Q(dout[24]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[250] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[250]),
        .Q(dout[250]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[251] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[251]),
        .Q(dout[251]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[252] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[252]),
        .Q(dout[252]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[253] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[253]),
        .Q(dout[253]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[254] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[254]),
        .Q(dout[254]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[255]),
        .Q(dout[255]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[25] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[25]),
        .Q(dout[25]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[26] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[26]),
        .Q(dout[26]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[27] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[27]),
        .Q(dout[27]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[28] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[28]),
        .Q(dout[28]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[29] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[29]),
        .Q(dout[29]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[2] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[2]),
        .Q(dout[2]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[30] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[30]),
        .Q(dout[30]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[31] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[31]),
        .Q(dout[31]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[32] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[32]),
        .Q(dout[32]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[33] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[33]),
        .Q(dout[33]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[34] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[34]),
        .Q(dout[34]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[35] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[35]),
        .Q(dout[35]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[36] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[36]),
        .Q(dout[36]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[37] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[37]),
        .Q(dout[37]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[38] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[38]),
        .Q(dout[38]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[39] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[39]),
        .Q(dout[39]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[3] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[3]),
        .Q(dout[3]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[40] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[40]),
        .Q(dout[40]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[41] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[41]),
        .Q(dout[41]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[42] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[42]),
        .Q(dout[42]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[43] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[43]),
        .Q(dout[43]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[44] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[44]),
        .Q(dout[44]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[45] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[45]),
        .Q(dout[45]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[46] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[46]),
        .Q(dout[46]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[47] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[47]),
        .Q(dout[47]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[48] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[48]),
        .Q(dout[48]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[49] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[49]),
        .Q(dout[49]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[4] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[4]),
        .Q(dout[4]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[50] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[50]),
        .Q(dout[50]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[51] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[51]),
        .Q(dout[51]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[52] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[52]),
        .Q(dout[52]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[53] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[53]),
        .Q(dout[53]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[54] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[54]),
        .Q(dout[54]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[55] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[55]),
        .Q(dout[55]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[56] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[56]),
        .Q(dout[56]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[57] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[57]),
        .Q(dout[57]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[58] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[58]),
        .Q(dout[58]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[59] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[59]),
        .Q(dout[59]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[5] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[5]),
        .Q(dout[5]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[60] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[60]),
        .Q(dout[60]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[61] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[61]),
        .Q(dout[61]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[62] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[62]),
        .Q(dout[62]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[63] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[63]),
        .Q(dout[63]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[64] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[64]),
        .Q(dout[64]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[65] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[65]),
        .Q(dout[65]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[66] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[66]),
        .Q(dout[66]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[67] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[67]),
        .Q(dout[67]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[68] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[68]),
        .Q(dout[68]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[69] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[69]),
        .Q(dout[69]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[6] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[6]),
        .Q(dout[6]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[70] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[70]),
        .Q(dout[70]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[71] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[71]),
        .Q(dout[71]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[72] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[72]),
        .Q(dout[72]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[73] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[73]),
        .Q(dout[73]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[74] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[74]),
        .Q(dout[74]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[75] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[75]),
        .Q(dout[75]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[76] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[76]),
        .Q(dout[76]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[77] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[77]),
        .Q(dout[77]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[78] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[78]),
        .Q(dout[78]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[79] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[79]),
        .Q(dout[79]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[7] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[7]),
        .Q(dout[7]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[80] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[80]),
        .Q(dout[80]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[81] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[81]),
        .Q(dout[81]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[82] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[82]),
        .Q(dout[82]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[83] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[83]),
        .Q(dout[83]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[84] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[84]),
        .Q(dout[84]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[85] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[85]),
        .Q(dout[85]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[86] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[86]),
        .Q(dout[86]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[87] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[87]),
        .Q(dout[87]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[88] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[88]),
        .Q(dout[88]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[89] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[89]),
        .Q(dout[89]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[8] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[8]),
        .Q(dout[8]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[90] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[90]),
        .Q(dout[90]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[91] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[91]),
        .Q(dout[91]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[92] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[92]),
        .Q(dout[92]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[93] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[93]),
        .Q(dout[93]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[94] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[94]),
        .Q(dout[94]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[95] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[95]),
        .Q(dout[95]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[96] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[96]),
        .Q(dout[96]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[97] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[97]),
        .Q(dout[97]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[98] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[98]),
        .Q(dout[98]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[99] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[99]),
        .Q(dout[99]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[9] 
       (.C(rd_clk),
        .CE(\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 ),
        .D(doutb_array[9]),
        .Q(dout[9]),
        .R(SR));
  ge11_rx_fifo_blk_mem_gen_prim_width \ramloop[0].ram.r 
       (.D(doutb_array[71:0]),
        .\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram (\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram ),
        .E(E),
        .ENA_I(ENA_I),
        .ENB_I(ENB_I),
        .POR_B(POR_B),
        .Q(Q),
        .din(din[71:0]),
        .rd_clk(rd_clk),
        .tmp_ram_rd_std(tmp_ram_rd_std),
        .wr_clk(wr_clk));
  ge11_rx_fifo_blk_mem_gen_prim_width__parameterized0 \ramloop[1].ram.r 
       (.D(doutb_array[143:72]),
        .\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram (\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram ),
        .E(E),
        .ENA_I(ENA_I),
        .ENB_I(ENB_I),
        .POR_B(POR_B),
        .Q(Q),
        .din(din[143:72]),
        .rd_clk(rd_clk),
        .tmp_ram_rd_std(tmp_ram_rd_std),
        .wr_clk(wr_clk));
  ge11_rx_fifo_blk_mem_gen_prim_width__parameterized1 \ramloop[2].ram.r 
       (.D(doutb_array[215:144]),
        .\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram (\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram ),
        .E(E),
        .ENA_I(ENA_I),
        .ENB_I(ENB_I),
        .POR_B(POR_B),
        .Q(Q),
        .din(din[215:144]),
        .rd_clk(rd_clk),
        .tmp_ram_rd_std(tmp_ram_rd_std),
        .wr_clk(wr_clk));
  ge11_rx_fifo_blk_mem_gen_prim_width__parameterized2 \ramloop[3].ram.r 
       (.D(doutb_array[255:216]),
        .\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram (\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram ),
        .E(E),
        .ENA_I(ENA_I),
        .ENB_I(ENB_I),
        .FULL_FB(FULL_FB),
        .POR_B(POR_B),
        .Q(Q),
        .SR(SR),
        .din(din[255:216]),
        .out(out),
        .ram_rd_en_d1(ram_rd_en_d1),
        .rd_clk(rd_clk),
        .rd_en(rd_en),
        .tmp_ram_rd_en_d1(tmp_ram_rd_en_d1),
        .tmp_ram_rd_std(tmp_ram_rd_std),
        .wr_clk(wr_clk),
        .wr_en(wr_en));
endmodule

module ge11_rx_fifo_blk_mem_gen_prim_width
   (D,
    rd_clk,
    wr_clk,
    ENB_I,
    ENA_I,
    tmp_ram_rd_std,
    POR_B,
    Q,
    \DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram ,
    din,
    E);
  output [71:0]D;
  input rd_clk;
  input wr_clk;
  input ENB_I;
  input ENA_I;
  input tmp_ram_rd_std;
  input POR_B;
  input [5:0]Q;
  input [5:0]\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram ;
  input [71:0]din;
  input [0:0]E;

  wire [71:0]D;
  wire [5:0]\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram ;
  wire [0:0]E;
  wire ENA_I;
  wire ENB_I;
  wire POR_B;
  wire [5:0]Q;
  wire [71:0]din;
  wire rd_clk;
  wire tmp_ram_rd_std;
  wire wr_clk;

  ge11_rx_fifo_blk_mem_gen_prim_wrapper \prim_noinit.ram 
       (.D(D),
        .\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_0 (\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram ),
        .E(E),
        .ENA_I(ENA_I),
        .ENB_I(ENB_I),
        .POR_B(POR_B),
        .Q(Q),
        .din(din),
        .rd_clk(rd_clk),
        .tmp_ram_rd_std(tmp_ram_rd_std),
        .wr_clk(wr_clk));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_width" *) 
module ge11_rx_fifo_blk_mem_gen_prim_width__parameterized0
   (D,
    rd_clk,
    wr_clk,
    ENB_I,
    ENA_I,
    tmp_ram_rd_std,
    POR_B,
    Q,
    \DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram ,
    din,
    E);
  output [71:0]D;
  input rd_clk;
  input wr_clk;
  input ENB_I;
  input ENA_I;
  input tmp_ram_rd_std;
  input POR_B;
  input [5:0]Q;
  input [5:0]\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram ;
  input [71:0]din;
  input [0:0]E;

  wire [71:0]D;
  wire [5:0]\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram ;
  wire [0:0]E;
  wire ENA_I;
  wire ENB_I;
  wire POR_B;
  wire [5:0]Q;
  wire [71:0]din;
  wire rd_clk;
  wire tmp_ram_rd_std;
  wire wr_clk;

  ge11_rx_fifo_blk_mem_gen_prim_wrapper__parameterized0 \prim_noinit.ram 
       (.D(D),
        .\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_0 (\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram ),
        .E(E),
        .ENA_I(ENA_I),
        .ENB_I(ENB_I),
        .POR_B(POR_B),
        .Q(Q),
        .din(din),
        .rd_clk(rd_clk),
        .tmp_ram_rd_std(tmp_ram_rd_std),
        .wr_clk(wr_clk));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_width" *) 
module ge11_rx_fifo_blk_mem_gen_prim_width__parameterized1
   (D,
    rd_clk,
    wr_clk,
    ENB_I,
    ENA_I,
    tmp_ram_rd_std,
    POR_B,
    Q,
    \DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram ,
    din,
    E);
  output [71:0]D;
  input rd_clk;
  input wr_clk;
  input ENB_I;
  input ENA_I;
  input tmp_ram_rd_std;
  input POR_B;
  input [5:0]Q;
  input [5:0]\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram ;
  input [71:0]din;
  input [0:0]E;

  wire [71:0]D;
  wire [5:0]\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram ;
  wire [0:0]E;
  wire ENA_I;
  wire ENB_I;
  wire POR_B;
  wire [5:0]Q;
  wire [71:0]din;
  wire rd_clk;
  wire tmp_ram_rd_std;
  wire wr_clk;

  ge11_rx_fifo_blk_mem_gen_prim_wrapper__parameterized1 \prim_noinit.ram 
       (.D(D),
        .\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_0 (\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram ),
        .E(E),
        .ENA_I(ENA_I),
        .ENB_I(ENB_I),
        .POR_B(POR_B),
        .Q(Q),
        .din(din),
        .rd_clk(rd_clk),
        .tmp_ram_rd_std(tmp_ram_rd_std),
        .wr_clk(wr_clk));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_width" *) 
module ge11_rx_fifo_blk_mem_gen_prim_width__parameterized2
   (D,
    ENB_I,
    ENA_I,
    tmp_ram_rd_std,
    POR_B,
    wr_clk,
    rd_clk,
    Q,
    \DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram ,
    din,
    E,
    SR,
    tmp_ram_rd_en_d1,
    rd_en,
    out,
    ram_rd_en_d1,
    FULL_FB,
    wr_en);
  output [39:0]D;
  output ENB_I;
  output ENA_I;
  output tmp_ram_rd_std;
  output POR_B;
  input wr_clk;
  input rd_clk;
  input [5:0]Q;
  input [5:0]\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram ;
  input [39:0]din;
  input [0:0]E;
  input [0:0]SR;
  input tmp_ram_rd_en_d1;
  input rd_en;
  input out;
  input ram_rd_en_d1;
  input FULL_FB;
  input wr_en;

  wire [39:0]D;
  wire [5:0]\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram ;
  wire [0:0]E;
  wire ENA_I;
  wire ENA_dly_D;
  wire ENB_I;
  wire ENB_dly_reg;
  wire ENB_dly_reg_D;
  wire FULL_FB;
  wire POR_B;
  wire [5:0]Q;
  wire \SAFETY_CKT_GEN.ENA_NO_REG.ENA_dly_reg_srl2_i_1_n_0 ;
  wire \SAFETY_CKT_GEN.ENA_NO_REG.ENA_dly_reg_srl2_n_0 ;
  wire \SAFETY_CKT_GEN.POR_B_i_1_n_0 ;
  wire \SAFETY_CKT_GEN.RSTA_SHFT_REG_reg[3]_srl3_n_0 ;
  wire \SAFETY_CKT_GEN.RSTA_SHFT_REG_reg_n_0_[0] ;
  wire \SAFETY_CKT_GEN.RSTA_SHFT_REG_reg_n_0_[4] ;
  wire \SAFETY_CKT_GEN.RSTB_SHFT_REG_reg[3]_srl3_n_0 ;
  wire \SAFETY_CKT_GEN.RSTB_SHFT_REG_reg_n_0_[0] ;
  wire \SAFETY_CKT_GEN.RSTB_SHFT_REG_reg_n_0_[4] ;
  wire [0:0]SR;
  wire [39:0]din;
  wire out;
  wire ram_rd_en_d1;
  wire rd_clk;
  wire rd_en;
  wire tmp_ram_rd_en_d1;
  wire tmp_ram_rd_std;
  wire wr_clk;
  wire wr_en;

  FDRE #(
    .INIT(1'b0)) 
    \SAFETY_CKT_GEN.ENA_NO_REG.ENA_dly_D_reg 
       (.C(wr_clk),
        .CE(1'b1),
        .D(\SAFETY_CKT_GEN.ENA_NO_REG.ENA_dly_reg_srl2_n_0 ),
        .Q(ENA_dly_D),
        .R(1'b0));
  (* srl_bus_name = "U0/\inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.mem/gbm.gbmg.gbmgc.ngecc.bmg/inst_blk_mem_gen/gnbram.gnativebmg.native_blk_mem_gen/valid.cstr/ramloop " *) 
  (* srl_name = "U0/\inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.mem/gbm.gbmg.gbmgc.ngecc.bmg/inst_blk_mem_gen/gnbram.gnativebmg.native_blk_mem_gen/valid.cstr/ramloop[3].ram.r/SAFETY_CKT_GEN.ENA_NO_REG.ENA_dly_reg_srl2 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \SAFETY_CKT_GEN.ENA_NO_REG.ENA_dly_reg_srl2 
       (.A0(1'b1),
        .A1(1'b0),
        .A2(1'b0),
        .A3(1'b0),
        .CE(1'b1),
        .CLK(wr_clk),
        .D(\SAFETY_CKT_GEN.ENA_NO_REG.ENA_dly_reg_srl2_i_1_n_0 ),
        .Q(\SAFETY_CKT_GEN.ENA_NO_REG.ENA_dly_reg_srl2_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \SAFETY_CKT_GEN.ENA_NO_REG.ENA_dly_reg_srl2_i_1 
       (.I0(\SAFETY_CKT_GEN.RSTA_SHFT_REG_reg_n_0_[0] ),
        .I1(\SAFETY_CKT_GEN.RSTA_SHFT_REG_reg_n_0_[4] ),
        .O(\SAFETY_CKT_GEN.ENA_NO_REG.ENA_dly_reg_srl2_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \SAFETY_CKT_GEN.ENB_WITH_REG.ENB_dly_reg_D_reg 
       (.C(rd_clk),
        .CE(1'b1),
        .D(ENB_dly_reg),
        .Q(ENB_dly_reg_D),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \SAFETY_CKT_GEN.ENB_WITH_REG.ENB_dly_reg_reg 
       (.C(rd_clk),
        .CE(1'b1),
        .D(POR_B),
        .Q(ENB_dly_reg),
        .R(1'b0));
  LUT2 #(
    .INIT(4'h6)) 
    \SAFETY_CKT_GEN.POR_B_i_1 
       (.I0(\SAFETY_CKT_GEN.RSTB_SHFT_REG_reg_n_0_[0] ),
        .I1(\SAFETY_CKT_GEN.RSTB_SHFT_REG_reg_n_0_[4] ),
        .O(\SAFETY_CKT_GEN.POR_B_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \SAFETY_CKT_GEN.POR_B_reg 
       (.C(rd_clk),
        .CE(1'b1),
        .D(\SAFETY_CKT_GEN.POR_B_i_1_n_0 ),
        .Q(POR_B),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \SAFETY_CKT_GEN.RSTA_SHFT_REG_reg[0] 
       (.C(wr_clk),
        .CE(1'b1),
        .D(1'b1),
        .Q(\SAFETY_CKT_GEN.RSTA_SHFT_REG_reg_n_0_[0] ),
        .R(1'b0));
  (* srl_bus_name = "U0/\inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.mem/gbm.gbmg.gbmgc.ngecc.bmg/inst_blk_mem_gen/gnbram.gnativebmg.native_blk_mem_gen/valid.cstr/ramloop[3].ram.r/SAFETY_CKT_GEN.RSTA_SHFT_REG_reg " *) 
  (* srl_name = "U0/\inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.mem/gbm.gbmg.gbmgc.ngecc.bmg/inst_blk_mem_gen/gnbram.gnativebmg.native_blk_mem_gen/valid.cstr/ramloop[3].ram.r/SAFETY_CKT_GEN.RSTA_SHFT_REG_reg[3]_srl3 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \SAFETY_CKT_GEN.RSTA_SHFT_REG_reg[3]_srl3 
       (.A0(1'b0),
        .A1(1'b1),
        .A2(1'b0),
        .A3(1'b0),
        .CE(1'b1),
        .CLK(wr_clk),
        .D(\SAFETY_CKT_GEN.RSTA_SHFT_REG_reg_n_0_[0] ),
        .Q(\SAFETY_CKT_GEN.RSTA_SHFT_REG_reg[3]_srl3_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \SAFETY_CKT_GEN.RSTA_SHFT_REG_reg[4] 
       (.C(wr_clk),
        .CE(1'b1),
        .D(\SAFETY_CKT_GEN.RSTA_SHFT_REG_reg[3]_srl3_n_0 ),
        .Q(\SAFETY_CKT_GEN.RSTA_SHFT_REG_reg_n_0_[4] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \SAFETY_CKT_GEN.RSTB_SHFT_REG_reg[0] 
       (.C(rd_clk),
        .CE(1'b1),
        .D(1'b1),
        .Q(\SAFETY_CKT_GEN.RSTB_SHFT_REG_reg_n_0_[0] ),
        .R(1'b0));
  (* srl_bus_name = "U0/\inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.mem/gbm.gbmg.gbmgc.ngecc.bmg/inst_blk_mem_gen/gnbram.gnativebmg.native_blk_mem_gen/valid.cstr/ramloop[3].ram.r/SAFETY_CKT_GEN.RSTB_SHFT_REG_reg " *) 
  (* srl_name = "U0/\inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.mem/gbm.gbmg.gbmgc.ngecc.bmg/inst_blk_mem_gen/gnbram.gnativebmg.native_blk_mem_gen/valid.cstr/ramloop[3].ram.r/SAFETY_CKT_GEN.RSTB_SHFT_REG_reg[3]_srl3 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \SAFETY_CKT_GEN.RSTB_SHFT_REG_reg[3]_srl3 
       (.A0(1'b0),
        .A1(1'b1),
        .A2(1'b0),
        .A3(1'b0),
        .CE(1'b1),
        .CLK(rd_clk),
        .D(\SAFETY_CKT_GEN.RSTB_SHFT_REG_reg_n_0_[0] ),
        .Q(\SAFETY_CKT_GEN.RSTB_SHFT_REG_reg[3]_srl3_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \SAFETY_CKT_GEN.RSTB_SHFT_REG_reg[4] 
       (.C(rd_clk),
        .CE(1'b1),
        .D(\SAFETY_CKT_GEN.RSTB_SHFT_REG_reg[3]_srl3_n_0 ),
        .Q(\SAFETY_CKT_GEN.RSTB_SHFT_REG_reg_n_0_[4] ),
        .R(1'b0));
  ge11_rx_fifo_blk_mem_gen_prim_wrapper__parameterized2 \prim_noinit.ram 
       (.D(D),
        .\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_0 (POR_B),
        .\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_1 (\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram ),
        .E(E),
        .ENA_I(ENA_I),
        .ENA_dly_D(ENA_dly_D),
        .ENB_I(ENB_I),
        .ENB_dly_reg_D(ENB_dly_reg_D),
        .FULL_FB(FULL_FB),
        .Q(Q),
        .SR(SR),
        .din(din),
        .out(out),
        .ram_rd_en_d1(ram_rd_en_d1),
        .rd_clk(rd_clk),
        .rd_en(rd_en),
        .tmp_ram_rd_en_d1(tmp_ram_rd_en_d1),
        .tmp_ram_rd_std(tmp_ram_rd_std),
        .wr_clk(wr_clk),
        .wr_en(wr_en));
endmodule

module ge11_rx_fifo_blk_mem_gen_prim_wrapper
   (D,
    rd_clk,
    wr_clk,
    ENB_I,
    ENA_I,
    tmp_ram_rd_std,
    POR_B,
    Q,
    \DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_0 ,
    din,
    E);
  output [71:0]D;
  input rd_clk;
  input wr_clk;
  input ENB_I;
  input ENA_I;
  input tmp_ram_rd_std;
  input POR_B;
  input [5:0]Q;
  input [5:0]\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_0 ;
  input [71:0]din;
  input [0:0]E;

  wire [71:0]D;
  wire [5:0]\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_0 ;
  wire [0:0]E;
  wire ENA_I;
  wire ENB_I;
  wire POR_B;
  wire [5:0]Q;
  wire [71:0]din;
  wire rd_clk;
  wire tmp_ram_rd_std;
  wire wr_clk;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_CASCADEOUTA_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_CASCADEOUTB_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_DBITERR_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_SBITERR_UNCONNECTED ;
  wire [7:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_ECCPARITY_UNCONNECTED ;
  wire [8:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_RDADDRECC_UNCONNECTED ;

  (* box_type = "PRIMITIVE" *) 
  RAMB36E1 #(
    .DOA_REG(1),
    .DOB_REG(1),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INITP_00(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_04(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_05(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_06(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_07(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_08(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_09(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_00(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_04(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_05(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_06(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_07(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_08(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_09(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_10(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_11(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_12(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_13(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_14(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_15(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_16(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_17(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_18(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_19(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_20(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_21(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_22(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_23(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_24(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_25(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_26(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_27(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_28(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_29(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_30(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_31(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_32(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_33(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_34(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_35(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_36(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_37(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_38(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_39(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_40(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_41(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_42(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_43(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_44(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_45(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_46(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_47(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_48(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_49(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_4A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_4B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_4C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_4D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_4E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_4F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_50(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_51(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_52(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_53(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_54(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_55(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_56(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_57(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_58(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_59(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_60(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_61(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_62(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_63(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_64(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_65(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_66(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_67(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_68(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_69(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_70(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_71(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_72(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_73(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_74(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_75(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_76(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_77(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_78(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_79(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .INIT_FILE("NONE"),
    .IS_CLKARDCLK_INVERTED(1'b0),
    .IS_CLKBWRCLK_INVERTED(1'b0),
    .IS_ENARDEN_INVERTED(1'b0),
    .IS_ENBWREN_INVERTED(1'b0),
    .IS_RSTRAMARSTRAM_INVERTED(1'b0),
    .IS_RSTRAMB_INVERTED(1'b0),
    .IS_RSTREGARSTREG_INVERTED(1'b0),
    .IS_RSTREGB_INVERTED(1'b0),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("SDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(72),
    .READ_WIDTH_B(0),
    .RSTREG_PRIORITY_A("REGCE"),
    .RSTREG_PRIORITY_B("REGCE"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("WRITE_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(0),
    .WRITE_WIDTH_B(72)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram 
       (.ADDRARDADDR({1'b1,1'b0,1'b0,1'b0,Q,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1}),
        .ADDRBWRADDR({1'b1,1'b0,1'b0,1'b0,\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_0 ,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1}),
        .CASCADEINA(1'b0),
        .CASCADEINB(1'b0),
        .CASCADEOUTA(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_CASCADEOUTA_UNCONNECTED ),
        .CASCADEOUTB(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_CASCADEOUTB_UNCONNECTED ),
        .CLKARDCLK(rd_clk),
        .CLKBWRCLK(wr_clk),
        .DBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_DBITERR_UNCONNECTED ),
        .DIADI({din[34:27],din[25:18],din[16:9],din[7:0]}),
        .DIBDI({din[70:63],din[61:54],din[52:45],din[43:36]}),
        .DIPADIP({din[35],din[26],din[17],din[8]}),
        .DIPBDIP({din[71],din[62],din[53],din[44]}),
        .DOADO({D[34:27],D[25:18],D[16:9],D[7:0]}),
        .DOBDO({D[70:63],D[61:54],D[52:45],D[43:36]}),
        .DOPADOP({D[35],D[26],D[17],D[8]}),
        .DOPBDOP({D[71],D[62],D[53],D[44]}),
        .ECCPARITY(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_ECCPARITY_UNCONNECTED [7:0]),
        .ENARDEN(ENB_I),
        .ENBWREN(ENA_I),
        .INJECTDBITERR(1'b0),
        .INJECTSBITERR(1'b0),
        .RDADDRECC(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_RDADDRECC_UNCONNECTED [8:0]),
        .REGCEAREGCE(tmp_ram_rd_std),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(POR_B),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(POR_B),
        .RSTREGB(1'b0),
        .SBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_SBITERR_UNCONNECTED ),
        .WEA({1'b0,1'b0,1'b0,1'b0}),
        .WEBWE({E,E,E,E,E,E,E,E}));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_wrapper" *) 
module ge11_rx_fifo_blk_mem_gen_prim_wrapper__parameterized0
   (D,
    rd_clk,
    wr_clk,
    ENB_I,
    ENA_I,
    tmp_ram_rd_std,
    POR_B,
    Q,
    \DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_0 ,
    din,
    E);
  output [71:0]D;
  input rd_clk;
  input wr_clk;
  input ENB_I;
  input ENA_I;
  input tmp_ram_rd_std;
  input POR_B;
  input [5:0]Q;
  input [5:0]\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_0 ;
  input [71:0]din;
  input [0:0]E;

  wire [71:0]D;
  wire [5:0]\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_0 ;
  wire [0:0]E;
  wire ENA_I;
  wire ENB_I;
  wire POR_B;
  wire [5:0]Q;
  wire [71:0]din;
  wire rd_clk;
  wire tmp_ram_rd_std;
  wire wr_clk;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_CASCADEOUTA_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_CASCADEOUTB_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_DBITERR_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_SBITERR_UNCONNECTED ;
  wire [7:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_ECCPARITY_UNCONNECTED ;
  wire [8:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_RDADDRECC_UNCONNECTED ;

  (* box_type = "PRIMITIVE" *) 
  RAMB36E1 #(
    .DOA_REG(1),
    .DOB_REG(1),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INITP_00(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_04(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_05(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_06(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_07(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_08(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_09(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_00(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_04(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_05(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_06(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_07(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_08(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_09(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_10(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_11(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_12(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_13(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_14(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_15(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_16(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_17(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_18(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_19(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_20(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_21(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_22(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_23(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_24(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_25(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_26(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_27(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_28(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_29(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_30(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_31(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_32(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_33(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_34(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_35(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_36(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_37(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_38(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_39(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_40(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_41(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_42(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_43(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_44(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_45(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_46(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_47(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_48(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_49(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_4A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_4B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_4C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_4D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_4E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_4F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_50(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_51(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_52(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_53(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_54(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_55(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_56(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_57(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_58(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_59(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_60(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_61(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_62(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_63(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_64(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_65(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_66(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_67(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_68(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_69(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_70(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_71(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_72(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_73(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_74(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_75(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_76(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_77(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_78(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_79(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .INIT_FILE("NONE"),
    .IS_CLKARDCLK_INVERTED(1'b0),
    .IS_CLKBWRCLK_INVERTED(1'b0),
    .IS_ENARDEN_INVERTED(1'b0),
    .IS_ENBWREN_INVERTED(1'b0),
    .IS_RSTRAMARSTRAM_INVERTED(1'b0),
    .IS_RSTRAMB_INVERTED(1'b0),
    .IS_RSTREGARSTREG_INVERTED(1'b0),
    .IS_RSTREGB_INVERTED(1'b0),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("SDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(72),
    .READ_WIDTH_B(0),
    .RSTREG_PRIORITY_A("REGCE"),
    .RSTREG_PRIORITY_B("REGCE"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("WRITE_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(0),
    .WRITE_WIDTH_B(72)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram 
       (.ADDRARDADDR({1'b1,1'b0,1'b0,1'b0,Q,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1}),
        .ADDRBWRADDR({1'b1,1'b0,1'b0,1'b0,\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_0 ,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1}),
        .CASCADEINA(1'b0),
        .CASCADEINB(1'b0),
        .CASCADEOUTA(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_CASCADEOUTA_UNCONNECTED ),
        .CASCADEOUTB(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_CASCADEOUTB_UNCONNECTED ),
        .CLKARDCLK(rd_clk),
        .CLKBWRCLK(wr_clk),
        .DBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_DBITERR_UNCONNECTED ),
        .DIADI({din[34:27],din[25:18],din[16:9],din[7:0]}),
        .DIBDI({din[70:63],din[61:54],din[52:45],din[43:36]}),
        .DIPADIP({din[35],din[26],din[17],din[8]}),
        .DIPBDIP({din[71],din[62],din[53],din[44]}),
        .DOADO({D[34:27],D[25:18],D[16:9],D[7:0]}),
        .DOBDO({D[70:63],D[61:54],D[52:45],D[43:36]}),
        .DOPADOP({D[35],D[26],D[17],D[8]}),
        .DOPBDOP({D[71],D[62],D[53],D[44]}),
        .ECCPARITY(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_ECCPARITY_UNCONNECTED [7:0]),
        .ENARDEN(ENB_I),
        .ENBWREN(ENA_I),
        .INJECTDBITERR(1'b0),
        .INJECTSBITERR(1'b0),
        .RDADDRECC(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_RDADDRECC_UNCONNECTED [8:0]),
        .REGCEAREGCE(tmp_ram_rd_std),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(POR_B),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(POR_B),
        .RSTREGB(1'b0),
        .SBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_SBITERR_UNCONNECTED ),
        .WEA({1'b0,1'b0,1'b0,1'b0}),
        .WEBWE({E,E,E,E,E,E,E,E}));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_wrapper" *) 
module ge11_rx_fifo_blk_mem_gen_prim_wrapper__parameterized1
   (D,
    rd_clk,
    wr_clk,
    ENB_I,
    ENA_I,
    tmp_ram_rd_std,
    POR_B,
    Q,
    \DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_0 ,
    din,
    E);
  output [71:0]D;
  input rd_clk;
  input wr_clk;
  input ENB_I;
  input ENA_I;
  input tmp_ram_rd_std;
  input POR_B;
  input [5:0]Q;
  input [5:0]\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_0 ;
  input [71:0]din;
  input [0:0]E;

  wire [71:0]D;
  wire [5:0]\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_0 ;
  wire [0:0]E;
  wire ENA_I;
  wire ENB_I;
  wire POR_B;
  wire [5:0]Q;
  wire [71:0]din;
  wire rd_clk;
  wire tmp_ram_rd_std;
  wire wr_clk;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_CASCADEOUTA_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_CASCADEOUTB_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_DBITERR_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_SBITERR_UNCONNECTED ;
  wire [7:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_ECCPARITY_UNCONNECTED ;
  wire [8:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_RDADDRECC_UNCONNECTED ;

  (* box_type = "PRIMITIVE" *) 
  RAMB36E1 #(
    .DOA_REG(1),
    .DOB_REG(1),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INITP_00(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_04(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_05(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_06(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_07(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_08(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_09(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_00(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_04(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_05(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_06(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_07(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_08(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_09(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_10(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_11(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_12(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_13(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_14(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_15(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_16(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_17(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_18(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_19(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_20(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_21(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_22(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_23(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_24(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_25(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_26(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_27(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_28(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_29(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_30(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_31(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_32(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_33(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_34(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_35(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_36(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_37(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_38(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_39(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_40(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_41(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_42(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_43(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_44(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_45(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_46(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_47(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_48(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_49(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_4A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_4B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_4C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_4D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_4E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_4F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_50(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_51(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_52(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_53(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_54(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_55(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_56(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_57(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_58(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_59(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_60(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_61(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_62(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_63(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_64(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_65(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_66(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_67(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_68(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_69(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_70(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_71(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_72(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_73(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_74(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_75(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_76(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_77(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_78(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_79(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .INIT_FILE("NONE"),
    .IS_CLKARDCLK_INVERTED(1'b0),
    .IS_CLKBWRCLK_INVERTED(1'b0),
    .IS_ENARDEN_INVERTED(1'b0),
    .IS_ENBWREN_INVERTED(1'b0),
    .IS_RSTRAMARSTRAM_INVERTED(1'b0),
    .IS_RSTRAMB_INVERTED(1'b0),
    .IS_RSTREGARSTREG_INVERTED(1'b0),
    .IS_RSTREGB_INVERTED(1'b0),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("SDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(72),
    .READ_WIDTH_B(0),
    .RSTREG_PRIORITY_A("REGCE"),
    .RSTREG_PRIORITY_B("REGCE"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("WRITE_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(0),
    .WRITE_WIDTH_B(72)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram 
       (.ADDRARDADDR({1'b1,1'b0,1'b0,1'b0,Q,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1}),
        .ADDRBWRADDR({1'b1,1'b0,1'b0,1'b0,\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_0 ,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1}),
        .CASCADEINA(1'b0),
        .CASCADEINB(1'b0),
        .CASCADEOUTA(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_CASCADEOUTA_UNCONNECTED ),
        .CASCADEOUTB(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_CASCADEOUTB_UNCONNECTED ),
        .CLKARDCLK(rd_clk),
        .CLKBWRCLK(wr_clk),
        .DBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_DBITERR_UNCONNECTED ),
        .DIADI({din[34:27],din[25:18],din[16:9],din[7:0]}),
        .DIBDI({din[70:63],din[61:54],din[52:45],din[43:36]}),
        .DIPADIP({din[35],din[26],din[17],din[8]}),
        .DIPBDIP({din[71],din[62],din[53],din[44]}),
        .DOADO({D[34:27],D[25:18],D[16:9],D[7:0]}),
        .DOBDO({D[70:63],D[61:54],D[52:45],D[43:36]}),
        .DOPADOP({D[35],D[26],D[17],D[8]}),
        .DOPBDOP({D[71],D[62],D[53],D[44]}),
        .ECCPARITY(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_ECCPARITY_UNCONNECTED [7:0]),
        .ENARDEN(ENB_I),
        .ENBWREN(ENA_I),
        .INJECTDBITERR(1'b0),
        .INJECTSBITERR(1'b0),
        .RDADDRECC(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_RDADDRECC_UNCONNECTED [8:0]),
        .REGCEAREGCE(tmp_ram_rd_std),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(POR_B),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(POR_B),
        .RSTREGB(1'b0),
        .SBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_SBITERR_UNCONNECTED ),
        .WEA({1'b0,1'b0,1'b0,1'b0}),
        .WEBWE({E,E,E,E,E,E,E,E}));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_wrapper" *) 
module ge11_rx_fifo_blk_mem_gen_prim_wrapper__parameterized2
   (D,
    ENB_I,
    ENA_I,
    tmp_ram_rd_std,
    rd_clk,
    wr_clk,
    \DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_0 ,
    Q,
    \DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_1 ,
    din,
    E,
    SR,
    tmp_ram_rd_en_d1,
    rd_en,
    out,
    ram_rd_en_d1,
    ENB_dly_reg_D,
    ENA_dly_D,
    FULL_FB,
    wr_en);
  output [39:0]D;
  output ENB_I;
  output ENA_I;
  output tmp_ram_rd_std;
  input rd_clk;
  input wr_clk;
  input \DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_0 ;
  input [5:0]Q;
  input [5:0]\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_1 ;
  input [39:0]din;
  input [0:0]E;
  input [0:0]SR;
  input tmp_ram_rd_en_d1;
  input rd_en;
  input out;
  input ram_rd_en_d1;
  input ENB_dly_reg_D;
  input ENA_dly_D;
  input FULL_FB;
  input wr_en;

  wire [39:0]D;
  wire \DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_0 ;
  wire [5:0]\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_1 ;
  wire \DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_n_12 ;
  wire \DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_n_13 ;
  wire \DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_n_14 ;
  wire \DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_n_20 ;
  wire \DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_n_21 ;
  wire \DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_n_22 ;
  wire \DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_n_28 ;
  wire \DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_n_29 ;
  wire \DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_n_30 ;
  wire \DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_n_36 ;
  wire \DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_n_37 ;
  wire \DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_n_38 ;
  wire \DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_n_4 ;
  wire \DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_n_44 ;
  wire \DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_n_45 ;
  wire \DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_n_46 ;
  wire \DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_n_5 ;
  wire \DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_n_52 ;
  wire \DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_n_53 ;
  wire \DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_n_54 ;
  wire \DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_n_6 ;
  wire \DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_n_60 ;
  wire \DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_n_61 ;
  wire \DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_n_62 ;
  wire \DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_n_68 ;
  wire \DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_n_69 ;
  wire \DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_n_70 ;
  wire \DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_n_71 ;
  wire \DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_n_72 ;
  wire \DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_n_73 ;
  wire \DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_n_74 ;
  wire \DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_n_75 ;
  wire [0:0]E;
  wire ENA_I;
  wire ENA_dly_D;
  wire ENB_I;
  wire ENB_dly_reg_D;
  wire FULL_FB;
  wire [5:0]Q;
  wire [0:0]SR;
  wire [39:0]din;
  wire out;
  wire ram_rd_en_d1;
  wire rd_clk;
  wire rd_en;
  wire tmp_ram_rd_en_d1;
  wire tmp_ram_rd_std;
  wire wr_clk;
  wire wr_en;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_CASCADEOUTA_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_CASCADEOUTB_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_DBITERR_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_SBITERR_UNCONNECTED ;
  wire [7:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_ECCPARITY_UNCONNECTED ;
  wire [8:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_RDADDRECC_UNCONNECTED ;

  (* box_type = "PRIMITIVE" *) 
  RAMB36E1 #(
    .DOA_REG(1),
    .DOB_REG(1),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INITP_00(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_04(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_05(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_06(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_07(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_08(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_09(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_00(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_04(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_05(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_06(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_07(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_08(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_09(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_10(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_11(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_12(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_13(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_14(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_15(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_16(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_17(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_18(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_19(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_20(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_21(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_22(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_23(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_24(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_25(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_26(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_27(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_28(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_29(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_30(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_31(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_32(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_33(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_34(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_35(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_36(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_37(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_38(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_39(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_40(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_41(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_42(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_43(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_44(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_45(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_46(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_47(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_48(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_49(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_4A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_4B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_4C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_4D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_4E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_4F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_50(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_51(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_52(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_53(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_54(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_55(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_56(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_57(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_58(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_59(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_60(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_61(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_62(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_63(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_64(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_65(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_66(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_67(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_68(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_69(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_70(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_71(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_72(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_73(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_74(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_75(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_76(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_77(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_78(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_79(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .INIT_FILE("NONE"),
    .IS_CLKARDCLK_INVERTED(1'b0),
    .IS_CLKBWRCLK_INVERTED(1'b0),
    .IS_ENARDEN_INVERTED(1'b0),
    .IS_ENBWREN_INVERTED(1'b0),
    .IS_RSTRAMARSTRAM_INVERTED(1'b0),
    .IS_RSTRAMB_INVERTED(1'b0),
    .IS_RSTREGARSTREG_INVERTED(1'b0),
    .IS_RSTREGB_INVERTED(1'b0),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("SDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(72),
    .READ_WIDTH_B(0),
    .RSTREG_PRIORITY_A("REGCE"),
    .RSTREG_PRIORITY_B("REGCE"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("WRITE_FIRST"),
    .WRITE_MODE_B("WRITE_FIRST"),
    .WRITE_WIDTH_A(0),
    .WRITE_WIDTH_B(72)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram 
       (.ADDRARDADDR({1'b1,1'b0,1'b0,1'b0,Q,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1}),
        .ADDRBWRADDR({1'b1,1'b0,1'b0,1'b0,\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_1 ,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1}),
        .CASCADEINA(1'b0),
        .CASCADEINB(1'b0),
        .CASCADEOUTA(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_CASCADEOUTA_UNCONNECTED ),
        .CASCADEOUTB(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_CASCADEOUTB_UNCONNECTED ),
        .CLKARDCLK(rd_clk),
        .CLKBWRCLK(wr_clk),
        .DBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_DBITERR_UNCONNECTED ),
        .DIADI({1'b0,1'b0,1'b0,din[19:15],1'b0,1'b0,1'b0,din[14:10],1'b0,1'b0,1'b0,din[9:5],1'b0,1'b0,1'b0,din[4:0]}),
        .DIBDI({1'b0,1'b0,1'b0,din[39:35],1'b0,1'b0,1'b0,din[34:30],1'b0,1'b0,1'b0,din[29:25],1'b0,1'b0,1'b0,din[24:20]}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO({\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_n_4 ,\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_n_5 ,\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_n_6 ,D[19:15],\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_n_12 ,\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_n_13 ,\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_n_14 ,D[14:10],\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_n_20 ,\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_n_21 ,\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_n_22 ,D[9:5],\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_n_28 ,\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_n_29 ,\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_n_30 ,D[4:0]}),
        .DOBDO({\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_n_36 ,\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_n_37 ,\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_n_38 ,D[39:35],\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_n_44 ,\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_n_45 ,\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_n_46 ,D[34:30],\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_n_52 ,\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_n_53 ,\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_n_54 ,D[29:25],\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_n_60 ,\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_n_61 ,\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_n_62 ,D[24:20]}),
        .DOPADOP({\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_n_68 ,\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_n_69 ,\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_n_70 ,\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_n_71 }),
        .DOPBDOP({\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_n_72 ,\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_n_73 ,\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_n_74 ,\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_n_75 }),
        .ECCPARITY(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_ECCPARITY_UNCONNECTED [7:0]),
        .ENARDEN(ENB_I),
        .ENBWREN(ENA_I),
        .INJECTDBITERR(1'b0),
        .INJECTSBITERR(1'b0),
        .RDADDRECC(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_RDADDRECC_UNCONNECTED [8:0]),
        .REGCEAREGCE(tmp_ram_rd_std),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_0 ),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_0 ),
        .RSTREGB(1'b0),
        .SBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_SBITERR_UNCONNECTED ),
        .WEA({1'b0,1'b0,1'b0,1'b0}),
        .WEBWE({E,E,E,E,E,E,E,E}));
  LUT6 #(
    .INIT(64'hFFFEFFFFFFFEFFFE)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_i_1 
       (.I0(SR),
        .I1(tmp_ram_rd_en_d1),
        .I2(ENB_dly_reg_D),
        .I3(ram_rd_en_d1),
        .I4(out),
        .I5(rd_en),
        .O(ENB_I));
  LUT3 #(
    .INIT(8'hBA)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_i_2 
       (.I0(ENA_dly_D),
        .I1(FULL_FB),
        .I2(wr_en),
        .O(ENA_I));
  LUT5 #(
    .INIT(32'hFFFFEEFE)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_i_3 
       (.I0(SR),
        .I1(tmp_ram_rd_en_d1),
        .I2(rd_en),
        .I3(out),
        .I4(ram_rd_en_d1),
        .O(tmp_ram_rd_std));
endmodule

module ge11_rx_fifo_blk_mem_gen_top
   (dout,
    wr_clk,
    rd_clk,
    Q,
    \DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram ,
    din,
    E,
    SR,
    tmp_ram_rd_en_d1,
    rd_en,
    out,
    ram_rd_en_d1,
    FULL_FB,
    wr_en,
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255] );
  output [255:0]dout;
  input wr_clk;
  input rd_clk;
  input [5:0]Q;
  input [5:0]\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram ;
  input [255:0]din;
  input [0:0]E;
  input [0:0]SR;
  input tmp_ram_rd_en_d1;
  input rd_en;
  input out;
  input ram_rd_en_d1;
  input FULL_FB;
  input wr_en;
  input [0:0]\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255] ;

  wire [5:0]\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram ;
  wire [0:0]E;
  wire FULL_FB;
  wire [5:0]Q;
  wire [0:0]SR;
  wire [255:0]din;
  wire [255:0]dout;
  wire [0:0]\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255] ;
  wire out;
  wire ram_rd_en_d1;
  wire rd_clk;
  wire rd_en;
  wire tmp_ram_rd_en_d1;
  wire wr_clk;
  wire wr_en;

  ge11_rx_fifo_blk_mem_gen_generic_cstr \valid.cstr 
       (.\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram (\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram ),
        .E(E),
        .FULL_FB(FULL_FB),
        .Q(Q),
        .SR(SR),
        .din(din),
        .dout(dout),
        .\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255]_0 (\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255] ),
        .out(out),
        .ram_rd_en_d1(ram_rd_en_d1),
        .rd_clk(rd_clk),
        .rd_en(rd_en),
        .tmp_ram_rd_en_d1(tmp_ram_rd_en_d1),
        .wr_clk(wr_clk),
        .wr_en(wr_en));
endmodule

module ge11_rx_fifo_blk_mem_gen_v8_4_4
   (dout,
    wr_clk,
    rd_clk,
    Q,
    \DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram ,
    din,
    E,
    SR,
    tmp_ram_rd_en_d1,
    rd_en,
    out,
    ram_rd_en_d1,
    FULL_FB,
    wr_en,
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255] );
  output [255:0]dout;
  input wr_clk;
  input rd_clk;
  input [5:0]Q;
  input [5:0]\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram ;
  input [255:0]din;
  input [0:0]E;
  input [0:0]SR;
  input tmp_ram_rd_en_d1;
  input rd_en;
  input out;
  input ram_rd_en_d1;
  input FULL_FB;
  input wr_en;
  input [0:0]\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255] ;

  wire [5:0]\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram ;
  wire [0:0]E;
  wire FULL_FB;
  wire [5:0]Q;
  wire [0:0]SR;
  wire [255:0]din;
  wire [255:0]dout;
  wire [0:0]\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255] ;
  wire out;
  wire ram_rd_en_d1;
  wire rd_clk;
  wire rd_en;
  wire tmp_ram_rd_en_d1;
  wire wr_clk;
  wire wr_en;

  ge11_rx_fifo_blk_mem_gen_v8_4_4_synth inst_blk_mem_gen
       (.\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram (\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram ),
        .E(E),
        .FULL_FB(FULL_FB),
        .Q(Q),
        .SR(SR),
        .din(din),
        .dout(dout),
        .\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255] (\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255] ),
        .out(out),
        .ram_rd_en_d1(ram_rd_en_d1),
        .rd_clk(rd_clk),
        .rd_en(rd_en),
        .tmp_ram_rd_en_d1(tmp_ram_rd_en_d1),
        .wr_clk(wr_clk),
        .wr_en(wr_en));
endmodule

module ge11_rx_fifo_blk_mem_gen_v8_4_4_synth
   (dout,
    wr_clk,
    rd_clk,
    Q,
    \DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram ,
    din,
    E,
    SR,
    tmp_ram_rd_en_d1,
    rd_en,
    out,
    ram_rd_en_d1,
    FULL_FB,
    wr_en,
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255] );
  output [255:0]dout;
  input wr_clk;
  input rd_clk;
  input [5:0]Q;
  input [5:0]\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram ;
  input [255:0]din;
  input [0:0]E;
  input [0:0]SR;
  input tmp_ram_rd_en_d1;
  input rd_en;
  input out;
  input ram_rd_en_d1;
  input FULL_FB;
  input wr_en;
  input [0:0]\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255] ;

  wire [5:0]\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram ;
  wire [0:0]E;
  wire FULL_FB;
  wire [5:0]Q;
  wire [0:0]SR;
  wire [255:0]din;
  wire [255:0]dout;
  wire [0:0]\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255] ;
  wire out;
  wire ram_rd_en_d1;
  wire rd_clk;
  wire rd_en;
  wire tmp_ram_rd_en_d1;
  wire wr_clk;
  wire wr_en;

  ge11_rx_fifo_blk_mem_gen_top \gnbram.gnativebmg.native_blk_mem_gen 
       (.\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram (\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram ),
        .E(E),
        .FULL_FB(FULL_FB),
        .Q(Q),
        .SR(SR),
        .din(din),
        .dout(dout),
        .\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255] (\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255] ),
        .out(out),
        .ram_rd_en_d1(ram_rd_en_d1),
        .rd_clk(rd_clk),
        .rd_en(rd_en),
        .tmp_ram_rd_en_d1(tmp_ram_rd_en_d1),
        .wr_clk(wr_clk),
        .wr_en(wr_en));
endmodule

module ge11_rx_fifo_clk_x_pntrs
   (ram_full_i0,
    WR_PNTR_RD,
    wr_en,
    FULL_FB,
    Q,
    ram_full_i_i_3_0,
    wr_clk,
    \src_gray_ff_reg[5] ,
    rd_clk,
    \src_gray_ff_reg[5]_0 );
  output ram_full_i0;
  output [5:0]WR_PNTR_RD;
  input wr_en;
  input FULL_FB;
  input [5:0]Q;
  input [5:0]ram_full_i_i_3_0;
  input wr_clk;
  input [5:0]\src_gray_ff_reg[5] ;
  input rd_clk;
  input [5:0]\src_gray_ff_reg[5]_0 ;

  wire FULL_FB;
  wire [5:0]Q;
  wire [5:0]WR_PNTR_RD;
  wire \gntv_or_sync_fifo.gl0.wr/gwas.wsts/comp1 ;
  wire \gntv_or_sync_fifo.gl0.wr/gwas.wsts/comp2 ;
  wire ram_full_i0;
  wire [5:0]ram_full_i_i_3_0;
  wire ram_full_i_i_4_n_0;
  wire ram_full_i_i_5_n_0;
  wire ram_full_i_i_6_n_0;
  wire ram_full_i_i_7_n_0;
  wire rd_clk;
  wire [5:0]rd_pntr_wr;
  wire [5:0]\src_gray_ff_reg[5] ;
  wire [5:0]\src_gray_ff_reg[5]_0 ;
  wire wr_clk;
  wire wr_en;

  LUT4 #(
    .INIT(16'hAEAA)) 
    ram_full_i_i_1
       (.I0(\gntv_or_sync_fifo.gl0.wr/gwas.wsts/comp1 ),
        .I1(wr_en),
        .I2(FULL_FB),
        .I3(\gntv_or_sync_fifo.gl0.wr/gwas.wsts/comp2 ),
        .O(ram_full_i0));
  LUT6 #(
    .INIT(64'h9009000000000000)) 
    ram_full_i_i_2
       (.I0(Q[1]),
        .I1(rd_pntr_wr[1]),
        .I2(Q[0]),
        .I3(rd_pntr_wr[0]),
        .I4(ram_full_i_i_4_n_0),
        .I5(ram_full_i_i_5_n_0),
        .O(\gntv_or_sync_fifo.gl0.wr/gwas.wsts/comp1 ));
  LUT6 #(
    .INIT(64'h9009000000000000)) 
    ram_full_i_i_3
       (.I0(ram_full_i_i_3_0[1]),
        .I1(rd_pntr_wr[1]),
        .I2(ram_full_i_i_3_0[0]),
        .I3(rd_pntr_wr[0]),
        .I4(ram_full_i_i_6_n_0),
        .I5(ram_full_i_i_7_n_0),
        .O(\gntv_or_sync_fifo.gl0.wr/gwas.wsts/comp2 ));
  LUT4 #(
    .INIT(16'h9009)) 
    ram_full_i_i_4
       (.I0(rd_pntr_wr[4]),
        .I1(Q[4]),
        .I2(rd_pntr_wr[5]),
        .I3(Q[5]),
        .O(ram_full_i_i_4_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    ram_full_i_i_5
       (.I0(rd_pntr_wr[2]),
        .I1(Q[2]),
        .I2(rd_pntr_wr[3]),
        .I3(Q[3]),
        .O(ram_full_i_i_5_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    ram_full_i_i_6
       (.I0(rd_pntr_wr[4]),
        .I1(ram_full_i_i_3_0[4]),
        .I2(rd_pntr_wr[5]),
        .I3(ram_full_i_i_3_0[5]),
        .O(ram_full_i_i_6_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    ram_full_i_i_7
       (.I0(rd_pntr_wr[2]),
        .I1(ram_full_i_i_3_0[2]),
        .I2(rd_pntr_wr[3]),
        .I3(ram_full_i_i_3_0[3]),
        .O(ram_full_i_i_7_n_0));
  (* DEST_SYNC_FF = "2" *) 
  (* INIT_SYNC_FF = "0" *) 
  (* KEEP_HIERARCHY = "true" *) 
  (* REG_OUTPUT = "1" *) 
  (* SIM_ASSERT_CHK = "0" *) 
  (* SIM_LOSSLESS_GRAY_CHK = "0" *) 
  (* VERSION = "0" *) 
  (* WIDTH = "6" *) 
  (* XPM_CDC = "GRAY" *) 
  (* XPM_MODULE = "TRUE" *) 
  ge11_rx_fifo_xpm_cdc_gray rd_pntr_cdc_inst
       (.dest_clk(wr_clk),
        .dest_out_bin(rd_pntr_wr),
        .src_clk(rd_clk),
        .src_in_bin(\src_gray_ff_reg[5]_0 ));
  (* DEST_SYNC_FF = "2" *) 
  (* INIT_SYNC_FF = "0" *) 
  (* KEEP_HIERARCHY = "true" *) 
  (* REG_OUTPUT = "1" *) 
  (* SIM_ASSERT_CHK = "0" *) 
  (* SIM_LOSSLESS_GRAY_CHK = "0" *) 
  (* VERSION = "0" *) 
  (* WIDTH = "6" *) 
  (* XPM_CDC = "GRAY" *) 
  (* XPM_MODULE = "TRUE" *) 
  ge11_rx_fifo_xpm_cdc_gray__2 wr_pntr_cdc_inst
       (.dest_clk(rd_clk),
        .dest_out_bin(WR_PNTR_RD),
        .src_clk(wr_clk),
        .src_in_bin(\src_gray_ff_reg[5] ));
endmodule

module ge11_rx_fifo_fifo_generator_ramfifo
   (SR,
    wr_rst_busy,
    empty,
    full,
    dout,
    valid,
    wr_clk,
    rd_clk,
    rd_en,
    rst,
    din,
    wr_en);
  output [0:0]SR;
  output wr_rst_busy;
  output empty;
  output full;
  output [255:0]dout;
  output valid;
  input wr_clk;
  input rd_clk;
  input rd_en;
  input rst;
  input [255:0]din;
  input wr_en;

  wire [0:0]SR;
  wire [255:0]din;
  wire [255:0]dout;
  wire empty;
  wire empty_fb_i;
  wire full;
  wire \gntv_or_sync_fifo.gl0.wr_n_1 ;
  wire ram_full_i0;
  wire ram_rd_en;
  wire ram_wr_en;
  wire rd_clk;
  wire rd_en;
  wire [5:0]rd_pntr;
  wire rst;
  wire rstblk_n_0;
  wire tmp_ram_rd_en_d1;
  wire tmp_ram_regce_both;
  wire valid;
  wire wr_clk;
  wire wr_en;
  wire [5:0]wr_pntr;
  wire [5:0]wr_pntr_plus1;
  wire [5:0]wr_pntr_plus2;
  wire [5:0]wr_pntr_rd;
  wire wr_rst_busy;

  ge11_rx_fifo_clk_x_pntrs \gntv_or_sync_fifo.gcx.clkx 
       (.FULL_FB(\gntv_or_sync_fifo.gl0.wr_n_1 ),
        .Q(wr_pntr_plus1),
        .WR_PNTR_RD(wr_pntr_rd),
        .ram_full_i0(ram_full_i0),
        .ram_full_i_i_3_0(wr_pntr_plus2),
        .rd_clk(rd_clk),
        .\src_gray_ff_reg[5] (wr_pntr),
        .\src_gray_ff_reg[5]_0 (rd_pntr),
        .wr_clk(wr_clk),
        .wr_en(wr_en));
  ge11_rx_fifo_rd_logic \gntv_or_sync_fifo.gl0.rd 
       (.E(ram_rd_en),
        .Q(rd_pntr),
        .SR(SR),
        .WR_PNTR_RD(wr_pntr_rd),
        .empty(empty),
        .out(empty_fb_i),
        .rd_clk(rd_clk),
        .rd_en(rd_en),
        .valid(valid));
  ge11_rx_fifo_wr_logic \gntv_or_sync_fifo.gl0.wr 
       (.E(ram_wr_en),
        .FULL_FB(\gntv_or_sync_fifo.gl0.wr_n_1 ),
        .Q(wr_pntr_plus2),
        .full(full),
        .\gic0.gc0.count_d1_reg[5] (wr_pntr_plus1),
        .\gic0.gc0.count_d2_reg[0] (rstblk_n_0),
        .\gic0.gc0.count_d2_reg[5] (wr_pntr),
        .ram_full_i0(ram_full_i0),
        .wr_clk(wr_clk),
        .wr_en(wr_en));
  ge11_rx_fifo_memory \gntv_or_sync_fifo.mem 
       (.\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram (wr_pntr),
        .E(ram_wr_en),
        .FULL_FB(\gntv_or_sync_fifo.gl0.wr_n_1 ),
        .Q(rd_pntr),
        .SR(SR),
        .din(din),
        .dout(dout),
        .\gbm.gregce.ram_rd_en_d1_reg_0 (ram_rd_en),
        .\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255] (tmp_ram_regce_both),
        .out(empty_fb_i),
        .rd_clk(rd_clk),
        .rd_en(rd_en),
        .tmp_ram_rd_en_d1(tmp_ram_rd_en_d1),
        .wr_clk(wr_clk),
        .wr_en(wr_en));
  ge11_rx_fifo_reset_blk_ramfifo rstblk
       (.SR(SR),
        .\ngwrdrst.grst.g7serrst.gsckt_wrst.gic_rst.sckt_rd_rst_ic_reg_0 (tmp_ram_regce_both),
        .\ngwrdrst.grst.g7serrst.gsckt_wrst.gic_rst.sckt_wr_rst_ic_reg_0 (rstblk_n_0),
        .rd_clk(rd_clk),
        .rst(rst),
        .tmp_ram_rd_en_d1(tmp_ram_rd_en_d1),
        .wr_clk(wr_clk),
        .wr_rst_busy(wr_rst_busy));
endmodule

module ge11_rx_fifo_fifo_generator_top
   (SR,
    wr_rst_busy,
    empty,
    full,
    dout,
    valid,
    wr_clk,
    rd_clk,
    rd_en,
    rst,
    din,
    wr_en);
  output [0:0]SR;
  output wr_rst_busy;
  output empty;
  output full;
  output [255:0]dout;
  output valid;
  input wr_clk;
  input rd_clk;
  input rd_en;
  input rst;
  input [255:0]din;
  input wr_en;

  wire [0:0]SR;
  wire [255:0]din;
  wire [255:0]dout;
  wire empty;
  wire full;
  wire rd_clk;
  wire rd_en;
  wire rst;
  wire valid;
  wire wr_clk;
  wire wr_en;
  wire wr_rst_busy;

  ge11_rx_fifo_fifo_generator_ramfifo \grf.rf 
       (.SR(SR),
        .din(din),
        .dout(dout),
        .empty(empty),
        .full(full),
        .rd_clk(rd_clk),
        .rd_en(rd_en),
        .rst(rst),
        .valid(valid),
        .wr_clk(wr_clk),
        .wr_en(wr_en),
        .wr_rst_busy(wr_rst_busy));
endmodule

(* C_ADD_NGC_CONSTRAINT = "0" *) (* C_APPLICATION_TYPE_AXIS = "0" *) (* C_APPLICATION_TYPE_RACH = "0" *) 
(* C_APPLICATION_TYPE_RDCH = "0" *) (* C_APPLICATION_TYPE_WACH = "0" *) (* C_APPLICATION_TYPE_WDCH = "0" *) 
(* C_APPLICATION_TYPE_WRCH = "0" *) (* C_AXIS_TDATA_WIDTH = "8" *) (* C_AXIS_TDEST_WIDTH = "1" *) 
(* C_AXIS_TID_WIDTH = "1" *) (* C_AXIS_TKEEP_WIDTH = "1" *) (* C_AXIS_TSTRB_WIDTH = "1" *) 
(* C_AXIS_TUSER_WIDTH = "4" *) (* C_AXIS_TYPE = "0" *) (* C_AXI_ADDR_WIDTH = "32" *) 
(* C_AXI_ARUSER_WIDTH = "1" *) (* C_AXI_AWUSER_WIDTH = "1" *) (* C_AXI_BUSER_WIDTH = "1" *) 
(* C_AXI_DATA_WIDTH = "64" *) (* C_AXI_ID_WIDTH = "1" *) (* C_AXI_LEN_WIDTH = "8" *) 
(* C_AXI_LOCK_WIDTH = "1" *) (* C_AXI_RUSER_WIDTH = "1" *) (* C_AXI_TYPE = "1" *) 
(* C_AXI_WUSER_WIDTH = "1" *) (* C_COMMON_CLOCK = "0" *) (* C_COUNT_TYPE = "0" *) 
(* C_DATA_COUNT_WIDTH = "6" *) (* C_DEFAULT_VALUE = "BlankString" *) (* C_DIN_WIDTH = "256" *) 
(* C_DIN_WIDTH_AXIS = "1" *) (* C_DIN_WIDTH_RACH = "32" *) (* C_DIN_WIDTH_RDCH = "64" *) 
(* C_DIN_WIDTH_WACH = "1" *) (* C_DIN_WIDTH_WDCH = "64" *) (* C_DIN_WIDTH_WRCH = "2" *) 
(* C_DOUT_RST_VAL = "0" *) (* C_DOUT_WIDTH = "256" *) (* C_ENABLE_RLOCS = "0" *) 
(* C_ENABLE_RST_SYNC = "1" *) (* C_EN_SAFETY_CKT = "1" *) (* C_ERROR_INJECTION_TYPE = "0" *) 
(* C_ERROR_INJECTION_TYPE_AXIS = "0" *) (* C_ERROR_INJECTION_TYPE_RACH = "0" *) (* C_ERROR_INJECTION_TYPE_RDCH = "0" *) 
(* C_ERROR_INJECTION_TYPE_WACH = "0" *) (* C_ERROR_INJECTION_TYPE_WDCH = "0" *) (* C_ERROR_INJECTION_TYPE_WRCH = "0" *) 
(* C_FAMILY = "virtex7" *) (* C_FULL_FLAGS_RST_VAL = "0" *) (* C_HAS_ALMOST_EMPTY = "0" *) 
(* C_HAS_ALMOST_FULL = "0" *) (* C_HAS_AXIS_TDATA = "1" *) (* C_HAS_AXIS_TDEST = "0" *) 
(* C_HAS_AXIS_TID = "0" *) (* C_HAS_AXIS_TKEEP = "0" *) (* C_HAS_AXIS_TLAST = "0" *) 
(* C_HAS_AXIS_TREADY = "1" *) (* C_HAS_AXIS_TSTRB = "0" *) (* C_HAS_AXIS_TUSER = "1" *) 
(* C_HAS_AXI_ARUSER = "0" *) (* C_HAS_AXI_AWUSER = "0" *) (* C_HAS_AXI_BUSER = "0" *) 
(* C_HAS_AXI_ID = "0" *) (* C_HAS_AXI_RD_CHANNEL = "1" *) (* C_HAS_AXI_RUSER = "0" *) 
(* C_HAS_AXI_WR_CHANNEL = "1" *) (* C_HAS_AXI_WUSER = "0" *) (* C_HAS_BACKUP = "0" *) 
(* C_HAS_DATA_COUNT = "0" *) (* C_HAS_DATA_COUNTS_AXIS = "0" *) (* C_HAS_DATA_COUNTS_RACH = "0" *) 
(* C_HAS_DATA_COUNTS_RDCH = "0" *) (* C_HAS_DATA_COUNTS_WACH = "0" *) (* C_HAS_DATA_COUNTS_WDCH = "0" *) 
(* C_HAS_DATA_COUNTS_WRCH = "0" *) (* C_HAS_INT_CLK = "0" *) (* C_HAS_MASTER_CE = "0" *) 
(* C_HAS_MEMINIT_FILE = "0" *) (* C_HAS_OVERFLOW = "0" *) (* C_HAS_PROG_FLAGS_AXIS = "0" *) 
(* C_HAS_PROG_FLAGS_RACH = "0" *) (* C_HAS_PROG_FLAGS_RDCH = "0" *) (* C_HAS_PROG_FLAGS_WACH = "0" *) 
(* C_HAS_PROG_FLAGS_WDCH = "0" *) (* C_HAS_PROG_FLAGS_WRCH = "0" *) (* C_HAS_RD_DATA_COUNT = "0" *) 
(* C_HAS_RD_RST = "0" *) (* C_HAS_RST = "1" *) (* C_HAS_SLAVE_CE = "0" *) 
(* C_HAS_SRST = "0" *) (* C_HAS_UNDERFLOW = "0" *) (* C_HAS_VALID = "1" *) 
(* C_HAS_WR_ACK = "0" *) (* C_HAS_WR_DATA_COUNT = "0" *) (* C_HAS_WR_RST = "0" *) 
(* C_IMPLEMENTATION_TYPE = "2" *) (* C_IMPLEMENTATION_TYPE_AXIS = "1" *) (* C_IMPLEMENTATION_TYPE_RACH = "1" *) 
(* C_IMPLEMENTATION_TYPE_RDCH = "1" *) (* C_IMPLEMENTATION_TYPE_WACH = "1" *) (* C_IMPLEMENTATION_TYPE_WDCH = "1" *) 
(* C_IMPLEMENTATION_TYPE_WRCH = "1" *) (* C_INIT_WR_PNTR_VAL = "0" *) (* C_INTERFACE_TYPE = "0" *) 
(* C_MEMORY_TYPE = "1" *) (* C_MIF_FILE_NAME = "BlankString" *) (* C_MSGON_VAL = "1" *) 
(* C_OPTIMIZATION_MODE = "0" *) (* C_OVERFLOW_LOW = "0" *) (* C_POWER_SAVING_MODE = "0" *) 
(* C_PRELOAD_LATENCY = "2" *) (* C_PRELOAD_REGS = "1" *) (* C_PRIM_FIFO_TYPE = "512x72" *) 
(* C_PRIM_FIFO_TYPE_AXIS = "1kx18" *) (* C_PRIM_FIFO_TYPE_RACH = "512x36" *) (* C_PRIM_FIFO_TYPE_RDCH = "1kx36" *) 
(* C_PRIM_FIFO_TYPE_WACH = "512x36" *) (* C_PRIM_FIFO_TYPE_WDCH = "1kx36" *) (* C_PRIM_FIFO_TYPE_WRCH = "512x36" *) 
(* C_PROG_EMPTY_THRESH_ASSERT_VAL = "2" *) (* C_PROG_EMPTY_THRESH_ASSERT_VAL_AXIS = "1022" *) (* C_PROG_EMPTY_THRESH_ASSERT_VAL_RACH = "1022" *) 
(* C_PROG_EMPTY_THRESH_ASSERT_VAL_RDCH = "1022" *) (* C_PROG_EMPTY_THRESH_ASSERT_VAL_WACH = "1022" *) (* C_PROG_EMPTY_THRESH_ASSERT_VAL_WDCH = "1022" *) 
(* C_PROG_EMPTY_THRESH_ASSERT_VAL_WRCH = "1022" *) (* C_PROG_EMPTY_THRESH_NEGATE_VAL = "3" *) (* C_PROG_EMPTY_TYPE = "0" *) 
(* C_PROG_EMPTY_TYPE_AXIS = "0" *) (* C_PROG_EMPTY_TYPE_RACH = "0" *) (* C_PROG_EMPTY_TYPE_RDCH = "0" *) 
(* C_PROG_EMPTY_TYPE_WACH = "0" *) (* C_PROG_EMPTY_TYPE_WDCH = "0" *) (* C_PROG_EMPTY_TYPE_WRCH = "0" *) 
(* C_PROG_FULL_THRESH_ASSERT_VAL = "61" *) (* C_PROG_FULL_THRESH_ASSERT_VAL_AXIS = "1023" *) (* C_PROG_FULL_THRESH_ASSERT_VAL_RACH = "1023" *) 
(* C_PROG_FULL_THRESH_ASSERT_VAL_RDCH = "1023" *) (* C_PROG_FULL_THRESH_ASSERT_VAL_WACH = "1023" *) (* C_PROG_FULL_THRESH_ASSERT_VAL_WDCH = "1023" *) 
(* C_PROG_FULL_THRESH_ASSERT_VAL_WRCH = "1023" *) (* C_PROG_FULL_THRESH_NEGATE_VAL = "60" *) (* C_PROG_FULL_TYPE = "0" *) 
(* C_PROG_FULL_TYPE_AXIS = "0" *) (* C_PROG_FULL_TYPE_RACH = "0" *) (* C_PROG_FULL_TYPE_RDCH = "0" *) 
(* C_PROG_FULL_TYPE_WACH = "0" *) (* C_PROG_FULL_TYPE_WDCH = "0" *) (* C_PROG_FULL_TYPE_WRCH = "0" *) 
(* C_RACH_TYPE = "0" *) (* C_RDCH_TYPE = "0" *) (* C_RD_DATA_COUNT_WIDTH = "6" *) 
(* C_RD_DEPTH = "64" *) (* C_RD_FREQ = "1" *) (* C_RD_PNTR_WIDTH = "6" *) 
(* C_REG_SLICE_MODE_AXIS = "0" *) (* C_REG_SLICE_MODE_RACH = "0" *) (* C_REG_SLICE_MODE_RDCH = "0" *) 
(* C_REG_SLICE_MODE_WACH = "0" *) (* C_REG_SLICE_MODE_WDCH = "0" *) (* C_REG_SLICE_MODE_WRCH = "0" *) 
(* C_SELECT_XPM = "0" *) (* C_SYNCHRONIZER_STAGE = "2" *) (* C_UNDERFLOW_LOW = "0" *) 
(* C_USE_COMMON_OVERFLOW = "0" *) (* C_USE_COMMON_UNDERFLOW = "0" *) (* C_USE_DEFAULT_SETTINGS = "0" *) 
(* C_USE_DOUT_RST = "1" *) (* C_USE_ECC = "0" *) (* C_USE_ECC_AXIS = "0" *) 
(* C_USE_ECC_RACH = "0" *) (* C_USE_ECC_RDCH = "0" *) (* C_USE_ECC_WACH = "0" *) 
(* C_USE_ECC_WDCH = "0" *) (* C_USE_ECC_WRCH = "0" *) (* C_USE_EMBEDDED_REG = "3" *) 
(* C_USE_FIFO16_FLAGS = "0" *) (* C_USE_FWFT_DATA_COUNT = "0" *) (* C_USE_PIPELINE_REG = "0" *) 
(* C_VALID_LOW = "0" *) (* C_WACH_TYPE = "0" *) (* C_WDCH_TYPE = "0" *) 
(* C_WRCH_TYPE = "0" *) (* C_WR_ACK_LOW = "0" *) (* C_WR_DATA_COUNT_WIDTH = "6" *) 
(* C_WR_DEPTH = "64" *) (* C_WR_DEPTH_AXIS = "1024" *) (* C_WR_DEPTH_RACH = "16" *) 
(* C_WR_DEPTH_RDCH = "1024" *) (* C_WR_DEPTH_WACH = "16" *) (* C_WR_DEPTH_WDCH = "1024" *) 
(* C_WR_DEPTH_WRCH = "16" *) (* C_WR_FREQ = "1" *) (* C_WR_PNTR_WIDTH = "6" *) 
(* C_WR_PNTR_WIDTH_AXIS = "10" *) (* C_WR_PNTR_WIDTH_RACH = "4" *) (* C_WR_PNTR_WIDTH_RDCH = "10" *) 
(* C_WR_PNTR_WIDTH_WACH = "4" *) (* C_WR_PNTR_WIDTH_WDCH = "10" *) (* C_WR_PNTR_WIDTH_WRCH = "4" *) 
(* C_WR_RESPONSE_LATENCY = "1" *) 
module ge11_rx_fifo_fifo_generator_v13_2_5
   (backup,
    backup_marker,
    clk,
    rst,
    srst,
    wr_clk,
    wr_rst,
    rd_clk,
    rd_rst,
    din,
    wr_en,
    rd_en,
    prog_empty_thresh,
    prog_empty_thresh_assert,
    prog_empty_thresh_negate,
    prog_full_thresh,
    prog_full_thresh_assert,
    prog_full_thresh_negate,
    int_clk,
    injectdbiterr,
    injectsbiterr,
    sleep,
    dout,
    full,
    almost_full,
    wr_ack,
    overflow,
    empty,
    almost_empty,
    valid,
    underflow,
    data_count,
    rd_data_count,
    wr_data_count,
    prog_full,
    prog_empty,
    sbiterr,
    dbiterr,
    wr_rst_busy,
    rd_rst_busy,
    m_aclk,
    s_aclk,
    s_aresetn,
    m_aclk_en,
    s_aclk_en,
    s_axi_awid,
    s_axi_awaddr,
    s_axi_awlen,
    s_axi_awsize,
    s_axi_awburst,
    s_axi_awlock,
    s_axi_awcache,
    s_axi_awprot,
    s_axi_awqos,
    s_axi_awregion,
    s_axi_awuser,
    s_axi_awvalid,
    s_axi_awready,
    s_axi_wid,
    s_axi_wdata,
    s_axi_wstrb,
    s_axi_wlast,
    s_axi_wuser,
    s_axi_wvalid,
    s_axi_wready,
    s_axi_bid,
    s_axi_bresp,
    s_axi_buser,
    s_axi_bvalid,
    s_axi_bready,
    m_axi_awid,
    m_axi_awaddr,
    m_axi_awlen,
    m_axi_awsize,
    m_axi_awburst,
    m_axi_awlock,
    m_axi_awcache,
    m_axi_awprot,
    m_axi_awqos,
    m_axi_awregion,
    m_axi_awuser,
    m_axi_awvalid,
    m_axi_awready,
    m_axi_wid,
    m_axi_wdata,
    m_axi_wstrb,
    m_axi_wlast,
    m_axi_wuser,
    m_axi_wvalid,
    m_axi_wready,
    m_axi_bid,
    m_axi_bresp,
    m_axi_buser,
    m_axi_bvalid,
    m_axi_bready,
    s_axi_arid,
    s_axi_araddr,
    s_axi_arlen,
    s_axi_arsize,
    s_axi_arburst,
    s_axi_arlock,
    s_axi_arcache,
    s_axi_arprot,
    s_axi_arqos,
    s_axi_arregion,
    s_axi_aruser,
    s_axi_arvalid,
    s_axi_arready,
    s_axi_rid,
    s_axi_rdata,
    s_axi_rresp,
    s_axi_rlast,
    s_axi_ruser,
    s_axi_rvalid,
    s_axi_rready,
    m_axi_arid,
    m_axi_araddr,
    m_axi_arlen,
    m_axi_arsize,
    m_axi_arburst,
    m_axi_arlock,
    m_axi_arcache,
    m_axi_arprot,
    m_axi_arqos,
    m_axi_arregion,
    m_axi_aruser,
    m_axi_arvalid,
    m_axi_arready,
    m_axi_rid,
    m_axi_rdata,
    m_axi_rresp,
    m_axi_rlast,
    m_axi_ruser,
    m_axi_rvalid,
    m_axi_rready,
    s_axis_tvalid,
    s_axis_tready,
    s_axis_tdata,
    s_axis_tstrb,
    s_axis_tkeep,
    s_axis_tlast,
    s_axis_tid,
    s_axis_tdest,
    s_axis_tuser,
    m_axis_tvalid,
    m_axis_tready,
    m_axis_tdata,
    m_axis_tstrb,
    m_axis_tkeep,
    m_axis_tlast,
    m_axis_tid,
    m_axis_tdest,
    m_axis_tuser,
    axi_aw_injectsbiterr,
    axi_aw_injectdbiterr,
    axi_aw_prog_full_thresh,
    axi_aw_prog_empty_thresh,
    axi_aw_data_count,
    axi_aw_wr_data_count,
    axi_aw_rd_data_count,
    axi_aw_sbiterr,
    axi_aw_dbiterr,
    axi_aw_overflow,
    axi_aw_underflow,
    axi_aw_prog_full,
    axi_aw_prog_empty,
    axi_w_injectsbiterr,
    axi_w_injectdbiterr,
    axi_w_prog_full_thresh,
    axi_w_prog_empty_thresh,
    axi_w_data_count,
    axi_w_wr_data_count,
    axi_w_rd_data_count,
    axi_w_sbiterr,
    axi_w_dbiterr,
    axi_w_overflow,
    axi_w_underflow,
    axi_w_prog_full,
    axi_w_prog_empty,
    axi_b_injectsbiterr,
    axi_b_injectdbiterr,
    axi_b_prog_full_thresh,
    axi_b_prog_empty_thresh,
    axi_b_data_count,
    axi_b_wr_data_count,
    axi_b_rd_data_count,
    axi_b_sbiterr,
    axi_b_dbiterr,
    axi_b_overflow,
    axi_b_underflow,
    axi_b_prog_full,
    axi_b_prog_empty,
    axi_ar_injectsbiterr,
    axi_ar_injectdbiterr,
    axi_ar_prog_full_thresh,
    axi_ar_prog_empty_thresh,
    axi_ar_data_count,
    axi_ar_wr_data_count,
    axi_ar_rd_data_count,
    axi_ar_sbiterr,
    axi_ar_dbiterr,
    axi_ar_overflow,
    axi_ar_underflow,
    axi_ar_prog_full,
    axi_ar_prog_empty,
    axi_r_injectsbiterr,
    axi_r_injectdbiterr,
    axi_r_prog_full_thresh,
    axi_r_prog_empty_thresh,
    axi_r_data_count,
    axi_r_wr_data_count,
    axi_r_rd_data_count,
    axi_r_sbiterr,
    axi_r_dbiterr,
    axi_r_overflow,
    axi_r_underflow,
    axi_r_prog_full,
    axi_r_prog_empty,
    axis_injectsbiterr,
    axis_injectdbiterr,
    axis_prog_full_thresh,
    axis_prog_empty_thresh,
    axis_data_count,
    axis_wr_data_count,
    axis_rd_data_count,
    axis_sbiterr,
    axis_dbiterr,
    axis_overflow,
    axis_underflow,
    axis_prog_full,
    axis_prog_empty);
  input backup;
  input backup_marker;
  input clk;
  input rst;
  input srst;
  input wr_clk;
  input wr_rst;
  input rd_clk;
  input rd_rst;
  input [255:0]din;
  input wr_en;
  input rd_en;
  input [5:0]prog_empty_thresh;
  input [5:0]prog_empty_thresh_assert;
  input [5:0]prog_empty_thresh_negate;
  input [5:0]prog_full_thresh;
  input [5:0]prog_full_thresh_assert;
  input [5:0]prog_full_thresh_negate;
  input int_clk;
  input injectdbiterr;
  input injectsbiterr;
  input sleep;
  output [255:0]dout;
  output full;
  output almost_full;
  output wr_ack;
  output overflow;
  output empty;
  output almost_empty;
  output valid;
  output underflow;
  output [5:0]data_count;
  output [5:0]rd_data_count;
  output [5:0]wr_data_count;
  output prog_full;
  output prog_empty;
  output sbiterr;
  output dbiterr;
  output wr_rst_busy;
  output rd_rst_busy;
  input m_aclk;
  input s_aclk;
  input s_aresetn;
  input m_aclk_en;
  input s_aclk_en;
  input [0:0]s_axi_awid;
  input [31:0]s_axi_awaddr;
  input [7:0]s_axi_awlen;
  input [2:0]s_axi_awsize;
  input [1:0]s_axi_awburst;
  input [0:0]s_axi_awlock;
  input [3:0]s_axi_awcache;
  input [2:0]s_axi_awprot;
  input [3:0]s_axi_awqos;
  input [3:0]s_axi_awregion;
  input [0:0]s_axi_awuser;
  input s_axi_awvalid;
  output s_axi_awready;
  input [0:0]s_axi_wid;
  input [63:0]s_axi_wdata;
  input [7:0]s_axi_wstrb;
  input s_axi_wlast;
  input [0:0]s_axi_wuser;
  input s_axi_wvalid;
  output s_axi_wready;
  output [0:0]s_axi_bid;
  output [1:0]s_axi_bresp;
  output [0:0]s_axi_buser;
  output s_axi_bvalid;
  input s_axi_bready;
  output [0:0]m_axi_awid;
  output [31:0]m_axi_awaddr;
  output [7:0]m_axi_awlen;
  output [2:0]m_axi_awsize;
  output [1:0]m_axi_awburst;
  output [0:0]m_axi_awlock;
  output [3:0]m_axi_awcache;
  output [2:0]m_axi_awprot;
  output [3:0]m_axi_awqos;
  output [3:0]m_axi_awregion;
  output [0:0]m_axi_awuser;
  output m_axi_awvalid;
  input m_axi_awready;
  output [0:0]m_axi_wid;
  output [63:0]m_axi_wdata;
  output [7:0]m_axi_wstrb;
  output m_axi_wlast;
  output [0:0]m_axi_wuser;
  output m_axi_wvalid;
  input m_axi_wready;
  input [0:0]m_axi_bid;
  input [1:0]m_axi_bresp;
  input [0:0]m_axi_buser;
  input m_axi_bvalid;
  output m_axi_bready;
  input [0:0]s_axi_arid;
  input [31:0]s_axi_araddr;
  input [7:0]s_axi_arlen;
  input [2:0]s_axi_arsize;
  input [1:0]s_axi_arburst;
  input [0:0]s_axi_arlock;
  input [3:0]s_axi_arcache;
  input [2:0]s_axi_arprot;
  input [3:0]s_axi_arqos;
  input [3:0]s_axi_arregion;
  input [0:0]s_axi_aruser;
  input s_axi_arvalid;
  output s_axi_arready;
  output [0:0]s_axi_rid;
  output [63:0]s_axi_rdata;
  output [1:0]s_axi_rresp;
  output s_axi_rlast;
  output [0:0]s_axi_ruser;
  output s_axi_rvalid;
  input s_axi_rready;
  output [0:0]m_axi_arid;
  output [31:0]m_axi_araddr;
  output [7:0]m_axi_arlen;
  output [2:0]m_axi_arsize;
  output [1:0]m_axi_arburst;
  output [0:0]m_axi_arlock;
  output [3:0]m_axi_arcache;
  output [2:0]m_axi_arprot;
  output [3:0]m_axi_arqos;
  output [3:0]m_axi_arregion;
  output [0:0]m_axi_aruser;
  output m_axi_arvalid;
  input m_axi_arready;
  input [0:0]m_axi_rid;
  input [63:0]m_axi_rdata;
  input [1:0]m_axi_rresp;
  input m_axi_rlast;
  input [0:0]m_axi_ruser;
  input m_axi_rvalid;
  output m_axi_rready;
  input s_axis_tvalid;
  output s_axis_tready;
  input [7:0]s_axis_tdata;
  input [0:0]s_axis_tstrb;
  input [0:0]s_axis_tkeep;
  input s_axis_tlast;
  input [0:0]s_axis_tid;
  input [0:0]s_axis_tdest;
  input [3:0]s_axis_tuser;
  output m_axis_tvalid;
  input m_axis_tready;
  output [7:0]m_axis_tdata;
  output [0:0]m_axis_tstrb;
  output [0:0]m_axis_tkeep;
  output m_axis_tlast;
  output [0:0]m_axis_tid;
  output [0:0]m_axis_tdest;
  output [3:0]m_axis_tuser;
  input axi_aw_injectsbiterr;
  input axi_aw_injectdbiterr;
  input [3:0]axi_aw_prog_full_thresh;
  input [3:0]axi_aw_prog_empty_thresh;
  output [4:0]axi_aw_data_count;
  output [4:0]axi_aw_wr_data_count;
  output [4:0]axi_aw_rd_data_count;
  output axi_aw_sbiterr;
  output axi_aw_dbiterr;
  output axi_aw_overflow;
  output axi_aw_underflow;
  output axi_aw_prog_full;
  output axi_aw_prog_empty;
  input axi_w_injectsbiterr;
  input axi_w_injectdbiterr;
  input [9:0]axi_w_prog_full_thresh;
  input [9:0]axi_w_prog_empty_thresh;
  output [10:0]axi_w_data_count;
  output [10:0]axi_w_wr_data_count;
  output [10:0]axi_w_rd_data_count;
  output axi_w_sbiterr;
  output axi_w_dbiterr;
  output axi_w_overflow;
  output axi_w_underflow;
  output axi_w_prog_full;
  output axi_w_prog_empty;
  input axi_b_injectsbiterr;
  input axi_b_injectdbiterr;
  input [3:0]axi_b_prog_full_thresh;
  input [3:0]axi_b_prog_empty_thresh;
  output [4:0]axi_b_data_count;
  output [4:0]axi_b_wr_data_count;
  output [4:0]axi_b_rd_data_count;
  output axi_b_sbiterr;
  output axi_b_dbiterr;
  output axi_b_overflow;
  output axi_b_underflow;
  output axi_b_prog_full;
  output axi_b_prog_empty;
  input axi_ar_injectsbiterr;
  input axi_ar_injectdbiterr;
  input [3:0]axi_ar_prog_full_thresh;
  input [3:0]axi_ar_prog_empty_thresh;
  output [4:0]axi_ar_data_count;
  output [4:0]axi_ar_wr_data_count;
  output [4:0]axi_ar_rd_data_count;
  output axi_ar_sbiterr;
  output axi_ar_dbiterr;
  output axi_ar_overflow;
  output axi_ar_underflow;
  output axi_ar_prog_full;
  output axi_ar_prog_empty;
  input axi_r_injectsbiterr;
  input axi_r_injectdbiterr;
  input [9:0]axi_r_prog_full_thresh;
  input [9:0]axi_r_prog_empty_thresh;
  output [10:0]axi_r_data_count;
  output [10:0]axi_r_wr_data_count;
  output [10:0]axi_r_rd_data_count;
  output axi_r_sbiterr;
  output axi_r_dbiterr;
  output axi_r_overflow;
  output axi_r_underflow;
  output axi_r_prog_full;
  output axi_r_prog_empty;
  input axis_injectsbiterr;
  input axis_injectdbiterr;
  input [9:0]axis_prog_full_thresh;
  input [9:0]axis_prog_empty_thresh;
  output [10:0]axis_data_count;
  output [10:0]axis_wr_data_count;
  output [10:0]axis_rd_data_count;
  output axis_sbiterr;
  output axis_dbiterr;
  output axis_overflow;
  output axis_underflow;
  output axis_prog_full;
  output axis_prog_empty;

  wire \<const0> ;
  wire \<const1> ;
  wire [255:0]din;
  wire [255:0]dout;
  wire empty;
  wire full;
  wire rd_clk;
  wire rd_en;
  wire rd_rst_busy;
  wire rst;
  wire valid;
  wire wr_clk;
  wire wr_en;
  wire wr_rst_busy;

  assign almost_empty = \<const0> ;
  assign almost_full = \<const0> ;
  assign axi_ar_data_count[4] = \<const0> ;
  assign axi_ar_data_count[3] = \<const0> ;
  assign axi_ar_data_count[2] = \<const0> ;
  assign axi_ar_data_count[1] = \<const0> ;
  assign axi_ar_data_count[0] = \<const0> ;
  assign axi_ar_dbiterr = \<const0> ;
  assign axi_ar_overflow = \<const0> ;
  assign axi_ar_prog_empty = \<const1> ;
  assign axi_ar_prog_full = \<const0> ;
  assign axi_ar_rd_data_count[4] = \<const0> ;
  assign axi_ar_rd_data_count[3] = \<const0> ;
  assign axi_ar_rd_data_count[2] = \<const0> ;
  assign axi_ar_rd_data_count[1] = \<const0> ;
  assign axi_ar_rd_data_count[0] = \<const0> ;
  assign axi_ar_sbiterr = \<const0> ;
  assign axi_ar_underflow = \<const0> ;
  assign axi_ar_wr_data_count[4] = \<const0> ;
  assign axi_ar_wr_data_count[3] = \<const0> ;
  assign axi_ar_wr_data_count[2] = \<const0> ;
  assign axi_ar_wr_data_count[1] = \<const0> ;
  assign axi_ar_wr_data_count[0] = \<const0> ;
  assign axi_aw_data_count[4] = \<const0> ;
  assign axi_aw_data_count[3] = \<const0> ;
  assign axi_aw_data_count[2] = \<const0> ;
  assign axi_aw_data_count[1] = \<const0> ;
  assign axi_aw_data_count[0] = \<const0> ;
  assign axi_aw_dbiterr = \<const0> ;
  assign axi_aw_overflow = \<const0> ;
  assign axi_aw_prog_empty = \<const1> ;
  assign axi_aw_prog_full = \<const0> ;
  assign axi_aw_rd_data_count[4] = \<const0> ;
  assign axi_aw_rd_data_count[3] = \<const0> ;
  assign axi_aw_rd_data_count[2] = \<const0> ;
  assign axi_aw_rd_data_count[1] = \<const0> ;
  assign axi_aw_rd_data_count[0] = \<const0> ;
  assign axi_aw_sbiterr = \<const0> ;
  assign axi_aw_underflow = \<const0> ;
  assign axi_aw_wr_data_count[4] = \<const0> ;
  assign axi_aw_wr_data_count[3] = \<const0> ;
  assign axi_aw_wr_data_count[2] = \<const0> ;
  assign axi_aw_wr_data_count[1] = \<const0> ;
  assign axi_aw_wr_data_count[0] = \<const0> ;
  assign axi_b_data_count[4] = \<const0> ;
  assign axi_b_data_count[3] = \<const0> ;
  assign axi_b_data_count[2] = \<const0> ;
  assign axi_b_data_count[1] = \<const0> ;
  assign axi_b_data_count[0] = \<const0> ;
  assign axi_b_dbiterr = \<const0> ;
  assign axi_b_overflow = \<const0> ;
  assign axi_b_prog_empty = \<const1> ;
  assign axi_b_prog_full = \<const0> ;
  assign axi_b_rd_data_count[4] = \<const0> ;
  assign axi_b_rd_data_count[3] = \<const0> ;
  assign axi_b_rd_data_count[2] = \<const0> ;
  assign axi_b_rd_data_count[1] = \<const0> ;
  assign axi_b_rd_data_count[0] = \<const0> ;
  assign axi_b_sbiterr = \<const0> ;
  assign axi_b_underflow = \<const0> ;
  assign axi_b_wr_data_count[4] = \<const0> ;
  assign axi_b_wr_data_count[3] = \<const0> ;
  assign axi_b_wr_data_count[2] = \<const0> ;
  assign axi_b_wr_data_count[1] = \<const0> ;
  assign axi_b_wr_data_count[0] = \<const0> ;
  assign axi_r_data_count[10] = \<const0> ;
  assign axi_r_data_count[9] = \<const0> ;
  assign axi_r_data_count[8] = \<const0> ;
  assign axi_r_data_count[7] = \<const0> ;
  assign axi_r_data_count[6] = \<const0> ;
  assign axi_r_data_count[5] = \<const0> ;
  assign axi_r_data_count[4] = \<const0> ;
  assign axi_r_data_count[3] = \<const0> ;
  assign axi_r_data_count[2] = \<const0> ;
  assign axi_r_data_count[1] = \<const0> ;
  assign axi_r_data_count[0] = \<const0> ;
  assign axi_r_dbiterr = \<const0> ;
  assign axi_r_overflow = \<const0> ;
  assign axi_r_prog_empty = \<const1> ;
  assign axi_r_prog_full = \<const0> ;
  assign axi_r_rd_data_count[10] = \<const0> ;
  assign axi_r_rd_data_count[9] = \<const0> ;
  assign axi_r_rd_data_count[8] = \<const0> ;
  assign axi_r_rd_data_count[7] = \<const0> ;
  assign axi_r_rd_data_count[6] = \<const0> ;
  assign axi_r_rd_data_count[5] = \<const0> ;
  assign axi_r_rd_data_count[4] = \<const0> ;
  assign axi_r_rd_data_count[3] = \<const0> ;
  assign axi_r_rd_data_count[2] = \<const0> ;
  assign axi_r_rd_data_count[1] = \<const0> ;
  assign axi_r_rd_data_count[0] = \<const0> ;
  assign axi_r_sbiterr = \<const0> ;
  assign axi_r_underflow = \<const0> ;
  assign axi_r_wr_data_count[10] = \<const0> ;
  assign axi_r_wr_data_count[9] = \<const0> ;
  assign axi_r_wr_data_count[8] = \<const0> ;
  assign axi_r_wr_data_count[7] = \<const0> ;
  assign axi_r_wr_data_count[6] = \<const0> ;
  assign axi_r_wr_data_count[5] = \<const0> ;
  assign axi_r_wr_data_count[4] = \<const0> ;
  assign axi_r_wr_data_count[3] = \<const0> ;
  assign axi_r_wr_data_count[2] = \<const0> ;
  assign axi_r_wr_data_count[1] = \<const0> ;
  assign axi_r_wr_data_count[0] = \<const0> ;
  assign axi_w_data_count[10] = \<const0> ;
  assign axi_w_data_count[9] = \<const0> ;
  assign axi_w_data_count[8] = \<const0> ;
  assign axi_w_data_count[7] = \<const0> ;
  assign axi_w_data_count[6] = \<const0> ;
  assign axi_w_data_count[5] = \<const0> ;
  assign axi_w_data_count[4] = \<const0> ;
  assign axi_w_data_count[3] = \<const0> ;
  assign axi_w_data_count[2] = \<const0> ;
  assign axi_w_data_count[1] = \<const0> ;
  assign axi_w_data_count[0] = \<const0> ;
  assign axi_w_dbiterr = \<const0> ;
  assign axi_w_overflow = \<const0> ;
  assign axi_w_prog_empty = \<const1> ;
  assign axi_w_prog_full = \<const0> ;
  assign axi_w_rd_data_count[10] = \<const0> ;
  assign axi_w_rd_data_count[9] = \<const0> ;
  assign axi_w_rd_data_count[8] = \<const0> ;
  assign axi_w_rd_data_count[7] = \<const0> ;
  assign axi_w_rd_data_count[6] = \<const0> ;
  assign axi_w_rd_data_count[5] = \<const0> ;
  assign axi_w_rd_data_count[4] = \<const0> ;
  assign axi_w_rd_data_count[3] = \<const0> ;
  assign axi_w_rd_data_count[2] = \<const0> ;
  assign axi_w_rd_data_count[1] = \<const0> ;
  assign axi_w_rd_data_count[0] = \<const0> ;
  assign axi_w_sbiterr = \<const0> ;
  assign axi_w_underflow = \<const0> ;
  assign axi_w_wr_data_count[10] = \<const0> ;
  assign axi_w_wr_data_count[9] = \<const0> ;
  assign axi_w_wr_data_count[8] = \<const0> ;
  assign axi_w_wr_data_count[7] = \<const0> ;
  assign axi_w_wr_data_count[6] = \<const0> ;
  assign axi_w_wr_data_count[5] = \<const0> ;
  assign axi_w_wr_data_count[4] = \<const0> ;
  assign axi_w_wr_data_count[3] = \<const0> ;
  assign axi_w_wr_data_count[2] = \<const0> ;
  assign axi_w_wr_data_count[1] = \<const0> ;
  assign axi_w_wr_data_count[0] = \<const0> ;
  assign axis_data_count[10] = \<const0> ;
  assign axis_data_count[9] = \<const0> ;
  assign axis_data_count[8] = \<const0> ;
  assign axis_data_count[7] = \<const0> ;
  assign axis_data_count[6] = \<const0> ;
  assign axis_data_count[5] = \<const0> ;
  assign axis_data_count[4] = \<const0> ;
  assign axis_data_count[3] = \<const0> ;
  assign axis_data_count[2] = \<const0> ;
  assign axis_data_count[1] = \<const0> ;
  assign axis_data_count[0] = \<const0> ;
  assign axis_dbiterr = \<const0> ;
  assign axis_overflow = \<const0> ;
  assign axis_prog_empty = \<const1> ;
  assign axis_prog_full = \<const0> ;
  assign axis_rd_data_count[10] = \<const0> ;
  assign axis_rd_data_count[9] = \<const0> ;
  assign axis_rd_data_count[8] = \<const0> ;
  assign axis_rd_data_count[7] = \<const0> ;
  assign axis_rd_data_count[6] = \<const0> ;
  assign axis_rd_data_count[5] = \<const0> ;
  assign axis_rd_data_count[4] = \<const0> ;
  assign axis_rd_data_count[3] = \<const0> ;
  assign axis_rd_data_count[2] = \<const0> ;
  assign axis_rd_data_count[1] = \<const0> ;
  assign axis_rd_data_count[0] = \<const0> ;
  assign axis_sbiterr = \<const0> ;
  assign axis_underflow = \<const0> ;
  assign axis_wr_data_count[10] = \<const0> ;
  assign axis_wr_data_count[9] = \<const0> ;
  assign axis_wr_data_count[8] = \<const0> ;
  assign axis_wr_data_count[7] = \<const0> ;
  assign axis_wr_data_count[6] = \<const0> ;
  assign axis_wr_data_count[5] = \<const0> ;
  assign axis_wr_data_count[4] = \<const0> ;
  assign axis_wr_data_count[3] = \<const0> ;
  assign axis_wr_data_count[2] = \<const0> ;
  assign axis_wr_data_count[1] = \<const0> ;
  assign axis_wr_data_count[0] = \<const0> ;
  assign data_count[5] = \<const0> ;
  assign data_count[4] = \<const0> ;
  assign data_count[3] = \<const0> ;
  assign data_count[2] = \<const0> ;
  assign data_count[1] = \<const0> ;
  assign data_count[0] = \<const0> ;
  assign dbiterr = \<const0> ;
  assign m_axi_araddr[31] = \<const0> ;
  assign m_axi_araddr[30] = \<const0> ;
  assign m_axi_araddr[29] = \<const0> ;
  assign m_axi_araddr[28] = \<const0> ;
  assign m_axi_araddr[27] = \<const0> ;
  assign m_axi_araddr[26] = \<const0> ;
  assign m_axi_araddr[25] = \<const0> ;
  assign m_axi_araddr[24] = \<const0> ;
  assign m_axi_araddr[23] = \<const0> ;
  assign m_axi_araddr[22] = \<const0> ;
  assign m_axi_araddr[21] = \<const0> ;
  assign m_axi_araddr[20] = \<const0> ;
  assign m_axi_araddr[19] = \<const0> ;
  assign m_axi_araddr[18] = \<const0> ;
  assign m_axi_araddr[17] = \<const0> ;
  assign m_axi_araddr[16] = \<const0> ;
  assign m_axi_araddr[15] = \<const0> ;
  assign m_axi_araddr[14] = \<const0> ;
  assign m_axi_araddr[13] = \<const0> ;
  assign m_axi_araddr[12] = \<const0> ;
  assign m_axi_araddr[11] = \<const0> ;
  assign m_axi_araddr[10] = \<const0> ;
  assign m_axi_araddr[9] = \<const0> ;
  assign m_axi_araddr[8] = \<const0> ;
  assign m_axi_araddr[7] = \<const0> ;
  assign m_axi_araddr[6] = \<const0> ;
  assign m_axi_araddr[5] = \<const0> ;
  assign m_axi_araddr[4] = \<const0> ;
  assign m_axi_araddr[3] = \<const0> ;
  assign m_axi_araddr[2] = \<const0> ;
  assign m_axi_araddr[1] = \<const0> ;
  assign m_axi_araddr[0] = \<const0> ;
  assign m_axi_arburst[1] = \<const0> ;
  assign m_axi_arburst[0] = \<const0> ;
  assign m_axi_arcache[3] = \<const0> ;
  assign m_axi_arcache[2] = \<const0> ;
  assign m_axi_arcache[1] = \<const0> ;
  assign m_axi_arcache[0] = \<const0> ;
  assign m_axi_arid[0] = \<const0> ;
  assign m_axi_arlen[7] = \<const0> ;
  assign m_axi_arlen[6] = \<const0> ;
  assign m_axi_arlen[5] = \<const0> ;
  assign m_axi_arlen[4] = \<const0> ;
  assign m_axi_arlen[3] = \<const0> ;
  assign m_axi_arlen[2] = \<const0> ;
  assign m_axi_arlen[1] = \<const0> ;
  assign m_axi_arlen[0] = \<const0> ;
  assign m_axi_arlock[0] = \<const0> ;
  assign m_axi_arprot[2] = \<const0> ;
  assign m_axi_arprot[1] = \<const0> ;
  assign m_axi_arprot[0] = \<const0> ;
  assign m_axi_arqos[3] = \<const0> ;
  assign m_axi_arqos[2] = \<const0> ;
  assign m_axi_arqos[1] = \<const0> ;
  assign m_axi_arqos[0] = \<const0> ;
  assign m_axi_arregion[3] = \<const0> ;
  assign m_axi_arregion[2] = \<const0> ;
  assign m_axi_arregion[1] = \<const0> ;
  assign m_axi_arregion[0] = \<const0> ;
  assign m_axi_arsize[2] = \<const0> ;
  assign m_axi_arsize[1] = \<const0> ;
  assign m_axi_arsize[0] = \<const0> ;
  assign m_axi_aruser[0] = \<const0> ;
  assign m_axi_arvalid = \<const0> ;
  assign m_axi_awaddr[31] = \<const0> ;
  assign m_axi_awaddr[30] = \<const0> ;
  assign m_axi_awaddr[29] = \<const0> ;
  assign m_axi_awaddr[28] = \<const0> ;
  assign m_axi_awaddr[27] = \<const0> ;
  assign m_axi_awaddr[26] = \<const0> ;
  assign m_axi_awaddr[25] = \<const0> ;
  assign m_axi_awaddr[24] = \<const0> ;
  assign m_axi_awaddr[23] = \<const0> ;
  assign m_axi_awaddr[22] = \<const0> ;
  assign m_axi_awaddr[21] = \<const0> ;
  assign m_axi_awaddr[20] = \<const0> ;
  assign m_axi_awaddr[19] = \<const0> ;
  assign m_axi_awaddr[18] = \<const0> ;
  assign m_axi_awaddr[17] = \<const0> ;
  assign m_axi_awaddr[16] = \<const0> ;
  assign m_axi_awaddr[15] = \<const0> ;
  assign m_axi_awaddr[14] = \<const0> ;
  assign m_axi_awaddr[13] = \<const0> ;
  assign m_axi_awaddr[12] = \<const0> ;
  assign m_axi_awaddr[11] = \<const0> ;
  assign m_axi_awaddr[10] = \<const0> ;
  assign m_axi_awaddr[9] = \<const0> ;
  assign m_axi_awaddr[8] = \<const0> ;
  assign m_axi_awaddr[7] = \<const0> ;
  assign m_axi_awaddr[6] = \<const0> ;
  assign m_axi_awaddr[5] = \<const0> ;
  assign m_axi_awaddr[4] = \<const0> ;
  assign m_axi_awaddr[3] = \<const0> ;
  assign m_axi_awaddr[2] = \<const0> ;
  assign m_axi_awaddr[1] = \<const0> ;
  assign m_axi_awaddr[0] = \<const0> ;
  assign m_axi_awburst[1] = \<const0> ;
  assign m_axi_awburst[0] = \<const0> ;
  assign m_axi_awcache[3] = \<const0> ;
  assign m_axi_awcache[2] = \<const0> ;
  assign m_axi_awcache[1] = \<const0> ;
  assign m_axi_awcache[0] = \<const0> ;
  assign m_axi_awid[0] = \<const0> ;
  assign m_axi_awlen[7] = \<const0> ;
  assign m_axi_awlen[6] = \<const0> ;
  assign m_axi_awlen[5] = \<const0> ;
  assign m_axi_awlen[4] = \<const0> ;
  assign m_axi_awlen[3] = \<const0> ;
  assign m_axi_awlen[2] = \<const0> ;
  assign m_axi_awlen[1] = \<const0> ;
  assign m_axi_awlen[0] = \<const0> ;
  assign m_axi_awlock[0] = \<const0> ;
  assign m_axi_awprot[2] = \<const0> ;
  assign m_axi_awprot[1] = \<const0> ;
  assign m_axi_awprot[0] = \<const0> ;
  assign m_axi_awqos[3] = \<const0> ;
  assign m_axi_awqos[2] = \<const0> ;
  assign m_axi_awqos[1] = \<const0> ;
  assign m_axi_awqos[0] = \<const0> ;
  assign m_axi_awregion[3] = \<const0> ;
  assign m_axi_awregion[2] = \<const0> ;
  assign m_axi_awregion[1] = \<const0> ;
  assign m_axi_awregion[0] = \<const0> ;
  assign m_axi_awsize[2] = \<const0> ;
  assign m_axi_awsize[1] = \<const0> ;
  assign m_axi_awsize[0] = \<const0> ;
  assign m_axi_awuser[0] = \<const0> ;
  assign m_axi_awvalid = \<const0> ;
  assign m_axi_bready = \<const0> ;
  assign m_axi_rready = \<const0> ;
  assign m_axi_wdata[63] = \<const0> ;
  assign m_axi_wdata[62] = \<const0> ;
  assign m_axi_wdata[61] = \<const0> ;
  assign m_axi_wdata[60] = \<const0> ;
  assign m_axi_wdata[59] = \<const0> ;
  assign m_axi_wdata[58] = \<const0> ;
  assign m_axi_wdata[57] = \<const0> ;
  assign m_axi_wdata[56] = \<const0> ;
  assign m_axi_wdata[55] = \<const0> ;
  assign m_axi_wdata[54] = \<const0> ;
  assign m_axi_wdata[53] = \<const0> ;
  assign m_axi_wdata[52] = \<const0> ;
  assign m_axi_wdata[51] = \<const0> ;
  assign m_axi_wdata[50] = \<const0> ;
  assign m_axi_wdata[49] = \<const0> ;
  assign m_axi_wdata[48] = \<const0> ;
  assign m_axi_wdata[47] = \<const0> ;
  assign m_axi_wdata[46] = \<const0> ;
  assign m_axi_wdata[45] = \<const0> ;
  assign m_axi_wdata[44] = \<const0> ;
  assign m_axi_wdata[43] = \<const0> ;
  assign m_axi_wdata[42] = \<const0> ;
  assign m_axi_wdata[41] = \<const0> ;
  assign m_axi_wdata[40] = \<const0> ;
  assign m_axi_wdata[39] = \<const0> ;
  assign m_axi_wdata[38] = \<const0> ;
  assign m_axi_wdata[37] = \<const0> ;
  assign m_axi_wdata[36] = \<const0> ;
  assign m_axi_wdata[35] = \<const0> ;
  assign m_axi_wdata[34] = \<const0> ;
  assign m_axi_wdata[33] = \<const0> ;
  assign m_axi_wdata[32] = \<const0> ;
  assign m_axi_wdata[31] = \<const0> ;
  assign m_axi_wdata[30] = \<const0> ;
  assign m_axi_wdata[29] = \<const0> ;
  assign m_axi_wdata[28] = \<const0> ;
  assign m_axi_wdata[27] = \<const0> ;
  assign m_axi_wdata[26] = \<const0> ;
  assign m_axi_wdata[25] = \<const0> ;
  assign m_axi_wdata[24] = \<const0> ;
  assign m_axi_wdata[23] = \<const0> ;
  assign m_axi_wdata[22] = \<const0> ;
  assign m_axi_wdata[21] = \<const0> ;
  assign m_axi_wdata[20] = \<const0> ;
  assign m_axi_wdata[19] = \<const0> ;
  assign m_axi_wdata[18] = \<const0> ;
  assign m_axi_wdata[17] = \<const0> ;
  assign m_axi_wdata[16] = \<const0> ;
  assign m_axi_wdata[15] = \<const0> ;
  assign m_axi_wdata[14] = \<const0> ;
  assign m_axi_wdata[13] = \<const0> ;
  assign m_axi_wdata[12] = \<const0> ;
  assign m_axi_wdata[11] = \<const0> ;
  assign m_axi_wdata[10] = \<const0> ;
  assign m_axi_wdata[9] = \<const0> ;
  assign m_axi_wdata[8] = \<const0> ;
  assign m_axi_wdata[7] = \<const0> ;
  assign m_axi_wdata[6] = \<const0> ;
  assign m_axi_wdata[5] = \<const0> ;
  assign m_axi_wdata[4] = \<const0> ;
  assign m_axi_wdata[3] = \<const0> ;
  assign m_axi_wdata[2] = \<const0> ;
  assign m_axi_wdata[1] = \<const0> ;
  assign m_axi_wdata[0] = \<const0> ;
  assign m_axi_wid[0] = \<const0> ;
  assign m_axi_wlast = \<const0> ;
  assign m_axi_wstrb[7] = \<const0> ;
  assign m_axi_wstrb[6] = \<const0> ;
  assign m_axi_wstrb[5] = \<const0> ;
  assign m_axi_wstrb[4] = \<const0> ;
  assign m_axi_wstrb[3] = \<const0> ;
  assign m_axi_wstrb[2] = \<const0> ;
  assign m_axi_wstrb[1] = \<const0> ;
  assign m_axi_wstrb[0] = \<const0> ;
  assign m_axi_wuser[0] = \<const0> ;
  assign m_axi_wvalid = \<const0> ;
  assign m_axis_tdata[7] = \<const0> ;
  assign m_axis_tdata[6] = \<const0> ;
  assign m_axis_tdata[5] = \<const0> ;
  assign m_axis_tdata[4] = \<const0> ;
  assign m_axis_tdata[3] = \<const0> ;
  assign m_axis_tdata[2] = \<const0> ;
  assign m_axis_tdata[1] = \<const0> ;
  assign m_axis_tdata[0] = \<const0> ;
  assign m_axis_tdest[0] = \<const0> ;
  assign m_axis_tid[0] = \<const0> ;
  assign m_axis_tkeep[0] = \<const0> ;
  assign m_axis_tlast = \<const0> ;
  assign m_axis_tstrb[0] = \<const0> ;
  assign m_axis_tuser[3] = \<const0> ;
  assign m_axis_tuser[2] = \<const0> ;
  assign m_axis_tuser[1] = \<const0> ;
  assign m_axis_tuser[0] = \<const0> ;
  assign m_axis_tvalid = \<const0> ;
  assign overflow = \<const0> ;
  assign prog_empty = \<const0> ;
  assign prog_full = \<const0> ;
  assign rd_data_count[5] = \<const0> ;
  assign rd_data_count[4] = \<const0> ;
  assign rd_data_count[3] = \<const0> ;
  assign rd_data_count[2] = \<const0> ;
  assign rd_data_count[1] = \<const0> ;
  assign rd_data_count[0] = \<const0> ;
  assign s_axi_arready = \<const0> ;
  assign s_axi_awready = \<const0> ;
  assign s_axi_bid[0] = \<const0> ;
  assign s_axi_bresp[1] = \<const0> ;
  assign s_axi_bresp[0] = \<const0> ;
  assign s_axi_buser[0] = \<const0> ;
  assign s_axi_bvalid = \<const0> ;
  assign s_axi_rdata[63] = \<const0> ;
  assign s_axi_rdata[62] = \<const0> ;
  assign s_axi_rdata[61] = \<const0> ;
  assign s_axi_rdata[60] = \<const0> ;
  assign s_axi_rdata[59] = \<const0> ;
  assign s_axi_rdata[58] = \<const0> ;
  assign s_axi_rdata[57] = \<const0> ;
  assign s_axi_rdata[56] = \<const0> ;
  assign s_axi_rdata[55] = \<const0> ;
  assign s_axi_rdata[54] = \<const0> ;
  assign s_axi_rdata[53] = \<const0> ;
  assign s_axi_rdata[52] = \<const0> ;
  assign s_axi_rdata[51] = \<const0> ;
  assign s_axi_rdata[50] = \<const0> ;
  assign s_axi_rdata[49] = \<const0> ;
  assign s_axi_rdata[48] = \<const0> ;
  assign s_axi_rdata[47] = \<const0> ;
  assign s_axi_rdata[46] = \<const0> ;
  assign s_axi_rdata[45] = \<const0> ;
  assign s_axi_rdata[44] = \<const0> ;
  assign s_axi_rdata[43] = \<const0> ;
  assign s_axi_rdata[42] = \<const0> ;
  assign s_axi_rdata[41] = \<const0> ;
  assign s_axi_rdata[40] = \<const0> ;
  assign s_axi_rdata[39] = \<const0> ;
  assign s_axi_rdata[38] = \<const0> ;
  assign s_axi_rdata[37] = \<const0> ;
  assign s_axi_rdata[36] = \<const0> ;
  assign s_axi_rdata[35] = \<const0> ;
  assign s_axi_rdata[34] = \<const0> ;
  assign s_axi_rdata[33] = \<const0> ;
  assign s_axi_rdata[32] = \<const0> ;
  assign s_axi_rdata[31] = \<const0> ;
  assign s_axi_rdata[30] = \<const0> ;
  assign s_axi_rdata[29] = \<const0> ;
  assign s_axi_rdata[28] = \<const0> ;
  assign s_axi_rdata[27] = \<const0> ;
  assign s_axi_rdata[26] = \<const0> ;
  assign s_axi_rdata[25] = \<const0> ;
  assign s_axi_rdata[24] = \<const0> ;
  assign s_axi_rdata[23] = \<const0> ;
  assign s_axi_rdata[22] = \<const0> ;
  assign s_axi_rdata[21] = \<const0> ;
  assign s_axi_rdata[20] = \<const0> ;
  assign s_axi_rdata[19] = \<const0> ;
  assign s_axi_rdata[18] = \<const0> ;
  assign s_axi_rdata[17] = \<const0> ;
  assign s_axi_rdata[16] = \<const0> ;
  assign s_axi_rdata[15] = \<const0> ;
  assign s_axi_rdata[14] = \<const0> ;
  assign s_axi_rdata[13] = \<const0> ;
  assign s_axi_rdata[12] = \<const0> ;
  assign s_axi_rdata[11] = \<const0> ;
  assign s_axi_rdata[10] = \<const0> ;
  assign s_axi_rdata[9] = \<const0> ;
  assign s_axi_rdata[8] = \<const0> ;
  assign s_axi_rdata[7] = \<const0> ;
  assign s_axi_rdata[6] = \<const0> ;
  assign s_axi_rdata[5] = \<const0> ;
  assign s_axi_rdata[4] = \<const0> ;
  assign s_axi_rdata[3] = \<const0> ;
  assign s_axi_rdata[2] = \<const0> ;
  assign s_axi_rdata[1] = \<const0> ;
  assign s_axi_rdata[0] = \<const0> ;
  assign s_axi_rid[0] = \<const0> ;
  assign s_axi_rlast = \<const0> ;
  assign s_axi_rresp[1] = \<const0> ;
  assign s_axi_rresp[0] = \<const0> ;
  assign s_axi_ruser[0] = \<const0> ;
  assign s_axi_rvalid = \<const0> ;
  assign s_axi_wready = \<const0> ;
  assign s_axis_tready = \<const0> ;
  assign sbiterr = \<const0> ;
  assign underflow = \<const0> ;
  assign wr_ack = \<const0> ;
  assign wr_data_count[5] = \<const0> ;
  assign wr_data_count[4] = \<const0> ;
  assign wr_data_count[3] = \<const0> ;
  assign wr_data_count[2] = \<const0> ;
  assign wr_data_count[1] = \<const0> ;
  assign wr_data_count[0] = \<const0> ;
  GND GND
       (.G(\<const0> ));
  VCC VCC
       (.P(\<const1> ));
  ge11_rx_fifo_fifo_generator_v13_2_5_synth inst_fifo_gen
       (.SR(rd_rst_busy),
        .din(din),
        .dout(dout),
        .empty(empty),
        .full(full),
        .rd_clk(rd_clk),
        .rd_en(rd_en),
        .rst(rst),
        .valid(valid),
        .wr_clk(wr_clk),
        .wr_en(wr_en),
        .wr_rst_busy(wr_rst_busy));
endmodule

module ge11_rx_fifo_fifo_generator_v13_2_5_synth
   (SR,
    wr_rst_busy,
    empty,
    full,
    dout,
    valid,
    wr_clk,
    rd_clk,
    rd_en,
    rst,
    din,
    wr_en);
  output [0:0]SR;
  output wr_rst_busy;
  output empty;
  output full;
  output [255:0]dout;
  output valid;
  input wr_clk;
  input rd_clk;
  input rd_en;
  input rst;
  input [255:0]din;
  input wr_en;

  wire [0:0]SR;
  wire [255:0]din;
  wire [255:0]dout;
  wire empty;
  wire full;
  wire rd_clk;
  wire rd_en;
  wire rst;
  wire valid;
  wire wr_clk;
  wire wr_en;
  wire wr_rst_busy;

  ge11_rx_fifo_fifo_generator_top \gconvfifo.rf 
       (.SR(SR),
        .din(din),
        .dout(dout),
        .empty(empty),
        .full(full),
        .rd_clk(rd_clk),
        .rd_en(rd_en),
        .rst(rst),
        .valid(valid),
        .wr_clk(wr_clk),
        .wr_en(wr_en),
        .wr_rst_busy(wr_rst_busy));
endmodule

module ge11_rx_fifo_memory
   (tmp_ram_rd_en_d1,
    dout,
    wr_clk,
    rd_clk,
    Q,
    \DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram ,
    din,
    E,
    SR,
    \gbm.gregce.ram_rd_en_d1_reg_0 ,
    rd_en,
    out,
    FULL_FB,
    wr_en,
    \mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255] );
  output tmp_ram_rd_en_d1;
  output [255:0]dout;
  input wr_clk;
  input rd_clk;
  input [5:0]Q;
  input [5:0]\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram ;
  input [255:0]din;
  input [0:0]E;
  input [0:0]SR;
  input [0:0]\gbm.gregce.ram_rd_en_d1_reg_0 ;
  input rd_en;
  input out;
  input FULL_FB;
  input wr_en;
  input [0:0]\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255] ;

  wire [5:0]\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram ;
  wire [0:0]E;
  wire FULL_FB;
  wire [5:0]Q;
  wire [0:0]SR;
  wire [255:0]din;
  wire [255:0]dout;
  wire [0:0]\gbm.gregce.ram_rd_en_d1_reg_0 ;
  wire [0:0]\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255] ;
  wire out;
  wire ram_rd_en_d1;
  wire rd_clk;
  wire rd_en;
  wire tmp_ram_rd_en_d1;
  wire wr_clk;
  wire wr_en;

  ge11_rx_fifo_blk_mem_gen_v8_4_4 \gbm.gbmg.gbmgc.ngecc.bmg 
       (.\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram (\DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram ),
        .E(E),
        .FULL_FB(FULL_FB),
        .Q(Q),
        .SR(SR),
        .din(din),
        .dout(dout),
        .\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255] (\mux_b_wire.mux_reg.ce_pri.doutb_i_reg[255] ),
        .out(out),
        .ram_rd_en_d1(ram_rd_en_d1),
        .rd_clk(rd_clk),
        .rd_en(rd_en),
        .tmp_ram_rd_en_d1(tmp_ram_rd_en_d1),
        .wr_clk(wr_clk),
        .wr_en(wr_en));
  FDRE #(
    .INIT(1'b0)) 
    \gbm.gregce.ram_rd_en_d1_reg 
       (.C(rd_clk),
        .CE(1'b1),
        .D(\gbm.gregce.ram_rd_en_d1_reg_0 ),
        .Q(ram_rd_en_d1),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \gbm.gregce.tmp_ram_rd_en_d1_reg 
       (.C(rd_clk),
        .CE(1'b1),
        .D(ram_rd_en_d1),
        .Q(tmp_ram_rd_en_d1),
        .R(SR));
endmodule

module ge11_rx_fifo_rd_bin_cntr
   (\ngwrdrst.grst.g7serrst.gsckt_wrst.gic_rst.sckt_rd_rst_ic_reg ,
    Q,
    SR,
    out,
    rd_en,
    WR_PNTR_RD,
    E,
    rd_clk);
  output \ngwrdrst.grst.g7serrst.gsckt_wrst.gic_rst.sckt_rd_rst_ic_reg ;
  output [5:0]Q;
  input [0:0]SR;
  input out;
  input rd_en;
  input [5:0]WR_PNTR_RD;
  input [0:0]E;
  input rd_clk;

  wire [0:0]E;
  wire [5:0]Q;
  wire [0:0]SR;
  wire [5:0]WR_PNTR_RD;
  wire \gras.rsts/comp0 ;
  wire \gras.rsts/comp1 ;
  wire \ngwrdrst.grst.g7serrst.gsckt_wrst.gic_rst.sckt_rd_rst_ic_reg ;
  wire out;
  wire [5:0]plusOp__0;
  wire ram_empty_i_i_4_n_0;
  wire ram_empty_i_i_5_n_0;
  wire ram_empty_i_i_6_n_0;
  wire ram_empty_i_i_7_n_0;
  wire rd_clk;
  wire rd_en;
  wire [5:0]rd_pntr_plus1;

  LUT1 #(
    .INIT(2'h1)) 
    \gc0.count[0]_i_1 
       (.I0(rd_pntr_plus1[0]),
        .O(plusOp__0[0]));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \gc0.count[1]_i_1 
       (.I0(rd_pntr_plus1[0]),
        .I1(rd_pntr_plus1[1]),
        .O(plusOp__0[1]));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \gc0.count[2]_i_1 
       (.I0(rd_pntr_plus1[0]),
        .I1(rd_pntr_plus1[1]),
        .I2(rd_pntr_plus1[2]),
        .O(plusOp__0[2]));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT4 #(
    .INIT(16'h7F80)) 
    \gc0.count[3]_i_1 
       (.I0(rd_pntr_plus1[1]),
        .I1(rd_pntr_plus1[0]),
        .I2(rd_pntr_plus1[2]),
        .I3(rd_pntr_plus1[3]),
        .O(plusOp__0[3]));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT5 #(
    .INIT(32'h7FFF8000)) 
    \gc0.count[4]_i_1 
       (.I0(rd_pntr_plus1[2]),
        .I1(rd_pntr_plus1[0]),
        .I2(rd_pntr_plus1[1]),
        .I3(rd_pntr_plus1[3]),
        .I4(rd_pntr_plus1[4]),
        .O(plusOp__0[4]));
  LUT6 #(
    .INIT(64'h7FFFFFFF80000000)) 
    \gc0.count[5]_i_1 
       (.I0(rd_pntr_plus1[3]),
        .I1(rd_pntr_plus1[1]),
        .I2(rd_pntr_plus1[0]),
        .I3(rd_pntr_plus1[2]),
        .I4(rd_pntr_plus1[4]),
        .I5(rd_pntr_plus1[5]),
        .O(plusOp__0[5]));
  FDRE #(
    .INIT(1'b0)) 
    \gc0.count_d1_reg[0] 
       (.C(rd_clk),
        .CE(E),
        .D(rd_pntr_plus1[0]),
        .Q(Q[0]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \gc0.count_d1_reg[1] 
       (.C(rd_clk),
        .CE(E),
        .D(rd_pntr_plus1[1]),
        .Q(Q[1]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \gc0.count_d1_reg[2] 
       (.C(rd_clk),
        .CE(E),
        .D(rd_pntr_plus1[2]),
        .Q(Q[2]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \gc0.count_d1_reg[3] 
       (.C(rd_clk),
        .CE(E),
        .D(rd_pntr_plus1[3]),
        .Q(Q[3]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \gc0.count_d1_reg[4] 
       (.C(rd_clk),
        .CE(E),
        .D(rd_pntr_plus1[4]),
        .Q(Q[4]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \gc0.count_d1_reg[5] 
       (.C(rd_clk),
        .CE(E),
        .D(rd_pntr_plus1[5]),
        .Q(Q[5]),
        .R(SR));
  FDSE #(
    .INIT(1'b1)) 
    \gc0.count_reg[0] 
       (.C(rd_clk),
        .CE(E),
        .D(plusOp__0[0]),
        .Q(rd_pntr_plus1[0]),
        .S(SR));
  FDRE #(
    .INIT(1'b0)) 
    \gc0.count_reg[1] 
       (.C(rd_clk),
        .CE(E),
        .D(plusOp__0[1]),
        .Q(rd_pntr_plus1[1]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \gc0.count_reg[2] 
       (.C(rd_clk),
        .CE(E),
        .D(plusOp__0[2]),
        .Q(rd_pntr_plus1[2]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \gc0.count_reg[3] 
       (.C(rd_clk),
        .CE(E),
        .D(plusOp__0[3]),
        .Q(rd_pntr_plus1[3]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \gc0.count_reg[4] 
       (.C(rd_clk),
        .CE(E),
        .D(plusOp__0[4]),
        .Q(rd_pntr_plus1[4]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \gc0.count_reg[5] 
       (.C(rd_clk),
        .CE(E),
        .D(plusOp__0[5]),
        .Q(rd_pntr_plus1[5]),
        .R(SR));
  LUT5 #(
    .INIT(32'hFFFFAEAA)) 
    ram_empty_i_i_1
       (.I0(SR),
        .I1(\gras.rsts/comp1 ),
        .I2(out),
        .I3(rd_en),
        .I4(\gras.rsts/comp0 ),
        .O(\ngwrdrst.grst.g7serrst.gsckt_wrst.gic_rst.sckt_rd_rst_ic_reg ));
  LUT6 #(
    .INIT(64'h9009000000000000)) 
    ram_empty_i_i_2
       (.I0(WR_PNTR_RD[1]),
        .I1(rd_pntr_plus1[1]),
        .I2(WR_PNTR_RD[0]),
        .I3(rd_pntr_plus1[0]),
        .I4(ram_empty_i_i_4_n_0),
        .I5(ram_empty_i_i_5_n_0),
        .O(\gras.rsts/comp1 ));
  LUT6 #(
    .INIT(64'h9009000000000000)) 
    ram_empty_i_i_3
       (.I0(WR_PNTR_RD[1]),
        .I1(Q[1]),
        .I2(WR_PNTR_RD[0]),
        .I3(Q[0]),
        .I4(ram_empty_i_i_6_n_0),
        .I5(ram_empty_i_i_7_n_0),
        .O(\gras.rsts/comp0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    ram_empty_i_i_4
       (.I0(rd_pntr_plus1[4]),
        .I1(WR_PNTR_RD[4]),
        .I2(rd_pntr_plus1[5]),
        .I3(WR_PNTR_RD[5]),
        .O(ram_empty_i_i_4_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    ram_empty_i_i_5
       (.I0(rd_pntr_plus1[2]),
        .I1(WR_PNTR_RD[2]),
        .I2(rd_pntr_plus1[3]),
        .I3(WR_PNTR_RD[3]),
        .O(ram_empty_i_i_5_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    ram_empty_i_i_6
       (.I0(Q[4]),
        .I1(WR_PNTR_RD[4]),
        .I2(Q[5]),
        .I3(WR_PNTR_RD[5]),
        .O(ram_empty_i_i_6_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    ram_empty_i_i_7
       (.I0(Q[2]),
        .I1(WR_PNTR_RD[2]),
        .I2(Q[3]),
        .I3(WR_PNTR_RD[3]),
        .O(ram_empty_i_i_7_n_0));
endmodule

module ge11_rx_fifo_rd_handshaking_flags
   (valid,
    SR,
    ram_valid_i,
    rd_clk);
  output valid;
  input [0:0]SR;
  input ram_valid_i;
  input rd_clk;

  wire [0:0]SR;
  wire ram_valid_d1;
  wire ram_valid_d2;
  wire ram_valid_i;
  wire rd_clk;
  wire valid;

  FDRE #(
    .INIT(1'b0)) 
    \gv.ram_valid_d1_reg 
       (.C(rd_clk),
        .CE(1'b1),
        .D(ram_valid_i),
        .Q(ram_valid_d1),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \gvep2.ram_valid_d2_reg 
       (.C(rd_clk),
        .CE(1'b1),
        .D(ram_valid_d1),
        .Q(ram_valid_d2),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \gvep2.ram_valid_d3_reg 
       (.C(rd_clk),
        .CE(1'b1),
        .D(ram_valid_d2),
        .Q(valid),
        .R(SR));
endmodule

module ge11_rx_fifo_rd_logic
   (empty,
    out,
    valid,
    E,
    Q,
    rd_clk,
    SR,
    rd_en,
    WR_PNTR_RD);
  output empty;
  output out;
  output valid;
  output [0:0]E;
  output [5:0]Q;
  input rd_clk;
  input [0:0]SR;
  input rd_en;
  input [5:0]WR_PNTR_RD;

  wire [0:0]E;
  wire [5:0]Q;
  wire [0:0]SR;
  wire [5:0]WR_PNTR_RD;
  wire empty;
  wire out;
  wire ram_valid_i;
  wire rd_clk;
  wire rd_en;
  wire rpntr_n_0;
  wire valid;

  ge11_rx_fifo_rd_status_flags_as \gras.rsts 
       (.E(E),
        .empty(empty),
        .out(out),
        .ram_empty_i_reg_0(rpntr_n_0),
        .ram_valid_i(ram_valid_i),
        .rd_clk(rd_clk),
        .rd_en(rd_en));
  ge11_rx_fifo_rd_handshaking_flags \grhf.rhf 
       (.SR(SR),
        .ram_valid_i(ram_valid_i),
        .rd_clk(rd_clk),
        .valid(valid));
  ge11_rx_fifo_rd_bin_cntr rpntr
       (.E(E),
        .Q(Q),
        .SR(SR),
        .WR_PNTR_RD(WR_PNTR_RD),
        .\ngwrdrst.grst.g7serrst.gsckt_wrst.gic_rst.sckt_rd_rst_ic_reg (rpntr_n_0),
        .out(out),
        .rd_clk(rd_clk),
        .rd_en(rd_en));
endmodule

module ge11_rx_fifo_rd_status_flags_as
   (empty,
    out,
    ram_valid_i,
    E,
    ram_empty_i_reg_0,
    rd_clk,
    rd_en);
  output empty;
  output out;
  output ram_valid_i;
  output [0:0]E;
  input ram_empty_i_reg_0;
  input rd_clk;
  input rd_en;

  wire [0:0]E;
  (* DONT_TOUCH *) wire ram_empty_fb_i;
  (* DONT_TOUCH *) wire ram_empty_i;
  wire ram_empty_i_reg_0;
  wire ram_valid_i;
  wire rd_clk;
  wire rd_en;

  assign empty = ram_empty_i;
  assign out = ram_empty_fb_i;
  LUT2 #(
    .INIT(4'h2)) 
    \gbm.gregce.ram_rd_en_d1_i_1 
       (.I0(rd_en),
        .I1(ram_empty_fb_i),
        .O(E));
  LUT2 #(
    .INIT(4'h2)) 
    \gv.ram_valid_d1_i_1 
       (.I0(rd_en),
        .I1(ram_empty_i),
        .O(ram_valid_i));
  (* DONT_TOUCH *) 
  (* KEEP = "yes" *) 
  (* equivalent_register_removal = "no" *) 
  FDRE #(
    .INIT(1'b1)) 
    ram_empty_fb_i_reg
       (.C(rd_clk),
        .CE(1'b1),
        .D(ram_empty_i_reg_0),
        .Q(ram_empty_fb_i),
        .R(1'b0));
  (* DONT_TOUCH *) 
  (* KEEP = "yes" *) 
  (* equivalent_register_removal = "no" *) 
  FDRE #(
    .INIT(1'b1)) 
    ram_empty_i_reg
       (.C(rd_clk),
        .CE(1'b1),
        .D(ram_empty_i_reg_0),
        .Q(ram_empty_i),
        .R(1'b0));
endmodule

module ge11_rx_fifo_reset_blk_ramfifo
   (\ngwrdrst.grst.g7serrst.gsckt_wrst.gic_rst.sckt_wr_rst_ic_reg_0 ,
    SR,
    wr_rst_busy,
    \ngwrdrst.grst.g7serrst.gsckt_wrst.gic_rst.sckt_rd_rst_ic_reg_0 ,
    rst,
    wr_clk,
    rd_clk,
    tmp_ram_rd_en_d1);
  output \ngwrdrst.grst.g7serrst.gsckt_wrst.gic_rst.sckt_wr_rst_ic_reg_0 ;
  output [0:0]SR;
  output wr_rst_busy;
  output [0:0]\ngwrdrst.grst.g7serrst.gsckt_wrst.gic_rst.sckt_rd_rst_ic_reg_0 ;
  input rst;
  input wr_clk;
  input rd_clk;
  input tmp_ram_rd_en_d1;

  wire [0:0]SR;
  wire arst_sync_rd_rst;
  wire dest_out;
  wire dest_rst;
  wire \ngwrdrst.grst.g7serrst.gsckt_wrst.gic_rst.rd_rst_wr_ext_reg_n_0_[0] ;
  wire \ngwrdrst.grst.g7serrst.gsckt_wrst.gic_rst.rd_rst_wr_ext_reg_n_0_[1] ;
  wire \ngwrdrst.grst.g7serrst.gsckt_wrst.gic_rst.rd_rst_wr_ext_reg_n_0_[3] ;
  wire \ngwrdrst.grst.g7serrst.gsckt_wrst.gic_rst.sckt_rd_rst_ic_i_1_n_0 ;
  wire [0:0]\ngwrdrst.grst.g7serrst.gsckt_wrst.gic_rst.sckt_rd_rst_ic_reg_0 ;
  wire \ngwrdrst.grst.g7serrst.gsckt_wrst.gic_rst.sckt_wr_rst_ic_i_1_n_0 ;
  wire \ngwrdrst.grst.g7serrst.gsckt_wrst.gic_rst.sckt_wr_rst_ic_reg_0 ;
  wire \ngwrdrst.grst.g7serrst.gsckt_wrst.gic_rst.wr_rst_busy_i_i_1_n_0 ;
  wire p_0_in;
  wire rd_clk;
  (* DONT_TOUCH *) wire [2:0]rd_rst_reg;
  wire rst;
  (* async_reg = "true" *) (* msgon = "true" *) wire rst_rd_reg1;
  (* async_reg = "true" *) (* msgon = "true" *) wire rst_rd_reg2;
  (* async_reg = "true" *) (* msgon = "true" *) wire rst_wr_reg1;
  (* async_reg = "true" *) (* msgon = "true" *) wire rst_wr_reg2;
  wire sckt_rd_rst_wr;
  wire tmp_ram_rd_en_d1;
  wire wr_clk;
  wire wr_rst_busy;
  wire [1:0]wr_rst_rd_ext;
  (* DONT_TOUCH *) wire [2:0]wr_rst_reg;
  wire \NLW_ngwrdrst.grst.g7serrst.gnrst_full.gsckt_bsy_o.xpm_cdc_sync_rst_sckt_bsy_o_dest_rst_UNCONNECTED ;

  LUT1 #(
    .INIT(2'h2)) 
    i_0
       (.I0(1'b0),
        .O(rst_wr_reg2));
  LUT1 #(
    .INIT(2'h2)) 
    i_1
       (.I0(1'b1),
        .O(wr_rst_reg[2]));
  LUT1 #(
    .INIT(2'h2)) 
    i_2
       (.I0(1'b1),
        .O(wr_rst_reg[1]));
  LUT1 #(
    .INIT(2'h2)) 
    i_3
       (.I0(1'b1),
        .O(wr_rst_reg[0]));
  LUT1 #(
    .INIT(2'h2)) 
    i_4
       (.I0(1'b1),
        .O(rd_rst_reg[2]));
  LUT1 #(
    .INIT(2'h2)) 
    i_5
       (.I0(1'b1),
        .O(rd_rst_reg[1]));
  LUT1 #(
    .INIT(2'h2)) 
    i_6
       (.I0(1'b1),
        .O(rd_rst_reg[0]));
  LUT1 #(
    .INIT(2'h2)) 
    i_7
       (.I0(1'b0),
        .O(rst_wr_reg1));
  LUT1 #(
    .INIT(2'h2)) 
    i_8
       (.I0(1'b0),
        .O(rst_rd_reg1));
  LUT1 #(
    .INIT(2'h2)) 
    i_9
       (.I0(1'b0),
        .O(rst_rd_reg2));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT2 #(
    .INIT(4'hE)) 
    \mux_b_wire.mux_reg.ce_pri.doutb_i[255]_i_1 
       (.I0(SR),
        .I1(tmp_ram_rd_en_d1),
        .O(\ngwrdrst.grst.g7serrst.gsckt_wrst.gic_rst.sckt_rd_rst_ic_reg_0 ));
  (* DEF_VAL = "1'b0" *) 
  (* DEST_SYNC_FF = "3" *) 
  (* INIT = "0" *) 
  (* INIT_SYNC_FF = "0" *) 
  (* KEEP_HIERARCHY = "true" *) 
  (* SIM_ASSERT_CHK = "0" *) 
  (* VERSION = "0" *) 
  (* XPM_CDC = "SYNC_RST" *) 
  (* XPM_MODULE = "TRUE" *) 
  ge11_rx_fifo_xpm_cdc_sync_rst__parameterized2 \ngwrdrst.grst.g7serrst.gnrst_full.gsckt_bsy_o.xpm_cdc_sync_rst_sckt_bsy_o 
       (.dest_clk(wr_clk),
        .dest_rst(\NLW_ngwrdrst.grst.g7serrst.gnrst_full.gsckt_bsy_o.xpm_cdc_sync_rst_sckt_bsy_o_dest_rst_UNCONNECTED ),
        .src_rst(wr_rst_busy));
  FDRE #(
    .INIT(1'b0)) 
    \ngwrdrst.grst.g7serrst.gsckt_wrst.gic_rst.rd_rst_wr_ext_reg[0] 
       (.C(wr_clk),
        .CE(1'b1),
        .D(sckt_rd_rst_wr),
        .Q(\ngwrdrst.grst.g7serrst.gsckt_wrst.gic_rst.rd_rst_wr_ext_reg_n_0_[0] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \ngwrdrst.grst.g7serrst.gsckt_wrst.gic_rst.rd_rst_wr_ext_reg[1] 
       (.C(wr_clk),
        .CE(1'b1),
        .D(\ngwrdrst.grst.g7serrst.gsckt_wrst.gic_rst.rd_rst_wr_ext_reg_n_0_[0] ),
        .Q(\ngwrdrst.grst.g7serrst.gsckt_wrst.gic_rst.rd_rst_wr_ext_reg_n_0_[1] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \ngwrdrst.grst.g7serrst.gsckt_wrst.gic_rst.rd_rst_wr_ext_reg[2] 
       (.C(wr_clk),
        .CE(1'b1),
        .D(\ngwrdrst.grst.g7serrst.gsckt_wrst.gic_rst.rd_rst_wr_ext_reg_n_0_[1] ),
        .Q(p_0_in),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \ngwrdrst.grst.g7serrst.gsckt_wrst.gic_rst.rd_rst_wr_ext_reg[3] 
       (.C(wr_clk),
        .CE(1'b1),
        .D(p_0_in),
        .Q(\ngwrdrst.grst.g7serrst.gsckt_wrst.gic_rst.rd_rst_wr_ext_reg_n_0_[3] ),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT3 #(
    .INIT(8'hF4)) 
    \ngwrdrst.grst.g7serrst.gsckt_wrst.gic_rst.sckt_rd_rst_ic_i_1 
       (.I0(wr_rst_rd_ext[1]),
        .I1(SR),
        .I2(arst_sync_rd_rst),
        .O(\ngwrdrst.grst.g7serrst.gsckt_wrst.gic_rst.sckt_rd_rst_ic_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ngwrdrst.grst.g7serrst.gsckt_wrst.gic_rst.sckt_rd_rst_ic_reg 
       (.C(rd_clk),
        .CE(1'b1),
        .D(\ngwrdrst.grst.g7serrst.gsckt_wrst.gic_rst.sckt_rd_rst_ic_i_1_n_0 ),
        .Q(SR),
        .R(1'b0));
  LUT4 #(
    .INIT(16'hFFD0)) 
    \ngwrdrst.grst.g7serrst.gsckt_wrst.gic_rst.sckt_wr_rst_ic_i_1 
       (.I0(\ngwrdrst.grst.g7serrst.gsckt_wrst.gic_rst.rd_rst_wr_ext_reg_n_0_[1] ),
        .I1(\ngwrdrst.grst.g7serrst.gsckt_wrst.gic_rst.rd_rst_wr_ext_reg_n_0_[0] ),
        .I2(\ngwrdrst.grst.g7serrst.gsckt_wrst.gic_rst.sckt_wr_rst_ic_reg_0 ),
        .I3(dest_rst),
        .O(\ngwrdrst.grst.g7serrst.gsckt_wrst.gic_rst.sckt_wr_rst_ic_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ngwrdrst.grst.g7serrst.gsckt_wrst.gic_rst.sckt_wr_rst_ic_reg 
       (.C(wr_clk),
        .CE(1'b1),
        .D(\ngwrdrst.grst.g7serrst.gsckt_wrst.gic_rst.sckt_wr_rst_ic_i_1_n_0 ),
        .Q(\ngwrdrst.grst.g7serrst.gsckt_wrst.gic_rst.sckt_wr_rst_ic_reg_0 ),
        .R(1'b0));
  LUT6 #(
    .INIT(64'hFFFFFFFFBFBB0000)) 
    \ngwrdrst.grst.g7serrst.gsckt_wrst.gic_rst.wr_rst_busy_i_i_1 
       (.I0(p_0_in),
        .I1(\ngwrdrst.grst.g7serrst.gsckt_wrst.gic_rst.rd_rst_wr_ext_reg_n_0_[3] ),
        .I2(\ngwrdrst.grst.g7serrst.gsckt_wrst.gic_rst.rd_rst_wr_ext_reg_n_0_[0] ),
        .I3(\ngwrdrst.grst.g7serrst.gsckt_wrst.gic_rst.rd_rst_wr_ext_reg_n_0_[1] ),
        .I4(wr_rst_busy),
        .I5(dest_rst),
        .O(\ngwrdrst.grst.g7serrst.gsckt_wrst.gic_rst.wr_rst_busy_i_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ngwrdrst.grst.g7serrst.gsckt_wrst.gic_rst.wr_rst_busy_i_reg 
       (.C(wr_clk),
        .CE(1'b1),
        .D(\ngwrdrst.grst.g7serrst.gsckt_wrst.gic_rst.wr_rst_busy_i_i_1_n_0 ),
        .Q(wr_rst_busy),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \ngwrdrst.grst.g7serrst.gsckt_wrst.gic_rst.wr_rst_rd_ext_reg[0] 
       (.C(rd_clk),
        .CE(1'b1),
        .D(dest_out),
        .Q(wr_rst_rd_ext[0]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \ngwrdrst.grst.g7serrst.gsckt_wrst.gic_rst.wr_rst_rd_ext_reg[1] 
       (.C(rd_clk),
        .CE(1'b1),
        .D(wr_rst_rd_ext[0]),
        .Q(wr_rst_rd_ext[1]),
        .R(1'b0));
  (* DEST_SYNC_FF = "5" *) 
  (* INIT_SYNC_FF = "0" *) 
  (* KEEP_HIERARCHY = "true" *) 
  (* SIM_ASSERT_CHK = "0" *) 
  (* SRC_INPUT_REG = "0" *) 
  (* VERSION = "0" *) 
  (* XPM_CDC = "SINGLE" *) 
  (* XPM_MODULE = "TRUE" *) 
  ge11_rx_fifo_xpm_cdc_single \ngwrdrst.grst.g7serrst.gsckt_wrst.gic_rst.xpm_cdc_single_inst_rrst_wr 
       (.dest_clk(wr_clk),
        .dest_out(sckt_rd_rst_wr),
        .src_clk(rd_clk),
        .src_in(SR));
  (* DEST_SYNC_FF = "5" *) 
  (* INIT_SYNC_FF = "0" *) 
  (* KEEP_HIERARCHY = "true" *) 
  (* SIM_ASSERT_CHK = "0" *) 
  (* SRC_INPUT_REG = "0" *) 
  (* VERSION = "0" *) 
  (* XPM_CDC = "SINGLE" *) 
  (* XPM_MODULE = "TRUE" *) 
  ge11_rx_fifo_xpm_cdc_single__2 \ngwrdrst.grst.g7serrst.gsckt_wrst.gic_rst.xpm_cdc_single_inst_wrst_rd 
       (.dest_clk(rd_clk),
        .dest_out(dest_out),
        .src_clk(wr_clk),
        .src_in(\ngwrdrst.grst.g7serrst.gsckt_wrst.gic_rst.sckt_wr_rst_ic_reg_0 ));
  (* DEF_VAL = "1'b1" *) 
  (* DEST_SYNC_FF = "5" *) 
  (* INIT = "1" *) 
  (* INIT_SYNC_FF = "0" *) 
  (* KEEP_HIERARCHY = "true" *) 
  (* SIM_ASSERT_CHK = "0" *) 
  (* VERSION = "0" *) 
  (* XPM_CDC = "SYNC_RST" *) 
  (* XPM_MODULE = "TRUE" *) 
  ge11_rx_fifo_xpm_cdc_sync_rst \ngwrdrst.grst.g7serrst.gsckt_wrst.gic_rst.xpm_cdc_sync_rst_inst_wrst 
       (.dest_clk(rd_clk),
        .dest_rst(arst_sync_rd_rst),
        .src_rst(rst));
  (* DEF_VAL = "1'b1" *) 
  (* DEST_SYNC_FF = "5" *) 
  (* INIT = "1" *) 
  (* INIT_SYNC_FF = "0" *) 
  (* KEEP_HIERARCHY = "true" *) 
  (* SIM_ASSERT_CHK = "0" *) 
  (* VERSION = "0" *) 
  (* XPM_CDC = "SYNC_RST" *) 
  (* XPM_MODULE = "TRUE" *) 
  ge11_rx_fifo_xpm_cdc_sync_rst__2 \ngwrdrst.grst.g7serrst.gsckt_wrst.xpm_cdc_sync_rst_inst_wrst 
       (.dest_clk(wr_clk),
        .dest_rst(dest_rst),
        .src_rst(rst));
endmodule

module ge11_rx_fifo_wr_bin_cntr
   (Q,
    \gic0.gc0.count_d1_reg[5]_0 ,
    \gic0.gc0.count_d2_reg[5]_0 ,
    \gic0.gc0.count_d2_reg[0]_0 ,
    E,
    wr_clk);
  output [5:0]Q;
  output [5:0]\gic0.gc0.count_d1_reg[5]_0 ;
  output [5:0]\gic0.gc0.count_d2_reg[5]_0 ;
  input \gic0.gc0.count_d2_reg[0]_0 ;
  input [0:0]E;
  input wr_clk;

  wire [0:0]E;
  wire [5:0]Q;
  wire [5:0]\gic0.gc0.count_d1_reg[5]_0 ;
  wire \gic0.gc0.count_d2_reg[0]_0 ;
  wire [5:0]\gic0.gc0.count_d2_reg[5]_0 ;
  wire [5:0]plusOp;
  wire wr_clk;

  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \gic0.gc0.count[0]_i_1 
       (.I0(Q[0]),
        .O(plusOp[0]));
  LUT2 #(
    .INIT(4'h6)) 
    \gic0.gc0.count[1]_i_1 
       (.I0(Q[0]),
        .I1(Q[1]),
        .O(plusOp[1]));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \gic0.gc0.count[2]_i_1 
       (.I0(Q[0]),
        .I1(Q[1]),
        .I2(Q[2]),
        .O(plusOp[2]));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT4 #(
    .INIT(16'h7F80)) 
    \gic0.gc0.count[3]_i_1 
       (.I0(Q[1]),
        .I1(Q[0]),
        .I2(Q[2]),
        .I3(Q[3]),
        .O(plusOp[3]));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT5 #(
    .INIT(32'h7FFF8000)) 
    \gic0.gc0.count[4]_i_1 
       (.I0(Q[2]),
        .I1(Q[0]),
        .I2(Q[1]),
        .I3(Q[3]),
        .I4(Q[4]),
        .O(plusOp[4]));
  LUT6 #(
    .INIT(64'h7FFFFFFF80000000)) 
    \gic0.gc0.count[5]_i_1 
       (.I0(Q[3]),
        .I1(Q[1]),
        .I2(Q[0]),
        .I3(Q[2]),
        .I4(Q[4]),
        .I5(Q[5]),
        .O(plusOp[5]));
  FDSE #(
    .INIT(1'b1)) 
    \gic0.gc0.count_d1_reg[0] 
       (.C(wr_clk),
        .CE(E),
        .D(Q[0]),
        .Q(\gic0.gc0.count_d1_reg[5]_0 [0]),
        .S(\gic0.gc0.count_d2_reg[0]_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \gic0.gc0.count_d1_reg[1] 
       (.C(wr_clk),
        .CE(E),
        .D(Q[1]),
        .Q(\gic0.gc0.count_d1_reg[5]_0 [1]),
        .R(\gic0.gc0.count_d2_reg[0]_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \gic0.gc0.count_d1_reg[2] 
       (.C(wr_clk),
        .CE(E),
        .D(Q[2]),
        .Q(\gic0.gc0.count_d1_reg[5]_0 [2]),
        .R(\gic0.gc0.count_d2_reg[0]_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \gic0.gc0.count_d1_reg[3] 
       (.C(wr_clk),
        .CE(E),
        .D(Q[3]),
        .Q(\gic0.gc0.count_d1_reg[5]_0 [3]),
        .R(\gic0.gc0.count_d2_reg[0]_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \gic0.gc0.count_d1_reg[4] 
       (.C(wr_clk),
        .CE(E),
        .D(Q[4]),
        .Q(\gic0.gc0.count_d1_reg[5]_0 [4]),
        .R(\gic0.gc0.count_d2_reg[0]_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \gic0.gc0.count_d1_reg[5] 
       (.C(wr_clk),
        .CE(E),
        .D(Q[5]),
        .Q(\gic0.gc0.count_d1_reg[5]_0 [5]),
        .R(\gic0.gc0.count_d2_reg[0]_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \gic0.gc0.count_d2_reg[0] 
       (.C(wr_clk),
        .CE(E),
        .D(\gic0.gc0.count_d1_reg[5]_0 [0]),
        .Q(\gic0.gc0.count_d2_reg[5]_0 [0]),
        .R(\gic0.gc0.count_d2_reg[0]_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \gic0.gc0.count_d2_reg[1] 
       (.C(wr_clk),
        .CE(E),
        .D(\gic0.gc0.count_d1_reg[5]_0 [1]),
        .Q(\gic0.gc0.count_d2_reg[5]_0 [1]),
        .R(\gic0.gc0.count_d2_reg[0]_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \gic0.gc0.count_d2_reg[2] 
       (.C(wr_clk),
        .CE(E),
        .D(\gic0.gc0.count_d1_reg[5]_0 [2]),
        .Q(\gic0.gc0.count_d2_reg[5]_0 [2]),
        .R(\gic0.gc0.count_d2_reg[0]_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \gic0.gc0.count_d2_reg[3] 
       (.C(wr_clk),
        .CE(E),
        .D(\gic0.gc0.count_d1_reg[5]_0 [3]),
        .Q(\gic0.gc0.count_d2_reg[5]_0 [3]),
        .R(\gic0.gc0.count_d2_reg[0]_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \gic0.gc0.count_d2_reg[4] 
       (.C(wr_clk),
        .CE(E),
        .D(\gic0.gc0.count_d1_reg[5]_0 [4]),
        .Q(\gic0.gc0.count_d2_reg[5]_0 [4]),
        .R(\gic0.gc0.count_d2_reg[0]_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \gic0.gc0.count_d2_reg[5] 
       (.C(wr_clk),
        .CE(E),
        .D(\gic0.gc0.count_d1_reg[5]_0 [5]),
        .Q(\gic0.gc0.count_d2_reg[5]_0 [5]),
        .R(\gic0.gc0.count_d2_reg[0]_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \gic0.gc0.count_reg[0] 
       (.C(wr_clk),
        .CE(E),
        .D(plusOp[0]),
        .Q(Q[0]),
        .R(\gic0.gc0.count_d2_reg[0]_0 ));
  FDSE #(
    .INIT(1'b1)) 
    \gic0.gc0.count_reg[1] 
       (.C(wr_clk),
        .CE(E),
        .D(plusOp[1]),
        .Q(Q[1]),
        .S(\gic0.gc0.count_d2_reg[0]_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \gic0.gc0.count_reg[2] 
       (.C(wr_clk),
        .CE(E),
        .D(plusOp[2]),
        .Q(Q[2]),
        .R(\gic0.gc0.count_d2_reg[0]_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \gic0.gc0.count_reg[3] 
       (.C(wr_clk),
        .CE(E),
        .D(plusOp[3]),
        .Q(Q[3]),
        .R(\gic0.gc0.count_d2_reg[0]_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \gic0.gc0.count_reg[4] 
       (.C(wr_clk),
        .CE(E),
        .D(plusOp[4]),
        .Q(Q[4]),
        .R(\gic0.gc0.count_d2_reg[0]_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \gic0.gc0.count_reg[5] 
       (.C(wr_clk),
        .CE(E),
        .D(plusOp[5]),
        .Q(Q[5]),
        .R(\gic0.gc0.count_d2_reg[0]_0 ));
endmodule

module ge11_rx_fifo_wr_logic
   (full,
    FULL_FB,
    E,
    Q,
    \gic0.gc0.count_d1_reg[5] ,
    \gic0.gc0.count_d2_reg[5] ,
    \gic0.gc0.count_d2_reg[0] ,
    ram_full_i0,
    wr_clk,
    wr_en);
  output full;
  output FULL_FB;
  output [0:0]E;
  output [5:0]Q;
  output [5:0]\gic0.gc0.count_d1_reg[5] ;
  output [5:0]\gic0.gc0.count_d2_reg[5] ;
  input \gic0.gc0.count_d2_reg[0] ;
  input ram_full_i0;
  input wr_clk;
  input wr_en;

  wire [0:0]E;
  wire FULL_FB;
  wire [5:0]Q;
  wire full;
  wire [5:0]\gic0.gc0.count_d1_reg[5] ;
  wire \gic0.gc0.count_d2_reg[0] ;
  wire [5:0]\gic0.gc0.count_d2_reg[5] ;
  wire ram_full_i0;
  wire wr_clk;
  wire wr_en;

  ge11_rx_fifo_wr_status_flags_as \gwas.wsts 
       (.E(E),
        .FULL_FB(FULL_FB),
        .full(full),
        .ram_full_fb_i_reg_0(\gic0.gc0.count_d2_reg[0] ),
        .ram_full_i0(ram_full_i0),
        .wr_clk(wr_clk),
        .wr_en(wr_en));
  ge11_rx_fifo_wr_bin_cntr wpntr
       (.E(E),
        .Q(Q),
        .\gic0.gc0.count_d1_reg[5]_0 (\gic0.gc0.count_d1_reg[5] ),
        .\gic0.gc0.count_d2_reg[0]_0 (\gic0.gc0.count_d2_reg[0] ),
        .\gic0.gc0.count_d2_reg[5]_0 (\gic0.gc0.count_d2_reg[5] ),
        .wr_clk(wr_clk));
endmodule

module ge11_rx_fifo_wr_status_flags_as
   (full,
    FULL_FB,
    E,
    ram_full_fb_i_reg_0,
    ram_full_i0,
    wr_clk,
    wr_en);
  output full;
  output FULL_FB;
  output [0:0]E;
  input ram_full_fb_i_reg_0;
  input ram_full_i0;
  input wr_clk;
  input wr_en;

  wire [0:0]E;
  (* DONT_TOUCH *) wire ram_full_fb_i;
  wire ram_full_fb_i_reg_0;
  (* DONT_TOUCH *) wire ram_full_i;
  wire ram_full_i0;
  wire wr_clk;
  wire wr_en;

  assign FULL_FB = ram_full_fb_i;
  assign full = ram_full_i;
  LUT2 #(
    .INIT(4'h2)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SDP.WIDE_PRIM36_NO_ECC.ram_i_4 
       (.I0(wr_en),
        .I1(ram_full_fb_i),
        .O(E));
  (* DONT_TOUCH *) 
  (* KEEP = "yes" *) 
  (* equivalent_register_removal = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    ram_full_fb_i_reg
       (.C(wr_clk),
        .CE(1'b1),
        .D(ram_full_i0),
        .Q(ram_full_fb_i),
        .R(ram_full_fb_i_reg_0));
  (* DONT_TOUCH *) 
  (* KEEP = "yes" *) 
  (* equivalent_register_removal = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    ram_full_i_reg
       (.C(wr_clk),
        .CE(1'b1),
        .D(ram_full_i0),
        .Q(ram_full_i),
        .R(ram_full_fb_i_reg_0));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
