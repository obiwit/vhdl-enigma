
-- Main Control Unit

-- 

-- Code by:
-- Beatriz Borges R (79857), MIECT, UA


library IEEE;
use IEEE.STD_LOGIC_1164.all;

use work.alphabet_type.all;



entity MainCtrlUnit is
	port( -- clock input signal
			CLOCK_50 : in  std_logic;
			-- switch and buttons' input signals
			SW       : in  std_logic_vector(14 downto 0);
			KEY      : in  std_logic_vector(2 downto 0);
			
--			STATE      : OUT STD_LOGIC_VECTOR(1 DOWNTO 0); -- For testing purposes only
				
			-- 7 Segment Display Output
			HEX0     : out std_logic_vector(6 downto 0);
			HEX1     : out std_logic_vector(6 downto 0);
			HEX2     : out std_logic_vector(6 downto 0);
			HEX3     : out std_logic_vector(6 downto 0);
			HEX4     : out std_logic_vector(6 downto 0));
end MainCtrlUnit;



architecture Structural of MainCtrlUnit is 
	-- Signals
	signal s_k0, s_k1, s_k2   	 	: std_logic; -- debounced buttons
	
	signal s_ref_sel              : std_logic := '0'; -- reflector settings
	signal s_r1, s_r2, s_r3       : std_logic_vector(12 downto 0) := "0000000000000"; -- rotors' settings
	
	signal s_letter_out           : std_logic_vector(4 downto 0); -- ciphered letter to send via RS232
	
	signal s_cp_disp0, s_cp_disp1 : std_logic_vector(6 downto 0); -- cipher letter module's 7seg display output
	signal s_cp_disp2, s_cp_disp3 : std_logic_vector(6 downto 0); -- cipher letter module's 7seg display output
	
	signal s_su_disp0, s_su_disp1 : std_logic_vector(6 downto 0); -- setup module's 7seg display output
	signal s_su_disp2, s_su_disp3 : std_logic_vector(6 downto 0); -- setup module's 7seg display output
	
	
	signal s_su_done, s_ciph_done : std_logic := '0';	
	signal s_next_r1, s_next_r2, s_next_r3 : std_logic_vector(12 downto 0);
	signal s_su_r1, s_su_r2, s_su_r3 : std_logic_vector(12 downto 0);
	signal s_clk_r1, s_clk_r2, s_clk_r3 : std_logic_vector(12 downto 0);
	
		-- test signals
		SIGNAL s_en_su, s_en_ciph, S_TIMER_CIPH  : STD_LOGIC; -- s_cipher_reset s_ciph_done
		
	-- States
	type TState is (ST_SETUP, ST_CIPHER, ST_SEND);
	signal s_currentState, s_nextState : TState;
	
	-- Memory (RAM)
	-- type alphabet is array (0 to 25) of std_logic_vector(4 downto 0);
	signal s_plugboard : alphabet := ("00000", "00001", "00010", "00011", "00100", "00101", 
												 "00110", "00111", "01000", "01001", "01010", "01011", 
												 "01100", "01101", "01110", "01111", "10000", "10001", 
												 "10010", "10011", "10100", "10101", "10110", "10111",
												 "11000", "11001");
	
