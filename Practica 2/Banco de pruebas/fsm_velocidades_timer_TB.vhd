----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.11.2023 19:25:50
-- Design Name: 
-- Module Name: fsm_velocidades_timer_TB - Behavioral
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

entity fsm_velocidades_timer_TB is
end fsm_velocidades_timer_TB;

architecture Behavioral of fsm_velocidades_timer_TB is
    component fsm_velocidades is    
        Port ( reset : IN STD_LOGIC;                                            -- Reset del sistema BTN0                                 
               clock : IN STD_LOGIC;                                            -- Reloj del sistema
               BTNU : IN STD_LOGIC;                                             -- BTNU cambio de velocidad
               S500milis : IN STD_LOGIC;
               S20milis : IN STD_LOGIC;
               S10milis : IN STD_LOGIC;
               velocidad_fsm : OUT STD_LOGIC);
    end component;
    
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
    signal BTNU_est : STD_LOGIC := '0';
    signal S500milis_est : STD_LOGIC := '0'; 
    signal S20milis_est : STD_LOGIC := '0';                               -- Salida timer 200 ms
    signal S10milis_est : STD_LOGIC := '0';                               -- Salida timer 100 ms
    signal velocidad_fsm_est : STD_LOGIC := '0';
    
    signal enable_est : STD_LOGIC := '1';
    signal ascendente_descendente_est : STD_LOGIC := '0';
    constant PERIOD : time := 20ns;
    
begin

    UUT_1: contador
        generic map (num_bits => 4, valor_fin_cuenta => 10)
        port map (  reset => reset_est,
                    clock => clock_est,
                    enable => enable_est,
                    ascendente_descendente => ascendente_descendente_est,
                    fin_cuenta => S500milis_est,
                    valor_cuenta_actual => open);
                  
    UUT_2: contador
        generic map (num_bits => 4, valor_fin_cuenta => 15)
        port map (  reset => reset_est,
                    clock => clock_est,
                    enable => enable_est,
                    ascendente_descendente => ascendente_descendente_est,
                    fin_cuenta => S20milis_est,
                    valor_cuenta_actual => open);
                  
    UUT_3: contador
        generic map (num_bits => 3, valor_fin_cuenta => 7)
        port map (  reset => reset_est,
                    clock => clock_est,
                    enable => enable_est,
                    ascendente_descendente => ascendente_descendente_est,
                    fin_cuenta => S10milis_est,
                    valor_cuenta_actual => open);
                  
    UUT_4: fsm_velocidades
        port map (  reset => reset_est,                                            -- Reset del sistema BTN0                                 
                    clock => clock_est,                                            -- Reloj del sistema
                    BTNU => BTNU_est,                                              -- BTNU cambio de velocidad
                    S500milis => S500milis_est,                                    
                    S20milis => S20milis_est,
                    S10milis => S10milis_est,
                    velocidad_fsm => velocidad_fsm_est);
                    
                    
    clock_est <= not clock_est after PERIOD/2;
    --reset_est <= '1', '0' after 100 ns;
    
    BTNU_est <= '0', '1' after 50 ns, '0' after 230 ns, '1' after 500 ns, '0' after 530 ns, '1' after 800 ns, '0' after 830 ns, '1' after 900 ns, '0' after 1000 ns;


end Behavioral;
