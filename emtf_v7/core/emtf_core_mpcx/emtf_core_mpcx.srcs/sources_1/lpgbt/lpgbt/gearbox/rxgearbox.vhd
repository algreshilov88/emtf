-------------------------------------------------------
--! @file
--! @author Julian Mendez <julian.mendez@cern.ch> (CERN - EP-ESE-BE)
--! @version 1.0
--! @brief Tx gearbox
-------------------------------------------------------

--! Include the IEEE VHDL standard library
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--! @brief rxGearbox - Rx Gearbox
--! @details 
--! The Rx gearbox module is used to ensure the MGT to Datapath clock domain
--! crossing. It takes the c_inputWidth bit words in input and generates an c_outputWidth bit
--! word every c_clockRatio clock cycle. When the clock ratio is bigger than the word ratio (oversampling),
--! each word get from each phase is stored in different words that are concatenated and set in output.
--! E.g.: (A0)(A1)(B0)(B1)(C0)(C1) where (A0) and (A1) are the "same bit" (2 samples took by the MGT in the same UI, 
--!       because of the oversampling), the output is (A0)(B0)(C0)(A1)(B1)(B1).
entity rxGearbox is
    generic (
        c_clockRatio                  : integer;                                                         --! Clock ratio is clock_out / clock_in (shall be an integer)
        c_inputWidth                  : integer;                                                         --! Bus size of the input word
        c_outputWidth                 : integer;                                                         --! Bus size of the output word (Warning: c_clockRatio/(c_inputWidth/c_outputWidth) shall be an integer)
        c_counterInitValue            : integer := 2                                                     --! Initialization value of the gearbox counter (3 for simulation / 2 for real HW)
    );
    port (
        -- Clock and reset
        clk_inClk_i                   : in  std_logic;                                                   --! Input clock (from MGT)
        clk_outClk_i                  : in  std_logic;                                                   --! Output clock (from MGT)
        clk_clkEn_i                   : in  std_logic;                                                   --! Clock enable (e.g.: header flag)
        clk_dataFlag_o                : out std_logic;
        
        rst_gearbox_i                 : in  std_logic;                                                   --! Reset signal
        
        -- Data
        dat_inFrame_i                 : in  std_logic_vector((c_inputWidth-1) downto 0);                 --! Input data from MGT
        dat_outFrame_o                : out std_logic_vector((c_inputWidth*c_clockRatio)-1 downto 0);    --! Output data, concatenation of word when the word ratio is lower than clock ration (e.g.: out <= word & word;)

        -- Status
        sta_gbRdy_o                   : out std_logic                                                    --! Ready signal
    );
end rxGearbox;

--! @brief rxGearbox - Rx Gearbox
--! @details 
--! The rxGearbox implements a register based clock domain crossing system. Using different clock
--! for the input and output require a special attention on the phase relation between these two
--! signals.
architecture behavioral of rxGearbox is

    --==================================== User Logic =====================================--
    constant c_oversampling                      : integer := c_clockRatio/(c_outputWidth/c_inputWidth);
    
    signal reg0                                  : std_logic_vector (((c_inputWidth*c_clockRatio)-1) downto 0);
    signal reg1                                  : std_logic_vector (((c_inputWidth*c_clockRatio)-1) downto 0);
    signal rxFrame_inverted_s                    : std_logic_vector (((c_inputWidth*c_clockRatio)-1) downto 0);
     
    signal gbReset_s                             : std_logic;
    signal sta_gbRdy_s0                          : std_logic;
    signal sta_gbRdy_s                           : std_logic;
    signal clk_dataFlag_s                        : std_logic;
    
    signal dat_outFrame_s                        : std_logic_vector((c_inputWidth*c_clockRatio)-1 downto 0);
    
    signal dat_inFrame_s                         : std_logic_vector((c_inputWidth-1) downto 0);
    
    signal gbReset_outsynch_s                    : std_logic;
    signal clk_dataFlag_outsynch_s               : std_logic;
    signal sta_gbRdy_outsynch_s                  : std_logic;
    signal dat_outFrame_outsynch_s               : std_logic_vector((c_inputWidth*c_clockRatio)-1 downto 0);
    
    signal cdc_dout                              : std_logic_vector((c_inputWidth*c_clockRatio)-1 downto 0); -- output data for CDC fifo  
    signal cdc_valid                             : std_logic;
    --=====================================================================================--     
