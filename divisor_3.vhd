library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity divisor_3 is
    port(
        clk         : in  std_logic;  -- Reloj del sistema (100MHz)
        ena         : in  std_logic;  -- Reset asíncrono (activo en '0')
        f_div_2_5   : out std_logic;  -- Salida de 25MHz (100MHz/4)
        f_div_1_25  : out std_logic;  -- Salida de 12.5MHz (100MHz/8)
        f_div_500   : out std_logic   -- Salida de 5MHz (100MHz/20)
    );
end entity divisor_3;

architecture Behavioral of divisor_3 is
    -- Contadores
    signal count4  : unsigned(1 downto 0) := (others => '0');  -- Contador módulo 4
    signal count8  : unsigned(2 downto 0) := (others => '0');  -- Contador módulo 8
    signal count20 : unsigned(4 downto 0) := (others => '0');  -- Contador módulo 20

    -- Señales de pulso para cada frecuencia
    signal pulse_div4  : std_logic := '0';
    signal pulse_div8  : std_logic := '0';
    signal pulse_div20 : std_logic := '0';

begin
    -- **Contador módulo 4 (Divide entre 4, genera 25MHz)**
    process(clk, ena)
    begin
        if ena = '0' then
            count4 <= (others => '0');
            pulse_div4 <= '0';
        elsif rising_edge(clk) then
            if count4 = "11" then
                count4 <= (others => '0');
                pulse_div4 <= '1';  -- Genera pulso cuando llega a 3
            else
                count4 <= count4 + 1;
                pulse_div4 <= '0';
            end if;
        end if;
    end process;

    -- **Contador módulo 8 (Divide entre 8, genera 12.5MHz)**
    process(clk, ena)
    begin
        if ena = '0' then
            count8 <= (others => '0');
            pulse_div8 <= '0';
        elsif rising_edge(clk) then
            if pulse_div4 = '1' then  -- Se habilita solo cuando pulso de 25MHz se activa
                if count8 = "111" then
                    count8 <= (others => '0');
                    pulse_div8 <= '1';  -- Genera pulso cuando llega a 7
                else
                    count8 <= count8 + 1;
                    pulse_div8 <= '0';
                end if;
            end if;
        end if;
    end process;

    -- **Contador módulo 20 (Divide entre 20, genera 5MHz)**
    process(clk, ena)
    begin
        if ena = '0' then
            count20 <= (others => '0');
            pulse_div20 <= '0';
        elsif rising_edge(clk) then
            if pulse_div4 = '1' then  -- Se habilita solo cuando pulso de 25MHz se activa
                if count20 = "10011" then
                    count20 <= (others => '0');
                    pulse_div20 <= '1';  -- Genera pulso cuando llega a 19
                else
                    count20 <= count20 + 1;
                    pulse_div20 <= '0';
                end if;
            end if;
        end if;
    end process;

    -- **Asignaciones de salida**
    f_div_2_5  <= pulse_div4;   -- Pulso de 25MHz (ciclo único)
    f_div_1_25 <= pulse_div8;   -- Pulso de 12.5MHz (ciclo único)
    f_div_500  <= pulse_div20;  -- Pulso de 5MHz (ciclo único)

end Behavioral;
