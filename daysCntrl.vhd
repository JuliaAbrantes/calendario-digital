library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
	
entity daysCntrl is
port(clk			: in std_logic;
	 month 		: in std_logic_vector(4 downto 0);
	 max_days	: out std_logic_vector(4 downto 0));
end daysCntrl;
	 
architecture Behavioral of daysCntrl is
	signal s_month : integer;
	constant days30 : std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(30,5));
	constant days31 : std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(31,5));
	constant days28 : std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(28,5));
begin
	process(clk)
   begin
    if (rising_edge(clk)) then
	    s_month <= to_integer(unsigned(month));
		 if (s_month=2) then 
			max_days <= days28;
		 elsif (s_month=4 or s_month=6 or s_month=9 or s_month=11) then
			max_days <= days30;
		 else
			max_days <= days31;
		 end if;
		 
		end if;
	end process;
end Behavioral;