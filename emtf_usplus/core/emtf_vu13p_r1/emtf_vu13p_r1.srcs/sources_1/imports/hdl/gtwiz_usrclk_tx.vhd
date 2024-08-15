----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/02/2020 11:15:19 AM
-- Design Name: 
-- Module Name: gtwiz_usrclk_rx - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity gtwiz_usrclk_tx is
  generic(
    USRCLK2_DIV : integer
    );
  port (
    txoutclk_in            : in  std_logic;
    userclk_tx_reset_in    : in  std_logic;
    userclk_tx_usrclk_out  : out std_logic;
    userclk_tx_usrclk2_out : out std_logic;
    userclk_tx_active_out  : out std_logic
    );
end gtwiz_usrclk_tx;

architecture Behavioral of gtwiz_usrclk_tx is

  signal userclk_tx_usrclk2_i         : std_logic;
  signal gtwiz_userclk_tx_active_meta : std_logic;
  signal gtwiz_userclk_tx_active_sync : std_logic;
  signal usrclk2div                   : std_logic_vector(2 downto 0);

  attribute ASYNC_REG                                 : string;
  attribute ASYNC_REG of gtwiz_userclk_tx_active_meta : signal is "TRUE";
  attribute ASYNC_REG of gtwiz_userclk_tx_active_sync : signal is "TRUE";
begin

  bufg_gt_txusrclk_inst : bufg_gt
    port map (
      O       => userclk_tx_usrclk_out,
      I       => txoutclk_in,
      CE      => '1',
      DIV     => "000",
      CLR     => userclk_tx_reset_in,
      CLRMASK => '0',
      CEMASK  => '0'
      );

  usrclk2div <= std_logic_vector(to_unsigned(USRCLK2_DIV, 3));

  bufg_gt_txusrclk2_inst : bufg_gt
    port map (
      O       => userclk_tx_usrclk2_i,
      I       => txoutclk_in,
      CE      => '1',
      DIV     => usrclk2div,
      CLR     => userclk_tx_reset_in,
      CLRMASK => '0',
      CEMASK  => '0'
      );

  userclk_tx_usrclk2_out <= userclk_tx_usrclk2_i;
  userclk_tx_active_out  <= gtwiz_userclk_tx_active_sync;

  activetxUsrClk_proc : process(userclk_tx_reset_in, userclk_tx_usrclk2_i)
  begin
    if userclk_tx_reset_in = '1' then
      gtwiz_userclk_tx_active_meta <= '0';
      gtwiz_userclk_tx_active_sync <= '0';
    elsif rising_edge(userclk_tx_usrclk2_i) then
      gtwiz_userclk_tx_active_meta <= '1';
      gtwiz_userclk_tx_active_sync <= gtwiz_userclk_tx_active_meta;
    end if;

  end process;

end Behavioral;
