`timescale 1ns / 1ps

module led_driver
(
    input low_pwr,
    input high_pwr,
    output reg led,
    input clk
);
    localparam os_time = 21'd400000; // 10 ms
    reg act = 1'b0;
    reg [17:0] clk_div = 1'b0;
    reg [20:0] act_cnt;
    always @(posedge clk)
    begin
        // 1/16-power if low_pwr, full power if activity
        led = clk_div[17:14] == 4'h0 ? low_pwr : act;
        clk_div = clk_div + 18'h1;
        
        // activity one-shot
        if (high_pwr)
        begin
            act_cnt = 21'h0;
            act = 1'b1;
        end
        else
        begin
            if (act_cnt != os_time) act_cnt = act_cnt + 21'h1;
            else act = 1'b0;
        end
        
    end
    
    
    
endmodule
