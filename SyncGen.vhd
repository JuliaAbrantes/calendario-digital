
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;


entity SyncGen is
	port( clkIn : in std_logic;
			progClk : out std_logic;
			timeClk : out std_logic;
			dispClk : out std_logic);
end SyncGen;


architecture RTL of SyncGen is
	signal s_counter_prog : unsigned(1 downto 0);
	signal s_counter_disp : unsigned(1 downto 0);
	signal s_counter_time : unsigned(1 downto 0);

begin
	process(clkIn)
	begin
		if (rising_edge(clkIn)) then
			s_counter_prog <= s_counter_prog + 1;
			s_counter_disp <= s_counter_disp + 1;
			s_counter_time <= s_counter_time + 1;		
		end if;
	end process;
	
	progClk <= '1' when (s_counter_prog = "00") else
				  '0';
				  
	dispClk <= '1' when (s_counter_disp = "00") else
				  '0';

	timeClk	<= s_counter_time(1);
end RTL;