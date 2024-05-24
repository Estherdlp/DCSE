----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.12.2023 17:51:45
-- Design Name: 
-- Module Name: control_cuadricula - Behavioral
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

entity control_cuadricula is
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
            color_crono_vuelta : IN STD_LOGIC_VECTOR (23 downto 0);-- Colores del cronometro
            columna : IN STD_LOGIC_VECTOR (10 - 1 downto 0);        -- Numero actual de columna px
            fila : IN STD_LOGIC_VECTOR (10 - 1 downto 0);           -- Numero actual de fila px
            col_personaje : IN STD_LOGIC_VECTOR (6 - 1 DOWNTO 0);   -- Columna actual personaje
            fila_personaje : IN STD_LOGIC_VECTOR (6 - 1 DOWNTO 0);  -- Fila actual personaje
            col_fantasma : IN STD_LOGIC_VECTOR (6 - 1 DOWNTO 0);    -- Columna actual fantasma
            fila_fantasma : IN STD_LOGIC_VECTOR (6 - 1 DOWNTO 0);   -- Fila actual fantasma
            vdata_RGB : OUT STD_LOGIC_VECTOR (23 downto 0));        -- Bus colores RGB
end control_cuadricula;

architecture Behavioral of control_cuadricula is
    signal col_uns : unsigned (10 - 1 downto 0);
    signal Seleccion_color_cuadricula : STD_LOGIC_VECTOR (4 - 1 downto 0);
    signal gris : STD_LOGIC_VECTOR (23 downto 0) := "100000001000000010000000";
    signal col_crono_mins : STD_LOGIC_VECTOR (6 - 1 DOWNTO 0) := "000001";      -- Columna min crono
    signal col_crono_puntos: STD_LOGIC_VECTOR (6 - 1 DOWNTO 0) := "000010";     -- Columna : crono
    signal col_crono_dec : STD_LOGIC_VECTOR (6 - 1 DOWNTO 0) := "000011";       -- Columna dec crono
    signal col_crono_seg: STD_LOGIC_VECTOR (6 - 1 DOWNTO 0) := "000100";        -- Columna seg crono
    signal fila_crono : STD_LOGIC_VECTOR (6 - 1 DOWNTO 0) := "000001";          -- Fila crono
    signal fila_lap : STD_LOGIC_VECTOR (6 - 1 DOWNTO 0) := "000010";            -- Fila LAP
begin
    col_uns <= unsigned(columna);
    p_pinta: Process (col_personaje, fila_personaje, col_fantasma, fila_fantasma, columna, fila)
    begin
        if col_personaje = columna(10 - 1 downto 4) and fila_personaje = fila(10 - 1 downto 4) then     -- Personaje manual
            Seleccion_color_cuadricula <= "0000";
        elsif col_fantasma = columna(10 - 1 downto 4) and fila_fantasma = fila(10 - 1 downto 4) then    -- Fantasma
            Seleccion_color_cuadricula <= "0001";
        elsif col_uns > 512 then                                                                        -- Gris del margen
            Seleccion_color_cuadricula <= "0010";
        elsif col_crono_mins = columna(10 - 1 downto 4) and fila_crono = fila(10 - 1 downto 4) then     -- Minutos
            Seleccion_color_cuadricula <= "0011";
        elsif col_crono_dec = columna(10 - 1 downto 4) and fila_crono = fila(10 - 1 downto 4) then      -- Decenas de segundo
            Seleccion_color_cuadricula <= "0100";
        elsif col_crono_seg = columna(10 - 1 downto 4) and fila_crono = fila(10 - 1 downto 4) then      -- Segundos
            Seleccion_color_cuadricula <= "0101";
        elsif col_crono_puntos = columna(10 - 1 downto 4) and fila_crono = fila(10 - 1 downto 4) then   -- :
            Seleccion_color_cuadricula <= "0110";
        elsif col_crono_mins = columna(10 - 1 downto 4) and fila_lap = fila(10 - 1 downto 4) then       -- L
            Seleccion_color_cuadricula <= "0111";    
        elsif col_crono_puntos = columna(10 - 1 downto 4) and fila_lap = fila(10 - 1 downto 4) then     -- A
            Seleccion_color_cuadricula <= "1000";
        elsif col_crono_dec = columna(10 - 1 downto 4) and fila_lap = fila(10 - 1 downto 4) then        -- P
            Seleccion_color_cuadricula <= "1001";
        elsif col_crono_seg = columna(10 - 1 downto 4) and fila_lap = fila(10 - 1 downto 4) then        -- Num vuelta
            Seleccion_color_cuadricula <= "1010";              
        else
            Seleccion_color_cuadricula <= "1111";
        end if;
    end process;

    vdata_RGB <= color_personaje when Seleccion_color_cuadricula = "0000" else
                 color_fantasma when Seleccion_color_cuadricula = "0001" else
                 gris when Seleccion_color_cuadricula = "0010" else
                 color_crono_min when Seleccion_color_cuadricula = "0011" else
                 color_crono_dec when Seleccion_color_cuadricula = "0100" else
                 color_crono_seg when Seleccion_color_cuadricula = "0101" else
                 color_crono_puntos when Seleccion_color_cuadricula = "0110" else
                 color_crono_L when Seleccion_color_cuadricula = "0111" else
                 color_crono_A when Seleccion_color_cuadricula = "1000" else
                 color_crono_P when Seleccion_color_cuadricula = "1001" else
                 color_crono_vuelta when Seleccion_color_cuadricula = "1010" else
                 color_pista;
end Behavioral;
