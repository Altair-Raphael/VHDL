library ieee;
use ieee.numeric_bit.all;

entity tb_ularbit is
end entity tb_ularbit;

architecture test of tb_ularbit is
    component ularbit is
        port (
            a, b, ainvert, binvert, cin : in bit;
            operation : in bit_vector(1 downto 0);
            result, cout, overflow : out bit
        );
    end component;

    signal s_a, s_b, s_ainv, s_binv, s_cin : bit := '0';
    signal s_op : bit_vector(1 downto 0) := "00";
    signal s_res, s_cout, s_ov : bit;

begin
    DUT: ularbit port map (s_a, s_b, s_ainv, s_binv, s_cin, s_op, s_res, s_cout, s_ov);

    process
    begin
        report "Inicio Teste ULA 1 Bit";
        
        -- Configuração Padrão: A=1, B=0
        s_a <= '1'; s_b <= '0'; s_cin <= '0'; s_ainv <= '0'; s_binv <= '0';

        -- 1. Teste AND (Op 00) -> 1 AND 0 = 0
        s_op <= "00"; wait for 10 ns;
        assert (s_res = '0') report "Erro AND" severity error;

        -- 2. Teste OR (Op 01) -> 1 OR 0 = 1
        s_op <= "01"; wait for 10 ns;
        assert (s_res = '1') report "Erro OR" severity error;

        -- 3. Teste ADD (Op 10) -> 1 + 0 = 1
        s_op <= "10"; wait for 10 ns;
        assert (s_res = '1' and s_cout = '0') report "Erro ADD" severity error;

        -- 4. Teste PASS B (Op 11) -> Passa B (0)
        s_op <= "11"; wait for 10 ns;
        assert (s_res = '0') report "Erro PASS B" severity error;

        -- 5. Teste SUBTRAÇÃO Simulada (A - B) -> A + NOT(B) + 1
        -- A=1, B=1. 1 - 1 = 0.
        s_a <= '1'; s_b <= '1';
        s_op <= "10"; -- ADD
        s_binv <= '1'; -- Inverte B
        s_cin <= '1';  -- Carry In = 1 (Complemento de 2)
        wait for 10 ns;
        -- 1 + 0 + 1 = 10 (S=0, Cout=1)
        assert (s_res = '0' and s_cout = '1') report "Erro SUB (1-1)" severity error;

        -- 6. Teste Overflow (Soma dois positivos dando negativo no bit MSB)
        -- Simulação de MSB: Cin=0, Cout=1 (estouro) -> Ov=1
        -- A=1, B=1, Op=ADD. 1+1 = 0, Cout=1.
        s_ainv <= '0'; s_binv <= '0'; s_cin <= '0'; -- Reset controles
        s_a <= '1'; s_b <= '1'; s_op <= "10";
        wait for 10 ns;
        assert (s_ov = '1') report "Erro Overflow Check" severity error;

        report "Fim Teste ULA 1 Bit";
        wait;
    end process;
end architecture;