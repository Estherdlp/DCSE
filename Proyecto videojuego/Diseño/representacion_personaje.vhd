----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.11.2023 22:49:15
-- Design Name: 
-- Module Name: representacion_personaje - Behavioral
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

entity representacion_personaje is
    Port (  clock : IN STD_LOGIC;                                   -- Reloj del sistema
            reset : IN STD_LOGIC;                                   -- BTN0 reset del sistema
            columna : IN STD_LOGIC_VECTOR (10 - 1 downto 0);                    -- Numero actual de columna px
            fila : IN STD_LOGIC_VECTOR (10 - 1 downto 0);                   -- Numero actual de fila px
            buttons_snes : IN STD_LOGIC_VECTOR (12 DOWNTO 0);       -- Vector estado botones mando  
            pintar_personaje : OUT STD_LOGIC_VECTOR (3 - 1 DOWNTO 0));-- Salida deteccion fondo/personaje
end representacion_personaje;

architecture Behavioral of representacion_personaje is

    -- Separador del vector de bits de la ROM en bits individuales    
    component divisor_16bits is
        Port (  dout : IN STD_LOGIC_VECTOR (16 - 1 downto 0);   -- Datos ROM
                sel_divisor : IN STD_LOGIC_VECTOR (4 - 1 downto 0);     -- Seleccion multiplexor
                clock : IN STD_LOGIC;                           -- Reloj del sistema
                reset : IN STD_LOGIC;                           -- Reset del sistema BTN0
                buttons_snes : IN STD_LOGIC_VECTOR (12 DOWNTO 0);   -- Vector estado botones mando
                salida : OUT STD_LOGIC);                             -- Representacion bit a bit del personaje
    end component;
    
    -- ROM personajes tonos azules
    component ROM1b_1f_blue_imagenes16_16x16 is
        port (  clk  : in  std_logic;   -- reloj
                addr : in  std_logic_vector(8-1 downto 0);
                dout : out std_logic_vector(16-1 downto 0));
    end component;
    
    -- ROM personajes tonos verdes
    component ROM1b_1f_green_imagenes16_16x16 is
        port (  clk  : in  std_logic;   -- reloj
                addr : in  std_logic_vector(8-1 downto 0);
                dout : out std_logic_vector(16-1 downto 0) );
    end component;
    
    -- ROM personajes tonos rojos
    component ROM1b_1f_red_imagenes16_16x16 is
        port (  clk  : in  std_logic;   -- reloj
                addr : in  std_logic_vector(8-1 downto 0);
                dout : out std_logic_vector(16-1 downto 0));
    end component;
    
    component sel_mux_personaje is
        Port (  reset : IN STD_LOGIC;                                           -- BTN0 reset del sistema
                columna : IN STD_LOGIC_VECTOR (10 - 1 downto 0);                -- Numero actual de columna px
                fila : IN STD_LOGIC_VECTOR (10 - 1 downto 0);                   -- Numero actual de fila px
                buttons_snes : IN STD_LOGIC_VECTOR (12 DOWNTO 0);               -- Vector estado botones mando
                sel_divisor_personaje : OUT STD_LOGIC_VECTOR (4 - 1 downto 0);  -- Selector multiplexor pixel a pixel fondo/personaje 
                direccion_personaje : OUT STD_LOGIC_VECTOR (8 - 1 downto 0));   -- Direccion ROM personaje
    end component;
    
    -- Señales intermedias acceso memoria personajes del juego
    signal salida_rom_personaje_azul : STD_LOGIC_VECTOR (16 - 1 downto 0);  -- Salida ROM azul personaje
    signal salida_rom_personaje_verde : STD_LOGIC_VECTOR (16 - 1 downto 0); -- Salida ROM verde personaje
    signal salida_rom_personaje_rojo : STD_LOGIC_VECTOR (16 - 1 downto 0);  -- Salida ROM roja personaje
    signal pintar_personaje_azul : STD_LOGIC;                               -- Salida deteccion personaje azul
    signal pintar_personaje_verde : STD_LOGIC;                              -- Salida deteccion personaje verde
    signal pintar_personaje_rojo : STD_LOGIC;                               -- Salida deteccion personaje rojo
    signal direccion_personaje : STD_LOGIC_VECTOR (8 - 1 downto 0);         -- Selector multiplexor pixel a pixel fondo/personaje   
    signal sel_divisor_personaje : STD_LOGIC_VECTOR (4 - 1 downto 0);       -- Direccion ROM personaje                              

begin                                   
    -- Calculo del selector del multiplexor para mostrar el personaje girado
    u0: sel_mux_personaje
        Port map (  reset => reset,                                 -- BTN0 reset del sistema
                    columna => columna,                                     -- Numero actual de columna px
                    fila => fila,                                   -- Numero actual de fila px
                    buttons_snes => buttons_snes,                   -- Vector estado botones mando
                    sel_divisor_personaje => sel_divisor_personaje, -- Selector multiplexor pixel a pixel fondo/personaje 
                    direccion_personaje => direccion_personaje);    -- Direccion ROM personaje

    -- Acceso a la ROM ROJA
    u1: ROM1b_1f_red_imagenes16_16x16
        Port map (  clk  => clock,          -- reloj
                    addr => direccion_personaje,
                    dout => salida_rom_personaje_rojo); 
    -- Separador del vector de bits de la ROM en bits individuales                  
    u2: divisor_16bits
        Port map (  dout => salida_rom_personaje_rojo,          -- Datos ROM
                    sel_divisor => sel_divisor_personaje,       -- Seleccion multiplexor
                    clock => clock,                             -- Reloj del sistema
                    reset => reset,                             -- Reset del sistema BTN0
                    buttons_snes => buttons_snes,               -- Vector estado botones mando
                    salida => pintar_personaje_rojo);                -- Representacion bit a bit del personaje
                
    -- Acceso a la ROM VERDE
    u3: ROM1b_1f_green_imagenes16_16x16
        Port map (  clk  => clock,          -- reloj
                    addr => direccion_personaje,
                    dout => salida_rom_personaje_verde); 
    -- Separador del vector de bits de la ROM en bits individuales                  
    u4: divisor_16bits
        Port map (  dout => salida_rom_personaje_verde,         -- Datos ROM
                    sel_divisor => sel_divisor_personaje,       -- Seleccion multiplexor
                    clock => clock,                             -- Reloj del sistema
                    reset => reset,                             -- Reset del sistema BTN0
                    buttons_snes => buttons_snes,               -- Vector estado botones mando      
                    salida => pintar_personaje_verde);               -- Representacion bit a bit del personaje
                    
    -- Acceso a la ROM AZUL
    u5: ROM1b_1f_blue_imagenes16_16x16
        Port map (  clk  => clock,          -- reloj
                    addr => direccion_personaje,
                    dout => salida_rom_personaje_azul); 
    -- Separador del vector de bits de la ROM en bits individuales                  
    u6: divisor_16bits
        Port map (  dout => salida_rom_personaje_azul,          -- Datos ROM
                    sel_divisor => sel_divisor_personaje,       -- Seleccion multiplexor
                    clock => clock,                             -- Reloj del sistema
                    reset => reset,                             -- Reset del sistema BTN0
                    buttons_snes => buttons_snes,               -- Vector estado botones mando      
                    salida => pintar_personaje_azul);                -- Representacion bit a bit del personaje
                    
    pintar_personaje <= pintar_personaje_rojo & pintar_personaje_verde & pintar_personaje_azul;
    
end Behavioral;
