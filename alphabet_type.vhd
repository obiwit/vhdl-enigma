library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package alphabet_type is
    type alphabet is array(0 to 25) of std_logic_vector (4 downto 0);
end package alphabet_type;
