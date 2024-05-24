----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.12.2023 18:39:18
-- Design Name: 
-- Module Name: registro_desplazamiento - Behavioral
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

entity registro_desplazamiento is
    Port (  clock_fsm : IN STD_LOGIC;                       -- Reloj para mando
            pre_finish : IN STD_LOGIC;                      -- FSM en estado 4
            data_snes : IN STD_LOGIC;                       -- Estado botones mando
            buttons_snes : OUT STD_LOGIC_VECTOR (12 DOWNTO 0)); -- Vector estado botones mando   
end registro_desplazamiento;

architecture Behavioral of registro_desplazamiento is

    signal buttons_temp : STD_LOGIC_VECTOR (15 DOWNTO 0) := (others => '0');   -- Registro de desplazamiento mando
    signal buttons_snes_signal : STD_LOGIC_VECTOR (12 DOWNTO 0) := (others => '0');
    
begin

    volcado: process(pre_finish)    -- Una vez terminados los ciclos de lectura, volcar como salida los 12 botones del mando
    begin
        if pre_finish'event and pre_finish = '1' then
            buttons_snes_signal <= buttons_temp(12 downto 0);
        end if;
    end process;
       
    registro: process(clock_fsm)    -- Añadir al registro de desplazamiento cada uno de los botones del mando en cada estado 3
    begin
        if clock_fsm = '0' and clock_fsm'event then
            buttons_temp(15 downto 0) <= data_snes & buttons_temp(15 downto 1);
        end if;
    end process;
    
    buttons_snes <= buttons_snes_signal;
    
end Behavioral;
