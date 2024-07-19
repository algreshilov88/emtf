`include "vppc_macros.sv"


module two_mu
(
   
	phi, th11i, thi, vli, me11ai, cpati,
    bt_rank_i,
    bt_vi, 
    bt_hi, 
    bt_ci, 
    bt_si,
    
    vl_stub,
    ph_stub,
    th_stub,
    cpat_stub,

    delay,
    en,

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

	
	// initial stubs
	input [bw_fph-1:0]  phi   [5:0][8:0][seg_ch-1:0];
	input [bw_th-1:0] 	th11i [2:0][2:0][th_ch11-1:0];
	input [bw_th-1:0] 	thi   [5:0][8:0][seg_ch-1:0];
	input [seg_ch-1:0] 	vli   [5:0][8:0];
	input [seg_ch-1:0] 	me11ai [2:0][2:0];
	input [3:0] 		cpati  [5:0][8:0][seg_ch-1:0];

    // best tracks
	// ranks [best_track_num]
	input [bwr:0] 		bt_rank_i [2:0];
	//[best_track_num][station 0-4]
	input [seg_ch-1:0] bt_vi [2:0][4:0]; // valid
	input [1:0] 		bt_hi [2:0][4:0]; // bx index
	input [3:0] 		bt_ci [2:0][4:0]; // chamber
	input [4:0]		bt_si [2:0]; // segment

    output reg vl_stub;
    output reg [bw_fph-1:0] ph_stub;
    output reg [bw_th-1:0]  th_stub;
    output reg [3:0] cpat_stub;

    input [3:0] delay;
    input en;
	input 				clk;
	
	wire [8:0] latency = {5'd0, delay};
	
	// outputs show not only delayed values, but also history of max_drift clocks
    reg [bw_fph-1:0] pho   [max_drift-1:0][5:0][8:0][seg_ch-1:0];
    reg [bw_th-1:0]     th11o [max_drift-1:0][2:0][2:0][th_ch11-1:0];
    reg [bw_th-1:0]     tho   [max_drift-1:0][5:0][8:0][seg_ch-1:0];
    reg [seg_ch-1:0] vlo   [max_drift-1:0][5:0][8:0];
    reg [seg_ch-1:0] me11ao [max_drift-1:0][2:0][2:0];
    reg [3:0]         cpato  [max_drift-1:0][5:0][8:0][seg_ch-1:0];
	
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
	
	// merge inputs
	`int i, j, k, d, bt;


	always @(*)
	begin
	    ph_stub = 0;
	    th_stub = 0;
	    vl_stub = 0;
	    cpat_stub = 0;
	    
        // check if any stubs match detected tracks		
	    // check only if this trigger is enabled AND one or two best tracks may be present (or not) 
	    if (en && bt_rank_i[2] == 0)
	    begin
    //		for (d = max_drift-1; d > 0; d = d-1) // history bx loop
            d = 0; // just check current BX for now
            begin
                for (i = 0; i < 2; i = i+1) // station loop, only taking ME1
                    for (j = 0; j < 3; j = j+1) // chamber loop, ME1/1 only
                        for (k = 1; k >= 0; k = k-1) // segment loop, backwards to give priority to best LCT
                        begin
                                if (
                                    vlo[d][i][j][k] == 1'b1 && // track stub valid
                                    (bt_rank_i[0] == 0 || (bt_vi [0][i][k] == 1'b0 || bt_ci[0][i][k] != j || bt_hi[0][i][k] != 2)) && // but this stub not used in track 0
                                    (bt_rank_i[1] == 0 || (bt_vi [1][i][k] == 1'b0 || bt_ci[1][i][k] != j || bt_hi[1][i][k] != 2))    // and this stub not used in track 1
                                )
                                begin
                                    // can report this stub now
                                    vl_stub = 1'b1;
                                    ph_stub = pho[d][i][j][0];
                                    cpat_stub = cpato[d][i][j][0];
//                                    if (i < 2 && j < 3)
                                        th_stub = th11o[d][i][j][0]; // ME1/1
//                                    else
//                                        th_stub = tho[d][i][j][0]; // all other chambers
                                end
                        end
             end 
         end                
    end


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
				    pho[0][i][j][k] = mem_ph_out[(i*9*seg_ch+j*seg_ch+k)*bw_fph +: bw_fph]; 
					tho[0][i][j][k] = mem_th_out[(i*9*seg_ch+j*seg_ch+k)*bw_th +: bw_th]; 
					vlo[0][i][j][k] = mem_vl_out[i*9*seg_ch+j*seg_ch+k]; 
				    cpato[0][i][j][k] = mem_cpat_out[(i*9*seg_ch+j*seg_ch+k)*4 +: 4]; 
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

