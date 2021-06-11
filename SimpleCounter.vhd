library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity SimpleCounter is --conta de 0 a max
	port(max 		: in std_logic_vector(3 downto 0) := "1001";
		  Res 		: in  std_logic;
		  clk			: in  std_logic;
		  En	      : in  std_logic;
		  Q		   : out std_logic_vector(3 downto 0);
		  TC     	: out std_logic);
end SimpleCounter;

architecture RTL of SimpleCounter is

	signal s_value : unsigned(3 downto 0) := "0000"; --começa  a contagem em 0

begin
	process(Res, clk) --reset assíncrono
	begin
		if (rising_edge(clk)) then
			if (Res = '1') then
				s_value <= "0000"; --quando é feito reset, fica a 0
				TC <= '0';
			elsif (En = '1') then
				if (to_integer(s_value) = to_integer(unsigned(max))) then --volta a 0
					s_value <= "0000";
					TC <= '0';
				else
					s_value <= s_value + 1;
					if (to_integer(s_value) = to_integer(unsigned(max)) - 1) then --terminou a contagem
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
