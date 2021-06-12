library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity BinToBCD is
generic (Nbits	  : positive := 5);
port ( Bin       : in std_logic_vector(NBits-1 downto 0); --o numero de bits da entrada é dado pelo generic
		 units_out : out std_logic_vector(3 downto 0);
		 tens_out  : out std_logic_vector(3 downto 0));
end BinToBCD;

architecture Behavioral of BinToBCD is
begin

	tens_out <= std_logic_vector(to_unsigned(to_integer(unsigned(Bin))/10 , 4));
	units_out <= std_logic_vector(to_unsigned(to_integer(unsigned(Bin)) mod 10 , 4));


--  units_out <= "0001" when (Bin = "0001" or Bin = "1011") else  --01 or 11
--					"0010" when (Bin = "0010" or Bin = "1100") else  --02	or 12
--					"0011" when (Bin = "0011" or Bin = "1101") else  --3
--					"0100" when (Bin = "0100" or Bin = "1110") else  --4
--					"0101" when (Bin = "0101" or Bin = "1111") else  --5
--					"0110" when (Bin = "0110") else  --6
--					"0111" when (Bin = "0111") else  --7
--					"1000" when (Bin = "1000") else  --8
--					"1001" when (Bin = "1001") else  --9
--					"0000"; --10 ou 00
--					
--					
--					
--
--  tens_out <= "0000" when (to_integer(unsigned(Bin)) < 10) else  --01 ... 09
--					"0001"; --10, 11, ... 16
	
end Behavioral;