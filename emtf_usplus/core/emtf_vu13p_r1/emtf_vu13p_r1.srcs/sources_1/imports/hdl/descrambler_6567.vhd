----------------------------------------------------------------------------------
-- descrambler 65b67b - kadamidi - 2021
-- implements the 65b67b descrambling of the received data
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use work.package_links.all;


entity descrambler_6567 is
    generic(DATA_WIDTH : natural := 64);
    port(
      rxusrclk             : in  std_logic;
      rst_rx               : in  std_logic;
      rxdata_in            : in  std_logic_vector(DATA_WIDTH - 1 downto 0);
      rx_datavalid_in      : in  std_logic;
      rxheader_in          : in  std_logic_vector(2 downto 0);
      unscrambled_data_out : out std_logic_vector(DATA_WIDTH - 1 downto 0);
      rxheader_out         : out std_logic_vector(2 downto 0);
      valid_bit_out        : out std_logic
      );
end descrambler_6567;

architecture Behavioral of descrambler_6567 is

    component DESCRAMBLER_BLOCK
      port(
        scrambled_data_in    : in  std_logic_vector(DATA_WIDTH downto 0);
        data_valid_in        : in  std_logic;
        unscrambled_data_out : out std_logic_vector(DATA_WIDTH downto 0);
        user_clk             : in  std_logic;
        system_reset         : in  std_logic
        );
    end component;

    signal scrabled_data_65b  : std_logic_vector(64 downto 0);
    signal unscrambled_data_l1: std_logic_vector(64 downto 0);
    signal rxheader_l1        : std_logic_vector(1 downto 0);
    signal rxheader           : std_logic_vector(2 downto 0);
    signal rxheader_out_l2           : std_logic_vector(2 downto 0);
    signal rx_datavalid_l1    : std_logic;

    attribute keep       : string;
    attribute keep of rxheader  : signal is "true";

  function bit_reverse(s1 : std_logic_vector) return std_logic_vector is
    variable rr : std_logic_vector(s1'high downto s1'low);
  begin
    for ii in s1'high downto s1'low loop
      rr(ii) := s1(s1'high-ii);
    end loop;
    return rr;
  end bit_reverse;

begin

  process(rxusrclk)
  begin
    if rising_edge(rxusrclk) then
      -- pipeline the header bits that haven't been scrambled
      rxheader_l1     <= rxheader_in(1 downto 0);
      rx_datavalid_l1 <= rx_datavalid_in;
    end if;
  end process;

  scrabled_data_65b <= rxheader_in(2) & rxdata_in;

  descrambler65 : DESCRAMBLER_BLOCK
    port map(
      USER_CLK             => rxusrclk,
      SYSTEM_RESET         => rst_rx,
      SCRAMBLED_DATA_IN    => scrabled_data_65b,
      DATA_VALID_IN        => rx_datavalid_in,
      UNSCRAMBLED_DATA_OUT => unscrambled_data_l1
      );

  unscrambled_data_out <= unscrambled_data_l1(63 downto 0);
  rxheader             <= unscrambled_data_l1(64) & rxheader_l1;
  rxheader_out         <= rxheader;

    process(rxusrclk)
    begin
    if rising_edge(rxusrclk) then
        if rst_rx = '1' then
            valid_bit_out <= '0';
        else
            if rxheader = "101" or rxheader = "001" or rxheader = "111" or rxheader = "100" then
                valid_bit_out <= '1';
            else
                valid_bit_out <= '0';
            end if;
        end if;
    end if;
    end process;

end Behavioral;
