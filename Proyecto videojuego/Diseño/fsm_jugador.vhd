----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.12.2023 18:37:32
-- Design Name: 
-- Module Name: fsm_jugador - Behavioral
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

entity fsm_jugador is
    Port (  reset : IN STD_LOGIC;                           -- Reset del sistema BTN0
            clock : IN STD_LOGIC;                           -- Entrada reloj del sistema
            buttons_snes : IN STD_LOGIC_VECTOR (12 DOWNTO 0);   -- Vector estado botones mando 
            filas_personaje : OUT STD_LOGIC_VECTOR (6 - 1 DOWNTO 0);    -- Fila actual personaje
            columnas_personaje : OUT STD_LOGIC_VECTOR (6 - 1 DOWNTO 0));-- Columna actual personaje
end fsm_jugador;

architecture Behavioral of fsm_jugador is
    component movimientos_personaje is
        Port (  reset : IN STD_LOGIC;                           -- Reset del sistema
                clock : IN STD_LOGIC;                           -- Reloj del sistema
                fin_cuenta : IN STD_LOGIC;                      -- Fin cuenta timer 500 ms
                fila_final : IN STD_LOGIC;                      -- Alcanzado fin max/min filas    
                columna_final : IN STD_LOGIC;                   -- Alcanzado fin max/min columnas
                buttons_snes : IN STD_LOGIC_VECTOR (12 DOWNTO 0);   -- Vector estado botones mando
                ascendente_descendente_fila : OUT STD_LOGIC;    -- Fila++ si = 0. Fila -- si = 1.
                enable_fila : OUT STD_LOGIC;                    -- Enable para contador de filas
                ascendente_descendente_columna : OUT STD_LOGIC; -- Columna++ si = 0. Columna -- si = 1.
                enable_columna : OUT STD_LOGIC);                -- Enable para contador de columnas                         
    end component;
    
    component contador is
        Generic ( num_bits : integer := 27;                     -- Numero de bits necesarios para almacenar el valor de cuenta
                  valor_fin_cuenta : integer := 120000000);     -- Valor fin de cuenta del contador
        Port (    reset : IN STD_LOGIC;                         -- Reset del sistema BTN0
                  clock : IN STD_LOGIC;                         -- Entrada reloj del sistema
                  enable : IN STD_LOGIC;                        -- Habilitacion contador
                  ascendente_descendente : IN STD_LOGIC;        -- Interruptor para cuenta ascendente o descendente
                  precarga : IN UNSIGNED (num_bits - 1 downto 0) := (others => '0');  -- Valor inicial de cuenta
                  fin_cuenta : OUT STD_LOGIC;                   -- Señal fin de cuenta
                  valor_cuenta_actual : out STD_LOGIC_VECTOR (num_bits - 1 downto 0));  -- Valor actual de cuenta
    end component;
    
    component velocidad_personaje is
        Port (  reset : IN STD_LOGIC;                           -- Reset del sistema BTN0
                clock : IN STD_LOGIC;                           -- Entrada reloj del sistema
                col_personaje : IN STD_LOGIC_VECTOR (6 - 1 DOWNTO 0);   -- Columna actual personaje
                fila_personaje : IN STD_LOGIC_VECTOR (6 - 1 DOWNTO 0);  -- Fila actual personaje
                muestreo_pulsadores : OUT STD_LOGIC);           -- Fila actual personaje
    end component;

    
    -- Señales intermedias velocidad personaje
    signal enable_sig : STD_LOGIC := '1';                       -- Habilitacion permanente
    signal asc_sig : STD_LOGIC := '0';                          -- Ascendente permanente
    signal muestreo_pulsadores : STD_LOGIC;                     -- Fin cuenta muestreo 100/500 ms
    -- Señales intermedias personaje
    signal fin_cuenta_filas_personaje : STD_LOGIC;              -- Bordes arriba/abajo
    signal fin_cuenta_columnas_personaje : STD_LOGIC;           -- Bordes izquierdo/derecho
    signal enable_fila_personaje  : STD_LOGIC := '0';           -- Enable contador filas fsm
    signal enable_columna_personaje  : STD_LOGIC := '0';        -- Enable contador columnas fsm
    signal ad_fila_personaje : STD_LOGIC;                       -- Ascendente/descendente filas
    signal ad_columna_personaje : STD_LOGIC;                    -- Ascendente/descendente columnas
    signal actual_filas_personaje : STD_LOGIC_VECTOR (6 - 1 DOWNTO 0);      -- Posicion de fila actual
    signal actual_columnas_personaje : STD_LOGIC_VECTOR (6 - 1 DOWNTO 0);   -- Posicion de columna actual
    signal precarga_columnas : UNSIGNED (6 - 1 downto 0) := "001101";   -- Columna inicial 13
    signal precarga_filas : UNSIGNED (6 - 1 downto 0) := "011001";      -- Fila inicial 25
       
