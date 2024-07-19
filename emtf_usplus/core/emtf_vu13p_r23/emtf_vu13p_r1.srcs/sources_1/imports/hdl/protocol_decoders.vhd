----------------------------------------------------------------------------------
-- CSP decoding blocks - kadamidi - 2021
-- contains the first decoding blocks of the received data. First descramble 
-- and then decode the hamming codes
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use work.package_links.all;


entity protocol_decoders is
    port(
      rxusrclk             : in  std_logic;
      rst_rx               : in  std_logic;
      rst_counters         : in  std_logic;
      rxdata_in            : in  std_logic_vector(DATA_WIDTH - 1 downto 0);
      rx_datavalid_in      : in  std_logic;
      rxheader_in          : in  std_logic_vector(2 downto 0);
      valid_bit_out        : out std_logic;
      unscrambled_data_out : out std_logic_vector(DATA_WIDTH - 1 downto 0);
      rx_datavalid_out     : out std_logic;
      linkStatusInfo_out   : out linkStatusInfo_t
      );
end protocol_decoders;

architecture Behavioral of protocol_decoders is

    signal cwt_single_error_i   : std_logic;
    signal cwt_double_error_i   : std_logic;
    signal rx_datavalid_i1      : std_logic;
    signal rx_datavalid_i2      : std_logic;
    signal unscrambled_data_i1  : std_logic_vector(DATA_WIDTH - 1 downto 0);
    signal unscrambled_data_i2  : std_logic_vector(DATA_WIDTH - 1 downto 0);
    signal rxheader_i1          : std_logic_vector(2 downto 0);
    signal rxheader_i2          : std_logic_vector(2 downto 0);
    signal valid_bit_i1         : std_logic;
    signal valid_bit_i2         : std_logic;


begin

    -- pipeline signals to match propagation delays
    process(rxusrclk)
    begin
      if rising_edge(rxusrclk) then
        -- delay of 1 cc to match descrambler latency
        rx_datavalid_i1 <= rx_datavalid_in;
        -- delay of 1 cc to hamming decoder latency
        rx_datavalid_i2 <= rx_datavalid_i1;
--        valid_bit_i2    <= valid_bit_i1;
        rxheader_i2     <= rxheader_i1;
      end if;
    end process;
    
    -- descramble data
    -- level0 in - level1 out
    --============================================================================================================================
    descrambler : entity work.descrambler_6567
      port map(
        rxusrclk                 => rxusrclk,
        rst_rx                   => rst_rx,
        rxdata_in                => rxdata_in,
        rxheader_in              => rxheader_in,
        rx_datavalid_in          => rx_datavalid_in,
        unscrambled_data_out     => unscrambled_data_i1,
        rxheader_out             => rxheader_i1,
        valid_bit_out            => valid_bit_i2
        );
    --============================================================================================================================


    -- decode received control word type
    -- level 1 in - level 2 out
    --============================================================================================================================  
    decoder : entity work.hamming_dececoder
      port map(
        rxusrclk                 => rxusrclk,
        rst_rx                   => rst_rx,
        rxdata_in                => unscrambled_data_i1,
        valid_bit_in             => valid_bit_i2,
        rx_datavalid_in          => rx_datavalid_i2,
        rxdata_out               => unscrambled_data_i2,
        cwt_single_error_out     => cwt_single_error_i,
        cwt_double_error_out     => cwt_double_error_i
        );
    --============================================================================================================================


    -- additional error counters
    --============================================================================================================================
    additional_error_counters : entity work.error_counters
      port map(
        rxusrclk                 => rxusrclk,
        rst_rx                   => rst_rx,
        rst_counters             => rst_counters,
        rxdata_in                => unscrambled_data_i2,
        rxdata_header_in         => rxheader_i2,
        valid_bit_in             => valid_bit_i2,
        rxdatavalid_in           => rx_datavalid_i2,
        cwt_single_error_in      => cwt_single_error_i,
        cwt_double_error_in      => cwt_double_error_i,
        hard_error_cnt_out       => linkStatusInfo_out.hard_errors,
        cwt_single_error_cnt_out => linkStatusInfo_out.cwt_single_errors,
        cwt_double_error_cnt_out => linkStatusInfo_out.cwt_double_errors
        );
    --============================================================================================================================


    -- out ports
    --============================================================================================================================
    unscrambled_data_out <= unscrambled_data_i2;
    valid_bit_out        <= valid_bit_i2;  
    rx_datavalid_out     <= rx_datavalid_i2;
    --============================================================================================================================

end Behavioral;
