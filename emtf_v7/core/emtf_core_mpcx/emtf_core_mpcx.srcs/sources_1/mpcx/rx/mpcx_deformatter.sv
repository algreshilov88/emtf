`include "mpcx_interface.sv"

module mpcx_deformatter
(
    input [75:0] rx_data_76 [7:0], // [link]
    
    output csc_lct_mpcx lct_o [9:1][1:0],
	output reg [25:0] stub_rate [8:0],
    input [25:0] hmt_rate_limit,
    output reg [8:0] hmt_rate_err = 0, // [chamber] hmt rate exceeded hmt_rate_limit

	output reg [7:0] cid1_bc0, // separate bc0 markers from cid=1 coming in each link
	output reg [3:0] cid1_vf [1:0], // separate valid flags from cid=1 coming in each link [lct0,1][link]
	output reg [7:0] crc_err,
	output reg [7:0] crc_err_flag,
	output reg [9:0] link_id [7:0],
	(* async_reg = "TRUE" *) output reg [7:0] err_tst_pat,
	output reg [7:0] err_tst_pat_flag,
	input            flag_reset,
	input clk40
);

	reg [3:0] rsv;
	reg [1:0] crc [7:0];
    reg [7:0] lnk_val;
    reg [8:0] hmt_val;
    reg [1:0] crc_rx [7:0];
	integer i, j;
//	(* async_reg = "TRUE" *) reg [75:0] rx_data_76_r [7:0];
	wire [75:0] rx_data_76_r [7:0];
	reg [18:0] cnt_19 [7:0];
	reg [18:0] cnt_19_rx [7:0];
	reg [1:0] lctvf [9:2];
	reg [25:0] rate_period = 0;
	reg [25:0] rate_counter [8:0] = '{0,0,0,0,0,0,0,0,0};
	reg [25:0] hmt_rate_counter [8:0] = '{0,0,0,0,0,0,0,0,0};

    assign rx_data_76_r = rx_data_76;

    localparam max_hs = 8'd223; // ME1/1 (64 strips top + 48 strips bottom) * 2
    localparam max_wg = 8'd111; // ME2/1 112 wiregroups max

  always @(posedge clk40)
  begin

    err_tst_pat = 8'h0;
    for (i = 0; i < 8; i=i+1) // link loop
    begin
        if (!lnk_val[i]) // if data is not valid, read link ID and test pattern
        begin
             // packaging in TX
             // {19'h0, cnt, 28'h0, mpc_id, i[3:0]}
             // link ID is just MPC id and link number in lower bits
             link_id[i] = rx_data_76_r[i][9:0];
             
             // check and lock test counter
             if (cnt_19 [i] != rx_data_76_r[i][56:38]) err_tst_pat[i] = 1'b1; 
             cnt_19 [i] = rx_data_76_r[i][56:38];
             cnt_19_rx [i] = rx_data_76_r[i][56:38];
        end
        cnt_19 [i]++;
    end    
    
    // persistent error flags for reporting via registers
    crc_err_flag |= crc_err;
    if (flag_reset) crc_err_flag = 8'h0;

    err_tst_pat_flag |= err_tst_pat;
    if (flag_reset) err_tst_pat_flag = 8'h0;
    
    for (i = 1; i < 9; i++) // chamber loop for native chambers
    begin
        // rate counter update
        if (lct_o[i+1][0].vf != 1'h0 && rate_counter[i] != 26'h3ffffff) 
            rate_counter[i]++;
		if (hmt_val[i] != 1'h0 && hmt_rate_counter[i] != 26'h3ffffff) 
		  hmt_rate_counter[i]++;
    end

    // special case of CSCID=1 rate counter
    if (cid1_vf [0][0] != 1'h0 && rate_counter[0] != 26'h3ffffff) 
        rate_counter[0]++;
    if (hmt_val[0] != 1'h0 && hmt_rate_counter[0] != 26'h3ffffff) 
      hmt_rate_counter[0]++;
    

    if (rate_period == 26'd40078700) // 1 sec 
    begin
      // rate period expired, store and reset all counters
      for (i = 0; i < 9; i = i+1) // chamber loop
      begin
          stub_rate[i] = rate_counter[i]; 
          rate_counter[i] = 26'h0;
          // check hmt rate limit
          if (hmt_rate_counter[i] >= hmt_rate_limit) hmt_rate_err[i] = 1'b1;
          else hmt_rate_err[i] = 1'b0;
          hmt_rate_counter[i] = 26'h0;
      end
      rate_period = 26'h0;
    end
    else 
      rate_period++;

  end
    
  always @(*)
  begin
    {
        
        crc   [0][1],
        cid1_bc0 [0],
		lct_o[1][0].hs    [7:4],
	
		lct_o[2][1].cid ,
		lct_o[2][1].ser  ,
		lct_o[2][1].bx0   ,
		lct_o[2][1].bc0   ,
		lctvf[2][1]   ,
		lct_o[2][1].lr    ,
		lct_o[2][1].cp  ,
		lct_o[2][1].ql  ,
		lct_o[2][1].wg    ,
		lct_o[2][1].hs    ,
	
		crc   [0][0],
		cid1_vf [0][0],
		lct_o[1][0].hs    [3:0],
	
		lct_o[2][0].cid ,
		lct_o[2][0].ser  ,
		lct_o[2][0].bx0   ,
		lct_o[2][0].bc0   ,
		lctvf[2][0]   ,
		lct_o[2][0].lr    ,
		lct_o[2][0].cp  ,
		lct_o[2][0].ql  ,
		lct_o[2][0].wg    ,
		lct_o[2][0].hs    
	} = rx_data_76_r [0];

	{
	
		crc   [1][1],
		cid1_bc0 [1],
		lct_o[1][0].lr    ,
		lct_o[1][0].wg    [6:4],

		lct_o[3][1].cid ,
		lct_o[3][1].ser  ,
		lct_o[3][1].bx0   ,
		lct_o[3][1].bc0   ,
		lctvf[3][1]   ,
		lct_o[3][1].lr    ,
		lct_o[3][1].cp  ,
		lct_o[3][1].ql  ,
		lct_o[3][1].wg    ,
		lct_o[3][1].hs    ,
	
		crc   [1][0],
		cid1_vf [0][1],
		lct_o[1][0].wg    [3:0],

		lct_o[3][0].cid ,
		lct_o[3][0].ser  ,
		lct_o[3][0].bx0   ,
		lct_o[3][0].bc0   ,
		lctvf[3][0]   ,
		lct_o[3][0].lr    ,
		lct_o[3][0].cp  ,
		lct_o[3][0].ql  ,
		lct_o[3][0].wg    ,
		lct_o[3][0].hs    
	} = rx_data_76_r [1];

	{
	
		crc   [2][1],
		cid1_bc0 [2],
		lct_o[1][0].cp  ,

		lct_o[4][1].cid ,
		lct_o[4][1].ser  ,
		lct_o[4][1].bx0   ,
		lct_o[4][1].bc0   ,
		lctvf[4][1]   ,
		lct_o[4][1].lr    ,
		lct_o[4][1].cp  ,
		lct_o[4][1].ql  ,
		lct_o[4][1].wg    ,
		lct_o[4][1].hs    ,
	
		crc   [2][0],
		cid1_vf [0][2],
		lct_o[1][0].ql  ,

		lct_o[4][0].cid ,
		lct_o[4][0].ser  ,
		lct_o[4][0].bx0   ,
		lct_o[4][0].bc0   ,
		lctvf[4][0]   ,
		lct_o[4][0].lr    ,
		lct_o[4][0].cp  ,
		lct_o[4][0].ql  ,
		lct_o[4][0].wg    ,
		lct_o[4][0].hs    
	} = rx_data_76_r [2];

	{
	
		crc   [3][1],
		cid1_bc0 [3],
		lct_o[1][0].ser  ,
		lct_o[1][0].bx0   ,
		rsv   [0],
		rsv   [1],

		lct_o[5][1].cid ,
		lct_o[5][1].ser  ,
		lct_o[5][1].bx0   ,
		lct_o[5][1].bc0   ,
		lctvf[5][1]   ,
		lct_o[5][1].lr    ,
		lct_o[5][1].cp  ,
		lct_o[5][1].ql  ,
		lct_o[5][1].wg    ,
		lct_o[5][1].hs    ,
	
		crc   [3][0],
		cid1_vf [0][3],
		lct_o[1][0].cid ,

		lct_o[5][0].cid ,
		lct_o[5][0].ser  ,
		lct_o[5][0].bx0   ,
		lct_o[5][0].bc0   ,
		lctvf[5][0]   ,
		lct_o[5][0].lr    ,
		lct_o[5][0].cp  ,
		lct_o[5][0].ql  ,
		lct_o[5][0].wg    ,
		lct_o[5][0].hs    
	} = rx_data_76_r [3];

	{
	
		crc   [4][1],
		cid1_bc0 [4],
		lct_o[1][1].hs    [7:4],

		lct_o[6][1].cid ,
		lct_o[6][1].ser  ,
		lct_o[6][1].bx0   ,
		lct_o[6][1].bc0   ,
		lctvf[6][1]   ,
		lct_o[6][1].lr    ,
		lct_o[6][1].cp  ,
		lct_o[6][1].ql  ,
		lct_o[6][1].wg    ,
		lct_o[6][1].hs    ,
	
		crc   [4][0],
		cid1_vf [1][0],
		lct_o[1][1].hs    [3:0],
	
		lct_o[6][0].cid ,
		lct_o[6][0].ser  ,
		lct_o[6][0].bx0   ,
		lct_o[6][0].bc0   ,
		lctvf[6][0]   ,
		lct_o[6][0].lr    ,
		lct_o[6][0].cp  ,
		lct_o[6][0].ql  ,
		lct_o[6][0].wg    ,
		lct_o[6][0].hs    
	} = rx_data_76_r [4];

	{
		crc   [5][1],
		cid1_bc0 [5],
		lct_o[1][1].lr    ,
		lct_o[1][1].wg    [6:4],

		lct_o[7][1].cid ,
		lct_o[7][1].ser  ,
		lct_o[7][1].bx0   ,
		lct_o[7][1].bc0   ,
		lctvf[7][1]   ,
		lct_o[7][1].lr    ,
		lct_o[7][1].cp  ,
		lct_o[7][1].ql  ,
		lct_o[7][1].wg    ,
		lct_o[7][1].hs    ,
	
		crc   [5][0],
		cid1_vf [1][1],
		lct_o[1][1].wg    [3:0],

		lct_o[7][0].cid ,
		lct_o[7][0].ser  ,
		lct_o[7][0].bx0   ,
		lct_o[7][0].bc0   ,
		lctvf[7][0]   ,
		lct_o[7][0].lr    ,
		lct_o[7][0].cp  ,
		lct_o[7][0].ql  ,
		lct_o[7][0].wg    ,
		lct_o[7][0].hs    
	} = rx_data_76_r [5];

	{
	
		crc   [6][1],
		cid1_bc0 [6],
		lct_o[1][1].cp  ,

		lct_o[8][1].cid ,
		lct_o[8][1].ser  ,
		lct_o[8][1].bx0   ,
		lct_o[8][1].bc0   ,
		lctvf[8][1]   ,
		lct_o[8][1].lr    ,
		lct_o[8][1].cp  ,
		lct_o[8][1].ql  ,
		lct_o[8][1].wg    ,
		lct_o[8][1].hs    ,
	
		crc   [6][0],
		cid1_vf [1][2],
		lct_o[1][1].ql  ,

		lct_o[8][0].cid ,
		lct_o[8][0].ser  ,
		lct_o[8][0].bx0   ,
		lct_o[8][0].bc0   ,
		lctvf[8][0]   ,
		lct_o[8][0].lr    ,
		lct_o[8][0].cp  ,
		lct_o[8][0].ql  ,
		lct_o[8][0].wg    ,
		lct_o[8][0].hs    
	} = rx_data_76_r [6];

	{
	
		crc   [7][1],
		cid1_bc0 [7],
		lct_o[1][1].ser  ,
		lct_o[1][1].bx0   ,
		rsv   [2],
		rsv   [3],

		lct_o[9][1].cid ,
		lct_o[9][1].ser  ,
		lct_o[9][1].bx0   ,
		lct_o[9][1].bc0   ,
		lctvf[9][1]   ,
		lct_o[9][1].lr    ,
		lct_o[9][1].cp  ,
		lct_o[9][1].ql  ,
		lct_o[9][1].wg    ,
		lct_o[9][1].hs    ,
	
		crc   [7][0],
		cid1_vf [1][3],
		lct_o[1][1].cid ,

		lct_o[9][0].cid ,
		lct_o[9][0].ser  ,
		lct_o[9][0].bx0   ,
		lct_o[9][0].bc0   ,
		lctvf[9][0]   ,
		lct_o[9][0].lr    ,
		lct_o[9][0].cp  ,
		lct_o[9][0].ql  ,
		lct_o[9][0].wg    ,
		lct_o[9][0].hs    
	} = rx_data_76_r [7];

    // link data valid if: one of the LCTs from native chamber valid, 
    // or fragment of CSCID=1 chamber is valid,
    // or BC0 signal is present from native chamber or CSCID=1 
    // or HMT bits are non-zero from native or CSCID=1
	lnk_val[0] = (lctvf[2][1] || lctvf[2][0] || cid1_vf[0][0] || lct_o[2][0].bc0 || cid1_bc0 [0] || lct_o[2][1].cp[3:1] != 3'b0 || lct_o[2][1].bx0);
	lnk_val[1] = (lctvf[3][1] || lctvf[3][0] || cid1_vf[0][1] || lct_o[3][0].bc0 || cid1_bc0 [1] || lct_o[3][1].cp[3:1] != 3'b0 || lct_o[3][1].bx0);
	lnk_val[2] = (lctvf[4][1] || lctvf[4][0] || cid1_vf[0][2] || lct_o[4][0].bc0 || cid1_bc0 [2] || lct_o[4][1].cp[3:1] != 3'b0 || lct_o[4][1].bx0);
	lnk_val[3] = (lctvf[5][1] || lctvf[5][0] || cid1_vf[0][3] || lct_o[5][0].bc0 || cid1_bc0 [3] || lct_o[5][1].cp[3:1] != 3'b0 || lct_o[5][1].bx0);
	lnk_val[4] = (lctvf[6][1] || lctvf[6][0] || cid1_vf[1][0] || lct_o[6][0].bc0 || cid1_bc0 [4] || lct_o[6][1].cp[3:1] != 3'b0 || lct_o[6][1].bx0);
	lnk_val[5] = (lctvf[7][1] || lctvf[7][0] || cid1_vf[1][1] || lct_o[7][0].bc0 || cid1_bc0 [5] || lct_o[7][1].cp[3:1] != 3'b0 || lct_o[7][1].bx0);
	lnk_val[6] = (lctvf[8][1] || lctvf[8][0] || cid1_vf[1][2] || lct_o[8][0].bc0 || cid1_bc0 [6] || lct_o[8][1].cp[3:1] != 3'b0 || lct_o[8][1].bx0 || lct_o[1][1].cp[3:1] != 3'b0); // cp[3:1] are HMT[3:1]
	lnk_val[7] = (lctvf[9][1] || lctvf[9][0] || cid1_vf[1][3] || lct_o[9][0].bc0 || cid1_bc0 [7] || lct_o[9][1].cp[3:1] != 3'b0 || lct_o[9][1].bx0 || lct_o[1][1].bx0); // BX0 is HMT[0]


    for (i = 0; i < 9; i=i+1) // chamber loop, 0 --> CSCID=1
    begin
        // hmt valid is decoded independently from lct_o structure
        // so we can invalidate hmt in lct_o depending on rate error
        if (i > 0) // native chambers
            hmt_val[i] = 
            (
                rx_data_76_r[i-1][60:58] != 3'b0 || // lct_o[i+1][1].cp[3:1] != 3'b0 ||
                rx_data_76_r[i-1][64]               // lct_o[i+1][1].bx0
            );
        else // i == 0 --> CSCID=1
            hmt_val[i] = 
            (
                rx_data_76_r[6][73:71] != 3'b0 || // lct_o[i+1][1].cp[3:1] != 3'b0 ||
                rx_data_76_r[7][72]               // lct_o[i+1][1].bx0
            );
            
		// disable HMT if rate is too high
		if (hmt_rate_err[i] == 1'b1)
		begin
		  // invalidate HMT bits
		  lct_o[i+1][1].cp[3:1] = 3'b0;
		  lct_o[i+1][1].bx0 = 1'b0;
		end
    end

    for (i = 0; i < 8; i=i+1)
    begin
        // calculate crc for each link
        // these are just parity bits for chunks of 37 bits
        crc_rx[i] = 2'b0;
    	for (j =  0; j <= 36; j=j+1) crc_rx[i][0] = crc_rx[i][0] ^ rx_data_76_r[i][j];
		for (j = 38; j <= 74; j=j+1) crc_rx[i][1] = crc_rx[i][1] ^ rx_data_76_r[i][j];
        
        // check CRC if link data is valid
        if (lnk_val[i] && crc_rx[i] != crc[i]) crc_err[i] = 1'b1;
        else crc_err[i] = 1'b0; 

		// disable link output if error was detected
		if (crc_err[i] == 1'b0)
		begin
		  lct_o[i+2][0].vf = lctvf[i+2][0]; 
		  lct_o[i+2][1].vf = lctvf[i+2][1];
		end 
		else
		begin
		  lct_o[i+2][0].vf = 1'b0; 
		  lct_o[i+2][1].vf = 1'b0;
		  
          // invalidate cscid=1 fragment if this link had crc error
		  cid1_vf[i/4][i%4] = 1'b0;
		  
		  // invalidate HMT bits
		  lct_o[i+2][1].cp[3:1] = 3'b0;
		  lct_o[i+2][1].bx0 = 1'b0;
		end
    end
    
    // invalidate HMT bits for cscid=1 in case of crc errors
    if (crc_err[6] == 1'b1) lct_o[1][1].cp[3:1] = 3'b0;
    if (crc_err[7] == 1'b1) lct_o[1][1].bx0 = 1'b0;
    
    // unused bits in CSCID=1 structure. Actual valid bits and bc0 
    // sent out in separate signals: cid1_bc0 and cid1_vf
    lct_o[1][0].vf  = 0;
    lct_o[1][0].bc0 = 0;
    lct_o[1][1].vf  = 0;
    lct_o[1][1].bc0 = 0;
    
  end

endmodule
