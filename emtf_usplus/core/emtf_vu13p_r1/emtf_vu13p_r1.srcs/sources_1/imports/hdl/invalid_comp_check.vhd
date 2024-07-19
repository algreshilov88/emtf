--------------------------------------------------------------------------------
-- invalid tx combinations check, kadamidi, 2022
-- checks the vald, start and last signals for invalid combinations
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.STD_LOGIC_UNSIGNED.all;
use ieee.numeric_std.all;

library work;
use work.package_links.all;
use work.emp_data_types.all;


entity invalid_comp_check is
  generic(
    MGT_KIND   : integer );
  port (
    clk                      : in  std_logic;
    rst_ttc                  : in  std_logic;
    rst_cntr_ttc             : in  std_logic;
    txdata_in                : in  lword;
    invalid_tx_comb_cntr_out : out invalidTxComp_t
    );
end invalid_comp_check;

architecture behave of invalid_comp_check is
 
    signal invalid_tx_comb_cntr           : invalidTxComp_t; 
    signal data_valid_shreg               : std_logic_vector(1 downto 0) := (others => '0'); 
    signal txdata_start_i1                : std_logic;
    signal txdata_last_i1                 : std_logic;
    signal LastAndNotStart_ValidInBoth    : std_logic;
    signal startOrLastHighnAndValidLow    : std_logic;
    signal startHighForMultiCycles        : std_logic;  
    signal lastHighForMultiCycles         : std_logic;
    signal startAndLastHighSimultaneously : std_logic;
    signal NoLastBeforeStart_ValidInBoth  : std_logic;

begin

    data_valid_shreg(0) <= txdata_in.valid;

    process(clk)
    begin
        if rising_edge(clk) then
            if rst_ttc = '1' then
                startOrLastHighnAndValidLow    <= '0';
                startHighForMultiCycles        <= '0';
                lastHighForMultiCycles         <= '0';
                startAndLastHighSimultaneously <= '0';
                NoLastBeforeStart_ValidInBoth  <= '0'; 
                LastAndNotStart_ValidInBoth    <= '0'; 
            else
                -- sreg valid bit
                data_valid_shreg(1) <= data_valid_shreg(0);
            
                -- start or last high when valid bit is low
                if txdata_in.start = '1' or txdata_in.last = '1' then
                    if txdata_in.valid = '0' then
                        startOrLastHighnAndValidLow <= '1';
                    else
                        startOrLastHighnAndValidLow <= '0';
                    end if;
                else    
                    startOrLastHighnAndValidLow <= '0';
                end if;
                
                -- sreg txdata in start and last
                txdata_start_i1 <= txdata_in.start;
                txdata_last_i1  <= txdata_in.last;
                
                -- start or last bits high for more that 1 c.c.
                if txdata_in.start = '1' and txdata_start_i1 = '1'then
                    startHighForMultiCycles <= '1';
                else
                    startHighForMultiCycles <= '0';
                end if;
                if txdata_in.last = '1' and txdata_last_i1 = '1'then
                    lastHighForMultiCycles <= '1';
                else
                    lastHighForMultiCycles <= '0';
                end if;
                
                -- start and last bits high at the same time
                if txdata_in.start = '1' and txdata_in.last = '1' then
                    startAndLastHighSimultaneously <= '1';
                else
                    startAndLastHighSimultaneously <= '0';
                end if;
                
                -- valid high and last not asserted before start bit in back to back packets
                if data_valid_shreg = "11" and txdata_in.start = '1' then
                    if txdata_last_i1 = '0' then
                        NoLastBeforeStart_ValidInBoth <= '1';
                    else
                        NoLastBeforeStart_ValidInBoth <= '0';
                    end if;
                else
                    NoLastBeforeStart_ValidInBoth <= '0';
                end if;
                
                -- valid high and last bit not followed by a start bit in back to back packets
                if data_valid_shreg = "11"  and txdata_last_i1 = '1' then
                    if txdata_in.start = '0' then
                        LastAndNotStart_ValidInBoth<= '1';
                    else
                        LastAndNotStart_ValidInBoth <= '0';
                    end if;
                else
                    LastAndNotStart_ValidInBoth <= '0';
                end if;
                
            end if;
        end if;
    end process;

    process(clk)
    begin
        if rising_edge(clk) then
            if rst_ttc = '1' or rst_cntr_ttc = '1' then
                invalid_tx_comb_cntr   <= (others =>( others => '0'));
            else
                if startOrLastHighnAndValidLow = '1' and invalid_tx_comb_cntr.startOrLastHighnAndValidLow /= X"F" then 
                    invalid_tx_comb_cntr.startOrLastHighnAndValidLow <= invalid_tx_comb_cntr.startOrLastHighnAndValidLow + 1;
                end if;
                if ((startHighForMultiCycles = '1' or lastHighForMultiCycles= '1') and invalid_tx_comb_cntr.starOrLasttHighForMultiCycles /= X"F")then 
                    invalid_tx_comb_cntr.starOrLasttHighForMultiCycles <= invalid_tx_comb_cntr.starOrLasttHighForMultiCycles + 1;
                end if;
                if startAndLastHighSimultaneously = '1' and invalid_tx_comb_cntr.startAndLastHighSimultaneously /= X"F" then 
                    invalid_tx_comb_cntr.startAndLastHighSimultaneously <= invalid_tx_comb_cntr.startAndLastHighSimultaneously + 1;
                end if;
                if NoLastBeforeStart_ValidInBoth = '1' and invalid_tx_comb_cntr.NoLastBeforeStart_ValidInBoth /= X"F" then 
                    invalid_tx_comb_cntr.NoLastBeforeStart_ValidInBoth <= invalid_tx_comb_cntr.NoLastBeforeStart_ValidInBoth + 1;
                end if;
                if LastAndNotStart_ValidInBoth = '1' and invalid_tx_comb_cntr.LastAndNotStart_ValidInBoth /= X"F" then 
                    invalid_tx_comb_cntr.LastAndNotStart_ValidInBoth <= invalid_tx_comb_cntr.LastAndNotStart_ValidInBoth + 1;
                end if;                
            end if;
        end if;
    end process;
 
    invalid_tx_comb_cntr_out <= invalid_tx_comb_cntr;

end behave;

