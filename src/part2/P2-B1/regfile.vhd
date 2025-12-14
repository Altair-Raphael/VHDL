-- NOME                                NUSP            TURMA   -- 
-- Altair Raphael Alcazar Perez        14555666        Turma 1 --
-- Alvaro Primitz                      13687623        Turma 2 --
-- Ana Luiza Vieira Custodio           13684508        Turma 3 --
-- João Pedro Vakimoto                 14654718        Turma 2 --
-- José Rodrigues de Oliveira Santos   14583790        Turma 2 --
-- Lucas José Moura Ferreira           14747812        Turma 2 --

-- Arquivo: Registradores

library ieee;
use ieee.numeric_bit.all;
use work.polilegv8_pkg.all; 

entity regfile is
    port (
        clock    : in bit;
        reset    : in bit;
        regWrite : in bit;
        rr1      : in bit_vector(4 downto 0);
        rr2      : in bit_vector(4 downto 0);
        wr       : in bit_vector(4 downto 0);
        d        : in bit_vector(63 downto 0);
        q1       : out bit_vector(63 downto 0);
        q2       : out bit_vector(63 downto 0)
    );
end entity regfile;

architecture structural of regfile is

    -- Declaração dos Componentes da Parte 1 e Auxiliares
    component reg is
        generic (dataSize: natural := 64);
        port (clock, reset, enable : in bit; d : in bit_vector; q : out bit_vector);
    end component;

    component decoder5_32 is
        port (sel : in bit_vector(4 downto 0); res : out bit_vector(31 downto 0));
    end component;

    component mux32_64 is
        port (inputs : in reg_array; sel : in bit_vector(4 downto 0); dOut : out bit_vector(63 downto 0));
    end component;

    -- Sinais Internos
    signal write_enable_lines : bit_vector(31 downto 0); -- Saida do Decoder
    signal reg_outputs        : reg_array;               -- Matriz com a saida de todos os regs

begin

    -- 1. Decodificador de Escrita
    -- Transforma o indice 'wr' (5 bits) em 32 fios ('hot-one')
    DECODER: decoder5_32 port map (sel => wr, res => write_enable_lines);

    -- 2. Geração dos Registradores Reais (X0 até X30)
    -- O 'generate' cria 31 copias do componente 'reg'
    GEN_REGS: for i in 0 to 30 generate
        REG_X: reg
            generic map (dataSize => 64)
            port map (
                clock  => clock,
                reset  => reset,
                -- O registrador só grava se regWrite=1 E se ele foi o escolhido pelo decoder
                enable => regWrite and write_enable_lines(i),
                d      => d,
                q      => reg_outputs(i) -- Conecta a saida no array geral
            );
    end generate GEN_REGS;

    -- 3. Tratamento do XZR (X31)
    [cite_start]-- "O registrador X31 tem a particularidade: seu conteudo é sempre zero" [cite: 684]
    -- Forçamos zero na posição 31 do array. Escritas aqui são ignoradas pois não há componente.
    reg_outputs(31) <= (others => '0');

    -- 4. Multiplexadores de Leitura
    -- Selecionam qual valor do array vai para a saida Q1 e Q2
    MUX_READ1: mux32_64 port map (inputs => reg_outputs, sel => rr1, dOut => q1);
    MUX_READ2: mux32_64 port map (inputs => reg_outputs, sel => rr2, dOut => q2);

end architecture structural;