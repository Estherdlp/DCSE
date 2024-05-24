----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.10.2023 20:20:53
-- Design Name: 
-- Module Name: contador - Behavioral
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

entity contador is
    Generic ( num_bits : integer := 27;                     -- Numero de bits necesarios para almacenar el valor de cuenta
              valor_fin_cuenta : integer := 120000000);     -- Valor fin de cuenta del contador
    Port (    reset : IN STD_LOGIC;                         -- Reset del sistema BTN0
              clock : IN STD_LOGIC;                         -- Entrada reloj del sistema
              enable : IN STD_LOGIC;                        -- Habilitacion contador
              ascendente_descendente : IN STD_LOGIC;        -- Interruptor para cuenta ascendente o descendente
              fin_cuenta : OUT STD_LOGIC;                   -- Señal fin de cuenta
              valor_cuenta_actual : out STD_LOGIC_VECTOR (num_bits - 1 downto 0));  -- Valor actual de cuenta
end contador;

architecture Behavioral of contador is

    signal fin_cuenta_signal: STD_LOGIC := '0';             -- Señal intermedia fin de cuenta
    signal cuenta_actual_signal: unsigned (num_bits - 1 downto 0) := (others => '0');   -- Señal intermedia valor de cuenta actual
    
begin

    p_contador: process (reset, clock)
    begin
        if reset = '1' then
            cuenta_actual_signal <= (others => '0');
        elsif clock'event and clock = '1' then                      -- Comprobar habilitacion cada pulso de reloj
            if enable = '1' then
                if fin_cuenta_signal = '1' then
                    if ascendente_descendente = '1' then            -- Si fin de cuenta, comprobar valor de reinicio
                        cuenta_actual_signal <= to_unsigned(valor_fin_cuenta - 1, num_bits); -- Reiniciar como 59 si cuenta descendente
                    else
                        cuenta_actual_signal <= (others => '0');    -- Reiniciar como 0 si cuenta descendente
                    end if;
                else                                                -- Si no fin cuenta, sumar si ascendente y restar si descendente
                    if ascendente_descendente = '1' then
                        cuenta_actual_signal <= cuenta_actual_signal - 1;
                    else
                        cuenta_actual_signal <= cuenta_actual_signal + 1;
                    end if;
                end if;
            end if;
        end if;
    end process;
      
    -- Activacion fin de cuenta si en ascendente = 59 o en descendente = 0
    fin_cuenta_signal <= '1' when (cuenta_actual_signal = valor_fin_cuenta - 1) and ascendente_descendente = '0' else
                         '1' when cuenta_actual_signal = 0 and ascendente_descendente = '1'
                         else '0';
    
    -- Cargar señales intermedias en las salidas
    valor_cuenta_actual <= std_logic_vector(cuenta_actual_signal);
    fin_cuenta <= fin_cuenta_signal;
      
end Behavioral;
