library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity Counter4 is --conta de 1 a 9
	port(max 		: in natural := 9;
		  Res 		: in  std_logic;
		  clk			: in  std_logic;
--		  enable1	: in  std_logic;
--		  enable2	: in  std_logic;
		  En	      : in  std_logic;
		  Q		   : out std_logic_vector(3 downto 0);
		  TC     	: out std_logic);
end Counter4;

architecture RTL of Counter4 is

	signal s_value : unsigned(3 downto 0) := "0001"; --começa  a contagem em 1

begin
	process(Res, clk)
	begin	
		if (rising_edge(clk)) then
			if (Res = '1') then
--				s_value <= (others => '0');
				s_value <= "0000"; --quando é feito reset, fica com 0
				TC <= '0';
--			elsif ((enable1 = '1') and (enable2 = '1')) then
			elsif (En = '1') then
				if (to_integer(s_value) = max) then
--					s_value <= (others => '0');
					s_value <= "0001";
					TC <= '0';
				else
					s_value <= s_value + 1;
					if (to_integer(s_value) = max - 1) then
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
