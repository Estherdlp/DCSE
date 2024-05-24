----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.12.2023 17:36:24
-- Design Name: 
-- Module Name: colores_personaje - Behavioral
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

entity colores_personaje is
    Generic ( num_bits_bus : integer := 8);                         -- Numero de bits del bus de datos
    Port (  Color_1 : IN STD_LOGIC_VECTOR (num_bits_bus - 1 downto 0);  -- Entrada 0 multiplexor      
            Color_2 : IN STD_LOGIC_VECTOR (num_bits_bus - 1 downto 0);  -- Entrada 1 multiplexor 
            Color_3 : IN STD_LOGIC_VECTOR (num_bits_bus - 1 downto 0);  -- Entrada 2 multiplexor
            Color_4 : IN STD_LOGIC_VECTOR (num_bits_bus - 1 downto 0);  -- Entrada 3 multiplexor
            Seleccion_color : IN STD_LOGIC_VECTOR (3 - 1 downto 0);             -- Seleccion entrada multiplexor 
            Salida_color : OUT STD_LOGIC_VECTOR (num_bits_bus - 1 downto 0));   -- Salida multiplexor 
end colores_personaje;

architecture Behavioral of colores_personaje is

begin

    Salida_color <= Color_1 when Seleccion_color = "110" else
                    Color_2 when Seleccion_color = "000" else
                    Color_3;
                    
end Behavioral;
