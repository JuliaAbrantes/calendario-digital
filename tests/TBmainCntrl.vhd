library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity TBmainCntrl is
end TBmainCntrl;

architecture simulation of TBmainCntrl is
	signal s_TCmonth, s_max_en, s_clock : std_logic;
	signal s_max_days : natural;
	constant cycle : time := 20 ns;
begin

clock: process
begin
	s_clock <= '0';
	wait for cycle/2;
	s_clock <= '1';
	wait for cycle/2;
end process;


main: process
begin

end process;


uut: entity work.mainCntrl(Behavioral)
port map( clk 		 => s_clock,
			 max_days => s_max_days);


end simulation;