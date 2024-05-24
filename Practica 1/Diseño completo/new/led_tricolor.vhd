----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.10.2023 20:44:35
-- Design Name: 
-- Module Name: led_tricolor - Behavioral
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

entity led_tricolor is
    Port ( reset : IN STD_LOGIC;                 -- Reset del sistema BTN0                                 
           clock : IN STD_LOGIC;                 -- Reloj del sistema    
           enable : IN STD_LOGIC;                -- Entrada de habilitacion 
           cambio_estado : IN STD_LOGIC;         -- Cambio de estado ON/OFF cada 500 ms
           salida_led_tricolor : OUT STD_LOGIC_VECTOR (2 downto 0)); -- Array para led RGB
end led_tricolor;

architecture Behavioral of led_tricolor is
    
    type estados_led is (sin_parpadeo, parpadeo_on, parpadeo_off);  -- Estados de maquina de estados
    signal e_act, e_sig : estados_led := sin_parpadeo;              -- Estado inicial: sin parpadeos. Transicion entre estados
    signal salida_led_tricolor_signal: STD_LOGIC_VECTOR (2 downto 0); -- Señal intermedia led RGB
    signal estado_reg1 : STD_LOGIC := '0';                          -- Detector de flancos 1
    signal estado_reg2 : STD_LOGIC := '0';                          -- Detector de flancos 2
    signal flanco : STD_LOGIC := '1';                               -- Flanco detectado
    
begin

    p_secuencial: process (reset, clock)
    begin
        if reset = '1' then                                         -- Si reset, volver a estado inicial
            e_act <= sin_parpadeo;
            estado_reg1 <= '0';
            estado_reg2 <= '0';
        elsif clock'event and clock = '1' then                      -- Si pulso de reloj, transicion de estados y de detector de flancos
            e_act <= e_sig;
            estado_reg1 <= cambio_estado;
            estado_reg2 <= estado_reg1;
        end if;
    end process;
    
    flanco <= '1' when estado_reg1 = '1' and estado_reg2 = '0' else '0';    -- Flanco detectado
    
    p_com: process (e_act, enable, flanco)
    begin
        case e_act is
            when sin_parpadeo =>                                    -- Estado sin_parpadeo: led rojo encendido
                salida_led_tricolor_signal <= "001";
                if enable = '1' then                                -- Si cambio de estado, encender led
                    e_sig <= parpadeo_on;
                else
                    e_sig <= sin_parpadeo;                    
                end if;
            when parpadeo_on =>                                     -- Estado parpadeo_on: led verde encendido
                salida_led_tricolor_signal <= "010";
                if enable = '0' then                                -- Si deshabilitacion, estado sin_parpadeo
                    e_sig <= sin_parpadeo;
                elsif flanco = '1' then                             -- Si transcurridos 500 ms, apagar led
                    e_sig <= parpadeo_off;
                else
                    e_sig <= parpadeo_on;
                end if;
            when parpadeo_off =>                                    -- Estado parpadeo_off: led apagado
                salida_led_tricolor_signal <= "000";
                if enable = '0' then                                -- Si deshabilitacion, estado sin_parpadeo
                    e_sig <= sin_parpadeo;
                elsif flanco = '1' then                             -- Si transcurridos 500 ms, encender led
                    e_sig <= parpadeo_on;                   
                else
                    e_sig <= parpadeo_off;                    
                end if;
        end case;
    end process;
     
    -- Salida del led tricolor
    salida_led_tricolor <= salida_led_tricolor_signal;
    
end Behavioral;
