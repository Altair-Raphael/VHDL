# 1. Cria a biblioteca de trabalho 'work' (se não existir)
if {[file exists work]} {
    vdel -lib work -all
}
vlib work
vmap work work

# 2. Compila dependências da PARTE 1 (Necessárias para a Parte 2)
# Nota: Usamos caminho relativo. O script deve rodar da raiz do projeto.
vcom -2008 -work work src/part1/utils/fulladder.vhd
vcom -2008 -work work src/part1/P1-C6/ula1bit.vhd
vcom -2008 -work work src/part1/P1-C1/reg.vhd

# 3. Compila utilitários da PARTE 2
vcom -2008 -work work src/part2/polilegv8_pkg.vhd
vcom -2008 -work work src/part2/decoder5_32.vhd
vcom -2008 -work work src/part2/mux32_64.vhd

# 4. Compila os Blocos Principais da PARTE 2
vcom -2008 -work work src/part2/P2-B1/regfile.vhd
vcom -2008 -work work src/part2/P2-B2/ula.vhd

# 5. Compila os Testbenches
vcom -2008 -work work src/part2/P2-B1/tb_regfile.vhd
vcom -2008 -work work src/part2/P2-B2/tb_ula.vhd

# -----------------------------------------------------------
# COMO RODAR:
# No console do ModelSim digite: do simular_parte2.do
# -----------------------------------------------------------

echo "Compilação Concluída com Sucesso!"
echo "Para simular o Banco de Registradores, digite: vsim work.tb_regfile"
echo "Para simular a ULA, digite: vsim work.tb_ula"