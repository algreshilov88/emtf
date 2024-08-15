--------------------------------------------------------------------------------
-- index correction - kadamidi, 2023
-- implements the rx index correction mechanism
--------------------------------------------------------------------------------

library ieee;
use ieee.STD_LOGIC_1164.all;
use ieee.STD_LOGIC_UNSIGNED.all;
use ieee.numeric_std.all;

entity rx_index_corr is
  port(
    rxusrclk                 : in  std_logic;
    rst_rx                   : in  std_logic;
    rst_latched              : in  std_logic;
    rst_cntr_rx              : in  std_logic;
    disable_ICM_in           : in  std_logic;
    received_index_in        : in  std_logic_vector(3 downto 0);
    filler_detected_in       : in  std_logic;
    index_lock_lost_out      : out std_logic;
    phase_ahead_out          : out std_logic_vector(2 downto 0);
    phase_behind_out         : out std_logic_vector(2 downto 0);
    index_lock_lost_cntr_out : out std_logic_vector(15 downto 0) := (others => '0');
    wrong_index_cntr_out     : out std_logic_vector(15 downto 0) := (others => '0')
    );
end entity;

architecture RTL of rx_index_corr is

  signal received_index_i1      : std_logic_vector(3 downto 0);
  signal local_index_cntr       : std_logic_vector(3 downto 0);
  signal index_lock_lost_cntr   : std_logic_vector(15 downto 0);
  signal wrong_index_cntr       : std_logic_vector(15 downto 0);
  signal wrong_rx_index         : std_logic_vector(3 downto 0);
  signal correct_guesses        : std_logic_vector(2 downto 0);
  signal phase_ahead            : std_logic_vector(2 downto 0);
  signal phase_behind           : std_logic_vector(2 downto 0);
  signal phase_undet            : std_logic_vector(2 downto 0);
  signal index_lock             : std_logic;
  signal wrong_index_i          : std_logic;
  signal index_lock_lost_i      : std_logic;
  signal icm_engaged            : std_logic;
  signal flag                   : std_logic;
          
begin


  -- index correction mechanism
  -----------------------------------------------------------------------------
  icm_prc: process(rxusrclk)
    variable phase_undet_min1 : std_logic_vector(2 downto 0);
  begin
    if rising_edge(rxusrclk) then
        if rst_rx = '1'  then
            index_lock         <= '0';
            wrong_rx_index     <= x"0"; 
            phase_undet        <= "000";
            phase_ahead        <= "000";
            phase_behind       <= "000";
            correct_guesses    <= "000";
            flag               <= '0';
            wrong_index_i      <= '0';
            icm_engaged        <= '0';
        else
            
            if filler_detected_in = '1' and disable_ICM_in = '0' then
                if index_lock = '0' then  
                    -- lock to received index value 
                    local_index_cntr <= received_index_in+'1';
                    index_lock       <= '1';
                else  
                    if icm_engaged = '0' then
                        -- 
                        if local_index_cntr = received_index_in  then
                            local_index_cntr  <= local_index_cntr + '1';
                        else 
                            phase_undet    <= "001";
                            icm_engaged    <= '1';
                        end if;
                        flag               <= '0';
                        phase_ahead        <= "000"; 
                        phase_behind       <= "000"; 
                    else -- icm_engaged
                        if phase_undet = "000" then
                            -- exit
                            if wrong_rx_index = x"b" then
                                index_lock         <= '0';
                                wrong_rx_index     <= x"0";
                                correct_guesses    <= "000";
                                phase_ahead        <= "000";
                                phase_behind       <= "000";
                                phase_undet        <= "000";
                                icm_engaged        <= '0';  
                            elsif (correct_guesses >= x"1" and local_index_cntr = received_index_in) then
