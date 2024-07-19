module mpc_descrambler #
( 
    parameter BW = 38
)
(
    input  wire [(BW-1):0] srx,
    output reg  [(BW-1):0] drx,

    input  wire         clk,
    input  wire         rst
);

    reg     [57:0]     descrambler;
    integer            i;
    reg     [57:0]     poly;
    reg     [(BW-1):0] tempData;
    reg     [(BW-1):0] unscrambled_data_i;
    reg                xorBit;

    always @(*)
    begin
        poly = descrambler;
        for (i = 0; i < BW; i++)
        begin
            xorBit = srx[i] ^ poly[38] ^ poly[57];
            poly = {poly[56:0], srx[i]};
            tempData[i] = xorBit;
        end
    end

    always @(posedge clk)
    begin
        if (rst)
        begin
            drx         = 'h0;
            descrambler = 58'h155_5555_5555_5555;
        end
        else 
        begin
            drx         = tempData;
            descrambler = poly;
        end
    end
         
endmodule
