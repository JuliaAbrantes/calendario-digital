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
	

	constant number_seconds : positive := 50000000;
	constant number_milisseconds : positive := 50000;
	signal s_counter_prog natural range 0 to ( number_seconds - 1 );
	signal s_counter_disp natural range 0 to ( number_milisseconds - 1 ); 
	signal s_counter_time : natural range 0 to ( number_seconds - 1 );
	
	
	
	
	
begin
	process(clkIn)
	begin
		if (rising_edge(clkIn)) then
			 s_counter_time <= s_counter_time +1;
			 s_counter_disp <= s_counter_time +1;
			 s_counter_prog <= s_counter_time +1;
			 
		
		if ( s_counter_time = '0' ) then 
			 timeClk <= '1' ; 
		else 
			 timeClk <= '0';
		end if;
				
		if ( s_counter_disp = '0' ) then 
			 dispClk <= '1' ; 
		else 
			 dispClk <= '0';
		end if;
		
		if ( s_counter_prog = '0' ) then 
			 progClk <= '1' ; 
		else 
			 progClk <= '0';
		end if;
	end process;
	
	
	
	
	
	
	
	
	
	progClk <= '1' when (s_counter_prog = "00") else
				  '0';
				  
	dispClk <= '1' when (s_counter_disp = "00") else
				  '0';

	timeClk	<= s_counter_time(1);
end RTL;


