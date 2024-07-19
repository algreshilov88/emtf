--------------------------------------------------------------------------------
-- bram control, smallios - kadamidi, 2020
-- controls the read/write pointes and enable, detects filler words and 
-- outputs metadata info, implements the rx index correction mechanism
--------------------------------------------------------------------------------


library ieee;
use ieee.STD_LOGIC_1164.all;
use ieee.STD_LOGIC_UNSIGNED.all;
use ieee.numeric_std.all;
use work.package_links.all;


entity rxbram_ctrl is
  port(
    freerun_clk              : in  std_logic;
    rxusrclk                 : in  std_logic;
    ttc_clk                  : in  std_logic;
    rst_rx                   : in  std_logic;
    rst_ttc                  : in  std_logic;
    rst_latched              : in  std_logic;
    rst_cntr_rx              : in  std_logic;
    rx_data_in               : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    valid_bit_in             : in  std_logic;
    rx_datavalid_in          : in  std_logic;
    rxram_pointer_ctrl_in    : in  rxram_pointer_t;
    link_status_in           : in  std_logic;
    disable_ICM_in           : in  std_logic;
    wr_en_out                : out std_logic;
    filler_tag_out           : out std_logic;
    crc_word_out             : out std_logic_vector(16 downto 0);
    rxMetadata_out           : out linkRxMetadata_t;
    special_bits_out         : out std_logic_vector(7 downto 0);
    index_lock_lost_out      : out std_logic;
    index_lock_lost_cntr_out : out std_logic_vector(3 downto 0);
    wrong_index_cntr_out     : out std_logic_vector(3 downto 0);
    wbuf_add_word_out        : out std_logic_vector(8 downto 0);
    rbuf_add_word_out        : out std_logic_vector(8 downto 0)
    );
end entity;


architecture RTL of rxbram_ctrl is

  constant BRAM_DEPTH : integer := 512;
  
  signal wbuf_add : integer range 0 to BRAM_DEPTH-1;
  signal rbuf_add : integer range 0 to BRAM_DEPTH-1;
  
  signal wr_en_i              : std_logic := '0';
  signal rd_en_i              : std_logic := '0';
  signal pad0_flag_i          : std_logic := '0';
  signal pad1_flag_i          : std_logic := '0';
  signal link_status_sync     : std_logic := '0';
  signal tag_marker_i         : std_logic := '0';
  signal crc_value_i          : std_logic := '0';
  signal wr_en_p              : std_logic                     := '0';
  signal buf_ptr_inc          : std_logic                     := '0';
  signal buf_ptr_dec          : std_logic                     := '0';
  signal buf_rst_r, buf_rst_w : std_logic                     := '0';
  signal buf_ptr_cntrl        : std_logic_vector(1 downto 0)  := "00";
  signal link_id_0            : std_logic_vector(31 downto 0) := (others => '0');
  signal link_id_1            : std_logic_vector(31 downto 0) := (others => '0');
  signal link_id_0_frn        : std_logic_vector(31 downto 0) := (others => '0');
  signal link_id_1_frn        : std_logic_vector(31 downto 0) := (others => '0');
  signal crc_word_i           : std_logic_vector(16 downto 0) := (others => '0');
  signal received_index_i     : std_logic_vector(3 downto 0)  := (others => '0');
  signal index_number         : std_logic_vector(3 downto 0)  := (others => '0');
  signal received_index_latced: std_logic_vector(3 downto 0)  := (others => '0');
  signal special_bits_i       : std_logic_vector(7 downto 0)  := (others => '0');
  signal filler_detected_i    : std_logic := '0';
  signal index_lock           : std_logic := '0';
  signal index_corr_dec       : std_logic := '0';
  signal index_corr_inc       : std_logic := '0';
  signal locked               : std_logic := '0';
  signal filler_detected_i1   : std_logic := '0';


  attribute ASYNC_REG                  : string;
  attribute ASYNC_REG of rxMetadata_out : signal is "TRUE";

