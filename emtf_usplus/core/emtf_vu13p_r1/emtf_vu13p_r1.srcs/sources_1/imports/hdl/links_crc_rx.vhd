--------------------------------------------------------------------------------
-- links crc rx, kadamidi, 2020
-- calculates the CRC16 of received data and checkes with the received one
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.package_links.all;

entity links_crc_rx is
    generic(
        MGT_KIND    : integer;
        IDLE_METHOD : integer );
    port (
        clk                 : in  std_logic;
        clken_in            : in  std_logic;
        reset               : in  std_logic;
        reset_counters_in   : in  std_logic;
        data_in             : in  std_logic_vector(DATA_WIDTH-1 downto 0);
        valid_bit_in        : in  std_logic;
        crc_ttc_word_in     : in  std_logic_vector(16 downto 0);
        crc_flag_in         : in  std_logic;
        align_tag_in        : in  std_logic;
        align_marker_sel_in : in  std_logic;
        align_marker_dis_in : in  std_logic;
        data_out            : out std_logic_vector(63 downto 0);
        valid_bit_out       : out std_logic;
        align_marker_out    : out std_logic;
        data_start_out      : out std_logic;
        end_of_packet_out   : out std_logic;
        packet_cnt_out      : out std_logic_vector(7 downto 0);
        crc_error_cnt_out   : out std_logic_vector(7 downto 0)
        );

end links_crc_rx;

architecture behave of links_crc_rx is
    
    signal safe_b2b                       : integer;
    signal vb_data_start_i                : std_logic;
    signal vb_data_start_i1               : std_logic;
    signal data_valid_shreg               : std_logic_vector(1 downto 0);
    signal data_start_shreg               : std_logic_vector(1 downto 0);
    signal data_in_i1                     : std_logic_vector(63 downto 0);
    signal crc_word                       : std_logic_vector(15 downto 0);
    signal crc_word_latced                : std_logic_vector(15 downto 0);
    signal crc_rst                        : std_logic;
    signal latch_crc                      : std_logic;
    signal crc_error                      : std_logic;
    signal crc_error_cnt, crc_checked_cnt : unsigned(7 downto 0);
    signal crc_valid_en                   : std_logic;
    signal back_to_back_dis               : std_logic;
    signal check_crc_i                    : std_logic;
    signal valid_bit_i1                   : std_logic;
    signal align_marker_i                 : std_logic;
    signal vb_end_of_packet_i             : std_logic;
    signal vb_end_of_packet_i1            : std_logic;
    signal crc_flag_i1                    : std_logic;
    signal b2b_end_of_packet_i            : std_logic;
    signal b2b_start_of_packet_i1         : std_logic;
    signal valid_bit_extracted_i          : std_logic;
    signal valid_bit_int                  : std_logic;
    signal valid_bit_in_i1                : std_logic;

    attribute keep                        : string;
    attribute keep of safe_b2b            : signal is "true";
    attribute keep of end_of_packet_out   : signal is "true";
    attribute keep of align_marker_out   : signal is "true";
    attribute keep of data_start_out   : signal is "true";

