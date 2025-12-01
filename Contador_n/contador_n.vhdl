VHDL

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; -- Necessário para somar (+1)

entity contador_n is
    generic (
        n : integer := 4
    );
    port (
        clock : in  std_logic;
        zera  : in  std_logic; -- Reset Síncrono
        conta : in  std_logic; -- Count Enable
        Q     : out std_logic_vector(n-1 downto 0);
        fim   : out std_logic  -- '1' quando Q for tudo '1'
    );
end entity contador_n;

architeture Behavioral of contador_n is
    --sinal interno para armazenar a contagem 
    signal contagem_atual: unsigned(n-1 downto 0) := (others => '0')
begin 

    --Processo Sícrono
    process(clock)
    begin
        if rising_edge(clock) then
            if zera = '1' then
                --reset tem prioridade
                contagem_atual <= (others => '0');
            elsif conta = '1' then
                --incrementa apenas se 'conta' estiver ativo
                contagem_atual <= contagem_atual +1;
            end if;
        end if;
    end process;

    --saídas
    Q <= std_logic_vector(contagem_atual);

    -- o sinal 'fim' acende quando a contagem é máxima (todos os bits 1)
    fim <= '1' when contagem_atual = (others => '1') else '0';

end Behavioral;