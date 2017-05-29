library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity OnewayPass is
	port(pass_dir    : in  std_logic;
		  rotor_one   : in  std_logic_vector(12 downto 0);
		  rotor_two   : in  std_logic_vector(12 downto 0);
		  rotor_three : in  std_logic_vector(12 downto 0);
		  letter_in   : in  std_logic_vector(4 downto 0);
		  letter_out  : out std_logic_vector(4 downto 0));
end OnewayPass;

-- rotor is rotor_sel (2 downto 0) + rotor_pos (12 downto 8) + rotor_ring(7 downto 3)

architecture Structural of OnewayPass is
	signal s_letter_one, s_letter_two : std_logic_vector(4 downto 0);
begin
	rotor_pass_one: entity work.RotorPass(Behavioral)
		port map(pass_dir   => pass_dir,
					rot_sel    => rotor_one(2 downto 0),
					rot_ring   => rotor_one(7 downto 3),
					rot_pos    => rotor_one(12 downto 8),
					letter_in  => letter_in,
					letter_out => s_letter_one);
	
	rotor_pass_two: entity work.RotorPass(Behavioral)
		port map(pass_dir   => pass_dir,
					rot_sel    => rotor_two(2 downto 0),
					rot_ring   => rotor_two(7 downto 3),
					rot_pos    => rotor_two(12 downto 8),
					letter_in  => s_letter_one,
					letter_out => s_letter_two);
	
	rotor_pass_three: entity work.RotorPass(Behavioral)
		port map(pass_dir   => pass_dir,
					rot_sel    => rotor_three(2 downto 0),
					rot_ring   => rotor_three(7 downto 3),
					rot_pos    => rotor_three(12 downto 8),
					letter_in  => s_letter_two,
					letter_out => letter_out);
end Structural;