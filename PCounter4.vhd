library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity PCounter4 is
	generic(MAX		: natural := 9);
	port(Res		: in  std_logic;
		  clk			: in  std_logic;
--		  enable1	: in  std_logic;
--		  enable2	: in  std_logic;
		  En	      : in  std_logic;
		  Q		   : out std_logic_vector(3 downto 0);
		  TC     	: out std_logic);
end PCounter4;

architecture RTL of PCounter4 is

	signal s_value : unsigned(3 downto 0);

begin
	process(Res, clk)
	begin	
		if (rising_edge(clk)) then
			if (Res = '1') then
				s_value <= (others => '0');
				TC <= '0';
--			elsif ((enable1 = '1') and (enable2 = '1')) then
			elsif (En = '1') then
				if (to_integer(s_value) = MAX) then
					s_value <= (others => '0');
					TC <= '0';
				else
					s_value <= s_value + 1;
					if (to_integer(s_value) = MAX - 1) then
						TC <= '1';
					else
						TC <= '0';
					end if;
				end if;
			end if;
		end if;
	end process;

	Q <= std_logic_vector(s_value);
end RTL;
