library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity BinToBCD is
port ( Bin       : in std_logic_vector(3 downto 0);
		 units_out : out std_logic_vector(3 downto 0);
		 tens_out  : out std_logic_vector(3 downto 0));
end BinToBCD;
		 
architecture RLT of BinToBCD is
signal s_bin : unsigned;
begin
	
	s_bin     <= unsigned(Bin);
	units_out <= std_logic_vector((s_bin mod 10)*10 , 4);
	units_out <= std_logic_vector((s_bin / 10)-(s_bin mod 10) , 4);
	
end RTL;