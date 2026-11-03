
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity morse_top is
    generic (
        DEBOUNCE_CYCLES       : integer := 50000;

        INIT_WAIT_CYCLES       : integer := 1000000;
        INIT_CMD_WAIT_CYCLES   : integer := 250000;
        INIT_CLEAR_WAIT_CYCLES : integer := 100000;
        BYTE_WAIT_CYCLES       : integer := 2500;
        E_PULSE_CYCLES         : integer := 50;
        REFRESH_WAIT_CYCLES    : integer := 5000000
    );

    port (
        clk       : in  std_logic;

        pb_dot    : in  std_logic;
        pb_dash   : in  std_logic;
        pb_enter  : in  std_logic;
        pb_space  : in  std_logic;
        pb_delete : in  std_logic;
        pb_clear  : in  std_logic;

        lcd_data  : out std_logic_vector(7 downto 0);
        lcd_rs    : out std_logic;
        lcd_e     : out std_logic;

        led       : out std_logic_vector(15 downto 0)
    );
end morse_top;


architecture Behavioral of morse_top is

    -- Button pulses
    signal dot_pulse    : std_logic;
    signal dash_pulse   : std_logic;
    signal enter_pulse  : std_logic;
    signal space_pulse  : std_logic;
    signal delete_pulse : std_logic;
    signal clear_pulse  : std_logic;

    -- Morse detector
    signal morse_code   : std_logic_vector(7 downto 0);
    signal morse_length : std_logic_vector(3 downto 0);
    signal char_ready   : std_logic;

    -- Morse decoder
    signal decoded_char  : std_logic_vector(7 downto 0);
    signal decoded_valid : std_logic;

    -- Character pipeline
    signal char_valid_d : std_logic := '0';
    signal char_d       : std_logic_vector(7 downto 0) := x"20";

    -- Display memory
    signal display_data : std_logic_vector(255 downto 0);
    signal char_count   : std_logic_vector(5 downto 0);

    -- UART transmitter
    signal bt_tx       : std_logic;
    signal bt_tx_start : std_logic := '0';
    signal bt_tx_data  : std_logic_vector(7 downto 0) := x"20";
    signal bt_tx_busy  : std_logic;

    -- UART transmission control
    signal uart_pending      : std_logic := '0';
    signal uart_pending_data : std_logic_vector(7 downto 0) := x"20";

    -- LED debugging
    signal led_reg : std_logic_vector(15 downto 0) :=
        (others => '0');

