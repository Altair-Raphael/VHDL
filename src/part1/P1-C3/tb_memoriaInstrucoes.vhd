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
            dataSize    : natural := 32; -- Atualizado para 32
            datFileName : string  := "memInstrPolilegv8.dat"
        );
        port (
            addr : in bit_vector(addressSize-1 downto 0);
            data : out bit_vector(dataSize-1 downto 0)
        );
    end component;

    constant addressSize : natural := 8;
    constant dataSize    : natural := 32;

    signal s_addr : bit_vector(addressSize-1 downto 0);
    signal s_data : bit_vector(dataSize-1 downto 0);

begin
    DUT: memoriaInstrucoes 
        generic map (addressSize => 8, dataSize => 32, datFileName => "memInstrPolilegv8.dat")
        port map (s_addr, s_data);

    process
    begin
        report "Inicio Teste Memoria Instrucoes (32 bits)";

        -- Teste 1: Endereço 0 (Deve ler os primeiros 4 bytes do arquivo e montar a palavra)
        s_addr <= "00000000";
        wait for 10 ns;
        -- Verifique no Wave se s_data montou os 32 bits corretamente

        -- Teste 2: Endereço 1 (Deve ler os proximos 4 bytes)
        s_addr <= "00000001";
        wait for 10 ns;

        -- Teste 3: Endereço 2
        s_addr <= "00000010";
        wait for 10 ns;

        report "Fim Teste Memoria Instrucoes";
        wait;
    end process;
end architecture;