----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.11.2023 18:19:31
-- Design Name: 
-- Module Name: fsm_velocidades_TB - Behavioral
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

entity fsm_velocidades_TB is
end fsm_velocidades_TB;

architecture Behavioral of fsm_velocidades_TB is
    component fsm_velocidades is    
        Port ( reset : IN STD_LOGIC;                                            -- Reset del sistema BTN0                                 
               clock : IN STD_LOGIC;                                            -- Reloj del sistema
               BTNU : IN STD_LOGIC;                                             -- BTNU cambio de velocidad
               S500milis : IN STD_LOGIC;
               S20milis : IN STD_LOGIC;
               S10milis : IN STD_LOGIC;
               velocidad_fsm : OUT STD_LOGIC);
    end component;
    
    signal clock_est : STD_LOGIC := '0';
    signal reset_est : STD_LOGIC := '0';
    signal BTNU_est : STD_LOGIC := '0';
    signal S500milis_est : STD_LOGIC := '0'; 
    signal S20milis_est : STD_LOGIC := '0';                               -- Salida timer 200 ms
    signal S10milis_est : STD_LOGIC := '0';                               -- Salida timer 100 ms
    signal velocidad_fsm_est : STD_LOGIC := '0';
    constant PERIOD : time := 20ns;
    
begin
    UUT_1: fsm_velocidades
        port map (  reset => reset_est,                                            -- Reset del sistema BTN0                                 
                    clock => clock_est,                                            -- Reloj del sistema
                    BTNU => BTNU_est,                                              -- BTNU cambio de velocidad
                    S500milis => S500milis_est,                                    
                    S20milis => S20milis_est,
                    S10milis => S10milis_est,
                    velocidad_fsm => velocidad_fsm_est);
    
    clock_est <= not clock_est after PERIOD/2;
    reset_est <= '1', '0' after 100 ns;
    
    BTNU_est <= '0', '1' after 50 ns, '0' after 230 ns, '1' after 500 ns, '0' after 530 ns, '1' after 800 ns, '0' after 830 ns, '1' after 900 ns, '0' after 1000 ns;

end Behavioral;
