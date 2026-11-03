library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity morse_detector is
    port (
        clk          : in  std_logic;
        dot          : in  std_logic;
        dash         : in  std_logic;
        enter        : in  std_logic;
        morse_code   : out std_logic_vector(7 downto 0);
        morse_length : out std_logic_vector(3 downto 0);
        char_ready   : out std_logic
    );
end morse_detector;

architecture Behavioral of morse_detector is

    signal code_reg : std_logic_vector(7 downto 0) :=
        (others => '0');

    signal length_reg : integer range 0 to 8 := 0;

    signal code_out_reg : std_logic_vector(7 downto 0) :=
        (others => '0');

    signal length_out_reg : std_logic_vector(3 downto 0) :=
        (others => '0');

    signal char_ready_reg : std_logic := '0';

begin

    process(clk)
    begin
        if rising_edge(clk) then

            char_ready_reg <= '0';

            if dot = '1' then

                if length_reg < 8 then
                    code_reg <= code_reg(6 downto 0) & '0';
                    length_reg <= length_reg + 1;
                end if;

            elsif dash = '1' then

                if length_reg < 8 then
                    code_reg <= code_reg(6 downto 0) & '1';
                    length_reg <= length_reg + 1;
                end if;

            elsif enter = '1' then

                if length_reg > 0 then
                    code_out_reg <= code_reg;
                    length_out_reg <=
                        std_logic_vector(to_unsigned(length_reg, 4));

                    char_ready_reg <= '1';

                    code_reg <= (others => '0');
                    length_reg <= 0;
                end if;

            end if;

        end if;
    end process;

    morse_code <= code_out_reg;
    morse_length <= length_out_reg;
    char_ready <= char_ready_reg;

end Behavioral;