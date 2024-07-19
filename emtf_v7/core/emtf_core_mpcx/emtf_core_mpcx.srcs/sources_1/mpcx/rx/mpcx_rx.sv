module mpcx_rx
(
    mgt_rx.out mgtrx,
    output [75:0] rx_data_76, // deframed data word
    input rx_fa_reset, // reset frame alignment and everything else
    input fiber_enable,
    input clk40, // clk40 and clk320 must have relative phase=0
    input clk320, // clk320 generated from or together with clk40 
    input pcie_clk
);

    wire rx_header_locked, rx_header_flag;

    wire [1:0] rx_header = 
    {
        mgtrx.rxdisperr [3],
        mgtrx.rxcharisk [3]
    };
    
    wire [37:0] rx_data_38 = 
    {
        mgtrx.rxdata    [31:24],
        mgtrx.rxdisperr [2],
        mgtrx.rxcharisk [2],
        mgtrx.rxdata    [23:16],
        mgtrx.rxdisperr [1],
        mgtrx.rxcharisk [1],
        mgtrx.rxdata    [15:8],
        mgtrx.rxdisperr [0],
        mgtrx.rxcharisk [0],
        mgtrx.rxdata    [7:0]
    };


    wire [37:0] rx_data_38_ds; // descrambled data word
    wire rx_gb_ready;
    wire rxslide = mgtrx.rxslide;

    mgt_framealigner
    #(
        .c_wordRatio               (2), // Word ratio: frameclock / mgt_wordclock
        .c_headerPattern           (2'b01), // Header pattern specified by the standard
        .c_wordSize                (40), // Size of the MGT word
        .c_allowedFalseHeader      (2), //(32), // Number of false header allowed to avoid unlock on frame error
        .c_allowedFalseHeaderOverN (40), // Number of header checked to know wether the lock is lost or not
        .c_requiredTrueHeader      (30), // Number of true header required to go in locked state
        
        .c_resetOnEven             (0),  // Reset on even bitslip (1: Enabled/ 0: disabled)
        .c_resetDuration           (10), // Reset duration (in clk_freeRunningClk_i periods)
        .c_bitslip_pulse_duration  (2),  // [PV]
        .c_bitslip_mindly          (40)  // Number of clock cycle required when asserting the bitslip signal
    )
    frame_align 
    (
        .clk_pcsRx_i             (mgtrx.rxoutclk), // MGT Wordclock
        .clk_freeRunningClk_i    (pcie_clk), // Free running clock for MGT reset (reset on even feature)
    
        .rst_pattsearch_i        (rx_fa_reset), // Rst the pattern search state machines
        .rst_mgtctrler_i         (rx_fa_reset), // Rst the "reset on even" controller
        .rst_rstoneven_o         (), // Output reset asserted when reset is even or odd depending on cmd_rstonevenoroddsel_i
    
        .cmd_bitslipCtrl_o       (mgtrx.rxslide), // Bitslip signal to shift the parrallel word
        .cmd_rstonevenoroddsel_i (1'b0), // Select how to reset the MGT (even or odd bitslip)
    
        .sta_headerLocked_o      (rx_header_locked), // Status: header is locked
        .sta_headerFlag_o        (rx_header_flag), // Status: header flag (1 pulse over c_wordRatio)
    
        .dat_word_i              (rx_header)  // Header bits from the MGT word (compared with c_headerPattern)
    );

    reg [1:0] rx_header_r;
    always @(posedge mgtrx.rxoutclk)
    begin
        rx_header_r = rx_header; // to match the latency of descrambler
    end

    mpc_descrambler ds 
    (
        .srx (rx_data_38), // scrambled RX data
        .drx (rx_data_38_ds), // unscrambled RX data
        .clk (mgtrx.rxoutclk),
        .rst (!rx_header_locked)
    );

    // local RX clock error check logic for predefined pattern (19-bit counter)
    reg [37:0] rx_r, rx_rr;

	reg [18:0] cnt_19;
	(* mark_debug *) wire [18:0] cnt_19_local = cnt_19;
	(* mark_debug *) wire [18:0] cnt_19_rx    = rx_rr[18:0];
	reg err_tst_pat_local;
	(* mark_debug *) wire err_tst_pat_local_w = err_tst_pat_local;
	reg rx_header_phase;
	reg header_phase_err;
	(* mark_debug *) wire header_phase_err_w = header_phase_err;

    always @(posedge mgtrx.rxoutclk)
    begin

        if (rx_header_r == 2'b10) // check if header phase has shifted
        begin 
            if (rx_header_phase != 1'b0) header_phase_err = 1'b1;
            else header_phase_err = 1'b0;
            rx_header_phase = 1'b1; // if special header, reset the header flag
        end
        else rx_header_phase = ~rx_header_phase; // if normal header, just flip the header flag

         // packaging in TX
         // {19'h0, cnt, 28'h0, mpc_id, i[3:0]}
         if (rx_header_phase)
         begin
            // check and lock test counter
            if (cnt_19 != rx_rr[18:0]) err_tst_pat_local = 1'b1; 
            else err_tst_pat_local = 1'b0;
            cnt_19 = rx_rr[18:0];
    
            cnt_19++;
         end
    
         rx_rr = rx_r;
         rx_r = rx_data_38_ds;
    end

    // clock domain crossing
    rx_reclock rxr
    (
        .rx_data_38     (rx_data_38_ds), // at mgt clk domain
        .rx_header      (rx_header_r),
        .rx_clk         (mgtrx.rxoutclk), // mgt rx clock
        
        .rx_data_76_o (rx_data_76), // at fabric clk domain
        .fiber_enable (fiber_enable),
        .clk40      (clk40), // fabric clk
        .clk320     (clk320)  // fabric clk x 8
    );
    
    
endmodule
