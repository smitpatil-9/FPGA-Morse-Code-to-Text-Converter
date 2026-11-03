library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity display_memory is
    port (
        clk            : in  std_logic;
        char_in        : in  std_logic_vector(7 downto 0);
        char_valid     : in  std_logic;
        space          : in  std_logic;
        delete         : in  std_logic;
        clear          : in  std_logic;
        display_data   : out std_logic_vector(255 downto 0);
        char_count_out : out std_logic_vector(5 downto 0)
    );
end display_memory;

architecture Behavioral of display_memory is

    function blank_memory return std_logic_vector is
        variable temp : std_logic_vector(255 downto 0);
    begin
        for i in 0 to 31 loop
            temp(i * 8 + 7 downto i * 8) := x"20";
        end loop;
        return temp;
    end function;

    signal mem : std_logic_vector(255 downto 0) :=
        blank_memory;

    signal char_count : integer range 0 to 32 := 0;

begin

    process(clk)
    begin
        if rising_edge(clk) then

            if clear = '1' then
                mem <= blank_memory;
                char_count <= 0;

            elsif delete = '1' then

                if char_count > 0 then
                    mem((char_count - 1) * 8 + 7 downto
                        (char_count - 1) * 8) <= x"20";

                    char_count <= char_count - 1;
                end if;

            elsif char_valid = '1' then

                if char_count < 32 then
                    mem(char_count * 8 + 7 downto
                        char_count * 8) <= char_in;

                    char_count <= char_count + 1;
                end if;

            elsif space = '1' then

                if char_count < 32 then
                    mem(char_count * 8 + 7 downto
                        char_count * 8) <= x"20";

                    char_count <= char_count + 1;
                end if;

            end if;

        end if;
    end process;

    display_data <= mem;

    char_count_out <=
        std_logic_vector(to_unsigned(char_count, 6));

end Behavioral;