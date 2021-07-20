library work;
use work.custom_package.all;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity music_box is
  Port (clk : in STD_LOGIC;
        i_sel : in STD_LOGIC_VECTOR(1 downto 0); --begins playing on rising edge of i_start(0)
        o_amp : out unsigned(4 downto 0));
end music_box;

architecture Behavioral of music_box is

component wave_generator
    PORT(
        clk, i_enable : STD_LOGIC;
        i_count : in unsigned(31 downto 0);
        o_value : out unsigned(2 downto 0));
end component;

component song_mux
Port ( 
    clk : in STD_LOGIC;
    sel : in STD_LOGIC_VECTOR(1 downto 0);
    reset : in STD_LOGIC;
    note_info : out byte_arr(3 downto 0);
    done : out STD_LOGIC
);
end component;

signal i_start : STD_LOGIC := '0';

signal note_counts : int_arr(0 to 3) := (0 => to_unsigned(382216,32),others => to_unsigned(0,32));
signal note_enables : STD_LOGIC_VECTOR(0 to 3) := "0000";
signal note_terminate : STD_LOGIC_VECTOR(0 to 3) := "0000"; --controls whether this note terminates on this beat or not (if it does then it won't play for the last ~10% of the beat)
signal r_note_outputs : threebit_arr(0 to 3) := (others => "000");

signal r_read_data : STD_LOGIC_VECTOR := "00"; --bit 1 is for Beethoven Virus, bit 0 is for the office
signal r_done_reading : STD_LOGIC := '0';
signal r_start_playing : STD_LOGIC := '0';
signal r_reset : STD_LOGIC := '0';

signal r_enable : STD_LOGIC := '0';
constant CYCLES_PER_BEAT : unsigned(31 downto 0) := to_unsigned(20000000,32); --clk cycles per beat, this is 150 bpm where 1 beat is quarter note
constant CYCLES_PER_PART_BEAT : unsigned(31 downto 0) := to_unsigned(18000000,32); --clk cycles for 90% of a beat so there is a break b/w notes
signal beat_counter : unsigned(31 downto 0) := (others => '0');
signal note_info : byte_arr(3 downto 0) := ("00000000", "00000000","00000000","00000000");


begin

i_start <= i_sel(0) xor i_sel(1);

n0 : component wave_generator
    PORT MAP( clk =>clk,
        i_enable => note_enables(0),
        i_count => note_counts(0), 
        o_value => r_note_outputs(0));
        
n1 : component wave_generator
    PORT MAP( clk =>clk,
         i_enable => note_enables(1),
         i_count => note_counts(1), 
         o_value => r_note_outputs(1));

n2 : component wave_generator
    PORT MAP(clk => clk,
        i_enable => note_enables(2),
        i_count => note_counts(2),
        o_value => r_note_outputs(2));

n3 : component wave_generator
    PORT MAP(clk => clk,
        i_enable => note_enables(3),
        i_count => note_counts(3),
        o_value => r_note_outputs(3));
        
mux : component song_mux
    PORT MAP(
        clk => clk,
        sel => r_read_data,
        reset => r_reset,
        note_info => note_info,
        done => r_done_reading);
        
        
process(clk)
    begin
        if rising_edge(clk) then
            if i_start = '1' and r_enable = '0' then --it's been enabled
                beat_counter <= (others => '0');
                r_read_data <= i_sel; -- start reading in data
                r_enable <= i_start;
                r_start_playing <= '0';
                r_reset <= '0';
            elsif i_start = '0' and r_enable = '1' then
                r_reset <= '1';
                r_enable <= i_start;
                beat_counter <= (others => '0');
                r_read_data <= "00";
                r_start_playing <= '0';
            elsif r_reset = '0' and r_done_reading = '0' and r_start_playing = '0' then --wait for song_ROM_reader to read in data
                r_enable <= i_start;
                r_read_data <= i_sel;
                beat_counter <= (others => '0');
                r_start_playing <= '0';
            elsif r_reset = '0' and  beat_counter = to_unsigned(4,8) then 
                r_read_data <= "00";
                r_start_playing <= '1';
                beat_counter <= beat_counter + 1;
            elsif r_reset = '0' and  r_enable = '1' and r_done_reading= '1' and r_start_playing='0' then --process data
                r_enable <= i_start;
                --set note_enables
                if note_info(to_integer(beat_counter)) = to_unsigned(0,8) then note_enables(to_integer(beat_counter)) <= '0';
                else note_enables(to_integer(beat_counter)) <= '1';
                end if;
                
                --set note terminate
                note_terminate(to_integer(beat_counter)) <= note_info(to_integer(beat_counter))(7);
                
                --set note_counts, first 6 downto 4 determines octave, 3 downto 0 determines note
                case note_info(to_integer(beat_counter))(6 downto 0) is 
                    when "0010000" => note_counts(to_integer(beat_counter)) <= to_unsigned(1528864,32);
                    when "0100000" => note_counts(to_integer(beat_counter)) <= to_unsigned(764432,32);
                    when "0110000" => note_counts(to_integer(beat_counter)) <= to_unsigned(382216,32);
                    when "1000000" => note_counts(to_integer(beat_counter)) <= to_unsigned(191108,32);
                    when "1010000" => note_counts(to_integer(beat_counter)) <= to_unsigned(95554,32);
                    when "0010001" => note_counts(to_integer(beat_counter)) <= to_unsigned(1443104,32);
                    when "0100001" => note_counts(to_integer(beat_counter)) <= to_unsigned(721552,32);
                    when "0110001" => note_counts(to_integer(beat_counter)) <= to_unsigned(360776,32);
                    when "1000001" => note_counts(to_integer(beat_counter)) <= to_unsigned(180388,32);
                    when "1010001" => note_counts(to_integer(beat_counter)) <= to_unsigned(90194,32);
                    when "0010010" => note_counts(to_integer(beat_counter)) <= to_unsigned(1362112,32);
                    when "0100010" => note_counts(to_integer(beat_counter)) <= to_unsigned(681056,32);
                    when "0110010" => note_counts(to_integer(beat_counter)) <= to_unsigned(340528,32);
                    when "1000010" => note_counts(to_integer(beat_counter)) <= to_unsigned(170264,32);
                    when "1010010" => note_counts(to_integer(beat_counter)) <= to_unsigned(85132,32);
                    when "0010011" => note_counts(to_integer(beat_counter)) <= to_unsigned(1285632,32);
                    when "0100011" => note_counts(to_integer(beat_counter)) <= to_unsigned(642816,32);
                    when "0110011" => note_counts(to_integer(beat_counter)) <= to_unsigned(321408,32);
                    when "1000011" => note_counts(to_integer(beat_counter)) <= to_unsigned(160704,32);
                    when "1010011" => note_counts(to_integer(beat_counter)) <= to_unsigned(80352,32);
                    when "0010100" => note_counts(to_integer(beat_counter)) <= to_unsigned(1213472,32);
                    when "0100100" => note_counts(to_integer(beat_counter)) <= to_unsigned(606736,32);
                    when "0110100" => note_counts(to_integer(beat_counter)) <= to_unsigned(303368,32);
                    when "1000100" => note_counts(to_integer(beat_counter)) <= to_unsigned(151684,32);
                    when "1010100" => note_counts(to_integer(beat_counter)) <= to_unsigned(75842,32);
                    when "0010101" => note_counts(to_integer(beat_counter)) <= to_unsigned(1145376,32);
                    when "0100101" => note_counts(to_integer(beat_counter)) <= to_unsigned(572688,32);
                    when "0110101" => note_counts(to_integer(beat_counter)) <= to_unsigned(286344,32);
                    when "1000101" => note_counts(to_integer(beat_counter)) <= to_unsigned(143172,32);
                    when "1010101" => note_counts(to_integer(beat_counter)) <= to_unsigned(71586,32);
                    when "0010110" => note_counts(to_integer(beat_counter)) <= to_unsigned(1081104,32);
                    when "0100110" => note_counts(to_integer(beat_counter)) <= to_unsigned(540552,32);
                    when "0110110" => note_counts(to_integer(beat_counter)) <= to_unsigned(270276,32);
                    when "1000110" => note_counts(to_integer(beat_counter)) <= to_unsigned(135138,32);
                    when "1010110" => note_counts(to_integer(beat_counter)) <= to_unsigned(67569,32);
                    when "0010111" => note_counts(to_integer(beat_counter)) <= to_unsigned(1020400,32);
                    when "0100111" => note_counts(to_integer(beat_counter)) <= to_unsigned(510200,32);
                    when "0110111" => note_counts(to_integer(beat_counter)) <= to_unsigned(255100,32);
                    when "1000111" => note_counts(to_integer(beat_counter)) <= to_unsigned(127550,32);
                    when "1010111" => note_counts(to_integer(beat_counter)) <= to_unsigned(63775,32);
                    when "0011000" => note_counts(to_integer(beat_counter)) <= to_unsigned(962960,32);
                    when "0101000" => note_counts(to_integer(beat_counter)) <= to_unsigned(481480,32);
                    when "0111000" => note_counts(to_integer(beat_counter)) <= to_unsigned(240740,32);
                    when "1001000" => note_counts(to_integer(beat_counter)) <= to_unsigned(120370,32);
                    when "1011000" => note_counts(to_integer(beat_counter)) <= to_unsigned(60185,32);
                    when "0011001" => note_counts(to_integer(beat_counter)) <= to_unsigned(909088,32);
                    when "0101001" => note_counts(to_integer(beat_counter)) <= to_unsigned(454544,32);
                    when "0111001" => note_counts(to_integer(beat_counter)) <= to_unsigned(227272,32);
                    when "1001001" => note_counts(to_integer(beat_counter)) <= to_unsigned(113636,32);
                    when "1011001" => note_counts(to_integer(beat_counter)) <= to_unsigned(56818,32);
                    when "0011010" => note_counts(to_integer(beat_counter)) <= to_unsigned(858064,32);
                    when "0101010" => note_counts(to_integer(beat_counter)) <= to_unsigned(429032,32);
                    when "0111010" => note_counts(to_integer(beat_counter)) <= to_unsigned(214516,32);
                    when "1001010" => note_counts(to_integer(beat_counter)) <= to_unsigned(107258,32);
                    when "1011010" => note_counts(to_integer(beat_counter)) <= to_unsigned(53629,32);
                    when "0011011" => note_counts(to_integer(beat_counter)) <= to_unsigned(809904,32);
                    when "0101011" => note_counts(to_integer(beat_counter)) <= to_unsigned(404952,32);
                    when "0111011" => note_counts(to_integer(beat_counter)) <= to_unsigned(202476,32);
                    when "1001011" => note_counts(to_integer(beat_counter)) <= to_unsigned(101238,32);
                    when "1011011" => note_counts(to_integer(beat_counter)) <= to_unsigned(50619,32);
                    when others => note_counts(to_integer(beat_counter)) <= to_unsigned(0,32);
                 end case;
                                     
                r_read_data <= i_sel; 
                r_start_playing <= '0';
                beat_counter <= beat_counter + 1;
            elsif r_enable = '1' and r_start_playing = '1' and beat_counter > to_unsigned(3,8) then--play this beat   
                if beat_counter >= CYCLES_PER_BEAT then
                    beat_counter <= to_unsigned(0,32);
                    r_read_data <= i_sel; 
                    r_start_playing <= '0';
                elsif beat_counter >= CYCLES_PER_PART_BEAT then
                    beat_counter <= beat_counter + 1;
                    if note_terminate(0)='1' then note_counts(0) <= to_unsigned(0,32); end if;
                    if note_terminate(1)='1' then note_counts(1) <= to_unsigned(0,32); end if;
                    if note_terminate(2)='1' then note_counts(2) <= to_unsigned(0,32); end if;
                    if note_terminate(3)='1' then note_counts(3) <= to_unsigned(0,32); end if;
                else beat_counter <= beat_counter + 1;
                end if;
            else 
                r_enable <= i_start;
                r_read_data <= r_read_data;
                r_start_playing <= '0';
                r_reset <= r_reset;
            end if;
        end if;
    end process;
        
o_amp <= ("00" & r_note_outputs(0)) + ("00" & r_note_outputs(1)) + ("00" & r_note_outputs(2)) + ("00" & r_note_outputs(3));

end Behavioral;
