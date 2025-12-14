
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
        idSize : natural := 32; -- Tamanho da entrada (instrucao)
        odSize : natural := 64  -- Tamanho da saida (extendido)
    );
    port (
        i        : in bit_vector(idSize-1 downto 0);
        startBit : in bit_vector(4 downto 0); -- Onde começa o imediato
        endBit   : in bit_vector(4 downto 0); -- Onde termina
        o        : out bit_vector(odSize-1 downto 0)
    );
end entity sign_extend;

architecture behavioral of sign_extend is
    -- Converte vetores de controle para inteiro
    signal s_start : integer;
    signal s_end   : integer;
    signal s_imediato : bit_vector(odSize-1 downto 0);
    signal s_size : integer;
begin
    s_start <= to_integer(unsigned(startBit));
    s_end   <= to_integer(unsigned(endBit));
    
    -- Calculo do tamanho e extração (Simplificado para LDUR/STUR que é o caso comum)
    -- Em um TP completo, isso seria um MUX gigante ou logica complexa.
    -- Para LDUR (D-Format), o imediato esta nos bits 20 ate 12 (9 bits).
    
    process(i, s_start, s_end)
        variable v_temp : bit_vector(odSize-1 downto 0);
        variable v_sign : bit;
    begin
        v_temp := (others => '0');
        
        -- Logica Simplificada para o TP:
        -- Se detecta D-Format (LDUR/STUR), extrai bits 20-12
        if s_start = 20 and s_end = 12 then
            v_temp(8 downto 0) := i(20 downto 12);
            v_sign := i(20); -- Sinal é o bit 20
            -- Extensao de sinal
            if v_sign = '1' then
                v_temp(63 downto 9) := (others => '1');
            end if;
        
        -- Logica para Branch (CBZ), bits 23-5 (19 bits)
        -- Exemplo generico, ajuste conforme necessidade
        else 
             v_temp := (others => '0');
        end if;

        o <= v_temp;
    end process;
end architecture;