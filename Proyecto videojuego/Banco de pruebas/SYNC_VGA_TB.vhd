----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.11.2023 16:58:28
-- Design Name: 
-- Module Name: SYNC_VGA_TB - Behavioral
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

entity SYNC_VGA_TB is
end SYNC_VGA_TB;

architecture Behavioral of SYNC_VGA_TB is
    component SYNC_VGA is
        Port (  clk1 : IN STD_LOGIC;
                reset : IN STD_LOGIC;
                hsync : OUT STD_LOGIC;
                vsync : OUT STD_LOGIC;
                visible : OUT STD_LOGIC;
                fila_actual : out STD_LOGIC_VECTOR (10 - 1 downto 0);
                columna_actual : out STD_LOGIC_VECTOR (10 - 1 downto 0));
    end component;
    
    signal clock_est : STD_LOGIC := '0';
    signal reset_est : STD_LOGIC := '0';
    signal hsync_est : STD_LOGIC := '0';
    signal vsync_est : STD_LOGIC := '0';
    signal visible_est : STD_LOGIC := '0';
    signal columnas_est : STD_LOGIC_VECTOR (10 - 1 downto 0);
    signal filas_est : STD_LOGIC_VECTOR (10 - 1 downto 0);
    constant PERIOD : time := 40ns;
    
    
begin
    UUT: SYNC_VGA
        Port map (  clk1 => clock_est,
                    reset => reset_est,
                    hsync => hsync_est,
                    vsync => vsync_est,
                    visible => visible_est,
                    fila_actual => filas_est,
                    columna_actual => columnas_est);
                    
    clock_est <= not clock_est after PERIOD/2;

end Behavioral;
