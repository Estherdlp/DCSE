----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.11.2023 16:50:17
-- Design Name: 
-- Module Name: colores_juego - Behavioral
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

entity colores_juego is
    Port (  clock : IN STD_LOGIC;                                   -- sysclk reloj del sistema 125 MHz
            reset : IN STD_LOGIC;                                   -- BTN0 reset del sistema
            columna : IN STD_LOGIC_VECTOR (10 - 1 downto 0);        -- Numero actual de columna px
            fila : IN STD_LOGIC_VECTOR (10 - 1 downto 0);           -- Numero actual de fila px
            col_personaje : IN STD_LOGIC_VECTOR (6 - 1 DOWNTO 0);   -- Columna actual personaje
            fila_personaje : IN STD_LOGIC_VECTOR (6 - 1 DOWNTO 0);  -- Fila actual personaje
            col_fantasma : IN STD_LOGIC_VECTOR (6 - 1 DOWNTO 0);    -- Columna actual fantasma
            fila_fantasma : IN STD_LOGIC_VECTOR (6 - 1 DOWNTO 0);   -- Fila actual fantasma
            buttons_snes : IN STD_LOGIC_VECTOR (12 DOWNTO 0);       -- Vector estado botones mando
            start :  IN STD_LOGIC;                                  -- Inicio cronometro SW3
            vdata_RGB : OUT STD_LOGIC_VECTOR (23 downto 0));        -- Bus colores RGB
end colores_juego;

