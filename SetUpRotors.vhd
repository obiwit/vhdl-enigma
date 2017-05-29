library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity SetUpRotors is
	port(clk	 	 : in  std_logic;
		  enable  : in  std_logic;
		  ref_in  : in  std_logic;
		  r1_in 	 : in  std_logic_vector(2 downto 0);
		  r2_in 	 : in  std_logic_vector(2 downto 0);
		  r3_in 	 : in  std_logic_vector(2 downto 0);
		  ref_out : out std_logic;
		  r1_out	 : out std_logic_vector(2 downto 0);
		  r2_out	 : out std_logic_vector(2 downto 0);
		  r3_out	 : out std_logic_vector(2 downto 0);
		  disp0	 : out std_logic_vector(6 downto 0);
		  disp1	 : out std_logic_vector(6 downto 0);
		  disp2	 : out std_logic_vector(6 downto 0);
		  disp3	 : out std_logic_vector(6 downto 0));
end SetUpRotors;

architecture Behavioral of SetUpRotors is 
	signal s_r1, s_r2, s_r3 : std_logic_vector(2 downto 0);
	signal s_ref            : std_logic;
begin
	
	-- while active, prints SW(2..0)'s value in HEX0, SW(5..3)'s value in HEX1, 
	-- SW(8..6)'s value in HEX2, and SW(9) as "b" if it's 0 or "c" if it's 1*, in HEX3
	b7sd0 : entity work.Bin7SegDecoder(Behavioral)
				port map(binInput => '0' & std_logic_vector(unsigned(r1_in) + 1), -- go from 1 to 8 instead of 0 to 7
							decOut_n => disp0,
							enable => enable);
							
	b7sd1 : entity work.Bin7SegDecoder(Behavioral)
				port map(binInput => '0' & std_logic_vector(unsigned(r2_in) + 1), -- go from 1 to 8 instead of 0 to 7
							decOut_n => disp1,
							enable => enable);
							
	b7sd2 : entity work.Bin7SegDecoder(Behavioral)
				port map(binInput => '0' & std_logic_vector(unsigned(r3_in) + 1), -- go from 1 to 8 instead of 0 to 7
							decOut_n => disp2,
							enable => enable);
	
	disp3 <= "0000011" when (ref_in = '0') else -- b
				"1000110"; -- C
	
	process(enable, clk)
	begin

		if(enable = '1') then
			-- when KEY[0] is pressed, save SW(2..0) as rot1_sel, SW(5..3) as rot2_sel,
			--	SW(8..6) as rot3_sel and SW(9) as ref_sel
			if(rising_edge(clk))then
				s_r1 <= r1_in;
				s_r2 <= r2_in;
				s_r3 <= r3_in;
				s_ref <= ref_in;
			end if;
		end if;	
	end process;
	
	r1_out  <= s_r1;
	r2_out  <= s_r2;
	r3_out  <= s_r3;
	ref_out <= s_ref;
	
end Behavioral;
