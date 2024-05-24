----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.10.2023 23:02:07
-- Design Name: 
-- Module Name: contador_cascada_2_TB - Behavioral
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

entity contador_cascada_2_TB is
--  Port ( );
end contador_cascada_2_TB;

architecture Behavioral of contador_cascada_2_TB is
    component contador
        Generic ( num_bits : integer := 4;            -- Este valor se vera modificado en el main
                  valor_fin_cuenta : integer := 10);    -- Este valor se vera modificado en el main
        Port(     reset : IN STD_LOGIC;
                  clock : IN STD_LOGIC;
                  enable : IN STD_LOGIC;
                  ascendente_descendente : IN STD_LOGIC;-- Interruptor para cuenta ascendente o descendente
                  fin_cuenta : OUT STD_LOGIC;
                  valor_cuenta_actual : out STD_LOGIC_VECTOR (num_bits - 1 downto 0));
    end component;

    signal clock_est : STD_LOGIC := '0';
    signal reset_est : STD_LOGIC := '0';
    signal enable_est : STD_LOGIC := '0';
    signal cuenta2_est : STD_LOGIC := '0';
    signal valor_cuenta2_actual_est : STD_LOGIC_VECTOR (1 downto 0) := (others => '0');
    signal cuenta14_est : STD_LOGIC := '0';
    signal valor_cuenta14_actual_est : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
    signal ascendente_descendente_est : STD_LOGIC := '0';
    constant PERIOD : time := 10ns;

begin
    UUT_1: contador
    generic map (num_bits => 2, valor_fin_cuenta => 2)
    port map (reset => reset_est,
              clock => clock_est,
              enable => enable_est,
              ascendente_descendente => ascendente_descendente_est,
              fin_cuenta => cuenta2_est,
              valor_cuenta_actual => valor_cuenta2_actual_est);
    UUT_2: contador
    generic map (num_bits => 4, valor_fin_cuenta => 14)
    port map (reset => reset_est,
              clock => clock_est,
              enable => cuenta2_est,
              ascendente_descendente => ascendente_descendente_est,
              fin_cuenta => cuenta14_est,
              valor_cuenta_actual => valor_cuenta14_actual_est);         
            
            
    clock_est <= not clock_est after PERIOD/2;
    reset_est <= '0', '1' after 100 ns, '0' after 200 ns, '1' after 420 ns, '0' after 440 ns;
    enable_est <= '1','0' after 100 ns, '1' after 250 ns;

end Behavioral;
