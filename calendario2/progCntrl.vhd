library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;


entity progCntrl is
port(clk   	  : in std_logic;
	  progStart: in std_logic;
	  res		  : in std_logic;
	  en		  : in std_logic;
	  key	  	  : in std_logic_vector(2 downto 0);
	  progBusy : out std_logic;
	  sel      : out std_logic_vector(5 downto 0) --0, contador dos dias, até 5, o contador das dezenas dos anos
	  );
end progCntrl;

architecture FSM of progCntrl is
	type Tstate is (WAITING, PROG_DAY, PROG_MONTH, PROG_YEAR_UNITS, PROG_YEAR_TENS, PROG_YEAR_HUND, PROG_YEAR_THOU);
	signal Nstate, Pstate : Tstate := WAITING;
	signal s_sel : std_logic_vector(5 downto 0);
begin

	sequencial : process(clk)
	begin
		if(rising_edge(clk)) then
			if (res = '1') then 
				Pstate <= WAITING;
				else
			Pstate <= Nstate;
			end if;
		end if;
	end process;

	combinational : process(Pstate, key, en)
	begin
		Nstate <= Pstate;
		progBusy <= '1';
		s_sel <= "000000";
		
		case Pstate is
			when WAITING =>
				progBusy <= '0';
				if (progStart = '1') then
					Nstate <= PROG_DAY;
				end if;
		
			when PROG_DAY =>
				if(key(0) = '1') then
					Nstate <= PROG_MONTH;
					
				elsif(key(1) = '1') then
					s_sel(0) <= '1';
					
				end if;
				
			when PROG_MONTH =>
				if(key(0) = '1') then
					Nstate   <= PROG_YEAR_UNITS;
					
				elsif(key(1) = '1') then
					s_sel(1) <= '1';
					
				end if;
				
			when PROG_YEAR_UNITS =>
				if(key(0) = '1') then
					Nstate   <= PROG_YEAR_TENS;
					
				elsif(key(1) = '1') then
					s_sel(2) <= '1';
					
				end if;
			
			when PROG_YEAR_TENS =>
				if(key(0) = '1') then
					Nstate   <= PROG_YEAR_HUND;
					
				elsif(key(1) = '1') then
					s_sel(3) <= '1';
					
				end if;
			
			when PROG_YEAR_HUND =>
				if(key(0) = '1') then
					Nstate   <= PROG_YEAR_THOU;
					
				elsif(key(1) = '1') then
					s_sel(4) <= '1';
					
				end if;
			
			when PROG_YEAR_THOU =>
				if(key(0) = '1') then
					progBusy <= '0';
					Nstate   <= WAITING;
					
				elsif(key(1) = '1') then
					s_sel(5) <= '1';
					
				end if;
				
		end case;
	end process;

end FSM;