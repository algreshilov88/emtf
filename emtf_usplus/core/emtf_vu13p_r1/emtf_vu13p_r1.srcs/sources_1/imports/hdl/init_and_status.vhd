----------------------------------------------------------------------------------
-- link initialization blocks - kadamidi - 2020
-- performs the alignment of incoming serial bit stream and declares the status
-- of the link
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use IEEE.std_logic_unsigned.all;
use work.package_links.all;


entity init_and_status is
  port(
    rxusrclk2_i                : in  std_logic;
    reset                      : in  std_logic;
    reset_link_down_latch_in   : in  std_logic;
    rx_init_done_in            : in  std_logic;
    rx_datavalid_in            : in  std_logic;
    rxdata_in                  : in  std_logic_vector(63 downto 0);
    rx_valid_bit_in            : in  std_logic;
    rxgearboxslip_out          : out std_logic;
    link_status_out            : out std_logic;
    link_down_latched_out      : out std_logic
    );
end init_and_status;


architecture Behavioral of init_and_status is

  signal reset_i               : std_logic;
  signal reset_sync            : std_logic;
  signal reset_latch_i         : std_logic;
  signal rxgearboxslip_ctr_int : std_logic_vector (7 downto 0);
  signal data_good_i           : std_logic;
  signal check_data            : std_logic;
  signal rxdatavalid_in_l1     : std_logic;
  signal rxgearboxslip         : std_logic;
  signal rxgearboxslip_l1      : std_logic;
  signal header_locked         : std_logic;
  signal link_down_latched_i   : std_logic;


begin



  reset_i <= not rx_init_done_in or reset_sync;

  reset_synchronizer_rst_inst : entity work.emp_reset_synchronizer
    port map(
      clk_in  => rxusrclk2_i,
      rst_in  => reset,
      rst_out => reset_sync
      );

  reset_synchronizer_rstRxLtc_inst : entity work.emp_reset_synchronizer
    port map(
      clk_in  => rxusrclk2_i,
      rst_in  => reset_link_down_latch_in,
      rst_out => reset_latch_i
      );  

  process(rxusrclk2_i)
    variable cnt : integer := 0;
    variable sh_valid : integer := 0;
  begin
    if rising_edge(rxusrclk2_i) then
      if reset_sync = '1' then
        rxgearboxslip_ctr_int <= x"00";
        rxgearboxslip         <= '0';
        header_locked         <= '0';
        cnt                   := 0;
        sh_valid              := 0;
      else
  
         -- no check untit 32 cc after a bit slip
        if rxgearboxslip_ctr_int < x"20" then
            rxgearboxslip_out <= '0';
            rxgearboxslip_ctr_int <= rxgearboxslip_ctr_int + '1';
        else
        -- bit slip done  
            -- check sync header
            if check_data = '1' then  
    
                -- sync header not locked - link down
                if header_locked = '0' then 
                    -- wrong haeder
                    if data_good_i = '0' then
                        sh_valid := 0;
                        rxgearboxslip_ctr_int <= x"00";
                        rxgearboxslip_out <= '1';      
                    else
                        --count 64 consequtive correct headers 
                        if sh_valid < 64 then
                            sh_valid := sh_valid + 1;
                        else
                            header_locked <= '1';
                        end if;
                    end if;
                else
                -- sync header locked - link up
                   
                    if data_good_i = '0' then
                        
                        if sh_valid > 8 then
                            sh_valid := sh_valid - 8;
                        else
                            sh_valid := 0;
                            header_locked <= '0';
                            rxgearboxslip_ctr_int <= x"00";
                            rxgearboxslip_out <= '1';
                        end if;
                    else
                        
                        if sh_valid < 64 then
                            sh_valid := sh_valid + 1;
                        end if;
                    end if;
                end if;
                
          end if;
        end if;
      end if;
    end if;
  end process;
  

  process(rxusrclk2_i)
  begin
    if rising_edge(rxusrclk2_i) then
      if reset_sync = '1' then
        data_good_i <= '0';
        check_data  <= '1';
      else
        if rx_datavalid_in = '1' then
          if rx_valid_bit_in = '1' then
             check_data  <= '0';
             data_good_i <= '0';
          else
            if rxdata_in(59 downto 56) = PAD0_CODE then    -- Padding
              data_good_i <= '1';
              check_data <= '1';
            elsif rxdata_in(59 downto 56) = TAG_CODE then   -- TAG
              data_good_i <= '0';
              check_data <= '1';
            elsif rxdata_in(59 downto 56) = IDLE_CODE then  -- IDLE
              data_good_i <= '1';
              check_data <= '1';
            elsif rxdata_in(59 downto 56) = PAD1_CODE then  -- Padding
              data_good_i <= '1';
              check_data <= '1';
            elsif rxdata_in(59 downto 56) = CRCV_CODE then  -- CRC
              data_good_i <= '1';
              check_data <= '1';
            else
              data_good_i <= '0';
              check_data <= '1';
            end if;
          end if;
        end if;
      end if;
    end if;
  end process;
  
  process (rxusrclk2_i)
  begin
    if rising_edge(rxusrclk2_i) then
      if (reset_latch_i = '1') then
        link_down_latched_i <= '0';
      elsif (header_locked = '0') then
        link_down_latched_i <= '1';
      end if;
    end if;
  end process;

  link_status_out       <= header_locked;
  link_down_latched_out <= link_down_latched_i;

end Behavioral;
