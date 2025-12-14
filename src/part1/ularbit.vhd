library ieee;
use ieee.numeric_bit.all;

entity ularbit is
    port (
        a         : in bit;
        b         : in bit;
        ainvert   : in bit;
        binvert   : in bit;
        cin       : in bit;
        operation : in bit_vector(1 downto 0);
        result    : out bit;
        cout      : out bit;
        overflow  : out bit
    );
end entity;

architecture behavior of ularbit is

    -- Declaração do componente Full Adder
    component fulladder is
        port (
            a, b, cin : in bit;
            s, cout   : out bit
        );
    end component;

    -- Sinais internos
    signal a_in, b_in : bit;    -- Entradas após inversão (se houver)
    signal sum_out    : bit;    -- Resultado da soma
    signal cout_out   : bit;    -- Carry out da soma
    signal logic_and  : bit;    -- Resultado AND
    signal logic_or   : bit;    -- Resultado OR

begin

    -- 1. Inversão das Entradas (Muxes de entrada)
    -- [cite: 213] "opera sempre sobre as entradas a e b, ou sobre suas versões negadas"
    a_in <= not a when ainvert = '1' else a;
    b_in <= not b when binvert = '1' else b;

    -- 2. Operações Lógicas
    logic_and <= a_in and b_in;
    logic_or  <= a_in or b_in;

    -- 3. Somador (Instância do FullAdder)
    ADDER: fulladder port map (
        a    => a_in,
        b    => b_in,
        cin  => cin,
        s    => sum_out,
        cout => cout_out
    );
    
    -- Conecta o Carry Out interno à saída
    cout <= cout_out;

    -- 4. Detecção de Overflow
    -- Overflow em soma de complemento de 2 (para 1 bit/MSB) é Cin XOR Cout
    -- [cite: 222] "A saída overflow só faz sentido... no bit mais significativo"
    overflow <= cin xor cout_out;

    -- 5. Multiplexador de Saída (Seleciona Result)
    -- [cite: 215-216] 00:AND, 01:OR, 10:ADD, 11:Pass B
    process(operation, logic_and, logic_or, sum_out, b)
    begin
        case operation is
            when "00" => result <= logic_and;
            when "01" => result <= logic_or;
            when "10" => result <= sum_out;
            when "11" => result <= b; -- [cite: 220] Copia a entrada B original (sem inversão)
            when others => result <= '0';
        end case;
    end process;

end architecture;