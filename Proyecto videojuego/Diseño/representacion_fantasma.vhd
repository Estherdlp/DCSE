----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.11.2023 22:46:27
-- Design Name: 
-- Module Name: representacion_fantasma - Behavioral
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

entity representacion_fantasma is
    Port (  clock : IN STD_LOGIC;                                       -- sysclk reloj del sistema 125 MHz
            reset : IN STD_LOGIC;                                       -- BTN0 reset del sistema
            columna : IN STD_LOGIC_VECTOR (10 - 1 downto 0);            -- Numero actual de columna px
            fila : IN STD_LOGIC_VECTOR (10 - 1 downto 0);               -- Numero actual de fila px
            pintar_fantasma : OUT STD_LOGIC);                           -- Salida deteccion fondo/fantasma
end representacion_fantasma;

architecture Behavioral of representacion_fantasma is
    
    -- ROM donde se almacenan los personajes del juego
    component rom1b_personajes is
        Port (  clk  : in  std_logic;                               -- Reloj del sistema
                addr : in  std_logic_vector(8 - 1 downto 0);        -- Direccion de memoria a leer
                dout : out std_logic_vector(16 - 1 downto 0));      -- Salida de la memoria
    end component;
    
    -- Separador del vector de bits de la ROM en bits individuales    
    component divisor_16bits is
        Port (  dout : IN STD_LOGIC_VECTOR (16 - 1 downto 0);   -- Datos ROM
                sel_divisor : IN STD_LOGIC_VECTOR (4 - 1 downto 0);     -- Seleccion multiplexor
                clock : IN STD_LOGIC;                           -- Reloj del sistema
                reset : IN STD_LOGIC;                           -- Reset del sistema BTN0
                buttons_snes : IN STD_LOGIC_VECTOR (12 DOWNTO 0);   -- Vector estado botones mando
                salida : OUT STD_LOGIC);                             -- Representacion bit a bit del personaje
    end component;
    
    -- Señales para representacion del fantasma
    signal direccion_fantasma :  STD_LOGIC_VECTOR (8 - 1 downto 0);     -- Direccion ROM fantasma
    signal fantasma : STD_LOGIC_VECTOR (4 - 1 downto 0) := "0100";      -- Cabecera ROM fantasma
    signal salida_rom_fantasma : STD_LOGIC_VECTOR (16 - 1 downto 0);    -- Salida ROM personaje
    signal buttons_snes : STD_LOGIC_VECTOR (12 DOWNTO 0) := (others => '0');   -- Vector estado botones mando
    
begin
    -- Direcciones de ROM de los distintos personajes del juego
    direccion_fantasma <= fantasma & fila(4 - 1 downto 0);
    
    -- Acceso a la ROM con los distintos personajes del juego
    u0: rom1b_personajes
        Port map (  clk  => clock,          -- reloj
                    addr => direccion_fantasma,
                    dout => salida_rom_fantasma); 

    u1: divisor_16bits
        Port map (  dout => salida_rom_fantasma,
                    sel_divisor => columna(4 - 1 downto 0),
                    clock => clock,
                    reset => reset,                             -- Reset del sistema BTN0
                    buttons_snes => buttons_snes,    
                    salida => pintar_fantasma);

end Behavioral;
