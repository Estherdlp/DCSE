----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.11.2023 16:44:14
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
    Port (  clock : IN STD_LOGIC;               -- Señal de reloj 125 MHz
            reset : IN STD_LOGIC;               -- Reset BTN0
            data_snes : IN STD_LOGIC;           -- Estado botones mando
            dificultad : IN STD_LOGIC_VECTOR (1 downto 0);   -- Interruptores para la dificultad
            start : IN STD_LOGIC;               -- Inicio cronometro SW3
            latch : OUT STD_LOGIC;              -- Latch mando
            clock_fsm : OUT STD_LOGIC;          -- Reloj para mando
            clk_p : OUT STD_LOGIC;              -- Reloj HDMI +
            clk_n : OUT STD_LOGIC;              -- Reloj HDMI -
            data_p : OUT STD_LOGIC_VECTOR (2 downto 0);     -- Datos HDMI +
            data_n : OUT STD_LOGIC_VECTOR (2 downto 0));     -- Datos HDMI -
end main;

architecture Behavioral of main is
    component clock_gen is
        generic(CLKIN_PERIOD : real:=8.000;     --input clock period (8ns)
                CLK_MULTIPLY : integer:=8;      --multiplier
                CLK_DIVIDE : integer:=1;        --divider
                CLKOUT0_DIV : integer:=8;       --serial clock divider
                CLKOUT1_DIV : integer:=40);     --pixel clockdivider 
        port(   clk_i : in std_logic;           --input clock  (125 MHz)
                clk0_o : out std_logic;         --serial clock (125 MHz)
                clk1_o : out std_logic);        --pixel clock  (25 MHz)
    end component;

    component SYNC_VGA is
        Port (  clk1 : IN STD_LOGIC;            -- Reloj 25 MHz
                reset : IN STD_LOGIC;           -- Reset BTN0
                hsync : OUT STD_LOGIC;          -- Sincronizacion horizontal
                vsync : OUT STD_LOGIC;          -- Sincronizacion vertical
                visible : OUT STD_LOGIC;        -- Zona visible de la pantalla
                fila_actual : out STD_LOGIC_VECTOR (10 - 1 downto 0);       -- Fila pixel actual
                columna_actual : out STD_LOGIC_VECTOR (10 - 1 downto 0));   -- Columna pixel actual
    end component;
    
    component colores_juego is
        Port (  clock : IN STD_LOGIC;                           -- sysclk reloj del sistema 125 MHz
                reset : IN STD_LOGIC;                           -- BTN0 reset del sistema
                columna : IN STD_LOGIC_VECTOR (10 - 1 downto 0);-- Numero actual de columna px
                fila : IN STD_LOGIC_VECTOR (10 - 1 downto 0);   -- Numero actual de fila px
                col_personaje : IN STD_LOGIC_VECTOR (6 - 1 DOWNTO 0);   -- Columna actual personaje
                fila_personaje : IN STD_LOGIC_VECTOR (6 - 1 DOWNTO 0);  -- Fila actual personaje
                col_fantasma : IN STD_LOGIC_VECTOR (6 - 1 DOWNTO 0);    -- Columna actual fantasma
                fila_fantasma : IN STD_LOGIC_VECTOR (6 - 1 DOWNTO 0);   -- Fila actual fantasma
                buttons_snes : IN STD_LOGIC_VECTOR (12 DOWNTO 0);       -- Vector estado botones mando
                start :  IN STD_LOGIC;                                  -- Inicio cronometro SW3   
                vdata_RGB : OUT STD_LOGIC_VECTOR (23 downto 0));-- Bus colores RGB
    end component;
    
    component hdmi_rgb2tmds is
        Generic ( SERIES6 : boolean := false);
        Port(   rst : in std_logic;                             -- Reset del sistema
                pixelclock : in std_logic;                      -- slow pixel clock 1x
                serialclock : in std_logic;                     -- fast serial clock 5x
                video_data : in std_logic_vector(23 downto 0);  -- Bus colores RGB
                video_active  : in std_logic;                   -- Zona visible
                hsync : in std_logic;                           -- Sincronizacion horizontal
                vsync : in std_logic;                           -- Sincronizacion vertical
                clk_p : out std_logic;                          -- Reloj + HDMI
                clk_n : out std_logic;                          -- Reloj - HDMI
                data_p : out std_logic_vector(2 downto 0);      -- Datos + HDMI
                data_n : out std_logic_vector(2 downto 0));     -- Datos - HDMI
    end component;
    
    component fsm_personajes is
        Port (  reset : IN STD_LOGIC;                         -- Reset del sistema BTN0
                clock : IN STD_LOGIC;                         -- Entrada reloj del sistema
                buttons_snes : IN STD_LOGIC_VECTOR (12 DOWNTO 0);           -- Vector estado botones mando    
                dificultad : IN STD_LOGIC_VECTOR (1 downto 0);   -- Interruptores para la dificultad
                filas_personaje : OUT STD_LOGIC_VECTOR (6 - 1 DOWNTO 0);    -- Posicion actual fila personaje
                columnas_personaje : OUT STD_LOGIC_VECTOR (6 - 1 DOWNTO 0); -- Posicion actual columna personaje
                filas_fantasma: OUT STD_LOGIC_VECTOR (6 - 1 DOWNTO 0);      -- Posicion actual fila fantasma
                columnas_fantasma : OUT STD_LOGIC_VECTOR (6 - 1 DOWNTO 0)); -- Posicion actual columna fantasma                          
    end component;
    
    component mando_snes is
        Port (  clock : IN STD_LOGIC;                               -- sysclk reloj del sistema 125 MHz
                reset : IN STD_LOGIC;                               -- BTN0 reset del sistema
                data_snes : IN STD_LOGIC;                           -- Estado de cada boton del mando
                latch : OUT STD_LOGIC;                              -- Pulso inicio
                clock_fsm : OUT STD_LOGIC;                          -- Reloj para mando
                buttons_snes : OUT STD_LOGIC_VECTOR (12 DOWNTO 0)); -- Vector con estado de todos los botones
    end component;

    -- Señales intermedias PLL
    signal clock_0 : STD_LOGIC;     -- Reloj 125 MHz
    signal clock_1 : STD_LOGIC;     -- Reloj 25 MHz
    -- Señales intermedias sync vga
    signal hsync : STD_LOGIC;       -- Sincronizacion horizontal
    signal vsync : STD_LOGIC;       -- Sincronizacion vertical
    signal visible : STD_LOGIC;     -- Zona visible de la pantalla
    signal columnas : STD_LOGIC_VECTOR (10 - 1 downto 0);   -- Columna pixel actual
    signal filas : STD_LOGIC_VECTOR (10 - 1 downto 0);      -- Fila pixel actual
    -- Señales intermedias color de cada pixel
    signal vdata_RGB : STD_LOGIC_VECTOR (23 downto 0);      -- Bus colores RGB
    -- Señales intermedias movimiento del personaje manual
    signal actual_filas_personaje : STD_LOGIC_VECTOR (6 - 1 DOWNTO 0);      -- Posicion de fila actual personaje
    signal actual_columnas_personaje : STD_LOGIC_VECTOR (6 - 1 DOWNTO 0);   -- Posicion de columna actual personaje
    -- Señales intermedias movimiento del fantasma
    signal actual_filas_fantasma : STD_LOGIC_VECTOR (6 - 1 DOWNTO 0);       -- Posicion de fila actual fantasma
    signal actual_columnas_fantasma : STD_LOGIC_VECTOR (6 - 1 DOWNTO 0);    -- Posicion de columna actual fantasma
    -- Señales intermedias mando
    signal buttons_snes : STD_LOGIC_VECTOR (12 DOWNTO 0);
