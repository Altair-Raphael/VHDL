library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--TestBench is an empty entity
entity FullAdderTB is
end FullAdderTB;

architecture Behavioral of FullAdderTB is

    -- DUT Declaration
    component FullAdder
        Port ( a, b, cin : in STD_LOGIC;
               s, cout   : out STD_LOGIC);
    end component;

    signal t_a, t_b, t_cin : STD_LOGIC := '0';
    signal t_s, t_cout     : STD_LOGIC;

    type pattern_type is record
        a, b, cin : STD_LOGIC;
        s_esp, cout_esp : STD_LOGIC;
    end record;

    type pattern_array is array (natural range <>) of pattern_type;

    -- Test Cases
    constant patterns : pattern_array := (
        -- (a, b, cin,  s_esp, cout_esp)
        ('0', '0', '0',   '0',    '0'), -- 0+0+0 = 0
        ('0', '0', '1',   '1',    '0'), -- 0+0+1 = 1
        ('0', '1', '0',   '1',    '0'), -- 0+1+0 = 1
        ('0', '1', '1',   '0',    '1'), -- 0+1+1 = 2 (10 bin)
        ('1', '0', '0',   '1',    '0'), -- 1+0+0 = 1
        ('1', '0', '1',   '0',    '1'), -- 1+0+1 = 2 (10 bin)
        ('1', '1', '0',   '0',    '1'), -- 1+1+0 = 2 (10 bin)
        ('1', '1', '1',   '1',    '1')  -- 1+1+1 = 3 (11 bin)
    );

begin

    DUT: somador_completo port map (
        a => t_a,
        b => t_b,
        cin => t_cin,
        s => t_s,
        cout => t_cout
    );

    stim_proc: process
    begin
        for i in patterns'range loop
            
            t_a   <= patterns(i).a;
            t_b   <= patterns(i).b;
            t_cin <= patterns(i).cin;

            wait for 10 ns;

            assert t_s = patterns(i).s_esp
            report "Error in SUM at test: " & integer'image(i)
            severity error;

            assert t_cout = patterns(i).cout_esp
            report "Error in carry at test: " & integer'image(i)
            severity error;
            
        end loop;

        assert false report "Sucecs" severity note;
        wait;

    end process;

end Behavioral;