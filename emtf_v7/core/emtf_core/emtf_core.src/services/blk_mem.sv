module blk_mem 
(
    clka,
    clkb,
    ena,
    enb,
    wea,
    web,
    addra,
    addrb,
    dia,
    dib,
    doa,
    dob
);

   
   parameter AW = 10;
   parameter DW = 256;
  
   localparam MEM_SIZE = (1 << AW);
   
   input clka,clkb,ena,enb,wea,web;
   input [AW-1:0] addra,addrb;
   input [DW-1:0] dia,dib;
   output [DW-1:0] dob, doa;
   reg [DW-1:0] 	 ram [MEM_SIZE-1:0];
   reg [DW-1:0] 	 doa,dob;
   always @(posedge clka) begin
	  if (ena)
		begin
		   if (wea)
			 ram[addra] = dia;
		   doa = ram[addra];
		end
   end
   always @(posedge clkb) begin
	  if (enb)
		begin
		   if (web)
			 ram[addrb] = dib;
		   dob = ram[addrb];
		end
   end
endmodule