begin
    
        
    safe_b2b <= SAFE_B2B_16G when (MGT_KIND = GTH16G or MGT_KIND = GTY16G) else SAFE_B2B_25G when MGT_KIND = GTY25G;

    idleMethod1: if IDLE_METHOD = 1 generate
        valid_bit_int <= valid_bit_in;
    end generate;
    
    idleMethod2: if IDLE_METHOD = 2 generate
        valid_bit_extracted_i <= '0' when data_in(63 downto 56) = x"44" else '1';
        valid_bit_int <= valid_bit_extracted_i;
    end generate;
    
    
    -- valid bit shift register
    data_start_shreg(0)   <= valid_bit_int; 
    
    -- valid bit data start - rising edge of valid bit
    vb_data_start_i <= '1' when data_start_shreg(1 downto 0) = "01" else '0';
    -- valid bit end of packet - falling edge of valid bit
    vb_end_of_packet_i <= '1' when data_start_shreg = "10" else '0';
    -- back to back end of packet - crc flag when valud bit is High
    b2b_end_of_packet_i <= crc_flag_in and valid_bit_in;
    
    process(clk)
    begin
        if rising_edge(clk) then
            if clken_in = '1' then        
                data_start_shreg(1)    <= data_start_shreg(0);
                
                vb_data_start_i1       <= vb_data_start_i;
                vb_end_of_packet_i1    <= vb_end_of_packet_i;
                b2b_start_of_packet_i1 <= b2b_end_of_packet_i;
                
                -- add FF for strict timing of -1 speed grade chips
                data_in_i1             <= data_in;
                valid_bit_i1           <= valid_bit_int;
                valid_bit_in_i1        <= valid_bit_in;
                crc_flag_i1            <= crc_flag_in;
            end if;
        end if;
    end process;

    -- calculate crc only when valid bit is 1
    crc_valid_en <= valid_bit_i1 and clken_in;


    -- prevent back to back crc checks
    process(clk)
        variable cntr : integer range 0 to SAFE_B2B_16G;
    begin
        if rising_edge(clk) then
            if reset = '1' then
                back_to_back_dis <= '0';
            else
                if crc_flag_i1 = '1' then
                    back_to_back_dis  <= '1';
                end if;

                if back_to_back_dis = '1' then
                    if cntr = SAFE_B2B then
                        back_to_back_dis <= '0';
                        cntr             := 0;
                    else
                        cntr := cntr + 1;
                    end if;
                end if;
            
            end if;
        end if;
    end process;


    -- check when checksum has arribved 
    check_crc_i <= crc_ttc_word_in(16);
         
    -- reset crc when crc flag arrives - tx arranges correct timing
    crc_rst  <= (vb_data_start_i1 or b2b_start_of_packet_i1);

    latch_crc  <= crc_flag_i1 and not back_to_back_dis;
 
    -- crc16
    crc_check : entity work.crc16isfTG
    port map(
      clk   => clk,
      rst   => crc_rst,
      crc_en => crc_valid_en,
      data_in  => data_in_i1,
      crc_out   => crc_word);
            
    -- latch crc word to be checked when checksum has arrived
    crc_word_latced <= crc_word when rising_edge(clk) and latch_crc = '1';

    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                crc_error <= '0';
            else
                if clken_in = '1' then
                    if check_crc_i = '0' then
                        crc_error <= '0';
                    else
                        -- check crc 
                        if crc_word_latced /= crc_ttc_word_in(15 downto 0) then
                            crc_error <= '1';
                        else
                            crc_error <= '0';
                        end if;
                    end if;
                end if;
            end if;
        end if;
    end process;

    -- Error & Packet counters
    status_counters : process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' or reset_counters_in = '1' then
                crc_error_cnt   <= (others => '0');
                crc_checked_cnt <= (others => '0');
            else
                if clken_in = '1'  then
                    if crc_error = '1' and crc_error_cnt /= X"ff" then
                        crc_error_cnt <= crc_error_cnt + 1;
                    end if;
                    if check_crc_i = '1' and crc_checked_cnt /= X"ff" then
                        crc_checked_cnt <= crc_checked_cnt + 1;
                    end if;
                end if;
            end if;
        end if;
    end process;

    -- algine marker select
    process(clk)
    begin
      if rising_edge(clk) then
        if reset = '1' or align_marker_dis_in = '1' then
          align_marker_i <= '0';
        else
          if align_marker_sel_in = '0' then
            align_marker_i <= vb_data_start_i;
          else
            align_marker_i <= align_tag_in;
          end if;
        end if;
      end if;
    end process;


    -- out ports
    data_out          <= data_in_i1;    
    valid_bit_out     <= valid_bit_in_i1;   
    data_start_out    <= vb_data_start_i1 or (b2b_start_of_packet_i1 and valid_bit_in_i1);  
    align_marker_out  <= align_marker_i;
    end_of_packet_out <= (crc_flag_in and valid_bit_in) or vb_end_of_packet_i;     

    crc_error_cnt_out   <= std_logic_vector(crc_error_cnt);
    packet_cnt_out      <= std_logic_vector(crc_checked_cnt);


end behave;
