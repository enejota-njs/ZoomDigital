<h1 align="center">
Zoom Digital: Redimensionamento de Imagens com FPGA em Verilog
</h1>

<p>
IMAGEM QUE REPRESENTE O PROJETO - ZOOM IN E ZOOM OUT
</p>

## 🧩 Descrição do Projeto

O projeto tem como objetivo criar um **módulo embarcado** para **redimensionar imagens em tempo real**, rodando **inteiramente em FPGA**.  
Ele funciona como um **co-processador gráfico** capaz de fazer **zoom (aproximação)** e **redução** direto no hardware, simulando uma interpolação visual simples.  

Todo o controle é feito pelos **botões e chaves da placa**, e a imagem processada aparece em um **monitor VGA**, sem depender de processadores externos — ou seja, o sistema é **totalmente autônomo**.  

---

## ⚙️ Especificações

- **🧠 Linguagem:** Verilog  
- **💻 Kit de desenvolvimento:** DE1-SoC  
- **🎨 Tipo de imagem:** Escala de cinza (8 bits por pixel)  
- **🔧 Operações implementadas:**
  - **Zoom In (Aproximação):**
    - Vizinho Mais Próximo (Nearest Neighbor)
    - Replicação de Pixel (Pixel Replication)
  - **Zoom Out (Redução):**
    - Decimação / Amostragem simples (Nearest Neighbor para Zoom Out)
    - Média de Blocos (Block Averaging)
- **🎛️ Controle:** Botões físicos da FPGA  
- **🖥️ Saída de vídeo:** VGA  
- **🔗 Compatibilidade:** Funciona como **coprocessador** para o processador **ARM (HPS)**  

---

## 🧰 Ambiente de Desenvolvimento

O código foi desenvolvido no **Quartus Prime**, que oferece tudo o que é preciso para criar e testar projetos em FPGA — desde a **edição e compilação** até a **síntese e simulação**.  

Esse ambiente também permite **configurar os pinos**, realizar **testes funcionais e temporais**, e validar o projeto antes da implementação na **placa DE1-SoC**.  

- **🧩 Software utilizado:** Quartus Prime  
- **📦 Versão:** 23.1  
- **🔍 Funcionalidades principais:**
  - Edição e compilação de projetos em Verilog  
  - Síntese para FPGA  
  - Configuração de pinos  
  - Simulação funcional e temporal  
  - Validação do projeto antes da implementação física  

---

## Guia de Instalação e Configuração

DESCREVER O GUIA DE INSTALAÇÃO E CONFIGURAÇÃO

---

## Kit de desenvolvimento

![FPGA](Imagens/Imagem%20da%20FPGA.jpg)

O Kit de Desenvolvimento **DE1-SoC** apresenta uma plataforma de hardware robusta construída em torno do FPGA Altera System-on-Chip (SoC), que combina os mais recentes núcleos embarcados **Cortex-A9 dual-core** com lógica programável de ponta, oferecendo máxima flexibilidade de projeto. Os usuários podem aproveitar a grande reconfigurabilidade junto a um sistema de processador de alto desempenho e baixo consumo de energia. O SoC da Altera integra um sistema de processador hard baseado em ARM (**HPS**), composto por processador, periféricos e interfaces de memória, ligados de forma transparente à estrutura FPGA por meio de um interconector de alta largura de banda. A placa de desenvolvimento DE1-SoC vem equipada com memória **DDR3** de alta velocidade, recursos de vídeo e áudio, conectividade **Ethernet**, entre outros, oferecendo diversas aplicações potenciais e inovadoras.

## 🛠 FPGA

- ⚡ **Dispositivo:** Altera Cyclone® V SE 5CSEMA5F31C6N  
- 💾 **Dispositivo de configuração serial:** Altera EPCS128  
- 🔌 **Programação:** USB-Blaster II onboard para programação; Modo JTAG (Também suporta RISC-V JTAG)  
- 🔘 **Botões:** 4 push-buttons  
- ⏱ **Fontes de clock:** Quatro clocks de 50 MHz do gerador de clock  
- 🎨 **VGA:** DAC VGA (DACs triplos de alta velocidade de 8 bits) com conector VGA-out  
- 🔧 **Elementos lógicos programáveis:** 85K  
- 🧠 **Memória embutida:** 4.450 Kbits

