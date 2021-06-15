library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;


entity SyncGen is
	port( clkIn   : in std_logic;
			res     : in std_logic;
			en		  : in std_logic;
			timeClk : out std_logic;
			dispClk : out std_logic); 
end SyncGen;




architecture RTL of SyncGen is

	constant number_seconds: positive :=50000000;
	constant number_milisseconds: positive :=50000;
	signal s_counter_time, s_counter_disp : natural;
	
	
begin
	process(clkIn)
	begin
		if (rising_edge(clkIn)) then
		 if (res ='1' or s_counter_disp>= (number_milisseconds-1)) then --volta para o inicio da contagem
			s_counter_disp <= 0;
		 else 
			s_counter_disp <=s_counter_disp +1; --avança a contagem
		  end if;
		end if;
	end process;
	
	process(clkIn)
	begin
		if (rising_edge(clkIn)) then
		 if (res ='1' or s_counter_time>= (number_seconds-1)) then
			s_counter_time <= 0;
		 else 
			s_counter_time <=s_counter_time +1;
		  end if;
		end if;
	end process;
	
	timeClk <= '1' when s_counter_time = 49999999 and en = '1' else --fica a 1 se for 0 e estivermos a usar o 
				  '0';
	
	dispClk <= '1' when s_counter_disp = 0 and en = '1' else
				  '0';
	
end RTL;
