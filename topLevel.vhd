library work;
use work.custom_package.all;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity topLevel is
    PORT (
        clk : in STD_LOGIC;
        enables : in STD_LOGIC_VECTOR(11 downto 0);
        preprog_song_sel : in STD_LOGIC_VECTOR(1 downto 0);
        i_up_btn : in STD_LOGIC;
        i_dn_btn : in STD_LOGIC;
        o_soundwave : out STD_LOGIC
     );
end topLevel;

architecture Behavioral of topLevel is

component debounce_filter 
    PORT (
        clk, i_btn : in  std_logic;
        o_btn_state : out std_logic);
end component;

component octave_changer
    PORT(
        clk : in STD_LOGIC;
        i_up_btn : in STD_LOGIC;
        i_dn_btn : in STD_LOGIC;
        o_note_counts : out int_arr);
end component;

component wave_generator
    PORT(
        clk, i_enable : STD_LOGIC;
        i_count : in unsigned(31 downto 0);
        o_value : out unsigned(2 downto 0));
end component;

component amplitude_adder 
    PORT ( i_values : in threebit_arr;
       o_amplitude : out unsigned(4 downto 0));
end component;    

component amplitude_mux 
    PORT ( i_input_amp  : in unsigned(4 downto 0);
         i_song_amp : in unsigned(4 downto 0);
         i_select : in STD_LOGIC;
         o_amp : out unsigned(4 downto 0));  
end component;  

component music_box 
  Port (clk : in STD_LOGIC;
      i_sel : in STD_LOGIC_VECTOR(1 downto 0);
      o_amp : out unsigned(4 downto 0));
end component;

component wave_adder
    PORT ( clk : in STD_LOGIC;
       i_amplitude : in unsigned(4 downto 0);
       o_value : out STD_LOGIC);
end component;

signal r_note_outputs : threebit_arr(0 to 11) := (others => "000"); --current on/off data for each note
signal added_output : STD_LOGIC := '0';

signal r_amplitude : unsigned(4 downto 0) := "00000";
signal r_song_amp : unsigned(4 downto 0) := "00000";
signal r_input_amp : unsigned(4 downto 0) := "00000";

signal w_up_btn_state : STD_LOGIC := '0';
signal w_dn_btn_state : STD_LOGIC := '0';

signal pre_prog : STD_LOGIC := '0'; --1 when preprogrammed song is turned on, 0 when synth is on

--clock counts for 1 cycle of notes C4 (index 0) to B4 (index 11) 
--counts set to nearest multiple of 4 so can divide twice to get lower octaves
signal note_counts : int_arr(0 to 11) := (others => to_unsigned(0,32)); 

begin

pre_prog <= preprog_song_sel(0) xor preprog_song_sel(1);
o_soundwave <= added_output;

btnU : component debounce_filter
    PORT MAP( clk => clk, i_btn => i_up_btn, o_btn_state => w_up_btn_state);
    
btnD : component debounce_filter
    PORT MAP( clk => clk, i_btn => i_dn_btn, o_btn_state => w_dn_btn_state);
    
oct : component octave_changer
    PORT MAP( clk => clk, 
        i_up_btn => w_up_btn_state, i_dn_btn => w_dn_btn_state,
        o_note_counts => note_counts);

C : component wave_generator
    PORT MAP( clk =>clk,
        i_enable => enables(0),
        i_count => note_counts(0), 
        o_value => r_note_outputs(0));
        
Csharp : component wave_generator
     PORT MAP( clk =>clk,
        i_enable => enables(1),
        i_count => note_counts(1), 
        o_value => r_note_outputs(1));
        
D : component wave_generator
     PORT MAP( clk =>clk,
        i_enable => enables(2),
        i_count => note_counts(2), 
        o_value => r_note_outputs(2));   
                
Dsharp : component wave_generator
      PORT MAP( clk =>clk,
        i_enable => enables(3),
        i_count => note_counts(3), 
        o_value => r_note_outputs(3));                 
                
E : component wave_generator
    PORT MAP( clk =>clk,
        i_enable => enables(4),
        i_count => note_counts(4), 
        o_value => r_note_outputs(4));  
        
F : component wave_generator
    PORT MAP( clk =>clk,
        i_enable => enables(5),
        i_count => note_counts(5), 
        o_value => r_note_outputs(5)); 
        
Fsharp : component wave_generator
    PORT MAP( clk =>clk,
        i_enable => enables(6),
        i_count => note_counts(6), 
        o_value => r_note_outputs(6)); 
           
G : component wave_generator
    PORT MAP( clk =>clk,
        i_enable => enables(7),
        i_count => note_counts(7), 
        o_value => r_note_outputs(7));  
         
Gsharp : component wave_generator
    PORT MAP( clk =>clk,
        i_enable => enables(8),
        i_count => note_counts(8), 
        o_value => r_note_outputs(8));    
        
A : component wave_generator
    PORT MAP( clk =>clk,
        i_enable => enables(9),
        i_count => note_counts(9), 
        o_value => r_note_outputs(9));  
        
Asharp : component wave_generator
    PORT MAP( clk =>clk,
        i_enable => enables(10),
        i_count => note_counts(10), 
        o_value => r_note_outputs(10)); 
        
B : component wave_generator
    PORT MAP( clk =>clk,
        i_enable => enables(11),
        i_count => note_counts(11), 
        o_value => r_note_outputs(11));                

amp_adder : component amplitude_adder
    PORT MAP(i_values => r_note_outputs, o_amplitude => r_input_amp);
    
mus : component music_box
    PORT MAP(
        clk => clk,
        i_sel => preprog_song_sel,
        o_amp => r_song_amp);            
    
amp_mux : component amplitude_mux
    PORT MAP(i_input_amp => r_input_amp, 
            i_song_amp => r_song_amp, 
            i_select => pre_prog, 
            o_amp => r_amplitude);
                
w_adder : component wave_adder
    PORT MAP( clk => clk,
        i_amplitude => r_amplitude,
        o_value => added_output);



end Behavioral;
