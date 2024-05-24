----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.10.2023 17:38:21
-- Design Name: 
-- Module Name: main - Behavioral
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

entity main is
    Port( reset : IN STD_LOGIC;                                    -- BTN0 reset del sistema
          clock : IN STD_LOGIC;                                    -- sysclk reloj del sistema 125 MHz
          enable : IN STD_LOGIC;                                   -- BTN3 habilitacion del cronometro y señalizacion LED
          ascendente_descendente : IN STD_LOGIC;                   -- SW1 seleccion ascendente/descendente
          AN : OUT STD_LOGIC;                                      -- JD3 salida para encender los dos 7seg
          salida_7seg : out STD_LOGIC_VECTOR (6 downto 0);         -- JC[0,3] y JD[0,3] salida 7seg
          salida_led_tricolor : OUT STD_LOGIC_VECTOR (2 downto 0); -- LED6[R,G,B] led RGB
          conteo_binario_led : out STD_LOGIC_VECTOR (3 downto 0)); -- LED[0-3] conteo binario de las decimas de segundo
end main;

architecture Behavioral of main is
    component contador is
        Generic ( num_bits : integer := 27;                     -- Numero de bits necesarios para almacenar el valor de cuenta
                  valor_fin_cuenta : integer := 120000000);     -- Valor fin de cuenta del contador
        Port (    reset : IN STD_LOGIC;                         -- Reset del sistema BTN0
                  clock : IN STD_LOGIC;                         -- Entrada reloj del sistema
                  enable : IN STD_LOGIC;                        -- Habilitacion contador
                  ascendente_descendente : IN STD_LOGIC;        -- Interruptor para cuenta ascendente o descendente
                  fin_cuenta : OUT STD_LOGIC;                   -- Señal fin de cuenta
                  valor_cuenta_actual : out STD_LOGIC_VECTOR (Num_bits - 1 downto 0));  -- Valor actual de cuenta
    end component;  
    
    component mux2_bus4 is
        Port ( In_0 : in STD_LOGIC_VECTOR (3 downto 0);         -- Entrada 0 multiplexor 4 bits
               In_1 : in STD_LOGIC_VECTOR (3 downto 0);         -- Entrada 1 multiplexor 4 bits
               Sel : in STD_LOGIC;                              -- Seleccion entrada multiplexor
               Q_0 : out STD_LOGIC_VECTOR (3 downto 0));        -- Salida multiplexor 4 bits
    end component;
    
    component conv_7seg is
        Port ( entrada_7seg : in STD_LOGIC_VECTOR (3 downto 0); -- Entrada conversor 7seg
               salida_7seg : out STD_LOGIC_VECTOR (6 downto 0));-- Salida conversor 7seg
    end component;
    
    component and2 is
        Port ( in_0 : in STD_LOGIC;                             -- Entrada 0 and
               in_1 : in STD_LOGIC;                             -- Entrada 1 and
               out_0 : out STD_LOGIC);                          -- Salida and
    end component;    
    
    component led_tricolor is
        Port ( reset : IN STD_LOGIC;                            -- Reset del sistema BTN0
               clock : IN STD_LOGIC;                            -- Reloj del sistema 
               enable : IN STD_LOGIC;                           -- Entrada de habilitacion
               cambio_estado : IN STD_LOGIC;                    -- Cuenta 500 ms
               salida_led_tricolor : OUT STD_LOGIC_VECTOR (2 downto 0));
    end component;
   
    component start_stop is
        Port ( reset : IN STD_LOGIC;                            -- Entrada de reset BTN0
               clock : IN STD_LOGIC;                            -- Reloj del sistema 
               boton : IN STD_LOGIC;                            -- Entrada de habilitacion
               enable_sistema : OUT STD_LOGIC);                 -- Pulso timer por cuenta 500 ms
    end component;
    
    component cuenta_LED is
        Port ( reset : in STD_LOGIC;                            -- Entrada de reset BTN0
               clock : in STD_LOGIC;                            -- Reloj del sistema 
               enable : in STD_LOGIC;                           -- Entrada de habilitacion
               conteo_binario_led : out STD_LOGIC_VECTOR (3 downto 0)); -- Array para conteo binario de las decimas de segundo
    end component;
   
    signal enable_sig : STD_LOGIC := '1';                       -- Habilitacion permanente para el 7segmentos
    signal enable_btn3 : STD_LOGIC;                             -- Señal para enable con boton
    signal S1seg : STD_LOGIC;                                   -- Salida timer 1 s
    signal S10seg : STD_LOGIC;                                  -- Salida timer 10 s
    signal S60seg: STD_LOGIC;                                   -- Salida timer 60 s
    signal S1mili : STD_LOGIC;                                  -- Salida timer 1 ms
    signal S2milis : STD_LOGIC;                                 -- Salida timer 2 ms
    signal S100milis : STD_LOGIC;                               -- Salida timer 100 ms
    signal S500milis : STD_LOGIC;                               -- Salida timer 500 ms
    signal segundos : STD_LOGIC_VECTOR (3 downto 0);            -- Valor actual segundos timer
    signal dec_segundos : STD_LOGIC_VECTOR (3 downto 0);        -- Valor actual decenas segundo timer
    signal puerta_and : STD_LOGIC;                              -- Puerta and para habilitar contador en cascada
    signal mostrar : STD_LOGIC_VECTOR (3 downto 0);             -- Salida valor de cuenta multiplexado, entrada del 7seg

