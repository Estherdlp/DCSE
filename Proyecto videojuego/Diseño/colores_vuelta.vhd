----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.12.2023 19:12:43
-- Design Name: 
-- Module Name: colores_vuelta - Behavioral
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

entity colores_vuelta is
    Port (  color_pista : IN STD_LOGIC_VECTOR (23 downto 0);
            pintar_crono_seg : IN STD_LOGIC;                -- Salida segundos
            pintar_crono_dec : IN STD_LOGIC;                -- Salida decenas segundo
            pintar_crono_min : IN STD_LOGIC;                -- Salida minutos
            pintar_crono_puntos : IN STD_LOGIC;             -- Salida :
            pintar_crono_L : IN STD_LOGIC;                 -- Salida L
            pintar_crono_A : IN STD_LOGIC;                 -- Salida A
            pintar_crono_P : IN STD_LOGIC;                 -- Salida P
            pintar_crono_vuelta : IN STD_LOGIC;            -- Salida num vuelta
            color_crono_seg : OUT STD_LOGIC_VECTOR (23 downto 0);       -- Colores del cronometro
            color_crono_dec : OUT STD_LOGIC_VECTOR (23 downto 0);       -- Colores del cronometro
            color_crono_min : OUT STD_LOGIC_VECTOR (23 downto 0);       -- Colores del cronometro
            color_crono_puntos : OUT STD_LOGIC_VECTOR (23 downto 0);    -- Colores del cronometro
            color_crono_L : OUT STD_LOGIC_VECTOR (23 downto 0);         -- Colores L
            color_crono_A : OUT STD_LOGIC_VECTOR (23 downto 0);         -- Colores A
            color_crono_P : OUT STD_LOGIC_VECTOR (23 downto 0);        -- Colores P
            color_crono_vuelta : OUT STD_LOGIC_VECTOR (23 downto 0));           -- Salida num vuelta
end colores_vuelta;

architecture Behavioral of colores_vuelta is
    component colores_cronometro is
        Generic ( num_bits_bus : integer := 16);            -- Numero de bits del bus de datos
        Port ( Color_1 : in STD_LOGIC_VECTOR (num_bits_bus - 1 downto 0); -- Entrada 0 multiplexor 4 bits      
               Color_2 : in STD_LOGIC_VECTOR (num_bits_bus - 1 downto 0); -- Entrada 1 multiplexor 4 bits  
               Seleccion_color : in STD_LOGIC;                      -- Seleccion entrada multiplexor 
               Salida_color : out STD_LOGIC_VECTOR (num_bits_bus - 1 downto 0));-- Salida multiplexor 4 bits 
    end component;
    
    signal negro : STD_LOGIC_VECTOR (23 downto 0) := (others => '0');
    
begin
    -- Salida color cronometro segundos            
    u0: colores_cronometro
        Generic map ( num_bits_bus => 24)                       -- Numero de bits del bus de datos
        Port map (  Color_1 => negro,                           -- Entrada 0 multiplexor      
                    Color_2 => color_pista,                     -- Entrada 1 multiplexor 
                    Seleccion_color => pintar_crono_seg,        -- Seleccion entrada multiplexor 
                    Salida_color => color_crono_seg);               -- Salida multiplexor                
   
    -- Salida color cronometro decenas de segundo           
    u1: colores_cronometro
        Generic map ( num_bits_bus => 24)                       -- Numero de bits del bus de datos
        Port map (  Color_1 => negro,                           -- Entrada 0 multiplexor      
                    Color_2 => color_pista,                     -- Entrada 1 multiplexor 
                    Seleccion_color => pintar_crono_dec,        -- Seleccion entrada multiplexor 
                    Salida_color => color_crono_dec);               -- Salida multiplexor  
                    
    -- Salida color cronometro minutos           
    u2: colores_cronometro
        Generic map ( num_bits_bus => 24)                       -- Numero de bits del bus de datos
        Port map (  Color_1 => negro,                           -- Entrada 0 multiplexor      
                    Color_2 => color_pista,                     -- Entrada 1 multiplexor 
                    Seleccion_color => pintar_crono_min,        -- Seleccion entrada multiplexor 
                    Salida_color => color_crono_min);               -- Salida multiplexor  
     
    -- Salida color cronometro :           
    u3: colores_cronometro
        Generic map ( num_bits_bus => 24)                       -- Numero de bits del bus de datos
        Port map (  Color_1 => negro,                           -- Entrada 0 multiplexor      
                    Color_2 => color_pista,                     -- Entrada 1 multiplexor 
                    Seleccion_color => pintar_crono_puntos,     -- Seleccion entrada multiplexor 
                    Salida_color => color_crono_puntos);        -- Salida multiplexor
                    
    -- Salida color cronometro L           
    u4: colores_cronometro
        Generic map ( num_bits_bus => 24)                       -- Numero de bits del bus de datos
        Port map (  Color_1 => negro,                           -- Entrada 0 multiplexor      
                    Color_2 => color_pista,                     -- Entrada 1 multiplexor 
                    Seleccion_color => pintar_crono_L,     -- Seleccion entrada multiplexor 
                    Salida_color => color_crono_L);        -- Salida multiplexor
    -- Salida color cronometro A           
    u5: colores_cronometro
        Generic map ( num_bits_bus => 24)                       -- Numero de bits del bus de datos
        Port map (  Color_1 => negro,                           -- Entrada 0 multiplexor      
                    Color_2 => color_pista,                     -- Entrada 1 multiplexor 
                    Seleccion_color => pintar_crono_A,     -- Seleccion entrada multiplexor 
                    Salida_color => color_crono_A);        -- Salida multiplexor    
    -- Salida color cronometro P           
    u6: colores_cronometro
        Generic map ( num_bits_bus => 24)                       -- Numero de bits del bus de datos
        Port map (  Color_1 => negro,                           -- Entrada 0 multiplexor      
                    Color_2 => color_pista,                     -- Entrada 1 multiplexor 
                    Seleccion_color => pintar_crono_P,     -- Seleccion entrada multiplexor 
                    Salida_color => color_crono_P);        -- Salida multiplexor
    -- Salida color numero vuelta         
    u7: colores_cronometro
        Generic map ( num_bits_bus => 24)                       -- Numero de bits del bus de datos
        Port map (  Color_1 => negro,                           -- Entrada 0 multiplexor      
                    Color_2 => color_pista,                     -- Entrada 1 multiplexor 
                    Seleccion_color => pintar_crono_vuelta,     -- Seleccion entrada multiplexor 
                    Salida_color => color_crono_vuelta);        -- Salida multiplexor               

end Behavioral;
