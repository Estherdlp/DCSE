----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.12.2023 12:38:25
-- Design Name: 
-- Module Name: cronometro_personaje_TB - Behavioral
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

entity cronometro_personaje_TB is
--  Port ( );
end cronometro_personaje_TB;

architecture Behavioral of cronometro_personaje_TB is
    component contador is
        Generic ( num_bits : integer := 27;                     -- Numero de bits necesarios para almacenar el valor de cuenta
                  valor_fin_cuenta : integer := 120000000);     -- Valor fin de cuenta del contador
        Port (    reset : IN STD_LOGIC;                         -- Reset del sistema BTN0
                  clock : IN STD_LOGIC;                         -- Entrada reloj del sistema
                  enable : IN STD_LOGIC;                        -- Habilitacion contador
                  ascendente_descendente : IN STD_LOGIC;        -- Interruptor para cuenta ascendente o descendente
                  precarga : IN UNSIGNED (num_bits - 1 downto 0) := (others => '0');  -- Valor inicial de cuenta
                  fin_cuenta : OUT STD_LOGIC;                   -- Se�al fin de cuenta
                  valor_cuenta_actual : out STD_LOGIC_VECTOR (num_bits - 1 downto 0));  -- Valor actual de cuenta
    end component;
    
    signal clock_est : STD_LOGIC := '0';
    signal reset_est : STD_LOGIC := '0';
    signal ascendente_descendente_est : STD_LOGIC := '0';
    signal precarga_div : unsigned (21 - 1 downto 0) := (others => '0');
    signal precarga_sec : unsigned (4 - 1 downto 0) := (others => '0');
    signal start_est : STD_LOGIC;
    signal S1_est : STD_LOGIC;
    signal S10_est : STD_LOGIC;
    signal enable_decenas_est : STD_LOGIC;
    signal enable_minutos_est : STD_LOGIC;
    signal S60_est : STD_LOGIC;
    signal Smin_est : STD_LOGIC;
    signal valor_sec_actual_est : STD_LOGIC_VECTOR (4 - 1 downto 0) := (others => '0');
    signal valor_dec_actual_est : STD_LOGIC_VECTOR (4 - 1 downto 0) := (others => '0');
    signal valor_min_actual_est : STD_LOGIC_VECTOR (4 - 1 downto 0) := (others => '0');
    constant PERIOD : time := 1ns;
    
    signal reg1_est : STD_LOGIC := '0';       -- Detector de flancos 1    
    signal reg2_est : STD_LOGIC := '0';       -- Detector de flancos 2 
    signal flanco_est : STD_LOGIC := '0';     -- Flanco detectado     
    signal reinicio_est : STD_LOGIC := '0';   -- Reinicio cronometro
    signal inicio_cuenta_est : STD_LOGIC := '0';
    signal vuelta_actual : STD_LOGIC_VECTOR (4 - 1 downto 0) := (others => '0');   -- Valor de vuelta actual
    signal inicio_columna : STD_LOGIC_VECTOR (6 - 1 downto 0) := "001110";  -- Columna inicial - 14
    signal fin_columna : STD_LOGIC_VECTOR (6 - 1 downto 0) := "001101";     -- Columna reinicio por fin de vuelta - 13
    signal inicio_fila_1 : STD_LOGIC_VECTOR (6 - 1 downto 0) := "011011";   -- Fila meta - 27
    signal inicio_fila_2 : STD_LOGIC_VECTOR (6 - 1 downto 0) := "011010";   -- Fila meta - 26
    signal inicio_fila_3 : STD_LOGIC_VECTOR (6 - 1 downto 0) := "011001";   -- Fila meta - 25
    signal inicio_fila_4 : STD_LOGIC_VECTOR (6 - 1 downto 0) := "011000";   -- Fila meta - 24
    signal inicio_fila_5 : STD_LOGIC_VECTOR (6 - 1 downto 0) := "010111";   -- Fila meta - 23
    signal col_personaje : STD_LOGIC_VECTOR (6 - 1 DOWNTO 0);   -- Columna actual personaje
    signal fila_personaje : STD_LOGIC_VECTOR (6 - 1 DOWNTO 0);  -- Fila actual personaje
    signal buttons_snes : STD_LOGIC_VECTOR (12 DOWNTO 0) := (others => '1');       -- Vector estado botones mando
    
