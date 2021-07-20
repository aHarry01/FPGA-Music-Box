library work;
use work.custom_package.all;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- adds the values of the amplitudes to get the total amplitude of the wave
-- since synth only plays 4 note at a time, sum shouldn't be over 16

entity amplitude_adder is
    PORT ( i_values : in threebit_arr;
           o_amplitude : out unsigned(4 downto 0));
end amplitude_adder;

architecture Behavioral of amplitude_adder is

begin

o_amplitude <= ("00" & i_values(0)) + ("00" & i_values(1)) + ("00" & i_values(2)) + ("00" & i_values(3)) + 
               ("00" & i_values(4)) + ("00" & i_values(5)) + ("00" & i_values(6)) + ("00" & i_values(7)) + 
               ("00" & i_values(8)) + ("00" & i_values(9)) + ("00" & i_values(10)) + ("00" & i_values(11));

end Behavioral;
