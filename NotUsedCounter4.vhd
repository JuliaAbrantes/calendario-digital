library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity Counter4 is --conta de 1 a max
	port(max 		: in std_logic_vector(3 downto 0);
		  Res 		: in  std_logic;
		  clk			: in  std_logic;
		  En	      : in  std_logic;
		  Q		   : out std_logic_vector(3 downto 0);
		  TC     	: out std_logic);
end Counter4;

architecture RTL of Counter4 is

	signal s_value : integer := 1; --começa  a contagem em 1

begin
	process(Res, clk) --reset assíncrono
	begin
		if (rising_edge(clk)) then
			if (Res = '1') then
				s_value <= 1; --quando é feito reset, fica a 1
				TC <= '0';
			elsif (En = '1') then
				if ( s_value = to_integer(unsigned(max))) then --volta a 1
					s_value <= 1;
					TC <= '0';
				else
					s_value <= s_value + 1;
					if ( s_value = to_integer(unsigned(max)) - 1) then --terminou a contagem
						TC <= '1';
					else
						TC <= '0';
					end if;
				end if;
			end if;
			
		end if;
		
	end process;

	Q <= std_logic_vector(to_unsigned(s_value,4));
end RTL;