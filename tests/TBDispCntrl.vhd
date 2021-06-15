library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity TBDispCntrl is
end TBDispCntrl;

architecture simulation of TBDispCntrl is
	signal CLOCK_50, s_En, s_res : std_logic;
	signal s_selMux : std_logic_vector(2 downto 0);
	signal s_selReg : std_logic_vector(6 downto 0);
	constant cycle : time := 20 ns;
	constant s : time := 1000000000 ns;

begin

clock : process
begin
	CLOCK_50 <= '0';
	wait for cycle/2;
	CLOCK_50 <= '1';
	wait for cycle/2;
end process;

stim : process
begin
	s_En <= '0';
	wait for s;
	s_En <= '1';
	wait for s;
	s_res <= '1';
	wait for 5 s;
	s_res <= '0';
end process;

uut : entity work.DispCntrl(Behavioral)
port map(clk => CLOCK_50,
			res => s_res,
			En  => s_En,
			selMux => s_selMux,
			selReg => s_selReg,
			dispStart=>'1',
			dispBusy => open);


end simulation;