`timescale 1ps / 1ps

module clock_phase_detect_tf;

    reg [5:0] rx_clk = 6'h0;
    reg clk320 = 1'b0;
    wire [5:0] rx_clk_phase_drift;
    reg flag_reset;

    clock_sync_detect uut
    (
        .rx_clk      (rx_clk), // clocks from MPC RX, 80M
        .clk_320     (clk320), // fab clk * 8
        .phase_drift (rx_clk_phase_drift), // flags showing clock phase shift relative to fab clk
        .flag_reset  (flag_reset)// error flag resets
    );

    always 
    begin
        #6250 rx_clk[5:2] = ~rx_clk[5:2];
    end

    always 
    begin
        #6200 rx_clk[0] = ~rx_clk[0];
    end

    always 
    begin
        #6300 rx_clk[1] = ~rx_clk[1];
    end

    always 
    begin
        #1562.5 clk320 = ~clk320;
    end

    initial
    begin
        flag_reset = 0;
        #10000
        flag_reset = 1;
        #10000
        flag_reset = 0;
        
        # 500000
        flag_reset = 1;
        #10000
        flag_reset = 0;
        
        #(5000000-530000)
        flag_reset = 1;
        #10000
        flag_reset = 0;
    end


endmodule

