----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.10.2023 12:04:38
-- Design Name: 
-- Module Name: cuenta_LED_TB - Behavioral
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

entity cuenta_LED_TB is
end cuenta_LED_TB;

architecture Behavioral of cuenta_LED_TB is
    component cuenta_LED is
        Port ( clock : in STD_LOGIC;
               reset : in STD_LOGIC;
               enable : in STD_LOGIC;
               conteo_binario_led : out STD_LOGIC_VECTOR (3 downto 0));
    end component;
    
    signal reset_est : STD_LOGIC := '0';
    signal clock_est : STD_LOGIC := '0';
    signal enable_est : STD_LOGIC := '0';
    signal conteo_binario_led_est : STD_LOGIC_VECTOR (3 downto 0);
    constant PERIOD : time := 20ns;
    
begin
    UUT: cuenta_LED
        port map( reset => reset_est,
                  clock => clock_est,
                  enable => enable_est,
                  conteo_binario_led => conteo_binario_led_est);
                  
                  
    clock_est <= not clock_est after PERIOD/2;
    --reset_est <= '1', '0' after 100 ns, '1' after 300 ns, '0' after 500 ns;
    --enable_est <= '1', '0' after 70ns, '1' after 140ns, '0' after 210ns, '1' after 280ns, '0' after 350ns, '1' after 420ns, '0' after 490ns, '1' after 560ns;
    enable_est <= not enable_est after PERIOD;

end Behavioral;
