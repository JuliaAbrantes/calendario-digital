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
		  HEX7		: out std_logic_vector(6 downto 0));
end calendario;

architecture Structural of calendario is
	signal s_Res, s_timeClk, s_dispClk: std_logic;

	signal s_dayTerm, s_monthTerm, s_year1Term, s_year2Term, s_year3Term : std_logic := '0'; --fins e inicios da contagem
	signal s_monthEn, s_year1En, s_year2En, s_year3En, s_year4En : std_logic := '0';

	signal s_max_days : std_logic_vector(4 downto 0);

	signal s_day, s_month : std_logic_vector(4 downto 0);
	signal s_data : std_logic_vector(3 downto 0);
	signal s_year1, s_year2, s_year3, s_year4 : std_logic_vector(3 downto 0);
	signal s_day_units, s_day_tens, s_month_units, s_month_tens : std_logic_vector(3 downto 0); --valores
	signal s_year_units, s_year_tens, s_year_hund, s_year_thou : std_logic_vector(3 downto 0);

	signal s_selMux : std_logic_vector(2 downto 0);
	signal s_decodedValue : std_logic_vector(6 downto 0);
	signal s_regEn : std_logic_vector(7 downto 0);

begin

	clearSW: process (CLOCK_50)
	begin
		if(rising_edge(CLOCK_50))then
			s_Res	<= SW(0);
		end if;
	end process;


	enables: process (CLOCK_50)
	begin
		if(rising_edge(CLOCK_50))then
			s_monthEn <= s_dayTerm and s_timeClk;
			s_year1En <= s_monthTerm and s_dayTerm and s_timeClk;
			s_year2En <= s_year1Term and s_monthTerm and s_dayTerm and s_timeClk;
			s_year3En <= s_year2Term and s_year1Term and s_monthTerm and s_dayTerm and s_timeClk;
			s_year4En <= s_year3Term and s_year2Term and s_year1Term and s_monthTerm and s_dayTerm and s_timeClk;
		end if;
	end process;
	
	
	sync_gen : entity work.SyncGen(RTL)
							port map(clkIn   => CLOCK_50,
										res 	  => s_Res,
										en		  => '1',
										timeClk => s_timeClk,
										dispClk => s_dispClk);

	
	days_control : entity work.daysCntrl(Behavioral) --gera o numero m??ximo de dias
						  port map(clk			=> CLOCK_50, --de acordo com o mes atual
									  month 		=> s_month,
									  max_days	=> s_max_days);
	
	
	day_counter : entity work.Counter5(RTL)
							port map(max		=> s_max_days,
										Res		=> s_Res,
										clk		=> CLOCK_50,
										En			=> s_timeClk, --1 Hz
										Q			=> s_day,
										TC			=> s_dayTerm);
										
	bcd_dayEncoder : entity work.BinToBCD(Behavioral) 
	--Nbits ?? 5 por defeito
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
										res      => s_Res,
										En 		=> s_dispClk, --1 ciclo por ms
										selMux 	=> s_selMux, --seleciona a antrada do multiplexer
										selReg	=> s_regEn, --seleciona o registro 
										dispStart=> '1',
										dispBusy => open);

 
	
										
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
										En 		=> s_regEn(0), --enable que sai do disp cntrl
										D 			=> s_decodedValue, --valor para ser registrado
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
