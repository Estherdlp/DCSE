----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.12.2023 12:26:37
-- Design Name: 
-- Module Name: cronometro_personaje - Behavioral
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

entity cronometro_personaje is
    Port (  reset : IN STD_LOGIC;                           -- Reset del sistema BTN0
            clock : IN STD_LOGIC;                           -- Entrada reloj del sistema
            start : IN STD_LOGIC;                           -- Start/stop cronometro
            columna : IN STD_LOGIC_VECTOR (10 - 1 downto 0);-- Numero actual de columna px
            fila : IN STD_LOGIC_VECTOR (10 - 1 downto 0);   -- Numero actual de fila px
            col_personaje : IN STD_LOGIC_VECTOR (6 - 1 DOWNTO 0);   -- Columna actual personaje
            fila_personaje : IN STD_LOGIC_VECTOR (6 - 1 DOWNTO 0);  -- Fila actual personaje
            pintar_crono_seg : OUT STD_LOGIC;               -- Salida segundos
            pintar_crono_dec : OUT STD_LOGIC;               -- Salida decenas segundo
            pintar_crono_min : OUT STD_LOGIC;               -- Salida minutos
            pintar_crono_puntos : OUT STD_LOGIC;            -- Salida :
            pintar_crono_L : OUT STD_LOGIC;                 -- Salida L
            pintar_crono_A : OUT STD_LOGIC;                 -- Salida A
            pintar_crono_P : OUT STD_LOGIC;                 -- Salida P
            pintar_crono_vuelta : OUT STD_LOGIC);           -- Salida num vuelta
end cronometro_personaje;

architecture Behavioral of cronometro_personaje is 
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

    component display_crono is
        Generic ( num_bits : integer := 27);                     -- Numero de bits necesarios para almacenar el valor de cuenta
        Port (  reset : IN STD_LOGIC;                           -- Reset del sistema BTN0
                clock : IN STD_LOGIC;                           -- Entrada reloj del sistema
                columna : IN STD_LOGIC_VECTOR (10 - 1 downto 0);-- Numero actual de columna px
                fila : IN STD_LOGIC_VECTOR (10 - 1 downto 0);   -- Numero actual de fila px
                valor_cuenta_actual : IN STD_LOGIC_VECTOR (num_bits - 1 downto 0);
                pintar_crono_seg : OUT STD_LOGIC);              -- Salida minutos
    end component;
    
    component display_separador_crono is
        Port (  reset : IN STD_LOGIC;                           -- Reset del sistema BTN0
                clock : IN STD_LOGIC;                           -- Entrada reloj del sistema
                columna : IN STD_LOGIC_VECTOR (10 - 1 downto 0);-- Numero actual de columna px
                fila : IN STD_LOGIC_VECTOR (10 - 1 downto 0);   -- Numero actual de fila px
                cabecera : IN STD_LOGIC_VECTOR (5 - 1 downto 0); -- Cabecera ROM :
                pintar_crono : OUT STD_LOGIC);              -- Salida minutos   
    end component;
    
    -- Se�ales para los contadores de tiempo
    signal asc_sig : STD_LOGIC := '0';                          -- Ascendente permanente
    signal precarga_div : unsigned (27 - 1 downto 0) := (others => '0');    -- Precarga del divisor de frecuencia: 0
    signal precarga_sec : unsigned (4 - 1 downto 0) := (others => '0');     -- Precarga del resto de contadores: 0
    signal S1seg : STD_LOGIC;                                   -- Salida divisor de frecuencia 1 s
    signal S10seg : STD_LOGIC;                                  -- Salida timer segundos
    signal S60seg : STD_LOGIC;                                  -- Salida timer decenas de segundo
    signal Smin : STD_LOGIC;                                    -- Salida timer minutos
    signal segundos : STD_LOGIC_VECTOR (4 - 1 downto 0);        -- Valor actual segundos timer
    signal dec_segundos : STD_LOGIC_VECTOR (4 - 1 downto 0);    -- Valor actual decenas segundo timer
    signal minutos : STD_LOGIC_VECTOR (4 - 1 downto 0);         -- Valor actual minutos timer
    signal enable_decenas : STD_LOGIC;                          -- Enable contador de decenas de segundo
    signal enable_minutos : STD_LOGIC;                          -- Enable contador de minutos
    signal reinicio : STD_LOGIC := '0';                         -- Reinicio cronometro por llegar a meta o reset
    signal inicio_cuenta : STD_LOGIC := '0';                    -- Enable cronometro
    signal inicio_columna : STD_LOGIC_VECTOR (6 - 1 downto 0) := "001110";  -- Columna inicial - 14
    signal fin_columna : STD_LOGIC_VECTOR (6 - 1 downto 0) := "001101";     -- Columna reinicio por fin de vuelta - 13
    signal inicio_fila_1 : STD_LOGIC_VECTOR (6 - 1 downto 0) := "011011";   -- Fila meta - 27
    signal inicio_fila_2 : STD_LOGIC_VECTOR (6 - 1 downto 0) := "011010";   -- Fila meta - 26
    signal inicio_fila_3 : STD_LOGIC_VECTOR (6 - 1 downto 0) := "011001";   -- Fila meta - 25
    signal inicio_fila_4 : STD_LOGIC_VECTOR (6 - 1 downto 0) := "011000";   -- Fila meta - 24
    signal inicio_fila_5 : STD_LOGIC_VECTOR (6 - 1 downto 0) := "010111";   -- Fila meta - 23
    signal cabecera_puntos : STD_LOGIC_VECTOR (5 - 1 downto 0) := "10101"; -- Cabecera ROM :
    signal cabecera_L : STD_LOGIC_VECTOR (5 - 1 downto 0) := "01011"; -- Cabecera ROM L
    signal cabecera_A : STD_LOGIC_VECTOR (5 - 1 downto 0) := "01100"; -- Cabecera ROM A
    signal cabecera_P : STD_LOGIC_VECTOR (5 - 1 downto 0) := "01010"; -- Cabecera ROM P
    signal vuelta_actual_vector : STD_LOGIC_VECTOR (4 - 1 downto 0) := (others => '0');   -- Valor de vuelta actual
    signal reg1 : STD_LOGIC := '0';       -- Detector de flancos 1    
    signal reg2 : STD_LOGIC := '0';       -- Detector de flancos 2 
    signal flanco : STD_LOGIC := '0';     -- Flanco detectado     
    
