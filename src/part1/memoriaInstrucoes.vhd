-- NOME                                NUSP            TURMA   -- 
-- Altair Raphael Alcazar Perez        14555666        Turma 1 --
-- Alvaro Primitz                      13687623        Turma 2 --
-- Ana Luiza Vieira Custodio           13684508        Turma 3 --
-- João Pedro Vakimoto                 14654718        Turma 2 --
-- José Rodrigues de Oliveira Santos   14583790        Turma 2 --
-- Lucas José Moura Ferreira           14747812        Turma 2 --

-- Arquivo: Memória de Instruções

library ieee;
use ieee.numeric_bit.all;
use std.textio.all;

entity memoriaInstrucoes is
    generic (
        addressSize : natural := 8;
        dataSize    : natural := 8; -- 8 bits (Byte addressing)
        datFileName : string  := "memInstr_conteudo.dat"
    );
    port (
        addr : in bit_vector(addressSize-1 downto 0);
        data : out bit_vector(dataSize-1 downto 0)
    );
end entity memoriaInstrucoes;

architecture behavior of memoriaInstrucoes is
    -- Define o tipo da memoria (Array de bytes)
    -- Profundidade = 2^addressSize
    constant DEPTH : natural := 2**addressSize;
    type mem_type is array (0 to DEPTH-1) of bit_vector(dataSize-1 downto 0);

    -- Funcao impura para carregar o arquivo .dat na memoria
    impure function init_mem(fileName : string) return mem_type is
        file f_ptr      : text open read_mode is fileName;
        variable linha  : line;
        variable temp_bv: bit_vector(dataSize-1 downto 0);
        variable temp_mem : mem_type := (others => (others => '0'));
    begin
        for i in 0 to DEPTH-1 loop
            if not endfile(f_ptr) then
                readline(f_ptr, linha);
                read(linha, temp_bv);
                temp_mem(i) := temp_bv;
            end if;
        end loop;
        return temp_mem;
    end function;

    -- Sinal de memoria inicializado pela funcao
    constant rom_content : mem_type := init_mem(datFileName);

begin
    -- Leitura Assincrona: data <= rom[addr]
    -- Converte o vetor de endereco (addr) para inteiro para acessar o indice
    data <= rom_content(to_integer(unsigned(addr)));

end architecture behavior;