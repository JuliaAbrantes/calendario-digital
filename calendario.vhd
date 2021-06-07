library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity calendario is
	port(SW			: in  std_logic_vector(0 downto 0);
		  CLOCK_50	: in  std_logic;
		  HEX0		: out std_logic_vector(6 downto 0);
		  HEX1		: out std_logic_vector(6 downto 0);
		  HEX2		: out std_logic_vector(6 downto 0);
		  HEX3		: out std_logic_vector(6 downto 0);
		  LEDG		: out std_logic_vector(0 downto 0));
end calendario;

architecture Structural of calendario is
signal s_Res, s_progClk, s_timeClk, s_dispClk: std_logic;
signal s_dayTerm, s_monthTerm : std_logic;
signal s_sel : std_logic_vector(2 downto 0);

signal regEn_day_units, regEn_day_tens : std_logic;
signal regEn_month_units, regEn_month_tens : std_logic;
signal regEn_year_units, regEn_year_tens : std_logic;
signal regEn_year_hund, regEn_year_thou : std_logic;

signal s_day, s_month, s_year, s_data : std_logic_vector(3 downto 0);
signal s_day_units, s_day_tens, s_month_units, s_month_tens : std_logic_vector(3 downto 0);
signal s_year_units, s_year_tens, s_year_hund, s_year_thou : std_logic_vector(3 downto 0);
signal s_decodedValue : std_logic_vector(6 downto 0);
begin
	s_Res	<= not SW(0); --provisório
	
	
	sync_gen : entity work.SyncGen(RTL)
							port map(clkIn => CLOCK_50,
										progClk => s_progClk,
										timeClk => s_timeClk,
										dispClk => s_dispClk);
	LEDG(0) <= s_timeClk; --provisório


	day_counter : entity work.PCounter4(RTL)
							generic map(MAX	=> 31)
							port map(Res		=> s_Res,
										clk		=> CLOCK_50,
										En			=> s_timeClk,
										Q			=> s_day,
										TC			=> s_dayTerm);
										
	bcd_dayEncoder : entity work.BinToBCD(RTL)
							port map(Bin => s_day,
										units_out => s_day_units,
										tens_out  => s_day_tens);
										
										
	month_counter : entity work.PCounter4(RTL)
							generic map(MAX	=> 12)
							port map(Res		=> s_Res,
										clk		=> CLOCK_50,
										En			=> s_dayTerm,
										Q			=> s_month,
										TC			=> s_monthTerm);
										
	bcd_MonthEncoder : entity work.BinToBCD(RTL)
							port map(Bin 		=> s_month,
										units_out=> s_month_units,
										tens_out => s_month_tens);
	
	
	dispUpdate : entity work.DispCntrl(FSM)
							port map(clk 		=> CLOCK_50,
										En 		=> s_dispClk,
										sel 		=> s_sel);
										
	demultiplexer : entity work.Demux8(Behavioral) --separa o seletor em enables de registos
							port map(encodedIn => s_sel,
										 Dout1 	=> regEn_day_units,
										 Dout2 	=> regEn_day_tens,
										 Dout3 	=> regEn_month_units,
										 Dout4 	=> regEn_month_tens,
										 Dout5 	=> regEn_year_units,
										 Dout6 	=> regEn_year_tens,
										 Dout7 	=> regEn_year_hund,
										 Dout8 	=> regEn_year_thou);
	
										
	multiplexer : entity work.Mux8(Behavioral)
							port map( sel 		=> s_sel,
										 Din1 	=> s_day_units,
										 Din2 	=> s_day_tens,
										 Din3 	=> s_month_units,
										 Din4 	=> s_month_tens,
										 Din5 	=> s_year_units,
										 Din6 	=> s_year_tens,
										 Din7 	=> s_year_hund,
										 Din8 	=> s_year_thou,
										 DataOut => s_data);
	
	
	Decoder : entity work.Bin7SegDecoder(RTL)
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
	
	
end Structural;