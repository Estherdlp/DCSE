----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.12.2023 18:01:24
-- Design Name: 
-- Module Name: Counter_Clks - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Counter_Clks is
    Port (  clock : IN STD_LOGIC;                           -- sysclk reloj del sistema 125 MHz
            reset : IN STD_LOGIC;                           -- BTN0 reset del sistema
            enable_countClocks : IN STD_LOGIC;              -- Enable conteo ciclos S2-S3
            fin_cuenta_12us : IN STD_LOGIC;                 -- Fin cuenta 12us
            fin_cuenta_6us : IN STD_LOGIC;                  -- Fin cuenta 6us
            finClocks : OUT STD_LOGIC);                     -- Fin ciclos comunicacion mando                          
end Counter_Clks;

architecture Behavioral of Counter_Clks is
    signal num_clocks: unsigned (4 - 1 downto 0) := (others => '0');    -- Señal intermedia valor de cuenta actual
    signal finClocks_signal : STD_LOGIC := '0';                         -- Señal intermedia fin cuenta
begin

    cuenta : process (clock, reset)
    begin
        if reset = '1' then
            num_clocks <= (others => '0');   -- Si hay un reset, se reinicia la cuenta
        elsif clock'event and clock = '1' then
            if finClocks_signal = '1' and fin_cuenta_12us = '1' then    -- Reinicio del ciclo por fin de cuenta
                num_clocks <= (others => '0');
            else
                if enable_countClocks = '1' and fin_cuenta_12us = '1' then  -- +1 ciclo
                    num_clocks <= num_clocks + 1;
                end if;
            end if;
        end if;
    end process;
    
    finClocks <= finClocks_signal;
    
    reinicio: process (fin_cuenta_6us)    -- Cada 16 ciclos, señal de reinicio
    begin
        if fin_cuenta_6us'event and fin_cuenta_6us = '1' then
            if num_clocks = 15 then
                finClocks_signal <= '1';
            else
                finClocks_signal <= '0';
            end if;
        end if;
    end process;               

end Behavioral;
