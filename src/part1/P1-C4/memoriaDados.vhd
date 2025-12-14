
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
        dataSize    : natural := 64;
        datFileName : string  := "memDadosInicialPolilegv8.dat"
    );
    port (
        clock  : in bit;
        wr     : in bit;
        addr   : in bit_vector(addressSize-1 downto 0);
        data_i : in bit_vector(dataSize-1 downto 0);
        data_o : out bit_vector(dataSize-1 downto 0)
    );
end entity memoriaDados;

architecture behavioral of memoriaDados is
    constant depth : natural := 2**addressSize;
    type mem_type is array (0 to depth-1) of bit_vector(dataSize-1 downto 0);

    impure function init_mem(file_name : string) return mem_type is
        file mif_file : text open read_mode is file_name;
        variable mif_line : line;
        variable temp_byte : bit_vector(7 downto 0);
        variable temp_word : bit_vector(dataSize-1 downto 0);
        variable temp_mem : mem_type;
    begin
        for i in 0 to depth-1 loop temp_mem(i) := (others => '0'); end loop;

        for i in 0 to depth-1 loop
            if not endfile(mif_file) then
                -- Le 8 bytes (8 linhas) para formar 64 bits
                for j in 0 to 7 loop
                    if not endfile(mif_file) then
                        readline(mif_file, mif_line);
                        read(mif_line, temp_byte);
                        temp_word((7-j)*8 + 7 downto (7-j)*8) := temp_byte;
                    end if;
                end loop;
                temp_mem(i) := temp_word;
            end if;
        end loop;
        return temp_mem;
    end function;

    signal mem : mem_type := init_mem(datFileName);
begin
    data_o <= mem(to_integer(unsigned(addr)));
    
    process(clock)
    begin
        if (clock'event and clock = '1') then
            if (wr = '1') then
                mem(to_integer(unsigned(addr))) <= data_i;
            end if;
        end if;
    end process;
end architecture behavioral;