library ieee;
use ieee.numeric_bit.all;

entity ula1bit is
    port(
        a         : in bit;
        b         : in bit;
        cin       : in bit;
        ainvert   : in bit;
        binvert   : in bit;
        operation : in bit_vector(1 downto 0);
        result    : out bit;
        cout      : out bit;
        overflow  : out bit
    );
end entity ula1bit;

architecture rtl of ula1bit is
    -- Sinais internos para os operandos após verificação de inversão
    signal op_a, op_b : bit;
    
    -- Sinais internos para resultados
    signal res_and, res_or : bit;
    signal sum_internal, cout_internal : bit;

begin

    -- 1. Tratamento das Entradas (Inversores)
    -- Se ainvert/binvert forem '1', inverte o bit. Caso contrário, mantém.
    op_a <= not a when ainvert = '1' else a;
    op_b <= not b when binvert = '1' else b;

    -- 2. Lógica do Somador Completo (Implementada internamente sem componente)
    -- Soma: A XOR B XOR Cin
    sum_internal  <= op_a xor op_b xor cin;
    
    -- Carry Out: (A AND B) OR (A AND Cin) OR (B AND Cin)
    cout_internal <= (op_a and op_b) or (op_a and cin) or (op_b and cin);

    -- 3. Operações Lógicas
    res_and <= op_a and op_b;
    res_or  <= op_a or op_b;

    -- 4. Saídas de Controle (Carry e Overflow)
    -- São calculadas sempre, independente da operação selecionada (conforme testbench)
    cout     <= cout_internal;
    overflow <= cin xor cout_internal;

    -- 5. Multiplexador de Saída
    with operation select
        result <= res_and      when "00", -- AND
                  res_or       when "01", -- OR
                  sum_internal when "10", -- ADD (Soma)
                  b            when "11", -- PASS B (Raw): Passa 'b' original,
                                          -- ignorando o 'binvert' (conforme regra do testbench).
                  '0'          when others;

end architecture rtl;