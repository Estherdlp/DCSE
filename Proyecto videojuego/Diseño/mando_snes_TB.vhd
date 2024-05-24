----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.12.2023 21:33:19
-- Design Name: 
-- Module Name: mando_snes_TB - Behavioral
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

entity mando_snes_TB is
end mando_snes_TB;

architecture Behavioral of mando_snes_TB is
    component mando_snes is
        Port (  clock : IN STD_LOGIC;                               -- sysclk reloj del sistema 125 MHz
                reset : IN STD_LOGIC;                               -- BTN0 reset del sistema
                data_snes : IN STD_LOGIC;                           -- Estado de cada boton del mando
                latch : OUT STD_LOGIC;                              -- Pulso inicio
                clock_fsm : OUT STD_LOGIC;                          -- Reloj para mando
                buttons_snes : OUT STD_LOGIC_VECTOR (13 - 1 DOWNTO 0)); -- Vector con estado de todos los botones
    end component;
    
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
    
    component fsm_snes is
        Port (  clock : IN STD_LOGIC;                           -- sysclk reloj del sistema 125 MHz
                reset : IN STD_LOGIC;                           -- BTN0 reset del sistema
                fin_cuenta_12us : IN STD_LOGIC;                 -- Fin cuenta 12us
                fin_cuenta_6us : IN STD_LOGIC;                  -- Fin cuenta 6us
                finClocks : IN STD_LOGIC;                       -- 16 ciclos S2 - S3
                start : IN STD_LOGIC;                           -- Pulso para comenzar lectura mando
                enable_countClocks : OUT STD_LOGIC;             -- Enable contador de ciclos
                latch : OUT STD_LOGIC;                          -- Pulso inicio
                clock_fsm : OUT STD_LOGIC;                      -- Reloj para mando
                pre_finish : OUT STD_LOGIC);                    -- La maquina de estados se encuentra en el estado 4     
    end component;
    
    component Counter_Clks is
        Port (  clock : IN STD_LOGIC;                           -- sysclk reloj del sistema 125 MHz
                reset : IN STD_LOGIC;                           -- SW0 reset del sistema
                enable_countClocks : IN STD_LOGIC;              -- Enable contador de ciclos
                fin_cuenta_12us : IN STD_LOGIC;                 -- Fin cuenta 12us
                fin_cuenta_6us : IN STD_LOGIC;                  -- Fin cuenta 6 us
                finClocks : OUT STD_LOGIC);                     -- Fin 14 pulsos                     
    end component;
    
    component registro_desplazamiento is
        Port (  clock_fsm : IN STD_LOGIC;                       -- Reloj para mando
                pre_finish : IN STD_LOGIC;                      -- FSM en estado 4
                data_snes : IN STD_LOGIC;                       -- Estado botones mando
                buttons_snes : OUT STD_LOGIC_VECTOR (13 - 1 DOWNTO 0)); -- Vector estado botones mando   
    end component;
    
    -- Estimulos temporizadores
    signal clock_est : STD_LOGIC := '0';                        -- Estimulo reloj
    signal reset_est : STD_LOGIC := '0';                        -- Estimulo reset
    signal enable_est : STD_LOGIC := '1';                       -- Habilitacion permanente
    signal ascendente_descendente_est : STD_LOGIC := '0';       -- Ascendente permanente
    constant PERIOD : time := 8ns;
    -- Señales intermedias muestreo pulsadores
    signal fin_cuenta_12us_est : STD_LOGIC;                     -- Fin cuenta 12us
    signal fin_cuenta_6us_est : STD_LOGIC;                      -- Fin cuenta 6 us
    signal start_est : STD_LOGIC := '1';                        -- Pulso para comenzar lectura mando
    signal enable_countClocks_est : STD_LOGIC := '0';           -- Enable contador de ciclos
    signal finClocks_est : STD_LOGIC := '0';                    -- Fin 14 pulsos
    -- Señales comunicacion mando
    signal latch_est : STD_LOGIC;                               -- Pulso inicio               
    signal clock_fsm_est : STD_LOGIC;                           -- Reloj para mando           
    signal pre_finish_est : STD_LOGIC := '0';                   -- La maquina de estados se encuentra en el estado 4
    signal data_snes_est : STD_LOGIC := '0';                           -- Estado de cada boton del mando
    signal buttons_snes_est : STD_LOGIC_VECTOR (13 - 1 DOWNTO 0);   -- Vector con estado de todos los botones
    
