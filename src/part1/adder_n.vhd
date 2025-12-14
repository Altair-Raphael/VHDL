-- NOME                                NUSP            TURMA   -- 
-- Altair Raphael Alcazar Perez        14555666        Turma 1 --
-- Alvaro Primitz                      13687623        Turma 2 --
-- Ana Luiza Vieira Custodio           13684508        Turma 3 --
-- João Pedro Vakimoto                 14654718        Turma 2 --
-- José Rodrigues de Oliveira Santos   14583790        Turma 2 --
-- Lucas José Moura Ferreira           14747812        Turma 2 --

-- Arquivo: Somador Binário

library ieee;
use ieee.numeric_bit.all;

entity adder_n is
    generic (dataSize: natural := 64);
    port(
        in0  : in bit_vector(dataSize-1 downto 0);
        in1  : in bit_vector(dataSize-1 downto 0);
        sum  : out bit_vector(dataSize-1 downto 0);
        cout : out bit
    );
end entity adder_n;

architecture behavioral of adder_n is
begin
    process(in0, in1)
        -- Variavel temporaria com 1 bit extra para capturar o Carry Out
        variable temp_sum : unsigned(dataSize downto 0);
    begin
        -- Concatena '0' na frente para garantir que o resultado caiba no vetor estendido
        -- Ex: Somar 11 + 11 (3+3) em 2 bits gera overflow.
        -- ('0'&"11") + ('0'&"11") = "011" + "011" = "110" (6)
        temp_sum := unsigned('0' & in0) + unsigned('0' & in1);

        -- A parte baixa vai para a soma
        sum <= bit_vector(temp_sum(dataSize-1 downto 0));
        
        -- O bit mais significativo é o Carry Out
        cout <= temp_sum(dataSize);
    end process;
end architecture behavioral;