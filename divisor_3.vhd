library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity divisor_3 is
    port(
        clk        : in  std_logic;
        ena        : in  std_logic;
        f_div_2_5  : out std_logic;
        f_div_1_25 : out std_logic;
        f_div_500  : out std_logic
    );
end entity divisor_3;

architecture Behavioral of divisor_3 is
    signal count4  : unsigned(1 downto 0) := "00";   
    signal count8  : unsigned(2 downto 0) := "000";  
    signal count20 : unsigned(4 downto 0) := "00000";

    signal pulse_4  : std_logic := '0';
    signal pulse_8  : std_logic := '0';
    signal pulse_20 : std_logic := '0';

begin
    -- Contador de módulo 4 (para 25MHz)
    process(clk)
    begin
        if rising_edge(clk) then
            if ena = '1' then
                if count4 = "11" then
                    count4 <= "00";
                    pulse_4 <= '1';  
                else
                    count4 <= count4 + 1;
                    pulse_4 <= '0';
                end if;
            end if;
        end if;
    end process;

    -- Contador de módulo 8 (para 12.5MHz)
    process(clk)
    begin
        if rising_edge(clk) then
            if ena = '1' then
                if count8 = "111" then
                    count8 <= "000";
                    pulse_8 <= '1'; 
                else
                    count8 <= count8 + 1;
                    pulse_8 <= '0';
                end if;
            end if;
        end if;
    end process;

    -- Contador de módulo 20 (para 5MHz)
    process(clk)
    begin
        if rising_edge(clk) then
            if ena = '1' then
                if count20 = "10011" then
                    count20 <= "00000";
                    pulse_20 <= '1'; 
                else
                    count20 <= count20 + 1;
                    pulse_20 <= '0';
                end if;
            end if;
        end if;
    end process;

    -- Asegurar que las salidas sean '1' cuando `ena` es '0'
    process(clk)
    begin
        if rising_edge(clk) then
            if ena = '1' then
                f_div_2_5  <= pulse_4;
                f_div_1_25 <= pulse_8;
                f_div_500  <= pulse_20;
            else
                f_div_2_5  <= '1';
                f_div_1_25 <= '1';
                f_div_500  <= '1';
            end if;
        end if;
    end process;

end Behavioral;