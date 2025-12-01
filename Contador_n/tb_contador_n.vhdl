library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_contador_n is
end entity tb_contador_n;

architecture Sim of tb_contador_n is

    -- 1. Configuração do DUT (Design Under Test)
    constant N_BITS : integer := 4; -- Vamos testar com 4 bits (0 a 15)
    
    component contador_n
        generic ( n : integer );
        port (
            clock : in  std_logic;
            zera  : in  std_logic;
            conta : in  std_logic;
            Q     : out std_logic_vector(n-1 downto 0);
            fim   : out std_logic
        );
    end component;

    -- 2. Sinais de conexão
    signal clk   : std_logic := '0';
    signal zera  : std_logic := '0';
    signal conta : std_logic := '0';
    signal Q     : std_logic_vector(N_BITS-1 downto 0);
    signal fim   : std_logic;

    -- Constante de Clock (50 MHz = 20ns)
    constant CLK_PERIOD : time := 20 ns;

begin

    -- 3. Instanciação do Componente
    DUT: contador_n
        generic map ( n => N_BITS )
        port map (
            clock => clk,
            zera  => zera,
            conta => conta,
            Q     => Q,
            fim   => fim
        );

    -- 4. Gerador de Clock
    clk <= not clk after CLK_PERIOD / 2;

    -- 5. Processo de Estímulos (Implementação do Plano de Teste)
    process
    begin
        -- =======================================
        -- CASO 1: Reset Inicial
        -- =======================================
        report "Inicio do Teste";
        zera  <= '1';
        conta <= '0';
        wait for CLK_PERIOD; -- Espera um clock para garantir o reset
        
        assert Q = "0000" report "Erro 1: Reset falhou!" severity error;
        assert fim = '0'  report "Erro 1b: Fim deveria ser 0" severity error;

        -- =======================================
        -- CASO 2: Contagem Normal (0 -> 1 -> 2)
        -- =======================================
        zera  <= '0';
        conta <= '1'; -- Habilita contagem
        wait for CLK_PERIOD; -- Borda de subida 1
        
        -- Esperado: Q = 1
        assert unsigned(Q) = 1 report "Erro 2: Nao contou para 1" severity error;
        
        wait for CLK_PERIOD; -- Borda de subida 2
        -- Esperado: Q = 2
        assert unsigned(Q) = 2 report "Erro 2b: Nao contou para 2" severity error;

        -- =======================================
        -- CASO 3: Teste do Sinal 'Fim' (Máximo)
        -- Vamos esperar até chegar em 15 (1111)
        -- Já estamos em 2, faltam 13 ciclos.
        -- =======================================
        for i in 3 to 15 loop
            wait for CLK_PERIOD;
        end loop;
        
        -- Agora Q deve ser 15 ("1111")
        assert unsigned(Q) = 15 report "Erro 3: Nao chegou no maximo" severity error;
        
        -- O sinal 'fim' deve estar ACESO
        -- Esperamos um delta time para o sinal fim atualizar (logica combinacional)
        wait for 1 ns; 
        assert fim = '1' report "Erro 3b: Sinal FIM nao acendeu no maximo" severity error;

        -- =======================================
        -- CASO 4: Overflow (Wrap-around)
        -- Mais um clock deve levar de 15 -> 0
        -- =======================================
        wait for CLK_PERIOD - 1 ns; -- Completa o ciclo anterior
        
        -- Agora Q deve ter voltado para 0
        assert unsigned(Q) = 0 report "Erro 4: Nao fez overflow para 0" severity error;
        assert fim = '0'       report "Erro 4b: Fim nao apagou" severity error;

        -- =======================================
        -- CASO 5: Hold (Pausa)
        -- Vamos contar ate 5 e pausar
        -- =======================================
        -- Avança 5 clocks (0 -> 5)
        for i in 1 to 5 loop wait for CLK_PERIOD; end loop;
        
        conta <= '0'; -- PAUSA!
        wait for CLK_PERIOD * 3; -- Espera 3 ciclos
        
        -- Deve continuar em 5
        assert unsigned(Q) = 5 report "Erro 5: Contador nao pausou" severity error;

        -- =======================================
        -- CASO 6: Reset durante contagem
        -- =======================================
        zera <= '1'; -- RESET!
        wait for CLK_PERIOD;
        
        assert unsigned(Q) = 0 report "Erro 6: Reset assincrono falhou" severity error;

        -- Fim
        report "Teste do Contador Concluido com Sucesso!";
        wait; -- Para a simulação
    end process;

end Sim;