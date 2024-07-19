`include "vppc_macros.sv"


module single
(
    input [bw_fph-1:0] ph   [4:0][8:0][seg_ch-1:0],
    input [bw_th-1:0]  th11 [1:0][2:0][th_ch11-1:0],
    input [bw_th-1:0]  th   [4:0][8:0][seg_ch-1:0],
    input [seg_ch-1:0] vl   [4:0][8:0],
    output reg vl_single,
    output reg [bw_fph-1:0] ph_single,
    output reg [bw_th-1:0]  th_single,
    input en,
    input clk
);

`include "spbits.sv"


    integer i, j;
    `localpar DEL = 8;

    reg vl_s;
    reg [DEL-1:0] vl_d;
    reg [bw_fph-1:0] ph_d [DEL-1:0];
    reg [bw_th-1:0]  th_d [DEL-1:0];
    reg [bw_fph-1:0] ph_s;
    reg [bw_th-1:0]  th_s;
    
    reg [11:0] orbit_period;
    reg [11:0] orb_rate [4:0][8:0];
//    reg link_good [4:0][8:0];
    
    
    always @(posedge clk)
    begin

        vl_single = vl_d[DEL-1];
        ph_single = ph_d[DEL-1];
        th_single = th_d[DEL-1];

        // delay lines for outputs
        vl_d = {vl_d[DEL-2:0], vl_s};
        ph_d = {ph_d[DEL-2:0], ph_s};
        th_d = {th_d[DEL-2:0], th_s};
    
        vl_s = 1'b0;
        ph_s = 0;
        th_s = 0;
        if (en == 1'b1)
        begin
            for (i = 0; i < 5; i = i+1) // station loop
            begin
                for (j = 0; j < 9; j = j+1) // chamber loop
                begin
             //       if (link_good[i][j]) // only use stubs if link rate is within bounds
  //                  begin 
                        vl_s = vl_s | vl[i][j][0];
                        if (vl[i][j][0] == 1'b1)
                        begin
                            ph_s = ph[i][j][0];                        
                            if (i < 2 && j < 3)
                                th_s = th11[i][j][0]; // ME1/1
                            else
                                th_s = th[i][j][0]; // all other chambers
                        end
 //                   end

/*
                    // instant segment rate per orbit counters
                    if (orbit_period == 12'h0)
                    begin
                        if (orb_rate[i][j] < 12'h10) // even 10 is too much for cosmics
                            link_good[i][j] = 1'b1;
                        else
                            link_good[i][j] = 1'b0;
                            
                        orb_rate[i][j] = 12'h0;
                    end
                    if (vl[i][j][0] == 1'b1) orb_rate[i][j]++;
           */
                end
            end
        end
        if (orbit_period == 12'd3564) orbit_period = 0;
        else orbit_period++;                
    
    end

endmodule