--                            elsif local_index_cntr = received_index_in then
                                if phase_ahead /= "000" or phase_behind /= "000" then
                                    flag               <= '1';
                                else
                                    flag               <= '0';
                                end if;
                                local_index_cntr   <= local_index_cntr + '1';
                                wrong_rx_index     <= x"0";
                                correct_guesses    <= "000";
                                icm_engaged        <= '0';
                            else        
                                if local_index_cntr = received_index_in then
                                    local_index_cntr <= local_index_cntr + '1';
                                    correct_guesses <= correct_guesses + '1';
                                else
                                    phase_undet <= "001";
                                    wrong_rx_index <= wrong_rx_index + '1';
                                end if;  
                            end if;
                            wrong_index_i      <= '0'; 
                            
                        else -- phase_undet /= "000"
                            if local_index_cntr = x"e" and received_index_in = x"0" and received_index_i1 = received_index_in then
                                phase_undet      <= phase_undet + "1";    
                            elsif local_index_cntr + phase_undet = received_index_in-phase_undet then
                                phase_ahead      <= phase_ahead + phase_undet;
                                local_index_cntr <= local_index_cntr + phase_undet  + phase_undet + "1";
                                phase_undet      <= "000";
                            elsif local_index_cntr + phase_undet = received_index_in+phase_undet then
                                phase_behind     <= phase_behind + phase_undet;
                                local_index_cntr <= local_index_cntr + '1';
                                phase_undet      <= "000";
                            elsif local_index_cntr + phase_undet = received_index_in then
                                local_index_cntr <= local_index_cntr + phase_undet + "1";
                                phase_undet      <= "000";
                                wrong_index_i    <= '1';
                            else
                                
                                if phase_undet <= x"1" then
                                    local_index_cntr <= local_index_cntr; 
                                    phase_undet      <= phase_undet + "1";
                                    wrong_rx_index   <= wrong_rx_index + '1';      
                                else
                                    phase_undet_min1 := phase_undet - "1";
                                    -- special case of mixed phase_ahead and phase_behind errors
                                    if local_index_cntr + phase_undet = received_index_in-phase_undet_min1 then
                                        phase_ahead      <= phase_ahead + phase_undet_min1;
                                        local_index_cntr <= local_index_cntr + phase_undet  + phase_undet_min1 + "1";
                                        phase_undet      <= "000";
                                    elsif local_index_cntr + phase_undet = received_index_in+phase_undet_min1 then
                                        phase_behind     <= phase_behind + phase_undet_min1;
                                        local_index_cntr <= local_index_cntr + x"1" + '1';
                                        phase_undet      <= "000";
                                    else
                                        local_index_cntr <= local_index_cntr; 
                                        phase_undet      <= phase_undet + "1";
                                        wrong_rx_index   <= wrong_rx_index + '1';                                         
                                    end if;   
                                end if;   
                            end if;   
                            
                        end if;
                        
                    end if;
                end if;
            else
                flag          <= '0';
                wrong_index_i <= '0';
            end if;
            received_index_i1 <= received_index_in;
        end if; 
    end if;
  end process;     
                    
  phase_ahead_out    <= phase_ahead  when flag = '1' else "000";  
  phase_behind_out   <= phase_behind when flag = '1' else "000"; 
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
                if index_lock = '0' then
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
                  if wrong_index_i = '1' and wrong_index_cntr /= X"FFFF" then
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
                  if flag = '1' and index_lock_lost_cntr /= X"FFFF" then
                      index_lock_lost_cntr <= index_lock_lost_cntr + 1;
                  end if;
              end if;
          end if;
      end if;
  end process;
  ---------------------------------------------------------------------------
 
  
  -- out ports
  ---------------------------------------------------------------------------
  index_lock_lost_out      <= index_lock_lost_i;
  index_lock_lost_cntr_out <= index_lock_lost_cntr;
  wrong_index_cntr_out     <= wrong_index_cntr;
  ---------------------------------------------------------------------------
    
--============================================================================================================================  


end architecture;