begin

    ----------------------------------------------------------------
    -- BUTTON CONDITIONERS
    ----------------------------------------------------------------

    U_DOT : entity work.button_conditioner
        generic map (
            DEBOUNCE_CYCLES => DEBOUNCE_CYCLES
        )
        port map (
            clk       => clk,
            btn_in    => pb_dot,
            btn_pulse => dot_pulse
        );

    U_DASH : entity work.button_conditioner
        generic map (
            DEBOUNCE_CYCLES => DEBOUNCE_CYCLES
        )
        port map (
            clk       => clk,
            btn_in    => pb_dash,
            btn_pulse => dash_pulse
        );

    U_ENTER : entity work.button_conditioner
        generic map (
            DEBOUNCE_CYCLES => DEBOUNCE_CYCLES
        )
        port map (
            clk       => clk,
            btn_in    => pb_enter,
            btn_pulse => enter_pulse
        );

    U_SPACE : entity work.button_conditioner
        generic map (
            DEBOUNCE_CYCLES => DEBOUNCE_CYCLES
        )
        port map (
            clk       => clk,
            btn_in    => pb_space,
            btn_pulse => space_pulse
        );

    U_DELETE : entity work.button_conditioner
        generic map (
            DEBOUNCE_CYCLES => DEBOUNCE_CYCLES
        )
        port map (
            clk       => clk,
            btn_in    => pb_delete,
            btn_pulse => delete_pulse
        );

    U_CLEAR : entity work.button_conditioner
        generic map (
            DEBOUNCE_CYCLES => DEBOUNCE_CYCLES
        )
        port map (
            clk       => clk,
            btn_in    => pb_clear,
            btn_pulse => clear_pulse
        );


    ----------------------------------------------------------------
    -- MORSE DETECTOR
    ----------------------------------------------------------------

    U_MORSE_DETECTOR : entity work.morse_detector
        port map (
            clk          => clk,
            dot          => dot_pulse,
            dash         => dash_pulse,
            enter        => enter_pulse,
            morse_code   => morse_code,
            morse_length => morse_length,
            char_ready   => char_ready
        );


    ----------------------------------------------------------------
    -- MORSE DECODER
    ----------------------------------------------------------------

    U_MORSE_DECODER : entity work.morse_decoder
        port map (
            morse_code   => morse_code,
            morse_length => morse_length,
            char_out     => decoded_char,
            char_valid   => decoded_valid
        );


    ----------------------------------------------------------------
    -- CAPTURE DECODED CHARACTER
    ----------------------------------------------------------------

    process(clk)
    begin
        if rising_edge(clk) then

            char_valid_d <= '0';

            if char_ready = '1' and decoded_valid = '1' then
                char_d       <= decoded_char;
                char_valid_d <= '1';
            end if;

        end if;
    end process;


    ----------------------------------------------------------------
    -- DISPLAY MEMORY
    ----------------------------------------------------------------

    U_DISPLAY_MEMORY : entity work.display_memory
        port map (
            clk            => clk,
            char_in        => char_d,
            char_valid     => char_valid_d,
            space          => space_pulse,
            delete         => delete_pulse,
            clear          => clear_pulse,
            display_data   => display_data,
            char_count_out => char_count
        );


    ----------------------------------------------------------------
    -- LCD CONTROLLER
    ----------------------------------------------------------------

    U_LCD_CONTROLLER : entity work.lcd_controller
        generic map (
            INIT_WAIT_CYCLES       => INIT_WAIT_CYCLES,
            INIT_CMD_WAIT_CYCLES   => INIT_CMD_WAIT_CYCLES,
            INIT_CLEAR_WAIT_CYCLES => INIT_CLEAR_WAIT_CYCLES,
            BYTE_WAIT_CYCLES       => BYTE_WAIT_CYCLES,
            E_PULSE_CYCLES         => E_PULSE_CYCLES,
            REFRESH_WAIT_CYCLES    => REFRESH_WAIT_CYCLES
        )
        port map (
            clk          => clk,
            display_data => display_data,
            lcd_data     => lcd_data,
            lcd_rs       => lcd_rs,
            lcd_e        => lcd_e
        );


    ----------------------------------------------------------------
    -- UART TRANSMITTER
    -- 50 MHz clock, 9600 baud
    ----------------------------------------------------------------

    U_BT_UART_TX : entity work.uart_tx
        generic map (
            CLK_FREQ  => 50000000,
            BAUD_RATE => 9600
        )
        port map (
            clk      => clk,
            tx_start => bt_tx_start,
            tx_data  => bt_tx_data,
            tx       => bt_tx,
            tx_busy  => bt_tx_busy
        );


    ----------------------------------------------------------------
    -- UART CHARACTER QUEUE
    --
    -- Send each decoded character once the UART is available.
    -- A pending register stores a character if the UART is busy.
    ----------------------------------------------------------------

    process(clk)
    begin
        if rising_edge(clk) then

            -- Default: do not start a new transmission.
            bt_tx_start <= '0';

            -- Capture a new decoded character.
            if char_valid_d = '1' then
                uart_pending_data <= char_d;
                uart_pending      <= '1';
            end if;

            -- Transmit when a character is pending and UART is idle.
            if uart_pending = '1' and bt_tx_busy = '0' then
                bt_tx_data  <= uart_pending_data;
                bt_tx_start <= '1';
                uart_pending <= '0';
            end if;

            -- Send a space to the phone when SPACE is pressed.
            if space_pulse = '1' then
                uart_pending_data <= x"20";
                uart_pending      <= '1';
            end if;

        end if;
    end process;


    ----------------------------------------------------------------
    -- LED DEBUGGING
    ----------------------------------------------------------------

    process(clk)
    begin
        if rising_edge(clk) then

            led_reg <= (others => '0');

            led_reg(0)  <= dot_pulse;
            led_reg(1)  <= dash_pulse;
            led_reg(2)  <= enter_pulse;
            led_reg(3)  <= space_pulse;
            led_reg(4)  <= delete_pulse;
            led_reg(5)  <= clear_pulse;

            led_reg(6)  <= char_ready;
            led_reg(7)  <= morse_code(0);
            led_reg(8)  <= morse_code(1);
            led_reg(9)  <= morse_code(2);
            led_reg(10) <= morse_code(3);
            led_reg(11) <= morse_code(4);
            led_reg(12) <= morse_code(5);
            led_reg(13) <= morse_code(6);
            led_reg(14) <= morse_code(7);
            led_reg(15) <= bt_tx_busy;

        end if;
    end process;

    led <= led_reg;

end Behavioral;
