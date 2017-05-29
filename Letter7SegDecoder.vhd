library IEEE;
use IEEE.STD_LOGIC_1164.all; 

entity Letter7SegDecoder is
	 port(letter_in : in  std_logic_vector(4 downto 0);
			decOut_n  : out std_logic_vector(6 downto 0);
			enable    : in std_logic);
end Letter7SegDecoder;

architecture Behavioral of Letter7SegDecoder is
begin
		decOut_n <= "0001000" when (letter_in = "00000") and enable = '1' else  --A
						"0000011" when (letter_in = "00001") and enable = '1' else  --b
						"1000110" when (letter_in = "00010") and enable = '1' else  --C
						"0100001" when (letter_in = "00011") and enable = '1' else  --d
						"0000110" when (letter_in = "00100") and enable = '1' else  --E
						"0001110" when (letter_in = "00101") and enable = '1' else  --F
						"1000010" when (letter_in = "00110") and enable = '1' else  --G
						"0001011" when (letter_in = "00111") and enable = '1' else  --h
						"1001111" when (letter_in = "01000") and enable = '1' else  --I
						"1100001" when (letter_in = "01001") and enable = '1' else  --J
						"0001010" when (letter_in = "01010") and enable = '1' else  --k
						"1000111" when (letter_in = "01011") and enable = '1' else  --L
						"1101010" when (letter_in = "01100") and enable = '1' else  --M
						"1001000" when (letter_in = "01101") and enable = '1' else  --N
						"1000000" when (letter_in = "01110") and enable = '1' else  --O
						"0001100" when (letter_in = "01111") and enable = '1' else  --P
						"0011000" when (letter_in = "10000") and enable = '1' else  --q
						"0101111" when (letter_in = "10001") and enable = '1' else  --r
						"0010010" when (letter_in = "10010") and enable = '1' else  --S
						"0000111" when (letter_in = "10011") and enable = '1' else  --t
						"1000001" when (letter_in = "10100") and enable = '1' else  --U
						"1100011" when (letter_in = "10101") and enable = '1' else  --v
						"1010101" when (letter_in = "10110") and enable = '1' else  --w
						"0111001" when (letter_in = "10111") and enable = '1' else  --X
						"0010001" when (letter_in = "11000") and enable = '1' else  --y
						"0101101" when (letter_in = "11001") and enable = '1' else  --z					
						"0111111" when (letter_in = "11010") and enable = '1' else  --dash (prints "-")		
						"1111111"; --  Invalid Letter Code (prints " ")
end Behavioral;	

-- For reference:
--  -0-
-- 5   1
-- 5   1
--  -6-
-- 4   2
-- 4   2
--  -3-					