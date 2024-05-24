----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.12.2023 12:31:23
-- Design Name: 
-- Module Name: velocidad_personaje - Behavioral
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
use WORK.RACETRACK_PKG.ALL;                                 -- incluye la pista

entity velocidad_personaje is
    Port (  reset : IN STD_LOGIC;                           -- Reset del sistema BTN0
            clock : IN STD_LOGIC;                           -- Entrada reloj del sistema
            col_personaje : IN STD_LOGIC_VECTOR (6 - 1 DOWNTO 0);   -- Columna actual personaje
            fila_personaje : IN STD_LOGIC_VECTOR (6 - 1 DOWNTO 0);  -- Fila actual personaje
            muestreo_pulsadores : OUT STD_LOGIC);           -- Fila actual personaje
end velocidad_personaje;

architecture Behavioral of velocidad_personaje is
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
    
    -- Señales intermedias muestreo pulsadores
    signal enable_sig : STD_LOGIC := '1';                       -- Habilitacion permanente
    signal asc_sig : STD_LOGIC := '0';                          -- Ascendente permanente
    signal S500milis : STD_LOGIC;                               -- Salida timer 500 ms
    signal S100milis : STD_LOGIC;                               -- Salida timer 500 ms
    signal precarga_100 : unsigned (24 - 1 downto 0) := (others => '0');
    signal precarga_500 : unsigned (26 - 1 downto 0) := (others => '0');
    -- Analisis personaje en pista
    signal jug_en_pista : STD_LOGIC;
    
begin
    -- Proceso para comprobar si el personaje dentro de pista para cambio de velocidades
    jug_en_pista <= pista(to_integer(unsigned(fila_personaje)))(to_integer(unsigned(col_personaje)));
    
    -- Divisor de frecuencia para obtener pulsos cada 100 ms: mover el personaje
    u1: contador 
        generic map ( num_bits => 24,                           -- Numero de bits necesarios para almacenar el valor de cuenta
                      valor_fin_cuenta => 12500000)             -- Valor fin de cuenta del contador
        port map ( reset => reset,                              -- Reset del sistema BTN0
                   clock => clock,                              -- Reloj del sistema 
                   enable => enable_sig,                        -- Habilitacion permanente
                   ascendente_descendente => asc_sig,           -- Interruptor para cuenta ascendente o descendente
                   precarga => precarga_100,
                   fin_cuenta => S100milis,                     -- Pulso fin de cuenta
                   valor_cuenta_actual => open);                -- Sin usar
                   
    -- Divisor de frecuencia para obtener pulsos cada 500 ms: mover el personaje fuera de la pista
    u2: contador 
        generic map ( num_bits => 26,                           -- Numero de bits necesarios para almacenar el valor de cuenta
                      valor_fin_cuenta => 62500000)             -- Valor fin de cuenta del contador
        port map ( reset => reset,                              -- Reset del sistema BTN0
                   clock => clock,                              -- Reloj del sistema 
                   enable => enable_sig,                        -- Habilitacion permanente
                   ascendente_descendente => asc_sig,           -- Interruptor para cuenta ascendente o descendente
                   precarga => precarga_500,
                   fin_cuenta => S500milis,                     -- Pulso fin de cuenta
                   valor_cuenta_actual => open);                -- Sin usar
    
    muestreo_pulsadores <=  S500milis when jug_en_pista = '0' else
                            S100milis when jug_en_pista = '1';
    
end Behavioral;