architecture Behavioral of colores_juego is
    component representacion_personaje is
        Port (  clock : IN STD_LOGIC;                                   -- Reloj del sistema
                reset : IN STD_LOGIC;                                   -- BTN0 reset del sistema
                columna : IN STD_LOGIC_VECTOR (10 - 1 downto 0);            -- Numero actual de columna px
                fila : IN STD_LOGIC_VECTOR (10 - 1 downto 0);           -- Numero actual de fila px
                buttons_snes : IN STD_LOGIC_VECTOR (12 DOWNTO 0);       -- Vector estado botones mando  
                pintar_personaje : OUT STD_LOGIC_VECTOR (3 - 1 DOWNTO 0));-- Salida deteccion fondo/personaje
    end component;
    
    component representacion_fantasma is
        Port (  clock : IN STD_LOGIC;                                   -- sysclk reloj del sistema 125 MHz
                reset : IN STD_LOGIC;                                   -- BTN0 reset del sistema
                columna : in STD_LOGIC_VECTOR (10 - 1 downto 0);        -- Numero actual de columna px
                fila : in STD_LOGIC_VECTOR (10 - 1 downto 0);           -- Numero actual de fila px
                pintar_fantasma : OUT STD_LOGIC);                       -- Salida deteccion fondo/fantasma
    end component;
    
    component representacion_pista is
        Port (  clock : IN STD_LOGIC;                                       -- sysclk reloj del sistema 125 MHz
                reset : IN STD_LOGIC;                                       -- BTN0 reset del sistema
                columna : in STD_LOGIC_VECTOR (10 - 1 downto 0);                -- Numero actual de columna px
                fila : in STD_LOGIC_VECTOR (10 - 1 downto 0);               -- Numero actual de fila px
                pintar_pista : OUT STD_LOGIC_VECTOR (2 - 1 DOWNTO 0));      -- Salida deteccion pista
    end component;
    
    component colores_pista is
        Generic ( num_bits_bus : integer := 24);     -- Numero de bits del bus de datos
        Port (  Color_1 : IN STD_LOGIC_VECTOR (num_bits_bus - 1 downto 0);  -- Entrada 0 multiplexor      
                Color_2 : IN STD_LOGIC_VECTOR (num_bits_bus - 1 downto 0);  -- Entrada 1 multiplexor 
                Color_3 : IN STD_LOGIC_VECTOR (num_bits_bus - 1 downto 0);  -- Entrada 1 multiplexor
                Color_4 : IN STD_LOGIC_VECTOR (num_bits_bus - 1 downto 0);  -- Entrada 1 multiplexor
                Seleccion_color : IN STD_LOGIC_VECTOR (2 - 1 downto 0);              -- Seleccion entrada multiplexor 
                Salida_color : OUT STD_LOGIC_VECTOR (num_bits_bus - 1 downto 0));   -- Salida multiplexor 4 bits 
    end component;
    
    component colores_fantasma is
        Generic ( num_bits_bus : integer := 24);            -- Numero de bits del bus de datos
        Port (  Color_1 : IN STD_LOGIC_VECTOR (num_bits_bus - 1 downto 0); -- Entrada 0 multiplexor 4 bits      
                Color_2 : IN STD_LOGIC_VECTOR (num_bits_bus - 1 downto 0); -- Entrada 1 multiplexor 4 bits  
                Seleccion_color : in STD_LOGIC;                      -- Seleccion entrada multiplexor 
                Salida_color : out STD_LOGIC_VECTOR (num_bits_bus - 1 downto 0));-- Salida multiplexor 4 bits 
    end component;
    
    component colores_personaje is
        Generic ( num_bits_bus : integer := 24);                         -- Numero de bits del bus de datos
        Port (  Color_1 : IN STD_LOGIC_VECTOR (num_bits_bus - 1 downto 0);  -- Entrada 0 multiplexor      
                Color_2 : IN STD_LOGIC_VECTOR (num_bits_bus - 1 downto 0);  -- Entrada 1 multiplexor 
                Color_3 : IN STD_LOGIC_VECTOR (num_bits_bus - 1 downto 0);  -- Entrada 2 multiplexor
                Color_4 : IN STD_LOGIC_VECTOR (num_bits_bus - 1 downto 0);  -- Entrada 3 multiplexor
                Seleccion_color : IN STD_LOGIC_VECTOR (3 - 1 downto 0);             -- Seleccion entrada multiplexor 
                Salida_color : OUT STD_LOGIC_VECTOR (num_bits_bus - 1 downto 0));   -- Salida multiplexor 
    end component;
    
    component cronometro_personaje is
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
    end component;
    
    component colores_vuelta is
        Port (  color_pista : IN STD_LOGIC_VECTOR (23 downto 0);
                pintar_crono_seg : IN STD_LOGIC;                -- Salida segundos
                pintar_crono_dec : IN STD_LOGIC;                -- Salida decenas segundo
                pintar_crono_min : IN STD_LOGIC;                -- Salida minutos
                pintar_crono_puntos : IN STD_LOGIC;             -- Salida :
                pintar_crono_L : IN STD_LOGIC;                  -- Salida L
                pintar_crono_A : IN STD_LOGIC;                  -- Salida A
                pintar_crono_P : IN STD_LOGIC;                  -- Salida P
                pintar_crono_vuelta : IN STD_LOGIC;             -- Salida num vuelta
                color_crono_seg : OUT STD_LOGIC_VECTOR (23 downto 0);       -- Colores del cronometro
                color_crono_dec : OUT STD_LOGIC_VECTOR (23 downto 0);       -- Colores del cronometro
                color_crono_min : OUT STD_LOGIC_VECTOR (23 downto 0);       -- Colores del cronometro
                color_crono_puntos : OUT STD_LOGIC_VECTOR (23 downto 0);   -- Colores del cronometro
                color_crono_L : OUT STD_LOGIC_VECTOR (23 downto 0);   -- Colores del cronometro
                color_crono_A : OUT STD_LOGIC_VECTOR (23 downto 0);   -- Colores del cronometro
                color_crono_P : OUT STD_LOGIC_VECTOR (23 downto 0);   -- Colores del cronometro
                color_crono_vuelta : OUT STD_LOGIC_VECTOR (23 downto 0));           -- Salida num vuelta
    end component;

    component control_cuadricula is
        Port (  color_pista : IN STD_LOGIC_VECTOR (23 downto 0);        -- Colores de la pista
                color_fantasma : IN STD_LOGIC_VECTOR (23 downto 0);     -- Colores del fantasma
                color_personaje : IN STD_LOGIC_VECTOR (23 downto 0);    -- Colores del personaje
                color_crono_seg : IN STD_LOGIC_VECTOR (23 downto 0);    -- Colores del cronometro
                color_crono_dec : IN STD_LOGIC_VECTOR (23 downto 0);    -- Colores del cronometro
                color_crono_min : IN STD_LOGIC_VECTOR (23 downto 0);    -- Colores del cronometro
                color_crono_puntos : IN STD_LOGIC_VECTOR (23 downto 0); -- Colores del cronometro
                color_crono_L : IN STD_LOGIC_VECTOR (23 downto 0);      -- Colores del cronometro
                color_crono_A : IN STD_LOGIC_VECTOR (23 downto 0);      -- Colores del cronometro
                color_crono_P : IN STD_LOGIC_VECTOR (23 downto 0);      -- Colores del cronometro
                color_crono_vuelta :IN STD_LOGIC_VECTOR (23 downto 0);-- Salida num vuelta
                columna : IN STD_LOGIC_VECTOR (10 - 1 downto 0);        -- Numero actual de columna px
                fila : IN STD_LOGIC_VECTOR (10 - 1 downto 0);           -- Numero actual de fila px
                col_personaje : IN STD_LOGIC_VECTOR (6 - 1 DOWNTO 0);   -- Columna actual personaje
                fila_personaje : IN STD_LOGIC_VECTOR (6 - 1 DOWNTO 0);  -- Fila actual personaje
                col_fantasma : IN STD_LOGIC_VECTOR (6 - 1 DOWNTO 0);    -- Columna actual fantasma
                fila_fantasma : IN STD_LOGIC_VECTOR (6 - 1 DOWNTO 0);   -- Fila actual fantasma
                vdata_RGB : OUT STD_LOGIC_VECTOR (23 downto 0));        -- Bus colores RGB
    end component;
    
    -- Selector para representacion elementos del juego
    signal pintar_personaje : STD_LOGIC_VECTOR (3 - 1 DOWNTO 0);
    signal pintar_fantasma : STD_LOGIC;
    signal pintar_pista : STD_LOGIC_VECTOR (2 - 1 DOWNTO 0);
    signal pintar_crono_seg : STD_LOGIC;
    signal pintar_crono_dec : STD_LOGIC;
    signal pintar_crono_min : STD_LOGIC;
    signal pintar_crono_puntos : STD_LOGIC;
    signal pintar_crono_L : STD_LOGIC;
    signal pintar_crono_A : STD_LOGIC;
    signal pintar_crono_P : STD_LOGIC;
    signal pintar_crono_vuelta : STD_LOGIC;
    -- Paleta de colores
    signal blanco : STD_LOGIC_VECTOR (23 downto 0) := (others => '1');
    signal rojo : STD_LOGIC_VECTOR (23 downto 0) := "111111110000000000000000";
    signal verde : STD_LOGIC_VECTOR (23 downto 0) := "000000001111111100000000";
    signal azul : STD_LOGIC_VECTOR (23 downto 0) := "000000000000000011111111";
    signal amarillo : STD_LOGIC_VECTOR (23 downto 0) := "111111111111111100000000";
    signal negro : STD_LOGIC_VECTOR (23 downto 0) := (others => '0');
    -- Variables auxiliares para pintar el juego
    signal color_pista : STD_LOGIC_VECTOR (23 downto 0);
    signal color_fantasma : STD_LOGIC_VECTOR (23 downto 0);
    signal color_personaje : STD_LOGIC_VECTOR (23 downto 0);
    signal color_crono_seg : STD_LOGIC_VECTOR (23 downto 0);
    signal color_crono_dec : STD_LOGIC_VECTOR (23 downto 0);
    signal color_crono_min : STD_LOGIC_VECTOR (23 downto 0);
    signal color_crono_puntos : STD_LOGIC_VECTOR (23 downto 0);
    signal color_crono_L : STD_LOGIC_VECTOR (23 downto 0);
    signal color_crono_A : STD_LOGIC_VECTOR (23 downto 0);
    signal color_crono_P : STD_LOGIC_VECTOR (23 downto 0);
    signal color_crono_vuelta : STD_LOGIC_VECTOR (23 downto 0);