begin


  -- bit & reset sync
  --============================================================================================================================  
  bit_synchronizer_linkst_inst : entity work.emp_bit_synchronizer
    port map(
      clk_in => rxusrclk,
      i_in   => link_status_in,
      o_out  => link_status_sync
      );

  reset_synchronizer_bufrstw_inst : entity work.emp_reset_synchronizer
    port map(
      clk_in  => rxusrclk,
      rst_in  => rxram_pointer_ctrl_in.rst,
      rst_out => buf_rst_w
      );

  -- when rx pointer signals are driven by the freerun clock
  ttc_synchs : if TTC_DOMAIN = 0 generate

    bit_synchronizer_bufptrinc_in_inst : entity work.emp_bit_synchronizer
      port map(
        clk_in => ttc_clk,
        i_in   => rxram_pointer_ctrl_in.ptr_inc,
        o_out  => buf_ptr_inc
        );

    bit_synchronizer_bufptrdec_inst : entity work.emp_bit_synchronizer
      port map(
        clk_in => ttc_clk,
        i_in   => rxram_pointer_ctrl_in.ptr_dec,
        o_out  => buf_ptr_dec
        );

    reset_synchronizer_bufrst_inst : entity work.emp_reset_synchronizer
      port map(
        clk_in  => ttc_clk,
        rst_in  => rxram_pointer_ctrl_in.rst,
        rst_out => buf_rst_r
        );

  end generate ttc_synchs;

  -- when rx pointer signals are driven by the ttc clock
  ttc_signals : if TTC_DOMAIN = 1 generate

    buf_ptr_inc <= rxram_pointer_ctrl_in.ptr_inc;
    buf_ptr_dec <= rxram_pointer_ctrl_in.ptr_dec;
    buf_rst_r   <= rxram_pointer_ctrl_in.rst;

  end generate;
  --============================================================================================================================  

  -- detect filler control words
  --============================================================================================================================  
  tag_marker_i  <= '1' when  (rx_data_in(59 downto 56) = TAG_CODE  and valid_bit_in = '0' and rx_datavalid_in = '1') else '0';
  pad0_flag_i   <= '1' when  (rx_data_in(59 downto 56) = PAD0_CODE and valid_bit_in = '0' and rx_datavalid_in = '1') else '0';
  pad1_flag_i   <= '1' when  (rx_data_in(59 downto 56) = PAD1_CODE and valid_bit_in = '0' and rx_datavalid_in = '1') else '0';
  crc_value_i   <= '1' when  (rx_data_in(59 downto 56) = CRCV_CODE and valid_bit_in = '0' and rx_datavalid_in = '1') else '0';
  
  filler_detected_i <= (tag_marker_i or pad0_flag_i or pad1_flag_i or crc_value_i);


  wr_en_i <= rx_datavalid_in and not filler_detected_i;  
  --============================================================================================================================  


  -- index correction
  --============================================================================================================================  
  process(rxusrclk)
  begin
      if rising_edge(rxusrclk) then
          if rst_rx = '1' then
              received_index_i   <= (others => '0');
              filler_detected_i1 <= '0';
          else
              if filler_detected_i = '1' then
                  received_index_i <= rx_data_in(55 downto 52);
              end if;
              filler_detected_i1   <= filler_detected_i;
          end if;
      end if;
  end process;
   
  index_correction: entity work.rx_index_corr
  port map(
    freerun_clk              => freerun_clk,  
    rxusrclk                 => rxusrclk,         
    ttc_clk                  => ttc_clk,            
    rst_rx                   => rst_rx,             
    rst_ttc                  => rst_ttc,              
    rst_latched              => rst_latched,              
    rst_cntr_rx              => rst_cntr_rx,              
    disable_ICM_in           => disable_ICM_in,    
    received_index_in        => received_index_i,    
    filler_detected_in       => filler_detected_i1,   
    rx_datavalid_in          => rx_datavalid_in,  
    index_lock_lost_out      => index_lock_lost_out,  
    index_lock_lost_cntr_out => index_lock_lost_cntr_out,  
    wrong_index_cntr_out     => wrong_index_cntr_out,  
    index_corr_inc_out       => index_corr_inc,      
    index_corr_dec_out       => index_corr_dec
  );       
  --============================================================================================================================  
  

  -- extract crc value and special bits from corresponding filler word
  --============================================================================================================================  
  process(rxusrclk)
  begin
    if rising_edge(rxusrclk) then
      if rst_rx = '1' then
        crc_word_i <= (others => '0');
      else
        wr_en_p <= wr_en_i;

        if crc_value_i = '1' then
          -- crc16 
          crc_word_i     <= "1" & rx_data_in(15 downto 0);
          -- special bits
          special_bits_i <= rx_data_in(31 downto 24);
        else
          if (wr_en_i = '1' and not wr_en_p = '1') then
            crc_word_i(16)          <= '0';
          end if;
        end if;
      end if;
    end if;
  end process;
  --============================================================================================================================  


  -- extract link id 0 and link id 1 from corresponding filler words
  --============================================================================================================================    
  process(rxusrclk)
  begin
    if rising_edge(rxusrclk) then
      if rst_rx = '1' then
        link_id_0 <= (others => '0');
        link_id_1 <= (others => '0');
      else
        if pad0_flag_i = '1' then
          link_id_0 <= rx_data_in(31 downto 0);
        end if;
        if pad1_flag_i = '1' then
          link_id_1 <= rx_data_in(31 downto 0);
        end if;
      end if;
    end if;
  end process;

  -- write link metadata info to free run clock
  process(freerun_clk)
  begin
    if rising_edge(freerun_clk) then
      rxMetadata_out.channel_id     <= link_id_0(7 downto 0);
      rxMetadata_out.slot_id        <= link_id_0(11 downto 8);
      rxMetadata_out.crate_id       <= link_id_0(19 downto 12);
      rxMetadata_out.clk_multiplier <= link_id_1(3 downto 0);
      rxMetadata_out.packet_size    <= link_id_1(11 downto 4);
      rxMetadata_out.tm_interval    <= link_id_1(16 downto 12);
      rxMetadata_out.IM             <= link_id_1(17);
    end if;
  end process;
  --============================================================================================================================  


  -- output filler tag
  --============================================================================================================================  
  process(rxusrclk)
  begin
    if rising_edge(rxusrclk) then
      if rst_rx = '1' then
        filler_tag_out <= '0';
      else
        if rx_datavalid_in = '1' and pad0_flag_i = '0' and pad1_flag_i = '0' then
