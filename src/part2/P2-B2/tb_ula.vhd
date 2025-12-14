-- NOME                                NUSP            TURMA   -- 
-- Altair Raphael Alcazar Perez        14555666        Turma 1 --
-- Alvaro Primitz                      13687623        Turma 2 --
-- Ana Luiza Vieira Custodio           13684508        Turma 3 --
-- João Pedro Vakimoto                 14654718        Turma 2 --
-- José Rodrigues de Oliveira Santos   14583790        Turma 2 --
-- Lucas José Moura Ferreira           14747812        Turma 2 --

-- Arquivo: TestBench Unidade Lógica Aritmética

library ieee;
use ieee.numeric_bit.all;

entity tb_ula is
end entity tb_ula;

architecture test of tb_ula is
    component ula is
        port (
            alu_control : in bit_vector(3 downto 0);
            A, B        : in bit_vector(63 downto 0);
            F           : out bit_vector(63 downto 0);
            Z, Ov, Co   : out bit
        );
    end component;

    signal s_ctrl : bit_vector(3 downto 0);
    signal s_A, s_B, s_F : bit_vector(63 downto 0);
    signal s_Z, s_Ov, s_Co : bit;

begin
    DUT: ula port map (s_ctrl, s_A, s_B, s_F, s_Z, s_Ov, s_Co);

    process
    begin
        report "Inicio Teste ULA 64";
        
        -- Configuração Inicial
        s_A <= bit_vector(to_unsigned(10, 64)); -- A = 10
        s_B <= bit_vector(to_unsigned(5, 64));  -- B = 5

        -- 1. Teste AND (0000) -> 10 AND 5 = 0
        -- (1010 AND 0101 = 0000)
        s_ctrl <= "0000"; wait for 10 ns;
        assert (unsigned(s_F) = 0) report "Erro AND" severity error;
        assert (s_Z = '1') report "Erro Flag Zero no AND" severity error;

        -- 2. Teste OR (0001) -> 10 OR 5 = 15
        -- (1010 OR 0101 = 1111)
        s_ctrl <= "0001"; wait for 10 ns;
        assert (unsigned(s_F) = 15) report "Erro OR" severity error;

        -- 3. Teste ADD (0010) -> 10 + 5 = 15
        s_ctrl <= "0010"; wait for 10 ns;
        assert (unsigned(s_F) = 15) report "Erro ADD" severity error;

        -- 4. Teste SUB (0110) -> 10 - 5 = 5
        -- Binvert=1 (bit 2) ativa a subtração e o carry-in
        s_ctrl <= "0110"; wait for 10 ns;
        assert (unsigned(s_F) = 5) report "Erro SUB" severity error;

        -- 5. Teste Pass B (xx11) -> Passa 5
        s_ctrl <= "0011"; wait for 10 ns;
        assert (unsigned(s_F) = 5) report "Erro Pass B" severity error;

        -- 6. Teste de Overflow
        -- Somar MAX_INT + 1
        s_ctrl <= "0010"; -- ADD
        s_A <= (63 => '0', others => '1'); -- Maior numero positivo (011...1)
        s_B <= bit_vector(to_unsigned(1, 64));
        wait for 10 ns;
        -- Resultado vira negativo (100...0) -> Overflow!
        assert (s_Ov = '1') report "Erro Overflow Check" severity error;

        report "Fim Teste ULA 64";
        wait;
    end process;

end architecture;
