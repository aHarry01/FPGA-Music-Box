library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity wave_adder is
    PORT ( clk : in STD_LOGIC;
           i_amplitude : in unsigned(4 downto 0);
           o_value : out STD_LOGIC
           );
end wave_adder;

architecture Behavioral of wave_adder is

signal r_duty_cycle : unsigned(7 downto 0) := (others => '0'); --how many cylces out of the next 100 should wave be "on"
signal r_count : unsigned(6 downto 0) := (others => '0');
signal r_value : STD_LOGIC := '0';

begin

    o_value <= r_value;

    process(clk)
    variable adjusted_amp : unsigned(11 downto 0) := (others => '0');
    begin
        if rising_edge(clk) then
            if r_count = to_unsigned(100,7) then --end of 100 clk cycles, update duty cycle
                r_count <= (others => '0');
                r_value <= '0';
                -- update duty cycle
                adjusted_amp := i_amplitude*to_unsigned(85,7);
                r_duty_cycle <= adjusted_amp(11 downto 4); --divide by 16 bc 16 is the max amplitude
            
            elsif r_count < r_duty_cycle then --part of cycle where it's on
                r_value <= '1';
                r_count <= r_count + 1;        
                r_duty_cycle <= r_duty_cycle;
            else
                r_count <= r_count + 1;
                r_value <= '0';
                r_duty_cycle <= r_duty_cycle;
            
            end if;
        end if;

    end process;


end Behavioral;
