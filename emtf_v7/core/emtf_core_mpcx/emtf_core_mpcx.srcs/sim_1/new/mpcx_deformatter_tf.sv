`timescale 1ns / 1ps


module mpcx_deformatter_tf;


    reg [75:0] rx_data_76 [7:0]; // [link]
    
    csc_lct_mpcx lct_o [9:1][1:0];
	wire [25:0] stub_rate [8:0];
    reg  [25:0] hmt_rate_limit = 26'd1000;
    wire [8:0] hmt_rate_err; // [chamber] hmt rate exceeded hmt_rate_limit

	wire [7:0] cid1_bc0; // separate bc0 markers from cid=1 coming in each link
	wire [3:0] cid1_vf [1:0]; // separate valid flags from cid=1 coming in each link [lct0;1][link]
	wire [7:0] crc_err;
	wire [7:0] crc_err_flag;
	wire [9:0] link_id [7:0];
	wire [7:0] err_tst_pat;
	wire [7:0] err_tst_pat_flag;
	reg            flag_reset = 0;
	reg clk40;


    mpcx_deformatter uut
    (
        .rx_data_76          (rx_data_76),
        .lct_o               (lct_o),
        .stub_rate           (stub_rate),
        .hmt_rate_limit      (hmt_rate_limit),
        .hmt_rate_err        (hmt_rate_err  ), // hmt rate exceeded hmt_rate_limit
    
        .cid1_bc0            (cid1_bc0), // separate bc0 markers from CSCID=1 coming in each link
        .cid1_vf             (cid1_vf),
        .crc_err             (crc_err   ),
        .crc_err_flag        (crc_err_flag),
        .link_id             (link_id   ),
        .err_tst_pat         (err_tst_pat),
        .err_tst_pat_flag    (err_tst_pat_flag),
        .flag_reset          (flag_reset),
        .clk40               (clk40)
    );
    
    integer i;
    initial
    begin
    
        for (i = 0; i < 100000000; i++)
        begin
            #12;
            clk40 = 0;
            #12;
            
            rx_data_76 = '{0,0,0,0,0,0,0,0};

            if ((i > 10000000 && i < 10000000+1001) || (i > 41000000 && i < 41000000+900))
            begin
                rx_data_76[0][64] = 1; // hmt[0]
                rx_data_76[0][58] = 0; // hmt[1]
                rx_data_76[0][59] = 0; // hmt[2]
                rx_data_76[0][60] = 0; // hmt[3]
                rx_data_76[0][75] = 1; // crc[1]
            end
            
            if (i > 15000000 && i < 15000000+1001)
            begin
                rx_data_76[1][64] = 0; // hmt[0]
                rx_data_76[1][58] = 1; // hmt[1]
                rx_data_76[1][59] = 0; // hmt[2]
                rx_data_76[1][60] = 0; // hmt[3]
                rx_data_76[1][75] = 1; // crc[1]
            end

            if (i > 20000000 && i < 20000000+1001)
            begin
                rx_data_76[2][64] = 0; // hmt[0]
                rx_data_76[2][58] = 0; // hmt[1]
                rx_data_76[2][59] = 1; // hmt[2]
                rx_data_76[2][60] = 0; // hmt[3]
                rx_data_76[2][75] = 1; // crc[1]
            end

            if (i > 25000000 && i < 25000000+1001)
            begin
                rx_data_76[3][64] = 0; // hmt[0]
                rx_data_76[3][58] = 0; // hmt[1]
                rx_data_76[3][59] = 0; // hmt[2]
                rx_data_76[3][60] = 1; // hmt[3]
                rx_data_76[3][75] = 1; // crc[1]
            end
          
            if (i > 30000000 && i < 30000000+1001)
            begin
                rx_data_76[4][64] = 1; // hmt[0]
                rx_data_76[4][58] = 1; // hmt[1]
                rx_data_76[4][59] = 0; // hmt[2]
                rx_data_76[4][60] = 0; // hmt[3]
                rx_data_76[4][75] = 0; // crc[1]
            end

            if (i > 41000000 && i < 41000000+1001)
            begin
                rx_data_76[5][64] = 1; // hmt[0]
                rx_data_76[5][58] = 0; // hmt[1]
                rx_data_76[5][59] = 0; // hmt[2]
                rx_data_76[5][60] = 0; // hmt[3]
                rx_data_76[5][75] = 1; // crc[1]
            end
            
            if (i > 42000000 && i < 42000000+1001)
            begin
                rx_data_76[6][64] = 0; // hmt[0]
                rx_data_76[6][58] = 1; // hmt[1]
                rx_data_76[6][59] = 0; // hmt[2]
                rx_data_76[6][60] = 0; // hmt[3]
                rx_data_76[6][75] = 1; // crc[1]
            end

            if (i > 43000000 && i < 43000000+1001)
            begin
                rx_data_76[7][64] = 0; // hmt[0]
                rx_data_76[7][58] = 0; // hmt[1]
                rx_data_76[7][59] = 1; // hmt[2]
                rx_data_76[7][60] = 0; // hmt[3]
                rx_data_76[7][75] = 1; // crc[1]
            end

            // CSCID=1 special case
            if (i > 35000000 && i < 35000000+1001)
            begin
                rx_data_76[7][72] = 0; // hmt[0]
                rx_data_76[6][71] = 1; // hmt[1]
                rx_data_76[6][72] = 0; // hmt[2]
                rx_data_76[6][73] = 0; // hmt[3]
                rx_data_76[6][75] = 1; // crc[1]
            end
            clk40 = 1;
        end
        $finish;
    end

endmodule
