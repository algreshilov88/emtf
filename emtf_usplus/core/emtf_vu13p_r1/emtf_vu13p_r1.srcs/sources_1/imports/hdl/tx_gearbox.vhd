--------------------------------------------------------------------------------
-- tx gearbox, kadamidi, 2020
-- tx gearbox logic to support 64b67b encoding for either 32 (GTH) or 64 (GTY) 
-- bits internal data width 
--------------------------------------------------------------------------------


library ieee;
use ieee.STD_LOGIC_1164.all;
use ieee.STD_LOGIC_unsigned.all;

use work.package_links.all;


--------------------------------------------------------------------------------
entity tx_gearbox is
  generic(
    MGT_KIND : integer
    );
  port(
    txusrclk            : in  std_logic;
    rst_tx              : in  std_logic;
    tx_gb_datavalid_out : out std_logic;
    tx_sequence_out     : out std_logic_vector(6 downto 0)
    );
end entity;

architecture RTL of tx_gearbox is

  signal txsequence_i   : std_logic_vector(6 downto 0) := (others => '0');
  signal tx_datavalid_i : std_logic                    := '0';
  signal txseq_cnt_en   : std_logic;


begin


-- 64b/67b TX Gearbox logic for 32bit internal data width
--============================================================================================================================
  txgb_32b : if MGT_KIND = GTH16G generate

      process(txusrclk)
      begin
        if rising_edge(txusrclk) then
          if rst_tx = '1' then
            txsequence_i   <= "0000000";
            txseq_cnt_en   <= '1';
            tx_datavalid_i <= '0';
          else
            if (txsequence_i = "0010101" or txsequence_i = "0101011" or txsequence_i = "1000001") then
              tx_datavalid_i <= '0';
              txsequence_i   <= txsequence_i + '1';
            elsif txsequence_i = "1000010" then
              tx_datavalid_i <= '1';
              txsequence_i   <= "0000000";
            else
              txsequence_i   <= txsequence_i + '1';
              tx_datavalid_i <= '1';
            end if;
          end if;
        end if;
      end process;

  end generate txgb_32b;
--============================================================================================================================

-- 64b/67b TX Gearbox logic for 64 bit internal data width
--============================================================================================================================
  gb_64_67 : if MGT_KIND = GTY16G or MGT_KIND = GTY25G generate

      process(txusrclk)
      begin
        if rising_edge(txusrclk) then
          if rst_tx = '1' then
            txsequence_i   <= "0000000";
            txseq_cnt_en   <= '1';
            tx_datavalid_i <= '0';
          else
            if txseq_cnt_en = '1' then
              if (txsequence_i = "0010101" or txsequence_i = "0101011" or txsequence_i = "1000001") then
                tx_datavalid_i <= '0';
                txsequence_i   <= txsequence_i + '1';
              elsif txsequence_i = "1000010" then
                tx_datavalid_i <= '1';
                txsequence_i   <= "0000000";
              else
                txsequence_i   <= txsequence_i + '1';
                tx_datavalid_i <= '1';
              end if;
            end if;
            txseq_cnt_en <= not txseq_cnt_en;
          end if;
        end if;
      end process;

    end generate gb_64_67;
--============================================================================================================================

-- out ports
--============================================================================================================================
  tx_sequence_out     <= txsequence_i;
  tx_gb_datavalid_out <= tx_datavalid_i;
--============================================================================================================================

end RTL;
