//////////////////////////////////////////////////////////////////////////////////
// Company: UF
// Engineer: Madorsky
// 
// Create Date:    01:36:08 03/19/2010 
// Design Name: tf_slhc
// Module Name:    ph_pattern 
// Project Name: tf_slch
// Target Devices: V6
// Tool versions: 11.4
// Description: phi pattern detector
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
////////////////////////////////////////////////////////////////////////////////////
`include "vppc_macros.sv"

module ph_pattern
(
    st1, 	  
    st2, 	  
    st3, 	  
    st4,	  
    drifttime,
	foldn,	  
    qcode,	  	  
    clk       
);

`include "spbits.sv"
	// input raw hit bits
    input [full_pat_w_st1-1 : 0] st1;
    input st2;
    input [full_pat_w_st3-1 : 0] st3;
    input [full_pat_w_st3-1 : 0] st4;
    input [2:0] drifttime;
	// number of current fold 
	input [2:0] foldn;
	// quality code output
    output reg [5:0] qcode;
    input clk;

    `int mi; 
	// bx counters, one per pattern per fold
    reg [2:0] bx [4:0][fold-1:0];
	
	reg [2:0] lyhits;
    reg [5:0] qcode_p [4:0];
	reg [2:0] straightness;
	reg [5:0] comp1 [1:0];
	reg [5:0] comp2;
    reg more_than_one, more_than_zero; 
	
    always @(posedge clk) 
    begin


        for (mi = 0; mi < 5; mi = mi + 1) 
        begin

			case (mi)
				0: begin
					lyhits[2] = (|st1[30:23]) | (|st1[7:0]);
					lyhits[1] = st2;
					lyhits[0] = (|st3[14:0]) | (|st4[14:0]);
					straightness = 3'h0;
				end
				1: begin
					lyhits[2] = (|st1[22:19]) | (|st1[11:8]);
					lyhits[1] = st2;
					lyhits[0] = (|st3[14:0]) | (|st4[14:0]);
					straightness = 3'h1;
				end
				2: begin
					lyhits[2] = (|st1[18:17]) | (|st1[13:12]);
					lyhits[1] = st2;
					lyhits[0] = (|st3[10:4]) | (|st4[10:4]);
					straightness = 3'h2;
				end
				3: begin
					lyhits[2] = st1[16] | st1[14];
					lyhits[1] = st2;
					lyhits[0] = (|st3[8:6]) | (|st4[8:6]);
					straightness = 3'h3;
				end
				4: begin
					lyhits[2] = st1[15];
					lyhits[1] = st2;
					lyhits[0] = st3[7] | st4[7];
					straightness = 3'h4;
				end
			endcase

			qcode_p[mi] = 0;
			more_than_one = (lyhits != 3'h0 && lyhits != 3'h1 && lyhits != 3'h2 && lyhits != 3'h4) ? 1'b1 : 1'b0;
		    more_than_zero = (lyhits != 3'h0) ? 1'b1 : 1'b0;
			
			if 
			(
			    bx[mi][foldn][2] == 1'b0 && // if drift time is up, find quality of this pattern
                bx[mi][foldn][1] == 1'b1 && 
				// remove single-layer and ME3-4 hit patterns
				more_than_one
			)
				// this quality code scheme is giving almost-equal priority to more stations and better straightness.
				// station 1 has higher weight, station 2 lower, st. 3 and 4 lowest
				qcode_p[mi] = {straightness[2], lyhits[2], straightness[1], lyhits[1], straightness[0], lyhits[0]};
			
			
		   // process bx shifter
            bx[mi][foldn][2] = bx[mi][foldn][1];
            bx[mi][foldn][1] = bx[mi][foldn][0];
            bx[mi][foldn][0] = more_than_zero; // put 1 in shifter when one layer is hit 
        end

        qcode = 0;
		// find max quality on each clock
		comp1[0] = qcode_p[0] > qcode_p[1] ? qcode_p[0] : qcode_p[1];
		comp1[1] = qcode_p[2] > qcode_p[3] ? qcode_p[2] : qcode_p[3];

		comp2 = comp1[0] > comp1[1] ? comp1[0] : comp1[1];

		qcode = comp2 > qcode_p[4] ? comp2 : qcode_p[4];

    end
endmodule