--        if rx_datavalid_in = '1' then
          filler_tag_out <= tag_marker_i;
        end if;
      end if;
    end if;
  end process;
--============================================================================================================================  


-- BRAM Pointers
--============================================================================================================================  
  wbuf_sm : process (rxusrclk)
  begin
    if rising_edge(rxusrclk) then
      if (rst_rx = '1') then
        wbuf_add <= 100;
      else
        if buf_rst_w = '1' then
          wbuf_add <= 15;
        else
          if wr_en_i = '0' then
            -- Padding word.  Do not place in FIFO.
            wbuf_add <= wbuf_add;
          else
            if wbuf_add < BRAM_DEPTH-1 then
              wbuf_add <= wbuf_add + 1;
            else
              wbuf_add <= 0;
            end if;
          end if;
        end if;
      end if;
    end if;
  end process wbuf_sm;


  buf_ptr_cntrl <= (buf_ptr_inc or index_corr_inc) & (buf_ptr_dec or index_corr_dec);

  rbuf_sm : process (ttc_clk)
  begin
    if rising_edge(ttc_clk) then
      if (rst_ttc = '1') then
        rbuf_add <= 0;
      else
        if (buf_rst_r = '1') then
          rbuf_add <= 10;
        else
          case buf_ptr_cntrl is
            when "01" =>                -- Subtract 1 ptr location
              rbuf_add <= rbuf_add;
            when "10" =>                -- Add 1 ptr location
              case rbuf_add is
                when BRAM_DEPTH-2 =>
                  rbuf_add <= 0;
                when BRAM_DEPTH-1 =>
                  rbuf_add <= 1;
                when others =>
                  rbuf_add <= rbuf_add + 2;
              end case;
            when others =>              -- Behave normally.
              case rbuf_add is
                when BRAM_DEPTH-1 =>
                  rbuf_add <= 0;
                when others =>
                  rbuf_add <= rbuf_add + 1;
              end case;
          end case;
        end if;
      end if;
    end if;
  end process rbuf_sm;
--============================================================================================================================  

  -- out ports
  wbuf_add_word_out <= std_logic_vector(to_unsigned(wbuf_add, 9));
  rbuf_add_word_out <= std_logic_vector(to_unsigned(rbuf_add, 9));
  wr_en_out         <= wr_en_i;
  crc_word_out      <= crc_word_i;
  special_bits_out  <= special_bits_i;
 
end architecture;
