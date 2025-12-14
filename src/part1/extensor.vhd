
-- NOME                                NUSP            TURMA   -- 
-- Altair Raphael Alcazar Perez        14555666        Turma 1 --
-- Alvaro Primitz                      13687623        Turma 2 --
-- Ana Luiza Vieira Custodio           13684508        Turma 3 --
-- João Pedro Vakimoto                 14654718        Turma 2 --
-- José Rodrigues de Oliveira Santos   14583790        Turma 2 --
-- Lucas José Moura Ferreira           14747812        Turma 2 --

-- Arquivo: extensor

library ieee;
use ieee.numeric_bit.all;

entity sign_extend is
    generic (
        dataISize       : natural := 32; -- Tamanho da entrada (datalSize no enunciado)
        dataOSize       : natural := 64; -- Tamanho da saída
        dataMaxPosition : natural := 5   -- log2(dataISize), para indexar 32 bits
    );
    port(
        inData      : in bit_vector(dataISize-1 downto 0);
        inDataStart : in bit_vector(dataMaxPosition-1 downto 0); -- Posição do Bit de Sinal (MSB útil)
        inDataEnd   : in bit_vector(dataMaxPosition-1 downto 0); -- Posição do Bit Menos Significativo (LSB útil)
        outData     : out bit_vector(dataOSize-1 downto 0)
    );
end entity sign_extend;

architecture behavioral of sign_extend is
begin
    process(inData, inDataStart, inDataEnd)
        -- Variáveis para armazenar os índices convertidos para inteiro
        variable start_idx : integer;
        variable end_idx   : integer;
        variable sign_bit  : bit;
        variable bit_count : integer; -- Comprimento do dado extraído
    begin
        -- Converte as entradas de posição (bit_vector) para inteiros
        start_idx := to_integer(unsigned(inDataStart));
        end_idx   := to_integer(unsigned(inDataEnd));
        
        -- Proteção básica: Se start < end, a configuração é inválida.
        -- Assumimos funcionamento normal (start >= end) conforme especificação.
        
        if start_idx >= dataISize then
             -- Caso o índice informado seja maior que o tamanho do vetor (segurança)
             start_idx := dataISize - 1;
        end if;
        
        -- O bit de sinal é o bit na posição 'inDataStart' da entrada
        sign_bit := inData(start_idx);
        
        -- Loop para construir a saída bit a bit
        for i in 0 to dataOSize-1 loop
            -- 'i' é a posição no vetor de saída (0 é o LSB)
            
            -- Verifica se 'i' está dentro da faixa de dados úteis extraídos
            -- O dado útil tem tamanho (start - end + 1).
            -- Logo, se i <= (start - end), estamos copiando dados.
            if i <= (start_idx - end_idx) then
                -- Mapeia o bit da entrada para a saída
                -- Exemplo: Se end=1, out(0) recebe in(1), out(1) recebe in(2)...
                outData(i) <= inData(end_idx + i);
            else
                -- Se 'i' ultrapassou o tamanho do dado útil, fazemos a extensão de sinal
                outData(i) <= sign_bit;
            end if;
        end loop;
        
    end process;
end architecture behavioral;