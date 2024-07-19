`ifndef EMTF_INTERFACES_SV
`define EMTF_INTERFACES_SV

// AXI master outputs and slave inputs
interface axi_in #(DW = 64) (input s_aclk, input s_aresetn);
    reg [5:0]awid;
    reg [31:0]awaddr;
    reg [7:0]awlen;
    reg [2:0]awsize;
    reg [1:0]awburst;
    reg  awvalid;
    reg [DW-1:0]wdata;
    wire [7:0]wstrb;
    reg  wlast;
    reg  wvalid;
    wire bready;
    reg [5:0]arid;
    reg [31:0]araddr;
    reg [7:0]arlen;
    reg [2:0]arsize;
    reg [1:0]arburst;
    reg  arvalid;
    wire rready;

    modport master
    (
        input s_aclk,
        input s_aresetn,
        output awid,
        output awaddr,
        output awlen,
        output awsize,
        output awburst,
        output awvalid,
        output wdata,
        output wstrb,
        output wlast,
        output wvalid,
        output bready,
        output arid,
        output araddr,
        output arlen,
        output arsize,
        output arburst,
        output arvalid,
        output rready
    );

    modport slave
    (
        input s_aclk,
        input s_aresetn,
        input awid,
        input awaddr,
        input awlen,
        input awsize,
        input awburst,
        input awvalid,
        input wdata,
        input wstrb,
        input wlast,
        input wvalid,
        input bready,
        input arid,
        input araddr,
        input arlen,
        input arsize,
        input arburst,
        input arvalid,
        input rready
    );
endinterface

// AXI master inputs and slave outputs
interface axi_out #(DW = 64);
    reg awready;
    reg wready;
    wire [5:0]bid;
    reg [1:0]bresp;
    reg bvalid;
    reg arready;
    wire [5:0]rid;
    reg [DW-1:0]rdata;
    reg [1:0]rresp;
    reg rlast;
    reg rvalid;
    
    modport master
    (
        input awready,
        input wready,
        input bid,
        input bresp,
        input bvalid,
        input arready,
        input rid,
        input rdata,
        input rresp,
        input rlast,
        input rvalid
    );

    modport slave
    (
        output awready,
        output wready,
        output bid,
        output bresp,
        output bvalid,
        output arready,
        output rid,
        output rdata,
        output rresp,
        output rlast,
        output rvalid
    );
endinterface

interface csc_lct;
    reg vf;         // valid flag
    reg [7:0] hs;   // halfstrip
    reg [6:0] wg;   // wiregroup
    reg [3:0] ql;   // quality
    reg [3:0] cp;   // CLCT pattern
    reg lr;         // left-right flag

    modport in
    (
        input vf,
        input hs,
        input wg,
        input ql,
        input cp,
        input lr
    );

    modport out
    (
        output vf,
        output hs,
        output wg,
        output ql,
        output cp,
        output lr
    );
endinterface

interface ge11_cluster;
	reg [7:0] str; // strip
	reg [2:0] prt; // partition
	reg [2:0] csz; // cluster size
	reg       vf;  // valid flag, generated field from strip != 'hff

	modport in  ( input str, prt, csz, vf);
	modport out (output str, prt, csz, vf);

endinterface

typedef struct packed
{
	logic [7:0] str; // strip
	logic [2:0] prt; // partition
	logic [2:0] csz; // cluster size
	logic       vf ;  // valid flag, generated field from strip != 'hff
} ge11_cluster_struct;


`endif    
