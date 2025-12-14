
-- NOME                                NUSP            TURMA   -- 
-- Altair Raphael Alcazar Perez        14555666        Turma 1 --
-- Alvaro Primitz                      13687623        Turma 2 --
-- Ana Luiza Vieira Custodio           13684508        Turma 3 --
-- João Pedro Vakimoto                 14654718        Turma 2 --
-- José Rodrigues de Oliveira Santos   14583790        Turma 2 --
-- Lucas José Moura Ferreira           14747812        Turma 2 --

-- Arquivo: multiplexador

library ieee;
use ieee.numeric_bit.all;

entity mux_n is
    generic (dataSize: natural := 64);
    port(
        in0  : in bit_vector(dataSize-1 downto 0);
        in1  : in bit_vector(dataSize-1 downto 0);
        sel  : in bit;
        dOut : out bit_vector(dataSize-1 downto 0)
    );
end entity mux_n;

architecture behavior of mux_n is
begin
    -- Logica Combinacional: Seleciona in0 se sel=0, senao in1
    dOut <= in0 when sel = '0' else in1;
end architecture behavior;