begin

    -- Mando
    UUT_0: mando_snes
        Port map (  clock => clock_est,                         -- sysclk reloj del sistema 125 MHz
                    reset => reset_est,                         -- SW0 reset del sistema
                    latch => latch_est,                         -- Pulso inicio
                    clock_fsm => clock_fsm_est,                 -- Reloj para mando
                    data_snes => data_snes_est,                 -- Estado de cada boton del mando                                
                    buttons_snes => buttons_snes_est);          -- Vector con estado de todos los botones         
    --Contador 12us
    UUT_1: contador 
        generic map ( num_bits => 11,                           -- Numero de bits necesarios para almacenar el valor de cuenta
                      valor_fin_cuenta => 1500)                 -- Valor fin de cuenta del contador
        port map ( reset => reset_est,                          -- Reset del sistema SW0
                   clock => clock_est,                          -- Reloj del sistema                              
                   enable => enable_est,                        -- Habilitacion contador
                   ascendente_descendente => ascendente_descendente_est,           -- Interruptor para cuenta ascendente o descendente
                   precarga => (others => '0'),
                   fin_cuenta => fin_cuenta_12us_est,               -- Señal fin de cuenta
                   valor_cuenta_actual => open);                -- Sin usar
                   
    --Contador 6us
    UUT_2: contador 
        generic map ( num_bits => 10,                           -- Numero de bits necesarios para almacenar el valor de cuenta
                      valor_fin_cuenta => 750)                  -- Valor fin de cuenta del contador
        port map ( reset => reset_est,                          -- Reset del sistema SW0
                   clock => clock_est,                          -- Reloj del sistema                              
                   enable => enable_est,                        -- Habilitacion contador
                   ascendente_descendente => ascendente_descendente_est, -- Interruptor para cuenta ascendente o descendente
                   precarga => (others => '0'),
                   fin_cuenta => fin_cuenta_6us_est,            -- Señal fin de cuenta
                   valor_cuenta_actual => open);                -- Sin usar   
                   
    --Contador 300 us - start
    UUT_3: contador 
        generic map ( num_bits => 15,                           -- Numero de bits necesarios para almacenar el valor de cuenta
                      valor_fin_cuenta => 30000)                -- Valor fin de cuenta del contador
        port map (  reset => reset_est,                         -- Reset del sistema SW0
                    clock => clock_est,                         -- Reloj del sistema                              
                    enable => enable_est,                       -- Habilitacion contador
                    ascendente_descendente => ascendente_descendente_est, -- Interruptor para cuenta ascendente o descendente
                    precarga => (others => '0'),
                    fin_cuenta => start_est,                    -- Señal fin de cuenta
                    valor_cuenta_actual => open);               -- Sin usar  
    
    -- Maquina de estados mando               
    UUT_4: fsm_snes
        Port map (  clock => clock_est,                         -- sysclk reloj del sistema 125 MHz
                    reset => reset_est,                         -- SW0 reset del sistema
                    fin_cuenta_12us => fin_cuenta_12us_est,     -- Fin cuenta 12us
                    fin_cuenta_6us => fin_cuenta_6us_est,       -- Fin cuenta 6us
                    finClocks => finClocks_est,                 -- 14 ciclos S2 - S3
                    start => start_est,                         -- Pulso para comenzar lectura mando
                    enable_countClocks => enable_countClocks_est,-- Enable contador de ciclos
                    latch => latch_est,                         -- Pulso inicio
                    clock_fsm => clock_fsm_est,                 -- Reloj para mando
                    pre_finish => pre_finish_est);              -- FSM en estado 4  

    -- Contador de pulsos del ciclo
    UUT_5: Counter_Clks
        Port map (  clock => clock_est,                         -- sysclk reloj del sistema 125 MHz
                    reset => reset_est,                         -- SW0 reset del sistema
                    enable_countClocks => enable_countClocks_est,-- Enable contador de ciclos
                    fin_cuenta_12us => fin_cuenta_12us_est,     -- Fin cuenta 12us
                    fin_cuenta_6us => fin_cuenta_6us_est,       -- Fin cuenta 6 us
                    finClocks => finClocks_est);                -- 14 ciclos S2 - S3   

    UUT_6: registro_desplazamiento
    Port map(   clock_fsm => clock_fsm_est,                     -- Reloj para mando
                pre_finish => pre_finish_est,                   -- FSM en estado 4
                data_snes => data_snes_est,                     -- Estado botones mando
                buttons_snes => buttons_snes_est);              -- Vector estado botones mando     
                
    clock_est <= not clock_est after PERIOD/2; 
    data_snes_est <= not data_snes_est after PERIOD*120;              
    
end Behavioral;
