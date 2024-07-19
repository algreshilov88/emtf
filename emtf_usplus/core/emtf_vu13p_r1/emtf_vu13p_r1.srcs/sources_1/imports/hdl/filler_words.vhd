----------------------------------------------------------------------------------
-- Filler Words, kadamidi, 2020 
-- generates the filler words of CSP
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use work.package_links.all;
use work.emp_project_decl.all;

entity filler_words is
  generic(
    INDEX                       : integer;
    CH                          : integer);
  port(
    clk                         : in  std_logic;
    reset                       : in  std_logic;
    tx_frame_sel                : in  integer;
    crc_word_in                 : in  std_logic_vector(15 downto 0);
    tx_gb_read_en_in            : in  std_logic;
    filler_flag_in              : in  std_logic;
    upstream_link_error_flag_in : in  std_logic;
    tx_idle_method_in           : in  std_logic;
    txMetadata_in               : in  linkTxMetadata_t;
    link_id0_payload_out        : out std_logic_vector(55 downto 0) := (others => '0');
    link_id1_payload_out        : out std_logic_vector(55 downto 0) := (others => '0');
    tag_payload_out             : out std_logic_vector(55 downto 0) := (others => '0');
    crc_payload_out             : out std_logic_vector(55 downto 0) := (others => '0')
    );
end filler_words;


architecture behavioral of filler_words is

  constant CRC  : integer := 1;
  constant TAG  : integer := 3;
  constant PAD  : integer := 4;
  
  signal index_number           : std_logic_vector(3 downto 0);
  signal special_status_parity  : std_logic_vector(3 downto 0);
  signal special_status_encoded : std_logic_vector(7 downto 0);
  signal channel_id             : std_logic_vector(7 downto 0);
  signal special_status         : std_logic_vector(3 downto 0);
  signal clk_multiplier         : std_logic_vector(3 downto 0);
  signal crc_valid              : std_logic;
  signal read_en_p              : std_logic;
  signal tx_datavalid_p         : std_logic;
  signal crc_valid_d            : std_logic;
  signal idle_method_i          : std_logic;

  attribute keep                       : string;
  attribute keep of link_id0_payload_out : signal is "true";
  attribute keep of link_id1_payload_out : signal is "true";
  attribute keep of tag_payload_out : signal is "true";
  attribute keep of crc_payload_out : signal is "true";

begin

  -- Calculate Special status hamming(8,4) header 
  --===========================================================================================================    
  -- bits 2 downto 0 are reserved
  special_status <= upstream_link_error_flag_in & "000";
  
  special_status_parity(3) <= (special_status(0) xor special_status(1)) xor special_status(2);
  special_status_parity(2) <= (special_status(1) xor special_status(2)) xor special_status(3);  
  special_status_parity(1) <= (special_status(0) xor special_status(2)) xor special_status(3);
  special_status_parity(0) <= (special_status(0) xor special_status(1)) xor special_status(3);
  
  special_status_encoded   <= special_status_parity & special_status;
  --===========================================================================================================    

  -- region and channel number
  channel_id    <= std_logic_vector(to_unsigned(INDEX, 6)) & std_logic_vector(to_unsigned(CH, 2));

  -- transmission Idle Method
  idle_method_i <= tx_idle_method_in;
  
  -- LHC Clock Multiplier / Clock Ration
  clk_multiplier <= std_logic_vector(to_unsigned(CLOCK_RATIO, 4));

  -- build payload of filler control words as specified by CSP
  -- Link Id 0 - Type Field (63 : 56) & Index (55 :52) & Reserved(51 : 32) & Reserved (31 downto 20) & Crate/Subsystem ID (19 : 12) & Slot ID (11 : 8) & Channel ID (7 : 0) 
  link_id0_payload_out(55 downto 0) <= index_number & CONTROL_RESERVED & ZEROS_RESERVED(11 downto 0) & txMetadata_in.crate_id & txMetadata_in.slot_id & channel_id;
  -- Link Id 1 - Type Field (63 : 56) & Index (55 :52) & Reserved(51 : 32) & Reserved (31 downto 14) & Idle Method (17) & TM Interval (16 : 12) & Packet Size (11 : 4) & LHC clock multiplier (3:0) 
  link_id1_payload_out(55 downto 0) <= index_number & CONTROL_RESERVED & ZEROS_RESERVED(13 downto 0) & idle_method_i & txMetadata_in.tm_interval(CH) & txMetadata_in.packet_payload_size(CH) & clk_multiplier;
  tag_payload_out(55 downto 0)      <= index_number & CONTROL_RESERVED & ZEROS_RESERVED;
  crc_payload_out(55 downto 0)      <= index_number & CONTROL_RESERVED & special_status_encoded & ZEROS_RESERVED(7 downto 0) & crc_word_in; -- reserved(7 downto 0) is for crc 24

  -- index correction counter
  process(clk)
    variable cntr : integer := 0;
    variable error_intr_cntr : integer := 0;
  begin
    if rising_edge(clk) then
        if reset = '1' then
            index_number <= X"0";
            cntr := 0;
        else
            if (tx_frame_sel = PAD or tx_frame_sel = CRC or tx_frame_sel = TAG) and tx_gb_read_en_in = '1' then
                if cntr < 15 then
                    cntr := cntr + 1;
                else
                    cntr := 0;
                end if;
            end if;
            index_number <= std_logic_vector(to_unsigned(cntr,4));
        end if;
    end if;
    end process;

end behavioral;
