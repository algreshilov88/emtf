

`timescale 1ns / 1ps
`define DLY #1


//***********************************Entity Declaration************************

module daq_link_rx_exdes #
(
    parameter EXAMPLE_CONFIG_INDEPENDENT_LANES     =   1,//configuration for frame gen and check
    parameter EXAMPLE_LANE_WITH_START_CHAR         =   0,         // specifies lane with unique start frame char
    parameter EXAMPLE_WORDS_IN_BRAM                =   512,       // specifies amount of data in BRAM
    parameter EXAMPLE_SIM_GTRESET_SPEEDUP          =   "FALSE",    // simulation setting for GT SecureIP model
    parameter EXAMPLE_USE_CHIPSCOPE                =   0,         // Set to 1 to use Chipscope to drive resets
    parameter EXAMPLE_SIMULATION                   =   0          // Set to 1 for Simulation

)
(
    input ref_clk,
    input wire  drp_clk,
    input  wire         RXN_IN,
    input  wire         RXP_IN,
    output wire         TXN_OUT,
    output wire         TXP_OUT,
    
    output reg k_rxresetdone,
    output reg [1:0] k_rxnotintable,
    output reg [1:0] k_rxchariscomma,
    output reg [1:0] k_rxcharisk,
    output reg [15:0] k_rxdata,
    output gt0_rxoutclk_p,
    input soft_reset_i    

);


//************************** Register Declarations ****************************

    wire            gt0_rxfsmresetdone_i;
    reg             gt0_rxresetdone_r;
    reg             gt0_rxresetdone_r2;
    reg             gt0_rxresetdone_r3;

    reg [5:0] reset_counter = 0;
    reg     [3:0]   reset_pulse;

//**************************** Wire Declarations ******************************//
    //------------------------ GT Wrapper Wires ------------------------------
    //________________________________________________________________________
    //________________________________________________________________________
    //GT0   (X0Y1)
    //------------------------------ Channel PLL -------------------------------
    wire            gt0_cpllfbclklost_i;
    wire            gt0_cplllock_i;
    wire            gt0_cpllrefclklost_i;
    wire            gt0_cpllreset_i = 1'b0;
    //----------------------------- Eye Scan Ports -----------------------------
    wire            gt0_eyescandataerror_i;
    //----------------------------- Receive Ports ------------------------------
    wire            gt0_rxuserrdy_i = 1'b0;
    //--------------------- Receive Ports - 8b10b Decoder ----------------------
    wire    [1:0]   gt0_rxcharisk_i;
    wire    [1:0]   gt0_rxchariscomma_i;
    wire    [1:0]   gt0_rxdisperr_i;
    wire    [1:0]   gt0_rxnotintable_i;
    //----------------- Receive Ports - Clock Correction Ports -----------------
    wire    [1:0]   gt0_rxclkcorcnt_i;
    //------------- Receive Ports - Comma Detection and Alignment --------------
    wire            gt0_rxbyteisaligned_i;
    wire            gt0_rxbyterealign_i;
    wire            gt0_rxcommadet_i;
    //----------------- Receive Ports - RX Data Path interface -----------------
    wire            gt0_gtrxreset_i = 1'b0;
    wire    [15:0]  gt0_rxdata_i;
    wire            gt0_rxoutclk_i;
    //----- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
    wire            gt0_gtxrxn_i;
    wire            gt0_gtxrxp_i;
    wire            gt0_rxcdrlock_i;
    wire            gt0_rxelecidle_i;
    //---------------------- Receive Ports - RX PLL Ports ----------------------
    wire            gt0_rxresetdone_i;
    //--------------- Receive Ports - RX Polarity Control Ports ----------------
    wire            gt0_rxpolarity_i;
    //----------------------------- Transmit Ports -----------------------------
    wire            gt0_txuserrdy_i = 1'b0;
    //---------------- Transmit Ports - TX Data Path interface -----------------
    wire            gt0_gttxreset_i = 1'b0;
    wire            gt0_txoutclk_i;
    //-------------- Transmit Ports - TX Driver and OOB signaling --------------
    wire            gt0_gtxtxn_i;
    wire            gt0_gtxtxp_i;

    //____________________________COMMON PORTS________________________________
    //----------------------- Common Block - QPLL Ports ------------------------
    wire            gt0_qplllock_i;
    wire            gt0_qpllrefclklost_i;
    wire            gt0_qpllreset_i = 1'b0;


    //----------------------------- Global Signals -----------------------------

    wire            drpclk_in_i = drp_clk;
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
    wire            gt0_txusrclk_i; 
    wire            gt0_txusrclk2_i; 
    wire            gt0_rxoutclk_g;
    wire            gt0_rxusrclk_i  = gt0_rxoutclk_g; 
    wire            gt0_rxusrclk2_i = gt0_rxoutclk_g; 
 
    //--------------------------- Reference Clocks ----------------------------
    
    wire            q0_clk1_refclk_i = ref_clk;


    //--------------------- Frame check/gen Module Signals --------------------
    wire            gt0_matchn_i;
    
    wire    [5:0]   gt0_txcharisk_float_i;
   
    wire    [15:0]  gt0_txdata_float16_i;
    wire    [43:0]  gt0_txdata_float_i;
    
    
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

    wire            cpllreset_i;
    


