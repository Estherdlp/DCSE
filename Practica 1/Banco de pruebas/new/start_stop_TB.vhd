----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.10.2023 00:22:25
-- Design Name: 
-- Module Name: start_stop_TB - Behavioral
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

entity start_stop_TB is
end start_stop_TB;

architecture Behavioral of start_stop_TB is
    component start_stop is
        Port ( reset : IN STD_LOGIC;                 -- Entrada de reset
               clock : IN STD_LOGIC;                 -- Entrada de reloj
               boton : IN STD_LOGIC;                 -- Entrada de habilitacion
               enable_sistema : OUT STD_LOGIC);         -- Pulso timer por cuenta 500 ms
    
    end component;
    
    signal reset_est : STD_LOGIC := '0';
    signal clock_est : STD_LOGIC := '0';
    signal boton_est : STD_LOGIC := '0';
    signal enable_sistema_est : STD_LOGIC := '0';
    constant PERIOD : time := 20ns;
    
begin
    UUT: start_stop
        port map( reset => reset_est,
                  clock => clock_est,
                  boton => boton_est,
                  enable_sistema => enable_sistema_est);

    clock_est <= not clock_est after PERIOD/2;
    reset_est <= '1', '0' after 100 ns, '1' after 300 ns, '0' after 500 ns;
    boton_est <= '1', '0' after 70ns, '1' after 140ns, '0' after 210ns, '1' after 280ns, '0' after 350ns, '1' after 420ns, '0' after 490ns, '1' after 560ns;

end Behavioral;
