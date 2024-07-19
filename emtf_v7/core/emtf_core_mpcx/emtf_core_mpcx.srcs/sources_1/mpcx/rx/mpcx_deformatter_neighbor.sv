`include "mpcx_interface.sv"
// deformatter for neighbor sector links
module mpcx_deformatter_neighbor
(
    input [75:0] rx_data_76 [8:0], // [link]
    
    output csc_lct_mpcx lct_o [8:0][1:0],
	output reg [25:0] stub_rate [8:0],
    input [25:0] hmt_rate_limit,
    output reg [8:0] hmt_rate_err = 0, // [chamber] hmt rate exceeded hmt_rate_limit

	output reg [8:0] crc_err,
	output reg [8:0] crc_err_flag,
	output reg [9:0] link_id [8:0],
	output reg [8:0] err_tst_pat,
	output reg [8:0] err_tst_pat_flag,
	input            flag_reset,
	input clk40
);

	reg [1:0] rsv;
	reg [1:0] crc [8:0];
    reg [8:0] lnk_val, hmt_val;
    reg [1:0] crc_rx [8:0];
//	(* async_reg = "TRUE" *) reg [75:0] rx_data_76_r [8:0];
	wire [75:0] rx_data_76_r [8:0];
	integer i, j;
	reg [3:0] dum4_1 [8:0];
	reg [3:0] dum4_2 [8:0];
	reg [18:0] cnt_19 [8:0];
	reg [1:0] lctvf [8:0];
	reg [25:0] rate_period = 0;
	reg [25:0] rate_counter [8:0] = '{0,0,0,0,0,0,0,0,0};
	reg [25:0] hmt_rate_counter [8:0] = '{0,0,0,0,0,0,0,0,0};

    localparam max_hs = 8'd159;
    localparam max_wg = 8'd111;

    assign rx_data_76_r = rx_data_76;

    // all links have identical format, except cscid=1, which we ignore here
    // cscid=1 data are unpacked into unused dum4 signals
    // and used only to determine that the data is valid and test pattern error should not be detected
  always @(posedge clk40)
  begin
    err_tst_pat = 9'b0;
    for (i = 0; i < 9; i=i+1)
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
        end
        cnt_19 [i]++;
    end    

    // persistent error flags for reporting via registers
    crc_err_flag |= crc_err;
    if (flag_reset) crc_err_flag = 9'h0;

    err_tst_pat_flag |= err_tst_pat;
    if (flag_reset) err_tst_pat_flag = 9'h0;

// the register is now in reclocker
//    rx_data_76_r = rx_data_76;

    for (i = 0; i < 9; i++) // chamber loop
    begin
    	// rate counter update
		if (lct_o[i][0].vf != 1'h0 && rate_counter[i] != 26'h3ffffff) 
		  rate_counter[i]++;
		if (hmt_val[i] != 1'h0 && hmt_rate_counter[i] != 26'h3ffffff) 
		  hmt_rate_counter[i]++;
	end

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

    reg [8:0] cscid1_bc0;
    reg [8:0] cscid1_vpf;

  always @(*)
  begin

    for (i = 0; i < 9; i++)
    begin
        {
            crc   [i][1],
            cscid1_bc0[i],
            dum4_1  [i],
        
            lct_o [i][1].cid ,
            lct_o [i][1].ser  ,
            lct_o [i][1].bx0   ,
            lct_o [i][1].bc0   ,
            lctvf [i][1]   ,
            lct_o [i][1].lr    ,
            lct_o [i][1].cp  ,
            lct_o [i][1].ql  ,
            lct_o [i][1].wg    ,
            lct_o [i][1].hs    ,
        
            crc   [i][0],
            cscid1_vpf[i],
            dum4_2  [i],
        
            lct_o [i][0].cid ,
            lct_o [i][0].ser  ,
            lct_o [i][0].bx0   ,
            lct_o [i][0].bc0   ,
            lctvf [i][0]   ,
            lct_o [i][0].lr    ,
            lct_o [i][0].cp  ,
            lct_o [i][0].ql  ,
            lct_o [i][0].wg    ,
            lct_o [i][0].hs    
        } = rx_data_76_r [i];
    
        lnk_val[i] = 
        (
            lctvf[i][1]  || 
            lctvf[i][0]  || 
            lct_o[i][0].bc0 || 
            cscid1_bc0[i] || 
            cscid1_vpf[i] || 
            lct_o[i][1].cp[3:1] != 3'b0 || 
            lct_o[i][1].bx0
        );
        // hmt valid is decoded independently from lct_o structure
        // so we can invalidate hmt in lct_o depending on rate error
        hmt_val[i] = 
        (
            rx_data_76_r[i][60:58] != 3'b0 || // lct_o[i][1].cp[3:1] != 3'b0 ||
            rx_data_76_r[i][64]               // lct_o[i][1].bx0
        );
        

        // calculate crc for each link
        // these are just parity bits for half the BX data
        crc_rx[i] = 2'b0;
    	for (j =  0; j <= 36; j=j+1) crc_rx[i][0] = crc_rx[i][0] ^ rx_data_76_r[i][j];
		for (j = 38; j <= 74; j=j+1) crc_rx[i][1] = crc_rx[i][1] ^ rx_data_76_r[i][j];
        
        // check CRC if link data is valid
        if (lnk_val[i] && crc_rx[i] != crc[i]) crc_err[i] = 1'b1;
        else crc_err[i] = 1'b0; 

		// disable link output if error was detected
		if (crc_err[i] == 1'b0)
		begin
		  lct_o[i][0].vf = lctvf[i][0]; 
		  lct_o[i][1].vf = lctvf[i][1];
		end 
		else
		begin
		  lct_o[i][0].vf = 1'b0; 
		  lct_o[i][1].vf = 1'b0;
		  
		  // invalidate HMT bits
		  lct_o[i][1].cp[3:1] = 3'b0;
		  lct_o[i][1].bx0 = 1'b0;
		end
		
		// disable HMT if rate is too high
		if (hmt_rate_err[i] == 1'b1)
		begin
		  // invalidate HMT bits
		  lct_o[i][1].cp[3:1] = 3'b0;
		  lct_o[i][1].bx0 = 1'b0;
		end

	end
  end

endmodule
