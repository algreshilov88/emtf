--------------------------------------------------------------------------------
-- tx datapath, kadamidi, 2020
-- includes all transmiter blocks that process payload data and prepares CSP 
-- frames 
--------------------------------------------------------------------------------

library ieee;
use ieee.STD_LOGIC_1164.all;

use work.package_links.all;
use work.emp_data_types.all;


entity tx_datapath is
  generic(
    INDEX                   : integer;
    CH                      : integer;
    MGT_KIND                : integer;
    TX_INST                 : integer
    );
  port(
    ttc_clk                 : in  std_logic;
    txusrclk                : in  std_logic;
    inject_error_in         : in  inject_error_t                               ;
    reset                   : in  std_logic;
    reset_cnt_in            : in  std_logic;
    reset_latched_in        : in  std_logic;
    tx_data_in              : in  lword;
    tx_idle_method_in       : in  std_logic;
    txMetadata_in           : in  linkTxMetadata_t;
    tx_data_out             : out std_logic_vector(DATA_WIDTH-1 downto 0);
    tx_sequence_out         : out std_logic_vector(6 downto 0);
    tx_header_out           : out std_logic_vector(5 downto 0);
    tx_datavalid_out        : out std_logic;
    txCtrlStatus_out        : out txCtrlnStatus_t
    );
end entity;

architecture RTL of tx_datapath is

  signal tx_datavalid_i    : std_logic;
  signal crc_word_i        : std_logic_vector(16 downto 0);
  signal tx_data_i         : std_logic_vector(63 downto 0);
  signal tx_data_o         : std_logic_vector(63 downto 0);
  signal txsequence_i      : std_logic_vector(6 downto 0);
  signal txsequence_i_s    : std_logic_vector(6 downto 0);
  signal tx_sequence_o     : std_logic_vector(6 downto 0);
  signal txheader_i        : std_logic_vector(2 downto 0);
  signal tx_header_o       : std_logic_vector(5 downto 0);
  signal tx_gb_datavalid_i : std_logic;
  signal tx_datavalid_o    : std_logic;
  signal rst_ttc           : std_logic;
  signal rst_tx            : std_logic;
  signal rst_latched       : std_logic;
  signal rst_cntr_ttc      : std_logic;
  
  signal tx_data_err       : std_logic_vector(63 downto 0);
  signal tx_header_err     : std_logic_vector(2 downto 0);
  signal tx_datavalid_err  : std_logic;
  signal tx_sequence_err   : std_logic_vector(6 downto 0);

