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

architecture test of tb_memoriaDados is
    component memoriaDados is
        generic (
            addressSize : natural := 8;
            dataSize    : natural := 64; -- Atualizado para 64
            datFileName : string  := "memDadosInicialPolilegv8.dat"
        );
        port (
            clock  : in bit;
            wr     : in bit;
            addr   : in bit_vector(addressSize-1 downto 0);
            data_i : in bit_vector(dataSize-1 downto 0);
            data_o : out bit_vector(dataSize-1 downto 0)
        );
    end component;

    signal s_clock : bit := '0';
    signal s_wr    : bit := '0';
    signal s_addr  : bit_vector(7 downto 0) := (others => '0');
    signal s_data_i: bit_vector(63 downto 0) := (others => '0');
    signal s_data_o: bit_vector(63 downto 0);

begin
    DUT: memoriaDados
        generic map (addressSize => 8, dataSize => 64, datFileName => "memDadosInicialPolilegv8.dat")
        port map (s_clock, s_wr, s_addr, s_data_i, s_data_o);

    -- Clock generator
    process
    begin
        s_clock <= '0'; wait for 5 ns;
        s_clock <= '1'; wait for 5 ns;
    end process;

    process
    begin
        report "Inicio Teste Memoria Dados (64 bits)";
        
        -- 1. Leitura Inicial (Endereço 0) - Deve ler 8 bytes do arquivo
        s_wr <= '0';
        s_addr <= "00000000";
        wait for 10 ns;

        -- 2. Escrita (Gravar FFFFFF... no Endereço 1)
        wait until s_clock = '0'; -- Sincronizar
        s_wr <= '1';
        s_addr <= "00000001";
        s_data_i <= (others => '1'); -- 64 bits de '1'
        wait for 10 ns;

        -- 3. Leitura do que foi gravado
        s_wr <= '0';
        s_data_i <= (others => '0');
        wait for 10 ns; -- Aguarda leitura estabilizar

        report "Fim Teste Memoria Dados";
        wait;
    end process;
end architecture;