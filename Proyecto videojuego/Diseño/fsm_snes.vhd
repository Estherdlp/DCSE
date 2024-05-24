----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.12.2023 18:46:55
-- Design Name: 
-- Module Name: fsm_snes - Behavioral
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

entity fsm_snes is
    Port (  clock : IN STD_LOGIC;                           -- sysclk reloj del sistema 125 MHz
            reset : IN STD_LOGIC;                           -- BTN0 reset del sistema
            fin_cuenta_12us : IN STD_LOGIC;                 -- Fin cuenta 12us
            fin_cuenta_6us : IN STD_LOGIC;                  -- Fin cuenta 6us
            finClocks : IN STD_LOGIC;                       -- 16 ciclos S2 - S3
            start : IN STD_LOGIC;                           -- Pulso para comenzar lectura mando
            enable_countClocks : OUT STD_LOGIC;             -- Enable contador de ciclos
            latch : OUT STD_LOGIC;                          -- Pulso inicio
            clock_fsm : OUT STD_LOGIC;                      -- Reloj para mando
            pre_finish : OUT STD_LOGIC);                    -- La maquina de estados se encuentra en el estado 4     
end fsm_snes;

architecture Behavioral of fsm_snes is
    type estados_fsm is (estado_0, estado_1, estado_2, estado_3, estado_4); -- Estados de maquina de estados
    signal e_act, e_sig : estados_fsm := estado_0;                          -- Estado inicial: espera

begin

    p_secuencial: process (reset, clock)                            -- Transicion de estados
    begin
        if reset = '1' then                                         -- Si reset, volver a estado inicial
            e_act <= estado_0;
        elsif clock'event and clock = '1' then                      -- Si pulso de reloj, transicion de estados
            e_act <= e_sig;
        end if;
    end process;
    
    
    p_com: process (start, fin_cuenta_12us, fin_cuenta_6us)
    begin
        e_sig <= e_act;
        case e_act is
            when estado_0 =>    -- Cambio a estado siguiente si han pasado 12 us en estado 0
                if start = '1' then
                    e_sig <= estado_1;
                end if;                                                       
            when estado_1 =>    -- Cambio a estado siguiente si han pasado 12 us en estado 1
                if fin_cuenta_12us = '1' then
                    e_sig <= estado_2;
                end if;                   
            when estado_2 =>    -- Cambio a estado siguiente si han pasado 6 us en estado 2
                if fin_cuenta_6us = '1' then
                    e_sig <= estado_3;
                end if;                           
            when estado_3 =>      
                if fin_cuenta_6us = '1' and finClocks = '0' then    -- Cambio a estado anterior si han pasado 6 us pero no 16 transiciones S2-S3
                    e_sig <= estado_2;
                elsif fin_cuenta_6us = '1' and finClocks = '1' then -- Cambio a estado siguiente si han pasado 6 us y 16 transiciones S2-S3
                    e_sig <= estado_4;
                end if;    
            when estado_4 =>    -- Cambio a estado inicial si han pasado 12 us en estado 4
                if fin_cuenta_12us = '1' then
                    e_sig <= estado_0;
                end if;                
        end case;
    end process;

    enable_countClocks <= '1' when e_act = estado_2 or e_act = estado_3 else '0';   -- Señal que habilita conteo transiciones S2-S3
    pre_finish <= '1' when e_act = estado_4 else '0';                               -- Señal que indica que FSM esta en estado 4
    latch <= '1' when e_act = estado_1 else '0';                                    -- Señal para indicar al mando que mande sus estados
    clock_fsm <= '0' when e_act = estado_3 else '1';                                -- Reloj para sincronizar con el mando el envio de sus estados
    
end Behavioral;
