----------------------------------------------------------------------
----                                                              ----
---- Ultimate CRC.                                                ----
----                                                              ----
---- This file is part of the ultimate CRC projectt               ----
---- http://www.opencores.org/cores/ultimate_crc/                 ----
----                                                              ----
---- Description                                                  ----
---- CRC generator/checker, parallel implementation.              ----
----                                                              ----
----                                                              ----
---- To Do:                                                       ----
---- -                                                            ----
----                                                              ----
---- Author(s):                                                   ----
---- - Geir Drange, gedra@opencores.org                           ----
----                                                              ----
----------------------------------------------------------------------
----                                                              ----
---- Copyright (C) 2005 Authors and OPENCORES.ORG                 ----
----                                                              ----
---- This source file may be used and distributed without         ----
---- restriction provided that this copyright statement is not    ----
---- removed from the file and that any derivative work contains  ----
---- the original copyright notice and the associated disclaimer. ----
----                                                              ----
---- This source file is free software; you can redistribute it   ----
---- and/or modify it under the terms of the GNU General          ----
---- Public License as published by the Free Software Foundation; ----
---- either version 2.0 of the License, or (at your option) any   ----
---- later version.                                               ----
----                                                              ----
---- This source is distributed in the hope that it will be       ----
---- useful, but WITHOUT ANY WARRANTY; without even the implied   ----
---- warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      ----
---- PURPOSE. See the GNU General Public License for more details.----
----                                                              ----
---- You should have received a copy of the GNU General           ----
---- Public License along with this source; if not, download it   ----
---- from http://www.gnu.org/licenses/gpl.txt                     ----
----                                                              ----
----------------------------------------------------------------------
--
-- CVS Revision History
--
-- $Log: ucrc_par.vhd,v $
-- Revision 1.1  2005/05/09 15:58:38  gedra
-- Parallel implementation
--
--
--

library ieee;
use ieee.std_logic_1164.all;

entity ucrc_par is
    generic (
        POLYNOMIAL : std_logic_vector;
        INIT_VALUE : std_logic_vector;
        DATA_WIDTH : integer range 2 to 256
        );  
    port (
        clk_i   : in  std_logic;        -- clock
        rst_i   : in  std_logic;        -- init CRC
        clken_i : in  std_logic;        -- clock enable
        data_i  : in  std_logic_vector(DATA_WIDTH - 1 downto 0);  -- data input
        match_o : out std_logic;        -- CRC match flag
        crc_o   : out std_logic_vector(POLYNOMIAL'length - 1 downto 0));  -- CRC output
end ucrc_par;

architecture rtl of ucrc_par is

    constant msb      : integer                        := POLYNOMIAL'length - 1;
    constant init_msb : integer                        := INIT_VALUE'length - 1;
    constant p        : std_logic_vector(msb downto 0) := POLYNOMIAL;
    constant dw       : integer                        := DATA_WIDTH;
    constant pw       : integer                        := POLYNOMIAL'length;
    type fb_array is array (dw downto 1) of std_logic_vector(msb downto 0);
    type dmsb_array is array (dw downto 1) of std_logic_vector(msb downto 1);
    signal crca       : fb_array;
    signal da, ma     : dmsb_array;
    signal crc, crc_r, zero  : std_logic_vector(msb downto 0) := (others=>'0');

begin

-- Parameter checking: Invalid generics will abort simulation/synthesis
    PCHK1 : if msb /= init_msb generate
        process
        begin
            report "POLYNOMIAL and INIT_VALUE vectors must be equal length!"
                severity failure;
            wait;
        end process;
    end generate PCHK1;

    PCHK2 : if (msb < 3) or (msb > 31) generate
        process
        begin
            report "POLYNOMIAL must be of order 4 to 32!"
                severity failure;
            wait;
        end process;
    end generate PCHK2;

    PCHK3 : if p(0) /= '1' generate     -- LSB must be 1
        process
        begin
            report "POLYNOMIAL must have lsb set to 1!"
                severity failure;
            wait;
        end process;
    end generate PCHK3;

-- Generate vector of each data bit
    CA : for i in 1 to dw generate      -- data bits
        DAT : for j in 1 to msb generate
            da(i)(j) <= data_i(i - 1);
        end generate DAT;
    end generate CA;

-- Generate vector of each CRC MSB
    MS0 : for i in 1 to msb generate
        ma(1)(i) <= crc(msb);
    end generate MS0;
    MSP : for i in 2 to dw generate
        MSU : for j in 1 to msb generate
            ma(i)(j) <= crca(i - 1)(msb);
        end generate MSU;
    end generate MSP;

-- Generate feedback matrix
    crca(1)(0)            <= da(1)(1) xor crc(msb);
    crca(1)(msb downto 1) <= crc(msb - 1 downto 0) xor ((da(1) xor ma(1)) and p(msb downto 1));
    FB : for i in 2 to dw generate
        crca(i)(0)            <= da(i)(1) xor crca(i - 1)(msb);
        crca(i)(msb downto 1) <= crca(i - 1)(msb - 1 downto 0) xor
                                 ((da(i) xor ma(i)) and p(msb downto 1));
    end generate FB;


-- CRC process
    crc_o <= crc_r;
    zero  <= (others => '0');

-- Modification by Greg to allow back to back frames (i.e. reset can take place while new data loaded)
    crc <= INIT_VALUE when rst_i = '1' else crc_r;

    CRCP : process (clk_i)
    begin
        if rising_edge(clk_i) then
            if rst_i = '1' and clken_i = '0' then
              crc_r     <= INIT_VALUE;
              match_o <= '0';
            elsif clken_i = '1' then
                crc_r <= crca(dw);
                if crca(dw) = zero then
                    match_o <= '1';
                else
                    match_o <= '0';
                end if;
            end if;
        end if;
    end process;

end rtl;
