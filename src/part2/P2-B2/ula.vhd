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

    -- Declara o componente de 1 bit (criado na Parte 1)
    component ularbit is
        port (
            a, b, ainvert, binvert, cin : in bit;
            operation : in bit_vector(1 downto 0);
            result, cout, overflow : out bit
        );
    end component;

    -- Sinais de Controle decodificados
    signal s_ainvert : bit;
    signal s_binvert : bit;
    signal s_op      : bit_vector(1 downto 0);

    -- Cadeia de Carry (65 bits: do 0 ate o 64)
    signal c : bit_vector(64 downto 0);
    
    -- Vetor temporario para o resultado (para calcularmos o Zero depois)
    signal result_temp : bit_vector(63 downto 0);
    
    -- Vetor para capturar overflows individuais (so usaremos o ultimo)
    signal ov_temp : bit_vector(63 downto 0);

begin

    -- 1. Decodificacao do Controle
    -- alu_control = (Ainvert, Binvert, Op1, Op0)
    s_ainvert <= alu_control(3);
    s_binvert <= alu_control(2);
    s_op      <= alu_control(1 downto 0);

    -- 2. Carry-In Inicial
    -- "Assuma que carry-in deve ser 1 sempre que B for invertido" 
    -- Isso permite transformar soma em subtracao automaticamente.
    c(0) <= s_binvert;

    -- 3. Geracao das 64 ULAs
    GEN_ALU: for i in 0 to 63 generate
        ALU_I: ularbit port map (
            a         => A(i),
            b         => B(i),
            ainvert   => s_ainvert,
            binvert   => s_binvert,
            cin       => c(i),      -- Recebe carry do anterior
            operation => s_op,
            result    => result_temp(i),
            cout      => c(i+1),    -- Passa carry para o proximo
            overflow  => ov_temp(i) -- Cada ULA calcula, mas so usaremos o MSB
        );
    end generate GEN_ALU;

    -- 4. Conexao das Saidas Finais
    F <= result_temp;
    
    -- Carry Out final é o carry que saiu da ultima ULA (bit 63 -> c(64))
    Co <= c(64);

    -- Overflow é relevante apenas na ULA do bit mais significativo (63) [cite: 243]
    Ov <= ov_temp(63);

    -- 5. Calculo da Flag Zero (Z)
    -- Se o resultado for 0, Z deve ser 1.
    -- Usamos conversao para unsigned para facilitar a comparacao
    Z <= '1' when unsigned(result_temp) = 0 else '0';

end architecture structural;