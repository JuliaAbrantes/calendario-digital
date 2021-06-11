library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;


entity TBcalendario is
end TBcalendario;


architecture simulation of TBcalendario is

	signal s_SW, s_LEDG : std_logic_vector(0 downto 0);
	signal s_HEX0, s_HEX1, s_HEX2, s_HEX3, s_HEX4,
			 s_HEX5,	 s_HEX6,  s_HEX7: std_logic_vector(6 downto 0);
	signal clk : std_logic;
	constant cycle : time := 20 ns;

begin

	clock: process
	begin
		clk <= '0';
		wait for cycle/2;
		clk <= '1';
		wait for cycle/2;
	end process;
	
	
	stim : process
	begin
		wait for cycle * 100;
		s_SW <= "1";
		wait for cycle;
		s_SW <= "0";
	end process;


	uut: entity work.calendario(Structural)
	port map( SW 		=> s_SW,
				 CLOCK_50=> clk,
				 HEX0		=> s_HEX0,
				 HEX1		=> s_HEX1,
				 HEX2		=> s_HEX2,
				 HEX3		=> s_HEX3,
				 HEX4		=> s_HEX4,
				 HEX5		=> s_HEX5,
				 HEX6		=> s_HEX6,
				 HEX7		=> s_HEX7,
				 LEDG 	=> s_LEDG);

end simulation;