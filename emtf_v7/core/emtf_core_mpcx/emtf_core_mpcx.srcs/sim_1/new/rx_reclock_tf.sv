`timescale 1ns / 1ps

module rx_reclock_tf;

    reg [37:0] rx_data_38 = 38'h0; // at mgt clk domain
    reg [1:0] rx_header = 2'b01;
    reg rx_clk = 1'b0; // mgt rx clock
     
    wire [75:0] rx_data_76_o; // at fabric clk domain
    wire clk40; // fabric clk
    reg clk320 = 1'b0;  // fabric clk x 8


    rx_reclock uut 
    (
        .rx_data_38   (rx_data_38  ), 
        .rx_header    (rx_header   ),
        .rx_clk       (rx_clk      ), 
         
        .rx_data_76_o (rx_data_76_o), 
        .clk40        (clk40       ), 
        .clk320       (clk320      )
    );

    wire [35:0] inreg_320_0 = uut.inreg_320[37:0];
    wire [35:0] inreg_320_1 = uut.inreg_320[75:38];

    always 
    begin
        #1.5625 
        clk320 = ~clk320;
    end
    
    always 
    begin
        //#6.25
        #6.3
        rx_clk = ~rx_clk;
    end
    
    reg [2:0] clk40_div = 2'b0;
    assign clk40 = clk40_div[2];
    
    always @(posedge clk320)
    begin
        clk40_div++;
    end
    
    always @(posedge rx_clk)
    begin
        rx_data_38++;
    end

    initial
    begin
        uut.clk80_ff = 0;
        uut.rx_header_320 = 0;
    end

endmodule
