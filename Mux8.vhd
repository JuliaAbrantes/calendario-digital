library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity Mux8 is
	port( sel 	: in std_logic;
		 Din1 	: in std_logic;
		 Din2 	: in std_logic;
		 Din3 	: in std_logic;
		 Din4 	: in std_logic;
		 Din5 	: in std_logic;
		 Din6 	: in std_logic;
		 Din7 	: in std_logic;
		 Din8 	: in std_logic;
		 DataOut : out std_logic;
end Mux8;



architecture Behavioral of Mux8 is
begin
	case sel is
	when 000 =>
		DataOut <= Din1;
	when 001 =>
		DataOut <= Din2;
	when 010 =>
		DataOut <= Din3;
	when 011 =>
		DataOut <= Din4;
	when 100 =>
		DataOut <= Din5;
	when 101 =>
		DataOut <= Din6;
	when 110 =>
		DataOut <= Din7;
	when 111 =>
		DataOut <= Din8;	
	end case;
end Behavioral;