-- NOME                                NUSP            TURMA   -- 
-- Altair Raphael Alcazar Perez        14555666        Turma 1 --
-- Alvaro Primitz                      13687623        Turma 2 --
-- Ana Luiza Vieira Custodio           13684508        Turma 3 --
-- João Pedro Vakimoto                 14654718        Turma 2 --
-- José Rodrigues de Oliveira Santos   14583790        Turma 2 --
-- Lucas José Moura Ferreira           14747812        Turma 2 --

-- Arquivo: Fluxo de Dados

library ieee;
use ieee.numeric_bit.all;

entity fluxoDados is
    port (
        clock        : in bit;
        reset        : in bit;
        -- Sinais de Controle
        reg2loc      : in bit;
        uncondBranch : in bit;
        branch       : in bit;
        memRead      : in bit;
        memToReg     : in bit;
        aluOp        : in bit_vector(3 downto 0);
        memWrite     : in bit;
        aluSrc       : in bit;
        regWrite     : in bit;
        -- Saidas
        pc_out       : out bit_vector(63 downto 0);
        alu_result   : out bit_vector(63 downto 0);
        opcode       : out bit_vector(10 downto 0) -- ADICIONADO: O erro 1 sumirá aqui
    );
end entity fluxoDados;

architecture structural of fluxoDados is

    -- Componentes
    component reg is generic (dataSize: natural := 64); port (clock, reset, enable : in bit; d : in bit_vector; q : out bit_vector); end component;
    component adder_n is generic (dataSize: natural := 64); port (in0, in1 : in bit_vector; sum : out bit_vector; cout : out bit); end component;
    component mux_n is generic (dataSize: natural := 64); port (in0, in1 : in bit_vector; sel : in bit; dOut : out bit_vector); end component;
    
    -- Memoria Instrucoes (Compativel com codigo da Parte 1 atualizado)
    component memoriaInstrucoes is 
        generic (addressSize : natural := 8; dataSize : natural := 32; datFileName : string); 
        port (addr : in bit_vector; data : out bit_vector); 
    end component;
    
    component regfile is port (clock, reset, regWrite : in bit; rr1, rr2, wr : in bit_vector; d : in bit_vector; q1, q2 : out bit_vector); end component;
    
    -- Sign Extend: Verifique se o nome dos generics bate com o arquivo sign_extend.vhd abaixo
    component sign_extend is
        generic (idSize : natural := 32; odSize : natural := 64); -- Nomes padronizados
        port (i : in bit_vector; startBit, endBit : in bit_vector; o : out bit_vector);
    end component;
    
    component ula is port (alu_control : in bit_vector(3 downto 0); A, B : in bit_vector; F : out bit_vector; Z, Ov, Co : out bit); end component;
    
    -- Memoria Dados (Compativel com codigo da Parte 1 atualizado)
    component memoriaDados is 
        generic (addressSize : natural := 8; dataSize : natural := 64; datFileName : string); 
        port (clock, wr : in bit; addr, data_i : in bit_vector; data_o : out bit_vector); 
    end component;
    
    component two_left_shifts is generic (dataSize : natural := 64); port (input : in bit_vector; output : out bit_vector); end component;

    -- Sinais Internos
    signal s_pc_current, s_pc_next, s_pc_plus_4, s_pc_branch : bit_vector(63 downto 0);
    signal s_instruction : bit_vector(31 downto 0); 
    signal s_read_reg_1, s_read_reg_2, s_write_reg : bit_vector(4 downto 0);
    signal s_write_data, s_read_data_1, s_read_data_2 : bit_vector(63 downto 0);
    signal s_imm_extended, s_imm_shifted, s_alu_in_b, s_alu_result : bit_vector(63 downto 0);
    signal s_zero, s_pc_src : bit;
    signal s_mem_read_data : bit_vector(63 downto 0);
    constant C_FOUR : bit_vector(63 downto 0) := (2 => '1', others => '0');

begin
    -- 1. IF
    PC_REG: reg generic map (dataSize => 64) port map (clock, reset, '1', s_pc_next, s_pc_current);
    ADD_PC4: adder_n generic map (dataSize => 64) port map (s_pc_current, C_FOUR, s_pc_plus_4, open);
    
    -- Divide PC por 4 para alinhar com memoria de 32 bits
    MEM_INSTR: memoriaInstrucoes generic map (addressSize => 8, dataSize => 32, datFileName => "memInstrPolilegv8.dat") port map (s_pc_current(9 downto 2), s_instruction);

    -- 2. ID
    s_read_reg_1 <= s_instruction(9 downto 5);
    s_write_reg  <= s_instruction(4 downto 0);
    
    opcode <= s_instruction(31 downto 21); -- CONEXÃO DO OPCODE

    MUX_REG2LOC: mux_n generic map (dataSize => 5) port map (s_instruction(20 downto 16), s_instruction(4 downto 0), reg2loc, s_read_reg_2);
    REG_FILE: regfile port map (clock, reset, regWrite, s_read_reg_1, s_read_reg_2, s_write_reg, s_write_data, s_read_data_1, s_read_data_2);
    
    -- Ajuste dos Generics do Sign Extend para casar com o Erro 2
    SIGN_EXT: sign_extend 
        generic map (idSize => 32, odSize => 64) 
        port map (i => s_instruction, startBit => "10100", endBit => "01100", o => s_imm_extended);

    -- 3. EX
    SHIFT: two_left_shifts generic map (dataSize => 64) port map (s_imm_extended, s_imm_shifted);
    ADD_BRANCH: adder_n generic map (dataSize => 64) port map (s_pc_current, s_imm_shifted, s_pc_branch, open);
    MUX_ALU_SRC: mux_n generic map (dataSize => 64) port map (s_read_data_2, s_imm_extended, aluSrc, s_alu_in_b);
    ULA_MAIN: ula port map (aluOp, s_read_data_1, s_alu_in_b, s_alu_result, s_zero, open, open);

    -- 4. MEM (Divide end por 8)
    MEM_DADOS: memoriaDados generic map (addressSize => 8, dataSize => 64, datFileName => "memDadosInicialPolilegv8.dat") port map (clock, memWrite, s_alu_result(10 downto 3), s_read_data_2, s_mem_read_data);

    -- 5. WB
    MUX_MEMTOREG: mux_n generic map (dataSize => 64) port map (s_alu_result, s_mem_read_data, memToReg, s_write_data);

    s_pc_src <= (branch and s_zero) or uncondBranch;
    MUX_PC: mux_n generic map (dataSize => 64) port map (s_pc_plus_4, s_pc_branch, s_pc_src, s_pc_next);

    pc_out <= s_pc_current;
    alu_result <= s_alu_result;

end architecture structural;