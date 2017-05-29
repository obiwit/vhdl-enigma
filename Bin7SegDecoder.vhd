library IEEE;
use IEEE.STD_LOGIC_1164.all; 

entity Bin7SegDecoder is
	 port(binInput : in  std_logic_vector(3 downto 0);
			decOut_n : out std_logic_vector(6 downto 0);
			enable : in std_logic);
end Bin7SegDecoder;

architecture Behavioral of Bin7SegDecoder is
begin
		-- TODO:
		decOut_n <= "0000000" when (binInput = "0000") and enable = '1' else  --prints 8 instead of 0
						"1111001" when (binInput = "0001") and enable = '1' else  --1
						"0100100" when (binInput = "0010") and enable = '1' else  --2
						"0110000" when (binInput = "0011") and enable = '1' else  --3
						"0011001" when (binInput = "0100") and enable = '1' else  --4
						"0010010" when (binInput = "0101") and enable = '1' else  --5
						"0000010" when (binInput = "0110") and enable = '1' else  --6
						"1111000" when (binInput = "0111") and enable = '1' else  --7
						"0000000" when (binInput = "1000") and enable = '1' else  --8
						"0010000" when (binInput = "1001") and enable = '1' else  --9
						"1111111"; --  Invalid Code
end Behavioral;	

-- For reference:
--  -0-
-- 5   1
-- 5   1
--  -6-
-- 4   2
-- 4   2
--  -3-					