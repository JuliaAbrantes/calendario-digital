library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity calendario is
	port(SW			: in  std_logic_vector(0 downto 0);
		  CLOCK_50	: in  std_logic;
		  HEX0		: out std_logic_vector(6 downto 0);
		  HEX1		: out std_logic_vector(6 downto 0);
		  HEX2		: out std_logic_vector(6 downto 0);
		  HEX3		: out std_logic_vector(6 downto 0);
		  HEX4		: out std_logic_vector(6 downto 0);
		  HEX5		: out std_logic_vector(6 downto 0);
		  HEX6		: out std_logic_vector(6 downto 0);
		  HEX7		: out std_logic_vector(6 downto 0);
		  LEDG		: out std_logic_vector(0 downto 0));
end calendario;

architecture Structural of calendario is
signal s_Res, s_progClk, s_timeClk, s_dispClk: std_logic;

signal s_dayTerm, s_monthTerm, s_year1Term, s_year2Term, s_year3Term : std_logic := '0';
signal s_monthEn, s_year1En, s_year2En, s_year3En, s_year4En : std_logic := '0';

signal s_selMux : std_logic_vector(2 downto 0);

signal s_max_days : std_logic_vector(4 downto 0);
signal s_max_en : std_logic;

signal s_day : std_logic_vector(4 downto 0);
signal s_month, s_data : std_logic_vector(3 downto 0);
signal s_year1, s_year2, s_year3, s_year4 : std_logic_vector(3 downto 0);
signal s_day_units, s_day_tens, s_month_units, s_month_tens : std_logic_vector(3 downto 0);
signal s_year_units, s_year_tens, s_year_hund, s_year_thou : std_logic_vector(3 downto 0);

signal s_decodedValue1, s_decodedValue2, s_decodedValue3, s_decodedValue4, 
			s_decodedValue5, s_decodedValue6, s_decodedValue7, s_decodedValue8 : std_logic_vector(6 downto 0); --provisório
			
signal s_regEn : std_logic_vector(7 downto 0); --usamos um vetor ou sinais com nomes separados?
signal regEn_day_units, regEn_day_tens,
		 regEn_month_units, regEn_month_tens,
		 regEn_year_units, regEn_year_tens,
		 regEn_year_hund, regEn_year_thou : std_logic;

begin

	entrada: process (CLOCK_50)
	begin
		if(rising_edge(CLOCK_50))then
			s_Res	<= SW(0);
		end if;
	end process;
	
	
	enables: process (CLOCK_50)
	begin
		if(rising_edge(CLOCK_50))then
			s_monthEn <= s_dayTerm;
			s_year1En <= s_dayTerm and s_monthTerm;
			s_year2En <= s_dayTerm and s_monthTerm and s_year1Term;
			s_year3En <= s_dayTerm and s_monthTerm and s_year1Term and s_year2Term;
			s_year4En <= s_dayTerm and s_monthTerm and s_year1Term and s_year2Term and s_year3Term;
		end if;
	end process;
	
	
	sync_gen : entity work.SyncGen(RTL)
							port map(clkIn => CLOCK_50,
										progClk => s_progClk,
										timeClk => s_timeClk,
										dispClk => s_dispClk);
	LEDG(0) <= s_timeClk; --provisório

	