begin

    -- Gestion velocidad del personaje
    u0: velocidad_personaje
        Port map (  reset => reset,                                 -- Reset del sistema BTN0
                    clock => clock,                                 -- Entrada reloj del sistema
                    col_personaje => actual_columnas_personaje,     -- Columna actual personaje
                    fila_personaje => actual_filas_personaje,       -- Fila actual personaje
                    muestreo_pulsadores => muestreo_pulsadores);    -- Fila actual personaje
                    
    -- Gestion movimiento del personaje
    u1: movimientos_personaje
        Port map (  reset => reset,                                 -- Reset del sistema
                    clock => clock,                                 -- Reloj del sistema
                    fin_cuenta => muestreo_pulsadores,              -- Fin cuenta timer 100 ms
                    fila_final => fin_cuenta_filas_personaje,       -- Alcanzado fin max/min filas    
                    columna_final => fin_cuenta_columnas_personaje, -- Alcanzado fin max/min columnas 
                    buttons_snes => buttons_snes,                   -- Vector estado botones mando   
                    ascendente_descendente_fila => ad_fila_personaje,-- Fila++ si = 0. Fila -- si = 1.
                    enable_fila => enable_fila_personaje,           -- Enable para contador de filas
                    ascendente_descendente_columna => ad_columna_personaje, -- Columna++ si = 0. Columna -- si = 1.
                    enable_columna => enable_columna_personaje);    -- Enable para contador de columnas
     
    -- Contador de columnas movimiento del personaje
    u2: contador 
        Generic map ( num_bits => 6,                                -- Numero de bits necesarios para almacenar el valor de cuenta
                      valor_fin_cuenta => 32)                       -- Valor fin de cuenta del contador
        Port map ( reset => reset,                                  -- Reset del sistema BTN0
                   clock => clock,                                  -- Reloj del sistema                              
                   enable =>  enable_columna_personaje,             -- Habilitacion contador
                   ascendente_descendente => ad_columna_personaje,  -- Cuenta ascendente o descendente
                   precarga => precarga_columnas,
                   fin_cuenta => fin_cuenta_columnas_personaje,     -- Señal fin de cuenta
                   valor_cuenta_actual => actual_columnas_personaje);   -- Valor actual cuenta
    
    -- Contador de filas movimiento del personaje
    u3: contador
        Generic map ( num_bits => 6,                                -- Numero de bits necesarios para almacenar el valor de cuenta
                      valor_fin_cuenta => 30)                       -- Valor fin de cuenta del contador
        Port map ( reset => reset,                                  -- Reset del sistema BTN0
                   clock => clock,                                  -- Reloj del sistema                              
                   enable =>  enable_fila_personaje,                -- Habilitacion contador
                   ascendente_descendente => ad_fila_personaje,     -- Cuenta ascendente o descendente
                   precarga => precarga_filas,
                   fin_cuenta => fin_cuenta_filas_personaje,        -- Señal fin de cuenta
                   valor_cuenta_actual => actual_filas_personaje);  -- Valor actual cuenta
                            
    filas_personaje <= actual_filas_personaje;
    columnas_personaje <= actual_columnas_personaje; 

end Behavioral;