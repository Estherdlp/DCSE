----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.11.2023 23:39:55
-- Design Name: 
-- Module Name: fsm_fantasma - Behavioral
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

entity fsm_fantasma is
    Port (  reset : IN STD_LOGIC;                                       -- Reset del sistema BTN0
            clock : IN STD_LOGIC;                                       -- Entrada reloj del sistema
            dificultad : IN STD_LOGIC_VECTOR (1 downto 0);   -- Interruptores para la dificultad
            filas_fantasma : OUT STD_LOGIC_VECTOR (6 - 1 DOWNTO 0);     -- Fila actual fantasma
            columnas_fantasma : OUT STD_LOGIC_VECTOR (6 - 1 DOWNTO 0)); -- Columna actual fantasma
end fsm_fantasma;

architecture Behavioral of fsm_fantasma is
    component velocidad_fantasma is
        Port (  reset : IN STD_LOGIC;                           -- Reset del sistema BTN0
                clock : IN STD_LOGIC;                           -- Entrada reloj del sistema
                dificultad : IN STD_LOGIC_VECTOR (1 downto 0);   -- Interruptores para la dificultad
                velocidad_automatico : OUT STD_LOGIC);           -- Fila actual personaje
    end component;
    
    component movimientos_fantasma is
        Port (  reset : IN STD_LOGIC;                                   -- Reset del sistema
                clock : IN STD_LOGIC;                                   -- Reloj del sistema
                fin_cuenta : IN STD_LOGIC;                              -- Fin cuenta timer 500 ms
                col_fantasma : IN STD_LOGIC_VECTOR (6 - 1 DOWNTO 0);   -- Columna actual personaje
                fila_fantasma : IN STD_LOGIC_VECTOR (6 - 1 DOWNTO 0);  -- Fila actual personaje
                ascendente_descendente_fila : OUT STD_LOGIC;            -- Fila++ si = 0. Fila -- si = 1.
                enable_fila : OUT STD_LOGIC;                            -- Enable para contador de filas
                ascendente_descendente_columna : OUT STD_LOGIC;         -- Columna++ si = 0. Columna -- si = 1.
                enable_columna : OUT STD_LOGIC);                        -- Enable para contador de columnas   
    end component;    
    
    component contador is
        Generic ( num_bits : integer := 27;                     -- Numero de bits necesarios para almacenar el valor de cuenta
                  valor_fin_cuenta : integer := 120000000);     -- Valor fin de cuenta del contador
        Port (    reset : IN STD_LOGIC;                         -- Reset del sistema BTN0
                  clock : IN STD_LOGIC;                         -- Entrada reloj del sistema
                  enable : IN STD_LOGIC;                        -- Habilitacion contador
                  ascendente_descendente : IN STD_LOGIC;        -- Interruptor para cuenta ascendente o descendente
                  precarga : IN UNSIGNED (num_bits - 1 downto 0) := (others => '0');  -- Valor inicial de cuenta
                  fin_cuenta : OUT STD_LOGIC;                   -- SeÃ±al fin de cuenta
                  valor_cuenta_actual : out STD_LOGIC_VECTOR (num_bits - 1 downto 0));  -- Valor actual de cuenta
    end component;
    
    -- Señales intermedias tiempo movimiento fantasma
    signal enable_sig : STD_LOGIC := '1';                       -- Habilitacion permanente
    signal asc_sig : STD_LOGIC := '0';                          -- Ascendente permanente
    signal velocidad_automatico : STD_LOGIC;                    -- Velocidad movimiento fantasma
    
    -- Señales intermedias fantasma
    signal fin_cuenta_filas_fantasma : STD_LOGIC;               -- Bordes arriba/abajo
    signal fin_cuenta_columnas_fantasma : STD_LOGIC;            -- Bordes izquierdo/derecho
    signal enable_fila_fantasma  : STD_LOGIC := '0';            -- Enable contador filas fsm
    signal enable_columna_fantasma  : STD_LOGIC := '0';         -- Enable contador columnas fsm
    signal ad_fila_fantasma : STD_LOGIC;                        -- Ascendente/descendente filas
    signal ad_columna_fantasma : STD_LOGIC;                     -- Ascendente/descendente columnas
    signal actual_filas_fantasma : STD_LOGIC_VECTOR (6 - 1 DOWNTO 0);      -- Posicion de fila actual
    signal actual_columnas_fantasma : STD_LOGIC_VECTOR (6 - 1 DOWNTO 0);   -- Posicion de columna actual
    signal precarga_columnas : UNSIGNED (6 - 1 downto 0) := "001101";   -- Columna inicial 13
    signal precarga_filas : UNSIGNED (6 - 1 downto 0) := "011011";      -- Fila inicial 27
    
    
