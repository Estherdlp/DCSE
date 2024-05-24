----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.11.2023 17:42:48
-- Design Name: 
-- Module Name: fsm_velocidades - Behavioral
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

entity fsm_velocidades is    
    Port ( reset : IN STD_LOGIC;                                            -- Reset del sistema BTN0                                 
           clock : IN STD_LOGIC;                                            -- Reloj del sistema
           BTNU : IN STD_LOGIC;                                             -- BTNU cambio de velocidad
           S500milis : IN STD_LOGIC;
           S20milis : IN STD_LOGIC;
           S10milis : IN STD_LOGIC;
           velocidad_fsm : OUT STD_LOGIC);
end fsm_velocidades;

architecture Behavioral of fsm_velocidades is
    type estados_led is (velocidad_1, velocidad_2, velocidad_3);  -- Estados de maquina de estados
    signal e_act, e_sig : estados_led := velocidad_1;              -- Estado inicial: sin parpadeos. Transicion entre estados
    signal estado_reg1 : STD_LOGIC := '0';                          -- Detector de flancos 1
    signal estado_reg2 : STD_LOGIC := '0';                          -- Detector de flancos 2
    signal flanco : STD_LOGIC := '1';                               -- Flanco detectado
    signal salida_seleccionada_signal : STD_LOGIC := S500milis;
    
begin
    p_secuencial: process (reset, clock)
    begin
        if reset = '1' then                                         -- Si reset, volver a estado inicial
            e_act <= velocidad_1;
            estado_reg1 <= '0';
            estado_reg2 <= '0';
        elsif clock'event and clock = '1' then                      -- Si pulso de reloj, transicion de estados y de detector de flancos
            e_act <= e_sig;
            estado_reg1 <= BTNU;
            estado_reg2 <= estado_reg1;
        end if;
    end process;
    
    flanco <= '1' when estado_reg1 = '1' and estado_reg2 = '0' else '0';    -- Flanco detectado
    
    p_com: process (e_act, flanco, S500milis, S20milis, S10milis)
    begin
        case e_act is
            when velocidad_1 =>                             
                if flanco = '1' then                                
                    e_sig <= velocidad_2;
                else
                    e_sig <= velocidad_1;                    
                end if;
            when velocidad_2 =>             
                if flanco = '1' then                                
                    e_sig <= velocidad_3;
                else
                    e_sig <= velocidad_2;                    
                end if;
            when velocidad_3 =>                               
                if flanco = '1' then                                
                    e_sig <= velocidad_1;
                else
                    e_sig <= velocidad_3;                    
                end if;
        end case;
    end process;
    
    salida_seleccionada_signal <=  S500milis when e_act = velocidad_1 else
                                   S20milis when e_act = velocidad_2 else
                                   S10milis when e_act = velocidad_3
                                   else '0';
                                   
    velocidad_fsm <= salida_seleccionada_signal;
    
end Behavioral;
