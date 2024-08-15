--------------------------------------------------------------------------------
-- gtwiz_usrclk_rx - kadamidi - 2021
-- implements a simple receiver user clocking network following the Xilinx 
-- example design
--------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
library UNISIM;
use UNISIM.VComponents.all;

entity gtwiz_usrclk_rx is
  generic(
    USRCLK2_DIV : integer
    );
  port (
    rxoutclk_in            : in  std_logic;
    userclk_rx_reset_in    : in  std_logic;
    userclk_rx_usrclk_out  : out std_logic;
    userclk_rx_usrclk2_out : out std_logic;
    userclk_rx_active_out  : out std_logic
    );
end gtwiz_usrclk_rx;

architecture Behavioral of gtwiz_usrclk_rx is

  signal userclk_rx_usrclk2_i         : std_logic;
  signal gtwiz_userclk_rx_active_meta : std_logic;
  signal gtwiz_userclk_rx_active_sync : std_logic;
  signal usrclk2div                   : std_logic_vector(2 downto 0);

  attribute ASYNC_REG                                 : string;
  attribute ASYNC_REG of gtwiz_userclk_rx_active_meta : signal is "TRUE";
  attribute ASYNC_REG of gtwiz_userclk_rx_active_sync : signal is "TRUE";
begin

  bufg_gt_rxusrclk_inst : bufg_gt
    port map (
      O       => userclk_rx_usrclk_out,
      I       => rxoutclk_in,
      CE      => '1',
      DIV     => "000",
      CLR     => userclk_rx_reset_in,
      CLRMASK => '0',
      CEMASK  => '0'
      );

  usrclk2div <= std_logic_vector(to_unsigned(USRCLK2_DIV, 3));

  bufg_gt_rxusrclk2_inst : bufg_gt
    port map (
      O       => userclk_rx_usrclk2_i,
      I       => rxoutclk_in,
      CE      => '1',
      DIV     => usrclk2div,
      CLR     => userclk_rx_reset_in,
      CLRMASK => '0',
      CEMASK  => '0'
      );

  userclk_rx_usrclk2_out <= userclk_rx_usrclk2_i;
  userclk_rx_active_out  <= gtwiz_userclk_rx_active_sync;

  activetxUsrClk_proc : process(userclk_rx_reset_in, userclk_rx_usrclk2_i)
  begin
    if userclk_rx_reset_in = '1' then
      gtwiz_userclk_rx_active_meta <= '0';
      gtwiz_userclk_rx_active_sync <= '0';
    elsif rising_edge(userclk_rx_usrclk2_i) then
      gtwiz_userclk_rx_active_meta <= '1';
      gtwiz_userclk_rx_active_sync <= gtwiz_userclk_rx_active_meta;
    end if;

  end process;

end Behavioral;