//**************************** Main Body of Code *******************************

    //  Static signal Assigments    
    assign tied_to_ground_i             = 1'b0;
    assign tied_to_ground_vec_i         = 64'h0000000000000000;
    assign tied_to_vcc_i                = 1'b1;
    assign tied_to_vcc_vec_i            = 8'hff;


    //***********************************************************************//
    //                                                                       //
    //--------------------------- The GT Wrapper ----------------------------//
    //                                                                       //
    //***********************************************************************//
    
    // Use the instantiation template in the example directory to add the GT wrapper to your design.
    // In this example, the wrapper is wired up for basic operation with a frame generator and frame 
    // checker. The GTs will reset, then attempt to align and transmit data. If channel bonding is 
    // enabled, bonding should occur after alignment.
    
    daq_link_rx_init #
    (
        .EXAMPLE_SIM_GTRESET_SPEEDUP    (EXAMPLE_SIM_GTRESET_SPEEDUP),
        .EXAMPLE_SIMULATION             (EXAMPLE_SIMULATION),
        .EXAMPLE_USE_CHIPSCOPE          (EXAMPLE_USE_CHIPSCOPE)
    )
    daq_link_rx_init_i
    (
        .SYSCLK_IN                      (drp_clk),
        .SOFT_RESET_IN                  (soft_reset_i),
        .GT0_TX_FSM_RESET_DONE_OUT      (gt0_txfsmresetdone_i),
        .GT0_RX_FSM_RESET_DONE_OUT      (gt0_rxfsmresetdone_i),
        .GT0_DATA_VALID_IN              (1'b1),
 
 

        //_____________________________________________________________________
        //_____________________________________________________________________
        //GT0  (X0Y1)

        //----------------------- Channel - Ref Clock Ports ------------------------
        .GT0_GTREFCLK0_IN               (q0_clk1_refclk_i),
        //------------------------------ Channel PLL -------------------------------
        .GT0_CPLLFBCLKLOST_OUT          (gt0_cpllfbclklost_i),
        .GT0_CPLLLOCK_OUT               (gt0_cplllock_i),
        .GT0_CPLLLOCKDETCLK_IN          (drpclk_in_i),
        .GT0_CPLLRESET_IN               (gt0_cpllreset_i),
        //----------------------------- Eye Scan Ports -----------------------------
        .GT0_EYESCANDATAERROR_OUT       (gt0_eyescandataerror_i),
        //----------------------------- Receive Ports ------------------------------
        .GT0_RXUSERRDY_IN               (gt0_rxuserrdy_i),
        //--------------------- Receive Ports - 8b10b Decoder ----------------------
        .GT0_RXCHARISK_OUT              (gt0_rxcharisk_i),
        .GT0_RXCHARISCOMMA_OUT          (gt0_rxchariscomma_i),
        .GT0_RXDISPERR_OUT              (gt0_rxdisperr_i),
        .GT0_RXNOTINTABLE_OUT           (gt0_rxnotintable_i),
        //----------------- Receive Ports - Clock Correction Ports -----------------
        .GT0_RXCLKCORCNT_OUT            (gt0_rxclkcorcnt_i),
        //------------- Receive Ports - Comma Detection and Alignment --------------
        .GT0_RXBYTEISALIGNED_OUT        (gt0_rxbyteisaligned_i),
        .GT0_RXBYTEREALIGN_OUT          (gt0_rxbyterealign_i),
        .GT0_RXCOMMADET_OUT             (gt0_rxcommadet_i),
        //----------------- Receive Ports - RX Data Path interface -----------------
        .GT0_GTRXRESET_IN               (gt0_gtrxreset_i),
        .GT0_RXDATA_OUT                 (gt0_rxdata_i),
        .GT0_RXOUTCLK_OUT               (gt0_rxoutclk_i),
        .GT0_RXUSRCLK_IN                (gt0_rxusrclk_i),
        .GT0_RXUSRCLK2_IN               (gt0_rxusrclk_i),
        //----- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
        .GT0_GTXRXN_IN                  (RXN_IN),
        .GT0_GTXRXP_IN                  (RXP_IN),
        .GT0_RXCDRLOCK_OUT              (gt0_rxcdrlock_i),
        .GT0_RXELECIDLE_OUT             (gt0_rxelecidle_i),
        //---------------------- Receive Ports - RX PLL Ports ----------------------
        .GT0_RXRESETDONE_OUT            (gt0_rxresetdone_i),
        //--------------- Receive Ports - RX Polarity Control Ports ----------------
        .GT0_RXPOLARITY_IN              (gt0_rxpolarity_i),
        //----------------------------- Transmit Ports -----------------------------
        .GT0_TXUSERRDY_IN               (gt0_txuserrdy_i),
        //---------------- Transmit Ports - TX Data Path interface -----------------
        .GT0_GTTXRESET_IN               (gt0_gttxreset_i),
        .GT0_TXOUTCLK_OUT               (gt0_txoutclk_i),
        //-------------- Transmit Ports - TX Driver and OOB signaling --------------
        .GT0_GTXTXN_OUT                 (TXN_OUT),
        .GT0_GTXTXP_OUT                 (TXP_OUT),




    //____________________________COMMON PORTS________________________________
        //-------------------- Common Block  - Ref Clock Ports ---------------------
        .GT0_GTREFCLK0_COMMON_IN        (q0_clk1_refclk_i),
        //----------------------- Common Block - QPLL Ports ------------------------
        .GT0_QPLLLOCK_OUT               (gt0_qplllock_i),
        .GT0_QPLLLOCKDETCLK_IN          (drpclk_in_i),
        .GT0_QPLLRESET_IN               (gt0_qpllreset_i)

    );

    reg k_rxresetdone_t;
    reg [1:0] k_rxnotintable_t;
    reg [1:0] k_rxchariscomma_t;
    reg [1:0] k_rxcharisk_t;
    reg [15:0] k_rxdata_t = 16'h1;
    
    BUFG rxclk_buf (.I(gt0_rxoutclk_i), .O(gt0_rxoutclk_g));
    
	ODDR rx_clk_oddr
    (
        .Q(gt0_rxoutclk_p), // 1-bit DDR output
        .C(gt0_rxoutclk_g), // 1-bit clock input
        .CE(1'b1), // 1-bit clock enable input
        .D1(1'b0), // 1-bit data input (positive edge)
        .D2(1'b1), // 1-bit data input (negative edge)
        .R(1'b0), // 1-bit reset
        .S(1'b0) // 1-bit set
    );    
    
    always @(posedge gt0_rxoutclk_g)
    begin
        k_rxresetdone = k_rxresetdone_t;
        k_rxnotintable = k_rxnotintable_t;
        k_rxchariscomma = k_rxchariscomma_t;
        k_rxcharisk = k_rxcharisk_t;
        k_rxdata = k_rxdata_t;

        k_rxresetdone_t = gt0_rxresetdone_i;
        k_rxnotintable_t = gt0_rxnotintable_i;
        k_rxchariscomma_t = gt0_rxchariscomma_i;
        k_rxcharisk_t = gt0_rxcharisk_i;
        k_rxdata_t = gt0_rxdata_i;
//        k_rxdata_t = {k_rxdata_t[14:0], k_rxdata_t[15]}; // running 1 test
        
    end

 
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
    daq_link_rx_GT_FRAME_CHECK #
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
        .TRACK_DATA_OUT                 (gt0_track_data_i)
    );
*/


//    assign TRACK_DATA_OUT = track_data_out_i;

    assign track_data_out_i = 
                                gt0_track_data_i ;








//-------------------------------------------------------------------------------------


    //***********************************************************************//
    //                                                                       //
    //--------------------- Chipscope Connections ---------------------------//
    //                                                                       //
    //***********************************************************************//
    // When the example design is run in hardware, it uses chipscope to allow the
    // example design and GT wrapper to be controlled and monitored. The 
    // EXAMPLE_USE_CHIPSCOPE parameter allows chipscope to be removed for simulation.
    assign  gt0_rx_system_reset_c = !gt0_rxresetdone_r3;

//-------------------------------------------------------------
    assign  gtrxreset_i                          =  tied_to_ground_i;
    assign  user_tx_reset_i                      =  tied_to_ground_i;
    assign  user_rx_reset_i                      =  tied_to_ground_i;
    assign  gt0_rxpolarity_i                     =  1'b1;


endmodule
    
