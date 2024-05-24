----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.11.2023 19:39:21
-- Design Name: 
-- Module Name: fsm_timer_and_conts_TB - Behavioral
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

entity fsm_timer_and_conts_TB is
end fsm_timer_and_conts_TB;

architecture Behavioral of fsm_timer_and_conts_TB is
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
    
    component contador
        Generic ( num_bits : integer := 26;            
                  valor_fin_cuenta : integer := 62500000);
        Port(     reset : IN STD_LOGIC;
                  clock : IN STD_LOGIC;
                  enable : IN STD_LOGIC;
                  ascendente_descendente : IN STD_LOGIC;                -- Interruptor para cuenta ascendente o descendente
                  fin_cuenta : OUT STD_LOGIC;
                  valor_cuenta_actual : out STD_LOGIC_VECTOR (num_bits - 1 downto 0));
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
    
    signal enable_est : STD_LOGIC := '1';
    signal enable_filas_and_est : STD_LOGIC := '0';
    signal enable_columnas_and_est : STD_LOGIC := '0';
    signal ascendente_descendente_est : STD_LOGIC := '0';
    signal valor_cuenta_divisor_est : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
    
    signal valor_actual_filas_est : STD_LOGIC_VECTOR (1 downto 0);  -- Posicion de fila actual
    signal valor_actual_columnas_est : STD_LOGIC_VECTOR (1 downto 0); -- Posicion de columna actual
    constant PERIOD : time := 20ns;


begin
    UUT_1: fsm_contadores
        port map (  reset => reset_est,                                   -- Reset del sistema
                    clock => clock_est,                                   -- Reloj del sistema
                    enable => fin_cuenta_est,                              -- Fin cuenta timer 500 ms
                    fila_final => fila_final_est,                              -- Alcanzado fin max/min filas    
                    columna_final => columna_final_est,                           -- Alcanzado fin max/min columnas  
                    ascendente_descendente_fila => ascendente_descendente_fila_est,            -- Fila++ si = 0. Fila -- si = 1.
                    enable_fila => enable_fila_est,                           -- Enable para contador de filas
                    ascendente_descendente_columna => ascendente_descendente_columna_est,         -- Columna++ si = 0. Columna -- si = 1.
                    enable_columna => enable_columna_est);                        -- Enable para contador de columnas  
    -- Divisor de frecuencia para obtener pulsos             
    UUT_2: contador
        generic map (num_bits => 4, valor_fin_cuenta => 10)
        port map (  reset => reset_est,
                    clock => clock_est,
                    enable => enable_est,
                    ascendente_descendente => ascendente_descendente_est,
                    fin_cuenta => fin_cuenta_est,
                    valor_cuenta_actual => valor_cuenta_divisor_est);
    -- Contador de filas                
    UUT_3: contador     -- Filas
        generic map (num_bits => 2, valor_fin_cuenta => 4)
        port map (  reset => reset_est,
                    clock => clock_est,
                    enable => enable_filas_and_est,
                    ascendente_descendente => ascendente_descendente_fila_est,
                    fin_cuenta => fila_final_est,
                    valor_cuenta_actual => valor_actual_filas_est);
    -- Contador de columnas                
    UUT_4: contador
        generic map (num_bits => 2, valor_fin_cuenta => 2)
        port map (  reset => reset_est,
                    clock => clock_est,
                    enable => enable_columnas_and_est,
                    ascendente_descendente => ascendente_descendente_columna_est,
                    fin_cuenta => columna_final_est,
                    valor_cuenta_actual => valor_actual_columnas_est);
                    
    clock_est <= not clock_est after PERIOD/2;
    reset_est <= '1', '0' after 100 ns;                
 
    enable_filas_and_est <= enable_fila_est and fin_cuenta_est;
    enable_columnas_and_est <= enable_columna_est and fin_cuenta_est;
 
end Behavioral;
