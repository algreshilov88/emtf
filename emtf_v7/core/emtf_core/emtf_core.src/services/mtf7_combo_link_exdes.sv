`timescale 1ns / 1ps
`define DLY #1


//***********************************Entity Declaration************************
(* CORE_GENERATION_INFO = "mtf7_combo_link,gtwizard_v2_7,{protocol_file=Start_from_scratch}" *)
module mtf7_combo_link_exdes #
(
    parameter EXAMPLE_CONFIG_INDEPENDENT_LANES     =   1,//configuration for frame gen and check
    parameter STABLE_CLOCK_PERIOD                  =   16, // Period of the stable clock driving this init module, unit is [ns] 
    parameter EXAMPLE_LANE_WITH_START_CHAR         =   0,         // specifies lane with unique start frame char
    parameter EXAMPLE_WORDS_IN_BRAM                =   512,       // specifies amount of data in BRAM
    parameter EXAMPLE_SIM_GTRESET_SPEEDUP          =   "FALSE",    // simulation setting for GT SecureIP model
    parameter EXAMPLE_USE_CHIPSCOPE                =   0,         // Set to 1 to use Chipscope to drive resets
    parameter EXAMPLE_SIMULATION                   =   0          // Set to 1 for Simulation

)
(

    input sync_ref_clk,
    input async_ref_clk,
    input  wire         RXN_IN,
    input  wire         RXP_IN,
    output wire         TXN_OUT,
    output wire         TXP_OUT,
	input tx_inv_mask,
    input rx_inv_mask,
	input [2:0] prbs_sel,
    output prbs_err,
    input clk_160,

	output [15:0] rxdata,
    output [1:0]  rxcharisk,
    output [1:0]  rxdisperr,
    output [1:0]  rxnotintable,
    
    output rxbyteisaligned,
    output rxbyterealign,
    output rxcommadet,   
    input soft_reset,
    input hard_reset,
    input rxbufreset,
	output [1:0] tx_rx_reset_done,
    
    input [63:0] txdata [2:0],
    input clk_40,
    input ttc_bc0,
    output txoutclk,
    input [19:0] link_id,
    input [11:0] bxn_tx_offset,
    output txcharisk_0,
    input gth_rx_reset,
	output cpll_lock,
    output gth_tx_reset_done

);



//************************** Register Declarations ****************************

    wire            gt0_txfsmresetdone_i;
    wire            gt0_rxfsmresetdone_i;
    (* async_reg = "TRUE" *) reg             gt0_txfsmresetdone_r;
    (* async_reg = "TRUE" *) reg             gt0_txfsmresetdone_r2;
    (* async_reg = "TRUE" *) reg             gt0_rxresetdone_r;
    (* async_reg = "TRUE" *) reg             gt0_rxresetdone_r2;
    (* async_reg = "TRUE" *) reg             gt0_rxresetdone_r3;
  
	assign tx_rx_reset_done = {gt0_txfsmresetdone_i, gt0_rxfsmresetdone_i};


