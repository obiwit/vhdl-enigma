library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity RotorPass is
	port(pass_dir      : in  std_logic; -- whether letter is passing rotor from right to left (0) or left to right (1)
		  rot_sel       : in  std_logic_vector(2 downto 0); -- rotor selector (0 to 7)
		  rot_pos       : in  std_logic_vector(4 downto 0); -- rotor starting position (A to Z)
		  rot_ring      : in  std_logic_vector(4 downto 0); -- rotor ring position (A to Z)
		  letter_in     : in  std_logic_vector(4 downto 0); -- letter to encrypt
		  letter_out    : out std_logic_vector(4 downto 0)); -- encrypted letter
end RotorPass;

architecture Behavioral of RotorPass is
	signal s_letter_in, s_letter_out : std_logic_vector(4 downto 0);
begin

	pre_process_letter: process (letter_in, rot_ring, rot_pos)
		variable s_let_val : unsigned(5 downto 0); -- must be able to house 52 (26*2)
	begin
		-- adjust for Ringstellung (ring position)
		-- adding 26 to letter value garantees we'll never deal with negative numbers
		s_let_val := unsigned(letter_in) + "011010";  
		s_let_val := (s_let_val - unsigned(rot_ring)) rem 26; -- it's necessary to rem
																				--	here so there's no 
																				-- chance of overflow
																				--	in the next operation 
																				-- (52 + 26) > 64
		

		-- adjust for Grundstellung (rotor's starting position)
		s_let_val := s_let_val + unsigned(rot_pos);
		
		s_letter_in <= std_logic_vector(s_let_val rem 26)(4 downto 0);
		
	end process pre_process_letter;

	pass_rot: process (s_letter_in, rot_sel, pass_dir)
	begin
		case s_letter_in is
			when "00000" =>    -- A
				if (pass_dir = '0') then
					case rot_sel is
						when "000"  => s_letter_out <= "00100"; -- rotor 1, E
						when "001"  => s_letter_out <= "00000"; -- rotor 2, A
						when "010"  => s_letter_out <= "00001"; -- rotor 3, B
						when "011"  => s_letter_out <= "00100"; -- rotor 4, E
						when "100"  => s_letter_out <= "10101"; -- rotor 5, V
						when "101"  => s_letter_out <= "01001"; -- rotor 6, J
						when "110"  => s_letter_out <= "01101"; -- rotor 7, N
						when others => s_letter_out <= "00101"; -- rotor 8, F
					end case;
				else
					case rot_sel is
						when "000"  => s_letter_out <= "10100"; -- rotor 1, U
						when "001"  => s_letter_out <= "00000"; -- rotor 2, A
						when "010"  => s_letter_out <= "10011"; -- rotor 3, T
						when "011"  => s_letter_out <= "00111"; -- rotor 4, H
						when "100"  => s_letter_out <= "10000"; -- rotor 5, Q
						when "101"  => s_letter_out <= "10010"; -- rotor 6, S
						when "110"  => s_letter_out <= "10000"; -- rotor 7, Q
						when others => s_letter_out <= "10000"; -- rotor 8, Q
					end case;
				end if;
			when "00001" =>    -- B
				if (pass_dir = '0') then
					case rot_sel is
						when "000"  => s_letter_out <= "01010"; -- rotor 1, K
						when "001"  => s_letter_out <= "01001"; -- rotor 2, J
						when "010"  => s_letter_out <= "00011"; -- rotor 3, D
						when "011"  => s_letter_out <= "10010"; -- rotor 4, S
						when "100"  => s_letter_out <= "11001"; -- rotor 5, Z
						when "101"  => s_letter_out <= "01111"; -- rotor 6, P
						when "110"  => s_letter_out <= "11001"; -- rotor 7, Z
						when others => s_letter_out <= "01010"; -- rotor 8, K
					end case;
				else
					case rot_sel is
						when "000"  => s_letter_out <= "10110"; -- rotor 1, W
						when "001"  => s_letter_out <= "01001"; -- rotor 2, J
						when "010"  => s_letter_out <= "00000"; -- rotor 3, A
						when "011"  => s_letter_out <= "11001"; -- rotor 4, Z
						when "100"  => s_letter_out <= "00010"; -- rotor 5, C
						when "101"  => s_letter_out <= "01010"; -- rotor 6, K
						when "110"  => s_letter_out <= "01100"; -- rotor 7, M
						when others => s_letter_out <= "01001"; -- rotor 8, J
					end case;
				end if;
			when "00010" =>    -- C
				if (pass_dir = '0') then
					case rot_sel is
						when "000"  => s_letter_out <= "01100"; -- rotor 1, M
						when "001"  => s_letter_out <= "00011"; -- rotor 2, D
						when "010"  => s_letter_out <= "00101"; -- rotor 3, F
						when "011"  => s_letter_out <= "01110"; -- rotor 4, O
						when "100"  => s_letter_out <= "00001"; -- rotor 5, B
						when "101"  => s_letter_out <= "00110"; -- rotor 6, G
						when "110"  => s_letter_out <= "01001"; -- rotor 7, J
						when others => s_letter_out <= "10000"; -- rotor 8, Q
					end case;
				else
					case rot_sel is
						when "000"  => s_letter_out <= "11000"; -- rotor 1, Y
						when "001"  => s_letter_out <= "01111"; -- rotor 2, P
						when "010"  => s_letter_out <= "00110"; -- rotor 3, G
						when "011"  => s_letter_out <= "10110"; -- rotor 4, W
						when "100"  => s_letter_out <= "11000"; -- rotor 5, Y
						when "101"  => s_letter_out <= "10111"; -- rotor 6, X
						when "110"  => s_letter_out <= "00110"; -- rotor 7, G
						when others => s_letter_out <= "01000"; -- rotor 8, I
					end case;
				end if;
			when "00011" =>    -- D
				if (pass_dir = '0') then
					case rot_sel is
						when "000"  => s_letter_out <= "00101"; -- rotor 1, F
						when "001"  => s_letter_out <= "01010"; -- rotor 2, K
						when "010"  => s_letter_out <= "00111"; -- rotor 3, H
						when "011"  => s_letter_out <= "10101"; -- rotor 4, V
						when "100"  => s_letter_out <= "10001"; -- rotor 5, R
						when "101"  => s_letter_out <= "10101"; -- rotor 6, V
						when "110"  => s_letter_out <= "00111"; -- rotor 7, H
						when others => s_letter_out <= "00111"; -- rotor 8, H
					end case;
				else
					case rot_sel is
						when "000"  => s_letter_out <= "00110"; -- rotor 1, G
						when "001"  => s_letter_out <= "00010"; -- rotor 2, C
						when "010"  => s_letter_out <= "00001"; -- rotor 3, B
						when "011"  => s_letter_out <= "10101"; -- rotor 4, V
						when "100"  => s_letter_out <= "01011"; -- rotor 5, L
						when "101"  => s_letter_out <= "10000"; -- rotor 6, Q
						when "110"  => s_letter_out <= "11000"; -- rotor 7, Y
						when others => s_letter_out <= "01101"; -- rotor 8, N
					end case;
				end if;
			when "00100" =>    -- E
				if (pass_dir = '0') then
					case rot_sel is
						when "000"  => s_letter_out <= "01011"; -- rotor 1, L
						when "001"  => s_letter_out <= "10010"; -- rotor 2, S
						when "010"  => s_letter_out <= "01001"; -- rotor 3, J
						when "011"  => s_letter_out <= "01111"; -- rotor 4, P
						when "100"  => s_letter_out <= "00110"; -- rotor 5, G
						when "101"  => s_letter_out <= "01110"; -- rotor 6, O
						when "110"  => s_letter_out <= "00110"; -- rotor 7, G
						when others => s_letter_out <= "10011"; -- rotor 8, T
					end case;
				else
					case rot_sel is
						when "000"  => s_letter_out <= "00000"; -- rotor 1, A
						when "001"  => s_letter_out <= "11001"; -- rotor 2, Z
						when "010"  => s_letter_out <= "01111"; -- rotor 3, P
						when "011"  => s_letter_out <= "00000"; -- rotor 4, A
						when "100"  => s_letter_out <= "10111"; -- rotor 5, X
						when "101"  => s_letter_out <= "01011"; -- rotor 6, L
						when "110"  => s_letter_out <= "10101"; -- rotor 7, V
						when others => s_letter_out <= "10010"; -- rotor 8, S
					end case;
				end if;
			when "00101" =>    -- F
				if (pass_dir = '0') then
					case rot_sel is
						when "000"  => s_letter_out <= "00110"; -- rotor 1, G
						when "001"  => s_letter_out <= "01000"; -- rotor 2, I
						when "010"  => s_letter_out <= "01011"; -- rotor 3, L
						when "011"  => s_letter_out <= "11001"; -- rotor 4, Z
						when "100"  => s_letter_out <= "01000"; -- rotor 5, I
						when "101"  => s_letter_out <= "10100"; -- rotor 6, U
						when "110"  => s_letter_out <= "10001"; -- rotor 7, R
						when others => s_letter_out <= "01011"; -- rotor 8, L
					end case;
				else
					case rot_sel is
						when "000"  => s_letter_out <= "00011"; -- rotor 1, D
						when "001"  => s_letter_out <= "10110"; -- rotor 2, W
						when "010"  => s_letter_out <= "00010"; -- rotor 3, C
						when "011"  => s_letter_out <= "10001"; -- rotor 4, R
						when "100"  => s_letter_out <= "10110"; -- rotor 5, W
						when "101"  => s_letter_out <= "00111"; -- rotor 6, H
						when "110"  => s_letter_out <= "01111"; -- rotor 7, P
						when others => s_letter_out <= "00000"; -- rotor 8, A
					end case;
				end if;
			when "00110" =>    -- G
				if (pass_dir = '0') then
					case rot_sel is
						when "000"  => s_letter_out <= "00011"; -- rotor 1, D
						when "001"  => s_letter_out <= "10001"; -- rotor 2, R
						when "010"  => s_letter_out <= "00010"; -- rotor 3, C
						when "011"  => s_letter_out <= "01001"; -- rotor 4, J
						when "100"  => s_letter_out <= "10011"; -- rotor 5, T
						when "101"  => s_letter_out <= "01100"; -- rotor 6, M
						when "110"  => s_letter_out <= "00010"; -- rotor 7, C
						when others => s_letter_out <= "10111"; -- rotor 8, X
					end case;
				else
					case rot_sel is
						when "000"  => s_letter_out <= "00101"; -- rotor 1, F
						when "001"  => s_letter_out <= "10001"; -- rotor 2, R
						when "010"  => s_letter_out <= "10010"; -- rotor 3, S
						when "011"  => s_letter_out <= "10011"; -- rotor 4, T
						when "100"  => s_letter_out <= "00100"; -- rotor 5, E
						when "101"  => s_letter_out <= "00010"; -- rotor 6, C
						when "110"  => s_letter_out <= "00100"; -- rotor 7, E
						when others => s_letter_out <= "11000"; -- rotor 8, Y
					end case;
				end if;
			when "00111" =>    -- H
				if (pass_dir = '0') then
					case rot_sel is
						when "000"  => s_letter_out <= "10000"; -- rotor 1, Q
						when "001"  => s_letter_out <= "10100"; -- rotor 2, U
						when "010"  => s_letter_out <= "01111"; -- rotor 3, P
						when "011"  => s_letter_out <= "00000"; -- rotor 4, A
						when "100"  => s_letter_out <= "11000"; -- rotor 5, Y
						when "101"  => s_letter_out <= "00101"; -- rotor 6, F
						when "110"  => s_letter_out <= "10111"; -- rotor 7, X
						when others => s_letter_out <= "01110"; -- rotor 8, O
					end case;
				else
					case rot_sel is
						when "000"  => s_letter_out <= "01111"; -- rotor 1, P
						when "001"  => s_letter_out <= "01011"; -- rotor 2, L
						when "010"  => s_letter_out <= "00011"; -- rotor 3, D
						when "011"  => s_letter_out <= "01101"; -- rotor 4, N
						when "100"  => s_letter_out <= "01101"; -- rotor 5, N
						when "101"  => s_letter_out <= "01101"; -- rotor 6, N
						when "110"  => s_letter_out <= "00011"; -- rotor 7, D
						when others => s_letter_out <= "00011"; -- rotor 8, D
					end case;
				end if;
			when "01000" =>    -- I
				if (pass_dir = '0') then
					case rot_sel is
						when "000"  => s_letter_out <= "10101"; -- rotor 1, V
						when "001"  => s_letter_out <= "10111"; -- rotor 2, X
						when "010"  => s_letter_out <= "10001"; -- rotor 3, R
						when "011"  => s_letter_out <= "11000"; -- rotor 4, Y
						when "100"  => s_letter_out <= "10100"; -- rotor 5, U
						when "101"  => s_letter_out <= "11000"; -- rotor 6, Y
						when "110"  => s_letter_out <= "01100"; -- rotor 7, M
						when others => s_letter_out <= "00010"; -- rotor 8, C
					end case;
				else
					case rot_sel is
						when "000"  => s_letter_out <= "10101"; -- rotor 1, V
						when "001"  => s_letter_out <= "00101"; -- rotor 2, F
						when "010"  => s_letter_out <= "10000"; -- rotor 3, Q
						when "011"  => s_letter_out <= "01011"; -- rotor 4, L
						when "100"  => s_letter_out <= "00101"; -- rotor 5, F
						when "101"  => s_letter_out <= "10110"; -- rotor 6, W
						when "110"  => s_letter_out <= "10001"; -- rotor 7, R
						when others => s_letter_out <= "10101"; -- rotor 8, V
					end case;
				end if;
			when "01001" =>    -- J
				if (pass_dir = '0') then
					case rot_sel is
						when "000"  => s_letter_out <= "11001"; -- rotor 1, Z
						when "001"  => s_letter_out <= "00001"; -- rotor 2, B
						when "010"  => s_letter_out <= "10011"; -- rotor 3, T
						when "011"  => s_letter_out <= "10000"; -- rotor 4, Q
						when "100"  => s_letter_out <= "01111"; -- rotor 5, P
						when "101"  => s_letter_out <= "10000"; -- rotor 6, Q
						when "110"  => s_letter_out <= "11000"; -- rotor 7, Y
						when others => s_letter_out <= "00001"; -- rotor 8, B
					end case;
				else
					case rot_sel is
						when "000"  => s_letter_out <= "11001"; -- rotor 1, Z
						when "001"  => s_letter_out <= "00001"; -- rotor 2, B
						when "010"  => s_letter_out <= "00100"; -- rotor 3, E
						when "011"  => s_letter_out <= "00110"; -- rotor 4, G
						when "100"  => s_letter_out <= "10011"; -- rotor 5, T
						when "101"  => s_letter_out <= "00000"; -- rotor 6, A
						when "110"  => s_letter_out <= "00010"; -- rotor 7, C
						when others => s_letter_out <= "01010"; -- rotor 8, K
					end case;
				end if;
			when "01010" =>    -- K
				if (pass_dir = '0') then
					case rot_sel is
						when "000"  => s_letter_out <= "01101"; -- rotor 1, N
						when "001"  => s_letter_out <= "01011"; -- rotor 2, L
						when "010"  => s_letter_out <= "10111"; -- rotor 3, X
						when "011"  => s_letter_out <= "10100"; -- rotor 4, U
						when "100"  => s_letter_out <= "10010"; -- rotor 5, S
						when "101"  => s_letter_out <= "00001"; -- rotor 6, B
						when "110"  => s_letter_out <= "10010"; -- rotor 7, S
						when others => s_letter_out <= "01001"; -- rotor 8, J
					end case;
				else
					case rot_sel is
						when "000"  => s_letter_out <= "00001"; -- rotor 1, B
						when "001"  => s_letter_out <= "00011"; -- rotor 2, D
						when "010"  => s_letter_out <= "10100"; -- rotor 3, U
						when "011"  => s_letter_out <= "10100"; -- rotor 4, U
						when "100"  => s_letter_out <= "11001"; -- rotor 5, Z
						when "101"  => s_letter_out <= "10001"; -- rotor 6, R
						when "110"  => s_letter_out <= "10110"; -- rotor 7, W
						when others => s_letter_out <= "00001"; -- rotor 8, B
					end case;
				end if;
			when "01011" =>    -- L
				if (pass_dir = '0') then
					case rot_sel is
						when "000"  => s_letter_out <= "10011"; -- rotor 1, T
						when "001"  => s_letter_out <= "00111"; -- rotor 2, H
						when "010"  => s_letter_out <= "10101"; -- rotor 3, V
						when "011"  => s_letter_out <= "01000"; -- rotor 4, I
						when "100"  => s_letter_out <= "00011"; -- rotor 5, D
						when "101"  => s_letter_out <= "00100"; -- rotor 6, E
						when "110"  => s_letter_out <= "10110"; -- rotor 7, W
						when others => s_letter_out <= "10010"; -- rotor 8, S
					end case;
				else
					case rot_sel is
						when "000"  => s_letter_out <= "00100"; -- rotor 1, E
						when "001"  => s_letter_out <= "01010"; -- rotor 2, K
						when "010"  => s_letter_out <= "00101"; -- rotor 3, F
						when "011"  => s_letter_out <= "01111"; -- rotor 4, P
						when "100"  => s_letter_out <= "01110"; -- rotor 5, O
						when "101"  => s_letter_out <= "10101"; -- rotor 6, V
						when "110"  => s_letter_out <= "10011"; -- rotor 7, T
						when others => s_letter_out <= "00101"; -- rotor 8, F
					end case;
				end if;
			when "01100" =>    -- M
				if (pass_dir = '0') then
					case rot_sel is
						when "000"  => s_letter_out <= "01110"; -- rotor 1, O
						when "001"  => s_letter_out <= "10110"; -- rotor 2, W
						when "010"  => s_letter_out <= "11001"; -- rotor 3, Z
						when "011"  => s_letter_out <= "10001"; -- rotor 4, R
						when "100"  => s_letter_out <= "01101"; -- rotor 5, N
						when "101"  => s_letter_out <= "01101"; -- rotor 6, N
						when "110"  => s_letter_out <= "00001"; -- rotor 7, B
						when others => s_letter_out <= "01111"; -- rotor 8, P
					end case;
				else
					case rot_sel is
						when "000"  => s_letter_out <= "00010"; -- rotor 1, C
						when "001"  => s_letter_out <= "01110"; -- rotor 2, O
						when "010"  => s_letter_out <= "10101"; -- rotor 3, V
						when "011"  => s_letter_out <= "10111"; -- rotor 4, X
						when "100"  => s_letter_out <= "10010"; -- rotor 5, S
						when "101"  => s_letter_out <= "00110"; -- rotor 6, G
						when "110"  => s_letter_out <= "01000"; -- rotor 7, I
						when others => s_letter_out <= "10001"; -- rotor 8, R
					end case;
				end if;
			when "01101" =>    -- N
				if (pass_dir = '0') then
					case rot_sel is
						when "000"  => s_letter_out <= "10110"; -- rotor 1, W 
						when "001"  => s_letter_out <= "10011"; -- rotor 2, T
						when "010"  => s_letter_out <= "01101"; -- rotor 3, N
						when "011"  => s_letter_out <= "00111"; -- rotor 4, H
						when "100"  => s_letter_out <= "00111"; -- rotor 5, H
						when "101"  => s_letter_out <= "00111"; -- rotor 6, H
						when "110"  => s_letter_out <= "01110"; -- rotor 7, O
						when others => s_letter_out <= "00011"; -- rotor 8, D
					end case;
				else
					case rot_sel is
						when "000"  => s_letter_out <= "01010"; -- rotor 1, K
						when "001"  => s_letter_out <= "10011"; -- rotor 2, T
						when "010"  => s_letter_out <= "01101"; -- rotor 3, N
						when "011"  => s_letter_out <= "10000"; -- rotor 4, Q
						when "100"  => s_letter_out <= "01100"; -- rotor 5, M
						when "101"  => s_letter_out <= "01100"; -- rotor 6, M
						when "110"  => s_letter_out <= "00000"; -- rotor 7, A
						when others => s_letter_out <= "10100"; -- rotor 8, U
					end case;
				end if;
			when "01110" =>    -- O
				if (pass_dir = '0') then
					case rot_sel is
						when "000"  => s_letter_out <= "11000"; -- rotor 1, Y
						when "001"  => s_letter_out <= "01100"; -- rotor 2, M
						when "010"  => s_letter_out <= "11000"; -- rotor 3, Y
						when "011"  => s_letter_out <= "10111"; -- rotor 4, X
						when "100"  => s_letter_out <= "01011"; -- rotor 5, L
						when "101"  => s_letter_out <= "11001"; -- rotor 6, Z
						when "110"  => s_letter_out <= "10100"; -- rotor 7, U
						when others => s_letter_out <= "11001"; -- rotor 8, Z
					end case;
				else
					case rot_sel is
						when "000"  => s_letter_out <= "01100"; -- rotor 1, M
						when "001"  => s_letter_out <= "11000"; -- rotor 2, Y
						when "010"  => s_letter_out <= "11001"; -- rotor 3, Z
						when "011"  => s_letter_out <= "00010"; -- rotor 4, C
						when "100"  => s_letter_out <= "10101"; -- rotor 5, V
						when "101"  => s_letter_out <= "00100"; -- rotor 6, E
						when "110"  => s_letter_out <= "01101"; -- rotor 7, N
						when others => s_letter_out <= "00111"; -- rotor 8, H
					end case;
				end if;
			when "01111" =>    -- P
				if (pass_dir = '0') then
					case rot_sel is
						when "000"  => s_letter_out <= "00111"; -- rotor 1, H
						when "001"  => s_letter_out <= "00010"; -- rotor 2, C
						when "010"  => s_letter_out <= "00100"; -- rotor 3, E
						when "011"  => s_letter_out <= "01011"; -- rotor 4, L
						when "100"  => s_letter_out <= "10111"; -- rotor 5, X
						when "101"  => s_letter_out <= "10001"; -- rotor 6, R
						when "110"  => s_letter_out <= "00101"; -- rotor 7, F
						when others => s_letter_out <= "10001"; -- rotor 8, R
					end case;
				else
					case rot_sel is
						when "000"  => s_letter_out <= "10011"; -- rotor 1, T
						when "001"  => s_letter_out <= "10100"; -- rotor 2, U
						when "010"  => s_letter_out <= "00111"; -- rotor 3, H
						when "011"  => s_letter_out <= "00100"; -- rotor 4, E
						when "100"  => s_letter_out <= "01001"; -- rotor 5, J
						when "101"  => s_letter_out <= "00001"; -- rotor 6, B
						when "110"  => s_letter_out <= "10100"; -- rotor 7, U
						when others => s_letter_out <= "01100"; -- rotor 8, M
					end case;
				end if;
			when "10000" =>    -- Q
				if (pass_dir = '0') then
					case rot_sel is
						when "000"  => s_letter_out <= "10111"; -- rotor 1, X 
						when "001"  => s_letter_out <= "10000"; -- rotor 2, Q
						when "010"  => s_letter_out <= "01000"; -- rotor 3, I
						when "011"  => s_letter_out <= "01101"; -- rotor 4, N
						when "100"  => s_letter_out <= "00000"; -- rotor 5, A
						when "101"  => s_letter_out <= "00011"; -- rotor 6, D
						when "110"  => s_letter_out <= "00000"; -- rotor 7, A
						when others => s_letter_out <= "00000"; -- rotor 8, A
					end case;
				else
					case rot_sel is
						when "000"  => s_letter_out <= "00111"; -- rotor 1, H 
						when "001"  => s_letter_out <= "10000"; -- rotor 2, Q
						when "010"  => s_letter_out <= "11000"; -- rotor 3, Y
						when "011"  => s_letter_out <= "01001"; -- rotor 4, J
						when "100"  => s_letter_out <= "10100"; -- rotor 5, U
						when "101"  => s_letter_out <= "01001"; -- rotor 6, J
						when "110"  => s_letter_out <= "10111"; -- rotor 7, X
						when others => s_letter_out <= "00010"; -- rotor 8, C
					end case;
				end if;
			when "10001" =>    -- R
				if (pass_dir = '0') then
					case rot_sel is
						when "000"  => s_letter_out <= "10100"; -- rotor 1, U
						when "001"  => s_letter_out <= "00110"; -- rotor 2, G
						when "010"  => s_letter_out <= "10110"; -- rotor 3, W
						when "011"  => s_letter_out <= "00101"; -- rotor 4, F
						when "100"  => s_letter_out <= "10110"; -- rotor 5, W
						when "101"  => s_letter_out <= "01010"; -- rotor 6, K
						when "110"  => s_letter_out <= "01000"; -- rotor 7, I
						when others => s_letter_out <= "01100"; -- rotor 8, M
					end case;
				else
					case rot_sel is
						when "000"  => s_letter_out <= "10111"; -- rotor 1, X
						when "001"  => s_letter_out <= "00110"; -- rotor 2, G
						when "010"  => s_letter_out <= "01000"; -- rotor 3, I
						when "011"  => s_letter_out <= "01100"; -- rotor 4, M
						when "100"  => s_letter_out <= "00011"; -- rotor 5, D
						when "101"  => s_letter_out <= "01111"; -- rotor 6, P
						when "110"  => s_letter_out <= "00101"; -- rotor 7, F
						when others => s_letter_out <= "01111"; -- rotor 8, P
					end case;
				end if;
			when "10010" =>    -- S
				if (pass_dir = '0') then
					case rot_sel is
						when "000"  => s_letter_out <= "10010"; -- rotor 1, S
						when "001"  => s_letter_out <= "11001"; -- rotor 2, Z
						when "010"  => s_letter_out <= "00110"; -- rotor 3, G
						when "011"  => s_letter_out <= "10011"; -- rotor 4, T
						when "100"  => s_letter_out <= "01100"; -- rotor 5, M
						when "101"  => s_letter_out <= "00000"; -- rotor 6, A
						when "110"  => s_letter_out <= "10101"; -- rotor 7, V
						when others => s_letter_out <= "00100"; -- rotor 8, E
					end case;
				else
					case rot_sel is
						when "000"  => s_letter_out <= "10010"; -- rotor 1, S
						when "001"  => s_letter_out <= "00100"; -- rotor 2, E
						when "010"  => s_letter_out <= "10111"; -- rotor 3, X
						when "011"  => s_letter_out <= "00001"; -- rotor 4, B
						when "100"  => s_letter_out <= "01010"; -- rotor 5, K
						when "101"  => s_letter_out <= "10011"; -- rotor 6, T
						when "110"  => s_letter_out <= "01010"; -- rotor 7, K
						when others => s_letter_out <= "01011"; -- rotor 8, L
					end case;
				end if;
			when "10011" =>    -- T
				if (pass_dir = '0') then
					case rot_sel is
						when "000"  => s_letter_out <= "01111"; -- rotor 1, P
						when "001"  => s_letter_out <= "01101"; -- rotor 2, N
						when "010"  => s_letter_out <= "00000"; -- rotor 3, A
						when "011"  => s_letter_out <= "00110"; -- rotor 4, G
						when "100"  => s_letter_out <= "01001"; -- rotor 5, J
						when "101"  => s_letter_out <= "10010"; -- rotor 6, S
						when "110"  => s_letter_out <= "01011"; -- rotor 7, L
						when others => s_letter_out <= "10110"; -- rotor 8, W
					end case;
				else
					case rot_sel is
						when "000"  => s_letter_out <= "01011"; -- rotor 1, L
						when "001"  => s_letter_out <= "01101"; -- rotor 2, N
						when "010"  => s_letter_out <= "01001"; -- rotor 3, J
						when "011"  => s_letter_out <= "10010"; -- rotor 4, S
						when "100"  => s_letter_out <= "00110"; -- rotor 5, G
						when "101"  => s_letter_out <= "11000"; -- rotor 6, Y
						when "110"  => s_letter_out <= "11001"; -- rotor 7, Z
						when others => s_letter_out <= "00100"; -- rotor 8, E
					end case;
				end if;
			when "10100" =>    -- U
				if (pass_dir = '0') then
					case rot_sel is
						when "000"  => s_letter_out <= "00000"; -- rotor 1, A
						when "001"  => s_letter_out <= "01111"; -- rotor 2, P
						when "010"  => s_letter_out <= "01010"; -- rotor 3, K
						when "011"  => s_letter_out <= "01010"; -- rotor 4, K
						when "100"  => s_letter_out <= "10000"; -- rotor 5, Q
						when "101"  => s_letter_out <= "10111"; -- rotor 6, X
						when "110"  => s_letter_out <= "01111"; -- rotor 7, P
						when others => s_letter_out <= "01101"; -- rotor 8, N
					end case;
				else
					case rot_sel is
						when "000"  => s_letter_out <= "10001"; -- rotor 1, R
						when "001"  => s_letter_out <= "00111"; -- rotor 2, H
						when "010"  => s_letter_out <= "10110"; -- rotor 3, W
						when "011"  => s_letter_out <= "01010"; -- rotor 4, K
						when "100"  => s_letter_out <= "01000"; -- rotor 5, I
						when "101"  => s_letter_out <= "00101"; -- rotor 6, F
						when "110"  => s_letter_out <= "01110"; -- rotor 7, O
						when others => s_letter_out <= "10110"; -- rotor 8, W
					end case;
				end if;
			when "10101" =>    -- V
				if (pass_dir = '0') then
					case rot_sel is
						when "000"  => s_letter_out <= "01000"; -- rotor 1, I 
						when "001"  => s_letter_out <= "11000"; -- rotor 2, Y
						when "010"  => s_letter_out <= "01100"; -- rotor 3, M
						when "011"  => s_letter_out <= "00011"; -- rotor 4, D
						when "100"  => s_letter_out <= "01110"; -- rotor 5, O
						when "101"  => s_letter_out <= "01011"; -- rotor 6, L
						when "110"  => s_letter_out <= "00100"; -- rotor 7, E
						when others => s_letter_out <= "01000"; -- rotor 8, I
					end case;
				else
					case rot_sel is
						when "000"  => s_letter_out <= "01000"; -- rotor 1, I
						when "001"  => s_letter_out <= "10111"; -- rotor 2, X
						when "010"  => s_letter_out <= "01011"; -- rotor 3, L
						when "011"  => s_letter_out <= "00011"; -- rotor 4, D
						when "100"  => s_letter_out <= "00000"; -- rotor 5, A
						when "101"  => s_letter_out <= "00011"; -- rotor 6, D
						when "110"  => s_letter_out <= "10010"; -- rotor 7, S
						when others => s_letter_out <= "11001"; -- rotor 8, Z
					end case;
				end if;
			when "10110" =>    -- W
				if (pass_dir = '0') then
					case rot_sel is
						when "000"  => s_letter_out <= "00001"; -- rotor 1, B
						when "001"  => s_letter_out <= "00101"; -- rotor 2, F
						when "010"  => s_letter_out <= "10100"; -- rotor 3, U
						when "011"  => s_letter_out <= "00010"; -- rotor 4, C
						when "100"  => s_letter_out <= "00101"; -- rotor 5, F
						when "101"  => s_letter_out <= "01000"; -- rotor 6, I
						when "110"  => s_letter_out <= "01010"; -- rotor 7, K
						when others => s_letter_out <= "10100"; -- rotor 8, U
					end case;
				else
					case rot_sel is
						when "000"  => s_letter_out <= "01101"; -- rotor 1, N
						when "001"  => s_letter_out <= "01100"; -- rotor 2, M
						when "010"  => s_letter_out <= "10001"; -- rotor 3, R
						when "011"  => s_letter_out <= "11000"; -- rotor 4, Y
						when "100"  => s_letter_out <= "10001"; -- rotor 5, R
						when "101"  => s_letter_out <= "11001"; -- rotor 6, Z
						when "110"  => s_letter_out <= "01011"; -- rotor 7, L
						when others => s_letter_out <= "10011"; -- rotor 8, T
					end case;
				end if;
			when "10111" =>    -- X
				if (pass_dir = '0') then
					case rot_sel is
						when "000"  => s_letter_out <= "10001"; -- rotor 1, R
						when "001"  => s_letter_out <= "10101"; -- rotor 2, V
						when "010"  => s_letter_out <= "10010"; -- rotor 3, S
						when "011"  => s_letter_out <= "01100"; -- rotor 4, M
						when "100"  => s_letter_out <= "00100"; -- rotor 5, E
						when "101"  => s_letter_out <= "00010"; -- rotor 6, C
						when "110"  => s_letter_out <= "10000"; -- rotor 7, Q
						when others => s_letter_out <= "11000"; -- rotor 8, Y
					end case;
				else
					case rot_sel is
						when "000"  => s_letter_out <= "10000"; -- rotor 1, Q
						when "001"  => s_letter_out <= "01000"; -- rotor 2, I
						when "010"  => s_letter_out <= "01010"; -- rotor 3, K
						when "011"  => s_letter_out <= "01110"; -- rotor 4, O
						when "100"  => s_letter_out <= "01111"; -- rotor 5, P
						when "101"  => s_letter_out <= "10100"; -- rotor 6, U
						when "110"  => s_letter_out <= "00111"; -- rotor 7, H
						when others => s_letter_out <= "00110"; -- rotor 8, G
					end case;
				end if;
			when "11000" =>    -- Y
				if (pass_dir = '0') then
					case rot_sel is
						when "000"  => s_letter_out <= "00010"; -- rotor 1, C
						when "001"  => s_letter_out <= "01110"; -- rotor 2, O
						when "010"  => s_letter_out <= "10000"; -- rotor 3, Q
						when "011"  => s_letter_out <= "10110"; -- rotor 4, W
						when "100"  => s_letter_out <= "00010"; -- rotor 5, C
						when "101"  => s_letter_out <= "10011"; -- rotor 6, T
						when "110"  => s_letter_out <= "00011"; -- rotor 7, D
						when others => s_letter_out <= "00110"; -- rotor 8, G
					end case;
				else
					case rot_sel is
						when "000"  => s_letter_out <= "01110"; -- rotor 1, O
						when "001"  => s_letter_out <= "10101"; -- rotor 2, V
						when "010"  => s_letter_out <= "01110"; -- rotor 3, O
						when "011"  => s_letter_out <= "01000"; -- rotor 4, I
						when "100"  => s_letter_out <= "00111"; -- rotor 5, H
						when "101"  => s_letter_out <= "01000"; -- rotor 6, I
						when "110"  => s_letter_out <= "01001"; -- rotor 7, J
						when others => s_letter_out <= "10111"; -- rotor 8, X
					end case;
				end if;
			when "11001" =>    -- Z
				if (pass_dir = '0') then
					case rot_sel is
						when "000"  => s_letter_out <= "01001"; -- rotor 1, J
						when "001"  => s_letter_out <= "00100"; -- rotor 2, E
						when "010"  => s_letter_out <= "01110"; -- rotor 3, O
						when "011"  => s_letter_out <= "00001"; -- rotor 4, B
						when "100"  => s_letter_out <= "01010"; -- rotor 5, K
						when "101"  => s_letter_out <= "10110"; -- rotor 6, W
						when "110"  => s_letter_out <= "10011"; -- rotor 7, T
						when others => s_letter_out <= "10101"; -- rotor 8, V
					end case;
				else
					case rot_sel is
						when "000"  => s_letter_out <= "01001"; -- rotor 1, J
						when "001"  => s_letter_out <= "10010"; -- rotor 2, S
						when "010"  => s_letter_out <= "01100"; -- rotor 3, M
						when "011"  => s_letter_out <= "00101"; -- rotor 4, F
						when "100"  => s_letter_out <= "00001"; -- rotor 5, B
						when "101"  => s_letter_out <= "01110"; -- rotor 6, O
						when "110"  => s_letter_out <= "00001"; -- rotor 7, B
						when others => s_letter_out <= "01110"; -- rotor 8, O
					end case;
				end if;
			when others =>     -- should never be reached
				s_letter_out <= (others => '1'); -- non-existing letter code ("11111")
		end case;
	end process pass_rot;
	
	

	-- Opposite process of pre_process_letter
	post_process_letter : process (s_letter_out, rot_ring, rot_pos)
		variable s_let_val : unsigned(5 downto 0); -- must be able to at house 52 (26*2)
	begin
		-- adjust for Grundstellung (rotor's starting position)
		-- adding 26 to letter value garantees we'll never deal with negative numbers
		s_let_val := unsigned(s_letter_out) + "011010";  
		s_let_val := (s_let_val - unsigned(rot_pos)) rem 26; -- it's necessary
																			  --	to rem here so
																			  -- there's	no chance 
																			  -- of overflow in the
																			  -- next operation
		
		-- adjust for Ringstellung (ring position)
		--s_let_val := s_let_val + unsigned(rot_ring);
		s_let_val := s_let_val + unsigned(rot_ring);
		
		letter_out <= std_logic_vector(s_let_val rem 26)(4 downto 0);
		
	end process post_process_letter;

end Behavioral;
