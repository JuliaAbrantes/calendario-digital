library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;


entity TBSyncGen is
end TBSyncGen;


architecture simulation of TBSyncGen is
	signal s_clock, s_res, s_en, s_timeClk, s_dispClk: std_logic;
	constant cycle : time := 20 ns;

begin

	clock: process
	begin
		s_clock <= '0';
		wait for cycle/2;
		s_clock <= '1';
		wait for cycle/2;
	end process;
	
	
	stim : process
	begin
		s_res <= '0';
		wait for cycle*500000000;
		s_res <= '1';
		wait for cycle*50000000;
	end process;


	uut: entity work.SyncGen(RTL)
	port map( clkIn	=> s_clock,
				 res		=> s_res,
				 en		=> s_en,
				 timeClk => s_timeClk,
				 dispClk => s_dispClk);

end simulation;