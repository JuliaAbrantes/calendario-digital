library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity mainCntrl is
port (clk 		: in std_logic;
		res		: in std_logic;
		key0 		: in std_logic;
		progBusy : in std_logic := '0';
		dispBusy : in std_logic := '1';
		leds 		: out std_logic_vector(3 downto 0);
		dispStart: out std_logic;
		progStart: out std_logic);
end mainCntrl;


architecture FSM of mainCntrl is
	type Tstate is (PROG, RUN);
	signal Pstate, Nstate: Tstate := RUN;
begin

	sequencial : process(clk)
	begin --autaliza o estado atual
		if(rising_edge(clk)) then
			Pstate <= Nstate;
			if(res = '1') then
				Pstate <= RUN;
			end if;
		end if;
	end process;
	
	combinational : process(Pstate, progBusy, dispBusy, key0) --define as saídas e o próximo estado
	begin
		Nstate <= Pstate; --valor por defeito
		case Pstate is
			when PROG =>
				leds <= "1011";
				progStart <= '1';
				dispStart <= '0';
				if(progBusy = '0') then --acabou de programar
					Nstate <= RUN;
				end if;
				
			when RUN =>
				leds <= "1010";
				progStart <= '0';
				dispStart <= '1';
				if(key0 = '1' and dispBusy = '0') then --só pode mudar pra prog se não estiver no processo de atualizar
					Nstate <= PROG;
				end if;
			end case;
	end process;

end FSM;