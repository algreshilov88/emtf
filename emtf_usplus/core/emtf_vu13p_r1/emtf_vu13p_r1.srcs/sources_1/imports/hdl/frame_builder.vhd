----------------------------------------------------------------------------------
-- CSTLP frame builder, kadamidi, 2021
-- builds the CSP output 64 bit frames
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;

use work.package_links.all;

entity frame_builder is
  generic(
    INDEX                  : integer;
    CH                     : integer);
  port(
    txusrclk               : in  std_logic;
    rst_tx                 : in  std_logic;
    data_in                : in  std_logic_vector(63 downto 0) := (others => '0');
    crc_word_in            : in  std_logic_vector(16 downto 0) := (others => '0');
    pad_in                 : in  std_logic;
    valid_bit_in           : in  std_logic;
    tx_gb_datavalid_in     : in  std_logic;
    crc_filler_flag_in     : in  std_logic;
    align_tag_in           : in  std_logic;
    tx_idle_method_in      : in  std_logic;
    upstream_link_error_in : in  std_logic;
    txMetadata_in          : in  linkTxMetadata_t;
    data_out               : out std_logic_vector(63 downto 0) := (others => '0');
    header_out             : out std_logic_vector(2 downto 0);
    tx_gb_datavalid_out    : out std_logic
    );
end frame_builder;


architecture behavioral of frame_builder is

  signal data_p              : std_logic_vector(63 downto 0) := (others => '0');
  signal control_word_i      : std_logic_vector(63 downto 0) := (others => '0');
  signal control_word_flag_i : std_logic                     := '0';
  signal tx_gb_datavalid_i1  : std_logic                     := '0';
  signal tx_idle_method_flag : std_logic                     := '0';

begin

-- Creates Control Words to be transmitted
--===========================================================================================================
  control_words : entity work.control_words_gen
    generic map(
      INDEX                  => INDEX,
      CH                     => CH
      )
    port map(
      clk                    => txusrclk,
      reset                  => rst_tx,
      data_in                => data_in,
      valid_bit_in           => valid_bit_in,
      crc_word_in            => crc_word_in,
      tx_gb_read_en_in       => tx_gb_datavalid_in,
      pad_in                 => pad_in,
      crc_filler_flag_in     => crc_filler_flag_in,
      align_tag_in           => align_tag_in,
      tx_idle_method_in      => tx_idle_method_in,
      upstream_link_error_in => upstream_link_error_in,
      txMetadata_in          => txMetadata_in,
      control_word_out       => control_word_i,
      control_word_flag_out  => control_word_flag_i,
      idle_method_flag_out   => tx_idle_method_flag
      );

  process(txusrclk)
  begin
    if rising_edge(txusrclk) then
      data_p             <= data_in;
      tx_gb_datavalid_i1 <= tx_gb_datavalid_in;
    end if;
  end process;
--===========================================================================================================

-- Out Data and Header
--===========================================================================================================
-- when control_word_flag_i bit is 0 we send DATA
-- when control_word_flag_i bit is 1 we send Contro Words
  
  -- Out Ports
  data_out            <= control_word_i when control_word_flag_i = '1' else data_p; 
                         
  header_out          <= "010"  when control_word_flag_i = '1' and tx_idle_method_flag = '0' else     -- idles with control word header
                         "101"  when control_word_flag_i = '1' and tx_idle_method_flag = '1' else     -- idles with data word header
                         "101";                                                                       -- data header
                               
  tx_gb_datavalid_out <= tx_gb_datavalid_i1;              
--===========================================================================================================


end behavioral;
