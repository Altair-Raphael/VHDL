# Processador PoliLEGv8 Monociclo

Este repositório contém a implementação completa do processador **PoliLEGv8** (baseado na arquitetura ARMv8/LEGv8), desenvolvida para a disciplina **PCS3225 - Sistemas Digitais II**.

O projeto foi estruturado em 3 etapas incrementais, culminando na versão Monociclo totalmente funcional.

##  Integrantes do Grupo
* **Altair Raphael Alcazar Perez** | **NUSP: 14555666**
* **Ana Luiza Vieira Custódio** | **NUSP: 13684508** [Número]


##  Organização do Projeto

###  Parte 1: Biblioteca de Componentes Básicos
Componentes fundamentais utilizados para construir o fluxo de dados.
* `reg`: Registrador genérico com carga paralela.
* `mux_n`: Multiplexador 2:1 genérico.
* `memoriaInstrucoes`: ROM que lê arquivos `.dat`.
* `memoriaDados`: RAM com escrita síncrona/leitura assíncrona.
* `adder_n`: Somador sem carry-in.
* `ularbit`: Bloco lógico de 1 bit (AND, OR, ADD, PASS B).
* `sign_extend`: Extensor de sinal configurável.
* `two_left_shifts`: Deslocador para cálculo de endereços (Branch).

### Parte 2: Blocos Principais
Componentes complexos construídos a partir da biblioteca da Parte 1.
* **Banco de Registradores (`regfile`):** * 32 registradores de 64 bits.
    * Leitura assíncrona dupla, escrita síncrona.
    * Proteção de hardware no registrador `XZR` (X31).
* **ULA de 64 bits (`ula`):**
    * Composta por 64 instâncias de `ularbit`.
    * Suporta flags: Zero (Z), Overflow (Ov), CarryOut (Co).
    * Operações: ADD, SUB, AND, OR, PASS B, NOR.

### Parte 3: Processador Integrado
Integração final dos módulos.
* **Fluxo de Dados (`fluxoDados`):** Conecta PC, Memórias, Banco de Registradores e ULA conforme diagrama monociclo.
* **Unidade de Controle (`unidadeControle`):** Lógica combinacional que decodifica o *Opcode* e gera sinais de controle (ALUOp, Branch, MemRead, etc.).
* **Top Level (`polilegv8`):** Entidade de topo contendo apenas Clock e Reset.

---

## 🚀 Como Simular (Testbench)

Para simular o processamento:

1. **Configuração da Memória:**
   Certifique-se de que os arquivos `memInstrPolilegv8.dat` e `memDadosInicialPolilegv8.dat` estão na pasta de execução do simulador ou referenciados corretamente no testbench.

2. **Compilação:**
   Compile todos os arquivos da pasta `src/` respeitando a ordem de dependência:
   `Utils` -> `Parte 1` -> `Parte 2` -> `Parte 3`.

3. **Execução:**
   Execute o testbench `tb/part3/tb_polilegv8.vhd`.
   
   *O programa de teste executa uma série de instruções (LDUR, ADD, SUB, ORR, AND, CBZ, STUR) para validar o conjunto de instruções.*

---

##  Estrutura de Entrega (.zip)

Para submissão final, os arquivos devem ser organizados conforme o roteiro:
* `P1-C1` a `P1-C8`: Componentes da Parte 1.
* `P2-B1` e `P2-B2`: RegFile e ULA.
* `P3`: Fluxo, Controle e Top Level.
* Relatório PDF consolidado.

---