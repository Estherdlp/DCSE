----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.10.2023 23:56:00
-- Design Name: 
-- Module Name: start_stop - Behavioral
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

entity start_stop is
    Port ( reset : IN STD_LOGIC;                 -- Entrada de reset
           clock : IN STD_LOGIC;                 -- Entrada de reloj
           boton : IN STD_LOGIC;                 -- Entrada de habilitacion
           enable_sistema : OUT STD_LOGIC);      -- Pulso timer por cuenta 500 ms

end start_stop;

architecture Behavioral of start_stop is

    type estados_cuenta is (cuenta_on, cuenta_off);
    signal e_act, e_sig : estados_cuenta := cuenta_on; 
    signal enable_sistema_signal : STD_LOGIC;
    signal boton_reg1 : STD_LOGIC := '0';       -- Detector de flancos 1    
    signal boton_reg2 : STD_LOGIC := '0';       -- Detector de flancos 2 
    signal flanco : STD_LOGIC := '1';           -- Flanco detectado     
    
begin
    p_secuencial: process (reset, clock)
    begin
        if reset = '1' then                     -- Si reset, volver a estado inicial
            e_act <= cuenta_on;
            boton_reg1 <= '0';
            boton_reg1 <= '0';
        elsif clock'event and clock = '1' then  -- Si pulso de reloj, transicion de estados y de detector de flancos     
            e_act <= e_sig;
            boton_reg1 <= boton;
            boton_reg2 <= boton_reg1;
        end if;
    end process;
    
    flanco <= '1' when boton_reg1 = '1' and boton_reg2 = '0' else '0';  -- Flanco detectado
    
    p_com: process (e_act, flanco)
    begin
        case e_act is
            when cuenta_on =>                       -- Estado cuenta_on: si hay flanco, en el siguiente pulso de reloj, deshabilitar el sistema
                if flanco = '1' then
                    enable_sistema_signal <= '0';
                    e_sig <= cuenta_off;
                else
                    e_sig <= cuenta_on;
                    enable_sistema_signal <= '1';
                end if;
            when cuenta_off =>                      -- Estado cuenta_off: si hay flanco, en el siguiente pulso de reloj, habilitar el sistema
                if flanco = '1' then
                    enable_sistema_signal <= '1';
                    e_sig <= cuenta_on;
                 else
                    e_sig <= cuenta_off;
                    enable_sistema_signal <= '0';
                end if;
        end case;
    end process;
    
    -- Salida habilitacion del sistema
    enable_sistema <= enable_sistema_signal;

end Behavioral;
