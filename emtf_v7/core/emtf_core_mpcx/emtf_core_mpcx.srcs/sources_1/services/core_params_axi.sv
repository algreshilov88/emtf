`include "../core/vppc_macros.sv"


module core_params_axi #
(
    parameter AW = 16, // address width, increased by one bit to accommodate mgt_builder
    parameter DW = 64, // data width
	parameter BA = 32'h0 // base address
)
(

    axi_in.slave  s_axi,
    axi_out.slave s_axo,

    // core interface    
    output reg [8:0] cs [6:0],
    output [1:0]     sel,
    output [bw_addr-1:0] addr,
    output [DW-1:0] r_in, // input data for memory or register
    input [DW-1:0]  r_out, // output data from memory or register
    output          we, // write enable for memory or register
    
    // MGT builder interface extra signals
    // we, r_in, r_out are the same as core interface
    output [11:0] mgtb_addr,
    output mgtb_en, // pulsed enable for DRP
    output mgtb_en_r // persistent enable for r_out bus multiplexor

);

`include "../core/spbits.sv"

    localparam IDLE = 2'h0;
    localparam WRITE = 2'h1;
    localparam READ = 2'h2;
    localparam READ_PAUSE = 2'h3;
    reg [1:0] state = IDLE;
    
    reg wlast_r;
	
	reg rvalid_e, rlast_e;
	wire [31:0] base_addr = BA;
	reg ba_we, ba_re, ba_re_e;
	wire [DW-1:0] rdata;

    wire [5:0] chamber;

    // core interface    

    assign s_axo.bid = 6'h0;
    assign s_axo.rid = 6'h0;
    
    
    assign r_in = s_axi.wdata;
    assign we = (s_axo.wready && s_axi.wvalid && ba_we); // write only if base address matches
    wire en;
    reg en_r;
    assign en = en_r | we;
	
	always @(posedge s_axi.s_aclk)
	begin
		s_axo.rdata = (ba_re) ? r_out : 64'h0; // output data only if base address matches
	end

     reg [AW-1:0] addr_cnt; 
     reg [7:0] xfer_cnt;

    assign mgtb_en = mgtb_en_r & en;
    assign {mgtb_en_r, chamber, sel, addr} = addr_cnt; // split address counter into fields
    assign mgtb_addr = addr_cnt[11:0];
    // decode chamber select
    always @(*)
    begin
        cs = '{9'h0, 9'h0, 9'h0, 9'h0, 9'h0, 9'h0, 9'h0};
        cs[chamber / 9][chamber % 9] = ~mgtb_en_r; // enable chamber only if not addressing MGT builder
    end


    always @(posedge s_axi.s_aclk)
    begin
        if (!s_axi.s_aresetn)
        begin
            state = IDLE;
        end
        else
        begin
    
			// need to delay rvalid and rlast to compensate for BRAM latency
			s_axo.rvalid = rvalid_e;
			s_axo.rlast = rlast_e;
			ba_re = ba_re_e;
			en_r = 1'b0;
	
            case (state)
                IDLE:
                begin
                    s_axo.awready = 1'b1; // ready for write address
                    s_axo.arready = 1'b1; // ready for read address
                    s_axo.wready = 1'b0; // not ready for data
                    rvalid_e = 1'b0; // no read data
                    s_axo.bvalid = 1'b0; // confirmation
                    rlast_e = 1'b0;
					ba_we = 1'b0;
					ba_re_e = 1'b0;
					s_axo.bresp = 2'h0;
					s_axo.rresp = 2'h0;

                    if (s_axi.awvalid)
                    begin
                        // valid write address arrived
						
						// check for base address match
						if (s_axi.awaddr[31:AW] == base_addr[31:AW])
							ba_we = 1'b1;
						else
							s_axo.bresp = 2'b10; // slave error
							
						addr_cnt = s_axi.awaddr[AW-1:0]; // put address into counter
						s_axo.awready = 1'b0; // not ready for write address
						s_axo.arready = 1'b0; // not ready for read address
						s_axo.wready = 1'b1; // ready for data
						state = WRITE;
                    end
                    if (s_axi.arvalid)
                    begin
                        // valid read address
						if (s_axi.araddr[31:AW] == base_addr[31:AW]) // base address match
						begin
							ba_re_e = 1'b1;
							en_r = 1'b1;
				        end
						else
							s_axo.rresp = 2'b10; // slave error

						addr_cnt = s_axi.araddr[AW-1:0]; // put address into counter
						xfer_cnt = s_axi.arlen; // transfer length into counter
						state = READ;
                    end
                end
                
                WRITE:
                begin
                    s_axo.awready = 1'b0; // not ready for write address
                    s_axo.arready = 1'b0; // not ready for read address
                    s_axo.wready = 1'b1; // ready for data
                    if (s_axi.wvalid)
                    begin 
                        addr_cnt = addr_cnt + 1; // increment address on each valid flag
                    end
                    if (s_axi.wlast && !wlast_r)
                    begin 
                        state = IDLE; // last word, get out
                        s_axo.bvalid = 1'b1; // confirmation
                    end       
                end

                READ:
                begin
                    s_axo.awready = 1'b0; // not ready for write address
                    s_axo.arready = 1'b0; // not ready for read address
                    rvalid_e = 1'b1; // data valid
                    if (xfer_cnt == 8'h0) // last transfer
                        rlast_e = 1'b1;
                    else 
                        rlast_e = 1'b0;
                    if (s_axi.rready) // master accepted data beat
                    begin
                        addr_cnt = addr_cnt + 1; // increment address
                        if (rlast_e) state = IDLE; // return to idle when last beat and it's accepted
                        xfer_cnt = xfer_cnt - 8'h1; // decrement transfer counter
                    end            
                end
            endcase
    
            wlast_r = s_axi.wlast;
        end
    end


endmodule
