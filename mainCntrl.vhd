library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity mainCntrl is
port (clk : in std_logic;
		--max_days : out std_logic_vector(4 downto 0);
		max_days : out natural);
end mainCntrl;


architecture Behavioral of mainCntrl is
	type Tstate is (PROG, RUN);

	signal Pstate, Nstate: Tstate := RUN;
begin

	sequencial : process(clk)
	begin --autaliza o estado atual
		if(rising_edge(clk)) then
			Pstate <= Nstate;
		end if;
	end process;

	combinational : process(Pstate)
	begin
		Nstate <= Pstate;
		
	end process;

end Behavioral;