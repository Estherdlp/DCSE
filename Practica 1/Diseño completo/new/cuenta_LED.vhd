----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.10.2023 11:52:52
-- Design Name: 
-- Module Name: cuenta_LED - Behavioral
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

entity cuenta_LED is
    Port ( clock : in STD_LOGIC;                        -- Reloj del sistema                                                  
           reset : in STD_LOGIC;                        -- Reset del sistema BTN0    
           enable : in STD_LOGIC;                       -- Habilitacion cada 100 ms para conteo de decimas de segundo      
           conteo_binario_led : out STD_LOGIC_VECTOR (3 downto 0)); -- Conteo binario de las decimas de segundo          
end cuenta_LED;

architecture Behavioral of cuenta_LED is

    signal fin_cuenta_signal: STD_LOGIC := '0';         -- Señal intermedia fin de cuenta
    signal cuenta_actual_signal: unsigned (3 downto 0) := (others => '0');   -- Señal intermedia valor de cuenta actual

begin

    p_contador: process (reset, clock, fin_cuenta_signal)
    begin
        if reset = '1' then                             -- Si reset, volver a estado inicial
            cuenta_actual_signal <= (others => '0');
        elsif clock'event and clock = '1' then          -- Si pulso de reloj, comprobar habilitacion  
            if enable = '1' then
                if fin_cuenta_signal = '1' then         -- Si fin de cuenta, volver a estado inicial
                    cuenta_actual_signal <= (others => '0');
                else
                    cuenta_actual_signal <= cuenta_actual_signal + 1;   -- Si no fin de cuenta, sumar 1
                end if;
            end if;
        end if;
    end process;
    
    -- Activacion fin de cuenta si cuenta = 9
    fin_cuenta_signal <= '1' when (cuenta_actual_signal = 9) else '0';
    
    -- Salidas del contador binario
    conteo_binario_led <= std_logic_vector(cuenta_actual_signal);
    
end Behavioral;
