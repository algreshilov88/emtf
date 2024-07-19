
library IEEE;
use IEEE.STD_LOGIC_1164.all;

library work;

package package_links is

  -- declarations
  constant TTC_DOMAIN          : integer := 0;              -- Refers to clock domain of rx bram read pointer control signals - 0 when at free run domain, 1 when at ttc (algo) domain
  constant IDLE_METHOD         : integer range 1 to 2 := 1; -- 1: Receiving Idle as Control word, 2: Receiving Idle as Data word
  constant TX_INST             : integer := 4;              -- Number of Tx channels to be instantiated
  constant RX_INST             : integer := 4;              -- Number of Rx channels to be instantiated
  
  -- firmware constants
  constant NOMGT  : integer := 0;
  constant GTH16G : integer := 1;
  constant GTY16G : integer := 2;
  constant GTY25G : integer := 3;

  constant N_CHANNELS  : integer := 4;    
  constant DATA_WIDTH  : integer := 64;

  -- control words
  constant TAG_CODE  : std_logic_vector(3 downto 0) := x"0";
  constant PAD0_CODE : std_logic_vector(3 downto 0) := x"1";
  constant PAD1_CODE : std_logic_vector(3 downto 0) := x"2";
  constant CRCV_CODE : std_logic_vector(3 downto 0) := x"3";
  constant IDLE_CODE : std_logic_vector(3 downto 0) := x"4";
  
  constant ZEROS_RESERVED     : std_logic_vector(31 downto 0)  := x"00000000";
  constant CONTROL_RESERVED   : std_logic_vector(19 downto 0)  := x"00000";
  constant IDLE_WORD          : std_logic_vector(55 downto 0)  := x"0" & CONTROL_RESERVED & ZEROS_RESERVED;

  constant NUMBER_OF_CHAN_RW_REGS   : integer := 4;
  constant NUMBER_OF_CHAN_RO_REGS   : integer := 5;
  constant NUMBER_OF_COMMON_RW_REGS : integer := 1;
  constant NUMBER_OF_COMMON_RO_REGS : integer := 1;

  constant DRP_CHAN_ADDR_WIDTH : integer := 9;
  constant DRP_COMM_ADDR_WIDTH : integer := 9;

  constant SAFE_B2B_16G : integer := 100;
  constant SAFE_B2B_25G : integer := 10;

  constant MGT_DIFFCTRL_WIDTH : integer := 4;

  type type_vector_of_stdlogicvec_x2 is array(natural range <>) of std_logic_vector(1 downto 0);
  type type_vector_of_stdlogicvec_x3 is array(natural range <>) of std_logic_vector(2 downto 0);
  type type_vector_of_stdlogicvec_x4 is array(natural range <>) of std_logic_vector(3 downto 0);
  type type_vector_of_stdlogicvec_x5 is array(natural range <>) of std_logic_vector(4 downto 0);
  type type_vector_of_stdlogicvec_x6 is array(natural range <>) of std_logic_vector(5 downto 0);
  type type_vector_of_stdlogicvec_x7 is array(natural range <>) of std_logic_vector(6 downto 0);
  type type_vector_of_stdlogicvec_x8 is array(natural range <>) of std_logic_vector(7 downto 0);
  type type_vector_of_stdlogicvec_x9 is array(natural range <>) of std_logic_vector(8 downto 0);
  type type_vector_of_stdlogicvec_x16 is array(natural range <>) of std_logic_vector(15 downto 0);
  type type_vector_of_stdlogicvec_x21 is array(natural range <>) of std_logic_vector(20 downto 0);
  type type_vector_of_stdlogicvec_x24 is array(natural range <>) of std_logic_vector(23 downto 0);
  type type_vector_of_stdlogicvec_x32 is array(natural range <>) of std_logic_vector(31 downto 0);
  type type_vector_of_stdlogicvec_x64 is array(natural range <>) of std_logic_vector(63 downto 0);

  -- CHANNEL register space
  subtype type_chan_ro_reg is type_vector_of_stdlogicvec_x32(NUMBER_OF_CHAN_RO_REGS-1 downto 0);
  subtype type_chan_rw_reg is type_vector_of_stdlogicvec_x32(NUMBER_OF_CHAN_RW_REGS-1 downto 0);

  type type_chan_ro_reg_array is array(natural range <>) of type_chan_ro_reg;
  type type_chan_rw_reg_array is array(natural range <>) of type_chan_rw_reg;
  
  -- COMMON register space
  subtype type_common_ro_reg is type_vector_of_stdlogicvec_x32(NUMBER_OF_COMMON_RO_REGS-1 downto 0);
  subtype type_common_rw_reg is type_vector_of_stdlogicvec_x32(NUMBER_OF_COMMON_RW_REGS-1 downto 0);

  type mgtControl_i_t is
  record
    loopback_in             : type_vector_of_stdlogicvec_x3(N_CHANNELS-1 downto 0);
    txpolarity_in           : std_logic_vector(N_CHANNELS-1 downto 0);
    rxpolarity_in           : std_logic_vector(N_CHANNELS-1 downto 0);
    rxlpmen_in              : std_logic_vector(N_CHANNELS-1 downto 0);
    rxpmareset_in           : std_logic_vector(N_CHANNELS-1 downto 0);
    eyescanreset_in         : std_logic_vector(N_CHANNELS-1 downto 0);

    txdiffctrl_in           : std_logic_vector(MGT_DIFFCTRL_WIDTH*N_CHANNELS-1 downto 0);
    txpostcursor_in         : std_logic_vector(5*N_CHANNELS-1 downto 0);
    txprecursor_in          : std_logic_vector(5*N_CHANNELS-1 downto 0);

    rxprbscntreset_in       : std_logic_vector(N_CHANNELS-1 downto 0);
    rxprbssel_in            : type_vector_of_stdlogicvec_x4(N_CHANNELS-1 downto 0);
    txprbssel_in            : type_vector_of_stdlogicvec_x4(N_CHANNELS-1 downto 0);
    txprbsforceerr_in       : std_logic_vector(N_CHANNELS-1 downto 0);
    rxpd_in                 : std_logic_vector(2*N_CHANNELS-1 downto 0);
    txpd_in                 : std_logic_vector(2*N_CHANNELS-1 downto 0);
    qpll0pd_in              : std_logic_vector(0 downto 0);
    txelecidle_in           : std_logic_vector(N_CHANNELS-1 downto 0);
  end record;


  type mgtControl_o_t is
  record
    qpll0lock_out           : std_logic;
    reset_tx_done_out       : std_logic;
    reset_rx_done_out       : std_logic;
    buffbypass_tx_done_out  : std_logic;
    buffbypass_rx_done_out  : std_logic;
    txresetdone_out         : std_logic_vector(N_CHANNELS-1 downto 0);
    rxresetdone_out         : std_logic_vector(N_CHANNELS-1 downto 0);
    txpmaresetdone_i        : std_logic_vector(N_CHANNELS-1 downto 0);
    rxpmaresetdone_i        : std_logic_vector(N_CHANNELS-1 downto 0);
    rxcdrlock_out           : std_logic_vector(N_CHANNELS-1 downto 0);
    rxprbserr_out           : std_logic_vector(N_CHANNELS-1 downto 0);
    rxprbslocked_out        : std_logic_vector(N_CHANNELS-1 downto 0);
  end record;

  type linkStatusInfo_t is
  record
    crc_errors              : std_logic_vector(7 downto 0);    
    hard_errors             : std_logic_vector(3 downto 0);
    cwt_single_errors       : std_logic_vector(3 downto 0);
    cwt_double_errors       : std_logic_vector(3 downto 0);
    packet_cntr             : std_logic_vector(7 downto 0);
    special_bits            : std_logic_vector(3 downto 0);
    rx_index_lock_lost      : std_logic;
    rx_index_lock_lost_cntr : std_logic_vector(3 downto 0);
    wrong_index_cntr_out    : std_logic_vector(3 downto 0);
  end record;

  type invalidTxComp_t is
  record  
    startOrLastHighnAndValidLow    : std_logic_vector(3 downto 0);
    starOrLasttHighForMultiCycles  : std_logic_vector(3 downto 0);
    startAndLastHighSimultaneously : std_logic_vector(3 downto 0);
    NoLastBeforeStart_ValidInBoth  : std_logic_vector(3 downto 0);
    LastAndNotStart_ValidInBoth    : std_logic_vector(3 downto 0);
  end record;

  type txCtrlnStatus_t is
  record
    almost_full             : std_logic;
    full                    : std_logic;
    invalid_tx_comb_cntr    : invalidTxComp_t;
  end record;

  type linkTxMetadata_t is
  record  
    crate_id                : std_logic_vector(7 downto 0);
    slot_id                 : std_logic_vector(3 downto 0);
    tm_interval             : type_vector_of_stdlogicvec_x5(N_CHANNELS-1 downto 0);
    packet_payload_size     : type_vector_of_stdlogicvec_x8(N_CHANNELS-1 downto 0);
  end record;
  
  type linkRxMetadata_t is
  record  
    crate_id                : std_logic_vector(7 downto 0);
    slot_id                 : std_logic_vector(3 downto 0);
    tm_interval             : std_logic_vector(4 downto 0);
    clk_multiplier          : std_logic_vector(3 downto 0);
    packet_size             : std_logic_vector(7 downto 0);
    channel_id              : std_logic_vector(7 downto 0);
    IM                      : std_logic;
  end record;  

  type rxram_pointer_t is
  record
    rst                     : std_logic;
    ptr_inc                 : std_logic;
    ptr_dec                 : std_logic;
  end record;

  type inject_error_t is
  record
    header_1bit             : std_logic;
    header_2bit             : std_logic;
    CC_2bit                 : std_logic;
    CRC_1bit                : std_logic;
    index_1bit              : std_logic;
    CC_1bit                 : std_logic;
  end record;

  type txCtrlnStatus_t_v  is array (natural range <>) of txCtrlnStatus_t;
  type linkStatusInfo_t_v is array (natural range <>) of linkStatusInfo_t;
  type rxram_pointer_t_v  is array (natural range <>) of rxram_pointer_t;
  type linkRxMetadata_t_v is array (natural range <>) of linkRxMetadata_t;
  type invalidTxComp_t_v  is array (natural range <>) of invalidTxComp_t;
  type inject_error_t_v   is array (natural range <>) of inject_error_t;

end package;
