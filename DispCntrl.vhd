library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity DispCntrl is
	port(clk : in std_logic;
		  En : in std_logic;
		  sel : out std_logic_vector(2 downto 0));
end DispCntrl;


architecture FSM of DispCntrl is
type Tstate is (s1, s2, s3, s4, s5, s6, s7, s8);
signal Pstate, Nstate : Tstate := s1;
begin
	sequencical : process(clk) --determina o próximo estado
	begin
		if(rising_edge(clk))then
		
			case Pstate is
			when s1 	=>
				Nstate <= s2;
				
			when s2 		=>
				Nstate <= s3;
				
			when s3 	=>
				Nstate <= s4;
				
			when s4 	=>
				Nstate <= s5;
				
			when s5 	=>
				Nstate <= s6;
				
			when s6 	=>
				Nstate <= s7;
				
			when s7 		=>
				Nstate <= s8;
				
			when s8 	=>
				Nstate <= s1;
			end case;
			
		end if;
	end process;
	
	
	combinational : process --determina a saídaw
	begin
			case Pstate is
			when s1 	=>
				sel <= "000"; --seleciona a entrada sel + 1
				
			when s2 		=>
				sel <= "001";
				
			when s3 	=>
				sel <= "010";
				
			when s4 	=>
				sel <= "011";
				
			when s5 	=>
				sel <= "100";
				
			when s6 	=>
				sel <= "101";
				
			when s7 		=>
				sel <= "110";
				
			when s8 	=>
				sel <= "111";
			end case;
	end process;

end FSM;