begin

    -- Representacion del personaje: posicion y orientacion
    u0: representacion_personaje 
        Port map (  clock => clock,                             -- sysclk reloj del sistema 125 MHz
                    reset => reset,                             -- BTN0 reset del sistema
                    columna => columna,                                 -- Numero actual de columna px
                    fila => fila,                               -- Numero actual de fila px
                    buttons_snes => buttons_snes,               -- Vector estado botones mando
                    pintar_personaje => pintar_personaje);      -- Salida deteccion fondo/personaje
    
    -- Posicion del fantasma                       
    u1: representacion_fantasma
        Port map (  clock => clock,                             -- sysclk reloj del sistema 125 MHz
                    reset => reset,                             -- BTN0 reset del sistema
                    columna => columna,                                 -- Numero actual de columna px
                    fila => fila,                               -- Numero actual de fila px
                    pintar_fantasma => pintar_fantasma);        -- Salida deteccion fondo/personaje
    
    -- Colores de la pista                    
    u2: representacion_pista
        Port map (  clock => clock,                             -- sysclk reloj del sistema 125 MHz
                    reset => reset,                             -- BTN0 reset del sistema
                    columna => columna,                                 -- Numero actual de columna px
                    fila => fila,                               -- Numero actual de fila px
                    pintar_pista => pintar_pista);              -- Colores de la pista            
    
    -- Salida color de la pista
    u3: colores_pista
        Generic map ( num_bits_bus => 24)                       -- Numero de bits del bus de datos
        Port map (  Color_1 => rojo,                            -- Entrada 0 multiplexor      
                    Color_2 => azul,                            -- Entrada 1 multiplexor 
                    Color_3 => verde,                           -- Entrada 2 multiplexor
                    Color_4 => blanco,                          -- Entrada 3 multiplexor
                    Seleccion_color => pintar_pista,            -- Seleccion entrada multiplexor 
                    Salida_color => color_pista);               -- Salida multiplexor
     
     -- Salida color del fantasma               
     u4: colores_fantasma
        Generic map ( num_bits_bus => 24)                       -- Numero de bits del bus de datos
        Port map (  Color_1 => azul,                            -- Entrada 0 multiplexor      
                    Color_2 => color_pista,                     -- Entrada 1 multiplexor 
                    Seleccion_color => pintar_fantasma,         -- Seleccion entrada multiplexor 
                    Salida_color => color_fantasma);            -- Salida multiplexor           
    
    -- Salida color del personaje
    u5: colores_personaje
        Generic map ( num_bits_bus => 24)                       -- Numero de bits del bus de datos
        Port map(   Color_1 => amarillo,                        -- Entrada 0 multiplexor      
                    Color_2 => negro,                           -- Entrada 1 multiplexor 
                    Color_3 => color_pista,                     -- Entrada 2 multiplexor
                    Color_4 => color_pista,                     -- Entrada 2 multiplexor
                    Seleccion_color => pintar_personaje,        -- Seleccion entrada multiplexor 
                    Salida_color => color_personaje);           -- Salida multiplexor 
     
    -- Salida cronometro
    u6: cronometro_personaje
        Port map (  reset => reset,                             -- Reset del sistema BTN0
                    clock => clock,                             -- Entrada reloj del sistema
                    start => start,                             -- Start/stop cronometro
                    columna => columna,                         -- Numero actual de columna px
                    fila => fila,                               -- Numero actual de fila px
                    col_personaje => col_personaje,             -- Columna actual personaje
                    fila_personaje => fila_personaje,           -- Fila actual personaje
                    pintar_crono_seg => pintar_crono_seg,       -- Salida segundos
                    pintar_crono_dec => pintar_crono_dec,       -- Salida decenas de segundo
                    pintar_crono_min => pintar_crono_min,       -- Salida minutos
                    pintar_crono_puntos => pintar_crono_puntos, -- Salida :
                    pintar_crono_L => pintar_crono_L,           -- Salida L
                    pintar_crono_A => pintar_crono_A,           -- Salida A
                    pintar_crono_P => pintar_crono_P,           -- Salida P
                    pintar_crono_vuelta => pintar_crono_vuelta);-- Salida numero de vuelta
                    
    u7: colores_vuelta
        Port map (  color_pista => color_pista,                 -- Color pista
                    pintar_crono_seg => pintar_crono_seg,       -- Salida segundos
                    pintar_crono_dec => pintar_crono_dec,       -- Salida decenas de segundo
                    pintar_crono_min => pintar_crono_min,       -- Salida minutos
                    pintar_crono_puntos => pintar_crono_puntos, -- Salida :
                    pintar_crono_L => pintar_crono_L,           -- Salida L
                    pintar_crono_A => pintar_crono_A,           -- Salida A
                    pintar_crono_P => pintar_crono_P,           -- Salida P
                    pintar_crono_vuelta => pintar_crono_vuelta, -- Salida numero vuelta
                    color_crono_seg => color_crono_seg,         -- Color cronometro segundos
                    color_crono_dec => color_crono_dec,         -- Color cronometro decenas de segundo
                    color_crono_min => color_crono_min,         -- Color cronometro minutos
                    color_crono_puntos => color_crono_puntos,   -- Color cronometro :
                    color_crono_L => color_crono_L,             -- Color cronometro L
                    color_crono_A => color_crono_A,             -- Color cronometro A
                    color_crono_P => color_crono_P,             -- Color cronometro P
                    color_crono_vuelta => color_crono_vuelta);  -- Color numero vuelta
                    
    u11: control_cuadricula       
        Port map (  color_pista  => color_pista,        -- Colores de la pista
                    color_fantasma  => color_fantasma,  -- Colores del fantasma
                    color_personaje  => color_personaje,-- Colores del personaje
                    color_crono_seg => color_crono_seg, -- Color cronometro segundos
                    color_crono_dec => color_crono_dec, -- Color cronometro decenas de segundo
                    color_crono_min => color_crono_min, -- Color cronometro minutos
                    color_crono_puntos => color_crono_puntos,   -- Color cronometro :
                    color_crono_L => color_crono_L,   -- Color cronometro L
                    color_crono_A => color_crono_A,   -- Color cronometro A
                    color_crono_P => color_crono_P,   -- Color cronometro P
                    color_crono_vuelta => color_crono_vuelta,  -- Color numero vuelta
                    columna => columna,                 -- Numero actual de columna px
                    fila => fila,                       -- Numero actual de fila px
                    col_personaje => col_personaje,     -- Columna actual personaje
                    fila_personaje => fila_personaje,   -- Fila actual personaje
                    col_fantasma => col_fantasma,       -- Columna actual fantasma
                    fila_fantasma => fila_fantasma,     -- Fila actual fantasma
                    vdata_RGB => vdata_RGB);            -- Bus colores RGB        
end Behavioral;
