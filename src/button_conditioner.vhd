library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity button_conditioner is
    generic (
        DEBOUNCE_CYCLES : integer := 50000
    );
    port (
        clk       : in  std_logic;
        btn_in    : in  std_logic;
        btn_pulse : out std_logic
    );
end button_conditioner;

architecture Behavioral of button_conditioner is

    signal sync1        : std_logic := '0';
    signal sync2        : std_logic := '0';
    signal stable_state : std_logic := '0';
    signal stable_prev  : std_logic := '0';

    signal counter : integer range 0 to DEBOUNCE_CYCLES := 0;

begin

    process(clk)
    begin
        if rising_edge(clk) then

            sync1 <= btn_in;
            sync2 <= sync1;

            if sync2 = stable_state then
                counter <= 0;
            else
                if counter < DEBOUNCE_CYCLES - 1 then
                    counter <= counter + 1;
                else
                    stable_state <= sync2;
                    counter <= 0;
                end if;
            end if;

            stable_prev <= stable_state;

        end if;
    end process;

    btn_pulse <= stable_state and not stable_prev;

end Behavioral;