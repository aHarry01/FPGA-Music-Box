library work;
use work.custom_package.all;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity octave_changer is
    PORT(
        clk : in STD_LOGIC;
        i_up_btn : in STD_LOGIC;
        i_dn_btn : in STD_LOGIC;
        o_note_counts : out int_arr(0 to 11));
end octave_changer;

architecture Behavioral of octave_changer is

--counts set to nearest multiple of 4 so can divide twice to get lower octaves
signal r_note_counts : int_arr(0 to 11) := (to_unsigned(382216,32),to_unsigned(360776,32),to_unsigned(340528,32),to_unsigned(321408,32),
                                 to_unsigned(303368,32),to_unsigned(286344,32),to_unsigned(270276,32),to_unsigned(255100,32),
                                 to_unsigned(240740,32),to_unsigned(227272,32),to_unsigned(214516,32),to_unsigned(202476,32)); 
signal r_octave_num : unsigned(2 downto 0) := "100";
signal r_up_btn : STD_LOGIC := '0';
signal r_dn_btn : STD_LOGIC := '0';

begin

o_note_counts <= r_note_counts;

process(clk)
begin
    if rising_edge(clk) then
        r_up_btn <= i_up_btn;
        r_dn_btn <= i_dn_btn;
        --rising edge on up button, previous val = '0' and new input = '1'
        if r_up_btn='0' and i_up_btn='1' and r_octave_num < "110" then
            r_note_counts(0) <= '0' & r_note_counts(0)(31 downto 1);--divide counts by 2, aka bitshift right 
            r_note_counts(1) <= '0' & r_note_counts(1)(31 downto 1);--divide counts by 2, aka bitshift right 
            r_note_counts(2) <= '0' & r_note_counts(2)(31 downto 1);--divide counts by 2, aka bitshift right 
            r_note_counts(3) <= '0' & r_note_counts(3)(31 downto 1);--divide counts by 2, aka bitshift right 
            r_note_counts(4) <= '0' & r_note_counts(4)(31 downto 1);--divide counts by 2, aka bitshift right 
            r_note_counts(5) <= '0' & r_note_counts(5)(31 downto 1);--divide counts by 2, aka bitshift right 
            r_note_counts(6) <= '0' & r_note_counts(6)(31 downto 1);--divide counts by 2, aka bitshift right 
            r_note_counts(7) <= '0' & r_note_counts(7)(31 downto 1);--divide counts by 2, aka bitshift right 
            r_note_counts(8) <= '0' & r_note_counts(8)(31 downto 1);--divide counts by 2, aka bitshift right 
            r_note_counts(9) <= '0' & r_note_counts(9)(31 downto 1);--divide counts by 2, aka bitshift right 
            r_note_counts(10) <= '0' & r_note_counts(10)(31 downto 1);--divide counts by 2, aka bitshift right 
            r_note_counts(11) <= '0' & r_note_counts(11)(31 downto 1);--divide counts by 2, aka bitshift right 
            r_octave_num <= r_octave_num + 1;
        --rising edge on down button
        elsif r_dn_btn='0' and i_dn_btn='1' and r_octave_num > "010" then
            r_note_counts(0) <= r_note_counts(0)(30 downto 0) & '0'; --multiply counts by 2, aka bitshift left
            r_note_counts(1) <= r_note_counts(1)(30 downto 0) & '0'; --multiply counts by 2, aka bitshift left
            r_note_counts(2) <= r_note_counts(2)(30 downto 0) & '0'; --multiply counts by 2, aka bitshift left
            r_note_counts(3) <= r_note_counts(3)(30 downto 0) & '0'; --multiply counts by 2, aka bitshift left
            r_note_counts(4) <= r_note_counts(4)(30 downto 0) & '0'; --multiply counts by 2, aka bitshift left
            r_note_counts(5) <= r_note_counts(5)(30 downto 0) & '0'; --multiply counts by 2, aka bitshift left
            r_note_counts(6) <= r_note_counts(6)(30 downto 0) & '0'; --multiply counts by 2, aka bitshift left
            r_note_counts(7) <= r_note_counts(7)(30 downto 0) & '0'; --multiply counts by 2, aka bitshift left
            r_note_counts(8) <= r_note_counts(8)(30 downto 0) & '0'; --multiply counts by 2, aka bitshift left
            r_note_counts(9) <= r_note_counts(9)(30 downto 0) & '0'; --multiply counts by 2, aka bitshift left
            r_note_counts(10) <= r_note_counts(10)(30 downto 0) & '0'; --multiply counts by 2, aka bitshift left
            r_note_counts(11) <= r_note_counts(11)(30 downto 0) & '0'; --multiply counts by 2, aka bitshift left
            r_octave_num <= r_octave_num - 1;
        else r_octave_num <= r_octave_num;
        end if;
        
    end if;
end process;

end Behavioral;
