library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity calendario2 is
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
		  LEDG		: out std_logic_vector(3 downto 0);
		  LEDR		: out std_logic_vector(17 downto 6));
end calendario2;

architecture Structural of calendario2 is
signal s_Res, s_progClk, s_timeClk, s_dispClk: std_logic;
signal s_key : std_logic_vector(2 downto 0);

signal s_dayTerm, s_monthTerm, s_year1Term, s_year2Term, s_year3Term : std_logic := '0';
signal s_dayEn, s_monthEn, s_year1En, s_year2En, s_year3En, s_year4En : std_logic := '0';

signal s_selMux : std_logic_vector(2 downto 0);

signal s_max_days : std_logic_vector(4 downto 0);
signal s_max_en : std_logic;

signal s_day, s_month : std_logic_vector(4 downto 0);
signal s_data : std_logic_vector(3 downto 0);
signal s_year1, s_year2, s_year3, s_year4 : std_logic_vector(3 downto 0);
signal s_day_units, s_day_tens, s_month_units, s_month_tens : std_logic_vector(3 downto 0);
signal s_year_units, s_year_tens, s_year_hund, s_year_thou : std_logic_vector(3 downto 0);

signal s_dispBusy, s_progBusy, s_dispStart, s_progStart : std_logic := '0';
signal counterSel : std_logic_Vector(5 downto 0);

signal s_decodedValue : std_logic_vector(6 downto 0);
			
signal s_regEn : std_logic_vector(7 downto 0);

begin


	LEDR(16) <= counterSel(0);
	LEDR(13) <= counterSel(1);
	LEDR(10) <= counterSel(2);
	LEDR(9) <= counterSel(3);
	LEDR(8) <= counterSel(4);
	LEDR(7) <= counterSel(5);

	clearSW: process (CLOCK_50)
	begin
		if(rising_edge(CLOCK_50))then
			s_Res	<= SW(0);
		end if;
	end process;
	
	
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

	--só faz enable do próximo quando receber o enable pra si e a contagem dos anteriores todos acabar
	--ou quando o progCntrl mandar incrementar
	s_dayEn	 <= (s_timeClk and not s_progBusy) or (counterSel(0) and s_progBusy);
	s_monthEn <= (s_dayTerm and s_timeClk and not s_progBusy) or (counterSel(1) and s_progBusy);
	s_year1En <= (s_monthEn and s_monthTerm and not s_progBusy) or (counterSel(2) and s_progBusy);
	s_year2En <= (s_year1En and s_year1Term and not s_progBusy) or (counterSel(3) and s_progBusy);
	s_year3En <= (s_year2En and s_year2Term and not s_progBusy) or (counterSel(4) and s_progBusy);
	s_year4En <= (s_year3En and s_year3Term and not s_progBusy) or (counterSel(5) and s_progBusy);
	
	
	
	sync_gen : entity work.SyncGen(RTL)
							port map(clkIn => CLOCK_50,
										progClk => s_progClk,
										timeClk => s_timeClk,
										dispClk => s_dispClk);

	days_control : entity work.daysCntrl(Behavioral) --gera o numero máximo de dias
						  port map(clk			=> CLOCK_50,
									  month 		=> s_month,
									  max_days	=> s_max_days);
	
	
	day_counter : entity work.Counter5(RTL)
							port map(max		=> s_max_days,
										Res		=> s_Res,
										clk		=> CLOCK_50,
										En			=> s_dayEn,
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
	
	
	TheMainCntrl : entity work.mainCntrl(FSM)
							port map(clk 		 => CLOCK_50,
										key0 		 => s_key(0),
										progBusy  => s_progBusy,
										dispBusy	 => s_dispBusy,
										leds 		 => LEDG(3 downto 0),
										progStart => s_progStart,
										dispStart => s_dispStart);
										
	ProgramCntrl : entity work.progCntrl(FSM)
							port map(clk   	 => CLOCK_50,
										progStart => s_progStart,
										en		  	 => s_progClk,
										key	  	 => s_key,
										progBusy  => s_progBusy,
										sel       => counterSel(5 downto 0));
	
	
	
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
