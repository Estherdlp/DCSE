------- ROM creada automaticamente por ppm2rom -----------
------- Felipe Machado -----------------------------------
------- Departamento de Tecnologia Electronica -----------
------- Universidad Rey Juan Carlos ----------------------
------- http://gtebim.es ---------------------------------
----------------------------------------------------------
--------Datos de la imagen -------------------------------
--- Fichero original    : imagenes16_16x16.ppm 
--- Filas    : 256 
--- Columnas : 16 
--- Color    :  Blanco y negro. 2 niveles (1 bit)



------ Puertos -------------------------------------------
-- Entradas ----------------------------------------------
--    clk  :  senal de reloj
--    addr :  direccion de la memoria
-- Salidas  ----------------------------------------------
--    dout :  dato de 16 bits de la direccion addr (un ciclo despues)


library IEEE;
  use IEEE.STD_LOGIC_1164.ALL;
  use IEEE.NUMERIC_STD.ALL;


entity ROM1b_1f_blue_imagenes16_16x16 is
  port (
    clk  : in  std_logic;   -- reloj
    addr : in  std_logic_vector(8-1 downto 0);
    dout : out std_logic_vector(16-1 downto 0) 
  );
end ROM1b_1f_blue_imagenes16_16x16;


architecture BEHAVIORAL of ROM1b_1f_blue_imagenes16_16x16 is
  signal addr_int  : natural range 0 to 2**8-1;
  type memostruct is array (natural range<>) of std_logic_vector(16-1 downto 0);
  constant filaimg : memostruct := (
       "1111100000111111",
       "1111000000000111",
       "1111000000011111",
       "1110000000000111",
       "1110000000000011",
       "1110000000000111",
       "1111100000000111",
       "1111110111111111",
       "1111110110111111",
       "1111110000111111",
       "1100101001010011",
       "1100000000000011",
       "1100000000000011",
       "1111000110001111",
       "1110001111000111",
       "1100001111000011",
       "1111100000110001",
       "1111000000000001",
       "1111000000011111",
       "1110000000000111",
       "1110000000000011",
       "1110000000000111",
       "1111100000001111",
       "1111110111011110",
       "0011111011101100",
       "0001111000010000",
       "1011010010000000",
       "1100000000000000",
       "1000000000011111",
       "1001111111111111",
       "1111111111111111",
       "1111111111111111",
       "1000111111110001",
       "1000100000010001",
       "1000000000000001",
       "1111000000001111",
       "1111000000001111",
       "1111100000001111",
       "1111100000011111",
       "1111100000011111",
       "1111100000011111",
       "0111110110111110",
       "0011110110111100",
       "0000110000110000",
       "0000001001000000",
       "0000000000000000",
       "1111111111111111",
       "1111111111111111",
       "1111111111111111",
       "1111111111111111",
       "1111110000011111",
       "1111000000000111",
       "1110000000000011",
       "1110000000000011",
       "1100000000001111",
       "1100000001111111",
       "1100001111111111",
       "1100000001111111",
       "1100000000001111",
       "1110000000000011",
       "1110000000000011",
       "1111000000000111",
       "1111110000011111",
       "1111111111111111",
       "1111111111111111",
       "1111110000111111",
       "1111000000001111",
       "1110000000000111",
       "1101100001100011",
       "1111110011110011",
       "1111110011110011",
       "1011110011110001",
       "1001100001100001",
       "1000000000000001",
       "1000000000000001",
       "1000000000000001",
       "1000000000000001",
       "1001000110001001",
       "1011100110011101",
       "1111111111111111",
       "1111111111111111",
       "1111111111111111",
       "1111111111111111",
       "1111111111111111",
       "1111111111111111",
       "1111111111111111",
       "1111111111111111",
       "1111111111111111",
       "1111111111111111",
       "1111111111111111",
       "1111111111111111",
       "1111111111111111",
       "1111111111111111",
       "1111111111111111",
       "1111111111111111",
       "1111111111111111",
       "1111110001001111",
       "1111100000000011",
       "1111000111110001",
       "1110001111111000",
       "1111111111111100",
       "1111111111111101",
       "1110010111111111",
       "1100010010100111",
       "1000000100100011",
       "1000001000000001",
       "1001001000000001",
       "1000101001000001",
       "1100001000100001",
       "1110000100000011",
       "1111111110000111",
       "1111111111111111",
       "1111111111111111",
       "1111000010000111",
       "1110000000000011",
       "1100000000000011",
       "1000000000000001",
       "1000000000000001",
       "1000000000000001",
       "1000000000000001",
       "1100000000000011",
       "1100000000000011",
       "1110000000000111",
       "1111000000000111",
       "1111100000001111",
       "1111110000011111",
       "1111111000111111",
       "1111111111111111",
       "1111000000000111",
       "1110000000000011",
       "1100000000000001",
       "1100000110000001",
       "1100001110000001",
       "1100001110000001",
       "1100001100000001",
       "1100001100100001",
       "1100001000100001",
       "1100001001100001",
       "1100000001100001",
       "1100000011100001",
       "1100000011000001",
       "1100000000000001",
       "1110000000000011",
       "1111000000000111",
       "1111110000001111",
       "1111110000001111",
       "1111000000001111",
       "1111000000001111",
       "1100000000001111",
       "1100000000001111",
       "1111110000001111",
       "1111110000001111",
       "1111110000001111",
       "1111110000001111",
       "1111110000001111",
       "1111110000001111",
       "1100000000000000",
       "1100000000000000",
       "1100000000000000",
       "1100000000000000",
       "1111000000000011",
       "1111000000000011",
       "1100000000000000",
       "1100000000000000",
       "1111111111000000",
       "1111111111000000",
       "1111000000000000",
       "1111000000000000",
       "1100000000000000",
       "1100000000000000",
       "1100000011111111",
       "1100000011111111",
       "1100000000000000",
       "1100000000000000",
       "1100000000000000",
       "1100000000000000",
       "1111000000000011",
       "1111000000000011",
       "1100000000000000",
       "1100000000000000",
       "1111111111000000",
       "1111111111000000",
       "1111110000000000",
       "1111110000000000",
       "1111110000000000",
       "1111110000000000",
       "1111111111000000",
       "1111111111000000",
       "1100000000000000",
       "1100000000000000",
       "1111000000000011",
       "1111000000000011",
       "1111000011111111",
       "1111000011111111",
       "1100000011111111",
       "1100000011111111",
       "1100000011000000",
       "1100000011000000",
       "1100000011000000",
       "1100000011000000",
       "1100000000000000",
       "1100000000000000",
       "1100000000000000",
       "1100000000000000",
       "1111111111000000",
       "1111111111000000",
       "1111111111000000",
       "1111111111000000",
       "1100000000000000",
       "1100000000000000",
       "1100000000000000",
       "1100000000000000",
       "1100000011111111",
       "1100000011111111",
       "1100000000000011",
       "1100000000000011",
       "1100000000000000",
       "1100000000000000",
       "1111111111000000",
       "1111111111000000",
       "1100000000000000",
       "1100000000000000",
       "1111000000000011",
       "1111000000000011",
       "1111111111111111",
       "1111111111111111",
       "1111111111111111",
       "1111100000011111",
       "1111100000011111",
       "1111111001111111",
       "1111111001111111",
       "1111110000111111",
       "1111110000111111",
       "1111100000011111",
       "1111100000011111",
       "1111000000001111",
       "1111000000001111",
       "1111100000011111",
       "1111111111111111",
       "1111111111111111",
       "1111111111111111",
       "1111111111111111",
       "1111111111011111",
       "1111111110001111",
       "1111111110000111",
       "1111111110000011",
       "1111111100000111",
       "1111110000111111",
       "1110000001111111",
       "1100000001111111",
       "1100000011111111",
       "1110000011111111",
       "1111000001111111",
       "1111100011111111",
       "1111111111111111",
       "1111111111111111"
        );

begin

  addr_int <= TO_INTEGER(unsigned(addr));

  P_ROM: process (clk)
  begin
    if clk'event and clk='1' then
      dout <= filaimg(addr_int);
    end if;
  end process;

end BEHAVIORAL;

