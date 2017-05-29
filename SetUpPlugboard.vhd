

-- Code by:
-- Beatriz Borges R (79857), MIECT, UA

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

use work.alphabet_type.all;

entity SetUpPlugboard is
	port(enable	    : in  std_logic;
		  clk 		 : in  std_logic;
		  save 		 : in  std_logic;
		  letter_in  : in  std_logic_vector(4 downto 0);
		  memory_out : out alphabet;
		  done       : out std_logic;
		  disp0		 : out std_logic_vector(6 downto 0);
		  disp1		 : out std_logic_vector(6 downto 0);
		  disp2	    : out std_logic_vector(6 downto 0);
				letter_out        : OUT std_logic_vector(4 downto 0);
		  disp3      : out std_logic_vector(6 downto 0));
end SetUpPlugboard;

architecture Structural of SetUpPlugboard is 
	signal s_memory       : alphabet; 	-- stores the plugboard information
	signal s_letter_count : unsigned(4 downto 0) := "00000";  -- letter counter (counts from A to Z)
begin

	-- Print current letter and its pair to user via 7 Segment Displays
	b7sd0 : entity work.Letter7SegDecoder(Behavioral)
				port map(letter_in => letter_in,
							decOut_n => disp0,
							enable => enable);
	b7sd1 : entity work.Letter7SegDecoder(Behavioral)
				port map(letter_in => "11010",
							decOut_n => disp1,
							enable => enable);
	b7sd2 : entity work.Letter7SegDecoder(Behavioral)
				port map(letter_in => "11010",
							decOut_n => disp2,
							enable => enable);	
	b7sd3 : entity work.Letter7SegDecoder(Behavioral)
				port map(letter_in => std_logic_vector(s_letter_count),
							decOut_n => disp3,
							enable => enable);
		  
	-- For every letter in the alphabet (while s_letter_count < 26) save its pair into the
	-- plugboard (when save input signal is '1'). When s_letter_count >= 26, setup is done.
	setup_pb : process(enable, clk, save)
	begin
		if (rising_edge(clk)) then
			done <= '0';	
			
			if (enable = '1') then
			
				if (s_letter_count >= 26) then
					-- reached end of count
					done <= '1';
					
				elsif (save = '1') then	
					-- writeto plugboard
					s_memory(to_integer(unsigned(s_letter_count))) <= letter_in;
					s_letter_count <= s_letter_count + 1;
					
				end if;
			end if;	
		end if;
	end process;
	
	memory_out <= s_memory;
	
end Structural;