begin
    p_flanco: process (clock, reset)
    begin
        if reset = '1' then
            reg1 <= '0';
            reg2 <= '0';
        elsif clock'event and clock = '1' then  -- Si pulso de reloj, transicion de estados y de detector de flancos     
            reg1 <= inicio_cuenta;
            reg2 <= reg1;
        end if;
    end process;
    
    flanco <= '1' when reg1 = '1' and reg2 = '0' else '0';  -- Flanco detectado
    inicio_cuenta <= '1' when col_personaje = inicio_columna and (fila_personaje = inicio_fila_1 or fila_personaje = inicio_fila_2 or fila_personaje = inicio_fila_3 or fila_personaje = inicio_fila_4 or fila_personaje = inicio_fila_5) else
                    '0' when col_personaje = fin_columna and (fila_personaje = inicio_fila_1 or fila_personaje = inicio_fila_2 or fila_personaje = inicio_fila_3 or fila_personaje = inicio_fila_4 or fila_personaje = inicio_fila_5);
    reinicio <= '1' when start = '0' or reset = '1' or (col_personaje = fin_columna and (fila_personaje = inicio_fila_1 or fila_personaje = inicio_fila_2 or fila_personaje = inicio_fila_3 or fila_personaje = inicio_fila_4 or fila_personaje = inicio_fila_5)) else '0';
     
    -- Divisor de frecuencia para obtener pulsos cada 1 s
    u0: contador 
        generic map ( num_bits => 27,                           -- Numero de bits necesarios para almacenar el valor de cuenta
                      valor_fin_cuenta => 125000000)            -- Valor fin de cuenta del contador
        port map (  reset => reinicio,                          -- Reset del sistema BTN0
                    clock => clock,                             -- Reloj del sistema                              
                    enable =>  inicio_cuenta,                   -- Habilitacion contador con SW3
                    ascendente_descendente => asc_sig,          -- Interruptor para cuenta ascendente o descendente
                    precarga => precarga_div,                   -- Valor conteo inicial
                    fin_cuenta => S1seg,                        -- Se�al fin de cuenta
                    valor_cuenta_actual => open);               -- Sin usar
          
    -- Contador de 10 segundos
    u1: contador 
        generic map ( num_bits => 4,                            -- Numero de bits necesarios para almacenar el valor de cuenta
                      valor_fin_cuenta => 10)                   -- Valor fin de cuenta del contador
        port map ( reset => reinicio,                              -- Reset del sistema BTN0
                   clock => clock,                              -- Reloj del sistema  
                   enable => S1seg,                             -- Habilitacion cada 1 s
                   ascendente_descendente => asc_sig,           -- Interruptor para cuenta ascendente o descendente
                   precarga => precarga_sec,                    -- Valor conteo inicial
                   fin_cuenta => S10seg,                        -- Señal fin de cuenta
                   valor_cuenta_actual => segundos);            -- Valor actual de cuenta
    
    -- Contador de decenas de segundo
    enable_decenas <= '1' when S1seg = '1' and S10seg = '1' else '0';
    u2: contador 
        generic map ( num_bits => 4,                            -- Numero de bits necesarios para almacenar el valor de cuenta
                      valor_fin_cuenta => 6)                    -- Valor fin de cuenta del contador
        port map ( reset => reinicio,                              -- Reset del sistema BTN0
                   clock => clock,                              -- Reloj del sistema  
                   enable => enable_decenas,                    -- Habilitacion cada 10 segundos
                   ascendente_descendente => asc_sig,           -- Interruptor para cuenta ascendente o descendente
                   precarga => precarga_sec,                    -- Valor conteo inicial
                   fin_cuenta => S60seg,                        -- Señal fin de cuenta 
                   valor_cuenta_actual => dec_segundos);        -- Valor actual de cuenta 
                   
    -- Contador de minutos: habilitacion cada 59 segundos
    enable_minutos <= '1' when S1seg = '1' and S10seg = '1' and S60seg = '1' else '0';   
    u3: contador 
        generic map ( num_bits => 4,                            -- Numero de bits necesarios para almacenar el valor de cuenta
                      valor_fin_cuenta => 10)                   -- Valor fin de cuenta del contador
        port map ( reset => reinicio,                           -- Reset del sistema BTN0
                   clock => clock,                              -- Reloj del sistema  
                   enable => enable_minutos,                    -- Habilitacion cada minuto
                   ascendente_descendente => asc_sig,           -- Interruptor para cuenta ascendente o descendente
                   precarga => precarga_sec,                    -- Valor conteo inicial
                   fin_cuenta => Smin,                          -- Señal fin de cuenta
                   valor_cuenta_actual => minutos);             -- Valor actual de cuenta 
             
    ----------------- DISPLAY SEGUNDOS -----------------                 
    u4: display_crono
        generic map ( num_bits => 4)                            -- Numero de bits necesarios para almacenar el valor de cuenta
        Port map (  reset => reinicio,                          -- Reset del sistema BTN0
                    clock => clock,                             -- Entrada reloj del sistema
                    columna => columna,                         -- Numero actual de columna px
                    fila => fila,                               -- Numero actual de fila px
                    valor_cuenta_actual => segundos,            -- Valor segundos actual
                    pintar_crono_seg => pintar_crono_seg);      -- Salida minutos
                    
    ----------------- DISPLAY DECENAS DE SEGUNDO -----------------                 
    u5: display_crono
        generic map ( num_bits => 4)                            -- Numero de bits necesarios para almacenar el valor de cuenta
        Port map (  reset => reinicio,                          -- Reset del sistema BTN0
                    clock => clock,                             -- Entrada reloj del sistema
                    columna => columna,                         -- Numero actual de columna px
                    fila => fila,                               -- Numero actual de fila px
                    valor_cuenta_actual => dec_segundos,        -- Valor segundos actual
                    pintar_crono_seg => pintar_crono_dec);      -- Salida minutos
                    
    ----------------- DISPLAY MINUTOS -----------------                 
    u6: display_crono
        generic map ( num_bits => 4)                            -- Numero de bits necesarios para almacenar el valor de cuenta
        Port map (  reset => reinicio,                          -- Reset del sistema BTN0
                    clock => clock,                             -- Entrada reloj del sistema
                    columna => columna,                         -- Numero actual de columna px
                    fila => fila,                               -- Numero actual de fila px
                    valor_cuenta_actual => minutos,             -- Valor segundos actual
                    pintar_crono_seg => pintar_crono_min);      -- Salida minutos
                    
    ----------------- DISPLAY : -----------------
     u7: display_separador_crono
        Port map (  reset => reinicio,                          -- Reset del sistema BTN0
                    clock => clock,                             -- Entrada reloj del sistema
                    columna => columna,                         -- Numero actual de columna px
                    fila => fila,                               -- Numero actual de fila px
                    cabecera => cabecera_puntos,
                    pintar_crono => pintar_crono_puntos);       -- Salida minutos        
                    
     ----------------- DISPLAY L -----------------
     u8: display_separador_crono
        Port map (  reset => reinicio,                          -- Reset del sistema BTN0
                    clock => clock,                             -- Entrada reloj del sistema
                    columna => columna,                         -- Numero actual de columna px
                    fila => fila,                               -- Numero actual de fila px
                    cabecera => cabecera_L,                     -- Cabecera ROM letra L
                    pintar_crono => pintar_crono_L);            -- Salida L 
                    
     ---------------- DISPLAY A -----------------
     u9: display_separador_crono
        Port map (  reset => reinicio,                          -- Reset del sistema BTN0
                    clock => clock,                             -- Entrada reloj del sistema
                    columna => columna,                         -- Numero actual de columna px
                    fila => fila,                               -- Numero actual de fila px
                    cabecera => cabecera_A,                     -- Cabecera ROM letra A
                    pintar_crono => pintar_crono_A);            -- Salida A  
                    
     ---------------- DISPLAY P -----------------
     u10: display_separador_crono
        Port map (  reset => reinicio,                          -- Reset del sistema BTN0
                    clock => clock,                             -- Entrada reloj del sistema
                    columna => columna,                         -- Numero actual de columna px
                    fila => fila,                               -- Numero actual de fila px
                    cabecera => cabecera_P,                     -- Cabecera ROM letra P
                    pintar_crono => pintar_crono_P);            -- Salida P       
     ----------------- DISPLAY VUELTAS -----------------                 
    u11: display_crono
        generic map ( num_bits => 4)                            -- Numero de bits necesarios para almacenar el valor de cuenta
        Port map (  reset => reinicio,                          -- Reset del sistema BTN0
                    clock => clock,                             -- Entrada reloj del sistema
                    columna => columna,                         -- Numero actual de columna px
                    fila => fila,                               -- Numero actual de fila px
                    valor_cuenta_actual => vuelta_actual_vector,-- Valor vuelta actual
                    pintar_crono_seg => pintar_crono_vuelta);   -- Salida num vuelta 
    -- Contador de minutos: habilitacion cada 59 segundos
    u12: contador 
        generic map ( num_bits => 4,                            -- Numero de bits necesarios para almacenar el valor de cuenta
                      valor_fin_cuenta => 10)                   -- Valor fin de cuenta del contador
        port map ( reset => reset,                              -- Reset del sistema BTN0
                   clock => clock,                              -- Reloj del sistema  
                   enable => flanco,                            -- Habilitacion cada minuto
                   ascendente_descendente => asc_sig,           -- Interruptor para cuenta ascendente o descendente
                   precarga => precarga_sec,                    -- Valor conteo inicial
                   fin_cuenta => open,                          -- Señal fin de cuenta
                   valor_cuenta_actual => vuelta_actual_vector);-- Valor actual de cuenta                                                   
end Behavioral;

