library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity Enigma is
	port(CLOCK_50 : in  std_logic;
        KEY      : in  std_logic_vector(1 downto 0);
        SW       : in  std_logic_vector(17 downto 0);
        LEDR     : out std_logic_vector(15 downto 0);
		  HEX0		: out std_logic_vector(6 downto 0);
		  HEX1		: out std_logic_vector(6 downto 0);
		  HEX2		: out std_logic_vector(6 downto 0);
		  HEX3		: out std_logic_vector(6 downto 0);
		  --HEX4		: out std_logic_vector(6 downto 0);
		  --HEX5		: out std_logic_vector(6 downto 0);
		  --HEX6		: out std_logic_vector(6 downto 0);
		  --HEX7		: out std_logic_vector(6 downto 0);
        LEDG     : out std_logic_vector(8 downto 0));
end Enigma;

architecture Structural of Enigma is
begin
end Structural;