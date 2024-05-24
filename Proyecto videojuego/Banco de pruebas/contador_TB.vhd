----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.12.2023 15:12:16
-- Design Name: 
-- Module Name: contador_TB - Behavioral
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

entity contador_TB is
--  Port ( );
end contador_TB;

architecture Behavioral of contador_TB is
    component contador is
        Generic ( num_bits : integer := 27;                     -- Numero de bits necesarios para almacenar el valor de cuenta
                  valor_fin_cuenta : integer := 120000000);     -- Valor fin de cuenta del contador
        Port (    reset : IN STD_LOGIC;                         -- Reset del sistema BTN0
                  clock : IN STD_LOGIC;                         -- Entrada reloj del sistema
                  enable : IN STD_LOGIC;                        -- Habilitacion contador
                  ascendente_descendente : IN STD_LOGIC;        -- Interruptor para cuenta ascendente o descendente
                  precarga : IN UNSIGNED (num_bits - 1 downto 0) := (others => '0');  -- Valor inicial de cuenta
                  fin_cuenta : OUT STD_LOGIC;                   -- Señal fin de cuenta
                  valor_cuenta_actual : out STD_LOGIC_VECTOR (num_bits - 1 downto 0));  -- Valor actual de cuenta
    end component;
    
    signal clock_est : STD_LOGIC := '0';
    signal reset_est : STD_LOGIC := '0';
    signal enable_est : STD_LOGIC := '0';
    signal cuenta12_est : STD_LOGIC := '0';
    signal ascendente_descendente_est : STD_LOGIC := '0';
    signal precarga_est : unsigned (4 - 1 downto 0) := "0100";
    signal valor_cuenta_actual_est : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
    constant PERIOD : time := 20ns;
begin
    UUT: contador
        generic map (num_bits => 4, valor_fin_cuenta => 12)
        port map (reset => reset_est,
                  clock => clock_est,
                  enable => enable_est,
                  ascendente_descendente => ascendente_descendente_est,
                  precarga => precarga_est,
                  fin_cuenta => cuenta12_est,
                  valor_cuenta_actual => valor_cuenta_actual_est);
        
            
    clock_est <= not clock_est after PERIOD/2;
    reset_est <= '0', '1' after 100 ns, '0' after 400 ns;
    enable_est <= '0', '1' after 50 ns, '0' after 150 ns, '1' after 250 ns;
    ascendente_descendente_est <= '0', '1' after 500 ns, '0' after 900 ns, '1' after 1040 ns;

end Behavioral;
