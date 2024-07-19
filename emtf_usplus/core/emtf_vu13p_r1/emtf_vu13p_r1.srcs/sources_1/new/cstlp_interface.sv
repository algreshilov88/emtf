`ifndef CSTLP_INTERFACE_SV
`define CSTLP_INTERFACE_SV

`define LWORD_WIDTH 64

typedef struct packed
{
    logic [`LWORD_WIDTH-1:0] data;
    logic valid          ;
    logic start          ;
    logic start_of_orbit ;
    logic strobe         ;
    logic last           ;
} lword;

typedef union packed
{
    lword s;
    logic [$bits(lword)-1:0] comb;
} lword_u;

typedef struct packed
{
    logic rst     ;
    logic ptr_inc ;
    logic ptr_dec ;
} rxram_pointer_t;

typedef union packed
{
    rxram_pointer_t s;
    logic [$bits(rxram_pointer_t)-1:0] comb;
} rxram_pointer_u;


typedef struct packed
{
    logic [7 : 0] crate_id       ;
    logic [3 : 0] slot_id        ;
    logic [4 : 0] tm_interval    ;
    logic [3 : 0] clk_multiplier ;
    logic [7 : 0] packet_size    ;
    logic [7 : 0] channel_id     ;
    logic         IM             ;
} linkRxMetadata_t;

typedef union packed
{
    linkRxMetadata_t s;
    logic [$bits(linkRxMetadata_t)-1:0] comb;
} linkRxMetadata_u;

typedef struct packed
{
    logic [7:0] crc_errors              ;    
    logic [3:0] hard_errors             ;
    logic [3:0] cwt_single_errors       ;
    logic [3:0] cwt_double_errors       ;
    logic [7:0] packet_cntr             ;
    logic [3:0] special_bits            ;
    logic       rx_index_lock_lost      ;
    logic [3:0] rx_index_lock_lost_cntr ;
    logic [3:0] wrong_index_cntr_out    ;
} linkStatusInfo_t;

typedef union packed
{
    linkStatusInfo_t s;
    logic [$bits(linkStatusInfo_t)-1:0] comb;
} linkStatusInfo_u;

`endif
