library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity DispCntrl is
	port(clk : in std_logic;
		  En : in std_logic;
		  selMux : out std_logic_vector(2 downto 0);
		  selReg : out std_logic_vector(7 downto 0));
end DispCntrl;


architecture FSM of DispCntrl is
	type Tstate is (s0, s1, s2, s3, s4, s5, s6, s7, s8);
	signal Pstate : Tstate := s0;
	signal Nstate : Tstate;
begin
	sequencical : process(clk) --determina o próximo estado
	begin
		if(rising_edge(clk))then
			Pstate <= Nstate;
		end if;
	end process;
	
	
	combinational : process(Pstate) --determina a saída
	begin
			case Pstate is
			when s0 	=>
				Nstate <= s1;
				selMux <= "000";
				selReg <= "00000000"; --não registra nenhum valor
				
			when s1 	=>
				Nstate <= s2;
				selMux <= "000"; --seleciona a entrada sel + 1
				selReg <= "00000001";
				
			when s2 		=>
				Nstate <= s3;
				selMux <= "001";
				selReg <= "00000010";
				
			when s3 	=>
				Nstate <= s4;
				selMux <= "010";
				selReg <= "00000100";
				
			when s4 	=>
				Nstate <= s5;
				selMux <= "011";
				selReg <= "00001000";
				
			when s5 	=>
				Nstate <= s6;
				selMux <= "100";
				selReg <= "00010000";
				
			when s6 	=>
				Nstate <= s7;
				selMux <= "101";
				selReg <= "00100000";
				
			when s7 	=>
				Nstate <= s8;
				selMux <= "110";
				selReg <= "01000000";
				
			when s8 	=>
				Nstate <= s1;
				selMux <= "111";
				selReg <= "10000000";
			end case;
	end process;

end FSM;