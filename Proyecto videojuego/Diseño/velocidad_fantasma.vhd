----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.12.2023 16:53:35
-- Design Name: 
-- Module Name: velocidad_fantasma - Behavioral
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

entity velocidad_fantasma is
    Port (  reset : IN STD_LOGIC;                           -- Reset del sistema BTN0
            clock : IN STD_LOGIC;                           -- Entrada reloj del sistema
            dificultad : IN STD_LOGIC_VECTOR (1 downto 0);   -- Interruptores para la dificultad
            velocidad_automatico : OUT STD_LOGIC);           -- Fila actual personaje
end velocidad_fantasma;

architecture Behavioral of velocidad_fantasma is
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
    signal S1seg : STD_LOGIC;                                   -- Salida timer 1s
    signal S500milis : STD_LOGIC;                               -- Salida timer 500 ms
    signal S200milis : STD_LOGIC;                               -- Salida timer 200 ms
    signal S100milis : STD_LOGIC;                               -- Salida timer 100 ms
    signal precarga_100 : unsigned (24 - 1 downto 0) := (others => '0');
    signal precarga_200 : unsigned (25 - 1 downto 0) := (others => '0');
    signal precarga_500 : unsigned (26 - 1 downto 0) := (others => '0');
    signal precarga_1000 : unsigned (27 - 1 downto 0) := (others => '0');
begin

    -- Divisor de frecuencia para obtener pulsos cada 100 ms: mover el personaje
    u0: contador 
        generic map ( num_bits => 24,                           -- Numero de bits necesarios para almacenar el valor de cuenta
                      valor_fin_cuenta => 12500000)             -- Valor fin de cuenta del contador
        port map ( reset => reset,                              -- Reset del sistema BTN0
                   clock => clock,                              -- Reloj del sistema 
                   enable => enable_sig,                        -- Habilitacion permanente
                   ascendente_descendente => asc_sig,           -- Interruptor para cuenta ascendente o descendente
                   precarga => precarga_100,
                   fin_cuenta => S100milis,                     -- Pulso fin de cuenta
                   valor_cuenta_actual => open);                -- Sin usar
                   
    -- Divisor de frecuencia para obtener pulsos cada 200 ms: mover el personaje
    u1: contador 
        generic map ( num_bits => 25,                           -- Numero de bits necesarios para almacenar el valor de cuenta
                      valor_fin_cuenta => 25000000)             -- Valor fin de cuenta del contador
        port map ( reset => reset,                              -- Reset del sistema BTN0
                   clock => clock,                              -- Reloj del sistema 
                   enable => enable_sig,                        -- Habilitacion permanente
                   ascendente_descendente => asc_sig,           -- Interruptor para cuenta ascendente o descendente
                   precarga => precarga_200,
                   fin_cuenta => S200milis,                     -- Pulso fin de cuenta
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
  
  
    -- Divisor de frecuencia para obtener pulsos cada 1s: mover el personaje fuera de la pista
    u3: contador 
        generic map ( num_bits => 27,                           -- Numero de bits necesarios para almacenar el valor de cuenta
                      valor_fin_cuenta => 125000000)             -- Valor fin de cuenta del contador
        port map ( reset => reset,                              -- Reset del sistema BTN0
                   clock => clock,                              -- Reloj del sistema 
                   enable => enable_sig,                        -- Habilitacion permanente
                   ascendente_descendente => asc_sig,           -- Interruptor para cuenta ascendente o descendente
                   precarga => precarga_1000,
                   fin_cuenta => S1seg,                     -- Pulso fin de cuenta
                   valor_cuenta_actual => open);                -- Sin usar
    
    velocidad_automatico <=  S1seg when dificultad = "00" else
                             S500milis when dificultad = "01" else
                             S200milis when dificultad = "10" else
                             S100milis when dificultad = "11";
end Behavioral;
