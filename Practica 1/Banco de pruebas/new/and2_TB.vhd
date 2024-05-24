----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.10.2023 22:36:49
-- Design Name: 
-- Module Name: and2_TB - Behavioral
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

entity and2_TB is
end and2_TB;

architecture Behavioral of and2_TB is
    component and2 is
        Port ( in_0 : in STD_LOGIC;
               in_1 : in STD_LOGIC;
               out_0 : out STD_LOGIC);
    end component;
    
    signal in_0_est : STD_LOGIC;
    signal in_1_est : STD_LOGIC;
    signal out_0_est : STD_LOGIC;
    
begin
    UUT: and2
        port map (in_0 => in_0_est,
                  in_1 => in_1_est,
                  out_0 => out_0_est);  

    in_0_est <= '0', '1' after 100ns, '0' after 700ns;
    in_1_est <= '1', '0' after 350ns, '1' after 550ns ;

end Behavioral;
