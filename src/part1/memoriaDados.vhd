
-- NOME                                NUSP            TURMA   -- 
-- Altair Raphael Alcazar Perez        14555666        Turma 1 --
-- Alvaro Primitz                      13687623        Turma 2 --
-- Ana Luiza Vieira Custodio           13684508        Turma 3 --
-- João Pedro Vakimoto                 14654718        Turma 2 --
-- José Rodrigues de Oliveira Santos   14583790        Turma 2 --
-- Lucas José Moura Ferreira           14747812        Turma 2 --

-- Arquivo: memoria de dados

library ieee;
use ieee.numeric_bit.all; 
use std.textio.all;

entity memoriaDados is
    generic (
        addressSize : natural := 8;
        dataSize    : natural := 8;
        datFileName : string  := "memDados_conteudo_inicial.dat"
    );
    port (
        clock  : in bit;
        wr     : in bit;
        addr   : in bit_vector (addressSize-1 downto 0);
        data_i : in bit_vector (dataSize-1 downto 0);
        data_o : out bit_vector (dataSize-1 downto 0)
    );
end entity memoriaDados;

architecture rtl of memoriaDados is
    constant MEM_DEPTH : natural := 2**addressSize;
    type mem_tipo is array (0 to MEM_DEPTH - 1) of bit_vector(dataSize-1 downto 0);

    impure function init_mem (file_name : string) return mem_tipo is
        file mem_file : text open read_mode is file_name;
        variable line_in : line;
        variable mem_aux : mem_tipo := (others => (others => '0'));
        variable i : integer := 0;
        variable data_read : bit_vector(dataSize-1 downto 0);
    begin
        while not endfile(mem_file) and i < MEM_DEPTH loop
            readline(mem_file, line_in);
            read(line_in, data_read);
            mem_aux(i) := data_read;
            i := i + 1;
        end loop;
        return mem_aux;
    end function init_mem;

    signal mem : mem_tipo := init_mem(datFileName);
    signal addr_int : integer range 0 to MEM_DEPTH - 1;

begin
    addr_int <= to_integer(unsigned(addr));
    data_o <= mem(addr_int);

    process (clock)
    begin
        if clock'event and clock = '1' then
            if wr = '1' then
                mem(addr_int) <= data_i;
            end if;
        end if;
    end process;
end architecture rtl;