library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity Demux8 is
port(sel		: in std_logic;
	  Dout1 	: out std_logic;
	  Dout2 	: out std_logic;
	  Dout3 	: out std_logic;
	  Dout4 	: out std_logic;
	  Dout5 	: out std_logic;
	  Dout6 	: out std_logic;
	  Dout7 	: out std_logic;
	  Dout8 	: out std_logic);
end Demux8;

architecture Behavioral of Demux8 is
begin

	process(sel)
	begin
		Dout1 	=> '0';
		Dout2 	=> '0';
		Dout3 	=> '0';
		Dout4 	=> '0';
		Dout5 	=> '0';
		Dout6 	=> '0';
		Dout7 	=> '0';
		Dout8 	=> '0';

		case sel is
		when "000" =>
			Dout1 <= '1';
		when "001" =>
			Dout2 <= '1';
		when "010" =>
			Dout3 <= '1';
		when "011" =>
			Dout4 <= '1';
		when "100" =>
			Dout5 <= '1';
		when "101" =>
			Dout6 <= '1';
		when "110" =>
			Dout7 <= '1';
		when "111" =>
			Dout8 <= '1';
		end case;
	end process;
	

end Behavioral;