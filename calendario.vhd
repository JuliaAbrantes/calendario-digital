library IEEE;
use IEEE.STD_LOGIC_1164.all;

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
signal s_dayTerm, s_monthTerm : std_logic;
signal s_year1Term, s_year2Term, s_year3Term : std_logic;
signal s_selMux : std_logic_vector(2 downto 0);

signal regEn_day_units, regEn_day_tens : std_logic;
signal regEn_month_units, regEn_month_tens : std_logic;
signal regEn_year_units, regEn_year_tens : std_logic;
signal regEn_year_hund, regEn_year_thou : std_logic;

--signal s_max_days : std_logic_vector(4 downto 0);
signal s_max_days : natural;
signal s_max_en : std_logic;

signal s_day, s_month, s_data : std_logic_vector(3 downto 0);
signal s_year1, s_year2, s_year3, s_year4 : std_logic_vector(3 downto 0);
signal s_day_units, s_day_tens, s_month_units, s_month_tens : std_logic_vector(3 downto 0);
signal s_year_units, s_year_tens, s_year_hund, s_year_thou : std_logic_vector(3 downto 0);
signal s_decodedValue : std_logic_vector(6 downto 0);
signal s_regEn : std_logic_vector(7 downto 0);

begin
	s_Res	<= not SW(0); --provisório
	
	
	sync_gen : entity work.SyncGen(RTL)
							port map(clkIn => CLOCK_50,
										progClk => s_progClk,
										timeClk => s_timeClk,
										dispClk => s_dispClk);
	LEDG(0) <= s_timeClk; --provisório

	