begin


  tx_gen : if MGT_KIND = NOMGT generate

    tx_data_out     <= (others => '0');
    tx_header_out   <= (others => '0');
    tx_sequence_out <= (others => '0');

  else generate -- tx_gen

    reset_synchronizer_rstTtc_inst : entity work.emp_reset_synchronizer
      port map(
        clk_in  => ttc_clk,
        rst_in  => reset,
        rst_out => rst_ttc
        );
    reset_synchronizer_rstLnk_inst : entity work.emp_reset_synchronizer
      port map(
        clk_in  => txusrclk,
        rst_in  => reset,
        rst_out => rst_tx
        );
    reset_synchronizer_rstLatched_inst : entity work.emp_reset_synchronizer
      port map(
        clk_in  => ttc_clk,
        rst_in  => reset_latched_in,
        rst_out => rst_latched
        );
    reset_synchronizer_rstCntr_inst : entity work.emp_reset_synchronizer
      port map(
        clk_in  => ttc_clk,
        rst_in  => reset_cnt_in,
        rst_out => rst_cntr_ttc
        );

    -- Check Invalid input combinations
    --============================================================================================================================
    invalid_check : entity work.invalid_comp_check
      generic map(
        MGT_KIND => MGT_KIND
        )
      port map(
        clk                      => ttc_clk,
        rst_ttc                  => rst_ttc,
        rst_cntr_ttc             => rst_cntr_ttc,
        txdata_in                => tx_data_in,
        invalid_tx_comb_cntr_out => txCtrlStatus_out.invalid_tx_comb_cntr
        );
    --============================================================================================================================

    -- CRC Checksum Calculation
    --============================================================================================================================
    crc_gen : entity work.links_crc_tx
      generic map(
        MGT_KIND => MGT_KIND
        )
      port map(
        clk              => ttc_clk,
        rst              => rst_ttc,
        txdata_in        => tx_data_in,
        crc_word_out     => crc_word_i
        );
    --============================================================================================================================

    -- TX Gearbox Logic
    --============================================================================================================================
    gb_logic : entity work.tx_gearbox
      generic map(
        MGT_KIND => MGT_KIND
        )
      port map(
        txusrclk            => txusrclk,
        rst_tx              => rst_tx,
        tx_gb_datavalid_out => tx_gb_datavalid_i,
        tx_sequence_out     => txsequence_i
        );
    --============================================================================================================================

    -- Protocol Engine
    --============================================================================================================================
    prtcl_engine : entity work.tx_engine
      generic map(
        INDEX                  => INDEX,
        CH                     => CH
        )
      port map(
        ttc_clk                => ttc_clk,
        txusrclk               => txusrclk,
        rst_ttc                => rst_ttc,
        rst_tx                 => rst_tx,
        rst_latched            => rst_latched,
        txdata_in              => tx_data_in,
        crc_word_in            => crc_word_i,
        tx_idle_method_in      => tx_idle_method_in,
        upstream_link_error_in => '0', -- unconnected until undertaning of its operation
        tx_gb_datavalid_in     => tx_gb_datavalid_i,
        txsequence_in          => txsequence_i,
        txMetadata_in          => txMetadata_in,
        tx_data_out            => tx_data_i,
        tx_header_out          => txheader_i,
        txsequence_out         => txsequence_i_s,
        tx_gb_datavalid_out    => tx_datavalid_i,
        almost_full_out        => txCtrlStatus_out.almost_full,
        full_out               => txCtrlStatus_out.full
        );
    --============================================================================================================================

    -- Error injection
    --============================================================================================================================
    error_inj : entity work.error_injection
      port map(
        txusrclk           => txusrclk,
        reset              => rst_tx,
        inject_error_in    => inject_error_in,
        txdata_in          => tx_data_i,
        txheader_in        => txheader_i,
        tx_datavalid_in    => tx_datavalid_i,
        txsequence_in      => txsequence_i_s,
        txdata_out         => tx_data_err,
        txheader_out       => tx_header_err,
        tx_datavalid_out   => tx_datavalid_err,
        txsequence_out     => tx_sequence_err
        );    

    scrambler : entity work.scrambler_6567
      port map(
        txusrclk           => txusrclk,
        reset              => rst_tx,
        txdata_in          => tx_data_err,
        txheader_in        => tx_header_err,
        tx_datavalid_in    => tx_datavalid_err,
        txsequence_in      => tx_sequence_err,
        scrambled_data_out => tx_data_o,
        txheader_out       => tx_header_o,
        tx_datavalid_out   => tx_datavalid_o,
        txsequence_out     => tx_sequence_o
        );        
    --============================================================================================================================
    
    
    -- Scrambler
    --============================================================================================================================
--    scrambler : entity work.scrambler_6567
--      port map(
--        txusrclk           => txusrclk,
--        reset              => rst_tx,
--        txdata_in          => tx_data_i,
--        txheader_in        => txheader_i,
--        tx_datavalid_in    => tx_datavalid_i,
--        txsequence_in      => txsequence_i_s,
--        scrambled_data_out => tx_data_o,
--        txheader_out       => tx_header_o,
--        tx_datavalid_out   => tx_datavalid_o,
--        txsequence_out     => tx_sequence_o
--        );
    --============================================================================================================================

    -- out ports
    --============================================================================================================================
    tx_data_out      <= tx_data_o;
    tx_header_out    <= tx_header_o;
    tx_sequence_out  <= tx_sequence_o;
    tx_datavalid_out <= tx_datavalid_o; -- sim only
    --============================================================================================================================

  end generate tx_gen;

end architecture;
