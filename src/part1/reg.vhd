
-- NOME                                NUSP            TURMA   -- 
-- Altair Raphael Alcazar Perez        14555666        Turma 1 --
-- Alvaro Primitz                      13687623        Turma 2 --
-- Ana Luiza Vieira Custodio           13684508        Turma 3 --
-- João Pedro Vakimoto                 14654718        Turma 2 --
-- José Rodrigues de Oliveira Santos   14583790        Turma 2 --
-- Lucas José Moura Ferreira           14747812        Turma 2 --

-- Arquivo: registradores

library ieee;
use ieee.numeric_bit.all;

entity reg is
    generic (dataSize: natural := 64);
    port (
        clock  : in bit;
        reset  : in bit;
        enable : in bit;
        d      : in bit_vector(dataSize-1 downto 0);
        q      : out bit_vector(dataSize-1 downto 0)
    );
end entity reg;

architecture behavior of reg is
    -- Sinal interno para armazenar o estado
    signal storage : bit_vector(dataSize-1 downto 0);
begin

    process(clock, reset)
    begin
        -- Reset Assíncrono (Prioridade sobre o Clock)
        -- Conforme enunciado: "reset é assíncrono e força todos os bits para zero" [cite: 86]
        if reset = '1' then
            storage <= (others => '0');
        
        -- Escrita Síncrona na Borda de Subida
        -- Conforme enunciado: "borda de subida... enable é alto... gravada" [cite: 87]
        elsif (clock'event and clock = '1') then
            if enable = '1' then
                storage <= d;
            end if;
        end if;
    end process;

    -- Saída Assíncrona
    -- Conforme enunciado: "saída q é assíncrona e mostra o conteúdo atual" [cite: 89]
    q <= storage;

end architecture behavior;