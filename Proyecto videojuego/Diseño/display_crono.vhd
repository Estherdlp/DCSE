----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.12.2023 17:06:19
-- Design Name: 
-- Module Name: display_crono - Behavioral
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

entity display_crono is
    Generic ( num_bits : integer := 27);                     -- Numero de bits necesarios para almacenar el valor de cuenta
    Port (  reset : IN STD_LOGIC;                           -- Reset del sistema BTN0
            clock : IN STD_LOGIC;                           -- Entrada reloj del sistema
            columna : IN STD_LOGIC_VECTOR (10 - 1 downto 0);-- Numero actual de columna px
            fila : IN STD_LOGIC_VECTOR (10 - 1 downto 0);   -- Numero actual de fila px
            valor_cuenta_actual : IN STD_LOGIC_VECTOR (num_bits - 1 downto 0);
            pintar_crono_seg : OUT STD_LOGIC);              -- Salida minutos
end display_crono;

architecture Behavioral of display_crono is
    component cabecera_rom is
        Generic ( num_bits : integer := 27);                                        -- Numero de bits necesarios para almacenar el valor de cuenta
        Port (  valor_cuenta_actual : IN STD_LOGIC_VECTOR (num_bits - 1 downto 0);  -- Valor actual de cuenta
                cabecera : OUT STD_LOGIC_VECTOR (5 - 1 downto 0) := "00000"); -- Cabecera ROM minutos);
    end component;
    
    component ROM1b_1f_blue_num32_play_sprite16x16 is
        port (  clk  : in  std_logic;   -- reloj
                addr : in  std_logic_vector(9 - 1 downto 0);
                dout : out std_logic_vector(16 - 1 downto 0));
    end component;
    
    -- Separador del vector de bits de la ROM en bits individuales  
    component divisor_16bits is
        Port (  dout : IN STD_LOGIC_VECTOR (16 - 1 downto 0);           -- Datos ROM
                sel_divisor : IN STD_LOGIC_VECTOR (4 - 1 downto 0);     -- Seleccion multiplexor    
                clock : IN STD_LOGIC;                                   -- Reloj del sistema
                reset : IN STD_LOGIC;                                   -- Reset del sistema BTN0
                buttons_snes : IN STD_LOGIC_VECTOR (12 DOWNTO 0);       -- Vector estado botones mando
                salida : OUT STD_LOGIC);                                -- Representacion bit a bit
    end component;
    
    signal cabecera : STD_LOGIC_VECTOR (5 - 1 downto 0) := (others => '0');
    signal direccion :  STD_LOGIC_VECTOR (9 - 1 downto 0);        -- Direccion ROM segundos
    signal salida_rom : STD_LOGIC_VECTOR (16 - 1 downto 0); -- Salida ROM segundos
    signal buttons_snes : STD_LOGIC_VECTOR (12 DOWNTO 0) := (others => '1');   -- Vector estado botones mando
    
begin
    ----------------- DISPLAY SEGUNDOS -----------------
    u0: cabecera_rom
        Generic map ( num_bits => 4)                                -- Numero de bits necesarios para almacenar el valor de cuenta
        Port map (  valor_cuenta_actual => valor_cuenta_actual,     -- Valor actual de cuenta
                    cabecera => cabecera);                  -- Cabecera ROM segundos);
    
    direccion <= cabecera & fila(4 - 1 downto 0);
    
    u1: ROM1b_1f_blue_num32_play_sprite16x16
        Port map (  clk  => clock,          -- reloj
                    addr => direccion,
                    dout => salida_rom);
                    
    -- Division bit a bit de los colores del cronometro                                               
    u2: divisor_16bits
        Port map (  dout => salida_rom,                 -- Datos ROM                     
                    sel_divisor => columna(4 - 1 downto 0),     -- Seleccion multiplexor         
                    clock => clock,                             -- Reloj del sistema             
                    reset => reset,                             -- Reset del sistema BTN0
                    buttons_snes => buttons_snes,               -- Vector estado botones mando          
                    salida => pintar_crono_seg);                -- Representacion bit a bit  
end Behavioral;