begin

	-- Debounces the vehicles entry and exit sensors' signal
	db0: entity work.DebounceUnit(Behavioral)
				-- (generic paramenters are correct by default)
				port map (refClk    => CLOCK_50,
							 dirtyIn   => KEY(0),
							 pulsedOut => s_k0);	
	db1: entity work.DebounceUnit(Behavioral)
				-- (generic paramenters are correct by default)
				port map (refClk    => CLOCK_50,
							 dirtyIn   => KEY(1), 
							 pulsedOut => s_k1);		
	db2: entity work.DebounceUnit(Behavioral)
				-- (generic paramenters are correct by default)
				port map (refClk    => CLOCK_50,
							 dirtyIn   => KEY(2), 
							 pulsedOut => s_k2);	

	
	-- Setup Control Unit
	setup_unit: entity work.SetUpCtrlUnit(Structural)
		port map(clk        => CLOCK_50,
					enable     => s_en_su,
				   reset      => s_k2, -- eventually change to s_reset, and move s_k2 to state machine
					trigger    => s_k0, -- Replace s_k0 by KEY(0) to test with the waveform simulation
				   SW_input   => SW(14 downto 0),
						memory_out => s_plugboard,
					r1_out     => s_su_r1,
					r2_out     => s_su_r2,
					r3_out     => s_su_r3,
					ref_out    => s_ref_sel,
					disp0      => s_su_disp0,
					disp1      => s_su_disp1,
					disp2      => s_su_disp2,
					disp3      => s_su_disp3,
					done       => s_su_done);

	-- Cipher Control Unit
	cipher_unit: entity work.CipherCtrlUnit(Structural)
		port map(--clk         => CLOCK_50,
					enable      => s_en_ciph, --(s_su_done and not s_k2),
					--save		   => s_k1,
					--reset       => s_k1, -- confirm this works
					--protocol    => '0',
					r1_in       => s_r1,
					r2_in       => s_r2,
					r3_in       => s_r3,
					ref_sel     => s_ref_sel,
					letter_in   => SW(4 downto 0),
						plugboard   => s_plugboard,
					r1_out      => s_next_r1,
					r2_out      => s_next_r2,
					r3_out      => s_next_r3,
				   letter_out  => s_letter_out,
					disp0       => s_cp_disp0,
					disp1       => s_cp_disp1,
					disp2       => s_cp_disp2,
					disp3       => s_cp_disp3,
					disp4       => HEX4);

					
	sync_proc: process(CLOCK_50)
	begin
		if (rising_edge(CLOCK_50)) then
			s_currentState <= s_nextState;
			
			s_r1 <= s_clk_r1;
			s_r2 <= s_clk_r2;
			s_r3 <= s_clk_r3;
		end if;
	end process;
		
		
	comb_proc: process(s_currentState, 
							 s_cp_disp0, s_cp_disp1, s_cp_disp2, s_cp_disp3, 
							 s_su_disp0, s_su_disp1, s_su_disp2, s_su_disp3,
							 s_su_done, s_ciph_done, 
							 s_k1, --KEY(1), 
							 s_su_r1, s_su_r2, s_su_r3,
							 s_next_r1, s_next_r2, s_next_r3)
	begin
	
		HEX0 <= s_cp_disp0;
		HEX1 <= s_cp_disp1;
		HEX2 <= s_cp_disp2;
		HEX3 <= s_cp_disp3;
			
		--s_cipher_reset <= '0';	
		
													s_en_su <= '0'; -- should be 0 instead!!!
		s_en_ciph <= '0';	
									
		
		case s_currentState is
		
			when ST_SETUP =>
				-- signals
				s_en_su <= '1';
				HEX0 <= s_su_disp0;
				HEX1 <= s_su_disp1;
				HEX2 <= s_su_disp2;
				HEX3 <= s_su_disp3;
				
				-- rotors' initial configuration
				s_clk_r1 <= s_su_r1;
				s_clk_r2 <= s_su_r2;
				s_clk_r3 <= s_su_r3;
				
				-- states
				s_nextState <= ST_SETUP;
				if (s_su_done = '1') then
					s_nextState <= ST_CIPHER;
				end if;
				
			when ST_CIPHER => 
				-- signals
				s_en_ciph <= '1';
				
				-- states
				s_nextState <= ST_CIPHER;
				if (s_k1 = '1') then -- s_k1 = '1'     --s_ciph_done = '1' -- Replace s_k1 by KEY(1) to test with the waveform simulation
					s_nextState <= ST_SEND;
				end if;
				
			when ST_SEND => 
			
				-- signals
				--s_en_ciph <= '1';
				
				-- update rotors' configuration
				s_clk_r1 <= s_next_r1;
				s_clk_r2 <= s_next_r2;
				s_clk_r3 <= s_next_r3;
				
				
				-- states
				s_nextState <= ST_CIPHER;
					
						
			when others => s_nextState <= ST_SETUP; -- catch all
			
		end case;
	end process;
	
		
	-- For testing purposes only
--	STATE <= "00" when (s_currentState = ST_SETUP) else
--				"01" when (s_currentState = ST_CIPHER) else
--				"10";
	
end Structural;