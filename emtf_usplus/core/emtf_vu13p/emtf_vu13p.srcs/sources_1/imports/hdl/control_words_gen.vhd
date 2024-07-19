----------------------------------------------------------------------------------
-- control words generation, kadamidi, 2020
-- generates the control words of CSP and implements the Hamming encoding
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.package_links.all;


entity control_words_gen is
  generic(
    INDEX                  : integer;
    CH                     : integer
    );
  port(
    clk                    : in  std_logic;
    reset                  : in  std_logic;
    data_in                : in  std_logic_vector(63 downto 0) := (others => '0');
    crc_word_in            : in  std_logic_vector(16 downto 0) := (others => '0');
    valid_bit_in           : in  std_logic;
    tx_gb_read_en_in       : in  std_logic;
    pad_in                 : in  std_logic;
    crc_filler_flag_in     : in  std_logic;
    align_tag_in           : in  std_logic;
    tx_idle_method_in      : in  std_logic;
    upstream_link_error_in : in  std_logic;
    txMetadata_in          : in  linkTxMetadata_t;
    control_word_out       : out std_logic_vector(63 downto 0) := (others => '0');
    control_word_flag_out  : out std_logic;
    idle_method_flag_out   : out std_logic
    );
end control_words_gen;


architecture behavioral of control_words_gen is

  constant IDLE : integer     := 0;
  constant CRC  : integer     := 1;
  constant DATA : integer     := 2;
  constant TAG  : integer     := 3;
  constant PAD  : integer     := 4;

  signal tx_frame_sel       : integer;
  signal sel                : std_logic_vector(3 downto 0)  := (others => '0');
  signal filler_payload_i   : std_logic_vector(55 downto 0) := (others => '0');
  signal hamming_parity     : std_logic_vector(3 downto 0)  := (others => '0');
  signal control_type       : std_logic_vector(3 downto 0)  := (others => '0');
  signal control_payload    : std_logic_vector(55 downto 0) := (others => '0');
  signal link_id0_payload_i : std_logic_vector(55 downto 0) := (others => '0');
  signal link_id1_payload_i : std_logic_vector(55 downto 0) := (others => '0');
  signal tag_payload_i      : std_logic_vector(55 downto 0) := (others => '0');
  signal crc_payload_i      : std_logic_vector(55 downto 0) := (others => '0');
  signal hamming_byte       : std_logic_vector(7 downto 0)  := (others => '0');
  signal crc_filler_i       : std_logic                     := '0';
  signal link_id_filler     : std_logic                     := '0';
  signal filler_flag_i      : std_logic                     := '0';
  signal idle_method_flag   : std_logic                     := '0';

  attribute keep                   : string;


begin

-- select frame to be transmitted 
--===========================================================================================================
  fillers_gen : entity work.filler_words
    generic map(
      INDEX       => INDEX,
      CH          => CH)
    port map(
      clk                         => clk,
      reset                       => reset,
      tx_frame_sel                => tx_frame_sel,
      crc_word_in                 => crc_word_in(15 downto 0),
      tx_gb_read_en_in            => tx_gb_read_en_in,
      filler_flag_in              => filler_flag_i,
      upstream_link_error_flag_in => upstream_link_error_in,
      tx_idle_method_in           => tx_idle_method_in,
      txMetadata_in               => txMetadata_in,
      link_id0_payload_out        => link_id0_payload_i, 
      link_id1_payload_out        => link_id1_payload_i,
      tag_payload_out             => tag_payload_i,      
      crc_payload_out             => crc_payload_i      
      ); 


  sel <= align_tag_in & valid_bit_in & pad_in & crc_filler_flag_in;

  -- frame to be transmitted
  tx_frame_sel <= CRC  when sel = "0001" or sel = "0101"  else  -- CRC
                  TAG  when sel = "1000" or sel = "1100" or sel = "1010" or sel = "1110" else  -- TAG   
                  DATA when sel = "0100"                                                 else  -- DATA          
                  IDLE when sel = "0000"                                                 else  -- IDLE 
                  PAD;                                                                         -- PAD            
--===========================================================================================================

-- CMS Standard Protocol
--===========================================================================================================
    process(clk)
    begin
      if rising_edge(clk) then
        if reset = '1' then
          control_payload       <= link_id0_payload_i;
          control_type          <= PAD0_CODE;
          link_id_filler        <= '0';
          filler_flag_i         <= '1';
          control_word_flag_out <= '1';
          idle_method_flag      <= '0';
        else
          case tx_frame_sel is
          
            when IDLE =>
              --
              if tx_idle_method_in = '0' then
                idle_method_flag      <= '0';
              else
                idle_method_flag      <= '1';
              end if;
                
              control_type          <= IDLE_CODE;
              control_payload       <= IDLE_WORD;
              control_word_flag_out <= '1';
              filler_flag_i         <= '0';
              
            when CRC =>
              control_type          <= CRCV_CODE;
              control_payload       <= crc_payload_i;
              control_word_flag_out <= '1';
              filler_flag_i         <= '1';
              idle_method_flag      <= '0';  
              
            when TAG =>
              control_type        <= TAG_CODE;
              control_payload       <= tag_payload_i;
              control_word_flag_out <= '1';
              filler_flag_i         <= '1';
              idle_method_flag      <= '0';              

            when PAD =>
              if link_id_filler = '0' then
                  control_type      <= PAD0_CODE;
                  control_payload   <= link_id0_payload_i;
              else
                  control_type      <= PAD1_CODE;       
                  control_payload   <= link_id1_payload_i;  
              end if;
              control_word_flag_out <= '1';
              link_id_filler        <= not link_id_filler;
              filler_flag_i         <= '1';
              idle_method_flag      <= '0';
              
            when DATA =>
              control_type          <= (others => '0');
              control_payload       <= (others => '0');
              control_word_flag_out <= '0';
              filler_flag_i         <= '0';
              idle_method_flag      <= '0';
              
            when others =>
              control_type          <= PAD0_CODE;
              control_payload       <= link_id0_payload_i;
              control_word_flag_out <= '1';
              filler_flag_i         <= '1';
              idle_method_flag      <= '0';
          end case;
        end if;
      end if;
    end process;

    -- 1 cc delayed
    -- Calculate TX hamming(8,4) header 
    --===========================================================================================================    
    hamming_parity(3) <= (control_type(0) xor control_type(1)) xor control_type(2);
    hamming_parity(2) <= (control_type(1) xor control_type(2)) xor control_type(3);  
    hamming_parity(1) <= (control_type(0) xor control_type(2)) xor control_type(3);
    hamming_parity(0) <= (control_type(0) xor control_type(1)) xor control_type(3);
   
    hamming_byte <= hamming_parity & control_type;
    --===========================================================================================================

    -- out control word
    control_word_out <= hamming_byte & control_payload;
    idle_method_flag_out <= idle_method_flag;
--===========================================================================================================

end behavioral;
