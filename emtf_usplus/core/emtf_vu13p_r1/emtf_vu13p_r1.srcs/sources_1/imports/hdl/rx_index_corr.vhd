
--------------------------------------------------------------------------------
-- index correction - kadamidi, 2020
-- implements the rx index correction mechanism
--------------------------------------------------------------------------------



library ieee;
use ieee.STD_LOGIC_1164.all;
use ieee.STD_LOGIC_UNSIGNED.all;
use ieee.numeric_std.all;

use work.package_links.all;

entity rx_index_corr is
  port(
    freerun_clk              : in  std_logic                               := '0';
    rxusrclk                 : in  std_logic                               := '0';
    ttc_clk                  : in  std_logic                               := '0';
    rst_rx                   : in  std_logic                               := '0';
    rst_ttc                  : in  std_logic                               := '0';
    rst_latched              : in  std_logic                               := '0';
    rst_cntr_rx              : in  std_logic                               := '0';
    disable_ICM_in           : in  std_logic                               := '0';
    received_index_in        : in  std_logic_vector(3 downto 0) := (others => '0');
    filler_detected_in       : in  std_logic                               := '0';
    rx_datavalid_in          : in  std_logic                               := '0';
    index_lock_lost_out      : out std_logic;
    index_lock_lost_cntr_out : out std_logic_vector(3 downto 0);
    wrong_index_cntr_out     : out std_logic_vector(3 downto 0);
    index_corr_inc_out       : out std_logic;
    index_corr_dec_out       : out std_logic
    );
end entity;

architecture RTL of rx_index_corr is

  attribute DONT_TOUCH        : string;
  attribute DONT_TOUCH of RTL : architecture is "yes";
  
  signal received_index_latced : std_logic_vector(3 downto 0) := "0000";
  signal local_index_cntr      : std_logic_vector(3 downto 0) := "0000";
  signal index_lock_lost_cntr  : std_logic_vector(3 downto 0) := "0000";
  signal wrong_index_cntr      : std_logic_vector(3 downto 0) := "0000";
  signal index_lock            : std_logic := '0';
  signal index_corr_dec        : std_logic := '0';
  signal index_corr_inc        : std_logic := '0';
  signal locked                : std_logic := '0';
  signal fitst_wrong_index_s   : std_logic := '0';
  signal fitst_wrong_index_s1  : std_logic := '0';
  signal index_corr_inc_ttc    : std_logic := '0';
  signal index_corr_dec_ttc    : std_logic := '0';
  signal index_lock_lost_i     : std_logic := '0';
  signal filler_detected_i1    : std_logic := '0';
  signal index_corr_dec_i1     : std_logic := '0';
  signal index_corr_inc_i1     : std_logic := '0';
  signal index_corr_dec_2cc    : std_logic := '0';
  signal index_corr_inc_2cc    : std_logic := '0';
  signal index_corr_inc_ttc_re : std_logic := '0';
  signal index_corr_dec_ttc_re : std_logic := '0';
  signal index_corr_inc_ttc_i1 : std_logic := '0';
  signal index_corr_dec_ttc_i1 : std_logic := '0';
  signal index_corr_dec_i2     : std_logic := '0';
  signal index_corr_inc_i2     : std_logic := '0';
      
