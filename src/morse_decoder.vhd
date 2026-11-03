library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity morse_decoder is
    port (
        morse_code   : in  std_logic_vector(7 downto 0);
        morse_length : in  std_logic_vector(3 downto 0);
        char_out     : out std_logic_vector(7 downto 0);
        char_valid   : out std_logic
    );
end morse_decoder;

architecture Behavioral of morse_decoder is
begin

    process(morse_code, morse_length)
    begin

        char_out <= x"3F"; -- ?        char_valid <= '0';
        case morse_length is

            when "0001" =>
                case morse_code(0) is
                    when '0' =>
                        char_out <= x"45"; -- E
                        char_valid <= '1';
                    when '1' =>
                        char_out <= x"54"; -- T
                        char_valid <= '1';
                    when others =>
                        char_out <= x"3F"; -- ?
                        char_valid <= '1';
                end case;

            when "0010" =>
                case morse_code(1 downto 0) is
                    when "00" =>
                        char_out <= x"49"; -- I
                        char_valid <= '1';
                    when "01" =>
                        char_out <= x"41"; -- A
                        char_valid <= '1';
                    when "10" =>
                        char_out <= x"4E"; -- N
                        char_valid <= '1';
                    when "11" =>
                        char_out <= x"4D"; -- M
                        char_valid <= '1';
                    when others =>
                        char_out <= x"3F"; -- ?
                        char_valid <= '1';
                end case;

            when "0011" =>
                case morse_code(2 downto 0) is
                    when "000" =>
                        char_out <= x"53"; -- S
                        char_valid <= '1';
                    when "001" =>
                        char_out <= x"55"; -- U
                        char_valid <= '1';
                    when "010" =>
                        char_out <= x"52"; -- R
                        char_valid <= '1';
                    when "011" =>
                        char_out <= x"57"; -- W
                        char_valid <= '1';
                    when "100" =>
                        char_out <= x"44"; -- D
                        char_valid <= '1';
                    when "101" =>
                        char_out <= x"4B"; -- K
                        char_valid <= '1';
                    when "110" =>
                        char_out <= x"47"; -- G
                        char_valid <= '1';
                    when "111" =>
                        char_out <= x"4F"; -- O
                        char_valid <= '1';
                    when others =>
                        char_out <= x"3F"; -- ?
                        char_valid <= '1';
                end case;

            when "0100" =>
                case morse_code(3 downto 0) is
                    when "0000" =>
                        char_out <= x"48"; -- H
                        char_valid <= '1';
                    when "0001" =>
                        char_out <= x"56"; -- V
                        char_valid <= '1';
                    when "0010" =>
                        char_out <= x"46"; -- F
                        char_valid <= '1';
                    when "0100" =>
                        char_out <= x"4C"; -- L
                        char_valid <= '1';
                    when "0110" =>
                        char_out <= x"50"; -- P
                        char_valid <= '1';
                    when "1000" =>
                        char_out <= x"42"; -- B
                        char_valid <= '1';
                    when "1001" =>
                        char_out <= x"58"; -- X
                        char_valid <= '1';
                    when "1010" =>
                        char_out <= x"43"; -- C
                        char_valid <= '1';
                    when "1011" =>
                        char_out <= x"59"; -- Y
                        char_valid <= '1';
                    when "1100" =>
                        char_out <= x"5A"; -- Z
                        char_valid <= '1';
                    when "1101" =>
                        char_out <= x"51"; -- Q
                        char_valid <= '1';
                    when "1110" =>
                        char_out <= x"4A"; -- J
                        char_valid <= '1';
                    when others =>
                        char_out <= x"3F"; -- ?
                        char_valid <= '1';
                end case;

            when "0101" =>
                case morse_code(4 downto 0) is
                    when "00000" =>
                        char_out <= x"35"; -- 5
                        char_valid <= '1';
                    when "00001" =>
                        char_out <= x"34"; -- 4
                        char_valid <= '1';
                    when "00011" =>
                        char_out <= x"33"; -- 3
                        char_valid <= '1';
                    when "00111" =>
                        char_out <= x"32"; -- 2
                        char_valid <= '1';
                    when "01111" =>
                        char_out <= x"31"; -- 1
                        char_valid <= '1';
                    when "10000" =>
                        char_out <= x"36"; -- 6
                        char_valid <= '1';
                    when "11000" =>
                        char_out <= x"37"; -- 7
                        char_valid <= '1';
                    when "11100" =>
                        char_out <= x"38"; -- 8
                        char_valid <= '1';
                    when "11110" =>
                        char_out <= x"39"; -- 9
                        char_valid <= '1';
                    when "11111" =>
                        char_out <= x"30"; -- 0
                        char_valid <= '1';
                    when others =>
                        char_out <= x"3F"; -- ?
                        char_valid <= '1';
                end case;

            when others =>
                char_out <= x"3F"; -- ?
                        char_valid <= '1';

        end case;

    end process;

end Behavioral;