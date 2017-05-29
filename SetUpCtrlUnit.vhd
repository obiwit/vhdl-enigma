
-- Set Up Control Unit

-- When started by the MainCtrlUnit, this module is in charge of setup all the
-- systems (rotors, rings, grunds and plugboard). Returns the the plugboard,
-- the rotors' and the reflector's configuration.

-- Code by:
-- Beatriz Borges R (79857), MIECT, UA


library IEEE;
use IEEE.STD_LOGIC_1164.all;

use work.alphabet_type.all;


entity SetUpCtrlUnit is
	port(clk        : in  std_logic;
		  enable     : in  std_logic;
		  reset      : in  std_logic;
		  trigger    : in  std_logic;
		  SW_input   : in  std_logic_vector(14 downto 0);
		  done       : out std_logic;
		  -- plugboard settings
		  memory_out : out alphabet;
		  -- reflector's configuration
		  ref_out    : out std_logic;
		  -- rotors' configuration 
		  r1_out     : out std_logic_vector(12 downto 0);
		  r2_out     : out std_logic_vector(12 downto 0);
		  r3_out     : out std_logic_vector(12 downto 0);
		  -- 7 Segment Displays output
	     disp0      : out std_logic_vector(6 downto 0);
		  disp1      : out std_logic_vector(6 downto 0);
		  disp2      : out std_logic_vector(6 downto 0);
		  disp3      : out std_logic_vector(6 downto 0));
end SetUpCtrlUnit;



architecture Structural of SetUpCtrlUnit is 
	-- Signals
	signal s_en_1, s_en_2, s_en_3, s_en_4 : std_logic;
	signal s_all_done, s_pb_done	 		  : std_logic := '0';
	signal s_count								  : std_logic_vector(1 downto 0);
	signal s_su_rt_disp0, s_su_rt_disp1	  : std_logic_vector(6 downto 0); 
	signal s_su_rt_disp2, s_su_rt_disp3	  : std_logic_vector(6 downto 0);
	signal s_su_rg_disp0, s_su_rg_disp1	  : std_logic_vector(6 downto 0);
	signal s_su_rg_disp2						  : std_logic_vector(6 downto 0);
	signal s_su_gd_disp0, s_su_gd_disp1	  : std_logic_vector(6 downto 0);
	signal s_su_gd_disp2						  : std_logic_vector(6 downto 0);
	signal s_su_pb_disp0, s_su_pb_disp1	  : std_logic_vector(6 downto 0);
	signal s_su_pb_disp2, s_su_pb_disp3	  : std_logic_vector(6 downto 0);
	signal s_r1, s_r2, s_r3         		  : std_logic_vector(12 downto 0);
	
	-- States
	type TState is (ST_IDLE, ST_SU_ROTORS, ST_SU_RINGS, ST_SU_GRUNDS, ST_SU_PLUGBOARD, ST_DONE);
	signal s_currentState, s_nextState : TState;