begin

  -- index correction
  --============================================================================================================================  
  
  -- index correction mechanism
  ---------------------------------------------------------------------------
  process(rxusrclk)
    variable first_wrong_index : std_logic;
  begin
    if rising_edge(rxusrclk) then
        if rst_rx = '1' then
            index_lock       <= '0';
            locked           <= '0';
            local_index_cntr <= X"0";
            index_corr_dec   <= '0';
            index_corr_inc   <= '0';
            first_wrong_index   := '0';
        else
            if filler_detected_in = '1' then 
                if index_lock = '0' then
                     -- lock to received index value 
                    local_index_cntr <= received_index_in+'1';
                    index_lock       <= '1';
                    index_corr_dec   <= '0';
                    index_corr_inc   <= '0';
                else -- index_lock = 1
                    if local_index_cntr = received_index_in then
                        locked              <= '1';
                        index_corr_dec      <= '0';
                        index_corr_inc      <= '0';
                        local_index_cntr    <= local_index_cntr + '1';
                        first_wrong_index   := '0';
                        fitst_wrong_index_s <= '0';
                    else
                        
                        if first_wrong_index = '0' then
                            local_index_cntr    <= local_index_cntr + '1';
                            first_wrong_index   := '1';
                            fitst_wrong_index_s <= '1';
                        else
                            if (local_index_cntr = received_index_in-'1') then
                                index_corr_dec <= '0';
                                index_corr_inc <= '1';
                                locked         <= '0';
                                index_lock     <= '0';
                            elsif (local_index_cntr = received_index_in+'1') then
                                index_corr_inc <= '0';
                                index_corr_dec <= '1';
                                locked         <= '0';
                                index_lock     <= '0';
                            else
                                index_corr_inc <= '0';
                                index_corr_dec <= '0';
                            end if;
                            fitst_wrong_index_s <= '0';
                        end if;
                        
                    end if;
                end if;
                received_index_latced <= received_index_in;
            else
                
                index_corr_dec <= '0';  
                index_corr_inc <= '0';  
            end if;
            filler_detected_i1   <= filler_detected_in;
            fitst_wrong_index_s1 <= fitst_wrong_index_s;
        end if;
            index_corr_dec_i1 <= index_corr_dec;
            index_corr_inc_i1 <= index_corr_inc;
            index_corr_dec_i2 <= index_corr_dec_i1;
            index_corr_inc_i2 <= index_corr_inc_i1;
    end if;
  end process;  
  ---------------------------------------------------------------------------
 
  -- status registers
  ---------------------------------------------------------------------------
  process(rxusrclk)
    variable cntr : integer := 0;
  begin
    if rising_edge(rxusrclk) then
        if rst_rx = '1' then
            index_lock_lost_i     <= '1';
        else    
            if rst_latched = '1' then
                index_lock_lost_i <= '0';
            else
                if locked = '0' then
                    index_lock_lost_i <= '1';
                end if; 
            end if;
        end if;
    end if;
   end process;     
            
  process(rxusrclk)
  begin
      if rising_edge(rxusrclk) then
          if rst_rx = '1' or rst_cntr_rx = '1' then
              wrong_index_cntr   <= (others => '0');
          else
              if disable_ICM_in = '0' then
                  if index_lock = '1' and filler_detected_i1 = '1' and fitst_wrong_index_s1 = '1' and wrong_index_cntr /= X"f" then
                      wrong_index_cntr <= wrong_index_cntr + 1;
                  end if;
              end if;
          end if;
      end if;
  end process;     
           
  process(rxusrclk)
  begin
      if rising_edge(rxusrclk) then
          if rst_rx = '1' or rst_cntr_rx = '1' then
              index_lock_lost_cntr   <= (others => '0');
          else
              if disable_ICM_in = '0' then
                  if index_lock = '0' and filler_detected_in = '1' and index_lock_lost_cntr /= X"f" then
                      index_lock_lost_cntr <= index_lock_lost_cntr + 1;
                  end if;
              end if;
          end if;
      end if;
  end process;
  ---------------------------------------------------------------------------
  
  
  -- cross pointer increase and decrease signals to ttc domain
  ---------------------------------------------------------------------------
  index_corr_dec_2cc <= (index_corr_dec or index_corr_dec_i1 or index_corr_dec_i2) and not disable_ICM_in;
  index_corr_inc_2cc <= (index_corr_inc or index_corr_inc_i1 or index_corr_inc_i2) and not disable_ICM_in;
  
  bit_synchronizer_bufptrdecttc_inst : entity work.emp_bit_synchronizer
    port map(
      clk_in => ttc_clk,
      i_in   => index_corr_dec_2cc,
      o_out  => index_corr_dec_ttc
      );
  
  bit_synchronizer_bufptrincttc_inst : entity work.emp_bit_synchronizer
    port map(
      clk_in => ttc_clk,
      i_in   => index_corr_inc_2cc,
      o_out  => index_corr_inc_ttc
      );

  process (ttc_clk)
  begin
    if rising_edge(ttc_clk) then
       index_corr_dec_ttc_i1 <= index_corr_dec_ttc;
       index_corr_inc_ttc_i1 <= index_corr_inc_ttc;
    end if;
  end process;
  
  index_corr_dec_ttc_re <= not index_corr_dec_ttc_i1 and index_corr_dec_ttc;
  index_corr_inc_ttc_re <= not index_corr_inc_ttc_i1 and index_corr_inc_ttc;
  ---------------------------------------------------------------------------
  
  
  -- out ports
  ---------------------------------------------------------------------------
  index_lock_lost_out      <= index_lock_lost_i;
  index_lock_lost_cntr_out <= index_lock_lost_cntr;
  wrong_index_cntr_out     <= wrong_index_cntr;
  index_corr_dec_out       <= index_corr_dec_ttc_re;
  index_corr_inc_out       <= index_corr_inc_ttc_re;
  ---------------------------------------------------------------------------
    
--============================================================================================================================  


end architecture;
