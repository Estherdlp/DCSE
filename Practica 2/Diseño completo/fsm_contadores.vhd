----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.11.2023 17:42:52
-- Design Name: 
-- Module Name: fsm_contadores - Behavioral
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

entity fsm_contadores is

    Port (  reset : IN STD_LOGIC;                                   -- Reset del sistema
            clock : IN STD_LOGIC;                                   -- Reloj del sistema
            enable : IN STD_LOGIC;                              -- Fin cuenta timer 500 ms
            fila_final : IN STD_LOGIC;                              -- Alcanzado fin max/min filas    
            columna_final : IN STD_LOGIC;                           -- Alcanzado fin max/min columnas  
            ascendente_descendente_fila : OUT STD_LOGIC;            -- Fila++ si = 0. Fila -- si = 1.
            enable_fila : OUT STD_LOGIC;                            -- Enable para contador de filas
            ascendente_descendente_columna : OUT STD_LOGIC;         -- Columna++ si = 0. Columna -- si = 1.
            enable_columna : OUT STD_LOGIC);                        -- Enable para contador de columnas                    
            
end fsm_contadores;

architecture Behavioral of fsm_contadores is

    type estados_fsm is (derecha, baja, izquierda, sube);           -- Estados de maquina de estados
    signal e_act, e_sig : estados_fsm := derecha;                   -- Estado inicial: derecha.

begin

    p_secuencial: process (reset, clock)                            -- Transicion de estados
    begin
        if reset = '1' then                                         -- Si reset, volver a estado inicial
            e_act <= derecha;
        elsif clock'event and clock = '1' then                      -- Si pulso de reloj, transicion de estados
            e_act <= e_sig;
        end if;
    end process;
    
    p_com: process (enable, columna_final, fila_final)
    begin
        case e_act is
            when derecha =>                                         -- En estado derecha: contador de columnas ascendente 
                e_sig <= derecha;
                enable_columna <= '1';
                enable_fila <= '0';                                 -- Poner a 0 por el primer ciclo tras reset
                ascendente_descendente_fila <= '0';                 -- Poner a 0 por el primer ciclo tras reset
                ascendente_descendente_columna <= '0';              -- Ascendente columnas                                
                if columna_final = '1' then                 
                    e_sig <= baja;
                    enable_columna <= '0';
                    enable_fila <= '1';
                else
                    e_sig <= derecha;
                end if;
            when baja =>
                e_sig <= baja;
                ascendente_descendente_fila <= '0';             -- Ascendente filas                          
                if fila_final = '1' then                            
                    e_sig <= izquierda;
                    enable_columna <= '1';
                    enable_fila <= '0';
                    ascendente_descendente_columna <= '1';              -- Ascendente columnas
                else
                    enable_fila <= '1';             
                end if;
            when izquierda =>                                       -- En estado izquierda: contador de columnas descendente
                ascendente_descendente_columna <= '1';              -- Descendente columnas
                e_sig <= izquierda;                             
                if columna_final = '1' then                   
                    e_sig <= sube;
                    enable_columna <= '0';
                    enable_fila <= '1';
                    ascendente_descendente_fila <= '1';              -- Descendente columnas
                else
                    enable_columna <= '1';             
                end if;
            when sube =>                                            -- En estado sube: contador de filas descendente  
                e_sig <= sube;
                ascendente_descendente_fila <= '1';             -- Descendente filas                                 
                if fila_final = '1' then          
                    e_sig <= derecha;
                    enable_columna <= '1';
                    enable_fila <= '0';
                    ascendente_descendente_columna <= '0';
                else
                    enable_fila <= '1';             
                end if;
        end case;
    end process;
    
end Behavioral;
