----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.11.2023 16:46:33
-- Design Name: 
-- Module Name: movimientos_personaje - Behavioral
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

entity movimientos_personaje is
    Port (  reset : IN STD_LOGIC;                               -- Reset del sistema
            clock : IN STD_LOGIC;                               -- Reloj del sistema
            fin_cuenta : IN STD_LOGIC;                          -- Fin cuenta timer 100-500 ms
            fila_final : IN STD_LOGIC;                          -- Alcanzado fin max/min filas    
            columna_final : IN STD_LOGIC;                       -- Alcanzado fin max/min columnas
            buttons_snes : IN STD_LOGIC_VECTOR (12 DOWNTO 0);   -- Vector estado botones mando  
            ascendente_descendente_fila : OUT STD_LOGIC;        -- Fila++ si = 0. Fila -- si = 1
            enable_fila : OUT STD_LOGIC;                        -- Enable para contador de filas
            ascendente_descendente_columna : OUT STD_LOGIC;     -- Columna++ si = 0. Columna -- si = 1
            enable_columna : OUT STD_LOGIC);                    -- Enable para contador de columnas                    
end movimientos_personaje;

architecture Behavioral of movimientos_personaje is
    
begin
    
    process (fin_cuenta, columna_final, fila_final)
    begin
        enable_fila <= '0';
        enable_columna <= '0';
        
        -- Arriba derecha
        if buttons_snes(4) = '0' and buttons_snes(7) = '0' then
            if fin_cuenta = '1' then                           
                ascendente_descendente_columna <= '0';
                ascendente_descendente_fila <= '1';
                if columna_final = '1' or fila_final = '1' then
                    enable_columna <= '0';
                    enable_fila <= '0';
                else                                                     
                    enable_columna <= '1';
                    enable_fila <= '1';  
                end if;
            end if;
        -- Arriba izquierda   
        elsif buttons_snes(4) = '0' and buttons_snes(6) = '0' then
            if fin_cuenta = '1' then                           
                ascendente_descendente_columna <= '1';
                ascendente_descendente_fila <= '1';
                if columna_final = '1' or fila_final = '1' then
                    enable_columna <= '0';
                    enable_fila <= '0';
                else                                                     
                    enable_columna <= '1';
                    enable_fila <= '1';  
                end if;
            end if;
        -- Abajo izquierda   
        elsif buttons_snes(5) = '0' and buttons_snes(6) = '0' then
            if fin_cuenta = '1' then                           
                ascendente_descendente_columna <= '1';
                ascendente_descendente_fila <= '0';
                if columna_final = '1' or fila_final = '1' then
                    enable_columna <= '0';
                    enable_fila <= '0';
                else                                                     
                    enable_columna <= '1';
                    enable_fila <= '1';  
                end if;
            end if;
        elsif buttons_snes(5) = '0' and buttons_snes(7) = '0' then
            if fin_cuenta = '1' then                           
                ascendente_descendente_columna <= '0';
                ascendente_descendente_fila <= '0';
                if columna_final = '1' or fila_final = '1' then
                    enable_columna <= '0';
                    enable_fila <= '0';
                else                                                     
                    enable_columna <= '1';
                    enable_fila <= '1';  
                end if;
            end if;
        elsif buttons_snes(7) = '0' then       -- Derecha
            if fin_cuenta = '1' then                           
                ascendente_descendente_columna <= '0';
                if columna_final = '1' then
                    enable_columna <= '0';
                else                                                     
                    enable_columna <= '1';  
                end if;
            end if;
        elsif buttons_snes(6) = '0' then    -- Izquierda
            if fin_cuenta = '1' then                           
                ascendente_descendente_columna <= '1';
                if columna_final = '1' then
                    enable_columna <= '0';
                else                 
                    enable_columna <= '1';
                end if;
            end if;
        elsif buttons_snes(5) = '0' then    -- Abajo
            if fin_cuenta = '1' then
                ascendente_descendente_fila <= '0';                           
                if fila_final = '1' then
                    enable_fila <= '0';
                else
                    enable_fila <= '1';                                 
                end if;
            end if;
        elsif buttons_snes(4) = '0' then    -- Arriba
            if fin_cuenta = '1' then                           
                ascendente_descendente_fila <= '1';
                if fila_final = '1' then
                    enable_fila <= '0';
                else
                    enable_fila <= '1';                                                   
                end if;
            end if;
        else
            enable_fila <= '0';                                 
            ascendente_descendente_fila <= '0';                 
            enable_columna <= '0';
            ascendente_descendente_columna <= '0';   
        end if;
    end process;
end Behavioral;
