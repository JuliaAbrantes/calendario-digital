library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity mainCntrl is
port (clk : in std_logic;
		TCmonth : in std_logic;
		--max_days : out std_logic_vector(4 downto 0);
		max_days : out natural;
		max_en : out std_logic);
end mainCntrl;


architecture Behavioral of mainCntrl is
type Tstate is (progDez, Jan, progJan, Fev, progFev, Mar, progMar, Abr, progAbr, Mai, 
progMai, Jun, progJun, Jul, progJul, Ago, progAgo, Set, progSet, Outu, progOutu, 
Nov, progNov, Dez);

signal Pstate, Nstate: Tstate := progJan;
begin

	sequencial : process(clk)
	begin
		if(rising_edge(clk)) then
			Nstate <= Pstate;
			case Pstate is
			when Jan =>
				if	(TCmonth = '1') then
					Nstate <= progFev;
				end if;
			when Fev =>
				if	(TCmonth = '1') then
					Nstate <= progMar;
				end if;
			when Mar =>
				if	(TCmonth = '1') then
					Nstate <= progAbr;
				end if;
			when Abr =>
				if	(TCmonth = '1') then
					Nstate <= progMai;
				end if;
			when Mai =>
				if	(TCmonth = '1') then
					Nstate <= progJun;
				end if;
			when Jun =>
				if	(TCmonth = '1') then
					Nstate <= progJul;
				end if;
			when Jul =>
				if	(TCmonth = '1') then
					Nstate <= progAgo;
				end if;
			when Ago =>
				if	(TCmonth = '1') then
					Nstate <= progSet;
				end if;
			when Set =>
				if	(TCmonth = '1') then
					Nstate <= progOutu;
				end if;
			when Outu =>
				if	(TCmonth = '1') then
					Nstate <= progNov;
				end if;
			when Nov =>
				if	(TCmonth = '1') then
					Nstate <= progDez;
				end if;
			when Dez =>
				if	(TCmonth = '1') then
					Nstate <= progJan;
				end if;
			when progJan =>
				Nstate <= Fev;
			when progFev =>
				Nstate <= Mar;
			when progMar =>
				Nstate <= Abr;
			when progAbr =>
				Nstate <= Mai;
			when progMai =>
				Nstate <= Jun;
			when progJun =>
				Nstate <= Jul;
			when progJul =>
				Nstate <= Ago;
			when progAgo =>
				Nstate <= Set;
			when progSet =>
				Nstate <= Outu;
			when progOutu =>
				Nstate <= Nov;
			when progNov =>
				Nstate <= Dez;
			when progDez =>
				Nstate <= Jan;
			end case;
		end if;
		Pstate <= Nstate;
	end process;

	combinational : process(Pstate)
	begin
		if(Pstate = Jan or Pstate = Mar or Pstate = MAi or PState = Jul or PState = Ago or 
			Pstate = Outu or Pstate = Dez) then
				--max_days <= std_logic_vector(to_unsigned(31,5));
				max_days <= 31;
				max_en <= '0';
		elsif (PState = Fev) then
				--max_days <= std_logic_vector(to_unsigned(28,5));
				max_days <= 28;
				max_en <= '0';
		elsif(Pstate = Abr or Pstate = Jun or Pstate = Set or PState = Nov) then
				--max_days <= std_logic_vector(to_unsigned(30,5));
				max_days <= 30;
				max_en <= '0';
		else --no caso de ser um estado de transição
				max_en <= '1';
		end if;
		
	end process;

end Behavioral;