----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.11.2023 16:57:14
-- Design Name: 
-- Module Name: main - Behavioral
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

entity main is
    Port( reset : IN STD_LOGIC;                                    -- BTN0 reset del sistema
          clock : IN STD_LOGIC;                                    -- sysclk reloj del sistema 125 MHz
          BTNU : IN STD_LOGIC;                                     -- BTNU cambio de velocidad
          salida_7seg : out STD_LOGIC_VECTOR (7 downto 0));        -- JC[0,3] y JD[0,3] salida 7seg
end main;

architecture Behavioral of main is
    component contador is
        Generic ( num_bits : integer := 2;                      -- Numero de bits necesarios para almacenar el valor de cuenta. Configurable al instanciar
                  valor_fin_cuenta : integer := 2);             -- Valor fin de cuenta del contador. Configurable al instanciar
        Port (    reset : IN STD_LOGIC;                         -- Reset del sistema BTN0
                  clock : IN STD_LOGIC;                         -- Entrada reloj del sistema
                  enable : IN STD_LOGIC;                        -- Habilitacion contador
                  ascendente_descendente : IN STD_LOGIC;        -- Interruptor para cuenta ascendente o descendente
                  fin_cuenta : OUT STD_LOGIC;                   -- Señal fin de cuenta
                  valor_cuenta_actual : out STD_LOGIC_VECTOR (Num_bits - 1 downto 0));  -- Valor actual de cuenta
    end component;
    
    component conv_7seg is
        Port (  entrada_7seg : in STD_LOGIC_VECTOR (3 downto 0); -- Entrada conversor 7seg
                salida_7seg : out STD_LOGIC_VECTOR (7 downto 0));-- Salida conversor 7seg
    end component;
    
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
    
    component fsm_velocidades is    
        Port (  reset : IN STD_LOGIC;                                            -- Reset del sistema BTN0                                 
                clock : IN STD_LOGIC;                                            -- Reloj del sistema
                BTNU : IN STD_LOGIC;                                             -- BTNU cambio de velocidad
                S500milis : IN STD_LOGIC;
                S20milis : IN STD_LOGIC;
                S10milis : IN STD_LOGIC;
                velocidad_fsm : OUT STD_LOGIC);
    end component;
    
    signal enable_sig : STD_LOGIC := '1';                       -- Habilitacion permanente para el contador de 500 ms
    signal ascendente_permanente : STD_LOGIC := '0';      -- Habilitacion permanente para el contador de 500 ms
    signal enable_fila_fsm  : STD_LOGIC := '0';                 -- Enable contador filas fsm
    signal enable_columna_fsm  : STD_LOGIC := '0';              -- Enable contador columnas fsm
    signal ascendente_descendente_fila : STD_LOGIC;             -- Ascendente/descendente filas
    signal ascendente_descendente_columna : STD_LOGIC;          -- Ascendente/descendente columnas
    signal S500milis : STD_LOGIC;                               -- Salida timer 500 ms
    signal fin_cuenta_filas : STD_LOGIC;                        -- Salida contador filas
    signal fin_cuenta_columnas : STD_LOGIC;                     -- Salida contador columnas
    signal enable_filas : STD_LOGIC;                        -- Puerta and para habilitar contador de filas
    signal enable_columnas : STD_LOGIC;                     -- Puerta and para habilitar contador de columnas
    signal valor_actual_filas : STD_LOGIC_VECTOR (1 downto 0);  -- Posicion de fila actual
    signal valor_actual_columnas : STD_LOGIC_VECTOR (1 downto 0); -- Posicion de columna actual
    signal mostrar : STD_LOGIC_VECTOR (3 downto 0); -- Posicion de columna actual
    
    signal num_bits_vector : STD_LOGIC_VECTOR (5 - 1 downto 0);
    signal valor_fin_cuenta_vector : STD_LOGIC_VECTOR (27 - 1 downto 0);
    
    signal S20milis : STD_LOGIC;                               -- Salida timer 200 ms
    signal S10milis : STD_LOGIC;                               -- Salida timer 100 ms
    signal velocidad_fsm : STD_LOGIC;
        
