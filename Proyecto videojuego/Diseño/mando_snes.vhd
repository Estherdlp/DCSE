----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.12.2023 17:42:45
-- Design Name: 
-- Module Name: mando_snes - Behavioral
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

entity mando_snes is
    Port (  clock : IN STD_LOGIC;                               -- sysclk reloj del sistema 125 MHz
            reset : IN STD_LOGIC;                               -- BTN0 reset del sistema
            data_snes : IN STD_LOGIC;                           -- Estado de cada boton del mando
            latch : OUT STD_LOGIC;                              -- Pulso inicio
            clock_fsm : OUT STD_LOGIC;                          -- Reloj para mando
            buttons_snes : OUT STD_LOGIC_VECTOR (12 DOWNTO 0)); -- Vector con estado de todos los botones
end mando_snes;

architecture Behavioral of mando_snes is

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
    
    component fsm_snes is
        Port (  clock : IN STD_LOGIC;                           -- sysclk reloj del sistema 125 MHz
                reset : IN STD_LOGIC;                           -- BTN0 reset del sistema
                fin_cuenta_12us : IN STD_LOGIC;                 -- Fin cuenta 12us
                fin_cuenta_6us : IN STD_LOGIC;                  -- Fin cuenta 6us
                finClocks : IN STD_LOGIC;                       -- 16 ciclos S2 - S3
                start : IN STD_LOGIC;                           -- Señal inicio cilo lectura mando
                enable_countClocks : OUT STD_LOGIC;             -- Enable contador de ciclos
                latch : OUT STD_LOGIC;                          -- Pulso inicio
                clock_fsm : OUT STD_LOGIC;                      -- Reloj para mando
                pre_finish : OUT STD_LOGIC);                    -- La maquina de estados se encuentra en el estado 4 
    end component;
    
    component Counter_Clks is
        Port (  clock : IN STD_LOGIC;                           -- sysclk reloj del sistema 125 MHz
                reset : IN STD_LOGIC;                           -- BTN0 reset del sistema
                enable_countClocks : IN STD_LOGIC;              -- Enable contador de ciclos
                fin_cuenta_12us : IN STD_LOGIC;                 -- Fin cuenta 12us
                fin_cuenta_6us : IN STD_LOGIC;                  -- Fin cuenta 6 us
                finClocks : OUT STD_LOGIC);                     -- Fin 14 pulsos                     
    end component;
    
    component registro_desplazamiento is
        Port (  clock_fsm : IN STD_LOGIC;                       -- Reloj para mando
                pre_finish : IN STD_LOGIC;                      -- FSM en estado 4
                data_snes : IN STD_LOGIC;                       -- Estado botones mando
                buttons_snes : OUT STD_LOGIC_VECTOR (12 DOWNTO 0)); -- Vector estado botones mando   
    end component;
    
    -- Señales intermedias muestreo pulsadores
    signal enable_sig : STD_LOGIC := '1';                       -- Habilitacion permanente
    signal asc_sig : STD_LOGIC := '0';                          -- Ascendente permanente
    signal fin_cuenta_12us : STD_LOGIC;                         -- Fin cuenta 12us
    signal fin_cuenta_6us : STD_LOGIC;                          -- Fin cuenta 6 us
    signal start : STD_LOGIC := '1';                            -- Pulso para comenzar lectura mando
    signal enable_countClocks : STD_LOGIC;                      -- Enable contador de ciclos
    signal finClocks : STD_LOGIC;                               -- Fin 16 pulsos
    signal pre_finish : STD_LOGIC;                              -- FSM mando en estado 4
    signal clock_fsm_signal : STD_LOGIC;                        -- Señal reloj FSM
    signal precarga_12 : unsigned (11 - 1 downto 0) := (others => '0');
    signal precarga_6 : unsigned (10 - 1 downto 0) := (others => '0');
    signal precarga_240 : unsigned (15 - 1 downto 0) := (others => '0');
    
