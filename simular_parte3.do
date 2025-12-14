# ============================================================================
# Script Final - Teste da Parte 3 (PoliLEGv8) - CORRIGIDO
# ============================================================================

if {[file exists work]} {
    vdel -lib work -all
}
vlib work
vmap work work

echo ">>> 1 de 4: Compilando Parte 1 (Com Memorias Inteligentes)..."
# Compila utilitarios e componentes basicos
vcom -2008 -work work src/part1/utils/fulladder.vhd
vcom -2008 -work work src/part1/P1-C6/ula1bit.vhd
vcom -2008 -work work src/part1/P1-C1/reg.vhd
vcom -2008 -work work src/part1/P1-C5/adder_n.vhd
vcom -2008 -work work src/part1/P1-C2/mux_n.vhd
vcom -2008 -work work src/part1/P1-C7/sign_extend.vhd
vcom -2008 -work work src/part1/P1-C8/two_left_shifts.vhd

# Compila as memorias que sabem ler os arquivos de 8 bits
vcom -2008 -work work src/part1/P1-C3/memoriaInstrucoes.vhd
vcom -2008 -work work src/part1/P1-C4/memoriaDados.vhd

echo ">>> 2 de 4: Compilando Parte 2 (Banco de Registradores e ULA)..."
vcom -2008 -work work src/part2/polilegv8_pkg.vhd
vcom -2008 -work work src/part2/decoder5_32.vhd
vcom -2008 -work work src/part2/mux32_64.vhd
vcom -2008 -work work src/part2/P2-B1/regfile.vhd
vcom -2008 -work work src/part2/P2-B2/ula.vhd

echo ">>> 3 de 4: Compilando Parte 3 (Processador Completo)..."
# Copia os arquivos .DAT da pasta P3 para a raiz (Obrigatorio para simulação)
file copy -force src/part3/P3/memInstrPolilegv8.dat .
file copy -force src/part3/P3/memDadosInicialPolilegv8.dat .

# Compila o Fluxo, Controle e o Top-Level
vcom -2008 -work work src/part3/P3/fluxoDados.vhd
vcom -2008 -work work src/part3/P3/unidadeControle.vhd
vcom -2008 -work work src/part3/P3/polilegv8.vhd

echo ">>> 4 de 4: Compilando Testbench Final..."
vcom -2008 -work work src/part3/P3/tb_polilegv8.vhd

echo ""
echo "----------------------------------------------------------------"
echo "TUDO PRONTO!"
echo "Para iniciar a simulacao, digite o comando abaixo:"
echo "vsim work.tb_polilegv8"
echo "----------------------------------------------------------------"