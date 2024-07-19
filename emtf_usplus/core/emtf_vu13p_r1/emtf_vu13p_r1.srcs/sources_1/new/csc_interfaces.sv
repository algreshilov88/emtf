`ifndef CSC_INTERFACES_SV
`define CSC_INTERFACES_SV

// counts of chambers in inner and outer rings
`define CSC_OUTER 35
`define CSC_INNER 19
`define CSC_TOTAL (`CSC_OUTER + `CSC_INNER)
// links per chamber
`define CSC_LINKS_PER_OUTER 1
`define CSC_LINKS_PER_INNER 2

`define CSC_LINKS_OUTER (`CSC_OUTER * `CSC_LINKS_PER_OUTER) 
`define CSC_LINKS_INNER (`CSC_INNER * `CSC_LINKS_PER_INNER)

// total link count
`define CSC_LINKS_TOTAL (`CSC_LINKS_OUTER + `CSC_LINKS_INNER)

`define MK_UNION(st,stu) union packed{st s; logic [$bits(st)-1:0] comb;} stu

typedef struct packed
{
    logic       vf;   // valid flag
    logic [2:0] ql;   // quality
    logic [9:0] es;   // 1/8 strip
    logic       lr;   // left-right
    logic [3:0] bn;   // bend
} csc_clct;

typedef struct packed
{
    logic       vf;   // valid flag
    logic [1:0] ql;   // quality
    logic [6:0] wg;   // wiregroup
} csc_alct;

typedef struct packed
{
    csc_clct   clct1;
    csc_alct   alct1;
    logic       bc0;
    logic [7:0] crc;
} csc_inner_l1f0; // inner rings link 1 frame 0

typedef struct packed
{
    csc_clct   clct3;
    csc_alct   alct2;
    logic       bc0;
    logic [7:0] crc;
} csc_inner_l2f0; // inner rings link 2 frame 0

typedef struct packed
{
    csc_clct   clct2;
    logic [4:0] pattern12;
    logic [3:0] hmt;
    logic       rsv;
    logic       bc0;
    logic [7:0] crc;
} csc_inner_l1f1; // inner rings link 1 frame 1

typedef struct packed
{
    csc_clct   clct4;
    logic [4:0] pattern34;
    logic [4:0] rsv;
    logic       bc0;
    logic [7:0] crc;
} csc_inner_l2f1; // inner rings link 2 frame 1

typedef struct packed
{
    csc_inner_l1f0 f0;
    csc_inner_l1f1 f1;
} csc_inner_deformatted_l1; // inner rings link 1

typedef struct packed
{
    csc_inner_l2f0 f0;
    csc_inner_l2f1 f1;
} csc_inner_deformatted_l2; // inner rings link 1

typedef struct packed
{
    csc_inner_deformatted_l1 l1;
    csc_inner_deformatted_l2 l2;
} csc_inner_deformatted; // inner rings both links combined

typedef struct packed
{
    csc_clct   clct1;
    csc_alct   alct1;
    logic       bc0;
    logic [7:0] crc;
} csc_outer_f0; // outer rings frame 0

typedef struct packed
{
    csc_clct   clct2;
    csc_alct   alct2;
    logic       bc0;
    logic [7:0] crc;
} csc_outer_f1; // outer rings frame 1

typedef struct packed
{
    logic [18:0] rsv1;
    logic [4:0]  pattern34;
    logic [3:0]  hmt;
    logic        rsv2;
    logic        bc0;
    logic [7:0]  crc;
} csc_outer_f2; // outer rings frame 2

typedef struct packed
{
    csc_outer_f0 f0;
    csc_outer_f1 f1;
    csc_outer_f2 f2;
} csc_outer_deformatted;

typedef struct packed
{
    logic       endcap; // 0 = me+, 1 = me-
    logic [2:0] station; // 1,2,3,4
    logic [1:0] ring; // 1,2,3
    logic [5:0] chamber; // 1..36
    logic       ch_link; // 0,1
    logic [4:0] rsv;
} csc_link_id;

typedef struct packed
{
    logic        zero1; // normally valid bit
    csc_link_id lid;
    logic        zero2; // normally valid bit
    logic [3:0]  test_pattern;
    logic [3:0]  zero3; // normally hmt
    logic        rsv;
    logic        zero4; // normally bc0
    logic [7:0]  crc;
} csc_dummy_frame;

typedef struct packed
{
    logic [4:0] automatic_delay; // automatic delay
    logic alg_out_range;  // alignment counter out of range
    logic bc0_period_err; // BC0 period is not exactly one orbit
	logic crc_err         ; // CRC error detected
    logic err_tst_pat     ; // test counter error detected 
	logic crc_err_flag    ; // CRC error detected, persisting
    logic err_tst_pat_flag; // test counter error detected, persisting
	csc_link_id link_id; // link ID
	logic [25:0] stub_rate;
} csc_link_monitor;

typedef struct packed
{
    logic fiber_enable; // fiber enable flags
    logic [4:0] manual_delay; // manual delays
} csc_link_control;

`endif
