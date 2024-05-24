----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.10.2023 23:09:49
-- Design Name: 
-- Module Name: contador_cascada_3_TB - Behavioral
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

entity contador_cascada_3_TB is
end contador_cascada_3_TB;

architecture Behavioral of contador_cascada_3_TB is
    component contador
        Generic ( num_bits : integer := 4;              -- Este valor se vera modificado en el main
                  valor_fin_cuenta : integer := 10);    -- Este valor se vera modificado en el main
        Port(     reset : IN STD_LOGIC;
                  clock : IN STD_LOGIC;
                  enable : IN STD_LOGIC;
                  ascendente_descendente : IN STD_LOGIC;-- Interruptor para cuenta ascendente o descendente
                  fin_cuenta : OUT STD_LOGIC;
                  valor_cuenta_actual : out STD_LOGIC_VECTOR (num_bits - 1 downto 0));
    end component;
    
    component and2 is
        Port ( in_0 : in STD_LOGIC;
               in_1 : in STD_LOGIC;
               out_0 : out STD_LOGIC);
    end component;

    signal clock_est : STD_LOGIC := '0';
    signal reset_est : STD_LOGIC := '0';
    signal enable_est : STD_LOGIC := '0';
    signal and_est : STD_LOGIC;
    signal cuenta2_est : STD_LOGIC := '0';
    signal valor_cuenta2_actual_est : STD_LOGIC_VECTOR (1 downto 0) := (others => '0');
    signal cuenta4_est : STD_LOGIC := '0';
    signal valor_cuenta4_actual_est : STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
    signal cuenta6_est : STD_LOGIC := '0';
    signal valor_cuenta6_actual_est : STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
    constant PERIOD : time := 10ns;
    signal ascendente_descendente_est : STD_LOGIC := '0';

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
    generic map (num_bits => 3, valor_fin_cuenta => 4)
    port map (reset => reset_est,
              clock => clock_est,
              enable => cuenta2_est,
              ascendente_descendente => ascendente_descendente_est,
              fin_cuenta => cuenta4_est,
              valor_cuenta_actual => valor_cuenta4_actual_est);    
    UUT_3: and2
    port map (in_0 => cuenta2_est,
              in_1 => cuenta4_est,
              out_0 => and_est);
    
    UUT_4: contador
    generic map (num_bits => 3, valor_fin_cuenta => 6)
    port map (reset => reset_est,
              clock => clock_est,
              enable => and_est,
              ascendente_descendente => ascendente_descendente_est,
              fin_cuenta => cuenta6_est,
              valor_cuenta_actual => valor_cuenta6_actual_est);       
            
            
    clock_est <= not clock_est after PERIOD/2;
    reset_est <= '0', '1' after 100 ns, '0' after 200 ns, '1' after 420 ns, '0' after 440 ns;
    enable_est <= '1','0' after 100 ns, '1' after 250 ns;

end Behavioral;
