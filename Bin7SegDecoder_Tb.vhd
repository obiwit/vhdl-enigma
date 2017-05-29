library IEEE;
use IEEE.STD_LOGIC_1164.all; 

entity Bin7SegDecoder_Tb is
	
end Bin7SegDecoder_Tb;

architecture Stimulus of Bin7SegDecoder_Tb is
	signal s_binInput : std_logic_vector(3 downto 0);
	signal s_enable 	: std_logic;
	signal s_decOut_n : std_logic_vector(6 downto 0);

begin

	uut : entity work.Bin7SegDecoder(Beheavioral)
			  port map(	binInput => s_binInput,
							enable 	=> s_enable,
							decOut_n => s_decOut_n);
		
	stim_proc : process
	begin
		s_enable <= '0';
		wait for 100 ns;
		
		s_enable <= '1';
		wait for 100 ns;
		
		s_binInput <= "0000";
		wait for 100 ns;
		
		s_binInput <= "0001";
		wait for 100 ns;
		
		s_binInput <= "0010";
		wait for 100 ns;
		
		s_binInput <= "0011";
		wait for 100 ns;
		
		s_binInput <= "0100";
		wait for 100 ns;
		
		s_binInput <= "0101";
		wait for 100 ns;
		
		s_binInput <= "0110";
		wait for 100 ns;
		
		s_binInput <= "0111";
		wait for 100 ns;
		
		s_binInput <= "1000";
		wait for 100 ns;
		
		s_binInput <= "1001";
		wait for 100 ns;	
	end process;
end Stimulus;