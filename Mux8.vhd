library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity Mux8 is
	port( sel 	: in std_logic_vector(2 downto 0);
		 Din1 	: in std_logic_vector(3 downto 0);
		 Din2 	: in std_logic_vector(3 downto 0);
		 Din3 	: in std_logic_vector(3 downto 0);
		 Din4 	: in std_logic_vector(3 downto 0);
		 Din5 	: in std_logic_vector(3 downto 0);
		 Din6 	: in std_logic_vector(3 downto 0);
		 Din7 	: in std_logic_vector(3 downto 0);
		 Din8 	: in std_logic_vector(3 downto 0);
		 DataOut : out std_logic_vector(3 downto 0));
end Mux8;



architecture Behavioral of Mux8 is
begin
	
	with sel select Dataout <=
							Din1 when "000",
							Din2 when "001",
							Din3 when "010",
							Din4 when "011",
							Din5 when "100",
							Din6 when "101",
							Din7 when "110",
							Din8 when "111";
	
	
end Behavioral;