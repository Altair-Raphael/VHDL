# Processador PoliLEGv8 (Single-Cycle)

Desenvolvido por:
 Altair Raphael Alcazar Perez
 Ana Luiza Vieria Custódio

Link Git para o repositório: https://github.com/Altair-Raphael/VHDL/

Este repositório contém a implementação em VHDL do processador **PoliLEGv8**, um subconjunto da arquitetura ARMv8 (AArch64), desenvolvido como parte da disciplina de Sistemas Digitais II.
O projeto consiste em um processador **Monociclo** (Single-Cycle), onde cada instrução é buscada, decodificada e executada em um único ciclo de clock.

## Visão Geral da Arquitetura

O design segue a arquitetura de Harvard, com memórias separadas para Instruções e Dados, otimizando a largura de banda de acesso à memória durante o ciclo único.

### Especificações Técnicas
* **ISA:** LEGv8 (Subset didático do ARMv8 de 64 bits).
* **Largura de Dados:** 64 bits.
* **Largura de Instrução:** 32 bits.
* **Registradores:** Banco de 32 registradores de uso geral (X0-X30) + XZR/SP.
* **Organização:** Monociclo (Caminho de dados crítico define o clock).

## Instruções Suportadas

O processador implementa as seguintes classes de instruções:

* **Aritméticas e Lógicas (R-Type):** `ADD`, `SUB`, `AND`, `ORR`.
* **Acesso à Memória (D-Type):** `LDUR` (Load), `STUR` (Store).
* **Imediatos (I-Type):** `ADDI`, `SUBI`.
* **Desvios (B-Type / CB-Type):** `CBZ`, `CBNZ`, `B` (Incondicional).
* **Extensões:** Suporte a `MOVZ` e `BR` (Branch to Register) para chamadas de função.

## Estrutura do Projeto

A organização foi pensada para garantir modularidade e facilidade de teste:

* `src/`: Contém todo o código VHDL sintetizável.
    * `components/`: Componentes básicos (Multiplexadores, Somadores).
    * `datapath/`: Blocos lógicos principais (ULA, Banco de Registradores).
* `tb/`: Testbenches para validação. Cada módulo possui um testbench unitário (`tb_*.vhd`).

## Escolhas de Design e Implementação

### 1. Modularidade
O projeto foi dividido em entidades independentes (Entity/Architecture) para facilitar a depuração. O `Top Level` apenas instancia e conecta esses módulos, evitando um arquivo monolítico complexo.

### 2. Banco de Registradores (Register File)
* Implementado com leitura assíncrona (para garantir estabilidade no monociclo) e escrita síncrona na borda de subida do clock.
* Proteção de hardware no registrador `X31` (`XZR`) para garantir que ele sempre leia zero e nunca seja sobrescrito.

### 3. Unidade de Controle
* A decodificação é feita puramente via lógica combinacional baseada no *Opcode* da instrução.
* Sinais de controle (`RegWrite`, `ALUOp`, `MemRead`, etc.) são gerados centralmente para coordenar o fluxo de dados.

## Como Executar / Simular

1.  Clone o repositório.
2.  Importe os arquivos da pasta `src/` e `tb/` no seu simulador (ModelSim, GHDL ou Vivado).
3.  Compile todos os arquivos.
4.  Execute a simulação do `tb_polilegv8_core` para ver o processador executando um programa completo.
