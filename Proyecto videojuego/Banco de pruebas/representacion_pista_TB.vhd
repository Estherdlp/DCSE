----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.12.2023 11:01:23
-- Design Name: 
-- Module Name: representacion_pista_TB - Behavioral
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

entity representacion_pista_TB is
--  Port ( );
end representacion_pista_TB;

architecture Behavioral of representacion_pista_TB is
    component representacion_pista is
        Port (  clock : IN STD_LOGIC;                                       -- sysclk reloj del sistema 125 MHz
                reset : IN STD_LOGIC;                                       -- BTN0 reset del sistema
                columna : in STD_LOGIC_VECTOR (10 - 1 downto 0);                        -- Numero actual de columna px
                fila : in STD_LOGIC_VECTOR (10 - 1 downto 0);                       -- Numero actual de fila px
                pintar_pista : OUT STD_LOGIC_VECTOR (2 - 1 DOWNTO 0));      -- Salida deteccion fondo/fantasma
    end component;
    
    component SYNC_VGA is
        Port (  clk1 : IN STD_LOGIC;            -- Reloj 25 MHz
                reset : IN STD_LOGIC;           -- Reset SW0
                hsync : OUT STD_LOGIC;          -- Sincronizacion horizontal
                vsync : OUT STD_LOGIC;          -- Sincronizacion vertical
                visible : OUT STD_LOGIC;        -- Zona visible de la pantalla
                fila_actual : out STD_LOGIC_VECTOR (10 - 1 downto 0);   -- Fila pixel actual
                columna_actual : out STD_LOGIC_VECTOR (10 - 1 downto 0));   -- Columna pixel actual
    end component;
    
    signal clock_est : STD_LOGIC := '0';
    signal reset_est : STD_LOGIC := '0';
    signal columnas : STD_LOGIC_VECTOR (10 - 1 downto 0);   -- Columna pixel actual
    signal filas : STD_LOGIC_VECTOR (10 - 1 downto 0);      -- Fila pixel actual
    signal pintar_pista_est : STD_LOGIC_VECTOR (1 DOWNTO 0) := (others => '0');
    signal hsync_est : STD_LOGIC;
    signal vsync_est : STD_LOGIC;
    signal visible_est : STD_LOGIC;
    
    constant PERIOD : time := 8ns;
begin

    UUT_1 : representacion_pista
        Port map (  clock => clock_est,                            -- sysclk reloj del sistema 125 MHz
                    reset => reset_est,                            -- SW0 reset del sistema
                    columna => columnas,                     -- Numero actual de columna px
                    fila => filas,                       -- Numero actual de fila px
                    pintar_pista => pintar_pista_est);
    
    UUT_2 : SYNC_VGA
        Port map(   clk1 => clock_est,              -- Reloj 25 MHz
                    reset => reset_est,             -- Reset SW0
                    hsync => hsync_est,             -- Sincronizacion horizontal
                    vsync => vsync_est,             -- Sincronizacion vertical
                    visible => visible_est,         -- Zona visible de la pantalla
                    fila_actual => columnas,        -- Fila pixel actual
                    columna_actual => filas);       -- Columna pixel actual
              
    clock_est <= not clock_est after PERIOD/2;      
end Behavioral;
