
-- Cipher Letter Unit

-- Receives the plugboard, the rotors' and reflector's configuration and a letter
-- (a 5-bit std_logic_vector), and passes the letter through the plugboard, the
-- three rotors, the reflector and back through the rotors and the plugboard.
-- Returns the ciphered letter (a 5-bit std_logic_vector), as well as the code to
-- print it (and the original letter) on 7 Segment Displays (6-bit std_logic_vectors).

-- Code by:
-- Beatriz Borges R (79857), MIECT, UA


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

use work.alphabet_type.all;


entity CipherLetterUnit is
	port( -- letter to cipher
		   letter_in  : in  std_logic_vector(4 downto 0);
			-- plugboard configuration
		 	plugboard  : in  alphabet;
		   -- reflector configuration (0 for reflector B, 1 for C)
		   ref_sel    : in  std_logic;
		   -- rotor's configuration ( rotor is rotor_selector (2 downto 0), rotor_ring (7 downto 3),
			--									and rotor_pos (12 downto 8) )
		   r1_in      : in  std_logic_vector(12 downto 0);
		   r2_in      : in  std_logic_vector(12 downto 0);
		   r3_in      : in  std_logic_vector(12 downto 0); -- r3 is the right-most rotor
			-- ciphered letter output
		   letter_out : out std_logic_vector(4 downto 0);
		   -- 7 Segment Displays output
		   disp0 : out std_logic_vector(6 downto 0);
		   disp1 : out std_logic_vector(6 downto 0);
		   disp2 : out std_logic_vector(6 downto 0);
		   disp3 : out std_logic_vector(6 downto 0));
end CipherLetterUnit;


architecture Structural of CipherLetterUnit is 
	-- Signals to store the letter's value in between the ciphering process
	signal s_letter_pb_left, s_letter_left, s_letter_ref : std_logic_vector(4 downto 0); 
	signal s_letter_right, s_letter_out                  : std_logic_vector(4 downto 0);
begin

	-- Pass the input letter through the plugboard
	s_letter_pb_left <= plugboard(to_integer(unsigned(letter_in)));

	-- Pass the plugboard's output letter throught the three rotors, from rigth to left
	rotor_pass_left: entity work.OnewayPass(Structural)
		port map(pass_dir    => '0',
					rotor_one   => r1_in,
					rotor_two   => r2_in,
					rotor_three => r3_in,
					letter_in   => s_letter_pb_left, 
					letter_out  => s_letter_left);
	
	-- Reflect the letter that passed through the three rotors
	reflect: entity work.Reflector(Behavioral)
		port map(ref_sel   => ref_sel,
					letter_in  => s_letter_left,
					letter_out => s_letter_ref);
	
	-- Pass the reflector's output letter throught the three rotors, from left to right
	rotor_pass_right: entity work.OnewayPass(Structural)
		port map(pass_dir   => '1',
					rotor_one   => r3_in,
					rotor_two   => r2_in,
					rotor_three => r1_in,
					letter_in   => s_letter_ref,
					letter_out  => s_letter_right);

	-- Pass the letter through the plugboard once again before outputting it
	s_letter_out <= plugboard(to_integer(unsigned(s_letter_right)));
				 
			 
	-- Return encrypted letter
	letter_out <= s_letter_out;
	
	
	-- Print original and ciphered letters to user (via 7 Segments Displays)
	print_ciph_let : entity work.Letter7SegDecoder(Behavioral)
			port map(letter_in => s_letter_out, -- print ciphered letter (zeroeth display)
						decOut_n => disp0,
						enable => '1' );	 
	print_dash_1 : entity work.Letter7SegDecoder(Behavioral)
			port map(letter_in => "11010",      -- print a dash (first display)
						decOut_n => disp1,
						enable => '1' );
	print_dash_2 : entity work.Letter7SegDecoder(Behavioral)
			port map(letter_in => "11010",      -- print a dash (second display)
						decOut_n => disp2,
						enable => '1' );
	print_orig_let : entity work.Letter7SegDecoder(Behavioral)
			port map(letter_in => letter_in,    -- print original letter (third display)
						decOut_n => disp3,
						enable => '1' );
	
end Structural;