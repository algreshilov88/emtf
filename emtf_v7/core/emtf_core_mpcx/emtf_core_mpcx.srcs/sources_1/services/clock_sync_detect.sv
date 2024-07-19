module clock_sync_detect
(
 	input [5:0] rx_clk, // clocks from MPC RX, 80M
	input clk_320, // fab clk * 8
	output reg [5:0] phase_drift, // flags showing clock phase shift relative to fab clk
	input flag_reset // error flag resets
);

    reg [5:0] rx_clk_ff [5:0] = '{8'h0, 8'h0, 8'h0, 8'h0, 8'h0, 8'h0};
    reg [7:0] rx_clk_cnt [5:0];
    reg [9:0] fab_clk_cnt;
    wire [7:0] fab_clk_0  = fab_clk_cnt[9:2];
    wire [7:0] fab_clk_p1 = fab_clk_cnt[9:2] + 8'h1;
    wire [7:0] fab_clk_n1 = fab_clk_cnt[9:2] - 8'h1;
    
    genvar gi;
    generate
        for (gi = 0; gi < 6; gi++)
        begin
            always @(posedge rx_clk[gi]) rx_clk_ff[gi][0] = ~rx_clk_ff[gi][0];
        end
    endgenerate

    integer i;
    always @(posedge clk_320)
    begin
        if (flag_reset)
        begin
            fab_clk_cnt = 10'h0;
            phase_drift = 6'h0;
            rx_clk_cnt = '{8'h0, 8'h0, 8'h0, 8'h0, 8'h0, 8'h0};
        end
        else
        begin
            for (i = 0; i < 6; i++)
            begin
            
                if (rx_clk_ff[i][5] != rx_clk_ff[i][4]) // rx clock transition detected
                begin
                    if (
                        fab_clk_0  != rx_clk_cnt[i] &&
                        fab_clk_p1 != rx_clk_cnt[i] &&
                        fab_clk_n1 != rx_clk_cnt[i]
                        ) // phase drift detected
                        phase_drift[i] = 1'b1;
                
                    rx_clk_cnt[i]++; // increase count
                end
                
                // demetastab 
                rx_clk_ff[i][5:1] = rx_clk_ff[i][4:0]; 
            end
            fab_clk_cnt++;
        end
    end

endmodule

