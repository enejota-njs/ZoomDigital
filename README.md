# Zoom Digital: Redimensionamento de Imagens com FPGA em Verilog

---

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

## 📦 Guia de Instalação e Uso do Quartus com Projeto do GitHub

### 1. Baixar e instalar o Quartus

1. Acesse o site oficial da Intel FPGA: [https://www.intel.com/content/www/us/en/software/programmable/quartus-prime/download.html](https://www.intel.com/content/www/us/en/software/programmable/quartus-prime/download.html)  
2. Escolha a versão **Quartus Prime Lite 23.1** (Lite é gratuita).  
3. Faça o download do instalador compatível com seu sistema operacional (Windows ou Linux).  
4. Execute o instalador e siga os passos:  
   - Aceite o contrato de licença.  
   - Escolha o caminho de instalação.  
   - Marque os pacotes que deseja instalar (Quartus, ModelSim, Programador USB-Blaster, etc.).  
6. Finalize a instalação e abra o **Quartus Prime**.

### 2. Baixar o projeto do GitHub

1. Acesse o repositório no GitHub.  
2. Clique no botão **Code → Download ZIP**.  
3. Salve o arquivo `.zip` em uma pasta de sua preferência.  
4. Extraia o conteúdo do arquivo `.zip` (clicar com o botão direito → Extrair aqui ou usar um descompactador).

### 3. Abrir o projeto no Quartus

1. Abra o Quartus Prime.  
2. Clique em **File → Open Project…**  
3. Navegue até a pasta descompactada do projeto.  
4. Selecione o arquivo de projeto do Quartus (`.qpf`) e clique em **Open**.  
5. Certifique-se de que todos os arquivos do projeto aparecem na **Project Navigator**.

### 4. Compilar o projeto

1. No Quartus, clique em **Processing → Start Compilation** (ou pressione **Ctrl+L**).  
2. Aguarde a compilação completa.  
3. Verifique se não há erros na **Mensagem de Compilação**.  

## 5. Programar a placa

1. Conecte sua placa DE1-SoC ao computador via cabo USB-Blaster.  
2. No Quartus, abra o **Programmer**: **Tools → Programmer**.  
3. Clique em **Hardware Setup** e selecione o seu **USB-Blaster**.  
4. Clique em **Add File** e selecione o arquivo `.sof` gerado na compilação.  
5. Certifique-se de que a opção **Program/Configure** esteja marcada.  
6. Clique em **Start** para enviar o projeto para a placa.  
7. Aguarde a mensagem de **Success**, indicando que a programação foi concluída.

---

## Kit de desenvolvimento

![FPGA](Imagens/Imagem%20da%20FPGA.jpg)

O Kit de Desenvolvimento **DE1-SoC** apresenta uma plataforma de hardware robusta construída em torno do FPGA Altera System-on-Chip (SoC), que combina os mais recentes núcleos embarcados **Cortex-A9 dual-core** com lógica programável de ponta, oferecendo máxima flexibilidade de projeto. Os usuários podem aproveitar a grande reconfigurabilidade junto a um sistema de processador de alto desempenho e baixo consumo de energia. O SoC da Altera integra um sistema de processador hard baseado em ARM (**HPS**), composto por processador, periféricos e interfaces de memória, ligados de forma transparente à estrutura FPGA por meio de um interconector de alta largura de banda. A placa de desenvolvimento DE1-SoC vem equipada com memória **DDR3** de alta velocidade, recursos de vídeo e áudio, conectividade **Ethernet**, entre outros, oferecendo diversas aplicações potenciais e inovadoras.

--- 

## 🛠 FPGA

- ⚡ **Dispositivo:** Altera Cyclone® V SE 5CSEMA5F31C6N  
- 💾 **Dispositivo de configuração serial:** Altera EPCS128  
- 🔌 **Programação:** USB-Blaster II onboard para programação; Modo JTAG (Também suporta RISC-V JTAG)  
- 🔘 **Botões:** 4 push-buttons  
- ⏱ **Fontes de clock:** Quatro clocks de 50 MHz do gerador de clock  
- 🎨 **VGA:** DAC VGA (DACs triplos de alta velocidade de 8 bits) com conector VGA-out  
- 🔧 **Elementos lógicos programáveis:** 85K  
- 🧠 **Memória embutida:** 4.450 Kbits

---

## Algoritmos

### Aproximação (Zoom in)

<p align="justify">
A aproximação digital, também conhecida como zoom in, é o processo de ampliação de uma imagem através do aumento do número de pixels <a href="https://www.tutorialspoint.com/dip/zooming_methods.htm" target="_blank">[1]</a>. Este processo é fundamental em sistemas de processamento digital de imagens, especialmente em aplicações que requerem análise detalhada de regiões específicas <a href="https://en.wikipedia.org/wiki/Digital_image_processing" target="_blank">[2]</a>. Os algoritmos de aproximação implementados neste projeto focam na eficiência computacional para execução em hardware FPGA, garantindo processamento em tempo real <a href="https://www.tutorialspoint.com/dip/zooming_methods.htm" target="_blank">[1]</a>.
</p>


---

### Vizinho Mais Próximo (Nearest Neighbor Interpolation)

![Vizinho Mais Próximo](Imagens/Vizinho%20Mais%20Próximo.gif)

A **Interpolação por Vizinho Mais Próximo** é o método mais simples e fundamental de ampliação de imagens digitais <a href="https://pt.wikipedia.org/wiki/Interpolação_por_vizinho_mais_próximo" target="_blank">[1]</a>. Esta técnica é amplamente utilizada em sistemas embarcados devido à sua **simplicidade computacional** e **velocidade de processamento** <a href="https://pt.wikipedia.org/wiki/Interpolação_por_vizinho_mais_próximo" target="_blank">[1]</a>.

---

## ⚙️ Como Funciona

1.  **Princípio Básico:**
    Para cada novo pixel na imagem ampliada, o algoritmo determina qual pixel da imagem original está mais próximo geometricamente <a href="https://kwojcicki.github.io/blog/NEAREST-NEIGHBOUR" target="_blank">[2]</a>.

2.  **Processo Passo a Passo:**
    * Calcula-se a posição correspondente na imagem original para cada pixel da nova imagem <a href="https://www.tutorialspoint.com/dip/zooming_methods.htm" target="_blank">[4]</a>
    * Encontra-se o pixel mais próximo através do **arredondamento das coordenadas** <a href="https://kwojcicki.github.io/blog/NEAREST-NEIGHBOUR" target="_blank">[2]</a>
    * O valor de intensidade do pixel mais próximo é **copiado diretamente** <a href="https://en.wikipedia.org/wiki/Nearest-neighbor_interpolation" target="_blank">[5]</a>

3.  **Cálculo das Coordenadas:**

    Para uma ampliação com fator de zoom **n**, as coordenadas são mapeadas por <a href="https://docs.ufpr.br/~centeno/m_pdi/pdf/jaulapdi05.pdf" target="_blank">[6]</a>:

$$x_{original} = \frac{x_{novo}}{n}, \quad y_{original} = \frac{y_{novo}}{n}$$

### 📌 Exemplo Prático

Se uma imagem tem 100x100 pixels e aplica-se um **fator de zoom** n = 2, a nova imagem terá:

👉 200x200 pixels.

Para um pixel na posição (150, 120) da imagem ampliada:
- Coordenada original: (75.0, 60.0)
- Vizinho mais próximo: (75, 60)
- Valor copiado: intensidade do pixel (75, 60)

### 🔬 Características do Algoritmo

| Aspecto | Detalhe |
| :---: | :--- |
| **⚡ Velocidade** | **Extremamente rápido:** Apenas operações de divisão e arredondamento <a href="https://www.giassa.net/?page_id=207" target="_blank">[7]</a> |
| **💾 Memória** | **Baixo consumo:** Não requer armazenamento de valores intermediários <a href="https://www.giassa.net/?page_id=207" target="_blank">[7]</a> |
| **🎯 Precisão** | **Preserva valores originais:** Nenhum pixel artificial é criado <a href="https://en.wikipedia.org/wiki/Nearest-neighbor_interpolation" target="_blank">[5]</a> |

---

## 🎯 Vantagens e Desvantagens

| Categoria | Detalhe |
| :---: | :--- |
| **🟢 Vantagem** | **Simplicidade Extrema:** Implementação direta, ideal para FPGA e sistemas de tempo real <a href="https://www.tutorialspoint.com/dip/zooming_methods.htm" target="_blank">[4]</a>. Preserva perfeitamente os valores de pixel originais <a href="https://en.wikipedia.org/wiki/Nearest-neighbor_interpolation" target="_blank">[5]</a>. |
| **🟢 Vantagem** | **Eficiência:** Requer apenas operações básicas de aritmética inteira, sem multiplicações complexas ou cálculos de média <a href="https://www.giassa.net/?page_id=207" target="_blank">[7]</a>. |
| **🔴 Desvantagem** | **Efeito Escada:** Produz bordas serrilhadas (*aliasing*) em linhas diagonais e curvas devido ao arredondamento discreto <a href="https://en.wikipedia.org/wiki/Nearest-neighbor_interpolation" target="_blank">[5]</a>. |
| **🔴 Desvantagem** | **Perda de Suavidade:** A imagem resultante pode parecer pixelizada, especialmente em ampliações grandes <a href="https://en.wikipedia.org/wiki/Nearest-neighbor_interpolation" target="_blank">[5]</a>. |

### 🧩 Aplicações Ideais

**Perfeito para:**
- Sistemas embarcados com recursos limitados <a href="https://dcm.ffclrp.usp.br/~murta/PIM/PIM_9_Interpol.pdf" target="_blank">[8]</a>
- Processamento de imagens em tempo real <a href="https://dcm.ffclrp.usp.br/~murta/PIM/PIM_9_Interpol.pdf" target="_blank">[8]</a>
- Ampliação de *pixel art* e gráficos de jogos retrô <a href="https://www.tutorialspoint.com/dip/zooming_methods.htm" target="_blank">[4]</a>
- Aplicações onde a **velocidade** é mais importante que a **qualidade visual** <a href="https://dcm.ffclrp.usp.br/~murta/PIM/PIM_9_Interpol.pdf" target="_blank">[8]</a>


---

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

---

<h3>
 Decimação / Amostragem (Nearest Neighbor for Zoom Out)
</h3>

![Decimação](Imagens/Decimação.gif)

TUDO SOBRE Decimação / Amostragem

---

<h3>
 Média de Blocos (Block Averaging / Downsampling with Averaging)
</h3>

![Média de Blocos](Imagens/Média%20de%20Blocos.gif)

TUDO SOBRE Média de Blocos

---

<h2>
 Caminho de Dados
</h2>

![Caminho de Dados](Imagens/Caminho%20de%20Dados.png)

🔗 [Ver em alta qualidade](https://viewer.diagrams.net/?tags=%7B%7D&lightbox=1&target=blank&highlight=000000&layers=1&nav=1&title=Caminho%20de%20Dados.drawio&dark=auto#Uhttps%3A%2F%2Fdrive.google.com%2Fuc%3Fid%3D16_pdd4TADHBSyZAoE4eO0e6Gq3GJ_Lt0%26export%3Ddownload)

## 🧠 Arquitetura do Sistema de Processamento de Imagens FPGA

Este projeto implementa uma arquitetura completa para **processamento digital de imagens em FPGA**, com suporte a múltiplos algoritmos e exibição em **VGA**.  
A coordenação geral é feita pelo módulo `control_unit`, que gerencia os sinais de controle, endereços e dados entre os módulos e as memórias.

---

### 🔷 Visão Geral

O sistema permite a execução dos seguintes algoritmos de forma independente:

- 🔁 **Pixel Replication** – Zoom in por duplicação de pixels.  
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
- Duplica cada pixel para gerar uma imagem ampliada.  
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

---

### 📦 COPY COUNTER

- Responsável pela **cópia inicial** da imagem da memória primária para a secundária.  
- Também restaura a imagem base antes de aplicar um novo algoritmo.

---

### 🔀 MUX – Multiplexadores

- Selecionam quais sinais (endereços, dados e enable de escrita) são enviados à **memória secundária**.  
- Alteram dinamicamente conforme o algoritmo ativo.

---

### 💾 Memórias

#### 📘 Primary Memory
- Armazena a **imagem original**.  
- Somente leitura durante o processamento.

#### 📙 Secondary Memory
- Armazena o **resultado processado**.  
- É constantemente sobrescrita pelos módulos ativos.

---

### 🖥️ Sistema VGA

#### 🎛️ VGA Controller
- Lê os pixels da **memória secundária**.  
- Gera sinais de cor (`R`, `G`, `B`) e endereços de leitura.  
- Suporta os modos 320×240 e 160×120.

#### 💡 VGA Output / Driver
- Converte os sinais em formato compatível com monitores VGA.  
- Gera `hsync`, `vsync`, `blank`, `sync` e `clk`.

---

### 🔄 Fluxo de Dados

1. O controle inicia a cópia da imagem base.  
2. Um algoritmo é ativado por um sinal de start.  
3. O módulo correspondente lê da **memória primária** e escreve na **memória secundária**.  
4. O controlador VGA exibe o resultado em tempo real.  
5. Se outro algoritmo for selecionado, o sistema restaura a imagem original antes de aplicar o novo processamento.

---

## 🧪 Testes e Resultados

### 🔁 Imagem original

![Imagem original](Imagens/Imagem%20Original.jpg)

---

### 🔁 Aplicação do algoritmo Pixel Replication

![GIF Pixel Replicação](Imagens/GIF%20Replicação%20de%20Pixel.gif)

---

### 🔻 Aplicação do algoritmo Pixel Decimation

![GIF Decimação](Imagens/GIF%20Decimação.gif)

---

### ⚖️ Aplicação do algoritmo Block Averaging

![GIF Média de Blocos](Imagens/GIF%20Média%20de%20Blocos.gif)

---

#### 🔲 Aplicação do algoritmo Nearest Neighbor Interpolation

![GIF Vizinho Mais Próximo](Imagens/GIF%20Vizinho%20Mais%20Próximo.gif)

---

<h2>
 Conclusão
</h2>

DESCREVER A CONCLUSÃO

---

<h2>
 Contribuidores
</h2>

[<img src="https://github.com/FelipeBastosz.png" width="80" height="80">](https://github.com/FelipeBastosz)   [<img src="https://github.com/limajonatas.png" width="80" height="80">](https://github.com/limajonatas)   [<img src="https://github.com/enejota-njs.png" width="80" height="80">](https://github.com/enejota-njs) 

---

## 📚 Referências

**[1]** **Digital Image Processing - Zooming Methods** - Tutorialspoint. Disponível em: <a href="https://www.tutorialspoint.com/dip/zooming_methods.htm" target="_blank">https://www.tutorialspoint.com/dip/zooming_methods.htm</a>

**[2]** **Digital image processing** - Wikipedia. Disponível em: <a href="https://en.wikipedia.org/wiki/Digital_image_processing" target="_blank">https://en.wikipedia.org/wiki/Digital_image_processing</a>

**[3]** **Interpolação por vizinho mais próximo** - Wikipedia. Disponível em: <a href="https://pt.wikipedia.org/wiki/Interpolação_por_vizinho_mais_próximo" target="_blank">https://pt.wikipedia.org/wiki/Interpolação_por_vizinho_mais_próximo</a>

**[4]** **Wojcicki, K.** (2020). *Nearest Neighbour Interpolation Theory*. Disponível em: <a href="https://kwojcicki.github.io/blog/NEAREST-NEIGHBOUR" target="_blank">https://kwojcicki.github.io/blog/NEAREST-NEIGHBOUR</a>

**[5]** **Digital Image Processing - Zooming Methods** - Tutorialspoint. Disponível em: <a href="https://www.tutorialspoint.com/dip/zooming_methods.htm" target="_blank">https://www.tutorialspoint.com/dip/zooming_methods.htm</a>

**[6]** **Nearest-neighbor interpolation** - Wikipedia. Disponível em: <a href="https://en.wikipedia.org/wiki/Nearest-neighbor_interpolation" target="_blank">https://en.wikipedia.org/wiki/Nearest-neighbor_interpolation</a>

**[7]** **Centeno, M.** *Processamento digital de imagens - Interpolação*. UFPR. Disponível em: <a href="https://docs.ufpr.br/~centeno/m_pdi/pdf/jaulapdi05.pdf" target="_blank">https://docs.ufpr.br/~centeno/m_pdi/pdf/jaulapdi05.pdf</a>

**[8]** **Nearest Neighbour Interpolation - Image Processing** - Giassa. Disponível em: <a href="https://www.giassa.net/?page_id=207" target="_blank">https://www.giassa.net/?page_id=207</a>


* **Conceitos de Zooming e Reamostragem:** [Tutorialspoint - Zooming Methods](https://www.tutorialspoint.com/dip/zooming_methods.htm)
