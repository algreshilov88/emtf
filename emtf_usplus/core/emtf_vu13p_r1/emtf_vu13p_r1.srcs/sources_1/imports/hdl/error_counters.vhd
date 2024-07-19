----------------------------------------------------------------------------------
-- additional error counters - kadamidi - 2021
-- counts potential hard errors, single bit and double bit errors of the 
-- control word type field
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use IEEE.std_logic_unsigned.all;

use work.package_links.all;

entity error_counters is
  port (
    rxusrclk                 : in  std_logic;
    rst_rx                   : in  std_logic;
    rst_counters             : in  std_logic;
    rxdata_in                : in  std_logic_vector(63 downto 0);
    rxdata_header_in         : in  std_logic_vector(2 downto 0);
    valid_bit_in             : in  std_logic;
    rxdatavalid_in           : in  std_logic;
    cwt_single_error_in      : in  std_logic;
    cwt_double_error_in      : in  std_logic;
    hard_error_cnt_out       : out std_logic_vector(3 downto 0);
    cwt_single_error_cnt_out : out std_logic_vector(3 downto 0);
    cwt_double_error_cnt_out : out std_logic_vector(3 downto 0)
    );

end error_counters;


architecture RTL of error_counters is

  signal hard_error_cnt       : std_logic_vector (3 downto 0);
  signal cwt_single_error_cnt : std_logic_vector (3 downto 0);
  signal cwt_double_error_cnt : std_logic_vector (3 downto 0);
  signal hard_error           : std_logic;

begin

  -- detect hard (or 3bit header) errors
  process(rxusrclk)
  begin
    if rising_edge(rxusrclk) then
      if rst_rx = '1' then
        hard_error    <= '0';
      else
        if rxdatavalid_in = '1' then
          if (rxdata_header_in = "101" or rxdata_header_in = "010") then
            hard_error <= '0';
          else
            hard_error <= '1';
          end if;
        else
          hard_error <= '0';
        end if;
      end if;
    end if;
  end process;

  process(rxusrclk)
  begin
    if rising_edge(rxusrclk) then
      if rst_counters = '1' or rst_rx = '1' then
        cwt_single_error_cnt <= (others => '0');
        cwt_double_error_cnt <= (others => '0');
        hard_error_cnt       <= (others => '0');
      else
        if cwt_single_error_in = '1' and cwt_single_error_cnt /= x"F" then
          cwt_single_error_cnt <= cwt_single_error_cnt + 1;
        end if;
        if cwt_double_error_in = '1' and cwt_double_error_cnt /= X"f" then
          cwt_double_error_cnt <= cwt_double_error_cnt + 1;
        end if;
        if hard_error = '1' and hard_error_cnt /= X"f" then
          hard_error_cnt <= hard_error_cnt + 1;
        end if;      
      end if;
    end if;
  end process;

  hard_error_cnt_out        <= hard_error_cnt;
  cwt_single_error_cnt_out  <= cwt_single_error_cnt;
  cwt_double_error_cnt_out  <= cwt_double_error_cnt;

end RTL;
