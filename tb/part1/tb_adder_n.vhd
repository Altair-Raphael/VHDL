-- NOME                                NUSP            TURMA   -- 
-- Altair Raphael Alcazar Perez        14555666        Turma 1 --
-- Alvaro Primitz                      13687623        Turma 2 --
-- Ana Luiza Vieira Custodio           13684508        Turma 3 --
-- João Pedro Vakimoto                 14654718        Turma 2 --
-- José Rodrigues de Oliveira Santos   14583790        Turma 2 --
-- Lucas José Moura Ferreira           14747812        Turma 2 --

-- Arquivo: TestBench Somador Binário

library ieee;
use ieee.numeric_bit.all;

entity tb_adder_n is
end entity tb_adder_n;

architecture test of tb_adder_n is

    component adder_n is
        generic (dataSize: natural := 64);
        port(
            in0  : in bit_vector(dataSize-1 downto 0);
            in1  : in bit_vector(dataSize-1 downto 0);
            sum  : out bit_vector(dataSize-1 downto 0);
            cout : out bit
        );
    end component;

    -- Vamos testar com 4 bits para facilitar a visualização manual
    constant TEST_WIDTH : natural := 4;

    signal s_in0  : bit_vector(TEST_WIDTH-1 downto 0);
    signal s_in1  : bit_vector(TEST_WIDTH-1 downto 0);
    signal s_sum  : bit_vector(TEST_WIDTH-1 downto 0);
    signal s_cout : bit;

begin

    DUT: adder_n
        generic map (dataSize => TEST_WIDTH)
        port map (
            in0  => s_in0,
            in1  => s_in1,
            sum  => s_sum,
            cout => s_cout
        );

    p_stimulus: process
    begin
        report "Inicio do Teste do SOMADOR..." severity note;

        -- Teste 1: Soma Simples (2 + 3 = 5)
        -- 0010 + 0011 = 0101, cout=0
        s_in0 <= "0010";
        s_in1 <= "0011";
        wait for 10 ns;
        assert (s_sum = "0101" and s_cout = '0') report "Erro: 2+3 falhou" severity error;

        -- Teste 2: Soma no Limite (15 + 0 = 15)
        -- 1111 + 0000 = 1111, cout=0
        s_in0 <= "1111";
        s_in1 <= "0000";
        wait for 10 ns;
        assert (s_sum = "1111" and s_cout = '0') report "Erro: 15+0 falhou" severity error;

        -- Teste 3: Overflow/CarryOut (15 + 1 = 0)
        -- 1111 + 0001 = 0000, cout=1
        s_in0 <= "1111";
        s_in1 <= "0001";
        wait for 10 ns;
        assert (s_sum = "0000" and s_cout = '1') report "Erro: CarryOut falhou (15+1)" severity error;

        -- Teste 4: Overflow no meio (10 + 10 = 20 -> 4 com cout)
        -- 1010 + 1010 = 0100 (4), cout=1
        s_in0 <= "1010";
        s_in1 <= "1010";
        wait for 10 ns;
        assert (s_sum = "0100" and s_cout = '1') report "Erro: 10+10 falhou" severity error;

        report "Fim dos testes do SOMADOR com SUCESSO." severity note;
        wait;
    end process;

end architecture test;