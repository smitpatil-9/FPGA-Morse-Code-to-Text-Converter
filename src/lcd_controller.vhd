library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity lcd_controller is
    generic (
        INIT_WAIT_CYCLES       : integer := 1000000;
        INIT_CMD_WAIT_CYCLES   : integer := 250000;
        INIT_CLEAR_WAIT_CYCLES : integer := 100000;
        BYTE_WAIT_CYCLES       : integer := 2500;
        E_PULSE_CYCLES         : integer := 50;
        REFRESH_WAIT_CYCLES    : integer := 5000000
    );
    port (
        clk          : in  std_logic;
        display_data : in  std_logic_vector(255 downto 0);
        lcd_data     : out std_logic_vector(7 downto 0);
        lcd_rs       : out std_logic;
        lcd_e        : out std_logic
    );
end lcd_controller;

architecture Behavioral of lcd_controller is

    type state_type is (
        INIT_WAIT,
        INIT_SETUP,
        INIT_PULSE,
        INIT_DELAY,
        ADDR_SETUP,
        ADDR_PULSE,
        ADDR_DELAY,
        DATA_SETUP,
        DATA_PULSE,
        DATA_DELAY,
        REFRESH_WAIT
    );

    signal state : state_type := INIT_WAIT;

    signal counter : integer range 0 to 5000000 := 0;
    signal init_index : integer range 0 to 3 := 0;
    signal char_index : integer range 0 to 31 := 0;

begin

    process(clk)
        variable address_value : integer;
    begin
        if rising_edge(clk) then

            case state is

                when INIT_WAIT =>
                    lcd_e <= '0';
                    lcd_rs <= '0';
                    lcd_data <= x"00";

                    if counter < INIT_WAIT_CYCLES - 1 then
                        counter <= counter + 1;
                    else
                        counter <= 0;
                        init_index <= 0;
                        state <= INIT_SETUP;
                    end if;

                when INIT_SETUP =>
                    lcd_rs <= '0';
                    lcd_e <= '0';

                    case init_index is
                        when 0 => lcd_data <= x"38";
                        when 1 => lcd_data <= x"0C";
                        when 2 => lcd_data <= x"01";
                        when 3 => lcd_data <= x"06";
                        when others => lcd_data <= x"00";
                    end case;

                    state <= INIT_PULSE;

                when INIT_PULSE =>
                    lcd_e <= '1';

                    if counter < E_PULSE_CYCLES - 1 then
                        counter <= counter + 1;
                    else
                        counter <= 0;
                        lcd_e <= '0';
                        state <= INIT_DELAY;
                    end if;

                when INIT_DELAY =>
                    lcd_e <= '0';

                    if init_index = 2 then
                        if counter < INIT_CLEAR_WAIT_CYCLES - 1 then
                            counter <= counter + 1;
                        else
                            counter <= 0;
                            init_index <= init_index + 1;
                            state <= INIT_SETUP;
                        end if;
                    else
                        if counter < INIT_CMD_WAIT_CYCLES - 1 then
                            counter <= counter + 1;
                        else
                            counter <= 0;

                            if init_index < 3 then
                                init_index <= init_index + 1;
                                state <= INIT_SETUP;
                            else
                                char_index <= 0;
                                state <= ADDR_SETUP;
                            end if;
                        end if;
                    end if;

                when ADDR_SETUP =>
                    lcd_rs <= '0';
                    lcd_e <= '0';

                    if char_index < 16 then
                        address_value := 16#80# + char_index;
                    else
                        address_value := 16#C0# + (char_index - 16);
                    end if;

                    lcd_data <= std_logic_vector(
                        to_unsigned(address_value, 8)
                    );

                    state <= ADDR_PULSE;

                when ADDR_PULSE =>
                    lcd_e <= '1';

                    if counter < E_PULSE_CYCLES - 1 then
                        counter <= counter + 1;
                    else
                        counter <= 0;
                        lcd_e <= '0';
                        state <= ADDR_DELAY;
                    end if;

                when ADDR_DELAY =>
                    lcd_e <= '0';

                    if counter < BYTE_WAIT_CYCLES - 1 then
                        counter <= counter + 1;
                    else
                        counter <= 0;
                        state <= DATA_SETUP;
                    end if;

                when DATA_SETUP =>
                    lcd_rs <= '1';
                    lcd_e <= '0';

                    lcd_data <= display_data(
                        char_index * 8 + 7 downto char_index * 8
                    );

                    state <= DATA_PULSE;

                when DATA_PULSE =>
                    lcd_e <= '1';

                    if counter < E_PULSE_CYCLES - 1 then
                        counter <= counter + 1;
                    else
                        counter <= 0;
                        lcd_e <= '0';
                        state <= DATA_DELAY;
                    end if;

                when DATA_DELAY =>
                    lcd_e <= '0';

                    if counter < BYTE_WAIT_CYCLES - 1 then
                        counter <= counter + 1;
                    else
                        counter <= 0;

                        if char_index < 31 then
                            char_index <= char_index + 1;
                            state <= ADDR_SETUP;
                        else
                            char_index <= 0;
                            state <= REFRESH_WAIT;
                        end if;
                    end if;

                when REFRESH_WAIT =>
                    lcd_e <= '0';

                    if counter < REFRESH_WAIT_CYCLES - 1 then
                        counter <= counter + 1;
                    else
                        counter <= 0;
                        char_index <= 0;
                        state <= ADDR_SETUP;
                    end if;

            end case;
        end if;
    end process;

end Behavioral;