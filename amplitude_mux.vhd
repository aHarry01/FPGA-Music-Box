library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity amplitude_mux is
    PORT ( i_input_amp  : in unsigned(4 downto 0);
     i_song_amp : in unsigned(4 downto 0);
     i_select : in STD_LOGIC;
     o_amp : out unsigned(4 downto 0));
end amplitude_mux;

architecture Behavioral of amplitude_mux is

begin

o_amp(0) <= (i_input_amp(0) and not i_select) or (i_song_amp(0) and i_select);
o_amp(1) <= (i_input_amp(1) and not i_select) or (i_song_amp(1) and i_select);
o_amp(2) <= (i_input_amp(2) and not i_select) or (i_song_amp(2) and i_select);
o_amp(3) <= (i_input_amp(3) and not i_select) or (i_song_amp(3) and i_select);
o_amp(4) <= (i_input_amp(4) and not i_select) or (i_song_amp(4) and i_select);

end Behavioral;
