-- NOME                                NUSP            TURMA   -- 
-- Altair Raphael Alcazar Perez        14555666        Turma 1 --
-- Alvaro Primitz                      13687623        Turma 2 --
-- Ana Luiza Vieira Custodio           13684508        Turma 3 --
-- João Pedro Vakimoto                 14654718        Turma 2 --
-- José Rodrigues de Oliveira Santos   14583790        Turma 2 --
-- Lucas José Moura Ferreira           14747812        Turma 2 --

-- Arquivo: TB Full Adder

library ieee;
use ieee.numeric_bit.all;

entity tb_fulladder is
end entity tb_fulladder;

architecture test of tb_fulladder is
    component fulladder is
        port (
            a, b, cin: in bit;
            s, cout: out bit
        );
    end component;

    signal s_a, s_b, s_cin : bit;
    signal s_s, s_cout : bit;
    
    -- Tipo para tabela verdade (A, B, Cin, S_esp, Cout_esp)
    type pattern_type is record
        a, b, cin : bit;
        s, cout   : bit;
    end record;
    
    type pattern_array is array (natural range <>) of pattern_type;
    constant patterns : pattern_array := (
        ('0', '0', '0', '0', '0'), -- 0+0+0 = 0
        ('0', '0', '1', '1', '0'), -- 0+0+1 = 1
        ('0', '1', '0', '1', '0'), -- 0+1+0 = 1
        ('0', '1', '1', '0', '1'), -- 0+1+1 = 2 (10)
        ('1', '0', '0', '1', '0'), -- 1+0+0 = 1
        ('1', '0', '1', '0', '1'), -- 1+0+1 = 2 (10)
        ('1', '1', '0', '0', '1'), -- 1+1+0 = 2 (10)
        ('1', '1', '1', '1', '1')  -- 1+1+1 = 3 (11)
    );

begin
    DUT: fulladder port map (s_a, s_b, s_cin, s_s, s_cout);

    process
    begin
        report "Inicio do Teste FullAdder";
        for i in patterns'range loop
            s_a   <= patterns(i).a;
            s_b   <= patterns(i).b;
            s_cin <= patterns(i).cin;
            wait for 10 ns;
            
            assert (s_s = patterns(i).s and s_cout = patterns(i).cout)
            report "Erro no caso " & integer'image(i) severity error;
        end loop;
        report "Fim do Teste FullAdder";
        wait;
    end process;
end architecture;