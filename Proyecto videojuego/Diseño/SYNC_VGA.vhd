----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.11.2023 12:15:56
-- Design Name: 
-- Module Name: SYNC_VGA - Behavioral
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

entity SYNC_VGA is
    Port (  clk1 : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            hsync : OUT STD_LOGIC;
            vsync : OUT STD_LOGIC;
            visible : OUT STD_LOGIC;
            fila_actual : out STD_LOGIC_VECTOR (10 - 1 downto 0);
            columna_actual : out STD_LOGIC_VECTOR (10 - 1 downto 0));
end SYNC_VGA;

architecture Behavioral of SYNC_VGA is

    component contador is
        Generic ( num_bits : integer := 10;                     -- Numero de bits necesarios para almacenar el valor de cuenta
                  valor_fin_cuenta : integer := 800);           -- Valor fin de cuenta del contador
        Port (    reset : IN STD_LOGIC;                         -- Reset del sistema BTN0
                  clock : IN STD_LOGIC;                         -- Entrada reloj del sistema
                  enable : IN STD_LOGIC;                        -- Habilitacion contador
                  ascendente_descendente : IN STD_LOGIC;        -- Interruptor para cuenta ascendente o descendente
                  precarga : IN UNSIGNED (num_bits - 1 downto 0) := (others => '0');  -- Valor inicial de cuenta
                  fin_cuenta : OUT STD_LOGIC;                   -- Señal fin de cuenta
                  valor_cuenta_actual : out STD_LOGIC_VECTOR (num_bits - 1 downto 0));  -- Valor actual de cuenta
    end component;
                    
    signal enable_columnas : STD_LOGIC := '1';
    signal ad_columnas : STD_LOGIC := '0';
    signal ad_filas : STD_LOGIC := '0';
    signal fin_cuenta_columnas : STD_LOGIC;
    signal valor_actual_columnas : STD_LOGIC_VECTOR (10 - 1 downto 0);
    signal fin_cuenta_filas : STD_LOGIC;
    signal valor_actual_filas : STD_LOGIC_VECTOR (10 - 1 downto 0);
    signal valor_actual_columnas_uns : unsigned (10 - 1 downto 0) := (others => '0');
    signal valor_actual_filas_uns : unsigned (10 - 1 downto 0) := (others => '0');
    signal visible_columnas : STD_LOGIC;
    signal visible_filas : STD_LOGIC;
    signal precarga : unsigned (10 - 1 downto 0) := (others => '0'); 

begin
    --Contador de columnas de px
    u0: contador 
        generic map ( num_bits => 10,                                   -- Numero de bits necesarios para almacenar el valor de cuenta
                      valor_fin_cuenta => 800)                          -- Valor fin de cuenta del contador
        port map ( reset => reset,                                      -- Reset del sistema BTN0
                   clock => clk1,                                       -- Reloj del sistema                              
                   enable =>  enable_columnas,                          -- Habilitacion contador
                   ascendente_descendente => ad_columnas,               -- Cuenta ascendente o descendente
                   precarga => precarga,                                -- Precarga 0
                   fin_cuenta => fin_cuenta_columnas,                   -- Señal fin de cuenta
                   valor_cuenta_actual => valor_actual_columnas);       -- Valor actual px columna
                   
    --Contador de filas de px
    u1: contador
        generic map ( num_bits => 10,                                   -- Numero de bits necesarios para almacenar el valor de cuenta
                      valor_fin_cuenta => 525)                          -- Valor fin de cuenta del contador
        port map ( reset => reset,                                      -- Reset del sistema BTN0
                   clock => clk1,                                       -- Reloj del sistema                              
                   enable =>  fin_cuenta_columnas,                      -- Habilitacion contador
                   ascendente_descendente => ad_filas,                  -- Cuenta ascendente o descendente
                   precarga => precarga,                                -- Precarga 0
                   fin_cuenta => fin_cuenta_filas,                      -- Señal fin de cuenta
                   valor_cuenta_actual => valor_actual_filas);          -- Valor actual px fila
    
    -- Cast para tratamiento de datos -> 1 en zona visible + porche delantero + porche trasero
    valor_actual_columnas_uns <= unsigned(valor_actual_columnas);
    valor_actual_filas_uns <= unsigned(valor_actual_filas);
    -- Señal de sincronizacion horizontal               
    hsync <= '1' when (valor_actual_columnas_uns < 639 + 16) else
            '1' when valor_actual_columnas_uns >= 639 + 16 + 96
            else '0';
    -- Señal de sincronizacion vertical -> 1 en zona visible + porche delantero + porche trasero      
    vsync <= '1' when (valor_actual_filas_uns < 479 + 10) else
            '1' when valor_actual_filas_uns >= 479 + 10 + 2
            else '0';
    -- Señal zona visible
    visible_columnas <= '1' when valor_actual_columnas_uns < 640 else '0';
    visible_filas <= '1' when valor_actual_filas_uns < 480 else '0';
    visible <= visible_columnas and visible_filas;
    -- Salida px actual
    columna_actual <= valor_actual_columnas;
    fila_actual <= valor_actual_filas;
    
end Behavioral;