begin

    p_flanco: process (clock_est, reset_est)
    begin
        if reset_est = '1' then
            reg1_est <= '0';
            reg2_est <= '0';
        elsif clock_est'event and clock_est = '1' then  -- Si pulso de reloj, transicion de estados y de detector de flancos     
            reg1_est <= inicio_cuenta_est;
            reg2_est <= reg1_est;
        end if;
    end process;
    
    flanco_est <= '1' when reg1_est = '1' and reg2_est = '0' else '0';  -- Flanco detectado
    inicio_cuenta_est <= '1' when col_personaje = inicio_columna and (fila_personaje = inicio_fila_1 or fila_personaje = inicio_fila_2 or fila_personaje = inicio_fila_3 or fila_personaje = inicio_fila_4 or fila_personaje = inicio_fila_5) else
                    '0' when col_personaje = fin_columna and (fila_personaje = inicio_fila_1 or fila_personaje = inicio_fila_2 or fila_personaje = inicio_fila_3 or fila_personaje = inicio_fila_4 or fila_personaje = inicio_fila_5);
    reinicio_est <= '1' when start_est = '0' or reset_est = '1' or (col_personaje = fin_columna and (fila_personaje = inicio_fila_1 or fila_personaje = inicio_fila_2 or fila_personaje = inicio_fila_3 or fila_personaje = inicio_fila_4 or fila_personaje = inicio_fila_5)) else '0';
    
    -- Divisor de frecuencia para obtener pulsos cada 1 s (modificado para el test)
    UUT_0: contador 
        generic map ( num_bits => 21,                           -- Numero de bits necesarios para almacenar el valor de cuenta
                      valor_fin_cuenta => 1250000)              -- Valor fin de cuenta del contador
        port map (  reset => reinicio_est,                         -- Reset del sistema BTN0
                    clock => clock_est,                         -- Reloj del sistema                              
                    enable =>  start_est,                       -- Habilitacion contador con SW3
                    ascendente_descendente => ascendente_descendente_est,   -- Interruptor para cuenta ascendente o descendente
                    precarga => precarga_div,                   -- Valor conteo inicial
                    fin_cuenta => S1_est,                       -- Se�al fin de cuenta
                    valor_cuenta_actual => open);               -- Sin usar
                   
    -- Contador de 10 segundos: 10 pulsos con habilitacion cada segundo: conteo los segundos
    UUT_1: contador 
        generic map ( num_bits => 4,                            -- Numero de bits necesarios para almacenar el valor de cuenta
                      valor_fin_cuenta => 10)                   -- Valor fin de cuenta del contador
        port map ( reset => reinicio_est,                          -- Reset del sistema BTN0
                   clock => clock_est,                          -- Reloj del sistema  
                   enable => S1_est,                            -- Habilitacion cada 1 s
                   ascendente_descendente => ascendente_descendente_est,    -- Interruptor para cuenta ascendente o descendente
                   precarga => precarga_sec,                    -- Valor conteo inicial
                   fin_cuenta => S10_est,                       -- Señal fin de cuenta
                   valor_cuenta_actual => valor_sec_actual_est);-- Valor actual de cuenta
    
    -- Contador de decenas de segundo: 6 pulsos con habilitacion cada 10 segundos: conteo de decenas de segundo
    enable_decenas_est <= '1' when S1_est = '1' and S10_est = '1' else '0';
    
    UUT_2: contador 
        generic map ( num_bits => 4,                            -- Numero de bits necesarios para almacenar el valor de cuenta
                      valor_fin_cuenta => 6)                    -- Valor fin de cuenta del contador
        port map ( reset => reinicio_est,                          -- Reset del sistema BTN0
                   clock => clock_est,                          -- Reloj del sistema  
                   enable => enable_decenas_est,                -- Habilitacion cada 10 segundos
                   ascendente_descendente => ascendente_descendente_est,    -- Interruptor para cuenta ascendente o descendente
                   precarga => precarga_sec,                    -- Valor conteo inicial
                   fin_cuenta => S60_est,                       -- Señal fin de cuenta 
                   valor_cuenta_actual => valor_dec_actual_est);-- Valor actual de cuenta 
                   
    -- Contador de minutos: 10 pulsos con habilitacion cada 59 segundos
    enable_minutos_est <= '1' when S1_est = '1' and S10_est = '1' and S60_est = '1' else '0';                 
    UUT_3: contador 
        generic map ( num_bits => 4,                            -- Numero de bits necesarios para almacenar el valor de cuenta
                      valor_fin_cuenta => 10)                   -- Valor fin de cuenta del contador
        port map ( reset => reinicio_est,                          -- Reset del sistema BTN0
                   clock => clock_est,                          -- Reloj del sistema  
                   enable => enable_minutos_est,                -- Habilitacion cada 10 segundos
                   ascendente_descendente => ascendente_descendente_est,    -- Interruptor para cuenta ascendente o descendente
                   precarga => precarga_sec,                    -- Valor conteo inicial
                   fin_cuenta => Smin_est,                      -- Señal fin de cuenta 
                   valor_cuenta_actual => valor_min_actual_est);-- Valor actual de cuenta                  

    UUT_4: contador 
        generic map ( num_bits => 4,                            -- Numero de bits necesarios para almacenar el valor de cuenta
                      valor_fin_cuenta => 10)                   -- Valor fin de cuenta del contador
        port map ( reset => reinicio_est,                          -- Reset del sistema BTN0
                   clock => clock_est,                          -- Reloj del sistema  
                   enable => flanco_est,                -- Habilitacion cada 10 segundos
                   ascendente_descendente => ascendente_descendente_est,    -- Interruptor para cuenta ascendente o descendente
                   precarga => precarga_sec,                    -- Valor conteo inicial
                   fin_cuenta => open,                      -- Señal fin de cuenta 
                   valor_cuenta_actual => vuelta_actual);-- Valor actual de cuenta  
    clock_est <= not clock_est after PERIOD/2;
    reset_est <= '0';
    start_est <= '1';
    buttons_snes(6) <= '1', '0' after 50 ns, '1' after 100 ns;
    col_personaje <= "001101", "001101" after 100 ns, "001110" after 150 ns, "001111" after 200 ns, "010000" after 300 ns;
    fila_personaje <= "011010", "011011" after 300 ns, "011010" after 400 ns;
end Behavioral;
