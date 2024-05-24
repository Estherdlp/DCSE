----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.12.2023 21:59:33
-- Design Name: 
-- Module Name: sel_mux_personaje - Behavioral
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

entity sel_mux_personaje is
    Port (  reset : IN STD_LOGIC;                                           -- BTN0 reset del sistema
            columna : IN STD_LOGIC_VECTOR (10 - 1 downto 0);                -- Numero actual de columna px
            fila : IN STD_LOGIC_VECTOR (10 - 1 downto 0);                   -- Numero actual de fila px
            buttons_snes : IN STD_LOGIC_VECTOR (12 DOWNTO 0);               -- Vector estado botones mando
            sel_divisor_personaje : OUT STD_LOGIC_VECTOR (4 - 1 downto 0);  -- Selector multiplexor pixel a pixel fondo/personaje 
            direccion_personaje : OUT STD_LOGIC_VECTOR (8 - 1 downto 0));   -- Direccion ROM personaje
end sel_mux_personaje;

architecture Behavioral of sel_mux_personaje is
    -- Señales intermedias acceso memoria personajes del juego
    signal personaje : STD_LOGIC_VECTOR (4 - 1 downto 0) := "0011";         -- Cabecera ROM personaje
    -- Señales intermedias para la orientacion del personaje
    signal estado : STD_LOGIC := '0';                                       -- Mantener orientacion
    
begin
    -- Calculo del selector del multiplexor para mostrar el personaje girado
    sel_mux: Process (buttons_snes, reset)
    begin
        -- Si el personaje se desplaza en vertical, invertir la lectura de la ROM
        if buttons_snes(5) = '0' or buttons_snes(4) = '0' then
            direccion_personaje <= personaje & columna (4 - 1 downto 0);
            sel_divisor_personaje <= fila(4 - 1 downto 0);
            estado <= '1';          -- Estado para mantener el comecocos arriba/abajo si se deja de pulsar
        -- Si el personaje se desplaza en horizontal, lectura normal de ROM
        elsif buttons_snes(7) = '0' or buttons_snes(6) = '0' or reset = '1' then
            direccion_personaje <= personaje & fila (4 - 1 downto 0);
            sel_divisor_personaje <= columna(4 - 1 downto 0);
            estado <= '0';          -- Estado para mantener el comecocos izquierda/derecha si se deja de pulsar
        -- Mantener la orientacion del personaje si no se pulsa ningun boton
        elsif estado = '0' then
            direccion_personaje <= personaje & fila (4 - 1 downto 0);
            sel_divisor_personaje <= columna(4 - 1 downto 0); 
        else
            direccion_personaje <= personaje & columna (4 - 1 downto 0);
            sel_divisor_personaje <= fila(4 - 1 downto 0);   
        end if;
    end process;		 
end Behavioral;
