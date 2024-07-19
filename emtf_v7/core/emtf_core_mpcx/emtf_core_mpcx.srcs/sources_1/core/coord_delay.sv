
//////////////////////////////////////////////////////////////////////////////////
// Company: UF
// Engineer: Madorsky
// 
// Create Date:    01:36:08 03/19/2010 
// Design Name: tf_slch
// Module Name:    coord_delay
// Project Name: tf_slch
// Target Devices: V6
// Tool versions: 11.4
// Description: delay line for segment coordinates
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
`include "vppc_macros.sv"


module coord_delay 
(
	phi, th11i, thi, vli, me11ai, cpati,
	ge11_ph, ge11_th, ge11_vl, use_gem,
	cppf_rxd, cppf_rx_valid,
	use_rpc,
	pho, th11o, tho, vlo_o, me11ao, cpato,
	clk
);
`include "spbits.sv"
	// width of combined memory data
	`localpar mem_ph_bw    = bw_fph*6*9*seg_ch;
	`localpar mem_th_bw    = bw_th*6*9*seg_ch; 
	`localpar mem_th11_bw  = bw_th*3*3*th_ch11; 
	`localpar mem_vl_bw    = 6*9*seg_ch;
	`localpar mem_me11a_bw = 3*3*seg_ch;
	`localpar mem_cpat_bw  = 4*6*9*seg_ch;

	// pulse length
	`param pulse_l = 3;
	`param latency = 4; // check core latency in DAQ
	
	input [bw_fph-1:0]  phi   [5:0][8:0][seg_ch-1:0];
	input [bw_th-1:0] 	th11i [2:0][2:0][th_ch11-1:0];
	input [bw_th-1:0] 	thi   [5:0][8:0][seg_ch-1:0];
	input [seg_ch-1:0] 	vli   [5:0][8:0];
	input [seg_ch-1:0] 	me11ai [2:0][2:0];
	input [3:0] 		cpati  [5:0][8:0][seg_ch-1:0];

    // GE11 data [schamber][layer][cluster]
  	input [bw_fph-1:0] ge11_ph [6:0][1:0][7:0]; 
	input [bw_th-1:0]  ge11_th [6:0][1:0][7:0];
	input [7:0]        ge11_vl [6:0][1:0];
	input use_gem;

  // CPPF data          [subsect][frame][stub*4]
    input [63:0] cppf_rxd [6:0][2:0]; // cppf rx data, 3 frames x 64 bit, for 7 links
    input [6:0] cppf_rx_valid; // cppf rx data valid flags
    input use_rpc; // enables using RPC data in track finding

	// outputs show not only delayed values, but also history of max_drift clocks
	output reg [bw_fph-1:0] pho   [max_drift-1:0][5:0][8:0][seg_ch-1:0];
	output reg [bw_th-1:0] 	th11o [max_drift-1:0][2:0][2:0][th_ch11-1:0];
	output reg [bw_th-1:0] 	tho   [max_drift-1:0][5:0][8:0][seg_ch-1:0];
	output     [seg_ch-1:0] vlo_o   [max_drift-1:0][5:0][8:0];
	output reg [seg_ch-1:0] me11ao [max_drift-1:0][2:0][2:0];
	output reg [3:0] 		cpato  [max_drift-1:0][5:0][8:0][seg_ch-1:0];

	input 				clk;

	reg [bw_fph-1:0] pho_csc   [5:0][8:0][seg_ch-1:0];
	reg [bw_th-1:0]  tho_csc   [5:0][8:0][seg_ch-1:0];
	reg [seg_ch-1:0] vlo_csc   [5:0][8:0];
	reg [3:0] 		 cpato_csc [5:0][8:0][seg_ch-1:0];
	
	reg [bw_fph-1:0] pho_rpc   [5:0][8:0][seg_ch-1:0];
    reg [bw_th-1:0]  tho_rpc   [5:0][8:0][seg_ch-1:0];
    reg [seg_ch-1:0] vlo_rpc   [5:0][8:0];
    reg [3:0]        cpato_rpc [5:0][8:0][seg_ch-1:0];
    
	reg [seg_ch-1:0] vlo   [max_drift-1:0][5:0][8:0];

      assign vlo_o[2:1] = vlo[2:1];
      // zero out first BX in history, only analyze two remaining BXs
      assign vlo_o[0] = '{
                          {0,0,0,0,0,0,0,0,0},
                          {0,0,0,0,0,0,0,0,0},
                          {0,0,0,0,0,0,0,0,0},
                          {0,0,0,0,0,0,0,0,0},
                          {0,0,0,0,0,0,0,0,0},
                          {0,0,0,0,0,0,0,0,0}
                          };
	
	// combined signals with all values merged
	reg  [mem_ph_bw-1:0] mem_ph_in;
	reg  [mem_ph_bw-1:0] mem_ph_out;
	
	reg  [mem_th_bw-1:0] mem_th_in;
	reg  [mem_th_bw-1:0] mem_th_out;

	reg  [mem_th11_bw-1:0] mem_th11_in;
	reg  [mem_th11_bw-1:0] mem_th11_out;

	reg  [mem_vl_bw-1:0] mem_vl_in;
	reg  [mem_vl_bw-1:0] mem_vl_out;

	reg  [mem_me11a_bw-1:0] mem_me11a_in;
	reg  [mem_me11a_bw-1:0] mem_me11a_out;

	reg  [mem_cpat_bw-1:0] mem_cpat_in;
	reg  [mem_cpat_bw-1:0] mem_cpat_out;
	// BRAM
	reg [mem_ph_bw-1:0]    mem_ph [511:0];
	reg [mem_th_bw-1:0]    mem_th [511:0];
	reg [mem_th11_bw-1:0]  mem_th11 [511:0];
	reg [mem_vl_bw-1:0]    mem_vl [511:0];
	reg [mem_me11a_bw-1:0] mem_me11a [511:0];
	reg [mem_cpat_bw-1:0]  mem_cpat [511:0];
	// read address
	reg [8:0] 		  ra = 0;
	// write address
	reg [8:0] 		  wa = latency;
	
	// split RPC data into chambers/stubs
	//            [subsect][chamber][stub]
	// RPC chamber index: 0=12 1=22 2=32 3=33 4=42 5=43
	reg [bw_fph-1:0] rpc_ph [6:0][5:0][seg_ch-1:0]; 
    reg [bw_th-1:0]  rpc_th [6:0][5:0][seg_ch-1:0]; 
	reg [seg_ch-1:0] rpc_vl [6:0][5:0]; 
	reg [15:0] rxd_temp;
	
	// correspondence between RPC subsector and chamber and CSC chambers
	// indexes: [ME station][CSCID]
	integer rpc_subsect[5:0][8:0]; // RPC subsector 
	integer rpc_ch[5:0][8:0]; // RPC chamber
	
    // fill the arrays. Contents comes from CSC-to-RPC-positional-mapping.xlsx
    // value of 7 means invalid subsector and/or chamber
    // chamber 2 means actually 2 or 3
    // chamber 4 means actually 4 or 5
    // updated according to what Andrew B. found experimentally, see message from 2017-05-03
    assign rpc_subsect[0][0] = 7;	 assign rpc_ch[0][0] = 7;
    assign rpc_subsect[0][1] = 7;    assign rpc_ch[0][1] = 7;
    assign rpc_subsect[0][2] = 7;    assign rpc_ch[0][2] = 7;
    assign rpc_subsect[0][3] = 1;    assign rpc_ch[0][3] = 0;
    assign rpc_subsect[0][4] = 2;    assign rpc_ch[0][4] = 0;
    assign rpc_subsect[0][5] = 3;    assign rpc_ch[0][5] = 0;
    assign rpc_subsect[0][6] = 7;    assign rpc_ch[0][6] = 7;
    assign rpc_subsect[0][7] = 7;    assign rpc_ch[0][7] = 7;
    assign rpc_subsect[0][8] = 7;    assign rpc_ch[0][8] = 7;
    assign rpc_subsect[1][0] = 7;    assign rpc_ch[1][0] = 7;
    assign rpc_subsect[1][1] = 7;    assign rpc_ch[1][1] = 7;
    assign rpc_subsect[1][2] = 7;    assign rpc_ch[1][2] = 7;
    assign rpc_subsect[1][3] = 4;    assign rpc_ch[1][3] = 0;
    assign rpc_subsect[1][4] = 5;    assign rpc_ch[1][4] = 0;
    assign rpc_subsect[1][5] = 6;    assign rpc_ch[1][5] = 0;
    assign rpc_subsect[1][6] = 7;    assign rpc_ch[1][6] = 7;
    assign rpc_subsect[1][7] = 7;    assign rpc_ch[1][7] = 7;
    assign rpc_subsect[1][8] = 7;    assign rpc_ch[1][8] = 7;
    assign rpc_subsect[2][0] = 7;    assign rpc_ch[2][0] = 7;
    assign rpc_subsect[2][1] = 7;    assign rpc_ch[2][1] = 7;
    assign rpc_subsect[2][2] = 7;    assign rpc_ch[2][2] = 7;
    assign rpc_subsect[2][3] = 1;    assign rpc_ch[2][3] = 1;
    assign rpc_subsect[2][4] = 2;    assign rpc_ch[2][4] = 1;
    assign rpc_subsect[2][5] = 3;    assign rpc_ch[2][5] = 1;
    assign rpc_subsect[2][6] = 4;    assign rpc_ch[2][6] = 1;
    assign rpc_subsect[2][7] = 5;    assign rpc_ch[2][7] = 1;
    assign rpc_subsect[2][8] = 6;    assign rpc_ch[2][8] = 1;
    assign rpc_subsect[3][0] = 7;    assign rpc_ch[3][0] = 7;
    assign rpc_subsect[3][1] = 7;    assign rpc_ch[3][1] = 7;
    assign rpc_subsect[3][2] = 7;    assign rpc_ch[3][2] = 7;
    assign rpc_subsect[3][3] = 1;    assign rpc_ch[3][3] = 2;
    assign rpc_subsect[3][4] = 2;    assign rpc_ch[3][4] = 2;
    assign rpc_subsect[3][5] = 3;    assign rpc_ch[3][5] = 2;
    assign rpc_subsect[3][6] = 4;    assign rpc_ch[3][6] = 2;
    assign rpc_subsect[3][7] = 5;    assign rpc_ch[3][7] = 2;
    assign rpc_subsect[3][8] = 6;    assign rpc_ch[3][8] = 2;
    assign rpc_subsect[4][0] = 7;    assign rpc_ch[4][0] = 7;
    assign rpc_subsect[4][1] = 7;    assign rpc_ch[4][1] = 7;
    assign rpc_subsect[4][2] = 7;    assign rpc_ch[4][2] = 7;
    assign rpc_subsect[4][3] = 1;    assign rpc_ch[4][3] = 4;
    assign rpc_subsect[4][4] = 2;    assign rpc_ch[4][4] = 4;
    assign rpc_subsect[4][5] = 3;    assign rpc_ch[4][5] = 4;
    assign rpc_subsect[4][6] = 4;    assign rpc_ch[4][6] = 4;
    assign rpc_subsect[4][7] = 5;    assign rpc_ch[4][7] = 4;
    assign rpc_subsect[4][8] = 6;    assign rpc_ch[4][8] = 4;
    assign rpc_subsect[5][0] = 7;    assign rpc_ch[5][0] = 7;
    assign rpc_subsect[5][1] = 0;    assign rpc_ch[5][1] = 0;
    assign rpc_subsect[5][2] = 7;    assign rpc_ch[5][2] = 7;
    assign rpc_subsect[5][3] = 7;    assign rpc_ch[5][3] = 7;
    assign rpc_subsect[5][4] = 0;    assign rpc_ch[5][4] = 1;
    assign rpc_subsect[5][5] = 7;    assign rpc_ch[5][5] = 7;
    assign rpc_subsect[5][6] = 0;    assign rpc_ch[5][6] = 2;
    assign rpc_subsect[5][7] = 7;    assign rpc_ch[5][7] = 7;
    assign rpc_subsect[5][8] = 0;    assign rpc_ch[5][8] = 4;    

	// correspondence between GE11 chamber and CSC chambers
	// indexes: [ME station][CSCID]
	integer ge11_ch     [5:0][2:0]; // GE11 chamber
	
	assign ge11_ch[0][0] = 0;	   
	assign ge11_ch[0][1] = 1;	   
	assign ge11_ch[0][2] = 2;	   
	assign ge11_ch[1][0] = 3;	   
	assign ge11_ch[1][1] = 4;	   
	assign ge11_ch[1][2] = 5;	   
	assign ge11_ch[5][0] = 6;	   


    integer rpc_sub, rpc_chm, ge11_chm;
  	`int i, j, k, d, f, s;
  
    // process RPC data in the same BX as they appear from CPPF RX
    always @(*)
    begin
	    // RPC data splitting
		for (i = 0; i < 7; i = i+1) // subsector (link) loop
            for (j = 0; j < 6; j = j+1) // chamber loop
                for (k = 0; k < seg_ch; k = k+1) // stub loop
                begin
                    f = j/2; // frame
                    s = ((j%2)*2+k); // stub
                    rxd_temp = cppf_rxd[i][f][s*16 +: 16];
                    rpc_ph[i][j][k] = {rxd_temp[10:0], 2'b0};  // upgrade to full CSC precision by adding 2 zeros
                    rpc_th[i][j][k] = {rxd_temp[15:11], 2'b0}; // upgrade to full CSC precision by adding 2 zeros
                    // RPC hit valid when data is not all ones and link is not in trailer
                    rpc_vl[i][j][k] = (rxd_temp[15:11] != 5'b11111 && cppf_rx_valid[i] == 1'b1) ? 1'b1 : 1'b0; 
                end
                
        for (i = 0; i < 6; i = i+1) // station loop
        begin
            for (j = 0; j < 9; j = j+1) // chamber loop
            begin
                pho[0][i][j][0] =   0;
                tho[0][i][j][0] =   0; 
                vlo[0][i][j][0] =   0; 
                cpato[0][i][j][0] = 0;
                
                pho[0][i][j][1] =   0;
                tho[0][i][j][1] =   0; 
                vlo[0][i][j][1] =   0; 
                cpato[0][i][j][1] = 0;

                
                if (vlo_csc[i][j] != 2'b0) // any CSC hit is present
                begin
                    // put updated stubs/hits into first element of history line
                    pho[0][i][j][0] =   pho_csc[i][j][0];
                    tho[0][i][j][0] =   tho_csc[i][j][0]; 
                    vlo[0][i][j][0] =   vlo_csc[i][j][0]; 
                    cpato[0][i][j][0] = cpato_csc[i][j][0];
                    
                    pho[0][i][j][1] =   pho_csc[i][j][1];
                    tho[0][i][j][1] =   tho_csc[i][j][1]; 
                    vlo[0][i][j][1] =   vlo_csc[i][j][1]; 
                    cpato[0][i][j][1] = cpato_csc[i][j][1];
                end
                else
                begin
                    if (((i <= 1 && j <= 2) || // ME11 only, can be replaced with GE11
                        (i == 5 && j == 0)) && use_gem) // ME11 in neighbor sector
                    begin
                        ge11_chm = ge11_ch[i][j]; // extract GE11 chamber number, 0..6
                        
                        for (k = 0; k < 2; k++) // cluster/LCT loop 
                        begin
                            // check if GE11 clusters are present
                            // layer 0
                            if (ge11_vl[ge11_chm][0][k*4] == 1'b1) // check only clusters 0 and 4 since they are filled first
                            begin
                                // finally, assign GE11 clusters to CSC stubs, mark them using CLCT pattern = 0
                                pho  [0][i][j][k] = ge11_ph[ge11_chm][0][k*4];
                                tho  [0][i][j][k] = ge11_th[ge11_chm][0][k*4];
                                vlo  [0][i][j][k] = ge11_vl[ge11_chm][0][k*4];
                                cpato[0][i][j][k] = 4'h0; // this marks GE11 stub, same as RPC stubs. Distinguishing between RPC and GE11 is done using station/chamber 
                            end
                            // layer 1
                            else if (ge11_vl[ge11_chm][1][k*4] == 1'b1) // check only clusters 0 and 4 since they are filled first
                            begin
                                // finally, assign GE11 clusters to CSC stubs, mark them using CLCT pattern = 0
                                pho  [0][i][j][k] = ge11_ph[ge11_chm][1][k*4];
                                tho  [0][i][j][k] = ge11_th[ge11_chm][1][k*4];
                                vlo  [0][i][j][k] = ge11_vl[ge11_chm][1][k*4];
                                cpato[0][i][j][k] = 4'h0; // this marks GE11 stub, same as RPC stubs. Distinguishing between RPC and GE11 is done using station/chamber 
                            end
                        end
                    end
                    else
                    begin
                        // get RPC chamber corresponding to this CSC
                        rpc_sub = rpc_subsect[i][j];
                        rpc_chm = rpc_ch[i][j];
                    
                        // slip RPC hits if CSC does not have stubs
                        if (rpc_sub < 7 && rpc_chm < 7 && use_rpc) // subsector and chamber are valid, and using RPC is enabled
                        begin
                            if (rpc_chm == 2 || rpc_chm == 4) // special case of RE34/2 and RE34/3 chambers
                            begin
                                // if RE34/2 does not have a hit, check RE34/3
                                // check both hits here
                                if (rpc_vl[rpc_sub][rpc_chm][0] == 1'b0 &&
                                    rpc_vl[rpc_sub][rpc_chm][1] == 1'b0) rpc_chm = rpc_chm + 1; 
                            end
                        
                            for (k = 0; k < 2; k++) // RPC hit loop
                            begin
                                // check if RPC hits are present
                                if (rpc_vl[rpc_sub][rpc_chm][k] == 1'b1)
                                begin
                                    // finally, assign RPC hits to CSC stubs, mark them using CLCT pattern = 0
                                    pho  [0][i][j][k] = rpc_ph[rpc_sub][rpc_chm][k];
                                    tho  [0][i][j][k] = rpc_th[rpc_sub][rpc_chm][k];
                                    vlo  [0][i][j][k] = rpc_vl[rpc_sub][rpc_chm][k];
                                    cpato[0][i][j][k] = 4'h0; // this marks RPC stub
                                end
                            end
                        end
                    end 
                end
            end 
        end

	end	

	// merge inputs
	always @(posedge clk)
	begin
		
		
		// merge inputs
		for (i = 0; i < 6; i = i+1) // station loop
			for (j = 0; j < 9; j = j+1) // chamber loop
				for (k = 0; k < seg_ch; k = k+1) // segment loop
				begin
				    mem_ph_in[(i*9*seg_ch+j*seg_ch+k)*bw_fph +: bw_fph] = phi[i][j][k]; 
					mem_th_in[(i*9*seg_ch+j*seg_ch+k)*bw_th +: bw_th] = thi[i][j][k]; 
					mem_vl_in[i*9*seg_ch+j*seg_ch+k] = vli[i][j][k]; 
				    mem_cpat_in[(i*9*seg_ch+j*seg_ch+k)*4 +: 4] = cpati[i][j][k]; 
				end
		// ME1/1 merge inputs
		for (i = 0; i < 3; i = i+1) // station loop
			for (j = 0; j < 3; j = j+1) // chamber loop
			begin
				for (k = 0; k < th_ch11; k = k+1) // segment loop
				begin
					mem_th11_in[(i*3*th_ch11+j*th_ch11+k)*bw_th +: bw_th] = th11i[i][j][k];
					if (k < 2) mem_me11a_in[i*3*seg_ch+j*seg_ch+k] = me11ai[i][j][k]; 
				end
			end

		// read the outputs
		mem_ph_out   = mem_ph  [ra];
		mem_th_out   = mem_th  [ra];
		mem_th11_out = mem_th11[ra];
		mem_vl_out   = mem_vl  [ra];
		mem_me11a_out= mem_me11a  [ra];
		mem_cpat_out = mem_cpat   [ra];
		
		// write all input bits into memory on each clock
		mem_ph  [wa] = mem_ph_in;
		mem_th  [wa] = mem_th_in;
		mem_th11[wa] = mem_th11_in;
		mem_vl  [wa] = mem_vl_in;
		mem_me11a [wa] = mem_me11a_in;
		mem_cpat  [wa] = mem_cpat_in;

		wa = (ra + latency + 1);
		ra = (ra + 1);
		
		// shift history
		for (d = max_drift-1; d > 0; d = d-1) // history bx loop
		begin
			for (i = 0; i < 6; i = i+1) // station loop
				for (j = 0; j < 9; j = j+1) // chamber loop
					for (k = 0; k < seg_ch; k = k+1) // segment loop
					begin
						pho[d][i][j][k] = pho[d-1][i][j][k]; 
						tho[d][i][j][k] = tho[d-1][i][j][k]; 
						vlo[d][i][j][k] = vlo[d-1][i][j][k];
						cpato[d][i][j][k] = cpato[d-1][i][j][k]; 
					end                 

			for (i = 0; i < 3; i = i+1) // station loop
				for (j = 0; j < 3; j = j+1) // chamber loop
					for (k = 0; k < th_ch11; k = k+1) // segment loop
					begin
						th11o[d][i][j][k] = th11o[d-1][i][j][k];
						if (k < 2) me11ao[d][i][j][k] = me11ao[d-1][i][j][k];
					end
		end
		
		
		// split memory outputs into word[0] of the coordinate history 
		for (i = 0; i < 6; i = i+1) // station loop
			for (j = 0; j < 9; j = j+1) // chamber loop
				for (k = 0; k < seg_ch; k = k+1) // segment loop
				begin
				    pho_csc[i][j][k] = mem_ph_out[(i*9*seg_ch+j*seg_ch+k)*bw_fph +: bw_fph]; 
					tho_csc[i][j][k] = mem_th_out[(i*9*seg_ch+j*seg_ch+k)*bw_th +: bw_th]; 
					vlo_csc[i][j][k] = mem_vl_out[i*9*seg_ch+j*seg_ch+k]; 
				    cpato_csc[i][j][k] = mem_cpat_out[(i*9*seg_ch+j*seg_ch+k)*4 +: 4];
 				end
 
		// split outputs
		for (i = 0; i < 3; i = i+1) // station loop
			for (j = 0; j < 3; j = j+1) // chamber loop
				for (k = 0; k < th_ch11; k = k+1) // segment loop
				begin
					th11o[0][i][j][k] = mem_th11_out[(i*3*th_ch11+j*th_ch11+k)*bw_th +: bw_th];
					if (k < 2) me11ao[0][i][j][k] = mem_me11a_out[i*3*seg_ch+j*seg_ch+k]; 
				end
	end

endmodule
