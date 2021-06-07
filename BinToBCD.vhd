library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity BinToBCD is
port ( Bin       : in std_logic_vector(3 downto 0);
		 units_out : out std_logic_vector(3 downto 0);
		 tens_out  : out std_logic_vector(3 downto 0));
end BinToBCD;
		 
architecture RTL of BinToBCD is
	signal s_bin : unsigned(3 downto 0);
	signal s_units_out : unsigned(3 downto 0);
	signal s_tens_out : unsigned(3 downto 0);

begin
	
	s_bin       <= unsigned(Bin);
	
	s_units_out <= (s_bin mod 10)*10;
	s_tens_out  <= (s_bin / 10)-(s_bin mod 10);
	
	units_out   <= std_logic_vector(s_units_out);
	units_out   <= std_logic_vector(s_tens_out);
	
end RTL;