begin
    -- Gestion velocidad del personaje
    u0: velocidad_fantasma
        Port map (  reset => reset,                                 -- Reset del sistema BTN0
                    clock => clock,                                 -- Entrada reloj del sistema
                    dificultad => dificultad,
                    velocidad_automatico => velocidad_automatico);  -- Fila actual personaje
            
    -- Gestion movimiento del fantasma
    u1: movimientos_fantasma
        Port map (  reset => reset,                                 -- Reset del sistema
                    clock => clock,                                 -- Reloj del sistema
                    fin_cuenta => velocidad_automatico,             -- Fin cuenta timer 100 ms
                    col_fantasma => actual_columnas_fantasma,       -- Valor columna actual
                    fila_fantasma => actual_filas_fantasma,         -- Valor fila actual
                    ascendente_descendente_fila => ad_fila_fantasma,-- Fila++ si = 0. Fila -- si = 1.
                    enable_fila => enable_fila_fantasma,            -- Enable para contador de filas
                    ascendente_descendente_columna => ad_columna_fantasma, -- Columna++ si = 0. Columna -- si = 1.
                    enable_columna => enable_columna_fantasma);     -- Enable para contador de columnas                  
                   
    -- Contador de columnas movimiento del fantasma
    u2: contador 
        Generic map ( num_bits => 6,                                    -- Numero de bits necesarios para almacenar el valor de cuenta
                      valor_fin_cuenta => 32)                           -- Valor fin de cuenta del contador
        Port map ( reset => reset,                                      -- Reset del sistema BTN0
                   clock => clock,                                      -- Reloj del sistema                              
                   enable =>  enable_columna_fantasma,                  -- Habilitacion contador
                   ascendente_descendente => ad_columna_fantasma,       -- Cuenta ascendente o descendente
                   precarga => precarga_columnas,                       -- Posicion inicial personaje
                   fin_cuenta => fin_cuenta_columnas_fantasma,          -- Señal fin de cuenta
                   valor_cuenta_actual => actual_columnas_fantasma);    -- Valor actual cuenta
    
    -- Contador de filas movimiento del fantasma
    u3: contador
        Generic map ( num_bits => 6,                                    -- Numero de bits necesarios para almacenar el valor de cuenta
                      valor_fin_cuenta => 30)                           -- Valor fin de cuenta del contador
        Port map ( reset => reset,                                      -- Reset del sistema BTN0
                   clock => clock,                                      -- Reloj del sistema                              
                   enable =>  enable_fila_fantasma,                     -- Habilitacion contador
                   ascendente_descendente => ad_fila_fantasma,          -- Cuenta ascendente o descendente
                   precarga => precarga_filas,                          -- Posicion inicial personaje
                   fin_cuenta => fin_cuenta_filas_fantasma,             -- Señal fin de cuenta
                   valor_cuenta_actual => actual_filas_fantasma);       -- Valor actual cuenta
                   
                   
    filas_fantasma <= actual_filas_fantasma;
    columnas_fantasma <= actual_columnas_fantasma; 

end Behavioral;