//**************************** Wire Declarations ******************************//
    //------------------------ GT Wrapper Wires ------------------------------
    //________________________________________________________________________
    //________________________________________________________________________
    //GT0   (X0Y0)
    //------------------------------- CPLL Ports -------------------------------
    wire            gt0_cpllfbclklost_i;
    wire            gt0_cplllock_i;
    assign cpll_lock = gt0_cplllock_i;
    wire            gt0_cpllrefclklost_i;
    wire            gt0_cpllreset_i;
    //------------------------ Channel - Clocking Ports ------------------------
    wire            gt0_gtgrefclk_i;
    wire            gt0_gtnorthrefclk0_i;
    wire            gt0_gtnorthrefclk1_i;
    wire            gt0_gtrefclk1_i;
    wire            gt0_gtsouthrefclk0_i;
    wire            gt0_gtsouthrefclk1_i;
    //-------------------------- Channel - DRP Ports  --------------------------
    wire    [8:0]   gt0_drpaddr_i;
    wire    [15:0]  gt0_drpdi_i;
    wire    [15:0]  gt0_drpdo_i;
    wire            gt0_drpen_i;
    wire            gt0_drprdy_i;
    wire            gt0_drpwe_i;
    //------------------- RX Initialization and Reset Ports --------------------
    wire            gt0_rxuserrdy_i;
    //------------------------ RX Margin Analysis Ports ------------------------
    wire            gt0_eyescandataerror_i;
    //----------------------- Receive Ports - CDR Ports ------------------------
    wire            gt0_rxcdrlock_i;
    //------------- Receive Ports - Comma Detection and Alignment --------------
    wire            gt0_rxslide_i;
    //---------------- Receive Ports - FPGA RX interface Ports -----------------
    wire    [15:0]  gt0_rxdata_i;
    //---------------- Receive Ports - RX 8B/10B Decoder Ports -----------------
    wire    [1:0]   gt0_rxdisperr_i;
    wire    [1:0]   gt0_rxnotintable_i;
    //---------------------- Receive Ports - RX AFE Ports ----------------------
    wire            gt0_gthrxn_i;
    //------------ Receive Ports - RX Byte and Word Alignment Ports ------------
    wire            gt0_rxbyteisaligned_i;
    wire            gt0_rxbyterealign_i;
    wire            gt0_rxcommadet_i;
    //------------- Receive Ports - RX Fabric Output Control Ports -------------
    wire            gt0_rxoutclk_i;
    //----------- Receive Ports - RX Initialization and Reset Ports ------------
    wire            gt0_gtrxreset_i;
    //--------------- Receive Ports - RX Polarity Control Ports ----------------
    wire            gt0_rxpolarity_i;
    //----------------- Receive Ports - RX8B/10B Decoder Ports -----------------
    wire    [1:0]   gt0_rxchariscomma_i;
    wire    [1:0]   gt0_rxcharisk_i;
    //---------------------- Receive Ports -RX AFE Ports -----------------------
    wire            gt0_gthrxp_i;
    //------------ Receive Ports -RX Initialization and Reset Ports ------------
    wire            gt0_rxresetdone_i;
    assign gth_tx_reset_done = gt0_rxresetdone_i;
    //------------------- TX Initialization and Reset Ports --------------------
    wire            gt0_gttxreset_i;
    wire            gt0_txuserrdy_i;
    //---------------- Transmit Ports - TX Data Path interface -----------------
    reg    [31:0]  gt0_txdata_i;
    //-------------- Transmit Ports - TX Driver and OOB signaling --------------
    wire            gt0_gthtxn_i;
    wire            gt0_gthtxp_i;
    //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
    wire            gt0_txoutclk_i;
    wire            gt0_txoutclkfabric_i;
    wire            gt0_txoutclkpcs_i;
    //----------- Transmit Ports - TX Initialization and Reset Ports -----------
    wire            gt0_txresetdone_i;
    //--------------- Transmit Ports - TX Polarity Control Ports ---------------
    wire            gt0_txpolarity_i;
    //--------- Transmit Transmit Ports - 8b10b Encoder Control Ports ----------
    reg    [3:0]   gt0_txcharisk_i;

    //____________________________COMMON PORTS________________________________
    //-------------------- Common Block  - Ref Clock Ports ---------------------
    wire            gt0_gtgrefclk_common_i;
    wire            gt0_gtnorthrefclk0_common_i;
    wire            gt0_gtnorthrefclk1_common_i;
    wire            gt0_gtrefclk1_common_i;
    wire            gt0_gtsouthrefclk0_common_i;
    wire            gt0_gtsouthrefclk1_common_i;
    //----------------------- Common Block - QPLL Ports ------------------------
    wire            gt0_qplllock_i;
    wire            gt0_qpllrefclklost_i;
    wire            gt0_qpllreset_i;


    //----------------------------- Global Signals -----------------------------

    wire            drpclk_in_i;
    wire            gt0_tx_system_reset_c;
    wire            gt0_rx_system_reset_c;
    wire            tied_to_ground_i;
    wire    [63:0]  tied_to_ground_vec_i;
    wire            tied_to_vcc_i;
    wire    [7:0]   tied_to_vcc_vec_i;
    wire            GTTXRESET_IN;
    wire            GTRXRESET_IN;
    wire            CPLLRESET_IN;
    wire            QPLLRESET_IN;

     //--------------------------- User Clocks ---------------------------------
    (* keep = "TRUE" *) wire            gt0_txusrclk_i; 
    (* keep = "TRUE" *) wire            gt0_txusrclk2_i; 
    (* keep = "TRUE" *) wire            gt0_rxusrclk_i; 
    (* keep = "TRUE" *) wire            gt0_rxusrclk2_i; 
  
    //--------------------------- Reference Clocks ----------------------------
    
    wire            q0_clk0_refclk_i = sync_ref_clk;
    
    wire            q0_clk1_refclk_i = async_ref_clk;

    //--------------------- Frame check/gen Module Signals --------------------
    wire            gt0_matchn_i;
    
    wire    [3:0]   gt0_txcharisk_float_i;
   
    wire    [15:0]  gt0_txdata_float16_i;
    wire    [31:0]  gt0_txdata_float_i;
    
    
    wire            gt0_block_sync_i;
    wire            gt0_track_data_i;
    wire    [7:0]   gt0_error_count_i;
    wire            gt0_frame_check_reset_i;
    wire            gt0_inc_in_i;
    wire            gt0_inc_out_i;
    wire    [15:0]  gt0_unscrambled_data_i;

    wire            reset_on_data_error_i;
    wire            track_data_out_i;
  

    //--------------------- Chipscope Signals ---------------------------------

    wire    [35:0]  tx_data_vio_control_i;
    wire    [35:0]  rx_data_vio_control_i;
    wire    [35:0]  shared_vio_control_i;
    wire    [35:0]  ila_control_i;
    wire    [35:0]  channel_drp_vio_control_i;
    wire    [35:0]  common_drp_vio_control_i;
    wire    [31:0]  tx_data_vio_async_in_i;
    wire    [31:0]  tx_data_vio_sync_in_i;
    wire    [31:0]  tx_data_vio_async_out_i;
    wire    [31:0]  tx_data_vio_sync_out_i;
    wire    [31:0]  rx_data_vio_async_in_i;
    wire    [31:0]  rx_data_vio_sync_in_i;
    wire    [31:0]  rx_data_vio_async_out_i;
    wire    [31:0]  rx_data_vio_sync_out_i;
    wire    [31:0]  shared_vio_in_i;
    wire    [31:0]  shared_vio_out_i;
    wire    [163:0] ila_in_i;
    wire    [31:0]  channel_drp_vio_async_in_i;
    wire    [31:0]  channel_drp_vio_sync_in_i;
    wire    [31:0]  channel_drp_vio_async_out_i;
    wire    [31:0]  channel_drp_vio_sync_out_i;
    wire    [31:0]  common_drp_vio_async_in_i;
    wire    [31:0]  common_drp_vio_sync_in_i;
    wire    [31:0]  common_drp_vio_async_out_i;
    wire    [31:0]  common_drp_vio_sync_out_i;

    wire    [31:0]  gt0_tx_data_vio_async_in_i;
    wire    [31:0]  gt0_tx_data_vio_sync_in_i;
    wire    [31:0]  gt0_tx_data_vio_async_out_i;
    wire    [31:0]  gt0_tx_data_vio_sync_out_i;
    wire    [31:0]  gt0_rx_data_vio_async_in_i;
    wire    [31:0]  gt0_rx_data_vio_sync_in_i;
    wire    [31:0]  gt0_rx_data_vio_async_out_i;
    wire    [31:0]  gt0_rx_data_vio_sync_out_i;
    wire    [163:0] gt0_ila_in_i;
    wire    [31:0]  gt0_channel_drp_vio_async_in_i;
    wire    [31:0]  gt0_channel_drp_vio_sync_in_i;
    wire    [31:0]  gt0_channel_drp_vio_async_out_i;
    wire    [31:0]  gt0_channel_drp_vio_sync_out_i;
    wire    [31:0]  gt0_common_drp_vio_async_in_i;
    wire    [31:0]  gt0_common_drp_vio_sync_in_i;
    wire    [31:0]  gt0_common_drp_vio_async_out_i;
    wire    [31:0]  gt0_common_drp_vio_sync_out_i;


    wire            gttxreset_i;
    wire            gtrxreset_i;

    wire            user_tx_reset_i;
    wire            user_rx_reset_i;
    wire            tx_vio_clk_i;
    wire            tx_vio_clk_mux_out_i;    
    wire            rx_vio_ila_clk_i;
    wire            rx_vio_ila_clk_mux_out_i;

    wire            qpllreset_i;
    

    wire  [1:0]     q0_clk0_refclk_i_i;
    wire  [1:0]     q0_clk1_refclk_i_i;

