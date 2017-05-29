library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity GetLetter is
	port(clk        : in  std_logic;
		  enable		 : in  std_logic;
		  letter_in	 : in  std_logic_vector(4 downto 0);
		  letter_out : out std_logic_vector(4 downto 0);
		  disp		 : out std_logic_vector(6 downto 0));
end GetLetter;

architecture Behavioral of GetLetter is 
	signal s_letter : std_logic_vector(4 downto 0);
begin
	
	b7sd  : entity work.Letter7SegDecoder(Behavioral)
				port map(letter_in => letter_in,
							decOut_n => disp,
							enable => enable);
	
	save_ltr : process(clk, enable, letter_in)
	begin
	if (rising_edge(clk)) then
		if (enable = '1') then
			s_letter <= letter_in;
		end if;
	end if;
	end process;
	
	letter_out <= s_letter;
	
end Behavioral;