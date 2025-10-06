<h1 align="center">
Zoom Digital: Redimensionamento de Imagens com FPGA em Verilog
</h1>

<p>
IMAGEM QUE REPRESENTE O PROJETO - ZOOM IN E ZOOM OUT
</p>

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
Kit de desenvolvimento
</h2>

![FPGA](Imagens/fpga.jpg)

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

![Aproximação](Imagens/Aproximação.gif)