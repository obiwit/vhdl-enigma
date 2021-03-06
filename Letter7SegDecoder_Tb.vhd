library IEEE;
use IEEE.STD_LOGIC_1164.all; 

entity Letter7SegDecoder_Tb is
	
end Letter7SegDecoder_Tb;

architecture Stimulus of Letter7SegDecoder_Tb is
	signal s_binInput : std_logic_vector(4 downto 0);
	signal s_enable 	: std_logic;
	signal s_decOut_n : std_logic_vector(6 downto 0);

begin

	uut : entity work.Letter7SegDecoder(Beheavioral)
			port map(letter_in => s_binInput,
						enable 	=> s_enable,
						decOut_n => s_decOut_n);
		
	stim_proc : process
	begin
		s_enable <= '0';
		wait for 100 ns;
		
		s_enable <= '1';
		wait for 100 ns;
		
		s_binInput <= "00000";
		wait for 100 ns;
		
		s_binInput <= "00001";
		wait for 100 ns;
		
		s_binInput <= "00010";
		wait for 100 ns;
		
		s_binInput <= "00011";
		wait for 100 ns;
		
		s_binInput <= "00100";
		wait for 100 ns;
		
		s_binInput <= "00101";
		wait for 100 ns;
		
		s_binInput <= "00110";
		wait for 100 ns;
		
		s_binInput <= "00111";
		wait for 100 ns;
		
		s_binInput <= "01000";
		wait for 100 ns;
		
		s_binInput <= "01001";
		wait for 100 ns;
		
		s_binInput <= "01010";
		wait for 100 ns;
		
		s_binInput <= "01011";
		wait for 100 ns;
		
		s_binInput <= "01100";
		wait for 100 ns;
		
		s_binInput <= "01101";
		wait for 100 ns;
		
		s_binInput <= "01110";
		wait for 100 ns;
		
		s_binInput <= "01111";
		wait for 100 ns;
		
		s_binInput <= "10001";
		wait for 100 ns;
		
		s_binInput <= "10010";
		wait for 100 ns;
		
		s_binInput <= "10011";
		wait for 100 ns;
		
		s_binInput <= "10100";
		wait for 100 ns;
		
		s_binInput <= "10101";
		wait for 100 ns;
		
		s_binInput <= "10110";
		wait for 100 ns;
		
		s_binInput <= "10111";
		wait for 100 ns;
		
		s_binInput <= "11000";
		wait for 100 ns;
		
		s_binInput <= "11001";
		wait for 100 ns;
		
		s_binInput <= "11010";
		wait for 100 ns;
	end process;
end Stimulus;