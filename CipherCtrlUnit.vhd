
-- Cipher Control Unit

-- Emulates an Enigma Machine's ciphering process, consisting of rotating the rotors (a
-- process that can rotate one, two or all three rotors, depending on their position),
-- and then ciphering the input letter (a process that involves passing the letter through
-- the plugboard and rotors twice and through the reflector once).
-- Receives the plugboard, the rotors' and reflector's configuration and a letter, and
-- outputs the new rotors' configuration, the ciphered letter and the code to print it
-- (and the original letter) on 7 Segment Displays.

-- Code by:
-- Beatriz Borges R (79857), MIECT, UA


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

use work.alphabet_type.all;


entity CipherCtrlUnit is
	port(
		  -- control inputs
		  enable		  : in  std_logic;
		  -- plugboard
		  plugboard   : in alphabet;
		  -- reflector's configuration
		  ref_sel     : in  std_logic;
		  -- letter to cipher
		  letter_in   : in  std_logic_vector(4 downto 0); 
		  -- rotors' configuration
		  r1_in       : in  std_logic_vector(12 downto 0);
		  r2_in       : in  std_logic_vector(12 downto 0);
		  r3_in       : in  std_logic_vector(12 downto 0);
		  -- ciphered letter
		  letter_out  : out std_logic_vector(4 downto 0);
		  -- new rotors' configuration
		  r1_out      : out std_logic_vector(12 downto 0);
		  r2_out      : out std_logic_vector(12 downto 0);
		  r3_out      : out std_logic_vector(12 downto 0);
		  -- 7 Segment Displays output
		  disp0       : out std_logic_vector(6 downto 0);
		  disp1       : out std_logic_vector(6 downto 0);
		  disp2       : out std_logic_vector(6 downto 0);
		  disp3       : out std_logic_vector(6 downto 0);
		  disp4       : out std_logic_vector(6 downto 0));
end CipherCtrlUnit;


architecture Structural of CipherCtrlUnit is 
	signal s_letter_out                 : std_logic_vector(4 downto 0);  -- ciphered letter
	signal s_r1_out, s_r2_out, s_r3_out : std_logic_vector(12 downto 0); -- rotated rotors
begin
	
	show_letter  : entity work.Letter7SegDecoder(Behavioral)
				port map(letter_in => letter_in,
							decOut_n => disp4,
							enable => enable);

	rotate_rotors: entity work.RotateRotors(Behavioral)
		port map(r1_in     => r1_in,
					r2_in     => r2_in,
					r3_in     => r3_in,
					r1_out    => s_r1_out,
					r2_out    => s_r2_out,
					r3_out    => s_r3_out);
					
	cipher_letter: entity work.CipherLetterUnit(Structural)
		port map(letter_in  => letter_in,
				   letter_out => s_letter_out,
					r1_in      => s_r1_out,
					r2_in      => s_r2_out,
					r3_in      => s_r3_out,
					ref_sel    => ref_sel,
					plugboard  => plugboard,
					disp0      => disp0,
					disp1      => disp1,
					disp2      => disp2,
					disp3      => disp3);
	
	
	-- Garantee input letter is valid. Otherwise, don't cipher, and don't rotate, and
	--	return an invalid letter code.
	letter_out <= s_letter_out;-- when (unsigned(letter_in) < 26) else (others => '0');
	r1_out <= s_r1_out;-- when  (unsigned(letter_in) < 26) else r1_in;
	r2_out <= s_r2_out;-- when  (unsigned(letter_in) < 26) else r2_in;
	r3_out <= s_r3_out;-- when  (unsigned(letter_in) < 26) else r3_in;
	
end Structural;