-- Rotate Rotor
-- Receives the last position of the rotors and outputs the new positions
-- by rotating the first rotor by one position. Whenever the first rotor
-- has performed a complete rotation it will rotate the 2nd rotor by one
-- position. The same applies to the 3rd rotor, which rotates one position
-- when the 2nd rotor completes the 26 rotations.

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity RotateRotors is
	port(r1_in  : in  std_logic_vector(12 downto 0);
		  r2_in  : in  std_logic_vector(12 downto 0);
		  r3_in  : in  std_logic_vector(12 downto 0);
		  r1_out : out std_logic_vector(12 downto 0);
		  r2_out : out std_logic_vector(12 downto 0);
		  r3_out : out std_logic_vector(12 downto 0));
end RotateRotors;

-- rotor is rotor_sel (2 downto 0) + rotor_pos (12 downto 8) + rotor_ring(7 downto 3)


architecture Behavioral of RotateRotors is 
	signal s_r1_out, s_r2_out, s_r3_out : std_logic_vector(12 downto 0);
	signal s_r1_kp, s_r2_kp : boolean; -- These signal are used to store whether 
												  -- rotor 1 and 2, respectively, have reached
												  -- their knockpoints (kp)
begin
	process(r1_in, r2_in)
	begin
		s_r1_out <= r1_in;
		s_r2_out <= r2_in;
		s_r3_out <= r3_in;
		
		s_r1_kp <= ((r1_in(2 downto 0) = "000") and (r1_in(12 downto 8) = "10000")) or -- Q (rotor 1 knockpoint)
					  ((r1_in(2 downto 0) = "001") and (r1_in(12 downto 8) = "00100")) or -- E (rotor 2 knockpoint)
					  ((r1_in(2 downto 0) = "010") and (r1_in(12 downto 8) = "10101")) or -- V (rotor 3 knockpoint)
					  ((r1_in(2 downto 0) = "011") and (r1_in(12 downto 8) = "01001")) or -- J (rotor 4 knockpoint)
					  ((r1_in(2 downto 0) = "100") and (r1_in(12 downto 8) = "11001")) or -- Z (rotor 5 knockpoint)
					  ((r1_in(2 downto 0) = "101") and 											  -- M,Z (rotor 6 knockpoints)
							 ((r1_in(12 downto 8) = "01100") or (r1_in(12 downto 8) = "11001"))) or 
					  ((r1_in(2 downto 0) = "110") and											  -- M,Z (rotor 7 knockpoints)
							 ((r1_in(12 downto 8) = "01100") or (r1_in(12 downto 8) = "11001"))) or
					  ((r1_in(2 downto 0) = "111") and 											  -- M,Z (rotor 8 knockpoints)
							 ((r1_in(12 downto 8) = "01100") or (r1_in(12 downto 8) = "11001")));
							 
		s_r2_kp <= ((r2_in(2 downto 0) = "000") and (r2_in(12 downto 8) = "10000")) or -- Q (rotor 1 knockpoint)
					  ((r2_in(2 downto 0) = "001") and (r2_in(12 downto 8) = "00100")) or -- E (rotor 2 knockpoint)
					  ((r2_in(2 downto 0) = "010") and (r2_in(12 downto 8) = "10101")) or -- V (rotor 3 knockpoint)
					  ((r2_in(2 downto 0) = "011") and (r2_in(12 downto 8) = "01001")) or -- J (rotor 4 knockpoint)
					  ((r2_in(2 downto 0) = "100") and (r2_in(12 downto 8) = "11001")) or -- Z (rotor 5 knockpoint)
					  ((r2_in(2 downto 0) = "101") and 											  -- M,Z (rotor 6 knockpoints)
							 ((r2_in(12 downto 8) = "01100") or (r2_in(12 downto 8) = "11001"))) or 
					  ((r2_in(2 downto 0) = "110") and 											  -- M,Z (rotor 7 knockpoints)
							 ((r2_in(12 downto 8) = "01100") or (r2_in(12 downto 8) = "11001"))) or
					  ((r2_in(2 downto 0) = "111") and 											  -- M,Z (rotor 8 knockpoints)
							 ((r2_in(12 downto 8) = "01100") or (r2_in(12 downto 8) = "11001")));
	

		if (s_r2_kp) then 
		
			-- rotate rotors 2 and 3
			s_r2_out(12 downto 8) <= std_logic_vector((unsigned(r2_in(12 downto 8)) + 1) rem 26);
			s_r3_out(12 downto 8) <= std_logic_vector((unsigned(r3_in(12 downto 8)) + 1) rem 26);
			
		elsif (s_r1_kp) then
		
			-- rotate rotor 2
			s_r2_out(12 downto 8) <= std_logic_vector((unsigned(r2_in(12 downto 8)) + 1) rem 26);
		end if;
		
		-- rotate rotor 1 (always rotates)
		s_r1_out(12 downto 8) <= std_logic_vector((unsigned(r1_in(12 downto 8)) + 1) rem 26);
		
	end process;
	
	r1_out <= s_r1_out;
	r2_out <= s_r2_out;
	r3_out <= s_r3_out;
	
end Behavioral;