--	days_control : entity work.daysCntrl(Behavioral)
--						  port map(clk			=> CLOCK_50,
--									  month 		=> s_month, --unsigned
--									  max_days	=> s_max_days); --natural
	
	
	s_max_days <=  std_logic_vector(to_unsigned(31,5));
	day_counter : entity work.Counter5(RTL)
							port map(max		=> s_max_days,
										Res		=> s_Res,
										clk		=> CLOCK_50,
										En			=> s_timeClk,
										Q			=> s_day,
										TC			=> s_dayTerm);
										
	bcd_dayEncoder : entity work.BinToBCD(Behavioral)
							generic map(Nbits => 5)
							port map(Bin => s_day,
										units_out => s_day_units,
										tens_out  => s_day_tens);
							
							
	month_counter : entity work.Counter4(RTL)
							port map(max		=> std_logic_vector(to_unsigned(12,4)),
										Res		=> s_Res,
										clk		=> CLOCK_50,
										En			=> s_monthEn,
										Q			=> s_month,
										TC			=> s_monthTerm);
										
	bcd_MonthEncoder : entity work.BinToBCD(Behavioral) --generico 4 por defeito
							port map(Bin 		=> s_month,
										units_out=> s_month_units,
										tens_out => s_month_tens);
										
						
	year1_counter : entity work.SimpleCounter(RTL) --year units
							port map(max		=> std_logic_vector(to_unsigned(9,4)),
										Res		=> s_Res,
										clk		=> CLOCK_50,
										En			=> s_year1En,
										Q			=> s_year_units,
										TC			=> s_year1Term);
					
					
	year2_counter : entity work.SimpleCounter(RTL) --year tens
							port map(max		=> std_logic_vector(to_unsigned(9,4)),
										Res		=> s_Res,
										clk		=> CLOCK_50,
										En			=> s_year2En,
										Q			=> s_year_tens,
										TC			=> s_year2Term);
					
					
	year3_counter : entity work.SimpleCounter(RTL) --year hundreds
							port map(max		=> std_logic_vector(to_unsigned(9,4)),
										Res		=> s_Res,
										clk		=> CLOCK_50,
										En			=> s_year3En,
										Q			=> s_year_hund,
										TC			=> s_year3Term);
					
										
	year4_counter : entity work.SimpleCounter(RTL) --year thousands
							port map(max		=> std_logic_vector(to_unsigned(9,4)),
										Res		=> s_Res,
										clk		=> CLOCK_50,
										En			=> s_year4En,
										Q			=> s_year_thou,
										TC			=> open);
	
	
	
	
	
	
--	dispUpdate : entity work.DispCntrl(FSM)
--							port map(clk 		=> CLOCK_50,
--										En 		=> s_dispClk,
--										selMux 	=> s_selMux,
--										selReg	=> s_regEn);
--										
--	
--	 regEn_day_units 		<= s_regEn(0); --separa s_regEn em sinais de En diferentes --provisório
--	 regEn_day_tens 		<= s_regEn(1);
--	 regEn_month_units 	<= s_regEn(2);
--	 regEn_month_tens 	<= s_regEn(3);
--	 regEn_year_units 	<= s_regEn(4);
--	 regEn_year_tens 		<= s_regEn(5);
--	 regEn_year_hund 		<= s_regEn(6);
--	 regEn_year_thou 		<= s_regEn(7);	 
	
										
--	multiplexer : entity work.Mux8(Behavioral)
--							port map( sel 		=> s_selMux,
--										 Din1 	=> s_day_units,
--										 Din2 	=> s_day_tens,
--										 Din3 	=> s_month_units,
--										 Din4 	=> s_month_tens,
--										 Din5 	=> s_year_units,
--										 Din6 	=> s_year_tens,
--										 Din7 	=> s_year_hund,
--										 Din8 	=> s_year_thou,
--										 DataOut => s_data);
	
	
--	Decoder : entity work.Bin7SegDecoder(Behavioral)
--							port map(binInput	=> s_data,
--										decOut_n	=> s_decodedValue);
										
