`include "vppc_macros.sv"
`ifdef SIMULATION_DAQ
    `include "spbits.sv"
`endif

module prim_conv_ge11
(
	ge11_cluster.in cl,
	output reg [bw_fph-1:0] ph, 
	// full precision th, but without displacement correction
	output reg [bw_th-1:0] th,
	// one-bit valid flags
	output reg vl,

	output reg [2:0] phzvl, // raw hit valid flags for up to 3 ph zones
	output reg [ph_hit_w-1:0] ph_hit, // raw hits

	input [7:0]  th_mem [7:0], // make memory size such that any address will be in range
	input [63:0] ph_init, // programmable parameter, chamber strip 0 phi coord
	input  clk, // write clock
	input  endcap

);

`include "spbits.sv"
`include "ph_init_hard.sv"

	reg [mult_bw-1:0] mult;
	reg [bw_fph-1:0] ph_tmp;
    reg [bw_fph-1:0] ph_hit_local;

	`int i;
	reg [bw_th-1:0] th_tmp;
	// theta lut, takes wiregroup, returns theta

	// initial ph for this chamber scaled to 0.1333 deg/strip
	reg [bw_fph-1:0] fph; 

	`int j;

	reg [11:0] factor; // strip width factor

	wire [7:0] 		 pc_id; // prim converter ID

	assign pc_id[3:0] = cscid; // layer in case of GE11
	assign pc_id[7:4] = station; // super-chamber in case of GE11

   	// select chamber start for this unit from the table above
   	wire [bw_fph-5-1:0] ph_hard = ge11_ph_init_hard[station][cscid];
   	reg	[bw_fph-5-1:0] ph_reduced ;
   	reg [bw_fph-1:0]   fph_to_reduce;

	// is this chamber mounted in reverse direction?
	// mapping comes from GE11_reverse_map.xlsx file
	wire ph_reverse = ((endcap == 1'b0 && (station == 0 || station == 2 || station == 4)) ||
	                   (endcap == 1'b1 && (station == 1 || station == 3 || station >= 5))) ? 1'b1 : 1'b0; 

	
	always @(posedge clk)
	begin

		// zero outputs
		vl = 0;
		phzvl = 0;
		fph = 0; 
		th = 0; 
		ph_hit = 0;
		

		// strip width factor relative to ME234/2 
		// 1024 == 1
		// factor needs correction for gem
		factor = 3256; // calculated by Jia Fu, see email from 2020-09-13
        // The GE1/1 pad pitch according to CMSSW is: 0.0529872. As the nominal pitch is 0.1333333, 
        // and the nominal 1/8-pitch is 1/8 of that, I calculated the multiplier factor as:
        // pad_pitch_multiplier = round(pad_pitch / (nominal_pitch / 8) * 1024) = 3256		  

		if (cl.vf) // valid cluster
		begin
			vl = 1;
			// ph conversion
			// for factors 1024 and 2048 the multiplier should be replaced with shifts by synthesizer
			mult = cl.str * factor;
			ph_tmp = mult[mult_bw-1 : 10];
			if (ph_reverse) fph = ph_init - ph_tmp;
			else            fph = ph_init + ph_tmp;

		    fph_to_reduce = fph + 13'd16; // +16 to put the rounded value into the middle of error range
		    // divide full ph by 32, subtract chamber start
		    ph_reduced = fph_to_reduce[bw_fph-1:5] - ph_hard;
		    ph_hit[ph_reduced] = 1'b1; // set hit in zone
			   
			// th conversion
			th = th_mem[cl.prt];
			if (th == 7'h0) th = 7'h1; // protect against invalid value


			// check which zones ph hits should be applied to
			if (th <= (ph_zone_bnd1 + zone_overlap)) phzvl[0] = 1;
			if (th >  (ph_zone_bnd2 - zone_overlap)) phzvl[2] = 1;
			if (
				(th >  (ph_zone_bnd1 - zone_overlap)) &&
				(th <= (ph_zone_bnd2 + zone_overlap))
				) phzvl[1] = 1;

		end 

		ph = fph;
	end


endmodule

