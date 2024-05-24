----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.11.2023 18:33:39
-- Design Name: 
-- Module Name: fsm_contadores_TB - Behavioral
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

entity fsm_contadores_TB is
end fsm_contadores_TB;

architecture Behavioral of fsm_contadores_TB is
    component fsm_contadores is
        Port (  reset : IN STD_LOGIC;                                   -- Reset del sistema
                clock : IN STD_LOGIC;                                   -- Reloj del sistema
                enable : IN STD_LOGIC;                              -- Fin cuenta timer 500 ms
                fila_final : IN STD_LOGIC;                              -- Alcanzado fin max/min filas    
                columna_final : IN STD_LOGIC;                           -- Alcanzado fin max/min columnas  
                ascendente_descendente_fila : OUT STD_LOGIC;            -- Fila++ si = 0. Fila -- si = 1.
                enable_fila : OUT STD_LOGIC;                            -- Enable para contador de filas
                ascendente_descendente_columna : OUT STD_LOGIC;         -- Columna++ si = 0. Columna -- si = 1.
                enable_columna : OUT STD_LOGIC);                        -- Enable para contador de columnas                    
                
    end component;
    
    signal clock_est : STD_LOGIC := '0';
    signal reset_est : STD_LOGIC := '0';
    signal fin_cuenta_est : STD_LOGIC := '0';
    signal fila_final_est : STD_LOGIC := '0'; 
    signal columna_final_est : STD_LOGIC := '0';
    signal ascendente_descendente_fila_est : STD_LOGIC;
    signal enable_fila_est : STD_LOGIC := '0';
    signal ascendente_descendente_columna_est : STD_LOGIC;
    signal enable_columna_est : STD_LOGIC := '0';
    constant PERIOD : time := 20ns;
    
begin

    UUT: fsm_contadores
        port map (  reset => reset_est,                                   -- Reset del sistema
                    clock => clock_est,                                   -- Reloj del sistema
                    enable => fin_cuenta_est,                              -- Fin cuenta timer 500 ms
                    fila_final => fila_final_est,                              -- Alcanzado fin max/min filas    
                    columna_final => columna_final_est,                           -- Alcanzado fin max/min columnas  
                    ascendente_descendente_fila => ascendente_descendente_fila_est,            -- Fila++ si = 0. Fila -- si = 1.
                    enable_fila => enable_fila_est,                           -- Enable para contador de filas
                    ascendente_descendente_columna => ascendente_descendente_columna_est,         -- Columna++ si = 0. Columna -- si = 1.
                    enable_columna => enable_columna_est);                        -- Enable para contador de columnas  

    clock_est <= not clock_est after PERIOD/2;
    reset_est <= '1', '0' after 100 ns;
    fin_cuenta_est <= not fin_cuenta_est after PERIOD;
    columna_final_est <= '0', '1' after 200 ns, '0' after 220 ns, '1' after 500 ns, '0' after 520 ns;
    fila_final_est <= '0', '1' after 400 ns, '0' after 420 ns, '1' after 800 ns, '0' after 820 ns;
    
end Behavioral;
