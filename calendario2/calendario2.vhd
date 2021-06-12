library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity calendario is
	port(SW			: in  std_logic_vector(0 downto 0);
		  KEY			: in  std_logic_vector(2 downto 0);
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
signal s_key : std_logic_vector(2 downto 0);
signal s_mode : std_logic := '0'; --0 é run e 1 é program

signal s_dayTerm, s_monthTerm, s_year1Term, s_year2Term, s_year3Term : std_logic := '0';
signal s_monthEn, s_year1En, s_year2En, s_year3En, s_year4En : std_logic := '0';

signal s_selMux : std_logic_vector(2 downto 0);

signal s_max_days : std_logic_vector(4 downto 0);
signal s_max_en : std_logic;

signal s_day, s_month : std_logic_vector(4 downto 0);
signal s_data : std_logic_vector(3 downto 0);
signal s_year1, s_year2, s_year3, s_year4 : std_logic_vector(3 downto 0);
signal s_day_units, s_day_tens, s_month_units, s_month_tens : std_logic_vector(3 downto 0);
signal s_year_units, s_year_tens, s_year_hund, s_year_thou : std_logic_vector(3 downto 0);

signal s_decodedValue : std_logic_vector(6 downto 0);
--signal s_decodedValue1, s_decodedValue2, s_decodedValue3, s_decodedValue4, 
--			s_decodedValue5, s_decodedValue6, s_decodedValue7, s_decodedValue8 : std_logic_vector(6 downto 0); --provisório
			
signal s_regEn : std_logic_vector(7 downto 0);

begin
	s_mode <= '0'; --provisório

	clearSW: process (CLOCK_50)
	begin
		if(rising_edge(CLOCK_50))then
			s_Res	<= SW(0);
		end if;
	end process;

	--só faz enable do próximo quando receber o enable pra si e a contagem dos anteriores todos acabar
	s_monthEn <= (s_dayTerm and s_timeClk and not s_mode);
	s_year1En <= (s_monthEn and s_monthTerm and not s_mode);
	s_year2En <= (s_year1En and s_year1Term and not s_mode);
	s_year3En <= (s_year2En and s_year2Term and not s_mode);
	s_year4En <= (s_year3En and s_year3Term and not s_mode);
	
	
--debouncers
	key0: entity work.DebounceUnit(Behavioral)
	generic map(kHzClkFreq		=> 50000,
	            mSecMinInWidth => 100,
			      inPolarity		=> '0',
			      outPolarity		=>'1')
	port map (refClk	  	=>  CLOCK_50,
		       dirtyIn		=>  KEY(0),
		       pulsedOut	=>  s_key(0));
 
  key1: entity work.DebounceUnit(Behavioral)
	generic map(kHzClkFreq		=> 50000,
	            mSecMinInWidth => 100,
			      inPolarity		=> '0',
			      outPolarity		=>'1')
	port map (refClk	  	=>  CLOCK_50,
		       dirtyIn		=>  KEY(1),
		       pulsedOut	=>  s_key(1));
		 
   key2: entity work.DebounceUnit(Behavioral)
	generic map(kHzClkFreq		=> 50000,
	            mSecMinInWidth => 100,
			      inPolarity		=> '0',
			      outPolarity		=>'1')	
	port map (refClk	  	=>  CLOCK_50,
		       dirtyIn		=>  KEY(2),
		       pulsedOut	=>  s_key(2));
	
	
	
	
	sync_gen : entity work.SyncGen(RTL)
							port map(clkIn => CLOCK_50,
										progClk => s_progClk,
										timeClk => s_timeClk,
										dispClk => s_dispClk);
	LEDG(0) <= s_timeClk; --provisório

	
--	days_control : entity work.daysCntrl(Behavioral) --gera o numero máximo de dias
--						  port map(clk			=> CLOCK_50,
--									  month 		=> s_month, --unsigned
--									  max_days	=> s_max_days); --natural
	
	
	s_max_days <=  std_logic_vector(to_unsigned(31,5)); --provisório
	day_counter : entity work.Counter5(RTL)
							port map(max		=> s_max_days,
										Res		=> s_Res,
										clk		=> CLOCK_50,
										En			=> s_timeClk,
										Q			=> s_day,
										TC			=> s_dayTerm);
										
	bcd_dayEncoder : entity work.BinToBCD(Behavioral) 
	--Nbits é 5 por defeito
							port map(Bin => s_day,
										units_out => s_day_units,
										tens_out  => s_day_tens);
							
							
	month_counter : entity work.Counter5(RTL)
							port map(max		=> std_logic_vector(to_unsigned(12,5)),
										Res		=> s_Res,
										clk		=> CLOCK_50,
										En			=> s_monthEn,
										Q			=> s_month,
										TC			=> s_monthTerm);
										
	bcd_MonthEncoder : entity work.BinToBCD(Behavioral)
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
	
	
	
	
	
	UpdateDisplay : entity work.DispCntrl(FSM)
							port map(clk 		=> CLOCK_50,
										En 		=> s_dispClk,
										selMux 	=> s_selMux,
										selReg	=> s_regEn);

 
	
										
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
										En 		=> s_regEn(0),
										D 			=> s_decodedValue,
										Q 			=> HEX6);
										
										
	Reg_day_tens : entity work.Register7(Behavioral)
							port map(Res 		=> s_Res,
										clk 		=> CLOCK_50,
										En 		=> s_regEn(1),
										D 			=> s_decodedValue,
										Q 			=> HEX7);
										
										
	Reg_month_units : entity work.Register7(Behavioral)
							port map(Res 		=> s_Res,
										clk 		=> CLOCK_50,
										En 		=> s_regEn(2),
										D 			=> s_decodedValue,
										Q 			=> HEX4);
										
										
	Reg_month_tens : entity work.Register7(Behavioral)
							port map(Res 		=> s_Res,
										clk 		=> CLOCK_50,
										En 		=> s_regEn(3),
										D 			=> s_decodedValue,
										Q 			=> HEX5);
										
										
	Reg_year_units : entity work.Register7(Behavioral)
							port map(Res 		=> s_Res,
										clk 		=> CLOCK_50,
										En 		=> s_regEn(4),
										D 			=> s_decodedValue,
										Q 			=> HEX0);
										
										
	Reg_year_tens : entity work.Register7(Behavioral)
							port map(Res 		=> s_Res,
										clk 		=> CLOCK_50,
										En 		=> s_regEn(5),
										D 			=> s_decodedValue,
										Q 			=> HEX1);
										
										
	Reg_year_hund : entity work.Register7(Behavioral)
							port map(Res 		=> s_Res,
										clk 		=> CLOCK_50,
										En 		=> s_regEn(6),
										D 			=> s_decodedValue,
										Q 			=> HEX2);
										
										
	Reg_year_thou : entity work.Register7(Behavioral)
							port map(Res 		=> s_Res,
										clk 		=> CLOCK_50,
										En 		=> s_regEn(7),
										D 			=> s_decodedValue,
										Q 			=> HEX3);

	
	
end Structural;
