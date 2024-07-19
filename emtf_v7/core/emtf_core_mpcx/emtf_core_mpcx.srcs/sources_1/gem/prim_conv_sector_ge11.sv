`ifdef SIMULATION_DAQ
    `include "spbits.sv"
`endif

module prim_conv_sector_ge11
(
 	ge11_cluster.in ge11_cl [6:0][1:0][7:0],

	output [bw_fph-1:0] ph [6:0][1:0][7:0], 
	output [bw_th-1:0]  th [6:0][1:0][7:0],
	output [7:0]        vl [6:0][1:0],

	output [2:0] phzvl [6:0][1:0][7:0], // raw hit valid flags for up to 3 ph zones
	output [ph_hit_w-1:0] ph_hit [6:0][1:0][7:0], // raw hits

	input  [1:0] reg_select, // 1 = ph_init, 2 = th_mem
	input  [bw_addr-1:0] addr, // address in memory to access. For registers, set to 0
	input  [63:0] r_in, // input data for memory or register
	output reg [63:0] r_out, // output data from memory or register
	input  we, // write enable for memory or register
	input  clk, // write clock
	input  control_clk, // control interface clock
	input  endcap
);

`include "spbits.sv"

	// all th LUTs combined into one array
	typedef union
	{
		// [schamber][layer][lut_location]
		bit [7:0] split [6:0][1:0][7:0];
		bit [8*8-1:0] comb [7*2-1:0]; // 14 64-bit words
	} th_mem_u;

	th_mem_u th_mem;

	// all ph_init parameters in one array
	typedef union
	{
		// [schamber][layer]
		bit [63:0] split [6:0][1:0]; // programmable parameter, chamber strip 0 phi coord
		bit [63:0] comb  [7*2-1:0]; // 
	} ph_init_u;

	ph_init_u ph_init;

	always @(posedge control_clk)
	begin
	    // parameter write
		if (we)
		begin
			case (reg_select)
				2'h2: begin th_mem.comb[addr] = r_in; end
			 	2'h1: begin	ph_init.comb[addr] = r_in; end
			endcase
		end
	    // parameter readback 
        r_out = reg_select == 2'h2 ? th_mem.comb[addr] : 
			    reg_select == 2'h1 ? ph_init.comb[addr] : 64'b0;
	end

	genvar gi, gj, gk;
	generate

		for (gi = 0; gi < 7; gi++) // schamber
		begin: ge11_scham_loop
			for (gj = 0; gj < 2; gj++) // layer
			begin: ge11_layer_loop
				for (gk = 0; gk < 8; gk++) // cluster
				begin: ge11_cluster_loop
					prim_conv_ge11 #
					(
					 	.station (gi), // super-chamber
						.cscid   (gj) // layer
					) 
					pcge11
					(
					 	.cl      (ge11_cl [gi][gj][gk]),
						.ph      (ph      [gi][gj][gk]),
						.th      (th      [gi][gj][gk]),
						.vl      (vl      [gi][gj][gk]),
						.phzvl   (phzvl   [gi][gj][gk]),
						.th_mem  (th_mem.split  [gi][gj]), // these LUTs are per chamber, don't depend on cluster #
						.ph_init (ph_init.split [gi][gj]), // these LUTs are per chamber, don't depend on cluster #
						.clk     (clk),
						.endcap  (endcap)
					);
				end
			end
		end
	endgenerate

endmodule

