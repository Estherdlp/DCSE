----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.10.2023 20:02:30
-- Design Name: 
-- Module Name: conv_7seg - Behavioral
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

entity conv_7seg is
    Port ( entrada_7seg : in STD_LOGIC_VECTOR (3 downto 0); -- Entrada conversor 7seg 
           salida_7seg : out STD_LOGIC_VECTOR (6 downto 0));-- Salida conversor 7seg  
end conv_7seg;

architecture Behavioral of conv_7seg is

begin
conv_7seg: process (entrada_7seg)
    begin
    case entrada_7seg is
        when "0000" => salida_7seg <= "0111111";  -- 0
        when "0001" => salida_7seg <= "0000110";  -- 1
        when "0010" => salida_7seg <= "1011011";  -- 2
        when "0011" => salida_7seg <= "1001111";  -- 3
        when "0100" => salida_7seg <= "1100110";  -- 4
        when "0101" => salida_7seg <= "1101101";  -- 5
        when "0110" => salida_7seg <= "1111101";  -- 6
        when "0111" => salida_7seg <= "0000111";  -- 7
        when "1000" => salida_7seg <= "1111111";  -- 8
        when "1001" => salida_7seg <= "1101111";  -- 9
        when "1010" => salida_7seg <= "1110111";  -- A
        when "1011" => salida_7seg <= "0011111";  -- B
        when "1100" => salida_7seg <= "1001110";  -- C
        when "1101" => salida_7seg <= "0111101";  -- D
        when "1110" => salida_7seg <= "1001111";  -- E
        when "1111" => salida_7seg <= "1000111";  -- F
        when others => salida_7seg <= "0000000";  -- Multivaluado
     end case;
end process;

end Behavioral;
