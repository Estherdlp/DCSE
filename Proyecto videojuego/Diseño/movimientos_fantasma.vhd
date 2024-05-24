----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.11.2023 23:59:34
-- Design Name: 
-- Module Name: movimientos_fantasma - Behavioral
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
use WORK.RACETRACK_PKG.ALL;  

entity movimientos_fantasma is
    Port (  reset : IN STD_LOGIC;                                   -- Reset del sistema
            clock : IN STD_LOGIC;                                   -- Reloj del sistema
            fin_cuenta : IN STD_LOGIC;                              -- Fin cuenta timer movimiento
            col_fantasma : IN STD_LOGIC_VECTOR (6 - 1 DOWNTO 0);    -- Columna actual personaje
            fila_fantasma : IN STD_LOGIC_VECTOR (6 - 1 DOWNTO 0);   -- Fila actual personaje
            ascendente_descendente_fila : OUT STD_LOGIC;            -- Fila++ si = 0. Fila -- si = 1.
            enable_fila : OUT STD_LOGIC;                            -- Enable para contador de filas
            ascendente_descendente_columna : OUT STD_LOGIC;         -- Columna++ si = 0. Columna -- si = 1.
            enable_columna : OUT STD_LOGIC);                        -- Enable para contador de columnas   
end movimientos_fantasma;

architecture Behavioral of movimientos_fantasma is
    type estados_fsm is (derecha, arriba, izquierda, abajo);           -- Estados de maquina de estados
    signal e_sig, e_act : estados_fsm := derecha;
    
    -- Analisis borde de pista
    signal borde_de_pista_derecho : STD_LOGIC;
    signal borde_de_pista_derecho_2 : STD_LOGIC;
    signal borde_de_pista_derecho_3 : STD_LOGIC;
    signal borde_de_pista_superior : STD_LOGIC;
    signal borde_de_pista_superior_2 : STD_LOGIC;
    signal borde_de_pista_superior_3 : STD_LOGIC;
    signal borde_de_pista_izquierda : STD_LOGIC;
    signal borde_de_pista_izquierda_2 : STD_LOGIC;
    signal borde_de_pista_izquierda_3 : STD_LOGIC;
    signal borde_de_pista_inferior : STD_LOGIC;
    signal borde_de_pista_inferior_2 : STD_LOGIC;
    signal borde_de_pista_inferior_3 : STD_LOGIC;
    signal borde_de_pista_inferior_4 : STD_LOGIC;
