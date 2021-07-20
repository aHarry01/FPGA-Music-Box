library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity full_adder is
    PORT ( 
        A : in STD_LOGIC_VECTOR(2 downto 0);
        sum : out unsigned(1 downto 0)
    );
end full_adder;

architecture behavioral of full_adder is

begin

sum(0) <= (A(0) xor A(1)) xor A(2);
sum(1) <= (A(0) and A(1)) or (A(1) and A(2)) or (A(0) and A(2)); --carry

end behavioral;
