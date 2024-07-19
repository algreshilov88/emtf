library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.package_links.all;


entity error_injection is
  port(
    txusrclk           : in  std_logic                                 := '0';
    reset              : in  std_logic                                 := '0';
    inject_error_in    : in  inject_error_t                               ;
    txdata_in          : in  std_logic_vector(DATA_WIDTH - 1 downto 0)     := (others => '0');
    txheader_in        : in  std_logic_vector(2 downto 0)              := (others => '0');
    tx_datavalid_in    : in  std_logic                                 := '0';
    txsequence_in      : in  std_logic_vector(6 downto 0)              := (others => '0');
    tx_datavalid_out   : out std_logic                                 := '0';
    txdata_out         : out std_logic_vector(DATA_WIDTH - 1 downto 0) := (others => '0');
    txheader_out       : out std_logic_vector(2 downto 0)              := (others => '0');
    txsequence_out     : out std_logic_vector(6 downto 0)              := (others => '0')
    );

end error_injection;

architecture Behavioral of error_injection is

  attribute DONT_TOUCH        : string;
  attribute DONT_TOUCH of Behavioral : architecture is "yes";

  signal txdata_l1        : std_logic_vector(63 downto 0)  := (others => '0');
  signal txheader_l1      : std_logic_vector(2 downto 0)  := (others => '0');
  
  
  signal inject_header_2biterr                   : std_logic_vector(2 downto 0)  := (others => '0');
  signal inject_header_1biterr                   : std_logic_vector(2 downto 0)  := (others => '0');
  signal inject_CC_2bitErr                       : std_logic_vector(2 downto 0)  := (others => '0');
  signal inject_CRC_bitErr                       : std_logic_vector(2 downto 0)  := (others => '0');
  signal inject_index_bitErr                     : std_logic_vector(2 downto 0)  := (others => '0');
  signal inject_CC_bitErr                        : std_logic_vector(2 downto 0)  := (others => '0');
  signal txdata_ccde_l1                          : std_logic_vector(7 downto 0)  := (others => '0');
  signal txdata_ccsb_l1                          : std_logic_vector(7 downto 0)  := (others => '0');
  signal txdata_crcsb_l1                         : std_logic_vector(8 downto 0)  := (others => '0');
  signal txdata_ccin_l1                          : std_logic_vector(8 downto 0)  := (others => '0');  
  signal inject_haeder_double_error              : std_logic;
  signal inject_haeder_1bit_error                : std_logic;
  signal inject_ControlCode_double_error         : std_logic := '0';
  signal inject_CRC_1biterror_error              : std_logic := '0';
  signal inject_Index_1biterror                  : std_logic := '0';
  signal inject_CC_1biterror                     : std_logic := '0';
  signal inject_haeder_double_error_latched      : std_logic := '0';
  signal inject_haeder_1bit_error_latched        : std_logic := '0';
  signal inject_ControlCode_double_error_latched : std_logic := '0';
  signal inject_haeder_double_error_flag         : std_logic := '0';
  signal inject_haeder_1bit_error_flag           : std_logic := '0';
  signal inject_ControlCode_double_error_flag    : std_logic := '0';
  signal inject_CRC_1biterror_flag               : std_logic := '0';
  signal inject_Index_1biterror_flag             : std_logic := '0';
  signal inject_CC_1biterror_flag                : std_logic := '0';
  signal inject_CRC_1biterror_latched            : std_logic := '0';
  signal inject_Index_1biterror_latched          : std_logic := '0';
  signal inject_CC_1biterror_latched             : std_logic := '0';
  
  attribute ASYNC_REG                          : string;
  attribute ASYNC_REG of inject_header_2biterr : signal is "TRUE";
      attribute ASYNC_REG of inject_header_1biterr : signal is "TRUE";
  attribute ASYNC_REG of inject_CC_2bitErr     : signal is "TRUE";
  attribute ASYNC_REG of inject_CRC_bitErr     : signal is "TRUE";
  attribute ASYNC_REG of inject_index_bitErr   : signal is "TRUE";
  attribute ASYNC_REG of inject_CC_bitErr      : signal is "TRUE";
  attribute keep                        : string;
  attribute keep of inject_error_in     : signal is "true"; 
