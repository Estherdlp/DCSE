----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.11.2023 20:48:40
-- Design Name: 
-- Module Name: movimientos_personaje_TB - Behavioral
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

entity movimientos_personaje_TB is
end movimientos_personaje_TB;

architecture Behavioral of movimientos_personaje_TB is
    component movimientos_personaje is
        Port (  reset : IN STD_LOGIC;                               -- Reset del sistema
                clock : IN STD_LOGIC;                               -- Reloj del sistema
                fin_cuenta : IN STD_LOGIC;                          -- Fin cuenta timer 100-500 ms
                fila_final : IN STD_LOGIC;                          -- Alcanzado fin max/min filas    
                columna_final : IN STD_LOGIC;                       -- Alcanzado fin max/min columnas
                buttons_snes : IN STD_LOGIC_VECTOR (12 DOWNTO 0);   -- Vector estado botones mando  
                ascendente_descendente_fila : OUT STD_LOGIC;        -- Fila++ si = 0. Fila -- si = 1
                enable_fila : OUT STD_LOGIC;                        -- Enable para contador de filas
                ascendente_descendente_columna : OUT STD_LOGIC;     -- Columna++ si = 0. Columna -- si = 1
                enable_columna : OUT STD_LOGIC);                    -- Enable para contador de columnas                    
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
    -- Estimulos divisor de frecuencia
    signal clock_est : STD_LOGIC := '0';
    signal reset_est : STD_LOGIC := '0';
    signal enable_est : STD_LOGIC := '1';
    signal fin_cuenta_est : STD_LOGIC := '0';
    signal ascendente_descendente_est : STD_LOGIC := '0';
    signal valor_cuenta_actual_est : STD_LOGIC_VECTOR (14 - 1 downto 0) := (others => '0');
    -- Estimulos maquina de estados
    signal fila_final_est : STD_LOGIC := '0'; 
    signal columna_final_est : STD_LOGIC := '0';
    signal ascendente_descendente_fila_est : STD_LOGIC;
    signal enable_fila_est : STD_LOGIC := '0';
    signal ascendente_descendente_columna_est : STD_LOGIC;
    signal enable_columna_est : STD_LOGIC := '0';
    signal buttons_snes : STD_LOGIC_VECTOR (12 DOWNTO 0) := (others => '1');
    -- Estimulos contador posicion personaje
    signal actual_columnas_personaje_est : STD_LOGIC_VECTOR (6 - 1 DOWNTO 0);
    signal actual_filas_personaje_est : STD_LOGIC_VECTOR (6 - 1 DOWNTO 0);
    signal precarga_columnas : UNSIGNED (6 - 1 downto 0) := "001101";   -- Columna inicial 13
    signal precarga_filas : UNSIGNED (6 - 1 downto 0) := "011001";      -- Fila inicial 25
    
    constant PERIOD : time := 8ns;
    
begin
    -- Divisor de frecuencia
    UUT_1: contador
        generic map (num_bits => 14, valor_fin_cuenta => 12500)
        port map (reset => reset_est,
                  clock => clock_est,
                  enable => enable_est,
                  ascendente_descendente => ascendente_descendente_est,
                  precarga => (others => '0'),
                  fin_cuenta => fin_cuenta_est,
                  valor_cuenta_actual => valor_cuenta_actual_est);
    
    -- Maquina de estados personaje              
    UUT_2: movimientos_personaje
        Port map(   reset => reset_est,                                   -- Reset del sistema
                    clock => clock_est,                                   -- Reloj del sistema
                    fin_cuenta => fin_cuenta_est,                              -- Fin cuenta timer 500 ms
                    fila_final => fila_final_est,                              -- Alcanzado fin max/min filas    
                    columna_final => columna_final_est,                           -- Alcanzado fin max/min columnas
                    ascendente_descendente_fila => ascendente_descendente_fila_est,     -- Fila++ si = 0. Fila -- si = 1.
                    buttons_snes => buttons_snes,
                    enable_fila => enable_fila_est,                     -- Enable para contador de filas
                    ascendente_descendente_columna => ascendente_descendente_columna_est,  -- Columna++ si = 0. Columna -- si = 1.
                    enable_columna => enable_columna_est);                 -- Enable para contador de columnas                                 
    -- Contador de columnas del personaje                  
    UUT_3: contador
        generic map (num_bits => 6, valor_fin_cuenta => 32)
        port map (reset => reset_est,
                  clock => clock_est,
                  enable => enable_columna_est,
                  ascendente_descendente => ascendente_descendente_columna_est,
                  precarga => precarga_columnas,
                  fin_cuenta => columna_final_est,
                  valor_cuenta_actual => actual_columnas_personaje_est);
    -- Contador de filas del personaje
    UUT_4: contador
        generic map (num_bits => 6, valor_fin_cuenta => 30)
        port map (reset => reset_est,
                  clock => clock_est,
                  enable => enable_fila_est,
                  ascendente_descendente => ascendente_descendente_fila_est,
                  precarga => precarga_filas,
                  fin_cuenta => fila_final_est,
                  valor_cuenta_actual => actual_filas_personaje_est);
                  
                  
    clock_est <= not clock_est after PERIOD/2;              
    reset_est <= '1', '0' after 100 ns;
    buttons_snes(4) <= '1', '0' after 200 ms, '1' after 300 ms;
    buttons_snes(5) <= '1', '0' after 400 ms, '1' after 450 ms;
    buttons_snes(6) <= '1', '0' after 250 ms, '1' after 350 ms;
    buttons_snes(7)  <= '1', '0' after 100 ms, '1' after 250 ms;
    
end Behavioral;
