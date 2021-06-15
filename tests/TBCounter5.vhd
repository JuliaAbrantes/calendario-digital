library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity TBCounter5 is
end TBCounter5;

architecture simulation of TBCounter5 is
	signal s_max : std_logic_vector(4 downto 0);
	signal s_loadEn, s_Res, s_clock, s_En, s_TC : std_logic;
	signal s_Q : std_logic_vector(3 downto 0);
	constant cycle : time := 20 ns;
begin
	clock : process
	begin
		s_clock <= '0';
		wait for cycle/2;
		s_clock <= '1';
		wait for cycle/2;
	end process;
	
	stim : process
	begin
		s_En <= '1';
		s_Res <= '1';
		wait for cycle;
		s_Res <= '0';
		wait for cycle;
		wait for cycle*40;
	end process;
	
	uut : entity work.Counter5(Behavioral)
	port map ( max 	=> s_max,
				  Res 	=> s_Res,
				  clk 	=> s_clock,
				  En 		=> s_En,
				  Q 		=> s_Q,
				  TC 		=>	s_TC);

end simulation;