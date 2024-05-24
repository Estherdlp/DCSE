----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.12.2023 17:12:12
-- Design Name: 
-- Module Name: cabecera_rom - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity cabecera_rom is
    Generic ( num_bits : integer := 27);                                        -- Numero de bits necesarios para almacenar el valor de cuenta
    Port (  valor_cuenta_actual : IN STD_LOGIC_VECTOR (num_bits - 1 downto 0);  -- Valor actual de cuenta
            cabecera : OUT STD_LOGIC_VECTOR (5 - 1 downto 0) := "00000"); -- Cabecera ROM minutos);
end cabecera_rom;

architecture Behavioral of cabecera_rom is

begin

    cabecera <= "00000" when valor_cuenta_actual = "0000" else
                "00001" when valor_cuenta_actual = "0001" else
                "00010" when valor_cuenta_actual = "0010" else
                "00011" when valor_cuenta_actual = "0011" else
                "00100" when valor_cuenta_actual = "0100" else
                "00101" when valor_cuenta_actual = "0101" else
                "00110" when valor_cuenta_actual = "0110" else
                "00111" when valor_cuenta_actual = "0111" else
                "01000" when valor_cuenta_actual = "1000" else
                "01001" when valor_cuenta_actual = "1001";

end Behavioral;
