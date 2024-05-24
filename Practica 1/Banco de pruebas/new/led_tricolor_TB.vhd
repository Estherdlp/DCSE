----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.10.2023 23:05:10
-- Design Name: 
-- Module Name: led_tricolor_TB - Behavioral
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

entity led_tricolor_TB is
end led_tricolor_TB;

architecture Behavioral of led_tricolor_TB is
    component led_tricolor is
        Port (    reset : IN STD_LOGIC;                 -- Entrada de reset
                  clock : IN STD_LOGIC;                 -- Entrada de reloj
                  enable : IN STD_LOGIC;                -- Entrada de habilitacion
                  cambio_estado : IN STD_LOGIC;            -- Cuenta 500 ms
                  salida_led_tricolor : OUT STD_LOGIC_VECTOR (2 downto 0));
    end component;
    
    signal clock_est : STD_LOGIC := '0';
    signal reset_est : STD_LOGIC := '0';
    signal enable_est : STD_LOGIC := '0';
    signal cambio_estado_est : STD_LOGIC := '0';
    signal salida_led_tricolor_est : STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
    constant PERIOD : time := 20ns;
    
begin

    UUT: led_tricolor
    port map (reset => reset_est,
              clock => clock_est,
              enable => enable_est,
              cambio_estado => cambio_estado_est,
              salida_led_tricolor => salida_led_tricolor_est);
              
    clock_est <= not clock_est after PERIOD/2;
    cambio_estado_est <= '0', '1' after 100 ns,'0' after 120 ns,'1' after 200 ns,'0' after 220 ns,'1' after 300 ns,'0' after 320 ns,'1' after 400 ns,'0' after 420 ns,'1' after 500 ns,'0' after 520 ns,'1' after 600 ns,'0' after 620 ns,'1' after 2700 ns,'0' after 720 ns,'1' after 800 ns,'0' after 820 ns;
    reset_est <= '0', '1' after 100 ns, '0' after 200 ns, '1' after 420 ns, '0' after 440 ns;
    enable_est <= '1','0' after 100 ns, '1' after 250 ns;
    
end Behavioral;