--	days_control : entity work.mainCntrl(Behavioral)
--						  port map(clk			=> CLOCK_50,
--									  TCmonth	=> s_dayTerm,
--									  max_days	=> s_max_days,
--									  max_en		=> s_max_en);
	
	

	day_counter : entity work.Counter5(RTL)
							port map(max		=> s_max_days,
										loadEn	=> s_max_en,
										Res		=> s_Res,
										clk		=> CLOCK_50,
										En			=> s_timeClk,
										Q			=> s_day,
										TC			=> s_dayTerm);
										
	bcd_dayEncoder : entity work.BinToBCD(Behavioral)
							port map(Bin => s_day,
										units_out => s_day_units,
										tens_out  => s_day_tens);
							
							
										
	month_counter : entity work.Counter4(RTL)
							port map(max		=> 12,
										Res		=> s_Res,
										clk		=> CLOCK_50,
										En			=> s_dayTerm,
										Q			=> s_month,
										TC			=> s_monthTerm);
										
	bcd_MonthEncoder : entity work.BinToBCD(Behavioral)
							port map(Bin 		=> s_month,
										units_out=> s_month_units,
										tens_out => s_month_tens);
										
						
						
	year1_counter : entity work.SimpleCounter(RTL) --year units
							port map(max		=> 9,
										Res		=> s_Res,
										clk		=> CLOCK_50,
										En			=> s_monthTerm,
										Q			=> s_year1,
										TC			=> s_year1Term);
										
	bcd_Year1Encoder : entity work.BinToBCD(Behavioral)
							port map(Bin 		=> s_year1,
										units_out=> s_year_units,
										tens_out => open);
										
					
					
	year2_counter : entity work.SimpleCounter(RTL) --year tens
							port map(max		=> 9,
										Res		=> s_Res,
										clk		=> CLOCK_50,
										En			=> s_year1Term,
										Q			=> s_year2,
										TC			=> s_year2Term);
										
	bcd_Year2Encoder : entity work.BinToBCD(Behavioral)
							port map(Bin 		=> s_year2,
										units_out=> s_year_tens,
										tens_out => open);
										
					
					
	year3_counter : entity work.SimpleCounter(RTL) --year hundreds
							port map(max		=> 9,
										Res		=> s_Res,
										clk		=> CLOCK_50,
										En			=> s_year2Term,
										Q			=> s_year3,
										TC			=> s_year3Term);
										
	bcd_Year3Encoder : entity work.BinToBCD(Behavioral)
							port map(Bin 		=> s_year3,
										units_out=> s_year_hund,
										tens_out => open);
					
					
										
	year4_counter : entity work.SimpleCounter(RTL) --year thousands
							port map(max		=> 9,
										Res		=> s_Res,
										clk		=> CLOCK_50,
										En			=> s_year3Term,
										Q			=> s_year4,
										TC			=> open);
										
	bcd_Year4Encoder : entity work.BinToBCD(Behavioral)
							port map(Bin 		=> s_year4,
										units_out=> s_year_thou,
										tens_out => open);
	
	
	
	
	
	
	dispUpdate : entity work.DispCntrl(FSM)
							port map(clk 		=> CLOCK_50,
										En 		=> s_dispClk,
										selMux 	=> s_selMux,
										selReg	=> s_regEn);
										
	
	 regEn_day_units 		<= s_regEn(0); --separa s_regEn em sinais de En diferentes --provisório
	 regEn_day_tens 		<= s_regEn(1);
	 regEn_month_units 	<= s_regEn(2);
	 regEn_month_tens 	<= s_regEn(3);
	 regEn_year_units 	<= s_regEn(4);
	 regEn_year_tens 		<= s_regEn(5);
	 regEn_year_hund 		<= s_regEn(6);
	 regEn_year_thou 		<= s_regEn(7);	 
	
										
	multiplexer : entity work.Mux8(Behavioral)
							port map( sel 		=> s_selMux,
										 Din1 	=> s_day_units,
										 Din2 	=> s_day_tens,
										 Din3 	=> s_month_units,
										 Din4 	=> s_month_tens,
										 Din5 	=> s_year_units,
										 Din6 	=> s_year_tens,
										 Din7 	=> s_year_hund,
										 Din8 	=> s_year_thou,
										 DataOut => s_data);
	
	
	Decoder : entity work.Bin7SegDecoder(Behavioral)
							port map(binInput	=> s_data,
										decOut_n	=> s_decodedValue);
										
			
	Reg_day_units : entity work.Register7(Behavioral)
							port map(Res 		=> s_Res,
										clk 		=> CLOCK_50,
										En 		=> regEn_day_units,
										D 			=> s_decodedValue,
										Q 			=> HEX0);
										
										
	Reg_day_tens : entity work.Register7(Behavioral)
							port map(Res 		=> s_Res,
										clk 		=> CLOCK_50,
										En 		=> regEn_day_tens,
										D 			=> s_decodedValue,
										Q 			=> HEX1);
										
										
	Reg_month_units : entity work.Register7(Behavioral)
							port map(Res 		=> s_Res,
										clk 		=> CLOCK_50,
										En 		=> regEn_month_units,
										D 			=> s_decodedValue,
										Q 			=> HEX2);
										
										
	Reg_month_tens : entity work.Register7(Behavioral)
							port map(Res 		=> s_Res,
										clk 		=> CLOCK_50,
										En 		=> regEn_month_tens,
										D 			=> s_decodedValue,
										Q 			=> HEX3);
										
										
	Reg_year_units : entity work.Register7(Behavioral)
							port map(Res 		=> s_Res,
										clk 		=> CLOCK_50,
										En 		=> regEn_year_units,
										D 			=> s_decodedValue,
										Q 			=> HEX4);
										
										
	Reg_year_tens : entity work.Register7(Behavioral)
							port map(Res 		=> s_Res,
										clk 		=> CLOCK_50,
										En 		=> regEn_year_tens,
										D 			=> s_decodedValue,
										Q 			=> HEX5);
										
										
	Reg_year_hund : entity work.Register7(Behavioral)
							port map(Res 		=> s_Res,
										clk 		=> CLOCK_50,
										En 		=> regEn_year_hund,
										D 			=> s_decodedValue,
										Q 			=> HEX6);
										
										
	Reg_year_thou : entity work.Register7(Behavioral)
							port map(Res 		=> s_Res,
										clk 		=> CLOCK_50,
										En 		=> regEn_year_thou,
										D 			=> s_decodedValue,
										Q 			=> HEX7);
	
	
end Structural;
