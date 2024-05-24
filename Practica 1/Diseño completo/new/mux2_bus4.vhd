----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.10.2023 19:12:34
-- Design Name: 
-- Module Name: mux2_bus4 - Behavioral
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

entity mux2_bus4 is
    Port ( In_0 : in STD_LOGIC_VECTOR (3 downto 0); -- Entrada 0 multiplexor 4 bits      
           In_1 : in STD_LOGIC_VECTOR (3 downto 0); -- Entrada 1 multiplexor 4 bits  
           Sel : in STD_LOGIC;                      -- Seleccion entrada multiplexor 
           Q_0 : out STD_LOGIC_VECTOR (3 downto 0));-- Salida multiplexor 4 bits 
end mux2_bus4;

architecture Behavioral of mux2_bus4 is

begin

    mux2_bus4: Q_0 <= In_0 when Sel = '0' else In_1;
    
end Behavioral;