## Algoritmos

### Aproximação (Zoom in)

DESCREVER A FUNÇÃO DE APROXIMAÇÃO

### Vizinho Mais Próximo (Nearest Neighbor Interpolation)

![Vizinho Mais Próximo](Imagens/Vizinho%20Mais%20Próximo.gif)

TUDO SOBRE Vizinho Mais Próximo

### 🖼️ Replicação de Pixel (Pixel Replication)

![Replicação de Pixel](Imagens/Replicação%20de%20Pixel.gif)

A **Replicação de Pixel**, também conhecida como **Pixel Replication**, é uma das técnicas mais simples e clássicas de ampliação de imagens digitais. Apesar da sua simplicidade, é muito utilizada em contextos onde a **velocidade** é mais importante do que a **qualidade visual**.

#### ⚙️ Como Funciona

1.  **Princípio Básico:**
    O objetivo é aumentar o número total de *pixels* (ou *amostras*) da imagem original.

2.  **Processo Passo a Passo:**
    * Cada *pixel* da imagem original é **replicado** (copiado) várias vezes.
    * O número de cópias depende do **fator de zoom** (n)
    * O pixel mantém exatamente a **mesma cor** e **valor de intensidade**.

3.  **Cálculo do Novo Tamanho:**

    A nova dimensão é dada por:

$$\text{Nova Dimensão} = (\text{Linhas Originais} \times n, \ \text{Colunas Originais} \times n)$$

#### 📌 Exemplo Prático

Se uma imagem tem 100x100 pixels e aplica-se um **fator de zoom** n = 3, a nova imagem terá:

👉 300x300 pixels.

#### 🔬 Exemplo Visual

| Original | Após Zoom ($n=3$) |
| :---: | :---: |
| 🔲 | **Blocos Maiores:** Cada pixel é ampliado n vezes, criando um efeito visual "quadrado" e mais visível. |

#### 🎯 Vantagens e Desvantagens

| Categoria | Detalhe |
| :---: | :--- |
| **🟢 Vantagem** | **Extrema Simplicidade:** Implementação direta, sem cálculos complexos nem interpolação. Ideal para aplicações em tempo real ou dispositivos com baixo poder de processamento. |
| **🔴 Desvantagem** | **Perda de Qualidade:** A imagem resultante apresenta um aspeto **pixelizado** e **borrado** (*blurry*), especialmente visível em imagens fotográficas. |
| **🧩 Melhor Uso** | Muito usada em jogos retrô, *pixel art*, ou visualizações rápidas onde o estilo "quadrado" é desejado. |

---

<h3>
 Redução (Zoom Out)
</h3>

DESCREVER A FUNÇÃO DE REDUÇÃO

<h3>
 Decimação / Amostragem (Nearest Neighbor for Zoom Out)
</h3>

![Decimação](Imagens/Decimação.gif)

TUDO SOBRE Decimação / Amostragem

<h3>
 Média de Blocos (Block Averaging / Downsampling with Averaging)
</h3>

![Média de Blocos](Imagens/Média%20de%20Blocos.gif)

TUDO SOBRE Média de Blocos

<h2>
 Caminho de Dados
</h2>

![Caminho de Dados](Imagens/Caminho%20de%20Dados.png)

