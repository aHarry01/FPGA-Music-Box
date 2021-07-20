library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

--adapted from NANDLAND.com
 
entity debounce_filter is
  PORT (
    clk    : in  STD_LOGIC;
    i_btn : in  STD_LOGIC;
    o_btn_state : out STD_LOGIC
    );
end entity debounce_filter;
 
architecture Behavioral of debounce_filter is
 
  -- Set for 1000000 clock ticks of 100 MHz clock (10 ms)
  constant c_DEBOUNCE_LIMIT : integer := 1000000;
 
  signal r_Count : integer range 0 to c_DEBOUNCE_LIMIT := 0;
  signal r_State : STD_LOGIC := '0';
 
begin
 
  process (clk) is
  begin
    if rising_edge(clk) then
 
      -- Switch input is different than internal switch value, so an input is
      -- changing.  Increase counter until it is stable for c_DEBOUNCE_LIMIT clk cycles.
      if (i_btn /= r_State and r_Count < c_DEBOUNCE_LIMIT) then
        r_Count <= r_Count + 1;
 
      -- End of counter reached, switch is stable, register it, reset counter
      elsif r_Count = c_DEBOUNCE_LIMIT then
        r_State <= i_btn;
        r_Count <= 0;
 
      -- Switches are the same state, reset the counter
      else r_Count <= 0;

      end if;
    end if;
  end process;
 
  -- Assign internal register to output (debounced!)
  o_btn_state <= r_State;
 
end architecture Behavioral;
