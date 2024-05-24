----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.11.2023 23:44:27
-- Design Name: 
-- Module Name: divisor_16bits - Behavioral
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

entity divisor_16bits is
    Port (  dout : IN STD_LOGIC_VECTOR (16 - 1 downto 0);   -- Datos ROM
            sel_divisor : IN STD_LOGIC_VECTOR (4 - 1 downto 0);     -- Seleccion multiplexor    
            clock : IN STD_LOGIC;                           -- Reloj del sistema
            reset : IN STD_LOGIC;                           -- Reset del sistema BTN0
            buttons_snes : IN STD_LOGIC_VECTOR (12 DOWNTO 0);   -- Vector estado botones mando
            salida : OUT STD_LOGIC);                             -- Representacion bit a bit
end divisor_16bits;

architecture Behavioral of divisor_16bits is
    signal dout_bit0, dout_bit1, dout_bit2, dout_bit3, dout_bit4, dout_bit5, dout_bit6, dout_bit7, dout_bit8, dout_bit9, dout_bit10, dout_bit11, dout_bit12, dout_bit13, dout_bit14, dout_bit15 : STD_LOGIC;
    signal estado : STD_LOGIC := '0';
    
begin

    division_dout: process (sel_divisor, dout, clock)
    begin
        -- Separacion en bits de la salida de la memoria ROM
        if buttons_snes(6) = '0' or buttons_snes(4) = '0' then
            estado <= '1';
            dout_bit0  <= dout(0);
            dout_bit1  <= dout(1);
            dout_bit2  <= dout(2);
            dout_bit3  <= dout(3);
            dout_bit4  <= dout(4);
            dout_bit5  <= dout(5);
            dout_bit6  <= dout(6);
            dout_bit7  <= dout(7);
            dout_bit8  <= dout(8);
            dout_bit9  <= dout(9);
            dout_bit10 <= dout(10);
            dout_bit11 <= dout(11);
            dout_bit12 <= dout(12);
            dout_bit13 <= dout(13);
            dout_bit14 <= dout(14);
            dout_bit15 <= dout(15);
        elsif buttons_snes(7) = '0' or buttons_snes(5) = '0' or reset = '1' then
            estado <= '0';
            dout_bit0  <= dout(15);
            dout_bit1  <= dout(14);
            dout_bit2  <= dout(13);
            dout_bit3  <= dout(12);
            dout_bit4  <= dout(11);
            dout_bit5  <= dout(10);
            dout_bit6  <= dout(9);
            dout_bit7  <= dout(8);
            dout_bit8  <= dout(7);
            dout_bit9  <= dout(6);
            dout_bit10 <= dout(5);
            dout_bit11 <= dout(4);
            dout_bit12 <= dout(3);
            dout_bit13 <= dout(2);
            dout_bit14 <= dout(1);
            dout_bit15 <= dout(0);
        else
            if estado = '1' then
                dout_bit0  <= dout(0);
                dout_bit1  <= dout(1);
                dout_bit2  <= dout(2);
                dout_bit3  <= dout(3);
                dout_bit4  <= dout(4);
                dout_bit5  <= dout(5);
                dout_bit6  <= dout(6);
                dout_bit7  <= dout(7);
                dout_bit8  <= dout(8);
                dout_bit9  <= dout(9);
                dout_bit10 <= dout(10);
                dout_bit11 <= dout(11);
                dout_bit12 <= dout(12);
                dout_bit13 <= dout(13);
                dout_bit14 <= dout(14);
                dout_bit15 <= dout(15);
            else
                dout_bit0  <= dout(15);
                dout_bit1  <= dout(14);
                dout_bit2  <= dout(13);
                dout_bit3  <= dout(12);
                dout_bit4  <= dout(11);
                dout_bit5  <= dout(10);
                dout_bit6  <= dout(9);
                dout_bit7  <= dout(8);
                dout_bit8  <= dout(7);
                dout_bit9  <= dout(6);
                dout_bit10 <= dout(5);
                dout_bit11 <= dout(4);
                dout_bit12 <= dout(3);
                dout_bit13 <= dout(2);
                dout_bit14 <= dout(1);
                dout_bit15 <= dout(0);
            end if;
        end if;
        
        -- Multiplexor 16 a 1
        if clock'event and clock = '1' then
            case sel_divisor is
                when "0000" => salida <= dout_bit0;
                when "0001" => salida <= dout_bit1;
                when "0010" => salida <= dout_bit2;
                when "0011" => salida <= dout_bit3;
                when "0100" => salida <= dout_bit4;
                when "0101" => salida <= dout_bit5;
                when "0110" => salida <= dout_bit6;
                when "0111" => salida <= dout_bit7;
                when "1000" => salida <= dout_bit8;
                when "1001" => salida <= dout_bit9;
                when "1010" => salida <= dout_bit10;
                when "1011" => salida <= dout_bit11;
                when "1100" => salida <= dout_bit12;
                when "1101" => salida <= dout_bit13;
                when "1110" => salida <= dout_bit14;
                when "1111" => salida <= dout_bit15;
                when others => salida <= '0';
            end case;
        end if;
    end process;

end Behavioral;
