`timescale 1ns / 1ps

module tx_crc
(
    input [31:0] d,
    input [3:0] k,
    output reg [31:0] dout,
    output reg [3:0] kout,
    input clk
);

    reg tx_crc;
    reg kr, krr;
    
    reg crc_en;
    wire [31:0] crc_out;
    reg crc_rst;
    
    crc_ol crc_ol_i
    (
      .data_in (d),
      .crc_en (crc_en),
      .crc_out (crc_out),
      .rst (crc_rst),
      .clk (clk)
    );

    always @(*)
    begin
        // command logic
        // see this document for details: stage1Interface_v3
        tx_crc = 1'b0;
        crc_en = 1'b0;
        crc_rst = 1'b0;
        if (k == 4'b1111) begin end // padding, don't calculate
        else
        if (k == 4'b0 && kr && !krr) begin tx_crc = 1'b1; end // transmit CRC
        else 
        if (k == 4'b1 && kr && krr) begin crc_rst = 1'b1; end // reset
        else 
        if (k == 4'h0) begin crc_en = 1'b1; end // keep calculating
        else begin end // comma, don't calculate
    end
     
    always @(posedge clk)
    begin
        if (k != 4'b1111) // shift K history only if not padding word
        begin
            krr = kr;
            kr = k[0];
        end
        kout = k; // just send k to the output 
        dout = (tx_crc == 1'b1) ? crc_out : d; 
    end
    
endmodule
