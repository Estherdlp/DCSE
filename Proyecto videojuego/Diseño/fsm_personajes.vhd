----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.11.2023 21:13:11
-- Design Name: 
-- Module Name: fsm_personajes - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fsm_personajes is
    Port (  reset : IN STD_LOGIC;                           -- Reset del sistema BTN0
            clock : IN STD_LOGIC;                           -- Entrada reloj del sistema
            buttons_snes : IN STD_LOGIC_VECTOR (12 DOWNTO 0);   -- Vector estado botones mando 
            dificultad : IN STD_LOGIC_VECTOR (1 downto 0);   -- Interruptores para la dificultad
            filas_personaje : OUT STD_LOGIC_VECTOR (6 - 1 DOWNTO 0);    -- Posicion actual fila personaje
            columnas_personaje : OUT STD_LOGIC_VECTOR (6 - 1 DOWNTO 0); -- Posicion actual columna personaje
            filas_fantasma: OUT STD_LOGIC_VECTOR (6 - 1 DOWNTO 0);      -- Posicion actual fila fantasma
            columnas_fantasma : OUT STD_LOGIC_VECTOR (6 - 1 DOWNTO 0)); -- Posicion actual columna fantasma          
end fsm_personajes;

architecture Behavioral of fsm_personajes is
     
    component fsm_jugador is
        Port (  reset : IN STD_LOGIC;                           -- Reset del sistema BTN0
                clock : IN STD_LOGIC;                           -- Entrada reloj del sistema
                buttons_snes : IN STD_LOGIC_VECTOR (12 DOWNTO 0);       -- Vector estado botones mando
                filas_personaje : OUT STD_LOGIC_VECTOR (6 - 1 DOWNTO 0);-- Fila actual personaje
                columnas_personaje : OUT STD_LOGIC_VECTOR (6 - 1 DOWNTO 0));    -- Columna actual personaje
    end component;
    
    component fsm_fantasma is
        Port (  reset : IN STD_LOGIC;                                       -- Reset del sistema BTN0
                clock : IN STD_LOGIC;                                       -- Entrada reloj del sistema
                dificultad : IN STD_LOGIC_VECTOR (1 downto 0);   -- Interruptores para la dificultad
                filas_fantasma : OUT STD_LOGIC_VECTOR (6 - 1 DOWNTO 0);     -- Fila actual fantasma
                columnas_fantasma : OUT STD_LOGIC_VECTOR (6 - 1 DOWNTO 0)); -- Columna actual fantasma
    end component;
begin

    u0: fsm_jugador
        Port map (  reset => reset,                             -- Reset del sistema BTN0
                    clock => clock,                             -- Entrada reloj del sistema
                    buttons_snes => buttons_snes,               -- Vector estado botones mando
                    filas_personaje => filas_personaje,         -- Fila actual personaje
                    columnas_personaje => columnas_personaje);  -- Columna actual personaje  
                    
    u1: fsm_fantasma
        Port map (  reset => reset,                             -- Reset del sistema BTN0
                    clock => clock,                             -- Entrada reloj del sistema
                    dificultad => dificultad,                   -- Interruptor para la dificultad
                    filas_fantasma => filas_fantasma,         -- Fila actual fantasma
                    columnas_fantasma => columnas_fantasma);  -- Columna actual fantasma               

end Behavioral;
