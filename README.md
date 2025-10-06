<h1 align="center">
Zoom Digital: Redimensionamento de Imagens com FPGA em Verilog
</h1>

<p>
IMAGEM QUE REPRESENTE O PROJETO - ZOOM IN E ZOOM OUT
</p>

<h2>
 Índice
</h2>

DESCREVER O ÍNDICE AQUI

<h2>
 Descrição do projeto
</h2>

<p align="justify">
O projeto consiste no desenvolvimento de um módulo embarcado para redimensionamento de imagens em sistemas de vigilância e exibição em tempo real, implementado inteiramente em FPGA. O sistema atua como um co-processador gráfico capaz de realizar operações de zoom (ampliação) e downscale (redução) diretamente no hardware, simulando uma interpolação visual básica. Todo o controle do processamento é feito por meio de chaves e botões presentes na placa, enquanto a imagem resultante é exibida em um monitor por meio da interface VGA, garantindo funcionamento autônomo e independente de processadores externos.
</p>

<h2>
Especificações
</h2>

- **Linguagem de descrição de hardware:** Verilog
- **Kit de desenvolvimento:** DE1-SoC
- **Tipo de imagem:** Escala de cinza (8 bits por pixel)
- **Operações implementadas:**
  - **Aproximação (Zoom in):**
    - Vizinho Mais Próximo (Nearest Neighbor Interpolation)
    - Replicação de Pixel (Pixel Replication / Block Replication)
  - **Redução (Zoom out):**
    - Decimação / Amostragem (Nearest Neighbor for Zoom Out)
    - Média de Blocos (Block Averaging / Downsampling with Averaging)
- **Controle do sistema:** Botões da placa FPGA
- **Saída de vídeo:** Interface VGA
- **Compatibilidade:** Coprocessador compatível com o processador ARM (Hard Processor System HPS)

<h2>
Ambiente de desenvolvimento
</h2>

<p align="justify">
O desenvolvimento do código em Verilog para a FPGA foi realizado utilizando o software de desenvolvimento apropriado. Este software fornece um ambiente completo para edição, compilação, simulação e síntese de projetos em FPGA, permitindo a configuração dos pinos e integração com o hardware do kit DE1-SoC. Além disso, a ferramenta oferece suporte a testes funcionais e temporais.
</p>

- **Software utilizado:** Quartus Prime
- **Versão:** 23.1
- **Funcionalidades principais:**
  - Edição e compilação de projetos em Verilog
  - Síntese para FPGA
  - Configuração de pinos
  - Simulação funcional e temporal
  - Validação do projeto antes da implementação física na placa DE1-SoC

<h2>
 Guia de Instalação e Configuração
</h2>

DESCREVER O GUIA DE INSTALAÇÃO E CONFIGURAÇÃO

<h2>
Kit de desenvolvimento
</h2>

![FPGA](Imagens/Imagem%20da%20FPGA.jpg)

<p align="justify">
O Kit de Desenvolvimento DE1-SoC apresenta uma plataforma de hardware robusta construída em torno do FPGA Altera System-on-Chip (SoC), que combina os mais recentes núcleos embarcados Cortex-A9 dual-core com lógica programável de ponta, oferecendo máxima flexibilidade de projeto. Os usuários podem aproveitar a grande reconfigurabilidade junto a um sistema de processador de alto desempenho e baixo consumo de energia. O SoC da Altera integra um sistema de processador hard baseado em ARM (HPS), composto por processador, periféricos e interfaces de memória, ligados de forma transparente à estrutura FPGA por meio de um interconector de alta largura de banda. A placa de desenvolvimento DE1-SoC vem equipada com memória DDR3 de alta velocidade, recursos de vídeo e áudio, conectividade Ethernet, entre outros, oferecendo diversas aplicações potenciais e inovadoras.
</p> 

<h2>
 FPGA
</h2>

- **Dispositivo:** Altera Cyclone® V SE 5CSEMA5F31C6N  
- **Dispositivo de configuração serial:** Altera EPCS128  
- **Programação:** USB-Blaster II onboard para programação; Modo JTAG (Também suporta RISC-V JTAG)  
- **Botões:** 4 push-buttons    
- **Fontes de clock:** Quatro clocks de 50 MHz do gerador de clock   
- **VGA:** DAC VGA (DACs triplos de alta velocidade de 8 bits) com conector VGA-out  
- **Elementos lógicos programáveis:** 85K  
- **Memória embutida:** 4.450 Kbits  

<h2>
 Algoritmos
</h2>

<h3>
 Aproximação (Zoom in)
</h3>

DESCREVER A FUNÇÃO DE APROXIMAÇÃO

<h4>
 Vizinho Mais Próximo (Nearest Neighbor Interpolation)
</h4>

![Vizinho Mais Próximo](Imagens/Vizinho%20Mais%20Próximo.gif)

TUDO SOBRE Vizinho Mais Próximo

<h4>
 # 🖼️ Método de Zoom: Replicação de Pixel (Pixel Replication)
