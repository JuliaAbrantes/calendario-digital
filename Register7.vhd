library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity Register7 is
port (Res : in std_logic;
		clk : in std_logic;
		En  : in std_logic;
		D	 : in std_logic_vector(6 downto 0) := "1111111";
		Q   : out std_logic_vector(6 downto 0));
end Register7;


architecture Behavioral of Register7 is
begin

	process(clk)
	begin
		if(rising_edge(clk)) then
			if(Res = '1') then
				Q <= (others => '0');
			elsif(En = '1') then
				Q <= D;
			end if;
		end if;
	
	end process;

end Behavioral;