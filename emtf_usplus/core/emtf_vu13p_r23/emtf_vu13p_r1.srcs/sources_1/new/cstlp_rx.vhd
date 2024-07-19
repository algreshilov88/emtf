library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.emp_data_types.all;
use work.package_links.all;

entity cstlp_rx is
  port(
    freerun_clk           : in  std_logic;
    ttc_clk               : in  std_logic;
    rxusrclk              : in  std_logic;
    reset                 : in  std_logic;
    reset_cnt_in          : in  std_logic;
    reset_latched_in      : in  std_logic;
    link_status_in        : in  std_logic;
    rx_data_in            : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    rx_header_in          : in  std_logic_vector(2 downto 0);
    rx_datavalid_in       : in  std_logic;
    align_marker_sel_in   : in  std_logic;
    align_marker_dis_in   : in  std_logic;
    disable_ICM_in        : in  std_logic;
    
--  rxram_pointer_ctrl_in : in  rxram_pointer_t;
    rxram_pointer_ctrl_in_c : in std_logic_vector(2 downto 0);

    unscrambled_data_out  : out std_logic_vector(DATA_WIDTH-1 downto 0);
    valid_bit_out         : out std_logic;
    rx_datavalid_out      : out std_logic;
    
--  rxdata_out            : out lword;
    rxdata_out_c            : out std_logic_vector(LWORD_WIDTH+5 - 1 downto 0);
      
--  rxMetadata_out        : out linkRxMetadata_t;
    rxMetadata_out_c        : out std_logic_vector(8+4+5+4+8+8+1-1 downto 0);
    
--  linkStatusInfo_out    : out linkStatusInfo_t
    linkStatusInfo_out_c    : out std_logic_vector(8+4+4+4+8+4+1+4+4-1 downto 0)    
    );
end cstlp_rx;

architecture Behavioral of cstlp_rx is
    signal rxram_pointer_ctrl_in : rxram_pointer_t;
    signal rxdata_out            : lword;
    signal rxMetadata_out        : linkRxMetadata_t;
    signal linkStatusInfo_out    : linkStatusInfo_t;
begin

--  rxram_pointer_ctrl_in : in  rxram_pointer_t;
--  have to go bit by bit, cannot assign to concatenation directly, like in Verilog :(
    rxram_pointer_ctrl_in.rst     <= rxram_pointer_ctrl_in_c (2);
    rxram_pointer_ctrl_in.ptr_inc <= rxram_pointer_ctrl_in_c (1); 
    rxram_pointer_ctrl_in.ptr_dec <= rxram_pointer_ctrl_in_c (0);
    
--  rxdata_out            : out lword;
    rxdata_out_c <= rxdata_out.data           &
                    rxdata_out.valid          &
                    rxdata_out.start          &
                    rxdata_out.start_of_orbit &
                    rxdata_out.strobe         &
                    rxdata_out.last           ;
    
--  rxMetadata_out        : out linkRxMetadata_t;
    rxMetadata_out_c <=  rxMetadata_out.crate_id      &
                         rxMetadata_out.slot_id       &
                         rxMetadata_out.tm_interval   &
                         rxMetadata_out.clk_multiplier&
                         rxMetadata_out.packet_size   &
                         rxMetadata_out.channel_id    &
                         rxMetadata_out.IM            ;
    
--  linkStatusInfo_out    : out linkStatusInfo_t
    linkStatusInfo_out_c <= linkStatusInfo_out.crc_errors             &    
                            linkStatusInfo_out.hard_errors            &
                            linkStatusInfo_out.cwt_single_errors      &
                            linkStatusInfo_out.cwt_double_errors      &
                            linkStatusInfo_out.packet_cntr            &
                            linkStatusInfo_out.special_bits           &
                            linkStatusInfo_out.rx_index_lock_lost     &
                            linkStatusInfo_out.rx_index_lock_lost_cntr&
                            linkStatusInfo_out.wrong_index_cntr_out   ;

 rx_path : entity work.rx_datapath
        generic map(
            CH => 0,
            INDEX => 0,
            MGT_KIND => GTY25G,
            IDLE_METHOD => 1, -- or 2?
            RX_INST => 0
        )      
        port map(
        freerun_clk           => freerun_clk          ,                    
        ttc_clk               => ttc_clk              ,         
        rxusrclk              => rxusrclk             ,        
        reset                 => reset                ,       
        reset_cnt_in          => reset_cnt_in         ,      
        reset_latched_in      => reset_latched_in     ,     
        link_status_in        => link_status_in       ,     
        rx_data_in            => rx_data_in           ,     
        rx_header_in          => rx_header_in         ,     
        rx_datavalid_in       => rx_datavalid_in      ,     
        align_marker_sel_in   => align_marker_sel_in  ,  
        align_marker_dis_in   => align_marker_dis_in  , 
        disable_ICM_in        => disable_ICM_in       ,  
        rxram_pointer_ctrl_in => rxram_pointer_ctrl_in,
        unscrambled_data_out  => unscrambled_data_out , 
        valid_bit_out         => valid_bit_out        , 
        rx_datavalid_out      => rx_datavalid_out     , 
        rxdata_out            => rxdata_out           , 
        rxMetadata_out        => rxMetadata_out       , 
        linkStatusInfo_out    => linkStatusInfo_out   
        );
        
end Behavioral;
