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
    Port (  entrada_7seg : in STD_LOGIC_VECTOR (3 downto 0); -- Entrada conversor 7seg
            salida_7seg : out STD_LOGIC_VECTOR (7 downto 0));-- Salida conversor 7seg  
end conv_7seg;

architecture Behavioral of conv_7seg is

begin
    conv_7seg: process (entrada_7seg)
    begin
        case entrada_7seg is
            when "0000" => salida_7seg <= "10000001";  -- a1
            when "0100" => salida_7seg <= "00000001";  -- a2
            when "0101" => salida_7seg <= "00000010";  -- b2
            when "0110" => salida_7seg <= "00000100";  -- c2
            when "0111" => salida_7seg <= "00001000";  -- d2
            when "0011" => salida_7seg <= "10001000";  -- d1
            when "0001" => salida_7seg <= "10100000";  -- f1
            when "0010" => salida_7seg <= "10010000";  -- e1
            when others => salida_7seg <= "00000000";  -- Multivaluado
         end case;
end process;

end Behavioral;
