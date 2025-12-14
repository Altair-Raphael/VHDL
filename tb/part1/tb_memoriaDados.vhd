-- NOME                                NUSP            TURMA   -- 
-- Altair Raphael Alcazar Perez        14555666        Turma 1 --
-- Alvaro Primitz                      13687623        Turma 2 --
-- Ana Luiza Vieira Custodio           13684508        Turma 3 --
-- João Pedro Vakimoto                 14654718        Turma 2 --
-- José Rodrigues de Oliveira Santos   14583790        Turma 2 --
-- Lucas José Moura Ferreira           14747812        Turma 2 --

-- Arquivo: testbench da memoria de dados

library ieee;
use ieee.numeric_bit.all;

entity tb_memoriaDados is
end entity tb_memoriaDados;

architecture behavioral of tb_memoriaDados is

    -- Constantes
    constant C_ADDR_SIZE : natural := 8;
    constant C_DATA_SIZE : natural := 8;
    constant C_CLK_PERIOD : time := 10 ns;

    -- Sinais
    signal clock_s  : bit := '0';
    signal wr_s     : bit := '0';
    signal addr_s   : bit_vector (C_ADDR_SIZE-1 downto 0) := (others => '0');
    signal data_i_s : bit_vector (C_DATA_SIZE-1 downto 0) := (others => '0');
    signal data_o_s : bit_vector (C_DATA_SIZE-1 downto 0);

begin

    -- Instanciação Direta
    DUT : entity work.memoriaDados
    generic map (
        addressSize => C_ADDR_SIZE,
        dataSize    => C_DATA_SIZE,
        datFileName => "memDados_conteudo_inicial.dat"
    )
    port map (
        clock  => clock_s,
        wr     => wr_s,
        addr   => addr_s,
        data_i => data_i_s,
        data_o => data_o_s
    );

    -- Gerador de Clock Limitado (para evitar timeout)
    CLK_GEN : process
    begin
        for i in 1 to 30 loop -- 30 ciclos são suficientes
            clock_s <= '0';
            wait for C_CLK_PERIOD/2;
            clock_s <= '1';
            wait for C_CLK_PERIOD/2;
        end loop;
        wait;
    end process;

    -- Processo de Teste com Asserts
    TEST_CASES : process
    begin
        -- Aguarda inicialização
        wait for 10 ns; 
        
        -----------------------------------------------------------------------
        -- TESTE 1: Verificar leitura inicial do arquivo .dat
        -----------------------------------------------------------------------
        -- Lê endereço 0
        addr_s <= "00000000"; 
        wait for 5 ns;
        -- Se data_o_s NÃO for 00000001, imprime erro
        assert data_o_s = "00000001"
            report "ERRO GRAVE: Leitura do endereco 0 incorreta! Verifique se o arquivo .dat foi lido."
            severity error;
        
        -- Lê endereço 1
        addr_s <= "00000001"; 
        wait for 5 ns;
        assert data_o_s = "00000010"
            report "ERRO: Leitura do endereco 1 incorreta!"
            severity error;

        -----------------------------------------------------------------------
        -- TESTE 2: Verificar Escrita Síncrona
        -----------------------------------------------------------------------
        addr_s <= "00000011";      -- Endereço 3
        data_i_s <= "10101010";    -- Dado a escrever
        wr_s <= '1';               -- Habilita escrita
        
        wait until clock_s = '1';  -- Aguarda borda de subida
        wait for 1 ns;             -- Hold time
        wr_s <= '0';               -- Desabilita

        -- Espera um pouco e verifica se o valor mudou
        wait for 5 ns;
        
        assert data_o_s = "10101010"
            report "ERRO: A escrita na memoria FALHOU. O valor nao foi gravado corretamente."
            severity error;

        -----------------------------------------------------------------------
        -- MENSAGEM FINAL
        -----------------------------------------------------------------------
        -- Se chegou até aqui, avisa que terminou. 
        -- Se houve erros, eles apareceram acima em vermelho/negrito no log.
        report "Verificacao concluida. Se voce nao viu mensagens de ERRO acima, o codigo funciona perfeitamente." severity note;
        
        wait; -- Para o processo
    end process;

end architecture behavioral;