library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity Plugboard is
	port(clk        : in  std_logic;
		  readWrite  : in  std_logic;
		  letter_in  : in  std_logic_vector(4 downto 0); -- letter to decode
		  letter_wr  : in  std_logic_vector(4 downto 0); -- if readWrite = 1, for letter_in, letter_out is now equal to letter_wr
		  letter_out : out std_logic_vector(4 downto 0));
end Plugboard;

architecture Behavioral of Plugboard is
	type alphabet is array (0 to 25) of std_logic_vector(4 downto 0);
	signal letters : alphabet := ("00000", "00001", "00010", "00011", "00100", "00101", 
											"00110", "00111", "01000", "01001", "01010", "01011", 
											"01100", "01101", "01110", "01111", "10000", "10001", 
											"10010", "10011", "10100", "10101", "10110", "10111",
											"11000", "11001");
begin
	process(clk, readWrite, letters, letter_in)
	begin
		-- could check that letter <= 25, via checking that (not( letter_in(4) and  letter_in(3) and 
		--																			(letter_in(2) or letter_in(1)) ))
		if (rising_edge(clk)) then
			if (readWrite = '1') then
				letters(to_integer(unsigned(letter_in))) <= letter_wr;
			end if;
		end if;
		
		letter_out <= letters(to_integer(unsigned(letter_in)));
	end process;
end Behavioral;