library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

package custom_package is
    type int_arr is array (integer range <>) of unsigned(31 downto 0);
    type threebit_arr is array (integer range <>) of unsigned(2 downto 0);
    type byte_arr is array (integer range<>) of unsigned(7 downto 0);
    
end custom_package;