begin


-- Header double error   
----------------------------------------------------------------------------------
  inject_header_2biterr(0) <= inject_error_in.header_2bit;
  
  process(txusrclk)
  begin
    if rising_edge(txusrclk) then
        inject_header_2biterr(1) <= inject_header_2biterr(0);
        inject_header_2biterr(2) <= inject_header_2biterr(1);
    end if;
  end process;
  
  inject_haeder_double_error <= not inject_header_2biterr(2) and inject_header_2biterr(1);

  process(txusrclk)
  begin
    if rising_edge(txusrclk) then
      if inject_haeder_double_error = '1' then
        inject_haeder_double_error_latched <= '1';
      elsif inject_haeder_double_error_flag = '1' then
        inject_haeder_double_error_latched <= '0';
      end if;
    end if;
  end process;
----------------------------------------------------------------------------------  


-- Header singe error  
----------------------------------------------------------------------------------
  inject_header_1biterr(0) <= inject_error_in.header_1bit;

  process(txusrclk)
  begin
    if rising_edge(txusrclk) then
        inject_header_1biterr(1) <= inject_header_1biterr(0);
        inject_header_1biterr(2) <= inject_header_1biterr(1);
    end if;
  end process;
  
  inject_haeder_1bit_error <= not inject_header_1biterr(2) and inject_header_1biterr(1);

  process(txusrclk)
  begin
    if rising_edge(txusrclk) then
      if inject_haeder_1bit_error = '1' then
        inject_haeder_1bit_error_latched <= '1';
      elsif inject_haeder_1bit_error_flag = '1' then
        inject_haeder_1bit_error_latched <= '0';
      end if;
    end if;
  end process;
----------------------------------------------------------------------------------  


-- Control Code double bitflip
----------------------------------------------------------------------------------  
    inject_CC_2bitErr(0) <= inject_error_in.CC_2bit;
  
  process(txusrclk)
  begin
    if rising_edge(txusrclk) then
        inject_CC_2bitErr(1) <= inject_CC_2bitErr(0);
        inject_CC_2bitErr(2) <= inject_CC_2bitErr(1);
    end if;
  end process;
  
  inject_ControlCode_double_error <= not inject_CC_2bitErr(2) and inject_CC_2bitErr(1);  
   
  process(txusrclk)
  begin
    if rising_edge(txusrclk) then
      if inject_ControlCode_double_error = '1' then
        inject_ControlCode_double_error_latched <= '1';
      elsif inject_ControlCode_double_error_flag = '1' then
        inject_ControlCode_double_error_latched <= '0';
      end if;
    end if;
  end process;
----------------------------------------------------------------------------------  


-- CRC bitflip
----------------------------------------------------------------------------------  
  inject_CRC_bitErr(0) <= inject_error_in.CRC_1bit;
 
  process(txusrclk)
  begin
    if rising_edge(txusrclk) then
        inject_CRC_bitErr(1) <= inject_CRC_bitErr(0);
        inject_CRC_bitErr(2) <= inject_CRC_bitErr(1);
    end if;
  end process;
  
  inject_CRC_1biterror_error <= not inject_CRC_bitErr(2) and inject_CRC_bitErr(1);  
  
  process(txusrclk)
  begin
    if rising_edge(txusrclk) then
      if inject_CRC_1biterror_error = '1' then
        inject_CRC_1biterror_latched <= '1';
      elsif inject_CRC_1biterror_flag = '1' then
        inject_CRC_1biterror_latched <= '0';
      end if;
    end if;
  end process;
----------------------------------------------------------------------------------  
  
  
  -- Index Number bitflip
