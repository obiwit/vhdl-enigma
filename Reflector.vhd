library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity Reflector is
	port(ref_sel    : in  std_logic;
		  letter_in  : in  std_logic_vector(4 downto 0);
		  letter_out : out std_logic_vector(4 downto 0));
end Reflector;

architecture Behavioral of Reflector is
	signal s_letter_out : std_logic_vector(4 downto 0);
begin

	reflect: process (letter_in, ref_sel)
	begin
		case letter_in is
			when "00000" =>    -- A
				case ref_sel is
					when '0'    => s_letter_out <= "11000"; -- reflector b, Y
					when others => s_letter_out <= "00101"; -- reflector c, F
				end case;
			when "00001" =>    -- B
				case ref_sel is
					when '0'    => s_letter_out <= "10001"; -- reflector b, R
					when others => s_letter_out <= "10101"; -- reflector c, V
				end case;
			when "00010" =>    -- C
				case ref_sel is
					when '0'    => s_letter_out <= "10100"; -- reflector b, U
					when others => s_letter_out <= "01111"; -- reflector c, P
				end case;
			when "00011" =>    -- D
				case ref_sel is
					when '0'    => s_letter_out <= "00111"; -- reflector b, H
					when others => s_letter_out <= "01001"; -- reflector c, J
				end case;
			when "00100" =>    -- E
				case ref_sel is
					when '0'    => s_letter_out <= "10000"; -- reflector b, Q
					when others => s_letter_out <= "01000"; -- reflector c, I
				end case;
			when "00101" =>    -- F
				case ref_sel is
					when '0'    => s_letter_out <= "10010"; -- reflector b, S
					when others => s_letter_out <= "00000"; -- reflector c, A
				end case;
			when "00110" =>    -- G
				case ref_sel is
					when '0'    => s_letter_out <= "01011"; -- reflector b, L
					when others => s_letter_out <= "01110"; -- reflector c, O
				end case;
			when "00111" =>    -- H
				case ref_sel is
					when '0'    => s_letter_out <= "00011"; -- reflector b, D
					when others => s_letter_out <= "11000"; -- reflector c, Y
				end case;
			when "01000" =>    -- I
				case ref_sel is
					when '0'    => s_letter_out <= "01111"; -- reflector b, P
					when others => s_letter_out <= "00100"; -- reflector c, E
				end case;
			when "01001" =>    -- J
				case ref_sel is
					when '0'    => s_letter_out <= "10111"; -- reflector b, X
					when others => s_letter_out <= "00011"; -- reflector c, D
				end case;
			when "01010" =>    -- K
				case ref_sel is
					when '0'    => s_letter_out <= "01101"; -- reflector b, N
					when others => s_letter_out <= "10001"; -- reflector c, R
				end case;
			when "01011" =>    -- L
				case ref_sel is
					when '0'    => s_letter_out <= "00110"; -- reflector b, G
					when others => s_letter_out <= "11001"; -- reflector c, Z
				end case;
			when "01100" =>    -- M
				case ref_sel is
					when '0'    => s_letter_out <= "01110"; -- reflector b, O
					when others => s_letter_out <= "10111"; -- reflector c, X
				end case;
			when "01101" =>    -- N
				case ref_sel is
					when '0'    => s_letter_out <= "01010"; -- reflector b, K
					when others => s_letter_out <= "10110"; -- reflector c, W
				end case;
			when "01110" =>    -- O
				case ref_sel is
					when '0'    => s_letter_out <= "01100"; -- reflector b, M
					when others => s_letter_out <= "00110"; -- reflector c, G
				end case;
			when "01111" =>    -- P
				case ref_sel is
					when '0'    => s_letter_out <= "01000"; -- reflector b, I
					when others => s_letter_out <= "00010"; -- reflector c, C
				end case;
			when "10000" =>    -- Q
				case ref_sel is
					when '0'    => s_letter_out <= "00100"; -- reflector b, E
					when others => s_letter_out <= "10011"; -- reflector c, T
				end case;
			when "10001" =>    -- R
				case ref_sel is
					when '0'    => s_letter_out <= "00001"; -- reflector b, B
					when others => s_letter_out <= "01010"; -- reflector c, K
				end case;
			when "10010" =>    -- S
				case ref_sel is
					when '0'    => s_letter_out <= "00101"; -- reflector b, F
					when others => s_letter_out <= "10100"; -- reflector c, U
				end case;
			when "10011" =>    -- T
				case ref_sel is
					when '0'    => s_letter_out <= "11001"; -- reflector b, Z
					when others => s_letter_out <= "10000"; -- reflector c, Q
				end case;
			when "10100" =>    -- U
				case ref_sel is
					when '0'    => s_letter_out <= "00010"; -- reflector b, C
					when others => s_letter_out <= "10010"; -- reflector c, S
				end case;
			when "10101" =>    -- V
				case ref_sel is
					when '0'    => s_letter_out <= "10110"; -- reflector b, W
					when others => s_letter_out <= "00001"; -- reflector c, B
				end case;
			when "10110" =>    -- W
				case ref_sel is
					when '0'    => s_letter_out <= "10101"; -- reflector b, V
					when others => s_letter_out <= "01101"; -- reflector c, N
				end case;
			when "10111" =>    -- X
				case ref_sel is
					when '0'    => s_letter_out <= "01001"; -- reflector b, J
					when others => s_letter_out <= "01100"; -- reflector c, M
				end case;
			when "11000" =>    -- Y
				case ref_sel is
					when '0'    => s_letter_out <= "00000"; -- reflector b, A
					when others => s_letter_out <= "00111"; -- reflector c, H
				end case;
			when "11001" =>    -- Z
				case ref_sel is
					when '0'    => s_letter_out <= "10011"; -- reflector b, T
					when others => s_letter_out <= "01011"; -- reflector c, L
				end case;
			when others =>     -- should never be reached
				s_letter_out <= (others => '1'); -- non-existing letter code ("11111")
			end case;
		end process;
				
		letter_out <= s_letter_out;

end Behavioral;