</h4>

![Replicação de Pixel](Imagens/Replicação%20de%20Pixel.gif)

A **Replicação de Pixel**, também conhecida como **Pixel Replication**, é uma das técnicas mais simples e clássicas de ampliação de imagens digitais. Apesar da sua simplicidade, é muito utilizada em contextos onde a **velocidade** é mais importante do que a **qualidade visual**.

---

## ⚙️ Como Funciona

1.  **Princípio Básico:**
    O objetivo é aumentar o número total de *pixels* (ou *amostras*) da imagem original.

2.  **Processo Passo a Passo:**
    * Cada *pixel* da imagem original é **replicado** (copiado) várias vezes.
    * O número de cópias depende do **fator de zoom** (n)
    * O pixel mantém exatamente a **mesma cor** e **valor de intensidade**.

3.  **Cálculo do Novo Tamanho:**

    A nova dimensão é dada por:

$$\text{Nova Dimensão} = (\text{Linhas Originais} \times n, \ \text{Colunas Originais} \times n)$$


### 📌 Exemplo Prático

Se uma imagem tem 100x100 pixels e aplica-se um **fator de zoom** n = 3, a nova imagem terá:

👉 300x300 pixels.

### 🔬 Exemplo Visual

| Original | Após Zoom ($n=3$) |
| :---: | :---: |
| 🔲 | **Blocos Maiores:** Cada pixel é ampliado n vezes, criando um efeito visual "quadrado" e mais visível. |

---

## 🎯 Vantagens e Desvantagens

| Categoria | Detalhe |
| :---: | :--- |
| **🟢 Vantagem** | **Extrema Simplicidade:** Implementação direta, sem cálculos complexos nem interpolação. Ideal para aplicações em tempo real ou dispositivos com baixo poder de processamento. |
| **🔴 Desvantagem** | **Perda de Qualidade:** A imagem resultante apresenta um aspeto **pixelizado** e **borrado** (*blurry*), especialmente visível em imagens fotográficas. |
| **🧩 Melhor Uso** | Muito usada em jogos retrô, *pixel art*, ou visualizações rápidas onde o estilo "quadrado" é desejado. |

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

🧠 Visão Geral do Sistema

O sistema implementa quatro algoritmos de processamento de imagem — replicação, decimação, média de blocos e interpolação por vizinho mais próximo — todos controlados por um módulo principal que gerencia a comunicação entre os módulos e a exibição VGA.

🔹 1. Controle Principal 

Atua como unidade de controle central.

Recebe sinais de início (START REPL, START DEC, START AVG, START NN) e ativa o módulo correspondente.

Gera os endereços e sinais de escrita/leitura das memórias.

Garante que apenas um algoritmo seja executado por vez.

Controla o modo de exibição (320x240 ou 160x120) e o fluxo entre memória primária e secundária.

🔹 2. Módulos de Processamento

Cada módulo realiza uma operação específica sobre os pixels lidos da memória primária.

📦 Pixel Replication

Replica cada pixel para aumentar a resolução da imagem.

Gera novos endereços e dados replicados.

Útil para zoom in.

🔻 Pixel Decimation

Reduz a resolução descartando pixels em intervalos regulares.

Ideal para “zoom out”.

🔢 Block Averaging

Calcula a média de blocos 2×2 pixels.

Suaviza a imagem e reduz ruído.

Usa dois módulos auxiliares:

address_counter_avg: gera endereços de leitura.

block_average: calcula a média dos quatro valores de entrada.

🔲 Nearest Neighbor Interpolation

Faz interpolação pelo método do vizinho mais próximo.

Redimensiona a imagem mantendo bordas nítidas.

🔹 3. Módulo COPY COUNTER

Responsável pela cópia inicial da imagem da memória primária para a secundária.

É usado também para restaurar a imagem original antes de aplicar um novo algoritmo.

🔹 4. Multiplexadores (MUX)

Selecionam quais sinais (endereços e dados) serão enviados à memória secundária.

Mudam dinamicamente conforme o algoritmo ativo.

🔹 5. Memórias
📘 Primary Memory

Armazena a imagem original.

Somente leitura durante o processamento.

📙 Secondary Memory

Armazena o resultado processado.

É constantemente sobrescrita conforme o algoritmo selecionado.

🔹 6. Sistema VGA
🧩 VGA Controller

Lê os pixels da memória secundária e gera os sinais de cor (R, G, B).

Controla a varredura da tela nos modos 320×240 e 160×120.

🖥️ VGA Output / Driver

Converte os dados em sinais compatíveis com o monitor VGA (hsync, vsync, blank, etc.).

Exibe a imagem processada em tempo real.

🔹 7. Fluxo de Dados

O controle inicia a cópia da imagem base.

Um dos algoritmos é ativado.

O módulo correspondente lê da memória primária e escreve na memória secundária.

O controlador VGA lê da secundária e exibe o resultado.

Se um novo algoritmo for selecionado, a imagem original é restaurada antes de aplicar o novo efeito.

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
