//////////////////////////////////////////////////////////////////////////////////
// Company: UF
// Engineer: Madorsky
// 
// Create Date:    01:36:08 03/19/2010 
// Design Name: tf_slch
// Module Name:    prim_conv_sector 
// Project Name: tf_slch
// Target Devices: V6
// Tool versions: 11.4
// Description: primitive converter for entire sector
//
// Dependencies: prim_conv
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
`include "vppc_macros.sv"
`include "spbits.sv"

module prim_conv_sector
(
    vpf, q, wg, hstr, cpat,
    ph, th11, th, vl, phzvl, me11a, cpatr,
    ph_hit, 
    cs, sel, addr, r_in, r_out, we,

    clk,
    control_clk,
    endcap,
    lat_test
);                


// lct parameters [station][chamber][segment]
// st 5 = neighbor sector, all stations
    input [seg_ch-1:0] vpf  [5:0][8:0];
	input [3:0]        q    [5:0][8:0][seg_ch-1:0];
	input [bw_wg-1:0]  wg   [5:0][8:0][seg_ch-1:0];
	input [bw_hs-1:0]  hstr [5:0][8:0][seg_ch-1:0];
	input [3:0] 	   cpat [5:0][8:0][seg_ch-1:0];

	output [bw_fph-1:0]  ph   [5:0][8:0][seg_ch-1:0];
	// special th outputs for ME11 because of duplication
	// [station][chamber][segment with duplicates], station 2 = neighbor segment
	output [bw_th-1:0]  th11 [2:0][2:0][th_ch11-1:0];
	
	output [bw_th-1:0]  th   [5:0][8:0][seg_ch-1:0];
	output [seg_ch-1:0] vl   [5:0][8:0];
	output [2:0] 		phzvl[5:0][8:0];
	// me11a flags only for ME11 (stations 1,0, chambers 2:0)
	// [station][chamber][segment], station 2 = neighbor segment
	output [seg_ch-1:0] me11a [2:0][2:0];
	output [3:0] 		cpatr [5:0][8:0][seg_ch-1:0];
	// ph and th raw hits
	output [ph_hit_w-1:0] ph_hit [5:0][8:0];

	input [8:0] 			  cs [5:0];
	input [1:0] 			  sel;
	input [bw_addr-1:0] 	  addr;

	input  [12:0] r_in; // input data for memory or register
	output reg [12:0] r_out; // output data from memory or register
	input we; // write enable for memory or register
	input clk; // write clock
	input control_clk; // control interface clock
	input endcap; // 0=ME+, 1=ME-
	input lat_test; // latency test enable

	// wires for read data for each module,
	// have to be muxed to r_out according to cs
	wire [12:0] 	 r_out_w [5:0][8:0];
	// wires for we signals for each module
	wire [8:0] 	 we_w [5:0];
	wire [seg_ch-1:0] dummy [5:0][8:0];

	// mux LUT outputs to r_out
	integer 		  s, c;
	always @(posedge control_clk)
	begin
		r_out = 13'h0;
		for (s = 0; s < 6; s = s+1) // station loop
			for (c = 0; c < 9; c = c+1) // chamber loop
			begin
				if (cs[s][c]) r_out = r_out | r_out_w[s][c];
			end
	end

	`genv i, j;
	generate
//	begin: genblk
		
		// set we for selected modules
		for (i = 0; i < 6; i = i+1)
		begin : we_assign
			assign we_w[i] = (we) ? cs[i] : 0;
		end
		
		// 
		for (i = 0; i < 2; i = i+1)
		begin: station11
			for (j = 0; j < 3; j = j+1)
			begin: csc11
				prim_conv11 #(.station(i), .cscid(j)) pc11 
				(
				    .vpf         (vpf[i][j]),
				    .quality     (q  [i][j]), 
				    .wiregroup   (wg [i][j]), 
				    .hstrip      (hstr[i][j]),
				    .clctpat     (cpat[i][j]),
				    .ph          (ph [i][j]), 
				    .th          (th11 [i][j]), // use special th11 array for ME11 
				    .vl          (vl [i][j]),
				    .phzvl       (phzvl[i][j]),
				    .me11a       (me11a[i][j]),
				    .clctpat_r   (cpatr[i][j]),
				    .ph_hit      (ph_hit [i][j]),
				    .sel         (sel), 
				    .addr        (addr), 
				    .r_in        (r_in), 
				    .r_out       (r_out_w[i][j]), 
				    .we          (we_w   [i][j]), 
				    .clk         (clk),
				    .control_clk (control_clk),
				    .endcap (endcap)
				);
			end
		end // block: station11
		
		for (i = 0; i < 2; i = i+1)
		begin: station12
			for (j = 3; j < 9; j = j+1)
			begin: csc12
				prim_conv #(.station(i), .cscid(j)) pc12 
				(
 				     .vpf         (vpf[i][j]),
					 .quality	  (q  [i][j]), 
					 .wiregroup	  (wg [i][j]), 
					 .hstrip	  (hstr[i][j]), 
 				     .clctpat     (cpat[i][j]),
					 .ph		  (ph [i][j]), 
					 .th		  (th [i][j]), 
					 .vl		  (vl [i][j]),
					 .phzvl		  (phzvl[i][j]),
					 .me11a		  (dummy[i][j]),
				     .clctpat_r   (cpatr[i][j]),
					 .ph_hit	  (ph_hit [i][j]),
					 .sel		  (sel), 
					 .addr		  (addr), 
					 .r_in		  (r_in), 
					 .r_out		  (r_out_w[i][j]), 
					 .we		  (we_w	  [i][j]), 
					 .clk		  (clk),
					 .control_clk (control_clk),
				     .endcap (endcap)
				);
			end
		end // block: station12

		for (i = 2; i < 5; i = i+1)
		begin: station
			for (j = 0; j < 9; j = j+1)
			begin: csc
				prim_conv #(.station(i), .cscid(j)) pc 
				(
				     .vpf         (vpf[i][j]),
					 .quality	  (q  [i][j]), 
					 .wiregroup	  (wg [i][j]), 
					 .hstrip	  (hstr[i][j]), 
 				     .clctpat     (cpat[i][j]),
					 .ph		  (ph [i][j]), 
					 .th		  (th [i][j]), 
					 .vl		  (vl [i][j]),
					 .phzvl		  (phzvl[i][j]),
					 .me11a		  (dummy[i][j]),
				     .clctpat_r   (cpatr[i][j]),
					 .ph_hit	  (ph_hit [i][j]),
					 .sel		  (sel), 
					 .addr		  (addr), 
					 .r_in		  (r_in), 
					 .r_out		  (r_out_w[i][j]), 
					 .we		  (we_w	  [i][j]), 
					 .clk		  (clk),
					 .control_clk (control_clk),
    			     .endcap (endcap),
    			     .lat_test (lat_test)
				);
			end
		end // block: station

        // neighbor sector single ME11 chamber
        prim_conv11 #(.station(0), .cscid(12)) pcn11
        (
		    .vpf         (vpf[5][0]),
            .quality     (q  [5][0]), 
            .wiregroup   (wg [5][0]), 
            .hstrip      (hstr[5][0]),
            .clctpat     (cpat[5][0]),
            .ph          (ph [5][0]), 
            .th          (th11[2][0]), // use special th11 array for ME11 
            .vl          (vl [5][0]),
            .phzvl       (phzvl[5][0]),
            .me11a       (me11a[2][0]),
            .clctpat_r   (cpatr[5][0]),
            .ph_hit      (ph_hit [5][0]),
            .sel         (sel), 
            .addr        (addr), 
            .r_in        (r_in), 
            .r_out       (r_out_w[5][0]), 
            .we          (we_w   [5][0]), 
            .clk         (clk),
            .control_clk (control_clk),
            .endcap (endcap)
        );

        // rest of neighbor chambers 
        for (j = 1; j < 9; j = j+1)
        begin: cscn
            prim_conv #(.station(j < 3 ? 0 : (j+1)/2), .cscid(j < 3 ? j + 12 : (j-1)%2 + 9)) pcn 
            (
			     .vpf         (vpf[5][j]),
                 .quality	  (q  [5][j]), 
                 .wiregroup	  (wg [5][j]), 
                 .hstrip	  (hstr[5][j]), 
                 .clctpat     (cpat[5][j]),
                 .ph		  (ph [5][j]), 
                 .th		  (th [5][j]), 
                 .vl		  (vl [5][j]),
                 .phzvl		  (phzvl[5][j]),
                 .me11a		  (dummy[5][j]),
                 .clctpat_r   (cpatr[5][j]),
                 .ph_hit	  (ph_hit [5][j]),
                 .sel		  (sel), 
                 .addr		  (addr), 
                 .r_in		  (r_in), 
                 .r_out		  (r_out_w[5][j]), 
                 .we		  (we_w	  [5][j]), 
                 .clk		  (clk),
                 .control_clk (control_clk),
                 .endcap (endcap),
                 .lat_test (lat_test)
            );
        end

//	end // block: genblk
		
	endgenerate
	

endmodule