🔗 [Ver em alta qualidade](https://viewer.diagrams.net/?tags=%7B%7D&lightbox=1&target=blank&highlight=000000&layers=1&nav=1&title=Caminho%20de%20Dados.drawio&dark=auto#Uhttps%3A%2F%2Fdrive.google.com%2Fuc%3Fid%3D16_pdd4TADHBSyZAoE4eO0e6Gq3GJ_Lt0%26export%3Ddownload)

## 🧠 Arquitetura do Sistema de Processamento de Imagens FPGA

Este projeto implementa uma arquitetura completa para **processamento digital de imagens em FPGA**, com suporte a múltiplos algoritmos e exibição em **VGA**.  
A coordenação geral é feita pelo módulo `control_unit`, que gerencia os sinais de controle, endereços e dados entre os módulos e as memórias.

### 🔷 Visão Geral

O sistema permite a execução dos seguintes algoritmos de forma independente:

- 🔁 **Pixel Replication** – Zoom in por replicação de pixels.  
- 🔻 **Pixel Decimation** – Redução de resolução (zoom out).  
- ⚖️ **Block Averaging** – Suavização por média de blocos 2×2.  
- 🔲 **Nearest Neighbor Interpolation** – Interpolação por vizinho mais próximo.

Cada operação é iniciada por um sinal de **start** específico e processada com base nos dados da memória primária.

---

### 🧩 Estrutura do Sistema

#### 🕹️ CONTROL – Unidade de Controle Principal

- Gerencia todos os módulos de processamento.  
- Recebe os sinais `START REPL`, `START DEC`, `START AVG` e `START NN`.  
- Garante que apenas **um algoritmo** rode por vez.  
- Controla o fluxo de dados entre **memória primária**, **memória secundária** e **VGA**.  
- Define o **modo de exibição**:  
  - `320x240` (imagem original)  
  - `160x120` (imagem reduzida)

---

### ⚙️ Módulos de Processamento

#### 🔁 Pixel Replication
- Multiplica cada pixel para gerar uma imagem ampliada.  
- Cria novos endereços de escrita e dados replicados.  
- Utilizado para **zoom in**.

#### 🔻 Pixel Decimation
- Reduz a resolução da imagem descartando pixels em intervalos regulares.  
- Ideal para **zoom out**.

#### ⚖️ Block Averaging
- Calcula a média de blocos 2×2 de pixels.  
- Reduz ruídos e suaviza transições.  
- Usa dois módulos auxiliares:  
  - `address_counter_avg`: gera endereços de leitura.  
  - `block_average`: calcula a média de quatro valores.

#### 🔲 Nearest Neighbor Interpolation
- Redimensiona a imagem utilizando o método do **vizinho mais próximo**.  
- Mantém bordas nítidas e processamento rápido.

### 📦 COPY COUNTER

- Responsável pela **cópia inicial** da imagem da memória primária para a secundária.  
- Também restaura a imagem base antes de aplicar um novo algoritmo.

### 🔀 MUX – Multiplexadores

- Selecionam quais sinais (endereços e dados) são enviados à **memória secundária**.  
- Alteram dinamicamente conforme o algoritmo ativo.

### 💾 Memórias

#### 📘 Primary Memory
- Armazena a **imagem original**.  
- Somente leitura durante o processamento.

#### 📙 Secondary Memory
- Armazena o **resultado processado**.  
- É constantemente sobrescrita pelos módulos ativos.

### 🖥️ Sistema VGA

#### 🎛️ VGA Controller
- Lê os pixels da **memória secundária**.  
- Gera sinais de cor (`R`, `G`, `B`) e endereços de leitura.  
- Suporta os modos 320×240 e 160×120.

#### 💡 VGA Output / Driver
- Converte os sinais em formato compatível com monitores VGA.  
- Gera `hsync`, `vsync`, `blank`, `sync` e `clk`.

### 🔄 Fluxo de Dados

1. O controle inicia a cópia da imagem base.  
2. Um algoritmo é ativado por um sinal de start.  
3. O módulo correspondente lê da **memória primária** e escreve na **memória secundária**.  
4. O controlador VGA exibe o resultado em tempo real.  
5. Se outro algoritmo for selecionado, o sistema restaura a imagem original antes de aplicar o novo processamento.

---

<h2>
 Testes e Resultados
</h2>

DESCREVER OS TESTES E RESULTADOS COM IMAGENS QUE TIRAMOS

<h2>
 Conclusão
</h2>

DESCREVER A CONCLUSÃO

<h2>
 Contribuidores
</h2>

[<img src="https://github.com/FelipeBastosz.png" width="80" height="80">](https://github.com/FelipeBastosz)   [<img src="https://github.com/limajonatas.png" width="80" height="80">](https://github.com/limajonatas)   [<img src="https://github.com/enejota-njs.png" width="80" height="80">](https://github.com/enejota-njs) 

## 📚 Referências

* **Conceitos de Zooming e Reamostragem:** [Tutorialspoint - Zooming Methods](https://www.tutorialspoint.com/dip/zooming_methods.htm)