----------------------------------------------------------------------------------  
  inject_index_bitErr(0) <= inject_error_in.index_1bit;

  process(txusrclk)
  begin
    if rising_edge(txusrclk) then
        inject_index_bitErr(1) <= inject_index_bitErr(0);
        inject_index_bitErr(2) <= inject_index_bitErr(1);
    end if;
  end process;

  inject_Index_1biterror <= not inject_index_bitErr(2) and inject_index_bitErr(1);  

  process(txusrclk)
  begin
    if rising_edge(txusrclk) then
      if inject_Index_1biterror = '1' then
        inject_Index_1biterror_latched <= '1';
      elsif inject_Index_1biterror_flag = '1' then
        inject_Index_1biterror_latched <= '0';
      end if;
    end if;
  end process;
----------------------------------------------------------------------------------  

  
-- Control Code single bitflips
----------------------------------------------------------------------------------  
  inject_CC_bitErr(0) <= inject_error_in.CC_1bit;

  process(txusrclk)
  begin
    if rising_edge(txusrclk) then
        inject_CC_bitErr(1) <= inject_CC_bitErr(0);
        inject_CC_bitErr(2) <= inject_CC_bitErr(1);
    end if;
  end process;


  inject_CC_1biterror <= not inject_CC_bitErr(2) and inject_CC_bitErr(1);  

  process(txusrclk)
  begin
    if rising_edge(txusrclk) then
      if inject_CC_1biterror = '1' then
        inject_CC_1biterror_latched <= '1';
      elsif inject_CC_1biterror_flag = '1' then
        inject_CC_1biterror_latched <= '0';
      end if;
    end if;
  end process;
----------------------------------------------------------------------------------