begin

    u0: clock_gen
        Generic map(    CLKIN_PERIOD => 8.000,      --input clock period (8ns)
                        CLK_MULTIPLY => 8,          --multiplier
                        CLK_DIVIDE => 1,            --divider
                        CLKOUT0_DIV => 8,           --serial clock divider
                        CLKOUT1_DIV => 40)          --pixel clockdivider 
        Port map (  clk_i => clock,                 --input clock
                    clk0_o => clock_0,              --serial clock
                    clk1_o => clock_1);             --pixel clock

    u1: SYNC_VGA
        Port map (  clk1 => clock_1,                -- Reloj 25 MHz                     
                    reset => reset,                 -- Reset BTN0                        
                    hsync => hsync,                 -- Sincronizacion horizontal        
                    vsync => vsync,                 -- Sincronizacion vertical          
                    visible => visible,             -- Zona visible de la pantalla      
                    fila_actual => filas,           -- Fila pixel actual       
                    columna_actual => columnas);    -- Columna pixel actual
                    
    u2: colores_juego
        Port map (  clock => clock_0,                           -- sysclk reloj del sistema 125 MHz  
                    reset => reset,                             -- BTN0 reset del sistema    
                    columna => columnas,                        -- Columna pixel actual  
                    fila => filas,                              -- Fila pixel actual         
                    col_personaje => actual_columnas_personaje, -- Columna actual personaje          
                    fila_personaje => actual_filas_personaje,   -- Fila actual personaje             
                    col_fantasma => actual_columnas_fantasma,   -- Columna actual fantasma              
                    fila_fantasma => actual_filas_fantasma,     -- Fila actual fantasma          
                    buttons_snes => buttons_snes,               -- Vector estado botones mando
                    start => start,                             -- Start cronometro SW3      
                    vdata_RGB => vdata_RGB);                    -- Bus colores RGB                
                    
    u3: hdmi_rgb2tmds
        Generic map (   SERIES6 => false )                                                           
        Port map(   rst => reset,               -- Reset del sistema               
                    pixelclock => clock_1,      -- slow pixel clock 1x             
                    serialclock => clock_0,     -- fast serial clock 5x            
                    video_data => vdata_RGB,    -- Bus colores RGB                 
                    video_active => visible,    -- Zona visible                    
                    hsync => hsync,             -- Sincronizacion horizontal       
                    vsync => vsync,             -- Sincronizacion vertical         
                    clk_p => clk_p,             -- Reloj + HDMI                    
                    clk_n => clk_n,             -- Reloj - HDMI                    
                    data_p => data_p,           -- Datos + HDMI                    
                    data_n => data_n);          -- Datos - HDMI                    
                    
    -- Maquina de estados para controlar todos los personajes                
    u4: fsm_personajes
        Port map(   reset => reset,                                 -- Reset del sistema BTN0
                    clock => clock_0,                               -- Entrada reloj del sistema
                    buttons_snes => buttons_snes,                   -- Vector con estado de todos los botones 
                    dificultad => dificultad, 
                    filas_personaje => actual_filas_personaje,      -- Posicion actual fila personaje    
                    columnas_personaje => actual_columnas_personaje,-- Posicion actual columna personaje
                    filas_fantasma => actual_filas_fantasma,        -- Posicion actual fila fantasma    
                    columnas_fantasma => actual_columnas_fantasma); -- Posicion actual columna fantasma  
                    
    -- Mando SNES
    u5: mando_snes
        Port map(  clock => clock_0,                -- sysclk reloj del sistema 125 MHz
                    reset => reset,                 -- BTN0 reset del sistema
                    data_snes => data_snes,         -- Estado de cada boton del mando
                    latch => latch,                 -- Pulso inicio
                    clock_fsm => clock_fsm,         -- Reloj para mando
                    buttons_snes => buttons_snes);  -- Vector con estado de todos los botones       
end Behavioral;