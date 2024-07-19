----------------------------------------------------------------------------------
-- tx 65b67b scrambler, kadamidi, 2021
-- 65b67b srambler
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.package_links.all;


entity scrambler_6567 is
  port(
    txusrclk           : in  std_logic                                 := '0';
    reset              : in  std_logic                                 := '0';
    txdata_in          : in  std_logic_vector(DATA_WIDTH - 1 downto 0)     := (others => '0');
    txheader_in        : in  std_logic_vector(2 downto 0)              := (others => '0');
    tx_datavalid_in    : in  std_logic                                 := '0';
    txsequence_in      : in  std_logic_vector(6 downto 0)              := (others => '0');
    tx_datavalid_out   : out std_logic                                 := '0';
    scrambled_data_out : out std_logic_vector(DATA_WIDTH - 1 downto 0) := (others => '0');
    txheader_out       : out std_logic_vector(5 downto 0)              := (others => '0');
    txsequence_out     : out std_logic_vector(6 downto 0)              := (others => '0')
    );

end scrambler_6567;

architecture Behavioral of scrambler_6567 is

  component SCRAMBLER_BLOCK
    port (
      unscrambled_data_in : in  std_logic_vector(DATA_WIDTH downto 0)     := (others => '0');
      data_valid_in       : in  std_logic                                 := '0';
      scrambled_data_out  : out std_logic_vector(DATA_WIDTH downto 0) := (others => '0');
      user_clk            : in  std_logic                                 := '0';
      system_reset        : in  std_logic                                 := '0'
      );
  end component;

  signal data_in_65b      : std_logic_vector(64 downto 0) := (others => '0');
  signal scrambled_data_o : std_logic_vector(64 downto 0) := (others => '0');
  signal txheader_l1      : std_logic_vector(1 downto 0)  := (others => '0');
  signal txsequence_l1    : std_logic_vector(6 downto 0)  := (others => '0');
  

begin

  process(txusrclk)
  begin
    if rising_edge(txusrclk) then
       -- delay 1 cc to match scrambler delay
      txheader_l1      <= txheader_in(1 downto 0);
      tx_datavalid_out <= tx_datavalid_in;
      txsequence_l1    <= txsequence_in;
    end if;
  end process;

  data_in_65b <= txheader_in(2) & txdata_in;

  scrambler_65b : SCRAMBLER_BLOCK
    port map(
      unscrambled_data_in => data_in_65b,
      data_valid_in       => tx_datavalid_in,
      scrambled_data_out  => scrambled_data_o,
      user_clk            => txusrclk,
      system_reset        => reset
      );

  scrambled_data_out <= scrambled_data_o(63 downto 0);
  txheader_out       <= "000" & scrambled_data_o(64) & txheader_l1;
  txsequence_out     <= txsequence_l1;
  
   
end Behavioral;