----------------------------------------------------------------------------------
  process(txusrclk)
    variable cntr: integer := 0;    
  begin
    if rising_edge(txusrclk) then
      if tx_datavalid_in = '1' then
          if inject_haeder_double_error_latched = '1' and inject_haeder_double_error_flag = '0' then
              txheader_l1(2)                  <= txheader_in(2);
              txheader_l1(1)                  <= not txheader_in(1);
              txheader_l1(0)                  <= not txheader_in(0);
              inject_haeder_double_error_flag <= '1';
          elsif inject_haeder_1bit_error_latched = '1' and inject_haeder_1bit_error_flag = '0' then
              if cntr >= 2 then
                cntr := 0;
              else
                cntr := cntr +1;
              end if;
              txheader_l1                     <= txheader_in;
              txheader_l1(cntr)               <= not txheader_in(cntr);
              inject_haeder_1bit_error_flag   <= '1';              
              
         else
              inject_haeder_double_error_flag <= '0';
              inject_haeder_1bit_error_flag   <= '0';
              txheader_l1                     <= txheader_in;
          end if;
      end if;
    end if;
  end process;  

  process(txusrclk)
    variable cntr: integer := 0;  
  begin
    if rising_edge(txusrclk) then
        if tx_datavalid_in = '1' and txheader_in = "010" then
          
          txdata_l1                            <= txdata_in;
          
           -- Control Code double bitflip
          if inject_ControlCode_double_error_latched = '1' and inject_ControlCode_double_error_flag = '0' then
              txdata_ccde_l1(2 downto 0)              <= txdata_in(58 downto 56);
              txdata_ccde_l1(3)                        <= not txdata_in(59);
              txdata_ccde_l1(4)                        <= not txdata_in(60);
              txdata_ccde_l1(7 downto 5)              <= txdata_in(63 downto 61);

              inject_ControlCode_double_error_flag <= '1';
           
          -- CRC bitflip
          elsif inject_CRC_1biterror_latched = '1' and txdata_in(59 downto 56) = CRCV_CODE and inject_CRC_1biterror_flag = '0' then 
              txdata_crcsb_l1(0)                      <= not txdata_in(0);
              inject_CRC_1biterror_flag            <= '1';
              
          -- Index Number bitflip    
          elsif inject_Index_1biterror_latched = '1' and txdata_in(59 downto 56) /= IDLE_CODE and inject_Index_1biterror_flag = '0' then
              txdata_ccin_l1(0)                    <= not txdata_in(55);
              inject_Index_1biterror_flag          <= '1';          
          
          -- Control Code single bitflip
          elsif inject_CC_1biterror_latched = '1' and inject_CC_1biterror_flag = '0' then
              if cntr >= 7 then
                cntr := 0;
              else
                cntr := cntr +1;
              end if;
              if cntr = 0 then
                txdata_ccsb_l1(7 downto 1)   <= txdata_in(63 downto 57);
                txdata_ccsb_l1(0)   <= not txdata_in(56);
              elsif cntr = 1 then
                txdata_ccsb_l1(7 downto 2)   <= txdata_in(63 downto 58);
                txdata_ccsb_l1(1)   <= not txdata_in(57);
                txdata_ccsb_l1(0)   <= txdata_in(56);
              elsif cntr = 2 then
                txdata_ccsb_l1(7 downto 3)   <= txdata_in(63 downto 59);
                txdata_ccsb_l1(2)   <= not txdata_in(58);
                txdata_ccsb_l1(1 downto 0)   <= txdata_in(57 downto 56);
              elsif cntr = 3 then
                txdata_ccsb_l1(7 downto 4)   <= txdata_in(63 downto 60);
                txdata_ccsb_l1(3)   <= not txdata_in(59);
                txdata_ccsb_l1(2 downto 0)   <= txdata_in(58 downto 56);
              elsif cntr = 4 then
                txdata_ccsb_l1(7 downto 5)   <= txdata_in(63 downto 61);
                txdata_ccsb_l1(4)   <= not txdata_in(60);
                txdata_ccsb_l1(3 downto 0)   <= txdata_in(59 downto 56);
              elsif cntr = 5 then
                txdata_ccsb_l1(7 downto 6)   <= txdata_in(63 downto 62);
                txdata_ccsb_l1(5)   <= not txdata_in(61);
                txdata_ccsb_l1(4 downto 0)   <= txdata_in(60 downto 56);
              elsif cntr = 6 then
                txdata_ccsb_l1(7)   <= txdata_in(63);
                txdata_ccsb_l1(6)   <= not txdata_in(62);
                txdata_ccsb_l1(5 downto 0)   <= txdata_in(61 downto 56);
              elsif cntr = 7 then
                txdata_ccsb_l1(7)   <= not txdata_in(63);
                txdata_ccsb_l1(6 downto 0)   <= txdata_in(62 downto 56);
              end if;   
              inject_CC_1biterror_flag             <= '1';    
              
          else
              inject_ControlCode_double_error_flag <= '0';
              inject_CRC_1biterror_flag            <= '0';
              inject_Index_1biterror_flag          <= '0';
              inject_CC_1biterror_flag             <= '0';
          end if;
        else
          txdata_l1                               <= txdata_in;      
          inject_ControlCode_double_error_flag <= '0';
          inject_CRC_1biterror_flag            <= '0';
          inject_Index_1biterror_flag          <= '0';
          inject_CC_1biterror_flag             <= '0';
        end if;
      end if;
  end process;

----------------------------------------------------------------------------------  

 txdata_out <= txdata_ccde_l1 & txdata_l1(55 downto 0) when inject_ControlCode_double_error_flag = '1' else
               txdata_l1(63 downto 1) & txdata_crcsb_l1(0) when  inject_CRC_1biterror_flag = '1' else
               txdata_l1(63 downto 56) & txdata_ccin_l1(0) & txdata_l1(54 downto 0) when inject_Index_1biterror_flag = '1' else
               txdata_ccsb_l1 & txdata_l1(55 downto 0) when inject_CC_1biterror_flag = '1' else
               txdata_l1;


  process(txusrclk)
  begin
    if rising_edge(txusrclk) then
      tx_datavalid_out <= tx_datavalid_in;
      txsequence_out   <= txsequence_in;
    end if;
  end process;

  txheader_out       <= txheader_l1;
  
   
end Behavioral;
