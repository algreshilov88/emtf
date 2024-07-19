`include "../core/vppc_macros.sv"

module spy_mem_axi #
(
    parameter AW = 13, // address width port A
    parameter DW = 64, // data width port A
	
	parameter AWB = 9, // address width port B
	parameter DWB = 1024, // data width port B
	
	parameter BA = 32'h0 // base address
)
(
    axi_in.slave  s_axi,
    axi_out.slave s_axo,

	input clkb,
	input inject,
	output [DWB-1:0] dout,
	input [DWB-1:0] din,
	
	input [8:0] daq_delay,
	input l1a,
	input rank_valid,
    output reg [AWB-1:0] inj_addr,
	input spy_reset,
	input spy_l1a,
	input spy_valid,
	input spy_rank,
	input [8*5+9-1:0] bc0_err_period_i, // all bc0 period errors combined
	input spy_bc0_err,

    input [63:0] mpc_link_use_bc0_ch1,
    input [63:0] gth_rx_reset
	
);

    assign s_axo.bid = 6'h0;
    assign s_axo.rid = 6'h0;
    

    reg [63:0] mpc_link_use_bc0_ch1_r [1:0];
    reg [63:0] gth_rx_reset_r [1:0];

    reg [AW-1:0] addr_cnt; 
    reg [7:0] xfer_cnt;
    
    localparam IDLE = 2'h0;
    localparam WRITE = 2'h1;
    localparam READ = 2'h2;
    reg [1:0] state = IDLE;
    
    reg wlast_r;
	
	reg rvalid_e, rlast_e;
	wire [31:0] base_addr = BA;
    reg ba_we, ba_re, ba_re_e;
	wire [DW-1:0] rdata;

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
							ba_re_e = 1'b1;
						else
							s_axo.rresp = 2'b10; // slave error

						addr_cnt = s_axi.araddr[AW-1:0] - 1; // put address into counter
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

    // injection control logic
    reg inject_r, inject_rr, ien;
	reg [4:0] l1a_event;
	reg l1a_r, l1a_en = 1'b0;
	(* mark_debug = "TRUE" *) wire l1a_en_w = l1a_en;
	reg [1:0] frame_cnt [48:0];
	reg [48:0] val_en = 49'h0;
	reg [48:0] bc0_en = 49'h0;
	(* mark_debug = "TRUE" *) wire [48:0] val_en_w = val_en;
	integer i, j;
	
	(* mark_debug = "TRUE" *) wire inject_w = inject;
	(* mark_debug = "TRUE" *) wire inject_rw = inject_r;
	(* mark_debug = "TRUE" *) wire inject_rrw = inject_rr;
	(* mark_debug = "TRUE" *) wire ien_w = ien;
	(* mark_debug = "TRUE" *) wire [AWB-1:0] inj_addr_w = inj_addr;
	reg [4:0] st_valid;
	reg [6:0] bc0_err_period_cnt [8*5+9-1:0]; // bc0 error time counters for each link, in 1/10 of sec
	reg [23:0] div_clk; // 10 Hz clock
	reg div_clk_tick, bc0_long_err;
	(* mark_debug = "TRUE" *) wire div_clk_tick_w = div_clk_tick; 
	(* mark_debug = "TRUE" *) wire bc0_long_err_w = bc0_long_err;
	
	(* mark_debug = "TRUE" *) wire [48:0] bc0_en_w = bc0_en;
	(* mark_debug = "TRUE" *) wire spy_bc0_err_w = spy_bc0_err;
	(* mark_debug = "TRUE" *) wire [6:0] bc0_err_period_cnt_w [8*5+9-1:0] = bc0_err_period_cnt;
	(* mark_debug = "TRUE" *) wire [8*5+9-1:0] bc0_err_period_i_w = bc0_err_period_i;
	reg [5:0] bc0_err_link_cnt;
	(* mark_debug = "TRUE" *) wire [5:0] bc0_err_link_cnt_w = bc0_err_link_cnt;
	
	reg bc0ch1_trig, gthrst_trig;
	
  
    always @(posedge clkb)
    begin
    
        bc0ch1_trig = 1'b0;
        if ((mpc_link_use_bc0_ch1_r[1] ^ mpc_link_use_bc0_ch1_r[0]) != 64'b0 && mpc_link_use_bc0_ch1_r[0] != 64'b0)
        begin
            bc0ch1_trig = 1'b1;
        end

        gthrst_trig = 1'b0;
        if ((gth_rx_reset_r[1] ^ gth_rx_reset_r[0]) != 64'b0 && gth_rx_reset_r[0] != 64'b0)
        begin
            gthrst_trig = 1'b1;
        end

        if ((bc0ch1_trig || gthrst_trig) && spy_bc0_err) // one of the link repair actions 
        begin
            ien = 1'b1; // set inject enable flag
        end

    
		// inject state machine
		// reacts to test data injection, fills entire spy fifo
        if (ien)
        begin
            inj_addr = inj_addr + 9'h1; // increase address
            if (inj_addr == 9'h1ff)
                ien = 1'b0; // last address reached, done injecting
        end
    
        if (inject_r && !inject_rr) // inject just rose
        begin
            ien = 1'b1; // set inject enable flag
        end
        inject_rr = inject_r;
        inject_r = inject;

		// l1a state machine
		// on l1a, fills only 28 locations in spy memory (7 clocks)
        if (l1a_en)
        begin
            if (inj_addr == 9'h1ff || l1a_event == 5'd28)
			begin
                l1a_en = 1'b0; // last address or event is done, stop writing
			end
			else
			begin
				inj_addr = inj_addr + 9'h1; // increase address
				l1a_event = l1a_event + 5'h1; // increase event counter
			end
        end
        else
        begin
            l1a_event = 5'h0; // reset event counter
        end
    
		// l1a just rose and memory not full and spying on L1A enabled
        if (l1a && !l1a_r && inj_addr != 9'h1ff && spy_l1a) 
        begin
            l1a_en = 1'b1; // set l1a enable flag
        end
		
		// valid rank detected and memory not full and spying on rank enabled
        if (rank_valid && inj_addr != 9'h1ff && spy_rank) 
        begin
            l1a_en = 1'b1; // set l1a enable flag
        end


		if (spy_reset)
			inj_addr = 9'h0;
        
        l1a_r = l1a;
		
		if (val_en != 0 && inj_addr != 9'h1ff && spy_valid)
		  inj_addr = inj_addr + 9'h1; // increase address
		  
		for (j = 0; j < 49; j = j+1) // link loop
		begin
            // logic to record data based on valid flags
            if (din[16*j + 15] == 1'b1) // frame 0 flag from this link
            begin
                frame_cnt[j] = 2'h0;
            end
            
            if (frame_cnt[j] == 2'h2) // all valid flags are in frame 2
            begin
                // check all valid bits (10 and 11) in each fiber
                if (din[j*16+10 +: 2] != 2'h0 && inj_addr != 9'h1ff) val_en[j] = spy_valid;
                else val_en[j] = 0;

                // check bc0 from any link
                if (din[j*16+12] == 1'h1) bc0_en[j] = 1'b1;
                else bc0_en[j] = 1'b0;
                
            end
            
            `inc(frame_cnt[j]);
		end
		
        mpc_link_use_bc0_ch1_r[1] = mpc_link_use_bc0_ch1_r[0];
        mpc_link_use_bc0_ch1_r[0] = mpc_link_use_bc0_ch1;
        
        gth_rx_reset_r[1] = gth_rx_reset_r[0];
        gth_rx_reset_r[0] = gth_rx_reset;

    end

    wire [DWB-1:0] doutm;
    assign dout = ien ? doutm : {DWB{1'h0}};

     wire we = (s_axo.wready && s_axi.wvalid && ba_we); // write only if base address matches

	wire [DWB-1:0] din_del;
	reg [8:0] del_mem_waddr, del_mem_raddr, del_mem_out_waddr;

    mpc_spy_mem msm 
    (
        .clka(s_axi.s_aclk),    // input wire clka
        .wea(we),      // input wire [0 : 0] wea
        .addra(addr_cnt[12:0]),  // input wire [12 : 0] addra
        .dina(s_axi.wdata),    // input wire [63 : 0] dina
        .douta(rdata),  // output wire [63 : 0] douta
        
        .clkb(clkb),    // input wire clkb
        .web(ien || l1a_en || val_en != 0),      // input wire [0 : 0] web
        .addrb(inj_addr),  // input wire [8 : 0] addrb
		.dinb(din_del),
        .doutb(doutm)  // output wire [1023 : 0] doutb
    );

	assign s_axo.rdata = (ba_re) ? rdata : 64'h0; // output data only if base address matches

	wire [8:0] core_latency = 9'h0; //9'd52; // 13*4

	// process daq delay memory addresses
	always @(posedge clkb)
	begin
		del_mem_out_waddr = del_mem_raddr + daq_delay - core_latency;
		del_mem_waddr = del_mem_raddr + daq_delay;
		del_mem_raddr = del_mem_raddr + 9'h1;
	end

	
	// this memory delays MPC data to match L1A delay
	daq_delay_mem dd_mpc 
	(
		.clka(clkb), // input clka
		.wea(1'b1), // input [0 : 0] wea
		.addra(del_mem_waddr), // input [8 : 0] addra
		.dina(din[16*49-1:0]), // input [639 : 0] dina
		.clkb(clkb), // input clkb
		.enb(1'b1),
		.addrb(del_mem_raddr), // input [8 : 0] addrb
		.doutb(din_del[16*49-1:0]) // output [639 : 0] doutb
	);

	// delay memory for TF core outputs
	daq_delay_mem_out dd_out
	(
		.clka(clkb), // input clka
		.wea(1'b1), // input [0 : 0] wea
		.addra(del_mem_out_waddr), // input [8 : 0] addra
		.dina(din[1023:16*49]), // input [383 : 0] dina
		.clkb(clkb), // input clkb
		.enb(1'b1),
		.addrb(del_mem_raddr), // input [8 : 0] addrb
		.doutb(din_del[1023:16*49]) // output [383 : 0] doutb
	);

endmodule