COMPONENT ge11_rx_fifo
  PORT (
    rst : IN STD_LOGIC;
    wr_clk : IN STD_LOGIC;
    rd_clk : IN STD_LOGIC;
    din : IN STD_LOGIC_VECTOR(255 DOWNTO 0);
    wr_en : IN STD_LOGIC;
    rd_en : IN STD_LOGIC;
    dout : OUT STD_LOGIC_VECTOR(255 DOWNTO 0);
    full : OUT STD_LOGIC;
    empty : OUT STD_LOGIC;
    valid : OUT STD_LOGIC;
    wr_rst_busy : OUT STD_LOGIC;
    rd_rst_busy : OUT STD_LOGIC
  );
END COMPONENT;

--=================================================================================================--
begin                 --========####   Architecture Body   ####========-- 
--=================================================================================================--  

    gbRstSynch_proc: process(rst_gearbox_i, clk_inClk_i)
    begin
    
        if rst_gearbox_i = '1' then
            gbReset_s  <= '1';
            
        elsif rising_edge(clk_inClk_i) then
        
            if clk_clkEn_i = '1' then
                gbReset_s <= '0';
            end if;
            
        end if;    
    end process;
    
    rxWordPipeline_proc: process(gbReset_s, clk_inClk_i)
      begin
        if gbReset_s = '1' then
            dat_inFrame_s <= (others => '0');
        elsif rising_edge(clk_inClk_i) then
            dat_inFrame_s <= dat_inFrame_i;
        end if;      
    end process;
    
    
    gbRegMan_proc: process(gbReset_s, clk_inClk_i)
        variable cnter              : integer range 0 to c_clockRatio;
    begin
    
        if gbReset_s = '1' then
            reg0           <= (others => '0');
            reg1           <= (others => '0');
            sta_gbRdy_s0   <= '0';
            
            cnter          := c_counterInitValue;
            
        elsif rising_edge(clk_inClk_i) then
            clk_dataFlag_s    <= '0';
            
            if cnter = 0 then
               reg1  <= reg0;
               clk_dataFlag_s <= '1';
               sta_gbRdy_s0   <= '1';
               sta_gbRdy_s    <= sta_gbRdy_s0; --Delay ready for 1 word. First word could be corrupted
            end if;
            
--            reg0((c_inputWidth*(1+cnter))-1 downto (c_inputWidth*cnter))     <= dat_inFrame_s;
-- Maq: reworking reg0 to be shift register, timing should be much better
            reg0 <= dat_inFrame_s & reg0 (((c_inputwidth * c_clockratio) - 1) downto c_inputwidth);    
            cnter                                                            := cnter + 1;
        
            if cnter = c_clockRatio then
               cnter := 0;
            end if;
        end if;

    end process;

    frameInverter: for i in ((c_inputWidth*c_clockRatio)-1) downto 0 generate
        rxFrame_inverted_s(i)                             <= reg1(((c_inputWidth*c_clockRatio)-1)-i);
    end generate;
    
    oversamplerMultPh: for i in 0 to (c_oversampling-1) generate
        oversamplerPhN: for j in 0 to (c_outputWidth-1) generate
            dat_outFrame_s((i*c_outputWidth)+j) <= rxFrame_inverted_s((j*c_oversampling)+i);
        end generate;
    end generate;
    
    -- Pipeline dat_outFrame_o to avoid clocking issue
    clkEnPipeline_proc: process(clk_outClk_i)
    begin
        if rising_edge(clk_outClk_i) then
            gbReset_outsynch_s       <= gbReset_s;
        end if;        
    end process;

    -- adding CDC fifo, since the logic in this module is not actually CDCing
    ge11_rx_fifo_i : ge11_rx_fifo
    PORT MAP 
    (
        rst    => rst_gearbox_i,
        wr_clk => clk_inClk_i,
        rd_clk => clk_outClk_i,
        din    => dat_outFrame_s,
        wr_en  => clk_dataFlag_s,
        rd_en  => '1',
        dout   => cdc_dout,
        full   => open,
        empty  => open,
        valid  => cdc_valid,
        wr_rst_busy => open,
        rd_rst_busy => open
    );
    
    
    outPipeline_proc: process(gbReset_outsynch_s, clk_outClk_i)
    begin    
        if gbReset_outsynch_s = '1' then
            dat_outFrame_o <= (others => '0');
            clk_dataFlag_o <= '0';
            sta_gbRdy_o    <= '0';
            
        elsif rising_edge(clk_outClk_i) then
        
            clk_dataFlag_o <= cdc_valid; --clk_dataFlag_s;
            dat_outFrame_o <= cdc_dout;  --dat_outFrame_s;          
            sta_gbRdy_o    <= cdc_valid; --sta_gbRdy_s;
            
        end if;    
    end process;
   --=====================================================================================--
end behavioral;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--