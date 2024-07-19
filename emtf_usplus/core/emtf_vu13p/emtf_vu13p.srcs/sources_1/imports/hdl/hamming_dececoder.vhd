----------------------------------------------------------------------------------
-- Simple Hamming (8,4) decoder - kadamidi - 2021
-- decodes the hammming 8,4 codes 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use ieee.numeric_std.all;
use work.package_links.all;

entity hamming_dececoder is
  port(
    rxusrclk             : in  std_logic;
    rst_rx               : in  std_logic;
    rxdata_in            : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    rx_datavalid_in      : in  std_logic;
    valid_bit_in         : in  std_logic;
    cwt_single_error_out : out std_logic;
    cwt_double_error_out : out std_logic;
    rxdata_out           : out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
end hamming_dececoder;

architecture Behavioral of hamming_dececoder is

    signal rxdata_i1           : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal rp                  : std_logic_vector(3 downto 0);
    signal rd                  : std_logic_vector(3 downto 0);
    signal cwt                 : std_logic_vector(7 downto 0) := (others => '0'); -- control word type
    signal cwt_i1              : std_logic_vector(7 downto 0); 
    signal s                   : std_logic_vector(3 downto 0);
    signal cwt_single_error_i  : std_logic;
    signal cwt_double_error_i  : std_logic;
    signal parity_check_matrix : type_vector_of_stdlogicvec_x4(7 downto 0);

    attribute DONT_TOUCH    : string;
    attribute keep          : string;

begin

  -- control word type
  cwt <= rxdata_in(63 downto 56);

 
  parity_check_matrix <= ("1000", "1100", "1010", "1001", "1111", "1110", "1101", "1011"); 

  rp <= cwt(7 downto 4);  -- received parity
  rd <= cwt(3 downto 0);  -- received data

  -- Syndrome bits as described in standard protocol spec
  s(3) <= rp(0) xor rp(1) xor rp(2) xor rp(3) xor rd(0) xor rd(1) xor rd(2) xor rd(3);
  s(2) <= rp(2) xor rd(1) xor rd(2) xor rd(3);
  s(1) <= rp(1) xor rd(0) xor rd(2) xor rd(3);
  s(0) <= rp(0) xor rd(0) xor rd(1) xor rd(3);

  process(rxusrclk)
  begin
      if rising_edge(rxusrclk) then
          if rst_rx = '1' then
              rxdata_i1            <= (others=>'0');
              cwt_i1               <= (others=>'0');
              cwt_single_error_i   <= '0';
              cwt_double_error_i   <= '0';
          else
            
            cwt_i1 <= cwt;
                         
            -- s not equal to 0000 means error has occured
            if s /= "0000"  then
                
                -- if s(3) is 0 means we have a double error - cannot be corrected
                if s(3) = '0' then 
                    cwt_single_error_i <= '0';
                    cwt_double_error_i <= '1';
                else
                    -- single error
                    -- loop the parity matrix to detect in which possition the error has occured
                    for i in 0 to 7 loop
                        if s = parity_check_matrix(i) then
                          -- correct the error
                          cwt_i1(i) <= not cwt(i);
                        end if;
                    end loop;
                    
                    cwt_single_error_i <= '1';
                    cwt_double_error_i <= '0';
                end if;
            
            -- if s = 0000 then no error has occured
            else
                cwt_single_error_i <= '0';
                cwt_double_error_i <= '0';
            end if;

            rxdata_i1 <= rxdata_in;
            
          end if;
      end if;
  end process;


  -- out data delayed by 1 cc
  rxdata_out <= cwt_i1(3 downto 0) & cwt_i1(3 downto 0) & rxdata_i1(55 downto 0) when (rx_datavalid_in= '1' and valid_bit_in = '0') else rxdata_i1;
 
  cwt_single_error_out <= cwt_single_error_i when (rx_datavalid_in= '1' and valid_bit_in = '0') else '0';
  cwt_double_error_out <= cwt_double_error_i when (rx_datavalid_in= '1' and valid_bit_in = '0') else '0';

end Behavioral;

