// AXI master outputs and slave inputs
interface axi_in #(DW = 64) (input s_aclk, input s_aresetn);
    wire [5:0]awid;
    wire [31:0]awaddr;
    wire [7:0]awlen;
    wire [2:0]awsize;
    wire [1:0]awburst;
    wire awvalid;
    wire [DW-1:0]wdata;
    wire [7:0]wstrb;
    wire wlast;
    wire wvalid;
    wire bready;
    wire [5:0]arid;
    wire [31:0]araddr;
    wire [7:0]arlen;
    wire [2:0]arsize;
    wire [1:0]arburst;
    wire arvalid;
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
    wire [DW-1:0]rdata;
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

// CSC trigger primitive (LCT, stub)
typedef struct 
{
    bit vf;         // valid flag
    bit [7:0] hs;   // halfstrip
    bit [6:0] wg;   // wiregroup
    bit [3:0] ql;   // quality
    bit [3:0] cp;   // CLCT pattern
    bit lr;         // left-right flag
} csc_lct;
    