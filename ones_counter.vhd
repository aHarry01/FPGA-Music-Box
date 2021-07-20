library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- counts the number of ones in a 12 bit input vector
-- since synth only plays 4 note at a time, sum shouldn't be over 4 
-- full adders count how many ones in 3 bits, then add those sums together with numeric_std function

entity ones_counter is
    PORT ( i_values : in STD_LOGIC_VECTOR (11 downto 0);
           o_num_ones : out unsigned(2 downto 0));
end ones_counter;

architecture Behavioral of ones_counter is

component full_adder
    PORT ( 
        A : in STD_LOGIC_VECTOR(2 downto 0);
        sum : out unsigned(1 downto 0)
    );
end component;

signal s1 : unsigned(1 downto 0);
signal s2 : unsigned(1 downto 0);
signal s3 : unsigned(1 downto 0);
signal s4 : unsigned(1 downto 0);

begin

one : component full_adder PORT MAP( A => i_values(2 downto 0), sum => s1);
two : component full_adder PORT MAP( A => i_values(5 downto 3), sum => s2);
three : component full_adder PORT MAP( A => i_values(8 downto 6), sum => s3);
four : component full_adder PORT MAP( A => i_values(11 downto 9), sum => s4);

o_num_ones <= (('0' & s1) + ('0' & s2) + ('0' & s3) + ('0' & s4));


end Behavioral;
