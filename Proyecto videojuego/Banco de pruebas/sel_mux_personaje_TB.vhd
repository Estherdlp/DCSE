----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.12.2023 08:57:52
-- Design Name: 
-- Module Name: sel_mux_personaje_TB - Behavioral
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

entity sel_mux_personaje_TB is
--  Port ( );
end sel_mux_personaje_TB;

architecture Behavioral of sel_mux_personaje_TB is
    component sel_mux_personaje is
        Port (  reset : IN STD_LOGIC;                                           -- BTN0 reset del sistema
                columna : IN STD_LOGIC_VECTOR (10 - 1 downto 0);                -- Numero actual de columna px
                fila : IN STD_LOGIC_VECTOR (10 - 1 downto 0);                   -- Numero actual de fila px
                buttons_snes : IN STD_LOGIC_VECTOR (12 DOWNTO 0);               -- Vector estado botones mando
                sel_divisor_personaje : OUT STD_LOGIC_VECTOR (4 - 1 downto 0);  -- Selector multiplexor pixel a pixel fondo/personaje 
                direccion_personaje : OUT STD_LOGIC_VECTOR (8 - 1 downto 0));   -- Direccion ROM personaje
    end component;
    
    component SYNC_VGA is
        Port (  clk1 : IN STD_LOGIC;
                reset : IN STD_LOGIC;
                hsync : OUT STD_LOGIC;
                vsync : OUT STD_LOGIC;
                visible : OUT STD_LOGIC;
                fila_actual : out STD_LOGIC_VECTOR (10 - 1 downto 0);
                columna_actual : out STD_LOGIC_VECTOR (10 - 1 downto 0));
    end component;
    
    component fsm_personajes is
        Port (  reset : IN STD_LOGIC;                           -- Reset del sistema BTN0
                clock : IN STD_LOGIC;                           -- Entrada reloj del sistema
                buttons_snes : IN STD_LOGIC_VECTOR (12 DOWNTO 0);   -- Vector estado botones mando 
                dificultad : IN STD_LOGIC_VECTOR (1 downto 0);   -- Interruptores para la dificultad
                filas_personaje : OUT STD_LOGIC_VECTOR (6 - 1 DOWNTO 0);    -- Posicion actual fila personaje
                columnas_personaje : OUT STD_LOGIC_VECTOR (6 - 1 DOWNTO 0); -- Posicion actual columna personaje
                filas_fantasma: OUT STD_LOGIC_VECTOR (6 - 1 DOWNTO 0);      -- Posicion actual fila fantasma
                columnas_fantasma : OUT STD_LOGIC_VECTOR (6 - 1 DOWNTO 0)); -- Posicion actual columna fantasma          
    end component;
    -- Señales sincro vga
    signal clock_est : STD_LOGIC := '0';
    signal reset_est : STD_LOGIC := '0';
    signal hsync_est : STD_LOGIC := '0';
    signal vsync_est : STD_LOGIC := '0';
    signal visible_est : STD_LOGIC := '0';
    signal columnas_est : STD_LOGIC_VECTOR (10 - 1 downto 0);
    signal filas_est : STD_LOGIC_VECTOR (10 - 1 downto 0);
    -- Señales mux
    signal sel_divisor_personaje_est : STD_LOGIC_VECTOR (4 - 1 downto 0);  -- Selector multiplexor pixel a pixel fondo/personaje 
    signal direccion_personaje_est : STD_LOGIC_VECTOR (8 - 1 downto 0);   -- Direccion ROM personaje
    -- Señales mando
    signal buttons_snes_est : STD_LOGIC_VECTOR (12 DOWNTO 0) := (others => '1');
    -- Señales fsm personajes
    signal filas_personaje_est : STD_LOGIC_VECTOR (6 - 1 DOWNTO 0);
    signal columnas_personaje_est : STD_LOGIC_VECTOR (6 - 1 DOWNTO 0);
    signal filas_fantasma_est : STD_LOGIC_VECTOR (6 - 1 DOWNTO 0);
    signal columnas_fantasma_est : STD_LOGIC_VECTOR (6 - 1 DOWNTO 0); 
    signal dificultad : STD_LOGIC_VECTOR (1 DOWNTO 0);
    
    constant PERIOD : time := 20ns;

begin
    UUT_0 : SYNC_VGA
        Port map (  clk1 => clock_est,
                    reset => reset_est,
                    hsync => hsync_est,
                    vsync => vsync_est,
                    visible => visible_est,
                    fila_actual => filas_est,
                    columna_actual => columnas_est);
    
    UUT_1 : sel_mux_personaje
        Port map(   reset => reset_est,                                       -- BTN0 reset del sistema
                    columna  => columnas_est,                        -- Numero actual de columna px
                    fila => filas_est,                       -- Numero actual de fila px
                    buttons_snes => buttons_snes_est,           -- Vector estado botones mando
                    sel_divisor_personaje => sel_divisor_personaje_est,  -- Selector multiplexor pixel a pixel fondo/personaje 
                    direccion_personaje => direccion_personaje_est);   -- Direccion ROM personaje        
     
    UUT_2 : fsm_personajes
        Port map(   reset => reset_est,                           -- Reset del sistema BTN0
                    clock => clock_est,                           -- Entrada reloj del sistema
                    buttons_snes  => buttons_snes_est,   -- Vector estado botones mando  
                    dificultad => dificultad,
                    filas_personaje => filas_personaje_est,    -- Posicion actual fila personaje
                    columnas_personaje => columnas_personaje_est, -- Posicion actual columna personaje
                    filas_fantasma => filas_fantasma_est,      -- Posicion actual fila fantasma
                    columnas_fantasma => columnas_fantasma_est); -- Posicion actual columna fantasma  
                                
    clock_est <= not clock_est after PERIOD/2;
    buttons_snes_est <= "1111111111111", "1111101011111" after 300 ns, "1111110011111" after 500 ns, "1111111111111" after 800 ns, "0111111111111" after 1000 ns;


end Behavioral;
