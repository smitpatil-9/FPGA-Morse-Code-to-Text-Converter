library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_morse_top is
end tb_morse_top;

architecture Behavioral of tb_morse_top is

    -- Clock
    signal clk : std_logic := '0';

    -- Button inputs
    signal pb_dot    : std_logic := '0';
    signal pb_dash   : std_logic := '0';
    signal pb_enter  : std_logic := '0';
    signal pb_space  : std_logic := '0';
    signal pb_delete : std_logic := '0';
    signal pb_clear  : std_logic := '0';

    -- LCD outputs
    signal lcd_data : std_logic_vector(7 downto 0);
    signal lcd_rs   : std_logic;
    signal lcd_e    : std_logic;

    -- LEDs
    signal led : std_logic_vector(15 downto 0);

    -- LCD frame storage
    type screen_type is array (0 to 31)
        of std_logic_vector(7 downto 0);

    signal screen_frame : screen_type :=
        (others => x"20");

    signal frame_seq : integer := 0;

begin

    ------------------------------------------------
    -- 50 MHz CLOCK
    ------------------------------------------------

    clk <= not clk after 10 ns;


    ------------------------------------------------
    -- DEVICE UNDER TEST
    ------------------------------------------------

    DUT : entity work.morse_top

        generic map (

            DEBOUNCE_CYCLES       => 5,

            INIT_WAIT_CYCLES       => 5,
            INIT_CMD_WAIT_CYCLES   => 2,
            INIT_CLEAR_WAIT_CYCLES => 2,
            BYTE_WAIT_CYCLES       => 2,
            E_PULSE_CYCLES         => 2,
            REFRESH_WAIT_CYCLES    => 20

        )

        port map (

            clk => clk,

            pb_dot    => pb_dot,
            pb_dash   => pb_dash,
            pb_enter  => pb_enter,
            pb_space  => pb_space,
            pb_delete => pb_delete,
            pb_clear  => pb_clear,

            lcd_data => lcd_data,
            lcd_rs   => lcd_rs,
            lcd_e    => lcd_e,

            led => led

        );


    ------------------------------------------------
    -- LCD MONITOR
    --
    -- Captures all 32 character writes.
    ------------------------------------------------

    process

        variable previous_e : std_logic := '0';

        variable index : integer range 0 to 32 := 0;

        variable frame_temp : screen_type :=
            (others => x"20");

    begin

        wait until rising_edge(clk);
        wait for 1 ns;

        if lcd_e = '1' and previous_e = '0' then

            if lcd_rs = '1' then

                frame_temp(index) := lcd_data;

                index := index + 1;

                if index = 32 then

                    screen_frame <= frame_temp;

                    frame_seq <= frame_seq + 1;

                    index := 0;

                end if;

            end if;

        end if;

        previous_e := lcd_e;

    end process;


    ------------------------------------------------
    -- TEST PROCESS
    ------------------------------------------------

    process

        procedure press_button(
            signal button : out std_logic
        ) is
        begin

            button <= '1';
            wait for 300 ns;

            button <= '0';
            wait for 300 ns;

        end procedure;


        procedure wait_two_frames is

            variable target : integer;

        begin

            target := frame_seq + 2;

            wait until frame_seq >= target;

            wait for 1 ns;

        end procedure;


    begin

        report "STARTING MORSE SYSTEM TEST"
            severity note;


        ------------------------------------------------
        -- SYSTEM STARTUP
        ------------------------------------------------

        wait until frame_seq >= 2;

        report "LCD INITIALIZATION COMPLETED"
            severity note;


        ------------------------------------------------
        -- TEST 1: A = .-
        ------------------------------------------------

        press_button(pb_dot);
        press_button(pb_dash);
        press_button(pb_enter);

        wait_two_frames;

        assert screen_frame(0) = x"41"
            report "TEST 1 FAILED: A"
            severity error;

        report "TEST 1 PASSED: A"
            severity note;


        ------------------------------------------------
        -- TEST 2: E = .
        ------------------------------------------------

        press_button(pb_dot);
        press_button(pb_enter);

        wait_two_frames;

        assert screen_frame(1) = x"45"
            report "TEST 2 FAILED: E"
            severity error;

        report "TEST 2 PASSED: E"
            severity note;


        ------------------------------------------------
        -- TEST 3: T = -
        ------------------------------------------------

        press_button(pb_dash);
        press_button(pb_enter);

        wait_two_frames;

        assert screen_frame(2) = x"54"
            report "TEST 3 FAILED: T"
            severity error;

        report "TEST 3 PASSED: T"
            severity note;


        ------------------------------------------------
        -- TEST 4: S = ...
        ------------------------------------------------

        press_button(pb_dot);
        press_button(pb_dot);
        press_button(pb_dot);
        press_button(pb_enter);

        wait_two_frames;

        assert screen_frame(3) = x"53"
            report "TEST 4 FAILED: S"
            severity error;

        report "TEST 4 PASSED: S"
            severity note;


        ------------------------------------------------
        -- TEST 5: SPACE
        ------------------------------------------------

        press_button(pb_space);

        wait_two_frames;

        assert screen_frame(4) = x"20"
            report "TEST 5 FAILED: SPACE"
            severity error;

        report "TEST 5 PASSED: SPACE"
            severity note;


        ------------------------------------------------
        -- TEST 6: DELETE
        ------------------------------------------------

        press_button(pb_delete);

        wait_two_frames;

        assert screen_frame(3) = x"53" and
               screen_frame(4) = x"20"

            report "TEST 6 FAILED: DELETE"
            severity error;

        report "TEST 6 PASSED: DELETE"
            severity note;


        ------------------------------------------------
        -- TEST 7: CLEAR
        ------------------------------------------------

        press_button(pb_clear);

        wait_two_frames;

        for i in 0 to 31 loop

            assert screen_frame(i) = x"20"

                report "TEST 7 FAILED: CLEAR"
                severity error;

        end loop;

        report "TEST 7 PASSED: CLEAR"
            severity note;


        ------------------------------------------------
        -- TEST 8: INVALID MORSE PATTERN
        -- ..-- = Invalid 4-symbol pattern
        ------------------------------------------------

        press_button(pb_dot);
        press_button(pb_dot);
        press_button(pb_dash);
        press_button(pb_dash);

        press_button(pb_enter);

        wait_two_frames;

        assert screen_frame(0) = x"3F"

            report "TEST 8 FAILED: INVALID PATTERN"
            severity error;

        report "TEST 8 PASSED: INVALID PATTERN"
            severity note;


        ------------------------------------------------
        -- ALL TESTS COMPLETED
        ------------------------------------------------

        report "ALL MORSE SYSTEM TESTS COMPLETED"
            severity note;

        wait;

    end process;

end Behavioral;