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

    -- Declaracao dos Componentes
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
    signal write_enable_lines : bit_vector(31 downto 0); 
    signal reg_outputs        : reg_array;               

begin

    -- 1. Decodificador de Escrita
    DECODER: decoder5_32 port map (sel => wr, res => write_enable_lines);

    -- 2. Geracao dos Registradores Reais (X0 ate X30)
    GEN_REGS: for i in 0 to 30 generate
        REG_X: reg
            generic map (dataSize => 64)
            port map (
                clock  => clock,
                reset  => reset,
                enable => regWrite and write_enable_lines(i),
                d      => d,
                q      => reg_outputs(i) 
            );
    end generate GEN_REGS;

    -- 3. Tratamento do XZR (X31)
    -- O registrador 31 e sempre zero e nao armazena dados.
    reg_outputs(31) <= (others => '0');

    -- 4. Multiplexadores de Leitura
    MUX_READ1: mux32_64 port map (inputs => reg_outputs, sel => rr1, dOut => q1);
    MUX_READ2: mux32_64 port map (inputs => reg_outputs, sel => rr2, dOut => q2);

end architecture structural;