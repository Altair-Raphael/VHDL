-- NOME                                NUSP            TURMA   -- 
-- Altair Raphael Alcazar Perez        14555666        Turma 1 --
-- Alvaro Primitz                      13687623        Turma 2 --
-- Ana Luiza Vieira Custodio           13684508        Turma 3 --
-- João Pedro Vakimoto                 14654718        Turma 2 --
-- José Rodrigues de Oliveira Santos   14583790        Turma 2 --
-- Lucas José Moura Ferreira           14747812        Turma 2 --

-- Arquivo: Unidade Lógica Aritmética

library ieee;
use ieee.numeric_bit.all;

entity ula is
    port (
        alu_control : in bit_vector(3 downto 0);
        A, B        : in bit_vector(63 downto 0);
        F           : out bit_vector(63 downto 0);
        Z, Ov, Co   : out bit
    );
end entity ula;

architecture structural of ula is

    -- 1. Declaração do SEU componente (Nome exato: ula1bit)
    component ula1bit is
        port(
            a, b, cin        : in bit;
            ainvert, binvert : in bit;
            operation        : in bit_vector(1 downto 0);
            result           : out bit;
            cout, overflow   : out bit
        );
    end component;

    -- Sinais de Controle
    signal s_ainvert : bit;
    signal s_binvert : bit;
    signal s_op      : bit_vector(1 downto 0);

    -- Sinais Internos (Cadeias de 64+1 bits)
    signal c           : bit_vector(64 downto 0); -- Carry chain
    signal result_temp : bit_vector(63 downto 0); -- Resultado temporário
    signal ov_temp     : bit_vector(63 downto 0); -- Overflow de cada bit

begin

    -- 2. Decodificação do Controle (Baseado na Tabela do Enunciado)
    -- alu_control(3) -> Ainvert
    -- alu_control(2) -> Binvert
    -- alu_control(1 downto 0) -> Operation
    s_ainvert <= alu_control(3);
    s_binvert <= alu_control(2);
    s_op      <= alu_control(1 downto 0);

    -- 3. Carry-In Inicial (Crucial para Subtração)
    -- Se Binvert=1, assumimos que é uma subtração (A - B = A + NOT(B) + 1)
    -- Então o Carry-In inicial deve ser 1.
    c(0) <= s_binvert;

    -- 4. Geração das 64 instâncias da ula1bit
    GEN_ALU: for i in 0 to 63 generate
        BIT_I: ula1bit port map (
            a         => A(i),
            b         => B(i),
            cin       => c(i),      -- Recebe carry do anterior (ou inicial)
            ainvert   => s_ainvert,
            binvert   => s_binvert,
            operation => s_op,
            result    => result_temp(i),
            cout      => c(i+1),    -- Joga carry para o próximo
            overflow  => ov_temp(i)
        );
    end generate GEN_ALU;

    -- 5. Saídas Finais
    F  <= result_temp;
    Co <= c(64);        -- O último Carry Out é o Carry Out da ULA
    Ov <= ov_temp(63);  -- O Overflow só importa no bit mais significativo (MSB)

    -- 6. Cálculo da Flag Zero (Z)
    -- Se o resultado inteiro for 0, Z = 1.
    Z <= '1' when unsigned(result_temp) = 0 else '0';

end architecture structural;