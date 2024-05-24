----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.12.2023 14:25:16
-- Design Name: 
-- Module Name: colores_cronometro - Behavioral
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

entity colores_cronometro is
    Generic ( num_bits_bus : integer := 16);            -- Numero de bits del bus de datos
    Port ( Color_1 : in STD_LOGIC_VECTOR (num_bits_bus - 1 downto 0); -- Entrada 0 multiplexor 4 bits      
           Color_2 : in STD_LOGIC_VECTOR (num_bits_bus - 1 downto 0); -- Entrada 1 multiplexor 4 bits  
           Seleccion_color : in STD_LOGIC;                      -- Seleccion entrada multiplexor 
           Salida_color : out STD_LOGIC_VECTOR (num_bits_bus - 1 downto 0));-- Salida multiplexor 4 bits 
end colores_cronometro;

architecture Behavioral of colores_cronometro is

begin

    Salida_color <= Color_1 when Seleccion_color = '0' else Color_2;

end Behavioral;