begin
   
    ------------------ PARTE BÁSICA -------------------------- 
   
    -- Divisor de frecuencia para obtener pulsos cada 1 s
    u0: contador 
        generic map ( num_bits => 27,                           -- Numero de bits necesarios para almacenar el valor de cuenta
                      valor_fin_cuenta => 125000000)            -- Valor fin de cuenta del contador
        port map ( reset => reset,                              -- Reset del sistema BTN0
                   clock => clock,                              -- Reloj del sistema                              
                   enable =>  enable_btn3,                      -- Habilitacion contador con BTN3
                   ascendente_descendente => ascendente_descendente, -- Interruptor para cuenta ascendente o descendente
                   fin_cuenta => S1seg,                         -- Señal fin de cuenta
                   valor_cuenta_actual => open);                -- Sin usar
        
    -- Multiplexor para poder mostrar los segundos y las decimas simultaneamente en el 7seg      
    u1: mux2_bus4 port map ( In_0 => segundos,                  -- Entrada 0 multiplexor 4 bits  
                             In_1 => dec_segundos,              -- Entrada 1 multiplexor 4 bits  
                             Sel => S2milis,                    -- Seleccion entrada multiplexor 
                             Q_0 => mostrar);                   -- Salida multiplexor 4 bits
        
    -- Conversor 7 segmentos PmodSSD catodo comun
    u2: conv_7seg port map ( entrada_7seg => mostrar,           -- Entrada conversor 7seg  
                             salida_7seg => salida_7seg);       -- Salida conversor 7seg   
    
    -- Contador de 10 segundos: 10 pulsos con habilitacion cada segundo: conteo los segundos
    u3: contador 
        generic map ( num_bits => 4,                            -- Numero de bits necesarios para almacenar el valor de cuenta
                      valor_fin_cuenta => 10)                   -- Valor fin de cuenta del contador
        port map ( reset => reset,                              -- Reset del sistema BTN0
                   clock => clock,                              -- Reloj del sistema  
                   enable => S1seg,                             -- Habilitacion cada 1 s
                   ascendente_descendente => ascendente_descendente, -- Interruptor para cuenta ascendente o descendente
                   fin_cuenta => S10seg,                        -- Señal fin de cuenta
                   valor_cuenta_actual => segundos);            -- Valor actual de cuenta
    
    -- Puerta AND para habilitar el contador de decenas de segundo un unico ciclo de reloj
    u4: and2
        port map ( in_0 => S1seg,                               -- Entrada 0 and 
                   in_1 => S10seg,                              -- Entrada 1 and 
                   out_0 => puerta_and);                        -- Salida and  
                   
    -- Contador de decenas de segundo: 6 pulsos con habilitacion cada 10 segundos: conteo de decenas de segundo
    u5: contador 
        generic map ( num_bits => 4,                            -- Numero de bits necesarios para almacenar el valor de cuenta
                      valor_fin_cuenta => 6)                    -- Valor fin de cuenta del contador
        port map ( reset => reset,                              -- Reset del sistema BTN0
                   clock => clock,                              -- Reloj del sistema  
                   enable => puerta_and,                        -- Habilitacion cada 10 segundos
                   ascendente_descendente => ascendente_descendente, -- Interruptor para cuenta ascendente o descendente
                   fin_cuenta => S60seg,                        -- Señal fin de cuenta 
                   valor_cuenta_actual => dec_segundos);        -- Valor actual de cuenta  

    -- Divisor de frecuencia para obtener pulsos cada 1 ms  
    u6: contador 
        generic map ( num_bits => 17,                           -- Numero de bits necesarios para almacenar el valor de cuenta
                      valor_fin_cuenta => 125000)               -- Valor fin de cuenta del contador
        port map ( reset => reset,                              -- Reset del sistema BTN0
                   clock => clock,                              -- Reloj del sistema  
                   enable => enable_sig,                        -- Habilitacion permanente del contador para visualizacion 7seg
                   ascendente_descendente => ascendente_descendente,-- Interruptor para cuenta ascendente o descendente
                   fin_cuenta => S1mili,                        -- Señal fin de cuenta
                   valor_cuenta_actual => open);                -- Sin usar
                   
    -- Contador de 2 ms: 2 pulsos con habilitacion cada 1 ms para encender los dos displays de 7 segmentos
    u7: contador 
        generic map ( num_bits => 2,                            -- Numero de bits necesarios para almacenar el valor de cuenta
                      valor_fin_cuenta => 2)                    -- Valor fin de cuenta del contador
        port map ( reset => reset,                              -- Reset del sistema BTN0
                   clock => clock,                              -- Reloj del sistema 
                   enable => S1mili,                            -- Habilitacion cada 1 ms para visualizacion 7seg
                   ascendente_descendente => ascendente_descendente,-- Interruptor para cuenta ascendente o descendente
                   fin_cuenta => S2milis,                       -- Señal fin de cuenta
                   valor_cuenta_actual => open);                -- Sin usar
     
    AN <= S2milis;  -- JD3 a CAT de PmodSSD: alternar pulsos cada 2 ms en displays 1 y 2 para visualizacion permanente de ambos
     
    ------------------ PARTE AVANZADA 1 -------------------------- 
                   
    -- Divisor de frecuencia para obtener pulsos cada 500 ms: parpadeo del LED tricolor 
    u8: contador 
        generic map ( num_bits => 26,                           -- Numero de bits necesarios para almacenar el valor de cuenta
                      valor_fin_cuenta => 62500000)             -- Valor fin de cuenta del contador
        port map ( reset => reset,                              -- Reset del sistema BTN0
                   clock => clock,                              -- Reloj del sistema 
                   enable => enable_btn3,                       -- Habilitacion contador con BTN3
                   ascendente_descendente => ascendente_descendente,-- Interruptor para cuenta ascendente o descendente
                   fin_cuenta => S500milis,                     -- Señal fin de cuenta
                   valor_cuenta_actual => open);                -- Sin usar
    
    -- LED tricolor: color verde parpadeante cada 0.5 s si esta contando, color rojo si esta parado           
    u9: led_tricolor
        port map ( reset => reset,                              -- Reset del sistema BTN0
                   clock => clock,                              -- Reloj del sistema
                   enable => enable_btn3,                       -- Entrada de habilitacion
                   cambio_estado => S500milis,                  -- Cambio de estado ON/OFF cada 500 ms
                   salida_led_tricolor => salida_led_tricolor); -- LED6[R,G,B] led RGB
     
    -- Habilitar/deshabilitar conteo con un pulsador              
    u10: start_stop
        port map ( reset => reset,                              -- Reset del sistema BTN0
                   clock => clock,                              -- Reloj del sistema
                   boton => enable,                             -- Pulsador BTN3
                   enable_sistema => enable_btn3);              -- Maquina de estados ON/OFF
                   
    -- Divisor de frecuencia para obtener pulsos cada 100 ms: mostrar decimas de segundo
    u11: contador 
        generic map ( num_bits => 24,                           -- Numero de bits necesarios para almacenar el valor de cuenta
                      valor_fin_cuenta => 12500000)             -- Valor fin de cuenta del contador
        port map ( reset => reset,                              -- Reset del sistema BTN0
                   clock => clock,                              -- Reloj del sistema 
                   enable => enable_btn3,                       -- Habilitacion contador con BTN3
                   ascendente_descendente => ascendente_descendente,-- Interruptor para cuenta ascendente o descendente
                   fin_cuenta => S100milis,                     -- Señal fin de cuenta
                   valor_cuenta_actual => open);                -- Sin usar
     
     -- Cuenta binaria de las decimas de segundo con cuatro LED              
     u12: cuenta_LED
        port map ( clock => clock,                              -- Reloj del sistema
                   reset => reset,                              -- Reset del sistema BTN0
                   enable => S100milis,                         -- Habilitacion cada 100 ms para conteo de decimas de segundo
                   conteo_binario_led => conteo_binario_led);   -- LED[0-3] conteo binario de las decimas de segundo  
end Behavioral;