begin
    -- Contador 12us
    u0: contador 
        generic map ( num_bits => 11,                           -- Numero de bits necesarios para almacenar el valor de cuenta
                      valor_fin_cuenta => 1500)                 -- Valor fin de cuenta del contador
        port map ( reset => reset,                              -- Reset del sistema BTN0
                   clock => clock,                              -- Reloj del sistema                              
                   enable =>  enable_sig,                       -- Habilitacion contador
                   ascendente_descendente => asc_sig,           -- Interruptor para cuenta ascendente o descendente
                   precarga => precarga_12,
                   fin_cuenta => fin_cuenta_12us,               -- Señal fin de cuenta
                   valor_cuenta_actual => open);                -- Sin usar
                   
    -- Contador 6us
    u1: contador 
        generic map ( num_bits => 10,                           -- Numero de bits necesarios para almacenar el valor de cuenta
                      valor_fin_cuenta => 750)                  -- Valor fin de cuenta del contador
        port map ( reset => reset,                              -- Reset del sistema BTN0
                   clock => clock,                              -- Reloj del sistema                              
                   enable =>  enable_sig,                       -- Habilitacion contador
                   ascendente_descendente => asc_sig,           -- Interruptor para cuenta ascendente o descendente
                   precarga => precarga_6,
                   fin_cuenta => fin_cuenta_6us,                -- Señal fin de cuenta
                   valor_cuenta_actual => open);                -- Sin usar   
                   
    -- Contador 240 us - start
    u2: contador 
        generic map ( num_bits => 15,                           -- Numero de bits necesarios para almacenar el valor de cuenta
                      valor_fin_cuenta => 30000)                -- Valor fin de cuenta del contador
        port map (  reset => reset,                             -- Reset del sistema BTN0
                    clock => clock,                             -- Reloj del sistema                              
                    enable =>  enable_sig,                      -- Habilitacion contador
                    ascendente_descendente => asc_sig,          -- Interruptor para cuenta ascendente o descendente
                    precarga => precarga_240,
                    fin_cuenta => start,                        -- Señal fin de cuenta
                    valor_cuenta_actual => open);               -- Sin usar  
    
    -- Maquina de estados mando               
    u3: fsm_snes
        Port map (  clock => clock,                             -- sysclk reloj del sistema 125 MHz
                    reset => reset,                             -- BTN0 reset del sistema
                    fin_cuenta_12us => fin_cuenta_12us,         -- Fin cuenta 12us
                    fin_cuenta_6us => fin_cuenta_6us,           -- Fin cuenta 6us
                    finClocks => finClocks,                     -- 16 ciclos S2 - S3
                    start => start,                             -- Pulso para comenzar lectura mando
                    enable_countClocks => enable_countClocks,   -- Enable contador de ciclos
                    latch => latch,                             -- Pulso inicio
                    clock_fsm => clock_fsm_signal,              -- Reloj para mando
                    pre_finish => pre_finish);                  -- Señal estado S4
                    
    clock_fsm <= clock_fsm_signal;                
                     
    -- Contador de cambios de estado S2-S3
    u4: Counter_Clks
        Port map (  clock => clock,                             -- sysclk reloj del sistema 125 MHz
                    reset => reset,                             -- BTN0 reset del sistema
                    enable_countClocks => enable_countClocks,   -- Enable contador de ciclos
                    fin_cuenta_12us => fin_cuenta_12us,         -- Fin cuenta 12us
                    fin_cuenta_6us => fin_cuenta_6us,           -- Fin cuenta 6 us
                    finClocks => finClocks);                    -- 16 ciclos S2 - S3 
                      
    -- Registro para almacenar los botones pulsados en cada ciclo                
    u5: registro_desplazamiento
        Port map(   clock_fsm => clock_fsm_signal,              -- Reloj para mando
                    pre_finish => pre_finish,                   -- FSM en estado 4
                    data_snes => data_snes,                     -- Estado botones mando
                    buttons_snes => buttons_snes);              -- Vector estado botones mando
                    
                                         
end Behavioral;
