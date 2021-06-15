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
	
end Behavioral;