begin

    borde_de_pista_derecho <= pista(to_integer(unsigned(fila_fantasma)))(to_integer(unsigned(col_fantasma) + 1));
    borde_de_pista_derecho_2 <= pista(to_integer(unsigned(fila_fantasma)))(to_integer(unsigned(col_fantasma) + 2));
    borde_de_pista_derecho_3 <= pista(to_integer(unsigned(fila_fantasma)))(to_integer(unsigned(col_fantasma) + 3));
    borde_de_pista_superior <= pista(to_integer(unsigned(fila_fantasma) - 1))(to_integer(unsigned(col_fantasma)));
    borde_de_pista_superior_2 <= pista(to_integer(unsigned(fila_fantasma) - 2))(to_integer(unsigned(col_fantasma)));
    borde_de_pista_superior_3 <= pista(to_integer(unsigned(fila_fantasma) - 3))(to_integer(unsigned(col_fantasma)));
    borde_de_pista_izquierda <= pista(to_integer(unsigned(fila_fantasma)))(to_integer(unsigned(col_fantasma) - 1));
    borde_de_pista_izquierda_2 <= pista(to_integer(unsigned(fila_fantasma)))(to_integer(unsigned(col_fantasma) - 2));
    borde_de_pista_izquierda_3 <= pista(to_integer(unsigned(fila_fantasma)))(to_integer(unsigned(col_fantasma) - 3));
    borde_de_pista_inferior <= pista(to_integer(unsigned(fila_fantasma) + 1))(to_integer(unsigned(col_fantasma)));
    borde_de_pista_inferior_2 <= pista(to_integer(unsigned(fila_fantasma) + 2))(to_integer(unsigned(col_fantasma)));
    borde_de_pista_inferior_3 <= pista(to_integer(unsigned(fila_fantasma) + 3))(to_integer(unsigned(col_fantasma)));
    borde_de_pista_inferior_4 <= pista(to_integer(unsigned(fila_fantasma) + 4))(to_integer(unsigned(col_fantasma)));
    
    p_secuencial: process (reset, clock)
    begin
        if reset = '1' then                                         -- Si reset, volver a estado inicial
            e_act <= derecha;
        elsif clock'event and clock = '1' then                      -- Si pulso de reloj, transicion de estados y de detector de flancos
            e_act <= e_sig;
        end if;
    end process;
      
    p_com: process (col_fantasma, fila_fantasma, fin_cuenta, e_act)
    begin
        e_sig <= e_act;  
        case e_act is                                      
            when derecha =>
                if borde_de_pista_derecho = '0' and borde_de_pista_inferior = '0' then
                    e_sig <= arriba;
                elsif borde_de_pista_superior = '0' and borde_de_pista_derecho = '0' then
                    e_sig <= izquierda;
                elsif borde_de_pista_inferior = '1' and borde_de_pista_inferior_2 = '0' and (borde_de_pista_izquierda_2 = '0' or borde_de_pista_izquierda_3 = '0') then
                    e_sig <= abajo;
                elsif borde_de_pista_inferior = '1' and borde_de_pista_superior_3 = '0' and borde_de_pista_derecho_3 = '0' and borde_de_pista_inferior_3 = '1' then
                    e_sig <= abajo;    
                end if;
                
            when arriba =>
                if borde_de_pista_derecho = '1' and borde_de_pista_superior = '1' and borde_de_pista_izquierda = '1' and borde_de_pista_superior_2 = '1' then
                    e_sig <= derecha;
                elsif borde_de_pista_derecho = '0' and borde_de_pista_superior = '0' then
                    e_sig <= izquierda;
                end if;    
                                        
            when izquierda =>
                if borde_de_pista_derecho = '1' and borde_de_pista_superior = '1' and borde_de_pista_izquierda = '1' and borde_de_pista_inferior = '1' and borde_de_pista_superior_2 = '0' and borde_de_pista_izquierda_2 = '1' and borde_de_pista_inferior_4 = '1'  then
                    e_sig <= arriba;
                elsif borde_de_pista_izquierda = '0' and borde_de_pista_superior = '0' then
                    e_sig <= abajo;   
                end if;
                      
            when abajo =>
                if borde_de_pista_izquierda = '1' and borde_de_pista_superior = '1' and borde_de_pista_izquierda_2 = '0' and borde_de_pista_inferior_2 = '1' then
                    e_sig <= izquierda;
                elsif borde_de_pista_izquierda = '0' and borde_de_pista_inferior = '0' then
                    e_sig <= derecha;
                elsif borde_de_pista_izquierda = '1' and borde_de_pista_superior = '1' and borde_de_pista_derecho = '1' and borde_de_pista_inferior = '1' and borde_de_pista_superior_2 = '0' and borde_de_pista_inferior_4 = '0' then
                    e_sig <= izquierda;
                elsif borde_de_pista_inferior = '1' and borde_de_pista_superior_3 = '1' and borde_de_pista_derecho_3 = '0' and borde_de_pista_inferior_3 = '0' then
                    e_sig <= izquierda;
                end if;
        end case;
    end process;
          
    ascendente_descendente_columna <= '1' when e_act = izquierda else
                                      '0' when e_act = derecha;
    ascendente_descendente_fila <=  '1' when e_act = arriba else
                                    '0' when e_act = abajo;
    enable_fila <= '1' when (e_act = arriba or e_act = abajo) and fin_cuenta = '1' else '0';
    enable_columna <= '1' when (e_act = izquierda or e_act = derecha) and fin_cuenta = '1' else '0';
    
end Behavioral;
