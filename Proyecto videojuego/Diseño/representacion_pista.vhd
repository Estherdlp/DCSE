----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.12.2023 10:05:48
-- Design Name: 
-- Module Name: representacion_pista - Behavioral
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

entity representacion_pista is
    Port (  clock : IN STD_LOGIC;                                       -- sysclk reloj del sistema 125 MHz
            reset : IN STD_LOGIC;                                       -- BTN0 reset del sistema
            columna : in STD_LOGIC_VECTOR (10 - 1 downto 0);                        -- Numero actual de columna px
            fila : in STD_LOGIC_VECTOR (10 - 1 downto 0);                       -- Numero actual de fila px
            pintar_pista : OUT STD_LOGIC_VECTOR (2 - 1 DOWNTO 0));      -- Salida deteccion fondo/fantasma
end representacion_pista;

architecture Behavioral of representacion_pista is

    -- ROM donde se almacena la pista - colores azules
    component rom1b_racetrack is
        Port (  clk  : in  std_logic;                           -- Reloj del sistema
                addr : in  std_logic_vector(5 - 1 downto 0);    -- Direccion de memoria a leer
                dout : out std_logic_vector(32 - 1 downto 0));  -- Salida de la memoria
    end component;

    -- Separador del vector de bits de la ROM en bits individuales  
    component divisor_32bits is
        Port (  dout : IN STD_LOGIC_VECTOR (32 - 1 downto 0);   -- Datos ROM
                Sel : IN STD_LOGIC_VECTOR (5 - 1 downto 0);     -- Seleccion multiplexor    
                clock : IN STD_LOGIC;                           -- Reloj del sistema
                reset : IN STD_LOGIC;                           -- Reset del sistema BTN0
                Q : OUT STD_LOGIC);                             -- Representacion bit a bit
    end component;
    
    -- ROM donde se almacena la pista - colores verdes
    component ROM1b_1f_green_racetrack_1 is
      port (    clk  : in  std_logic;                           -- Reloj del sistema
                addr : in  std_logic_vector(5-1 downto 0);      -- Direccion de memoria a leer
                dout : out std_logic_vector(32-1 downto 0) );   -- Salida de la memoria
    end component;

    -- Señales para representacion de la pista
    signal salida_rom_pista_azul : STD_LOGIC_VECTOR (32 - 1 downto 0);      -- Salida ROM pista azul
    signal salida_rom_pista_verde : STD_LOGIC_VECTOR (32 - 1 downto 0);     -- Salida ROM pista verde
    signal pintar_pista_azul : STD_LOGIC;                                   -- Representacion bit a bit azul
    signal pintar_pista_verde : STD_LOGIC;                                  -- Representacion bit a bit verde
        
begin
  
    -- Acceso a la ROM con los colores azules de la pista
    u0: rom1b_racetrack
        Port map (  clk  => clock,          -- reloj             -- Reloj del sistema              
                    addr => fila(9 - 1 downto 4),     -- Direccion de memoria a leer    
                    dout => salida_rom_pista_azul);              -- Salida de la memoria  
                             
    -- Division bit a bit de los colores azules de la pista                                               
    u1: divisor_32bits
        Port map (  dout => salida_rom_pista_azul,              -- Datos ROM                     
                    Sel => columna(9 - 1 downto 4),       -- Seleccion multiplexor         
                    clock => clock,                             -- Reloj del sistema             
                    reset => reset,                             -- Reset del sistema BTN0          
                    Q => pintar_pista_azul);                    -- Representacion bit a bit      
     
     -- Acceso a la ROM con los colores verdes de la pista              
     u2: ROM1b_1f_green_racetrack_1 
        Port map (  clk  => clock,          -- reloj             -- Reloj del sistema              
                    addr => fila(9 - 1 downto 4),     -- Direccion de memoria a leer    
                    dout => salida_rom_pista_verde);             -- Salida de la memoria 
    
    -- Division bit a bit de los colores verdes de la pista                                               
    u3: divisor_32bits
        Port map (  dout => salida_rom_pista_verde,             -- Datos ROM                     
                    Sel => columna(9 - 1 downto 4),       -- Seleccion multiplexor         
                    clock => clock,                             -- Reloj del sistema             
                    reset => reset,                             -- Reset del sistema BTN0          
                    Q => pintar_pista_verde);                   -- Representacion bit a bit  

    pintar_pista <= pintar_pista_verde & pintar_pista_azul; 
                                                                                                   
end Behavioral;

