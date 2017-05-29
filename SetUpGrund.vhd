-- Setup Control Unit

-- When started by the “Main Control Unit”, this module is in charge of setup
-- all the systems (rotors, rings, grunds and plugboard) to get ready for letters
-- ciphering/deciphering. When it finishes, it waits for the next letter, that
-- corresponds to KEY[0] being pressed.

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity SetUpGrund is
	port( enable  	: in  std_logic;
			clk	 	: in  std_logic;
			r1_in 	: in  std_logic_vector(4 downto 0);
			r2_in 	: in  std_logic_vector(4 downto 0);
			r3_in 	: in  std_logic_vector(4 downto 0);
			r1_out	: out std_logic_vector(4 downto 0);
			r2_out 	: out std_logic_vector(4 downto 0);
			r3_out	: out std_logic_vector(4 downto 0);
			disp0		: out std_logic_vector(6 downto 0);
			disp1		: out std_logic_vector(6 downto 0);
			disp2		: out std_logic_vector(6 downto 0));
end SetUpGrund;

architecture Behavioral of SetUpGrund is 
	signal s_r1, s_r2, s_r3 : std_logic_vector(4 downto 0);
begin
	-- while active, prints SW(4..0)'s value in HEX0, SW(9..5)'s value in HEX1, and
	-- SW(14..10)'s value in HEX2
	
	-- when KEY[0] is pressed, return SW(4..0) as rot1_ring, SW(9..5) as rot2_ring, and
	--	SW(14..10) as rot3_ring
	
	-- which are saved by a bigger module onto memory (set up ctrl unit),
	-- somethingl like, work entity (...) r1_out <= rot1(7 downto 3), (...)
	
	b7sd0 : entity work.Letter7SegDecoder(Behavioral)
				port map(letter_in => r1_in,
							decOut_n => disp0,
							enable => enable);
							
	b7sd1 : entity work.Letter7SegDecoder(Behavioral)
				port map(letter_in => r2_in,
							decOut_n => disp1,
							enable => enable);
							
	b7sd2 : entity work.Letter7SegDecoder(Behavioral)
				port map(letter_in => r3_in,
							decOut_n => disp2,
							enable => enable);
	
	process(enable, clk)
	begin

		if(enable = '1') then
			-- when KEY[0] is pressed, save SW(2..0) as rot1_sel, SW(5..3) as rot2_sel,
			--	SW(8..6) as rot3_sel and SW(9) as ref_sel
			if(rising_edge(clk))then
				s_r1 <= r1_in;
				s_r2 <= r2_in;
				s_r3 <= r3_in;
			end if;
		end if;	
	end process;
	
	r1_out  <= s_r1;
	r2_out  <= s_r2;
	r3_out  <= s_r3;
	
end Behavioral;