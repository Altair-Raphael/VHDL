
-- NOME                                NUSP            TURMA   -- 
-- Altair Raphael Alcazar Perez        14555666        Turma 1 --
-- Alvaro Primitz                      13687623        Turma 2 --
-- Ana Luiza Vieira Custodio           13684508        Turma 3 --
-- João Pedro Vakimoto                 14654718        Turma 2 --
-- José Rodrigues de Oliveira Santos   14583790        Turma 2 --
-- Lucas José Moura Ferreira           14747812        Turma 2 --

-- Arquivo: testbench do multiplexador

library ieee;
use ieee.numeric_bit.all;

entity tb_mux_n is
end entity tb_mux_n;

architecture test of tb_mux_n is

    -- 1. Declaração do Componente
    component mux_n is
        generic (dataSize: natural := 64);
        port(
            in0  : in bit_vector(dataSize-1 downto 0);
            in1  : in bit_vector(dataSize-1 downto 0);
            sel  : in bit;
            dOut : out bit_vector(dataSize-1 downto 0)
        );
    end component;

    -- 2. Sinais de Teste
    constant DATA_WIDTH : natural := 64;
    
    -- Valores de teste (Hexadecimal para facilitar leitura)
    -- A = Todos Zero, B = Todos Um
    constant VAL_A : bit_vector(DATA_WIDTH-1 downto 0) := (others => '0');
    constant VAL_B : bit_vector(DATA_WIDTH-1 downto 0) := (others => '1');
    -- C = Padrão alternado 1010...
    constant VAL_C : bit_vector(DATA_WIDTH-1 downto 0) := X"AAAAAAAAAAAAAAAA"; 

    signal s_in0  : bit_vector(DATA_WIDTH-1 downto 0);
    signal s_in1  : bit_vector(DATA_WIDTH-1 downto 0);
    signal s_sel  : bit;
    signal s_dOut : bit_vector(DATA_WIDTH-1 downto 0);

begin

    -- 3. Instanciação do DUT
    DUT: mux_n
        generic map (dataSize => DATA_WIDTH)
        port map (
            in0  => s_in0,
            in1  => s_in1,
            sel  => s_sel,
            dOut => s_dOut
        );

    -- 4. Processo de Estímulos
    p_stimulus: process
    begin
        report "Inicio do Teste do MUX_N..." severity note;

        -- Configuração Inicial
        s_in0 <= VAL_A; -- Entrada 0 recebe Zeros
        s_in1 <= VAL_B; -- Entrada 1 recebe Ums
        
        -- Caso 1: Teste Seleção 0
        s_sel <= '0';
        wait for 10 ns;
        assert (s_dOut = VAL_A) report "Erro: Sel=0 deveria passar in0 (Zeros)" severity error;

        -- Caso 2: Teste Seleção 1
        s_sel <= '1';
        wait for 10 ns;
        assert (s_dOut = VAL_B) report "Erro: Sel=1 deveria passar in1 (Ums)" severity error;

        -- Caso 3: Mudança dinâmica nas entradas
        report "Teste Dinamico: Mudando entradas..." severity note;
        s_sel <= '0';           -- Volta a olhar para in0
        wait for 5 ns;
        s_in0 <= VAL_C;         -- Muda in0 para padrão alternado
        wait for 5 ns;
        assert (s_dOut = VAL_C) report "Erro: Saida nao acompanhou mudanca em in0" severity error;

        -- Caso 4: Mudança dinâmica do Select com valores fixos
        s_in0 <= VAL_A;
        s_in1 <= VAL_C;
        s_sel <= '1'; -- Deve passar C
        wait for 5 ns;
        assert (s_dOut = VAL_C) report "Erro: Falha ao selecionar in1 (C)" severity error;
        
        s_sel <= '0'; -- Deve passar A
        wait for 5 ns;
        assert (s_dOut = VAL_A) report "Erro: Falha ao selecionar in0 (A)" severity error;

        -- Finalização
        report "Fim dos testes do MUX_N com SUCESSO." severity note;
        wait;
    end process;

end architecture test;