--	Reg_day_units : entity work.Register7(Behavioral)
--							port map(Res 		=> s_Res,
--										clk 		=> CLOCK_50,
--										En 		=> regEn_day_units,
--										D 			=> s_decodedValue,
--										Q 			=> HEX6);
--										
--										
--	Reg_day_tens : entity work.Register7(Behavioral)
--							port map(Res 		=> s_Res,
--										clk 		=> CLOCK_50,
--										En 		=> regEn_day_tens,
--										D 			=> s_decodedValue,
--										Q 			=> HEX7);
--										
--										
--	Reg_month_units : entity work.Register7(Behavioral)
--							port map(Res 		=> s_Res,
--										clk 		=> CLOCK_50,
--										En 		=> regEn_month_units,
--										D 			=> s_decodedValue,
--										Q 			=> HEX4);
--										
--										
--	Reg_month_tens : entity work.Register7(Behavioral)
--							port map(Res 		=> s_Res,
--										clk 		=> CLOCK_50,
--										En 		=> regEn_month_tens,
--										D 			=> s_decodedValue,
--										Q 			=> HEX5);
--										
--										
--	Reg_year_units : entity work.Register7(Behavioral)
--							port map(Res 		=> s_Res,
--										clk 		=> CLOCK_50,
--										En 		=> regEn_year_units,
--										D 			=> s_decodedValue,
--										Q 			=> HEX0);
--										
--										
--	Reg_year_tens : entity work.Register7(Behavioral)
--							port map(Res 		=> s_Res,
--										clk 		=> CLOCK_50,
--										En 		=> regEn_year_tens,
--										D 			=> s_decodedValue,
--										Q 			=> HEX1);
--										
--										
--	Reg_year_hund : entity work.Register7(Behavioral)
--							port map(Res 		=> s_Res,
--										clk 		=> CLOCK_50,
--										En 		=> regEn_year_hund,
--										D 			=> s_decodedValue,
--										Q 			=> HEX2);
--										
--										
--	Reg_year_thou : entity work.Register7(Behavioral)
--							port map(Res 		=> s_Res,
--										clk 		=> CLOCK_50,
--										En 		=> regEn_year_thou,
--										D 			=> s_decodedValue,
--										Q 			=> HEX3);
										
	Decoder1 : entity work.Bin7SegDecoder(Behavioral) --provisório
							port map(binInput	=> s_day_units,
										decOut_n	=> s_decodedValue1);
										
	Decoder2 : entity work.Bin7SegDecoder(Behavioral) --provisório
							port map(binInput	=> s_day_tens,
										decOut_n	=> s_decodedValue2);
										
	Decoder3 : entity work.Bin7SegDecoder(Behavioral) --provisório
							port map(binInput	=> s_month_units,
										decOut_n	=> s_decodedValue3);
										
	Decoder4 : entity work.Bin7SegDecoder(Behavioral) --provisório
							port map(binInput	=> s_month_tens,
										decOut_n	=> s_decodedValue4);
										
	Decoder5 : entity work.Bin7SegDecoder(Behavioral) --provisório
							port map(binInput	=> s_year_units,
										decOut_n	=> s_decodedValue5);
										
	Decoder6 : entity work.Bin7SegDecoder(Behavioral) --provisório
							port map(binInput	=> s_year_tens,
										decOut_n	=> s_decodedValue6);
										
	Decoder7 : entity work.Bin7SegDecoder(Behavioral) --provisório
							port map(binInput	=> s_year_hund,
										decOut_n	=> s_decodedValue7);
										
	Decoder8 : entity work.Bin7SegDecoder(Behavioral) --provisório
							port map(binInput	=> s_year_thou,
										decOut_n	=> s_decodedValue8);


	Reg_day_units : entity work.Register7(Behavioral)
							port map(Res 		=> s_Res,
										clk 		=> CLOCK_50,
										En 		=> '1',
										D 			=> s_decodedValue1,
										Q 			=> HEX6);
										
										
	Reg_day_tens : entity work.Register7(Behavioral)
							port map(Res 		=> s_Res,
										clk 		=> CLOCK_50,
										En 		=> '1',
										D 			=> s_decodedValue2,
										Q 			=> HEX7);
										
										
	Reg_month_units : entity work.Register7(Behavioral)
							port map(Res 		=> s_Res,
										clk 		=> CLOCK_50,
										En 		=> '1',
										D 			=> s_decodedValue3,
										Q 			=> HEX4);
										
										
	Reg_month_tens : entity work.Register7(Behavioral)
							port map(Res 		=> s_Res,
										clk 		=> CLOCK_50,
										En 		=> '1',
										D 			=> s_decodedValue4,
										Q 			=> HEX5);
										
										
	Reg_year_units : entity work.Register7(Behavioral)
							port map(Res 		=> s_Res,
										clk 		=> CLOCK_50,
										En 		=> '1',
										D 			=> s_decodedValue5,
										Q 			=> HEX0);
										
										
	Reg_year_tens : entity work.Register7(Behavioral)
							port map(Res 		=> s_Res,
										clk 		=> CLOCK_50,
										En 		=> '1',
										D 			=> s_decodedValue6,
										Q 			=> HEX1);
										
										
	Reg_year_hund : entity work.Register7(Behavioral)
							port map(Res 		=> s_Res,
										clk 		=> CLOCK_50,
										En 		=> '1',
										D 			=> s_decodedValue7,
										Q 			=> HEX2);
										
										
	Reg_year_thou : entity work.Register7(Behavioral)
							port map(Res 		=> s_Res,
										clk 		=> CLOCK_50,
										En 		=> '1',
										D 			=> s_decodedValue8,
										Q 			=> HEX3);


	
	
end Structural;
