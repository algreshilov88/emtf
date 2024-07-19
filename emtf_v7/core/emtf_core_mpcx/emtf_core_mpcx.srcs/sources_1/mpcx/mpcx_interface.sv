`ifndef MPCX_INTERFACE_SV
`define MPCX_INTERFACE_SV

typedef struct packed
{
        logic       vf;   // valid flag
        logic [7:0] hs;   // halfstrip
        logic [6:0] wg;   // wilogicroup
        logic [3:0] ql;   // quality
        logic [3:0] cp;   // CLCT pattern
        logic       lr;   // left-right flag
        logic       bc0;  // BC0 flag
        logic       bx0;  // low bit of BX counter
        logic       ser;  // sync error
        logic [3:0] cid;  // CSC ID
} csc_lct_mpcx;

typedef struct packed
{
    csc_lct_mpcx lct0, lct1;
} csc_all_lcts;

// this union includes both LCTs from a chamber
typedef union packed
{
    csc_all_lcts lcts;
    logic [63:0] comb;
} csc_mpcx_u;


`endif
