-- NOME                                NUSP            TURMA   -- 
-- Altair Raphael Alcazar Perez        14555666        Turma 1 --
-- Alvaro Primitz                      13687623        Turma 2 --
-- Ana Luiza Vieira Custodio           13684508        Turma 3 --
-- João Pedro Vakimoto                 14654718        Turma 2 --
-- José Rodrigues de Oliveira Santos   14583790        Turma 2 --
-- Lucas José Moura Ferreira           14747812        Turma 2 --

-- Arquivo: Full Adder

library ieee;
use ieee.numeric_bit.all;

entity fulladder is
  port (
    a, b, cin: in bit;
    s, cout: out bit
  );
end entity;

architecture structural of fulladder is
  signal axorb: bit;
begin
  axorb <= a xor b;
  s     <= axorb xor cin;
  cout  <= (axorb and cin) or (a and b);
end architecture;