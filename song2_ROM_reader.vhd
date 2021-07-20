library work;
use work.custom_package.all;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

--only read a byte out when enable is '1'

entity song2_ROM_reader is
  Port ( 
    clk : in STD_LOGIC;
    enable : in STD_LOGIC;
    reset : in STD_LOGIC; -- to reset mem address to beginning
    note_info : out byte_arr(3 downto 0);
    done : out STD_LOGIC
  );

end song2_ROM_reader;

architecture Behavioral of song2_ROM_reader is


COMPONENT song2_ROM
  PORT (
    clka : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
END COMPONENT;

--signal addr : unsigned(9 downto 0) := (others => '0');
signal r_delay_count : unsigned(1 downto 0) := "00";
signal r_en : STD_LOGIC := '0';
signal r_addr : unsigned(10 downto 0) := (others => '0');
signal r_cnt : unsigned(1 downto 0) := "00";
signal addra : STD_LOGIC_VECTOR(10 downto 0) := (others => '0');
signal data : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
signal data_bus : byte_arr(3 downto 0) := (others => "00000000");
signal r_done : STD_LOGIC := '0';
signal r_reset : STD_LOGIC := '0';

begin

beethoven_virus : song2_ROM
  PORT MAP (
    clka => clk,
    addra => addra,
    douta => data
  );
  
addra <= std_logic_vector(r_addr);
done <= r_done;
note_info <= data_bus;

process(clk)
begin

    if rising_edge(clk) then
        if enable = '1' and r_en = '0' then --start reading
            r_done <= '0';
            r_delay_count <= "00";
            r_cnt <= "00";
        elsif reset = '1' then
            r_addr <= (others => '0');
            r_done <= '0';
            r_delay_count <= "00";
            r_cnt <= "00";
            data_bus <= (others => "00000000");
        elsif r_delay_count > "00" and r_done= '0' then  --need to delay bc ROM has 2 clk cycles of latency
            r_delay_count <= r_delay_count + 1;
            r_cnt <= r_cnt;
            r_done <= r_done;
            r_addr <= r_addr;
        elsif enable = '1' and r_done = '0' and r_delay_count = "00" then
            if r_cnt = "11" then r_done <= '1'; r_cnt <= "00";
            else r_done <= '0';
            end if;
            data_bus(to_integer(r_cnt)) <= unsigned(data);
            r_addr <= r_addr + 1;
            r_cnt <= r_cnt + 1;
            r_delay_count <= r_delay_count + 1;
        else 
            r_cnt <= "00";
            r_done <= r_done;
            r_addr <= r_addr;
            r_delay_count <= "00";
        end if;
        
        r_en <= enable;
    end if;

end process;

end Behavioral;
