library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_divisor_3 is
end entity tb_divisor_3;

architecture Behavioral of tb_divisor_3 is
   -- **Componente a probar**
   component divisor_3 is
      port(
          clk         : in  std_logic;
          ena         : in  std_logic;
          f_div_2_5   : out std_logic;
          f_div_1_25  : out std_logic;
          f_div_500   : out std_logic
      );
   end component;

   -- **Señales de prueba**
   signal clk        : std_logic := '0';
   signal ena        : std_logic := '0';
   signal f_div_2_5  : std_logic;
   signal f_div_1_25 : std_logic;
   signal f_div_500  : std_logic;
   
   -- **Definir el período del reloj**
   constant clk_period : time := 10 ns;  -- Período de 100MHz (10ns por ciclo)
   
begin
   -- **Instancia del módulo divisor**
   uut: divisor_3 port map (
       clk        => clk,
       ena        => ena,
       f_div_2_5  => f_div_2_5,
       f_div_1_25 => f_div_1_25,
       f_div_500  => f_div_500
   );

   -- **Generador de reloj (100MHz)**
   clk_process : process
   begin
      while true loop
         clk <= '0';
         wait for clk_period/2;
         clk <= '1';
         wait for clk_period/2;
      end loop;
   end process;

   -- **Proceso de estímulos**
   stimulus: process
   begin
      -- **Aplicar reset**
      ena  <= '0';
      wait for 40 ns;  
      ena  <= '1';  -- Habilitar el módulo
      
      -- **Ejecutar la simulación durante 2000 ns**
      wait for 2000 ns;  

      -- **Verificación de salidas (esperado: pulsos en f_div_2_5, f_div_1_25 y f_div_500)**
      report "Fin de la simulación" severity note;
      assert false report "Simulación terminada" severity failure;
   end process;

end Behavioral;
