----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.12.2023 10:18:57
-- Design Name: 
-- Module Name: divisor_32bits - Behavioral
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

entity divisor_32bits is
    Port (  dout : IN STD_LOGIC_VECTOR (32 - 1 downto 0);   -- Datos ROM
            Sel : IN STD_LOGIC_VECTOR (5 - 1 downto 0);     -- Seleccion multiplexor    
            clock : IN STD_LOGIC;                           -- Reloj del sistema
            reset : IN STD_LOGIC;                           -- Reset del sistema SW0
            Q : OUT STD_LOGIC);                             -- Representacion bit a bit
end divisor_32bits;

architecture Behavioral of divisor_32bits is
    signal dout_bit0, dout_bit1, dout_bit2, dout_bit3, dout_bit4, dout_bit5, dout_bit6, dout_bit7, dout_bit8, dout_bit9, dout_bit10, dout_bit11, dout_bit12, dout_bit13, dout_bit14, dout_bit15 : STD_LOGIC;
    signal dout_bit16, dout_bit17, dout_bit18, dout_bit19, dout_bit20, dout_bit21, dout_bit22, dout_bit23, dout_bit24, dout_bit25, dout_bit26, dout_bit27, dout_bit28, dout_bit29, dout_bit30, dout_bit31 : STD_LOGIC;
begin
    division_dout: process (clock)
    begin
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
        dout_bit16 <= dout(16);
        dout_bit17 <= dout(17);
        dout_bit18 <= dout(18);
        dout_bit19 <= dout(19);
        dout_bit20 <= dout(20);
        dout_bit21 <= dout(21);
        dout_bit22 <= dout(22);
        dout_bit23 <= dout(23);
        dout_bit24 <= dout(24);
        dout_bit25 <= dout(25);
        dout_bit26 <= dout(26);
        dout_bit27 <= dout(27);
        dout_bit28 <= dout(28);
        dout_bit29 <= dout(29);
        dout_bit30 <= dout(30);
        dout_bit31 <= dout(31);
            
        if clock'event and clock = '1' then
            case Sel is
                when "00000" => Q <= dout_bit0;
                when "00001" => Q <= dout_bit1;
                when "00010" => Q <= dout_bit2;
                when "00011" => Q <= dout_bit3;
                when "00100" => Q <= dout_bit4;
                when "00101" => Q <= dout_bit5;
                when "00110" => Q <= dout_bit6;
                when "00111" => Q <= dout_bit7;
                when "01000" => Q <= dout_bit8;
                when "01001" => Q <= dout_bit9;
                when "01010" => Q <= dout_bit10;
                when "01011" => Q <= dout_bit11;
                when "01100" => Q <= dout_bit12;
                when "01101" => Q <= dout_bit13;
                when "01110" => Q <= dout_bit14;
                when "01111" => Q <= dout_bit15;
                when "10000" => Q <= dout_bit16;
                when "10001" => Q <= dout_bit17;
                when "10010" => Q <= dout_bit18;
                when "10011" => Q <= dout_bit19;
                when "10100" => Q <= dout_bit20;
                when "10101" => Q <= dout_bit21;
                when "10110" => Q <= dout_bit22;
                when "10111" => Q <= dout_bit23;
                when "11000" => Q <= dout_bit24;
                when "11001" => Q <= dout_bit25;
                when "11010" => Q <= dout_bit26;
                when "11011" => Q <= dout_bit27;
                when "11100" => Q <= dout_bit28;
                when "11101" => Q <= dout_bit29;
                when "11110" => Q <= dout_bit30;
                when others  => Q <= dout_bit31;
            end case;
        end if;
    end process;

end Behavioral;
