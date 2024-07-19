//////////////////////////////////////////////////////////////////////////////////
// Company: UF
// Engineer: Madorsky
// 
// Create Date:    20:48:51 03/25/2010 
// Design Name: tf_slhc
// Module Name:    zones 
// Project Name: tf_slhc
// Target Devices: V6	
// Tool versions: 11.4
// Description: raw hit zone merger
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
`include "vppc_macros.sv"

module zones
(
    phzvl,
    ph_hit, 
	ph_zone, 
	clk
);
`include "spbits.sv"
`include "ph_init_hard.sv"
	
	// ph zone valid flags [station][chamber][zone]
	// note that zone flags in phzvl are local to each chamber
    input [2:0] 		 phzvl[5:0][8:0];

	// ph raw hits [station][chamber]
	input [ph_hit_w-1:0] ph_hit [5:0][8:0];
	// ph zones [zone][station]
	output reg [ph_raw_w-1:0] ph_zone [3:0][4:1];
	
	input clk;

	always @(*) 
	begin
		
		// ph zone 0 stations 1234
		ph_zone[0][1] = 0;
		if (phzvl[5][0][0]) ph_zone[0][1][ph_init_hard[0][12]+: ph_hit_w10] |= ph_hit[5][0]; // neighbor sector
		if (phzvl[0][0][0]) ph_zone[0][1][ph_init_hard[0][0] +: ph_hit_w10] |= ph_hit[0][0];
		if (phzvl[0][1][0]) ph_zone[0][1][ph_init_hard[0][1] +: ph_hit_w10] |= ph_hit[0][1];
		if (phzvl[0][2][0]) ph_zone[0][1][ph_init_hard[0][2] +: ph_hit_w10] |= ph_hit[0][2];
		if (phzvl[1][0][0]) ph_zone[0][1][ph_init_hard[1][0] +: ph_hit_w10] |= ph_hit[1][0];
		if (phzvl[1][1][0]) ph_zone[0][1][ph_init_hard[1][1] +: ph_hit_w10] |= ph_hit[1][1];
		if (phzvl[1][2][0]) ph_zone[0][1][ph_init_hard[1][2] +: ph_hit_w10] |= ph_hit[1][2];
                                                          
		ph_zone[0][2] = 0;                                 
		if (phzvl[5][3][0]) ph_zone[0][2][ph_init_hard[2][9]+: ph_hit_w20] |= ph_hit[5][3]; // neighbor sector
		if (phzvl[2][0][0]) ph_zone[0][2][ph_init_hard[2][0]+: ph_hit_w20] |= ph_hit[2][0];
		if (phzvl[2][1][0]) ph_zone[0][2][ph_init_hard[2][1]+: ph_hit_w20] |= ph_hit[2][1];
		if (phzvl[2][2][0]) ph_zone[0][2][ph_init_hard[2][2]+: ph_hit_w20] |= ph_hit[2][2];
														
		ph_zone[0][3] = 0;								
		if (phzvl[5][5][0]) ph_zone[0][3][ph_init_hard[3][9]+: ph_hit_w20] |= ph_hit[5][5]; // neighbor sector
		if (phzvl[3][0][0]) ph_zone[0][3][ph_init_hard[3][0]+: ph_hit_w20] |= ph_hit[3][0];
		if (phzvl[3][1][0]) ph_zone[0][3][ph_init_hard[3][1]+: ph_hit_w20] |= ph_hit[3][1];
		if (phzvl[3][2][0]) ph_zone[0][3][ph_init_hard[3][2]+: ph_hit_w20] |= ph_hit[3][2];

		ph_zone[0][4] = 0;								
		if (phzvl[5][7][0]) ph_zone[0][4][ph_init_hard[4][9]+: ph_hit_w20] |= ph_hit[5][7]; // neighbor sector
		if (phzvl[4][0][0]) ph_zone[0][4][ph_init_hard[4][0]+: ph_hit_w20] |= ph_hit[4][0];
		if (phzvl[4][1][0]) ph_zone[0][4][ph_init_hard[4][1]+: ph_hit_w20] |= ph_hit[4][1];
		if (phzvl[4][2][0]) ph_zone[0][4][ph_init_hard[4][2]+: ph_hit_w20] |= ph_hit[4][2];

		// ph zone 1 stations 1234
		ph_zone[1][1] = 0;
		if (phzvl[5][0][1]) ph_zone[1][1][ph_init_hard[0][12]+: ph_hit_w10] |= ph_hit[5][0];
		if (phzvl[0][0][1]) ph_zone[1][1][ph_init_hard[0][0] +: ph_hit_w10] |= ph_hit[0][0];
		if (phzvl[0][1][1]) ph_zone[1][1][ph_init_hard[0][1] +: ph_hit_w10] |= ph_hit[0][1];
		if (phzvl[0][2][1]) ph_zone[1][1][ph_init_hard[0][2] +: ph_hit_w10] |= ph_hit[0][2];
		if (phzvl[1][0][1]) ph_zone[1][1][ph_init_hard[1][0] +: ph_hit_w10] |= ph_hit[1][0];
		if (phzvl[1][1][1]) ph_zone[1][1][ph_init_hard[1][1] +: ph_hit_w10] |= ph_hit[1][1];
		if (phzvl[1][2][1]) ph_zone[1][1][ph_init_hard[1][2] +: ph_hit_w10] |= ph_hit[1][2];
														
		ph_zone[1][2] = 0;								
		if (phzvl[5][3][1]) ph_zone[1][2][ph_init_hard[2][9]+: ph_hit_w20] |= ph_hit[5][3];
		if (phzvl[2][0][1]) ph_zone[1][2][ph_init_hard[2][0]+: ph_hit_w20] |= ph_hit[2][0];
		if (phzvl[2][1][1]) ph_zone[1][2][ph_init_hard[2][1]+: ph_hit_w20] |= ph_hit[2][1];
		if (phzvl[2][2][1]) ph_zone[1][2][ph_init_hard[2][2]+: ph_hit_w20] |= ph_hit[2][2];

														
		ph_zone[1][3] = 0;								
		if (phzvl[5][6][0]) ph_zone[1][3][ph_init_hard[3][10]+: ph_hit_w10] |= ph_hit[5][6];
		if (phzvl[3][3][0]) ph_zone[1][3][ph_init_hard[3][3] +: ph_hit_w10] |= ph_hit[3][3];
		if (phzvl[3][4][0]) ph_zone[1][3][ph_init_hard[3][4] +: ph_hit_w10] |= ph_hit[3][4];
		if (phzvl[3][5][0]) ph_zone[1][3][ph_init_hard[3][5] +: ph_hit_w10] |= ph_hit[3][5];
		if (phzvl[3][6][0]) ph_zone[1][3][ph_init_hard[3][6] +: ph_hit_w10] |= ph_hit[3][6];
		if (phzvl[3][7][0]) ph_zone[1][3][ph_init_hard[3][7] +: ph_hit_w10] |= ph_hit[3][7];
		if (phzvl[3][8][0]) ph_zone[1][3][ph_init_hard[3][8] +: ph_hit_w10] |= ph_hit[3][8];
														  
		ph_zone[1][4] = 0;								
		if (phzvl[5][8][0]) ph_zone[1][4][ph_init_hard[4][10]+: ph_hit_w10] |= ph_hit[5][8];
		if (phzvl[4][3][0]) ph_zone[1][4][ph_init_hard[4][3] +: ph_hit_w10] |= ph_hit[4][3];
		if (phzvl[4][4][0]) ph_zone[1][4][ph_init_hard[4][4] +: ph_hit_w10] |= ph_hit[4][4];
		if (phzvl[4][5][0]) ph_zone[1][4][ph_init_hard[4][5] +: ph_hit_w10] |= ph_hit[4][5];
		if (phzvl[4][6][0]) ph_zone[1][4][ph_init_hard[4][6] +: ph_hit_w10] |= ph_hit[4][6];
		if (phzvl[4][7][0]) ph_zone[1][4][ph_init_hard[4][7] +: ph_hit_w10] |= ph_hit[4][7];
		if (phzvl[4][8][0]) ph_zone[1][4][ph_init_hard[4][8] +: ph_hit_w10] |= ph_hit[4][8];

		// ph zone 2 stations 1234
		ph_zone[2][1] = 0;
		if (phzvl[5][1][0]) ph_zone[2][1][ph_init_hard[0][13]+: ph_hit_w10] |= ph_hit[5][1];
		if (phzvl[0][3][0]) ph_zone[2][1][ph_init_hard[0][3] +: ph_hit_w10] |= ph_hit[0][3];
		if (phzvl[0][4][0]) ph_zone[2][1][ph_init_hard[0][4] +: ph_hit_w10] |= ph_hit[0][4];
		if (phzvl[0][5][0]) ph_zone[2][1][ph_init_hard[0][5] +: ph_hit_w10] |= ph_hit[0][5];
		if (phzvl[1][3][0]) ph_zone[2][1][ph_init_hard[1][3] +: ph_hit_w10] |= ph_hit[1][3];
		if (phzvl[1][4][0]) ph_zone[2][1][ph_init_hard[1][4] +: ph_hit_w10] |= ph_hit[1][4];
		if (phzvl[1][5][0]) ph_zone[2][1][ph_init_hard[1][5] +: ph_hit_w10] |= ph_hit[1][5];

		ph_zone[2][2] = 0;				  			
		if (phzvl[5][4][0]) ph_zone[2][2][ph_init_hard[2][10]+: ph_hit_w10] |= ph_hit[5][4];
		if (phzvl[2][3][0]) ph_zone[2][2][ph_init_hard[2][3] +: ph_hit_w10] |= ph_hit[2][3];
		if (phzvl[2][4][0]) ph_zone[2][2][ph_init_hard[2][4] +: ph_hit_w10] |= ph_hit[2][4];
		if (phzvl[2][5][0]) ph_zone[2][2][ph_init_hard[2][5] +: ph_hit_w10] |= ph_hit[2][5];
		if (phzvl[2][6][0]) ph_zone[2][2][ph_init_hard[2][6] +: ph_hit_w10] |= ph_hit[2][6];
		if (phzvl[2][7][0]) ph_zone[2][2][ph_init_hard[2][7] +: ph_hit_w10] |= ph_hit[2][7];
		if (phzvl[2][8][0]) ph_zone[2][2][ph_init_hard[2][8] +: ph_hit_w10] |= ph_hit[2][8];
										                     
		ph_zone[2][3] = 0;				  			   		 
		if (phzvl[5][6][1]) ph_zone[2][3][ph_init_hard[3][10]+: ph_hit_w10] |= ph_hit[5][6];
		if (phzvl[3][3][1]) ph_zone[2][3][ph_init_hard[3][3] +: ph_hit_w10] |= ph_hit[3][3];
		if (phzvl[3][4][1]) ph_zone[2][3][ph_init_hard[3][4] +: ph_hit_w10] |= ph_hit[3][4];
		if (phzvl[3][5][1]) ph_zone[2][3][ph_init_hard[3][5] +: ph_hit_w10] |= ph_hit[3][5];
		if (phzvl[3][6][1]) ph_zone[2][3][ph_init_hard[3][6] +: ph_hit_w10] |= ph_hit[3][6];
		if (phzvl[3][7][1]) ph_zone[2][3][ph_init_hard[3][7] +: ph_hit_w10] |= ph_hit[3][7];
		if (phzvl[3][8][1]) ph_zone[2][3][ph_init_hard[3][8] +: ph_hit_w10] |= ph_hit[3][8];
										  			  
		ph_zone[2][4] = 0;				  			
		if (phzvl[5][8][1]) ph_zone[2][4][ph_init_hard[4][10]+: ph_hit_w10] |= ph_hit[5][8];
		if (phzvl[4][3][1]) ph_zone[2][4][ph_init_hard[4][3] +: ph_hit_w10] |= ph_hit[4][3];
		if (phzvl[4][4][1]) ph_zone[2][4][ph_init_hard[4][4] +: ph_hit_w10] |= ph_hit[4][4];
		if (phzvl[4][5][1]) ph_zone[2][4][ph_init_hard[4][5] +: ph_hit_w10] |= ph_hit[4][5];
		if (phzvl[4][6][1]) ph_zone[2][4][ph_init_hard[4][6] +: ph_hit_w10] |= ph_hit[4][6];
		if (phzvl[4][7][1]) ph_zone[2][4][ph_init_hard[4][7] +: ph_hit_w10] |= ph_hit[4][7];
		if (phzvl[4][8][1]) ph_zone[2][4][ph_init_hard[4][8] +: ph_hit_w10] |= ph_hit[4][8];

		// ph zone 3 stations 1234
		ph_zone[3][1] = 0;
		ph_zone[3][1][ph_init_hard[0][14]+: ph_hit_w10] |= ph_hit[5][2];
		ph_zone[3][1][ph_init_hard[0][6] +: ph_hit_w10] |= ph_hit[0][6];
		ph_zone[3][1][ph_init_hard[0][7] +: ph_hit_w10] |= ph_hit[0][7];
		ph_zone[3][1][ph_init_hard[0][8] +: ph_hit_w10] |= ph_hit[0][8];
		ph_zone[3][1][ph_init_hard[1][6] +: ph_hit_w10] |= ph_hit[1][6];
		ph_zone[3][1][ph_init_hard[1][7] +: ph_hit_w10] |= ph_hit[1][7];
		ph_zone[3][1][ph_init_hard[1][8] +: ph_hit_w10] |= ph_hit[1][8];

		ph_zone[3][2] = 0;                                 
		if (phzvl[5][4][1]) ph_zone[3][2][ph_init_hard[2][10]+: ph_hit_w10] |= ph_hit[5][4];
		if (phzvl[2][3][1]) ph_zone[3][2][ph_init_hard[2][3] +: ph_hit_w10] |= ph_hit[2][3];
		if (phzvl[2][4][1]) ph_zone[3][2][ph_init_hard[2][4] +: ph_hit_w10] |= ph_hit[2][4];
		if (phzvl[2][5][1]) ph_zone[3][2][ph_init_hard[2][5] +: ph_hit_w10] |= ph_hit[2][5];
		if (phzvl[2][6][1]) ph_zone[3][2][ph_init_hard[2][6] +: ph_hit_w10] |= ph_hit[2][6];
		if (phzvl[2][7][1]) ph_zone[3][2][ph_init_hard[2][7] +: ph_hit_w10] |= ph_hit[2][7];
		if (phzvl[2][8][1]) ph_zone[3][2][ph_init_hard[2][8] +: ph_hit_w10] |= ph_hit[2][8];
										                     
		ph_zone[3][3] = 0;				  			   		 			  
		if (phzvl[5][6][2]) ph_zone[3][3][ph_init_hard[3][10]+: ph_hit_w10] |= ph_hit[5][6];
		if (phzvl[3][3][2]) ph_zone[3][3][ph_init_hard[3][3] +: ph_hit_w10] |= ph_hit[3][3];
		if (phzvl[3][4][2]) ph_zone[3][3][ph_init_hard[3][4] +: ph_hit_w10] |= ph_hit[3][4];
		if (phzvl[3][5][2]) ph_zone[3][3][ph_init_hard[3][5] +: ph_hit_w10] |= ph_hit[3][5];
		if (phzvl[3][6][2]) ph_zone[3][3][ph_init_hard[3][6] +: ph_hit_w10] |= ph_hit[3][6];
		if (phzvl[3][7][2]) ph_zone[3][3][ph_init_hard[3][7] +: ph_hit_w10] |= ph_hit[3][7];
		if (phzvl[3][8][2]) ph_zone[3][3][ph_init_hard[3][8] +: ph_hit_w10] |= ph_hit[3][8];

		ph_zone[3][4] = 0; // no st 4 in this zone
	end                                                                                     
	

endmodule




















