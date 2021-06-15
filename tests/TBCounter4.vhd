library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity TBCounter4 is
end TBCounter4;

architecture stimulus of TBCounter4 is
	signal s_max : std_logic_vector(3 downto 0);
	signal s_Res, CLOCK_50, s_En, s_TC : std_logic;
	signal s_Q : std_logic_vector(3 downto 0);

	constant cycle : time := 20 ns;
begin

clock_stim : process
begin
	CLOCK_50 <= '0';
	wait for cycle/2;
	CLOCK_50 <= '1';
	wait for cycle/2;
end process;


counter_stim : process
begin
	s_Res <= '0';
	s_max <= "0100";
	s_En <= '1';
	wait for cycle;
	s_En <= '0';
	wait for cycle*10;
	s_Res <= '1';
	wait for cycle;
end process;

uut : entity work.simpleCounter(Behavioral)
port map( max => s_max,
			 Res => s_Res,
			 clk => CLOCK_50,
			 En  => s_En,
			 Q	  => s_Q,
			 TC  => s_TC);

end stimulus;