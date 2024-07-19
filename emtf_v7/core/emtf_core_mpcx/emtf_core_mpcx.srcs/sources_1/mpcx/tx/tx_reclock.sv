module tx_reclock
(
    input [75:0] din,
    // this is fabric clock, phase unknown, but synchronous with TXOUTCLK
    input clk40, 
    
    output reg [37:0] dout,
    output reg frame_0,
    // clk80 and clk320 must be generated from TXOUTCLK, and phase diff = 0
    input clk80,
    input clk320
);

    reg [75:0] inreg;
    (* async_reg *) reg [75:0] inreg_320, inreg_80;
    (* mark_debug *) wire [75:0] inreg_w = inreg;
    (* mark_debug *) wire [75:0] inreg320_w = inreg_320;
    reg clk40_ff;
    
    always @(posedge clk40)
    begin 
        inreg = din; // this should be combined with protocol encoding
        clk40_ff = ~clk40_ff; // just inverts on every clk40
    end 

    (* async_reg *) reg [10:0] clk40_r;
    (* mark_debug *) wire [10:0] clk40_rw = clk40_r;
    (* mark_debug *) wire clk40_w = clk40;
    (* mark_debug *) wire clk80_w = clk80;
   
    // use 320M clock to find 40M clock edge, and lock input data into TX clk domain at the right moment
    always @(posedge clk320)
    begin
 
        if (clk40_r[8:7] == 2'b01 || clk40_r[8:7] == 2'b10)
        begin 
         // this is the best phase of clk40 to move data to TX clock domain
            inreg_320 = inreg; 
            frame_0 = 1'b0;
        end 

        if (clk40_r[4:3] == 2'b01 || clk40_r[4:3] == 2'b10)
            frame_0 = 1'b1;
 
        clk40_r = {clk40_r[9:0], clk40_ff}; // clk40 history
        
    end


    // mux output according to frame_0 signal
    always @(posedge clk80)
    begin
        if (!frame_0) dout = inreg_80[37:0];
        else
        begin          
            dout = inreg_80[75:38];
            inreg_80 = inreg_320; // update input word only when MS bits are out
        end
    end
    

endmodule
