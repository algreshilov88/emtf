module mpc_scrambler #
( 
    parameter BW = 38
)
(
    input  wire  [(BW-1):0] dtx,
    output reg   [(BW-1):0] stx,

    input  wire          clk,
    input  wire          rst
);


    integer             i;
    reg     [57:0]      poly;
    reg     [(BW-1):0]  scrambled_data_i;
    reg     [57:0]      scrambler;
    reg     [(BW-1):0]  tempData;
    reg                 xorBit;

    always @(*)
    begin
        poly = scrambler;
        for (i = 0; i < BW; i=i+1)
        begin
            xorBit = dtx[i] ^ poly[38] ^ poly[57];
            poly = {poly[56:0], xorBit};
            tempData[i] = xorBit;
        end
    end  

    always @(posedge clk)
    begin
        if (rst)
        begin
            stx       = 38'h1555555555;//'h0;
            scrambler = 58'h155_5555_5555_5555;
        end
        else 
        begin
            stx       = tempData;
            scrambler = poly;
        end
    end
         
endmodule

