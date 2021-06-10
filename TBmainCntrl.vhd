library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity TBmainCntrl is
end TBmainCntrl;

architecture simulation of TBmainCntrl is
	signal s_TCmonth, s_max_en, CLOCK_50 : std_logic;
	signal s_max_days : natural;
	constant cycle : time := 20 ns;
begin

clock: process
begin
	CLOCK_50 <= '0';
	wait for cycle/2;
	CLOCK_50 <= '1';
	wait for cycle/2;
end process;


main: process
begin
	wait for cycle/2;
	s_TCmonth 	<= '0';
	wait for cycle*31;
	s_TCmonth	<= '1';
	wait for cycle;
	s_TCmonth <= '0';
	wait for cycle*28;
	s_TCmonth <= '1';
	wait for cycle;
	s_TCmonth <= '0';
	wait for cycle*31;
	s_TCmonth	<= '1';
	wait for cycle;
	s_TCmonth <= '0';

end process;


uut: entity work.mainCntrl(Behavioral)
port map( clk 		 => CLOCK_50,
			 TCmonth  => s_TCmonth,
			 max_days => s_max_days,
			 max_en   => s_max_en);


end simulation;