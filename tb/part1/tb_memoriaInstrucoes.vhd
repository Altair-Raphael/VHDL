-- NOME                                NUSP            TURMA   -- 
-- Altair Raphael Alcazar Perez        14555666        Turma 1 --
-- Alvaro Primitz                      13687623        Turma 2 --
-- Ana Luiza Vieira Custodio           13684508        Turma 3 --
-- João Pedro Vakimoto                 14654718        Turma 2 --
-- José Rodrigues de Oliveira Santos   14583790        Turma 2 --
-- Lucas José Moura Ferreira           14747812        Turma 2 --

-- Arquivo: TestBench Memória de Instruções

library ieee;
use ieee.numeric_bit.all;

entity tb_memoriaInstrucoes is
end entity tb_memoriaInstrucoes;

architecture test of tb_memoriaInstrucoes is

    component memoriaInstrucoes is
        generic (
            addressSize : natural := 8;
            dataSize    : natural := 8;
            datFileName : string  := "memInstr_conteudo.dat"
        );
        port (
            addr : in bit_vector(addressSize-1 downto 0);
            data : out bit_vector(dataSize-1 downto 0)
        );
    end component;

    constant ADDR_WIDTH : natural := 8;
    constant DATA_WIDTH : natural := 8;

    signal s_addr : bit_vector(ADDR_WIDTH-1 downto 0) := (others => '0');
    signal s_data : bit_vector(DATA_WIDTH-1 downto 0);

begin

    -- Instancia aponta para o arquivo padrao
    DUT: memoriaInstrucoes
        generic map (
            addressSize => ADDR_WIDTH,
            dataSize    => DATA_WIDTH,
            datFileName => "memInstr_conteudo.dat"
        )
        port map (
            addr => s_addr,
            data => s_data
        );

    p_stimulus: process
    begin
        report "Inicio do Teste da ROM..." severity note;

        -- Teste Endereco 0 (Linha 1 do arquivo: 11110000)
        s_addr <= bit_vector(to_unsigned(0, ADDR_WIDTH));
        wait for 10 ns;
        assert (s_data = "11110000") report "Erro na leitura do end. 0" severity error;

        -- Teste Endereco 1 (Linha 2 do arquivo: 10101010)
        s_addr <= bit_vector(to_unsigned(1, ADDR_WIDTH));
        wait for 10 ns;
        assert (s_data = "10101010") report "Erro na leitura do end. 1" severity error;

        -- Teste Endereco 2 (Linha 3 do arquivo: 00001111)
        s_addr <= bit_vector(to_unsigned(2, ADDR_WIDTH));
        wait for 10 ns;
        assert (s_data = "00001111") report "Erro na leitura do end. 2" severity error;

        report "Teste da ROM concluido com SUCESSO." severity note;
        wait;
    end process;

end architecture test;