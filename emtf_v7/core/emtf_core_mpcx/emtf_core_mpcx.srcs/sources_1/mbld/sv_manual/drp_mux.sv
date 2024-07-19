`include "drp_interface.sv"

module drp_mux #
(
    parameter N = 2,
    parameter AW_QUAD = 9,
    parameter AW_FPGA = 11
)
(
    drp.out drp_quad[N-1:0],
    drp.in  drp_fpga,
    input drp_clk
);

	(* dont_touch = "true" *) logic [AW_QUAD-1:0] drpaddr_quad [N-1:0];
	(* dont_touch = "true" *) logic [31:0]  drpdi_quad   [N-1:0];
	(* dont_touch = "true" *) logic [31:0]  drpdo_quad   [N-1:0];
	(* dont_touch = "true" *) logic [N-1:0] drpen_quad ;
	(* dont_touch = "true" *) logic [N-1:0] drprdy_quad ;
	(* dont_touch = "true" *) logic [N-1:0] drpwe_quad ;
	(* dont_touch = "true" *) logic [N-1:0] int_reg_quad ;

	(* dont_touch = "true" *) logic [AW_FPGA-1:0] drpaddr_fpga;
	(* dont_touch = "true" *) logic [31:0] drpdi_fpga;
	(* dont_touch = "true" *) logic [31:0] drpdo_fpga;
	(* dont_touch = "true" *) logic        drpen_fpga;
	(* dont_touch = "true" *) logic        drprdy_fpga;
	(* dont_touch = "true" *) logic        drpwe_fpga;
	(* dont_touch = "true" *) logic        int_reg_fpga;
	
	genvar gi;
	generate
	   for (gi = 0; gi < N; gi++)
	   begin: ass_quad_loop
	       assign drp_quad[gi].drpaddr = drpaddr_quad[gi];
//	       assign drp_quad[gi].drpclk  = drpclk_quad[gi];
	       assign drp_quad[gi].drpdi   = drpdi_quad[gi];
	       assign drpdo_quad[gi]       = drp_quad[gi].drpdo;
	       assign drp_quad[gi].drpen   = drpen_quad[gi];
	       assign drprdy_quad[gi]      = drp_quad[gi].drprdy;
	       assign drp_quad[gi].drpwe   = drpwe_quad[gi];
	       assign drp_quad[gi].int_reg = int_reg_quad[gi];
	   end
	endgenerate

   assign drpaddr_fpga    = drp_fpga.drpaddr;
//   assign drpclk_fpga     = drp_fpga.drpclk ;
   assign drpdi_fpga      = drp_fpga.drpdi  ;
   assign drp_fpga.drpdo  = drpdo_fpga      ;
   assign drpen_fpga      = drp_fpga.drpen  ;
   assign drp_fpga.drprdy = drprdy_fpga     ;
   assign drpwe_fpga      = drp_fpga.drpwe  ;
   assign int_reg_fpga    = drp_fpga.int_reg;
   
	integer di;
//	always @(posedge drpclk_fpga)
	always @(posedge drp_clk)
	begin
		drprdy_fpga = 1'b0;
		for (di = 0; di < N; di++)
		begin
			if (drprdy_quad[di] == 1'b1)
			begin
				drpdo_fpga = drpdo_quad[di];
				drprdy_fpga = 1'b1;
			end
		end
	end
	always @(*)
	begin
		for (di = 0; di < N; di++)
		begin
			drpaddr_quad[di] = drpaddr_fpga;
//			drpclk_quad [di] = drpclk_fpga;
			drpdi_quad  [di] = drpdi_fpga;
			drpwe_quad  [di] = drpwe_fpga;
			drpen_quad  [di] = 1'b0;
			int_reg_quad[di] = 1'b0;
		end
		if (drpen_fpga == 1'b1)
			drpen_quad[drpaddr_fpga[AW_FPGA-1 : AW_QUAD]] = 1'b1;
		if (int_reg_fpga == 1'b1)
			int_reg_quad[drpaddr_fpga[AW_FPGA-1 : AW_QUAD]] = 1'b1;
	end
   

endmodule