begin

    ------------------ PARTE BASICA -------------------------- 
    -- Divisor de frecuencia para obtener pulsos cada 500 ms: cambio de estado del sistema
    u0: contador 
        generic map ( num_bits => 26,                  -- Numero de bits necesarios para alcanzar el valor de cuenta
                      valor_fin_cuenta => 62500000)  -- Valor de cuenta deseado: 62500000 (500 ms)
        port map (  reset => reset,                                 -- Reset del sistema BTN0
                    clock => clock,                                 -- Reloj del sistema 
                    enable => enable_sig,                           -- Timer 500 ms siempre habilitado
                    ascendente_descendente => ascendente_permanente,   -- El timer de 500 ms siempre es ascendente
                    fin_cuenta => S500milis,                        -- Señal fin de cuenta
                    valor_cuenta_actual => open);                   -- Sin usar
    
    -- Conversor 7 segmentos PmodSSD catodo comun
    u1: conv_7seg port map ( entrada_7seg => mostrar,               -- Entrada conversor 7seg 
                             salida_7seg => salida_7seg);           -- Salida conversor 7seg   
                                          
    -- Contador de filas
    u2: contador 
        generic map ( num_bits => 2,                                -- Numero de bits necesarios para almacenar el valor de cuenta
                      valor_fin_cuenta => 4)                        -- Valor fin de cuenta: 4 filas
        port map (  reset => reset,                                 -- Reset del sistema BTN0
                    clock => clock,                                 -- Reloj del sistema 
                    enable => enable_filas,                         -- Habilitacion cuenta filas con fin cuenta 500 ms
                    ascendente_descendente => ascendente_descendente_fila,   -- Seleccion ascendente o descendente
                    fin_cuenta => fin_cuenta_filas,                 -- Señal fin de cuenta
                    valor_cuenta_actual => valor_actual_filas);     -- Valor actual filas para 7seg
                       
    -- Contador de columnas
    u3: contador 
        generic map ( num_bits => 2,                                -- Numero de bits necesarios para almacenar el valor de cuenta
                      valor_fin_cuenta => 2)                        -- Valor fin de cuenta: 2 columnas
        port map (  reset => reset,                                 -- Reset del sistema BTN0
                    clock => clock,                                 -- Reloj del sistema 
                    enable => enable_columnas,                      -- Habilitacion cuenta filas con fin cuenta 500 ms
                    ascendente_descendente => ascendente_descendente_columna,-- Seleccion ascendente o descendente
                    fin_cuenta => fin_cuenta_columnas,              -- Señal fin de cuenta
                    valor_cuenta_actual => valor_actual_columnas);  -- Valor actual columnas para 7seg
                   
    -- Maquina de estados
    u4: fsm_contadores
        port map (  reset => reset,                                 -- Reset del sistema
                    clock => clock,                                 -- Reloj del sistema
                    enable => velocidad_fsm,                        -- Fin cuenta timer 500 ms
                    fila_final => fin_cuenta_filas,                 -- Alcanzado fin max/min filas    
                    columna_final => fin_cuenta_columnas,           -- Alcanzado fin max/min columnas   
                    ascendente_descendente_fila => ascendente_descendente_fila,-- Fila++ si = 0. Fila -- si = 1.
                    enable_fila => enable_fila_fsm,                 -- Enable para contador de filas
                    ascendente_descendente_columna => ascendente_descendente_columna, -- Columna++ si = 0. Columna -- si = 1.
                    enable_columna => enable_columna_fsm);          -- Enable para contador de columnas
    
                    
      enable_filas <= velocidad_fsm and enable_fila_fsm;
      enable_columnas <= velocidad_fsm and enable_columna_fsm;
      mostrar <= valor_actual_columnas & valor_actual_filas;
                          
    ------------------ PARTE AVANZADA --------------------------                 
    u5: fsm_velocidades    
        port map (  reset => reset,                                 -- Reset del sistema BTN0                                 
                    clock => clock,                                 -- Reloj del sistema
                    BTNU => BTNU,                                   -- BTNU cambio de velocidad
                    S500milis => S500milis,
                    S20milis => S20milis,
                    S10milis => S10milis,
                    velocidad_fsm => velocidad_fsm);

    -- Divisor de frecuencia para obtener pulsos cada 20 ms: cambio de estado del sistema
    u6: contador 
        generic map ( num_bits => 22,                  -- Numero de bits necesarios para alcanzar el valor de cuenta
                      valor_fin_cuenta => 2500000)  -- Valor de cuenta deseado: 62500000 (500 ms)
        port map (  reset => reset,                                 -- Reset del sistema BTN0
                    clock => clock,                                 -- Reloj del sistema 
                    enable => enable_sig,                           -- Timer 500 ms siempre habilitado
                    ascendente_descendente => ascendente_permanente,   -- El timer de 500 ms siempre es ascendente
                    fin_cuenta => S20milis,                        -- Señal fin de cuenta
                    valor_cuenta_actual => open);                   -- Sin usar
      
    -- Divisor de frecuencia para obtener pulsos cada 10 ms: cambio de estado del sistema
    u7: contador 
        generic map ( num_bits => 21,                  -- Numero de bits necesarios para alcanzar el valor de cuenta
                      valor_fin_cuenta => 1250000)  -- Valor de cuenta deseado: 62500000 (500 ms)
        port map (  reset => reset,                                 -- Reset del sistema BTN0
                    clock => clock,                                 -- Reloj del sistema 
                    enable => enable_sig,                           -- Timer 500 ms siempre habilitado
                    ascendente_descendente => ascendente_permanente,   -- El timer de 500 ms siempre es ascendente
                    fin_cuenta => S10milis,                        -- Señal fin de cuenta
                    valor_cuenta_actual => open);                   -- Sin usar
              
end Behavioral;
