
// see EMTF_reclockers.docx document in github for the logic details 
module rx_reclock 
#(
    parameter N_FRAMES = 2 // number of frames, 2 or 3
)
(
    input [37:0] rx_data_38, // at mgt clk domain
    input [1:0] rx_header,
    input rx_clk, // mgt rx clock
     
    output [N_FRAMES*38-1:0] rx_data_o, // at fabric clk domain
    input fiber_enable,
    input clk40, // fabric clk
    input clk320  // fabric clk x 8
);


    reg [N_FRAMES*38-1:0] inreg_80;
    reg [N_FRAMES*38-1:0] inreg_40 [5:0];
    (* dont_touch = "TRUE" *) reg rx_header_80 = 1'b0;
    reg [2:0] del_sel = 0, del_sel_n;
    reg clk40_ff = 0;
    (* async_reg = "TRUE" *) reg [10:0] rx_header_r, rx_header_40;
    
//    (* mark_debug *) wire [N_FRAMES*38-1:0] inreg_80_w = inreg_80;
//    (* mark_debug *) wire [37:0] rx_data_38_w = rx_data_38;
//    (* mark_debug *) wire [N_FRAMES*38-1:0] rx_data_ow = rx_data_o;
//    (* mark_debug *) wire [1:0] rx_header_w = rx_header;
//    (* mark_debug *) wire rx_header_80_w = rx_header_80;
//    (* mark_debug *) wire [10:0] rx_header_rw = rx_header_r;
//    (* mark_debug *) wire [10:0] rx_header_40_w = rx_header_40;
//    (* mark_debug *) wire [2:0] del_sel_w = del_sel;

    (* async_reg = "TRUE" *)
    FDRE fdre_i[N_FRAMES*38-1:0]
    (
        .C  (clk40),
        .CE (1'b1),
        .D  (inreg_40[del_sel]),
        .R  (fiber_enable == 1'b0),
        .Q  (rx_data_o)
    );
    
    always @(posedge clk40)
    begin 
    
        del_sel = del_sel_n;
    
        if      (rx_header_40[ 3:2] == 2'b01 || rx_header_40[ 4:3] == 2'b01) del_sel_n = 3'h3; // 2
        else if (rx_header_40[ 9:8] == 2'b01 || rx_header_40[10:9] == 2'b01) del_sel_n = 3'h2; // 1
        else if (rx_header_40[ 5:4] == 2'b01 || rx_header_40[ 6:5] == 2'b01) 
        begin 
            if (del_sel <= 3'h1) del_sel_n = 3'h0; 
            else del_sel_n = 3'h4; 
        end
        else if (rx_header_40[ 7:6] == 2'b01 || rx_header_40[ 8:7] == 2'b01)
        begin
            if (del_sel >= 3'h4) del_sel_n = 3'h5; 
            else del_sel_n = 3'h1; 
        end
        rx_header_40 = rx_header_r;

        clk40_ff = ~clk40_ff;
    end
    
    always @(posedge clk320)
    begin
        
        #1 rx_header_r = {rx_header_r[9:0], rx_header_80};
    end

    integer i;

    always @(posedge rx_clk)
    begin
        // inreg_40 is updated every 25 ns
        inreg_40[4] = inreg_40[2];
        inreg_40[2] = inreg_40[0];
        if (rx_header_80 == 1'b1) inreg_40[0] = inreg_80;
        
        // inreg_80 is updated every 12.5 or 8.33 ns
        for (i = 0; i < N_FRAMES-1; i++)
        begin
            inreg_80[i*38 +: 38] = inreg_80[(i+1)*38 +: 38];
        end 
        inreg_80[(N_FRAMES-1)*38 +: 38] = rx_data_38;

        if (rx_header == 2'b10) rx_header_80 = 1'b1; // if special header, reset the header flag
        else rx_header_80 = ~rx_header_80; // if normal header, just flip the header flag
    end

    always @(negedge rx_clk)
    begin
        inreg_40[5] = inreg_40[3];
        inreg_40[3] = inreg_40[1];
        inreg_40[1] = inreg_40[0];
    end
    
endmodule

