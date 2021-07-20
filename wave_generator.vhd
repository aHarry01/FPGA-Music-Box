library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity wave_generator is
    Port ( clk : in STD_LOGIC;
           i_enable : in STD_LOGIC;
           i_count : in unsigned(31 downto 0); --how many counts for 1 cycle
           o_value : out unsigned(2 downto 0));
end wave_generator;

architecture Behavioral of wave_generator is

signal r_count : unsigned (31 downto 0) := (others => '0');
signal r_output : unsigned(2 downto 0) := "000";
signal r_index : unsigned(2 downto 0) := "000";

begin

    process(clk)
        variable eighth_count : unsigned(31 downto 0);
    begin
        if rising_edge(clk) then --and enable/disable in here
            eighth_count := "000" & (i_count(31 downto 3));
            if i_enable='1' then
                if r_count >= eighth_count then 
                    r_count <= to_unsigned(0,32);
                    case r_index is
                        when "000" => r_output <= "000";
                        when "001" => r_output <= "001";
                        when "010" => r_output <= "010";
                        when "011" => r_output <= "011";
                        when "100" => r_output <= "100";
                        when "101" => r_output <= "011";
                        when "110" => r_output <= "010";
                        when others => r_output <= "001";
                    end case;
                    r_index <= r_index + 1;
                else 
                    r_count <= r_count + 1;
                    r_output <= r_output;
                    r_index <= r_index;
                end if;
            elsif i_enable='0' then r_output <= "000";
            end if; 
        end if;
    
    end process;
    
    o_value <= r_output;
    
end Behavioral;
