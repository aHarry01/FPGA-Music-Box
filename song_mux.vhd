library work;
use work.custom_package.all;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity song_mux is
  Port(
    clk : in STD_LOGIC;
    sel : in STD_LOGIC_VECTOR(1 downto 0); -- bit 1 is to enable song2, bit 0 enables song1
    reset : in STD_LOGIC;
    note_info : out byte_arr(3 downto 0);
    done : out STD_LOGIC);
end song_mux;

architecture Behavioral of song_mux is

component song_ROM_reader
Port ( 
    clk : in STD_LOGIC;
    enable : in STD_LOGIC;
    reset : in STD_LOGIC;
    note_info : out byte_arr(3 downto 0);
    done : out STD_LOGIC
);
end component;

component song2_ROM_reader
Port ( 
    clk : in STD_LOGIC;
    enable : in STD_LOGIC;
    reset : in STD_LOGIC;
    note_info : out byte_arr(3 downto 0);
    done : out STD_LOGIC
);
end component;

signal dones : STD_LOGIC_VECTOR(1 downto 0) := "00";
signal note_info0 : byte_arr(3 downto 0) := ("00000000", "00000000","00000000","00000000");
signal note_info1 : byte_arr(3 downto 0) := ("00000000", "00000000","00000000","00000000");

begin

note_info <= note_info0 when sel="01" else
             note_info1 when sel="10" else
             ("00000000", "00000000","00000000","00000000");
done <= dones(0) when sel="01" else
        dones(1) when sel="10" else
        '0';

rom : component song_ROM_reader
    PORT MAP(
        clk => clk,
        enable => sel(0),
        reset => reset,
        note_info => note_info0,
        done => dones(0));
        
rom2 : component song2_ROM_reader
    PORT MAP(
        clk => clk,
        enable => sel(1),
        reset => reset,
        note_info => note_info1,
        done => dones(1));

end Behavioral;
