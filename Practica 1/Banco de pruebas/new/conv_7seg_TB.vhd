----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.10.2023 15:51:49
-- Design Name: 
-- Module Name: conv_7seg_TB - Behavioral
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

entity conv_7seg_TB is
--  Port ( );
end conv_7seg_TB;

architecture Behavioral of conv_7seg_TB is
    component conv_7seg is
        Port ( entrada_7seg : in STD_LOGIC_VECTOR (3 downto 0);
               salida_7seg : out STD_LOGIC_VECTOR (6 downto 0));
    end component;
    
    signal entrada_7seg_est: STD_LOGIC_VECTOR (3 downto 0);
    signal salida_7seg_est: STD_LOGIC_VECTOR (6 downto 0);

begin
    UUT: conv_7seg port map(
        entrada_7seg => entrada_7seg_est,
        salida_7seg => salida_7seg_est
    );


    entrada_7seg_est <= "0000", "0001" after 100ns, "0010" after 200 ns, "0011" after 300 ns, "0100" after 400 ns, "0101" after 500 ns, "0110" after 600 ns;

end Behavioral;