begin

	-- compact setup grund and setup ring into only 1 unit, called twice?
	
	-- Get each rotor's number
	su_rotors : entity work.SetUpRotors(Behavioral)
		port map(clk     => clk,
					enable  => s_en_1,
					r1_in   => SW_input(2 downto 0),
					r2_in   => SW_input(5 downto 3),
					r3_in   => SW_input(8 downto 6),
					ref_in  => SW_input(9),
					disp0	  => s_su_rt_disp0,
					disp1	  => s_su_rt_disp1,
					disp2	  => s_su_rt_disp2,
					disp3	  => s_su_rt_disp3,
					r1_out  => s_r1(2 downto 0),
					r2_out  => s_r2(2 downto 0),
					r3_out  => s_r3(2 downto 0),
					ref_out => ref_out);
					
	-- Get each rotor's ring position
	su_rings : entity work.SetUpRings(Behavioral)
		port map(clk     => clk,
					enable  => s_en_2,
					r1_in   => SW_input(4 downto 0),
					r2_in   => SW_input(9 downto 5),
					r3_in   => SW_input(14 downto 10),
					disp0	  => s_su_rg_disp0,
					disp1	  => s_su_rg_disp1,
					disp2	  => s_su_rg_disp2,
					r1_out  => s_r1(7 downto 3),
					r2_out  => s_r2(7 downto 3),
					r3_out  => s_r3(7 downto 3));
					
	-- Get each rotor's starting position (grund)
	su_grund : entity work.SetUpGrund(Behavioral)
		port map(clk     => clk,
					enable  => s_en_3,
					r1_in   => SW_input(4 downto 0),
					r2_in   => SW_input(9 downto 5),
					r3_in   => SW_input(14 downto 10),
					disp0	  => s_su_gd_disp0,
					disp1	  => s_su_gd_disp1,
					disp2	  => s_su_gd_disp2,
					r1_out  => s_r1(12 downto 8),
					r2_out  => s_r2(12 downto 8),
					r3_out  => s_r3(12 downto 8));
					
	-- Get each every letter's plugboard pair
	su_plugboard : entity work.SetUpPlugboard(Structural)
		port map(clk     => clk,
					enable	 => (s_en_4 and not s_pb_done),
					save 	    => trigger,
					letter_in => SW_input(4 downto 0),
						memory_out => memory_out,
					disp0		 => s_su_pb_disp0,
					disp1	 	 => s_su_pb_disp1,
					disp2		 => s_su_pb_disp2,
					disp3	  	 => s_su_pb_disp3,
					done      => s_pb_done);
		
	
	r1_out  <= s_r1;
	r2_out  <= s_r2;
	r3_out  <= s_r3;
	
	sync_proc: process(clk)
	begin
		if (rising_edge(clk)) then
			s_currentState <= s_nextState;
		end if;
	end process;
		
		
	comb_proc: process(s_currentState, trigger, s_pb_done)
	begin
		s_en_1 <= '0';
		s_en_2 <= '0';
		s_en_3 <= '0';
		s_en_4 <= '0';
		
		done <= '0';
		
		disp0  <= (others => '1');
		disp1  <= (others => '1');
		disp2  <= (others => '1');
		disp3  <= (others => '1');
			
		case s_currentState is
			when ST_IDLE =>
				-- states
				s_nextState <= ST_IDLE;
				if (enable = '1') then
					s_nextState <= ST_SU_ROTORS;
				end if;
				
			when ST_SU_ROTORS => 
				-- states
				s_nextState <= ST_SU_ROTORS;
				if (enable = '0' or reset = '1') then
					s_nextState <= ST_IDLE;
				elsif (trigger = '1') then
					s_nextState <= ST_SU_RINGS;
				end if;
				
				-- signals
				s_en_1     <= '1';
				disp0  <= s_su_rt_disp0;
				disp1  <= s_su_rt_disp1;
				disp2  <= s_su_rt_disp2;
				disp3  <= s_su_rt_disp3;
				
				
			when ST_SU_RINGS => 
				-- states
				s_nextState <= ST_SU_RINGS;
				if (enable = '0' or reset = '1') then
					s_nextState <= ST_IDLE;
				elsif (trigger = '1') then
					s_nextState <= ST_SU_GRUNDS;
				end if;
				
				-- signals
				s_en_2     <= '1';
				disp0  <= s_su_rg_disp0;
				disp1  <= s_su_rg_disp1;
				disp2  <= s_su_rg_disp2;
				disp3  <= (others => '1');
				
				
			when ST_SU_GRUNDS => 
				-- states
				s_nextState <= ST_SU_GRUNDS;
				if (enable = '0' or reset = '1') then
					s_nextState <= ST_IDLE;
				elsif (trigger = '1') then
					s_nextState <= ST_SU_PLUGBOARD;
				end if;
				
				-- signals
				s_en_3     <= '1';
				disp0  <= s_su_gd_disp0;
				disp1  <= s_su_gd_disp1;
				disp2  <= s_su_gd_disp2;
				disp3  <= (others => '1');
					
				
			when ST_SU_PLUGBOARD => 
				-- states
				s_nextState <= ST_SU_PLUGBOARD;
				if (enable = '0' or reset = '1') then
					s_nextState <= ST_IDLE;
				elsif (s_pb_done = '1') then
					s_nextState <= ST_DONE;
				end if;
				
				-- signals
				s_en_4 	  <= '1';
				disp0  <= s_su_pb_disp0;
				disp1  <= s_su_pb_disp1;
				disp2  <= s_su_pb_disp2;
				disp3  <= s_su_pb_disp3;
				
				
			when ST_DONE =>  
				-- states
				s_nextState <= ST_DONE;
				if (reset = '1') then
					s_nextState <= ST_IDLE;
				end if;
				
				-- signals
				done <= '1';
																
			when others => s_nextState <= ST_IDLE; -- catch all
			
		end case;
	end process;
	
	--done <= (s_all_done and s_pb_done);

end Structural;