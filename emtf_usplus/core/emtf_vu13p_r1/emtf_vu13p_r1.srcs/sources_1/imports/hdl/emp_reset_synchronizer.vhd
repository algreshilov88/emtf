
library IEEE;
use IEEE.STD_LOGIC_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity emp_reset_synchronizer is
  port (clk_in  : in  std_logic;
        rst_in  : in  std_logic;
        rst_out : out std_logic);
end emp_reset_synchronizer;


architecture Behavioral of emp_reset_synchronizer is

  signal rst_in_meta  : std_logic;
  signal rst_in_sync1 : std_logic;
  signal rst_in_out   : std_logic;

  attribute ASYNC_REG                 : string;
  attribute ASYNC_REG of rst_in_meta  : signal is "TRUE";
  attribute ASYNC_REG of rst_in_sync1 : signal is "TRUE";

begin

  process(clk_in)
  begin
    if rising_edge(clk_in) then
      if (rst_in = '1') then
        rst_in_meta  <= '1';
        rst_in_sync1 <= '1';
        rst_in_out   <= '1';
      else
        rst_in_meta  <= '0';
        rst_in_sync1 <= rst_in_meta;
        rst_in_out   <= rst_in_sync1;
      end if;
    end if;
  end process;

  rst_out <= rst_in_out;

end Behavioral;


