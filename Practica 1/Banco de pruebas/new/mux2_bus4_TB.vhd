----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.10.2023 20:58:31
-- Design Name: 
-- Module Name: mux2_bus4_TB - Behavioral
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

entity mux2_bus4_TB is

end mux2_bus4_TB;

architecture Behavioral of mux2_bus4_TB is
    component mux2_bus4 is
    Port ( In_0 : in STD_LOGIC_VECTOR (3 downto 0);
           In_1 : in STD_LOGIC_VECTOR (3 downto 0);
           Sel : in STD_LOGIC;
           Q_0 : out STD_LOGIC_VECTOR (3 downto 0));
    end component;
    
    signal In_0_sig: STD_LOGIC_VECTOR (3 downto 0);
    signal In_1_sig: STD_LOGIC_VECTOR (3 downto 0);
    signal Sel_sig: STD_LOGIC;
    signal Q_0_sig: STD_LOGIC_VECTOR (3 downto 0);
    
begin
    UUT: mux2_bus4 port map(
        In_0 => In_0_sig,
        In_1 => In_1_sig,
        Sel => Sel_sig,
        Q_0 => Q_0_sig
    );
    
    In_0_sig <= "0000", "0001" after 100ns, "0010" after 200 ns, "0011" after 300 ns, "0100" after 400 ns, "0101" after 500 ns, "0110" after 600 ns;
    In_1_sig <= "1111", "1110" after 80 ns, "1101" after 160 ns, "1100" after 240 ns, "1011" after 320 ns, "1010" after 400 ns, "1001" after 480 ns;
    Sel_sig <= '1', '0' after 70ns, '1' after 140ns, '0' after 210ns, '1' after 280ns, '0' after 350ns, '1' after 420ns, '0' after 490ns, '1' after 560ns;
    
end Behavioral;