//**************************** Main Body of Code *******************************
	assign rxdata = gt0_rxdata_i;
    assign rxcharisk = gt0_rxcharisk_i;
    assign rxbyteisaligned = gt0_rxbyteisaligned_i;
    assign rxbyterealign = gt0_rxbyterealign_i;
    assign rxcommadet = gt0_rxcommadet_i;
    assign txoutclk = gt0_txusrclk2_i;

    //  Static signal Assigments    
    assign tied_to_ground_i      = 1'b0;
    assign tied_to_ground_vec_i  = 64'h0000000000000000;
    assign tied_to_vcc_i         = 1'b1;
    assign tied_to_vcc_vec_i     = 8'hff;

    assign gt0_rxusrclk_i = clk_160;
    assign gt0_rxusrclk2_i = clk_160;
    
    BUFG txusrclk_buf (.I(gt0_txoutclk_i), .O(gt0_txusrclk_i));
    assign gt0_txusrclk2_i = gt0_txusrclk_i;
    
    assign drpclk_in_i = clk_40;
/*
    mtf7_combo_link_GT_USRCLK_SOURCE gt_usrclk_source
    (
        .GT0_TXUSRCLK_OUT    (gt0_txusrclk_i),
        .GT0_TXUSRCLK2_OUT   (gt0_txusrclk2_i),
        .GT0_TXOUTCLK_IN     (gt0_txoutclk_i),
        .GT0_RXUSRCLK_OUT    (gt0_rxusrclk_i),
        .GT0_RXUSRCLK2_OUT   (gt0_rxusrclk2_i),
        .GT0_RXOUTCLK_IN     (clk_160), //(gt0_rxoutclk_i),
        
        .DRPCLK_IN (clk_40),
        .DRPCLK_OUT(drpclk_in_i)
    );
*/
    //***********************************************************************//
    //                                                                       //
    //--------------------------- The GT Wrapper ----------------------------//
    //                                                                       //
    //***********************************************************************//
    
    // Use the instantiation template in the example directory to add the GT wrapper to your design.
    // In this example, the wrapper is wired up for basic operation with a frame generator and frame 
    // checker. The GTs will reset, then attempt to align and transmit data. If channel bonding is 
    // enabled, bonding should occur after alignment.
    
    mtf7_combo_link_init #
    (
        .EXAMPLE_SIM_GTRESET_SPEEDUP    ("FALSE"),
        .EXAMPLE_SIMULATION             (EXAMPLE_SIMULATION),
        .STABLE_CLOCK_PERIOD            (STABLE_CLOCK_PERIOD),
        .EXAMPLE_USE_CHIPSCOPE          (EXAMPLE_USE_CHIPSCOPE)
    )
    mtf7_combo_link_init_i
    (
        .SYSCLK_IN                      (drpclk_in_i),
        .SOFT_RESET_IN                  (soft_reset),
        .hard_reset                     (hard_reset),
        .DONT_RESET_ON_DATA_ERROR_IN    (1'b1),
        .GT0_TX_FSM_RESET_DONE_OUT      (gt0_txfsmresetdone_i),
        .GT0_RX_FSM_RESET_DONE_OUT      (gt0_rxfsmresetdone_i),
        .GT0_DATA_VALID_IN              (1'b1),

        //_____________________________________________________________________
        //_____________________________________________________________________
        //GT0  (X0Y0)

        //------------------------------- CPLL Ports -------------------------------
        .GT0_CPLLFBCLKLOST_OUT          (gt0_cpllfbclklost_i),
        .GT0_CPLLLOCK_OUT               (gt0_cplllock_i),
        .GT0_CPLLLOCKDETCLK_IN          (drpclk_in_i),
        .GT0_CPLLRESET_IN               (gt0_cpllreset_i),
        //------------------------ Channel - Clocking Ports ------------------------
        .GT0_GTGREFCLK_IN               (gt0_gtgrefclk_i),
        .GT0_GTNORTHREFCLK0_IN          (gt0_gtnorthrefclk0_i),
        .GT0_GTNORTHREFCLK1_IN          (gt0_gtnorthrefclk1_i),
        .GT0_GTREFCLK0_IN               (q0_clk0_refclk_i),
        .GT0_GTREFCLK1_IN               (gt0_gtrefclk1_i),
        .GT0_GTSOUTHREFCLK0_IN          (gt0_gtsouthrefclk0_i),
        .GT0_GTSOUTHREFCLK1_IN          (gt0_gtsouthrefclk1_i),
        //-------------------------- Channel - DRP Ports  --------------------------
        .GT0_DRPADDR_IN                 (gt0_drpaddr_i),
        .GT0_DRPCLK_IN                  (drpclk_in_i),
        .GT0_DRPDI_IN                   (gt0_drpdi_i),
        .GT0_DRPDO_OUT                  (gt0_drpdo_i),
        .GT0_DRPEN_IN                   (gt0_drpen_i),
        .GT0_DRPRDY_OUT                 (gt0_drprdy_i),
        .GT0_DRPWE_IN                   (gt0_drpwe_i),
        //------------------- RX Initialization and Reset Ports --------------------
        .GT0_RXUSERRDY_IN               (gt0_rxuserrdy_i),
        //------------------------ RX Margin Analysis Ports ------------------------
        .GT0_EYESCANDATAERROR_OUT       (gt0_eyescandataerror_i),
        //----------------------- Receive Ports - CDR Ports ------------------------
        .GT0_RXCDRLOCK_OUT              (gt0_rxcdrlock_i),
        //------------- Receive Ports - Comma Detection and Alignment --------------
        .GT0_RXSLIDE_IN                 (gt0_rxslide_i),
        //---------------- Receive Ports - FPGA RX Interface Ports -----------------
        .GT0_RXUSRCLK_IN                (gt0_rxusrclk_i),
        .GT0_RXUSRCLK2_IN               (gt0_rxusrclk_i),
        //---------------- Receive Ports - FPGA RX interface Ports -----------------
        .GT0_RXDATA_OUT                 (gt0_rxdata_i),
        //---------------- Receive Ports - RX 8B/10B Decoder Ports -----------------
        .GT0_RXDISPERR_OUT              (rxdisperr),
        .GT0_RXNOTINTABLE_OUT           (rxnotintable),
        //---------------------- Receive Ports - RX AFE Ports ----------------------
        .GT0_GTHRXN_IN                  (RXN_IN),
        //------------ Receive Ports - RX Byte and Word Alignment Ports ------------
        .GT0_RXBYTEISALIGNED_OUT        (gt0_rxbyteisaligned_i),
        .GT0_RXBYTEREALIGN_OUT          (gt0_rxbyterealign_i),
        .GT0_RXCOMMADET_OUT             (gt0_rxcommadet_i),
        //------------- Receive Ports - RX Fabric Output Control Ports -------------
        .GT0_RXOUTCLK_OUT               (gt0_rxoutclk_i),
        //----------- Receive Ports - RX Initialization and Reset Ports ------------
        .GT0_GTRXRESET_IN               (gt0_gtrxreset_i),
        //--------------- Receive Ports - RX Polarity Control Ports ----------------
        .GT0_RXPOLARITY_IN              (gt0_rxpolarity_i),
        //----------------- Receive Ports - RX8B/10B Decoder Ports -----------------
        .GT0_RXCHARISCOMMA_OUT          (gt0_rxchariscomma_i),
        .GT0_RXCHARISK_OUT              (gt0_rxcharisk_i),
        //---------------------- Receive Ports -RX AFE Ports -----------------------
        .GT0_GTHRXP_IN                  (RXP_IN),
        //------------ Receive Ports -RX Initialization and Reset Ports ------------
        .GT0_RXRESETDONE_OUT            (gt0_rxresetdone_i),
        //------------------- TX Initialization and Reset Ports --------------------
        .GT0_GTTXRESET_IN               (gt0_gttxreset_i),
        .GT0_TXUSERRDY_IN               (gt0_txuserrdy_i),
        //---------------- Transmit Ports - FPGA TX Interface Ports ----------------
        .GT0_TXUSRCLK_IN                (gt0_txusrclk_i),
        .GT0_TXUSRCLK2_IN               (gt0_txusrclk_i),
        //---------------- Transmit Ports - TX Data Path interface -----------------
        .GT0_TXDATA_IN                  (gt0_txdata_i),
        //-------------- Transmit Ports - TX Driver and OOB signaling --------------
        .GT0_GTHTXN_OUT                 (TXN_OUT),
        .GT0_GTHTXP_OUT                 (TXP_OUT),
        //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
        .GT0_TXOUTCLK_OUT               (gt0_txoutclk_i),
        .GT0_TXOUTCLKFABRIC_OUT         (gt0_txoutclkfabric_i),
        .GT0_TXOUTCLKPCS_OUT            (gt0_txoutclkpcs_i),
        //----------- Transmit Ports - TX Initialization and Reset Ports -----------
        .GT0_TXRESETDONE_OUT            (gt0_txresetdone_i),
        //--------------- Transmit Ports - TX Polarity Control Ports ---------------
        .GT0_TXPOLARITY_IN              (gt0_txpolarity_i),
        //--------- Transmit Transmit Ports - 8b10b Encoder Control Ports ----------
        .GT0_TXCHARISK_IN               (gt0_txcharisk_i),



         //____________________________COMMON PORTS________________________________
        //-------------------- Common Block  - Ref Clock Ports ---------------------
        .GT0_GTGREFCLK_COMMON_IN        (gt0_gtgrefclk_common_i),
        .GT0_GTNORTHREFCLK0_COMMON_IN   (gt0_gtnorthrefclk0_common_i),
        .GT0_GTNORTHREFCLK1_COMMON_IN   (gt0_gtnorthrefclk1_common_i),
        .GT0_GTREFCLK0_COMMON_IN        (q0_clk1_refclk_i),
        .GT0_GTREFCLK1_COMMON_IN        (gt0_gtrefclk1_common_i),
        .GT0_GTSOUTHREFCLK0_COMMON_IN   (gt0_gtsouthrefclk0_common_i),
        .GT0_GTSOUTHREFCLK1_COMMON_IN   (gt0_gtsouthrefclk1_common_i),
        //----------------------- Common Block - QPLL Ports ------------------------
        .GT0_QPLLLOCK_OUT               (gt0_qplllock_i),
        .GT0_QPLLLOCKDETCLK_IN          (drpclk_in_i),
        .GT0_QPLLRESET_IN               (gt0_qpllreset_i),
        
        .prbs_sel (prbs_sel),
        .prbs_err (prbs_err),
        .rxbufreset (rxbufreset),
        .gth_rx_reset (gth_rx_reset)

    );



    //***********************************************************************//
    //                                                                       //
    //--------------------------- User Module Resets-------------------------//
    //                                                                       //
    //***********************************************************************//
    // All the User Modules i.e. FRAME_GEN, FRAME_CHECK and the sync modules
    // are held in reset till the RESETDONE goes high. 
    // The RESETDONE is registered a couple of times on *USRCLK2 and connected 
    // to the reset of the modules
    
    always @(posedge gt0_rxusrclk_i or negedge gt0_rxresetdone_i)
    begin
        if (!gt0_rxresetdone_i)
        begin
            gt0_rxresetdone_r    <=   `DLY 1'b0;
            gt0_rxresetdone_r2   <=   `DLY 1'b0;
        end
        else
        begin
            gt0_rxresetdone_r    <=   `DLY gt0_rxresetdone_i;
            gt0_rxresetdone_r2   <=   `DLY gt0_rxresetdone_r;
            gt0_rxresetdone_r3   <=   `DLY gt0_rxresetdone_r2;
        end
    end
    

    
    always @(posedge gt0_txusrclk_i or negedge gt0_txfsmresetdone_i)
    begin
        if (!gt0_txfsmresetdone_i)
        begin
            gt0_txfsmresetdone_r    <=   `DLY 1'b0;
            gt0_txfsmresetdone_r2   <=   `DLY 1'b0;
        end
        else
        begin
            gt0_txfsmresetdone_r    <=   `DLY gt0_txfsmresetdone_i;
            gt0_txfsmresetdone_r2   <=   `DLY gt0_txfsmresetdone_r;
        end
    end



    //***********************************************************************//
    //                                                                       //
    //------------------------  Frame Generators  ---------------------------//
    //                                                                       //
    //***********************************************************************//
    // The example design uses Block RAM based frame generators to provide test
    // data to the GTs for transmission. By default the frame generators are 
    // loaded with an incrementing data sequence that includes commas/alignment
    // characters for alignment. If your protocol uses channel bonding, the 
    // frame generator will also be preloaded with a channel bonding sequence.
    
    // You can modify the data transmitted by changing the INIT values of the frame
    // generator in this file. Pay careful attention to bit order and the spacing
    // of your control and alignment characters.

/*
    mtf7_combo_link_GT_FRAME_GEN #
    (
        .WORDS_IN_BRAM(EXAMPLE_WORDS_IN_BRAM)
    )
    gt0_frame_gen
    (
        // User Interface
        .TX_DATA_OUT                    ({gt0_txdata_float_i,gt0_txdata_i,gt0_txdata_float16_i}),
        .TXCTRL_OUT                     ({gt0_txcharisk_float_i,gt0_txcharisk_i}),

        // System Interface
        .USER_CLK                       (gt0_txusrclk_i),
        .SYSTEM_RESET                   (gt0_tx_system_reset_c)
    );
*/
    //***********************************************************************//
    //                                                                       //
    //------------------------  Frame Checkers  -----------------------------//
    //                                                                       //
    //***********************************************************************//
    // The example design uses Block RAM based frame checkers to verify incoming  
    // data. By default the frame generators are loaded with a data sequence that 
    // matches the outgoing sequence of the frame generators for the TX ports.
    
    // You can modify the expected data sequence by changing the INIT values of the frame
    // checkers in this file. Pay careful attention to bit order and the spacing
    // of your control and alignment characters.
    
    // When the frame checker receives data, it attempts to synchronise to the 
    // incoming pattern by looking for the first sequence in the pattern. Once it 
    // finds the first sequence, it increments through the sequence, and indicates an 
    // error whenever the next value received does not match the expected value.


    assign gt0_frame_check_reset_i = (EXAMPLE_CONFIG_INDEPENDENT_LANES==0)?reset_on_data_error_i:gt0_matchn_i;

    // gt0_frame_check0 is always connected to the lane with the start of char
    // and this lane starts off the data checking on all the other lanes. The INC_IN port is tied off
    assign gt0_inc_in_i = 1'b0;
/*
    mtf7_combo_link_GT_FRAME_CHECK #
    (
        .RX_DATA_WIDTH(16),
        .RXCTRL_WIDTH(2),
        .COMMA_DOUBLE(16'h02bc),
        .WORDS_IN_BRAM(EXAMPLE_WORDS_IN_BRAM),
        .START_OF_PACKET_CHAR(16'h02bc)
    )
    gt0_frame_check
    (
        // GT Interface
        .RX_DATA_IN                     (gt0_rxdata_i),
        .RXCTRL_IN                      (gt0_rxcharisk_i),
        .RXENMCOMMADET_OUT              ( ),
        .RXENPCOMMADET_OUT              ( ),
        .RX_ENCHAN_SYNC_OUT             ( ),
        .RX_CHANBOND_SEQ_IN             (tied_to_ground_i),
        // Control Interface
        .INC_IN                         (gt0_inc_in_i),
        .INC_OUT                        (gt0_inc_out_i),
        .PATTERN_MATCHB_OUT             (gt0_matchn_i),
        .RESET_ON_ERROR_IN              (gt0_frame_check_reset_i),
        // System Interface
        .USER_CLK                       (gt0_rxusrclk_i),
        .SYSTEM_RESET                   (gt0_rx_system_reset_c),
        .ERROR_COUNT_OUT                (gt0_error_count_i),
        .RX_SLIDE                       (gt0_rxslide_i),
        .TRACK_DATA_OUT                 (gt0_track_data_i)
    );

*/

    assign TRACK_DATA_OUT = track_data_out_i;

    assign track_data_out_i = 
                                gt0_track_data_i ;







//-------------------------------------------------------------------------------------





    assign  gt0_tx_system_reset_c = !gt0_txfsmresetdone_r2;

    // assign resets for frame_check modules
    assign  gt0_rx_system_reset_c = !gt0_rxresetdone_r3;

//-------------------------------------------------------------
    assign  gttxreset_i                          =  tied_to_ground_i;
    assign  gtrxreset_i                          =  tied_to_ground_i;
    assign  user_tx_reset_i                      =  tied_to_ground_i;
    assign  user_rx_reset_i                      =  tied_to_ground_i;
    assign  gt0_txpolarity_i                     =  tx_inv_mask;
    assign  gt0_rxpolarity_i                     =  rx_inv_mask;
    assign  gt0_drpaddr_i                        =  tied_to_ground_vec_i[8:0];
    assign  gt0_drpdi_i                          =  tied_to_ground_vec_i[15:0];
    assign  gt0_drpen_i                          =  tied_to_ground_i;
    assign  gt0_drpwe_i                          =  tied_to_ground_i;


    reg [65:0] txdata_din; 
    wire [32:0] txdata_dout; 
    wire tx_fifo_uf;
    (* ASYNC_REG = "TRUE" *) reg [31:0] txdata_async;
    (* ASYNC_REG = "TRUE" *) reg [3:0] txcharisk_async;
    wire clk_120, mmcm_120_locked;
    reg [32:0] txdata_dout_r, txdata_dout_rr;
    reg tx_fifo_uf_r, tx_fifo_uf_rr;

    reg [11:0] bxn;
    reg clk_40_r, clk_40_rr;
    reg [1:0] tx_mux;
    wire clk_40_sh;
    
    `define BX_TRAILER    12'd3555// 12'd3550
    `define BX_RESERVED_F 12'd3556// 12'd3551
    `define BX_RESERVED_L 12'd3559
    `define TX_COMMA   32'h505050bc 
    `define TX_PADDING 32'hf7f7f7f7

    `define TX_CRC 32'h0 // no CRC at this time
    `define TX_LID {6'h0, link_id[9:0], 6'h0, link_id[19:10]}
    
    wire [63:0] trailer_d [2:0];
    wire [7:0]  trailer_k [2:0];
    assign trailer_d [0] = {`TX_CRC, `TX_COMMA}; 
    assign trailer_d [1] = {`TX_COMMA, `TX_LID}; 
    assign trailer_d [2] = {`TX_COMMA, `TX_COMMA};
    assign trailer_k [0] = 8'b00000001; 
    assign trailer_k [1] = 8'b00010000; 
    assign trailer_k [2] = 8'b00010001; 

	localparam LHC_ORBIT_LAST_CLK = 12'd3563;
    
    reg [63:0] txdata_r [2:0];
    (* ASYNC_REG = "TRUE" *) reg [63:0] txdata_a [2:0];
    reg [7:0] txcharisk_r [2:0];
    (* ASYNC_REG = "TRUE" *) reg [7:0] txcharisk_a [2:0];
    (* ASYNC_REG = "TRUE" *) reg [6:0] clk40_s;

    // CRC calculator
    tx_crc tx_crc_
    (
        .d (txdata_async),
        .k (txcharisk_async),
        .dout (gt0_txdata_i),
        .kout (gt0_txcharisk_i),
        .clk (gt0_txusrclk2_i)
    );


    // clock domain crossing logic
    always @(posedge gt0_txusrclk2_i)
    begin

        if (clk40_s[1:0] == 2'b01) // clk_40 rose one clock ago
        begin
            txdata_a = txdata_r; // store entire data word
            txcharisk_a = txcharisk_r; 
            txdata_async = txdata_a[0][31:0];
            txcharisk_async = txcharisk_a[0][3:0];
        end
        else
        if (clk40_s[2:1] == 2'b01) // clk_40 rose two clocks ago
        begin
            txdata_async = txdata_a[0][63:32];
            txcharisk_async = txcharisk_a[0][7:4];
        end
        else
        if (clk40_s[3:2] == 2'b01)
        begin
            txdata_async = txdata_a[1][31:0];
            txcharisk_async = txcharisk_a[1][3:0];
        end
        else
        if (clk40_s[4:3] == 2'b01)
        begin
            txdata_async = txdata_a[1][63:32];
            txcharisk_async = txcharisk_a[1][7:4];
        end
        else
        if (clk40_s[5:4] == 2'b01)
        begin
            txdata_async = txdata_a[2][31:0];
            txcharisk_async = txcharisk_a[2][3:0];
        end
        else
        if (clk40_s[6:5] == 2'b01)
        begin
            txdata_async = txdata_a[2][63:32];
            txcharisk_async = txcharisk_a[2][7:4];
        end
        else
        begin
            // nothing to transmit, send padding
            txdata_async = `TX_PADDING;
            txcharisk_async = 4'hf;
        end    
    
        clk40_s = {clk40_s[5:0], !clk_40};
    end

    integer i;
    // tx format logic
    always @(negedge clk_40)
    begin

        if (bxn == `BX_TRAILER) // send trailer
        begin
            for (i = 0; i < 3; i = i+1)
            begin
                txdata_r[i] = trailer_d[i];
                txcharisk_r[i] = trailer_k[i];
            end
        end
        else if (bxn >= `BX_RESERVED_F && bxn <= `BX_RESERVED_L) // send reserved words
        begin
            // only transmit commas here
            for (i = 0; i < 3; i = i+1)
            begin
                txdata_r[i] = trailer_d[2];
                txcharisk_r[i] = trailer_k[2];
            end
        end
        else // send payload
        begin
            for (i = 0; i < 3; i = i+1)
            begin
                txdata_r[i] = txdata[i];
                txcharisk_r[i] = 4'b0000;
            end
        end


        // process BXN
        if (ttc_bc0) bxn = bxn_tx_offset;
        else
        begin 
            if (bxn == LHC_ORBIT_LAST_CLK) bxn = 12'h0;
            else bxn = bxn + 12'h1;
        end
    end


    assign txcharisk_0 = gt0_txcharisk_i;


endmodule
    
