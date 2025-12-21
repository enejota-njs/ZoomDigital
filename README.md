<h1 align="center"> 
 Zoom Digital
</h1>

---

<details>
  <summary><h2>🧩 Descrição do Projeto</h2></summary>

O projeto é a continuação do desenvolvimento de um módulo embarcado para redimensionar imagens em tempo real na placa **DE1-SoC**. Enquanto a primeira etapa focou na implementação do coprocessador gráfico em Verilog (FPGA) e a segunda etapa na integração software-hardware através de uma API, esta terceira etapa desenvolve uma **interface de usuário completa e interativa**.

O objetivo é criar uma aplicação em C que permita ao usuário carregar imagens, selecionar regiões de interesse usando o **mouse** e aplicar operações de **zoom in/out** de forma dinâmica. A aplicação integra controle por mouse e teclado, permitindo seleção interativa de janelas retangulares para ampliação, com feedback em tempo real da posição do cursor e controle através das teclas **+** e **-**.

</details>

---

<details>
  <summary><h2>📝 Requisitos da 3ª Etapa</h2></summary>
 
- O código da aplicação deve ser escrito em **linguagem C**.  
- O **driver do processador (biblioteca)** deve ser ligado ao código da aplicação principal.
- Um **arquivo header** deve armazenar os protótipos dos métodos da API.
- A aplicação deve ter uma **interface texto** com as seguintes operações:
  - Carregar arquivo 
  - Selecionar **algoritmos de zoom**
- Usar o **mouse** para selecionar uma região da tela (janela) para ampliação:
  - A janela ampliada deve ser desenhada **sobre a imagem original**
  - A **posição (x, y) do mouse** será visualizada por meio de interface de texto
  - Dois **cantos opostos** da janela são definidos pressionando botões do mouse
- Operações de **zoom in** e **zoom out** na janela selecionada:
  - Tecla **+** para zoom in
  - Tecla **-** para zoom out
  - Limite de zoom out: **resolução da imagem original**
</details>

---

<details>
  <summary><h2>⚙️ Especificações</h2></summary>
  
- **🧠 Linguagem Principal:** C (aplicação com interface interativa)
- **📚 Driver/Biblioteca:** Assembly ARM (integrado à aplicação)
- **💻 Kit de desenvolvimento:** DE1-SoC (HPS ARM + FPGA)
- **🎨 Tipo de imagem:** PGM em escala de cinza (8 bits por pixel)
- **🔧 Operações controladas:**
  - **Zoom In (Aproximação):** Vizinho Mais Próximo e Replicação de Pixel
  - **Zoom Out (Redução):** Decimação e Média de Blocos
- **🎛️ Controle:** 
  - **Mouse:** Seleção de regiões/janelas
  - **Teclado:** Operações de zoom (+/-) e comandos
- **🖼️ Interface:** Texto (exibição de coordenadas e menu)
- **🖥️ Saída de vídeo:** VGA (controlada pelo módulo FPGA)
- **🔗 Comunicação:** Mapeamento de memória (`/dev/mem`) entre HPS e FPGA
- **🛠️ Ferramentas de desenvolvimento:** 
  - Quartus Prime II versão 23.1  
  - Platform Designer (módulos PIO)
  - GCC ARM (compilação da aplicação C)
</details>

---

<details>
  <summary><h2>⚙️ Mudanças no Hardware (FPGA)</h2></summary>
  
Para suportar a interface interativa com mouse e a seleção de janelas de zoom, o hardware do coprocessador gráfico implementado na FPGA sofreu as seguintes modificações em relação à Fase 2 do projeto:

- **Instrução de Load:** Implementação de instrução para leitura de valores da memória, permitindo consulta de pixels específicos.
- **PIO de Entrada para Leitura:** Criação de registrador mapeado para receber valores lidos da memória pelo HPS.
- **Terceira Memória:** Adição de memória adicional para separação entre memória de trabalho (processamento) e memória do VGA (exibição), permitindo operações simultâneas de processamento e renderização.
- **Suporte a Operações de Janela:** Ajustes no módulo Decoder e na máquina de estados para processar regiões específicas da imagem (janelas selecionadas pelo mouse).
- **Otimização do Fluxo de Dados:** Revisão da lógica de controle para gerenciar múltiplas memórias e operações de zoom em janelas sobrepostas à imagem original.

</details>

---

<details>
  <summary><h2>📜 Caminho de Dados</h2></summary>
  
O caminho de dados contendo apenas as modificações realizadas pode ser visualizado na imagem abaixo.  

As alterações incluem:
- **Instrução de Load:** Capacidade de leitura de valores específicos da memória
- **PIO de Entrada:** Registrador para receber dados lidos da memória
- **Terceira Memória:** Separação entre memória de trabalho e memória VGA
- **Gerenciamento de Janelas:** Suporte para processamento de regiões selecionadas
- **Fluxo de Múltiplas Memórias:** Ajuste na lógica para operações simultâneas

🔗 [Ver diagrama completo](https://viewer.diagrams.net/?tags=%7B%7D&lightbox=1&highlight=0000ff&layers=1&nav=1&title=Datapath%203&dark=auto#R%3Cmxfile%3E%3Cdiagram%20name%3D%22P%C3%A1gina-1%22%20id%3D%22gjH22BMqtbLyWabGkIET%22%3E7V1bd9o60%2F41rPW%2BF7AsybLsS5KQlLUTyCZp07w3XSShSXYTyEfo7uHXfzbYYI%2Fkg2TJB0ou2mAsQ2aeGc1ZHXL8%2BvNsOX17ulg8zF462Hr42SEnHYxtgqj%2FX3DlV3jF8uzNlcfl88PmGtpduHr%2BPQsvWuHV788Ps%2FfEjavF4mX1%2FJa8eL%2BYz2f3q8S16XK5%2BJG87eviJfmpb9PHGXfh6n76wl%2B9eX5YPW2uupjtrn%2BYPT8%2BRZ%2BMHG%2Fzzt30%2FtvjcvF9Hn5eB5PT9c%2Fm7ddp9KzwD31%2Fmj4sfiQuTR%2Bmb6vnf2fHi5fFMvw75ov5LHiXDDrkeLlYrDa%2Fvf48nr0EpI%2BIunnEacq7279qOZuviiw4vaPO%2B4fPV%2Bhx8Dd6sPrnt6ujLuWfEj74ffUrIuCaBLPgMVaHHP14el7Nrt6m98G7P3zM%2BNeeVq8v%2Fivk%2F7pZ%2Fe%2F05fssotr6wmy5mv2MfUL4Jc9mi9fZavnLv%2BUpxgSMaEjBHzuWYc8NL4YP6tosvBBis4uIFVE%2BpPbj9gN2tPF%2FCckjJtWT88t5eb60j53p68OrjRf%2FXA66KPxLZg8c3HjiLb4v72cZD7M5IgePvQpfLparp8XjYj59GeyuHiXZsLvnfLF4C4n%2Fz2y1%2BhVK4PT7apFkjf8tl78%2Bh%2BvXL26DFz1Mo9cnP%2BPvnvwKX72vlotvW%2BHZPCoSdLK%2B%2Fefzav3gnu2w8HXw7K7VsywUXtg9PHjxK%2FbicrZ89pk0W4bXQiUxXT7OVhlE3DCfB9Jy9jINhC6pSQR4WC%2FtL5fTX7Eb3hbP89V77MmXwYUd6BxCkpjDHgXg2jxSvNxXi1YPcY%2Bwesy1tj84%2BZ03lAgfBGC8%2FbvVkY3d1iN7i78NlkP45SAPYHgrHT1CcVJCAo5ki8j6lSKOsVMHjqlLEyDEDtg%2FwP3EsUrdT1je%2FShxP7UT9%2BeIFfGSn%2BZgsA8YliGP7I8MsbgMWTIyVIs%2B9pI47lJHBjjIQUy8viro2NptsM1%2BvbY516vJZlfx3%2Fn6%2FPISux6as0KrzXnxv8zRw%2FO%2F%2Fq%2BPq%2FU9m0vvb9N54ss5%2F%2Fc9MGKP7jcP7gcsf7z7j09FnyBW9N9%2FN48I740eejn8PDj3X0xfg79hfvf%2BFvskn5ybD0t%2BAf%2By4GuZ%2FqaTweX58Lh%2FPRyPJL%2Bfiv1rCcxfnLR%2BKQHGLzNl%2BkYOnxbl5rRIuYnt5TxzWaAUC1gBLiupPUux2PmTldBo0J8Mrq79G0aD4dmHo%2FGkkRroNPhe1v%2FG4wv%2Fv%2FHHa%2FNqCKF8NeQiYBca00JUoxZirddCuV67ohry6lRDLJ2jBzXUEDU0HF0PJpfj8waZQsjyqrKFCNKohdx6tZCWYIm7ifhFiikI%2BSE7VzW1LVqCbJx0M6mVHc6gDsu6P8crpSCw7TBWqU%2FqOfuDcsff0mKbbc8iNAfqWsz%2BEoFttx6IU4yTStSxMyLbuqDm%2Fslb%2FtH5%2BPivRu7y%2FU%2BDSf9sODprhpeBCKvIzUA6I7n1BDtSFJhN81WYYF9W8yPqSc65IOnQxVRm28WWy3oM7xJxME9nuz0v9rZV7a6MZOJwjYAcw2jfIYcQ9D2QhyQwx6%2BHvstGy3CoEqHX6SGP%2BzI924lB1q4WsjqDNk1yl9SCNi5Tco1aJQ%2FQU%2FIx4ErpYM%2FrRf7H7hFOz4nrZVopim2mEcW4ZqOgZ3moU8qzKeG9bzyKynPEwCxwSLbzDu%2BnLMOK0FaG47Xe8NQbWaIJlOZgtCD%2B6okeuU5SJZIc%2FNnYyro%2FrxbGTWrPqoNHUV56HxI1UkDeItdhCQ27jolWaAjXFCJFdhLlNspBuetm3W9Gy1KZyGY9O%2FSuana3RSOUX4GobZOuy3AEEZ4c%2BMD7uwRLFeLCgBJSdruY24sHBUDQgNCAn7Efp1ptjIvgu1yN%2F%2FH48ta%2Fcjz%2BGOQGO6aCgBgixFiST2cMMGJA1dqkSrOK1GLWQxHO23By7s9TGLDE2AV%2Fj2knNNwtwz6p6V2EJquIgAeNTG%2Bc4KqJqseL6rbaO7J4KfCgoMeuTVYF6i2TfKpKLy13lJ5tElDbRAXtZHjRnwTq92JwMQ5%2BScnX6OI0TXIabpvaGGsLmtOKctb%2FI1dJ9k1fnh%2Fn%2Fu%2F3%2FrMCe%2BgoIMXz%2FfSlH77x%2BvzwsFa9IhwkkSJibKKAeXLypX9yMhlcXSmRnfBUR1VV2VFBPrahVP9bF3GB7iIghu5qoLWw%2B9IRWBXqtBZRMKmc1p2nSU0WXirOpxyenPSv%2B4bY4lTDFCbYTlvOlJuJbnUEJQYneIOiXln9zNk%2FibmZDEaG2JIMr2zDM%2Fp36lBf1m%2BZujxNbCtJFAxiq1GfYSmy%2FJ5b6J%2Ffv58%2BjD7%2BuD1nt%2FP566cutouTJZOuNRBLv5ku6DDJpJrQTk%2BT2qzgxMXHzy2gDxFYu0XpU7Hd5W8kg6BKPdhTOuWiPoIpD25F7gUR9Bo0lOCQ0FbQi2hoz0BWUj2ao7%2FA0Wgo%2FScnO7SfDI5NUZ5VRXmvlZQfmTKTYFjZXERDsPE3lPAXg4u1nunHGND%2FdKaLAyzJAYKq4gBpDQcEhd5xadiG%2FbSVYds8m7xsNhlrsqIyTVZ1lVGxRCIlP72vksm3xWyTS6twmQyPJT3DrYTmpD615eDxgb27Kq3K8%2BxwcATOqUbyGM26P6%2B%2BOe3jKkObzukVuG5U4kS3JepZlisHTXGdUVjwFFU4xepCU%2BudCmLcbQTGHTnMYrCcFazJ14VZpwWdHj2HOHIqUl9lu5FtkeN61ZrKKTSFpWI7dDgKvF7VtE6%2BUelQaPubsiqdQtMlKiZvOADLJIU9UhmFCzXz7gGFYZAS9nAZJLEgeFM7ibXrCASSNsh2qyIwww0k8M0k9PzN5XAdEPjtOqbShUwQhPkTKOxC88IYhAuNlNw%2FAiME27%2FNYbjQ5PSKSbyeCaebxiBUi%2BCkXWModkM1UXtVwfYT44lgaAFQ0MzS3dZJ6sde0fqBiIK1p9KFFAR1pNDX0kcugVdVlFx1ZNbXtVpfymTVRfWjMONSUcKFCczVhhI%2FTKzcTIbXg47eHDt0D3SUHImpWEI11GUPdNST6iLPAWTRddSJiilYtBSxWaTWl0WHPhpUKeZALvDQGkr5nUXWUc%2BfC%2F1jmqQ97iVzNEhHblacGW%2BZitmEJayrwfF4dLLOmOuBP8yNAxXvGUO%2FRFVpA81iB56uoI8wRfuF3KZUmNZqFruFzeLaS2E2WjQUZI1VSAhXRWtB5qGhtI7rTI21jtv%2BNbGxYM5WKNrOVj%2FlNyiPshUTRe%2BjVpO4sLNXO7HjMN8Dk9grbJTVTvkI4KeT9TkW2zpGTVhP2T6Nm8WosDtYOwfi7mDlZrGpgLzXgpLRTnzwhqFjhDb0rrzeyoKjWXJqCrkF27NcC1ZopX1gVbU6XhOLSSrtzMKgcMeYx%2Bs1sapkW4uvmmoTEBjoTmrr153ivauB9BU0oBhBMSKufhiLA2cNpHIFKEawo9AYjJtYVlIBgV1cEX2bWPIQ8%2BP0OBCgpMQDMy11JEqFxG1i6e%2FF4GQYOMjryIQe8sJqEpsrnDRE3yaaa6bB64Cxw9uqJe3UbaKFZpq6XLuAOfKGcTU9hyhQjjHVto1IzZ9Uc4KJmL%2BGp1Ei0CfXpVmHzyg4omLj3dIIjkg973OEpCw4yjkBTSlqRJGZmDHaMRhqnET0tu5Av3EpkdbOpGwN5NI%2FoaPg30yzMtlWfia7qTNNY1FpE1NNXUO8FONSoI6LMnMPSvRhNEBHjl1MZ0F8paF01mmUgiCssfyWXXRcVv3kLR1zsXn9ADO7mMKZCKboXnRMVv10V5zHyxMbBAmwB45S9kypEEU%2FS%2FywWk%2BrSw5ywEVPPO5ZyEva4JiY6esXR3BT8FKysX93hjw4z8vA6H7x34X3FFhM7ShtVtqzMwOfcppa0RHP%2BFNqc8TLHRBYkF247GiYcuxqsifOjSi0QJycGguUUwm6ZBLWUNW5lUGtXZjCEHFIYWcuq%2FWygGfOEevTWeBB%2B27x9WR8fq56yFIW1ExnYAoPfBXQrmJLdjT4HJTRqFX1C7wHQGJjPnDhya6NIbFi3WEuiZGO84bE6q1wnKF2Gh%2BPz8dqiiKfwMbKZOyig%2BLrp298HutaP%2BsJ6cA8Y3RMjGkFbbdHe6hH0HKjDebKZ8LPaYXBieA4IHMGJy5sF%2FDJSR021fjj9aVigUsmJfXv7oXTQjyh2mRAZWw%2Bu8RkApzmDKrCUe%2BmkFyxk0aa5EjH3B%2FxNlTYx6qd5qGBZQ0VO8hyNyM4OERH697o%2B8vL7zP3yxW%2B%2Fm5Pry7O2cuikSXg%2Fr5gHQ2vFXM4%2BXYVAbkzR8dMQSF1BS7DvlOXwdIRqsNjEFK3iXXfpagrqPmGRipo6e06OlpLhdRt4ixB05qBCyhqOSROSN4mFtUbBi%2BiCKLX2L7WxLJ6xDTTF8LXBh0hXWRM9zaxrL4cfR2evty0ZxCR6WJiG6JvEwvrtdMX6Ad4dnxXS7BRSF5BxKvl5M1XDw4GZeqEaCheEnsVhUJbe0ZfDA8z01GTJyZvE40H0%2BSlYHPDOip3xeT9E40HF%2Fht5nQv2j%2FboYBtZoF2c2JOO%2Byf7VCAvgS4braOcLyYvn%2Bi8cDA5kZ15NnFMbM%2F0naAdV5d6ppyLYL1zSOwVYbAghPboe%2FmmchriunbSPNBN31hf48HzDPHHH2baD%2BUCp0VgS%2FoOafGtjfSRP1birxePnpdGPg1Zp1FlaSy8%2BrmD%2F3lcvHDfzVfzGdJ0ueeKF10gxJWYAuazvTNj3M9MCfaBRTOHAaXsjpvFhz%2FIM8CD0LgSfoaRcSooAdUxKwhhOBEhbBQoRgu0tdLIwMjGDWjFDzKNDTcAzQSGyFoCgyPzC2oMdKWK6gMGzyJgieZxoVM0%2BIfgAsw88hBRAoXKcsVcAGmwTgWeJJhXEi1o%2F0JuAB%2BiYPlcCFeroIL8CQKnmQaF%2FiAixg7aFRuCCtpCgIjdb08MiiFj4J%2FrmlokAM0YvzA0QlGW5PPYjLQSF0vDw3swUch8CjT0LAP0IjxgxuMFdWOFp1enrZeHhoWV0wFI26moXHwWWP8YBhKKpVxWVOXSwODEfgkeBiyaVw4B1zE5NQGfmIXUSkLNHW9vMqwKXwUtGZNQ4MdoBHjx7aNbBd1lDI0UtcrGBoWfJRXsaFxCHPF%2BOG6wCXAUgHQ1OXSwHA9%2BKSKw5%2F2IcwVY8fWM4QlssVwkbpcGhcOTJgRaMgaxkX0lxxwEbyPiZNgB0ZS%2BZKU1fLZEhs8CI4NNg2KQ3I1xg0KzrDwhVYCFGmrpUFB4chMCh5kGhT4AIrYho6TPgAhUoZFymp5uwLk4QiuWFMcQp4JT8JKssOW2j9Sl8v7IQiBJ1W9gxzinXF2EBckuS2ZLSR1uTwuCJgFbHsVbyKHYGeCHSxp6DlSu0jqcgVcuOBJVe8jh2BnIvacNPUokynOSVstHwIHpitX5GMYFI5MmDM2EViMMMajp7qxz1bPc91OfPQzQaRTcKi47IlPQCT8K6fPAeXX74MzSx6mM%2FfrfUdwZolz787uvm7fuQnxHk2shhPLN9TNPT1oc3YIL3dmz5ZyuSSfRTKhzy1geQcyuzbJXNEpe3qVWERkwnrNFhHUs6zkdHTXjITweJaXiTwpKyEhm%2FqmqiWEMhCgplY24B14ALn0AjtnAS9SdlaVgC6RYjIR0WaLlC8Y1IuJFCooTx3Z6fWZsqBF3tTladNHVrU8YXh2aDTGICN1WG6BU8V%2BQws1je0AjFL6lLLGinawz77gpvnde%2FBfOLQ9vE9yWJVgXIoXKaLwMV1uXJWrY57S6R113j98vkKPg7%2FRg9U%2Fv10dqc5TEpEwKSyh5MUlK7xUvKEsqXeSYpviQm1Olfu6WAOTP7wueKP7vlZTwahYx3r72REdWHd6GYyS3R5Rt3leiSPqBAepgU7hLpxe2EVaJmGIub5HjkzCQit6MFLXioy73bbiEid3Y1kpnIwk3gTq2AO6cJhClzmJ%2BE6BFdjO2QXK3c%2Fc7NuZV%2B5%2Bx5OJXHRt1KOMedsfeCKw7fqY82LvJzmWEthQ2PyEYswUg5ctPgFYSAe3JmniRqK62U48vyJS%2Bmkr4PQI6ftzpM8uu4DJxId5wyaiWGUSs68bH%2FO39MydT%2BCvKAqbXYuwYRdCB7NMpPIrSJ4DA%2Fcu%2BQVO3mYHjTzpFXIC5%2B9f2PWs6AfD%2FmmGnR6zdj%2BqzZFWNNUm%2BpbGsnhisZYpMm2TWLvENhMiUVEH4vh5PdoAzsuO8sbp2gCuIDmWIxf%2FkF%2BQpz4IKbtCszagtE5rdn9SBzv3civJ1FU7WlVFkpOREqQs26Qmu5rvgEPZws2tyDNjOdNA7n69YucQ3POKTbjRJWtR9f8eyFpyw6QBrBTEDFe3Y9ZjPxO4Ozk5kOdX4LxYS9n7ZVoeurbv9CBrt1e5UKos3HOwrGmrTcBkQjNtEjCbOkoCZltq0dW2ix008ZwcE49fgXNWcBFaufuTe2tZqaMMKziUuqQuSqS1IZ21%2BVqx5NXVdX9y%2FeXofHz815f%2Bp8GkfzYcnYV3ac82IRcMxqMIp2O%2FVLJJdP5ba5gSJQEfnv%2BNEoAbPo1GX4aj68Hkcnzevx6OR7FsYexec%2BwDHd%2FbsTX62Yf3lH3%2FG48vvoyDk0Kr5By2MOCcw0xxTvEgtUZwbsOmyeDyfHgcCpgphkBNCH0xfQxRPN%2BjEQwZn55eDa6%2FKB4BW4APsBzPgYMX9fGhRVUvaXy4rY4POibWi%2FmgOPG7EXwIjiz%2FMrzonw2McQJO%2FGHIGCcUzxZpBCeircIXC2OswGCTcLBjihWKx5A0ghU3k8HItFDAEiZGDXGCttmb7J%2Bc%2BBJxZZgZMETI4DwafSWLodm8dwE1EhXEp8XTEsGutLrz6gNb0ExgVl6SBq7AObUP3FAbufvzOqQcWMokeX9mfbt8KSElXs%2BJJV8VjzyAJ15E37KqUgxn%2F04pyz9guktQsl25y2Brqj5FeBiclajrgIPMGPZkxDJ1vbTkdTGczsYIeJTpMqj92SMFFRSBjBUv7ifJ9BOzPIPpp%2Bp3X7g3MpJXyM%2FtpjmlxFwaSu5%2BRrNroRmYsy57v9y8%2F9waDIr87ZnEtl%2FFgSYu9Xdxh8t%2F7b50z7ZSP8S0ejjMRkqqaxBecTyZKa3p6xV2DgYjPXCyvGlo2EWQ0KbD4QoZbZwSNdVwx2TGyTR0Z9bT0pOxwQfhTdkehg0lcos%2Famm57nLtODQ5IrzAivz%2BgNILcvZ1xhVOSy6QLZaEShXIpOESErfQntjQoN86Eq6kLvODfTAvpOOg0oxuvgMHOA5QUhUHWl84YIgDrmVXxAFFe2zvOYDggermWNDmYg2jLCBO0luhnikW7EGdhql6GcQZcvCcOn1saHOZhuFyGZ8NwGCFp3XpY0ObazQMSwOFuUU4eFYfF9pcnmFYGLizM00xwVM0UPcrXBW1khigb2h%2BHiLFm6gM11smNRY7fb1KpBg%2BClbcGI4Ue4fB2NlJAEcSGinrNSQRHFgZZxoainbifmllBg%2FM0qaVUdQ60uB5X6LBehhjpdy7UpsnE3PVbKSfT67n5Mq5WY8oL2oPYSa%2FAmdPSOEiK2BBjiZLI4G0HrMp6sVS5J4H%2Fm7L68Xf9QAvDes4ZCkm0WuWQcLy83Qtl0Gu%2BsrLxJkH4S55v8w2D78b8iGueqIrwslnUZ%2FZHi8v%2BuXh8uPqr%2BvZYnRKX5%2B%2FLU9WfXax6iLFQSLTq9Goa63%2B%2FT3%2BdvNqu7efji%2Fftk57bcPJY%2BnooqPJY5NDbhNyVSgbrkNQBJVYbm97Xs5Wbxo8Rl6MDBljJYaMFLXr1AsNgtxOvFYhqM8uCJCgJyKGkLV2zjWIhHWHxRS0djzZnt2zPWZvNYwAWj3bNoWubEAUHfxupbgP2YPfFXwGJIiTEQsDt8GGVRXINeg3tCiAX%2BWU9w%2BXVzqHvEf99lneIjggrYsYdXqmwqQIKeYwjXrkwVQ5dZdccH4CSxKZ88iRBX0RjRQ%2BhMMSlgcYS%2BK5UmZy2nJpK5kg%2BCTPWCyM9E%2B7qD%2F%2BTO6uv%2F32%2Bt%2B%2BnNxcdKNObZPnkpwMjscng4mSGEXkiKFhC4eo4AtuUa6ODLOYWm2utRiOrq4nH48NzijhqkINcqLNJReDUf%2Fo3FSzsw1HALg6Ri4JXSfFPaVKfwgr%2BcplXeVk7ClDlej3qRHqcS61BYvP9NUmC3Ehc3hBTbhgjcVFLS0AdpRJ32EmJ25vUzd7RY4NZXukB3PEJoEqDOTZzUVqCuhQWdCJ6ZBirJcNyFi4R0nsB7AbQ%2FPAsF5SdYIaq5iSHUuKesoM6z1nnctJMpwUbJLJP%2F%2BHx47pMHFzz7BSM3aaix1xXkAZO3ycpWrsEMVerXaHtyxoUhCkIYAoJjBWE859jW5B2QET7nPDW2nrFWSPexQUY9OydxgmEN9HYYUnwuGZVAWt9tT1Cls6jzLwKNPQaOIwAdNq2YYD1X21rGEElNCtCIl5v5jPZ%2Fer6V1EUqsI3R99Qr0JZUs%2B1SmIIhMYRbZAnxKCikobWXBxsmSRtQZaaSeFoD8ii2SqGfN4MLeDyen6h4v8%2Bu9shuFkJXPf36bzxDeJkrX3m6cEidzl491%2FfIr5JLGi%2F%2F4rTOxeDybXw%2F7k1r%2FjYnAxDn7Zpnk3H1QizbsFcCWcFOjSgpysWMHeTPzX4dRRJboKQvAe0CU0afpGBe%2FaiS5IRzWT6MEQaiViCyrb4fhMU4gWZJiaSdzJSUlE27zK33btRpCOCiij3dGYIhHUADWT7H%2BraQ%2Be1sBCQ6BHFFENbrOQhIqn0f6eW%2Bif37%2BfPow%2B%2Frg9Z7fz%2Beun7VkFVYfJzZcVcidREegN6%2FNThGySGaSaV7pc80guEF001nIjhqhnBh8I4IOaq2AW%2BwNNDC%2F6puv0Nbhvfvce%2FFeqv83lrQAX7k95QqrPq8US8rj3ESWf8MnOJxvLTKdMXS4dT8KIgSchY7MpxbhoYrM%2FFMNOEGVIXio3dLyAaGIn6Q7Z0dEh%2BkXzMA8gYbiAKu6oyqOgaKYtlxdN7IInwaOaTItmcxP%2FeqaVdjgLKD1eUNYAkoUhgvMA5bJRqcurKhKK4rINBg9oog1qs0xY1ekh3OoxBdu4Sc5pwtguvQIzGctG8BVxsS4BXcCNUp%2F1518QbyQQzoCHVRrMmAUvSvxlUlBbp17%2FcqhGwaiYQkRB%2FfQpGlcW0KehJffmmx%2BcZCePOeYUjUu3hzlG%2ByGwXRVjikau28OYy%2BHnwfmX83H%2FxBBzUGVS4zZkLxR5foTRqLc2dTfkxiLoI41gUmQmDbXthufDsw%2FXN4PgX%2F%2BND5dX3etx9%2FTyLMihH02GJ4oHQm6ZKibxrwSX9SfCi5ZxCMjZUDVQweZJYdcSggOT9DFI4L61nEFmN1BaJXPw3jGngk3Uq5BBRUu22sOgCtQb7kHfXx9DCjuzrWGIYXVmkhmFPefWMKMC9eUYZIjigWaZ3G3C3LdtR5dUz7KZ9lFSdpBiORY3xbVDglwocYBjB0%2Bi55vR9BGmqGNnZzl2KhNfzsbnJ4NR4NP1Jyc3%2FYmvy63J4HQwGYyOg99PBlfDM7XNNpPI%2BgtsizpzAhI2VJ9XYO3A%2BkVTAKdFPbn2cMdwKLQyzhR149rDmerkRj83ivps7eFGNXKinxNFnbX2cMK8f0CNtc8U9dYO3IhxI1nKhYwV81GZ4Tx5rhutqT2hSjeMli3vKseuNk%2FkMy42WxdlO5XPWKqTKp6%2F19zjbQoMG4HzgTxz5JVpx9n7GmOe8LbUJN205fLjJOAxox5smzNcY%2Bw0sQvH%2BJAfbm4gNpZ5cv7QSS7pw3U8BokPMV9cerhHwZiaafGRaUats8c0hqf7l%2Bn7%2B%2FP95uLp80u04t2n1QqAbn0tvMeKXofPxW5HT%2B%2BqdIeIzZ0Kl3O6EL%2FCkSnmd9yUz5PvKeEO8oLhE9OAbfMs8HBagEmLl7qw4qrLYAORvr2hDYNcGWh%2BluzxEfZsJFTNTh%2FFtQ0C2gZqsRBbOxUm01Lt1qG2XJhEc3OGFfMLrDw1R0qvwDKD1TjF6MJ6T8PNIs7Bfc8MzUP2YGOqTJC1rd2PMOy%2BM04%2BqSnyRp%2F8p3kRYrXDoBHlWjLue%2BpyaXOOOZz%2Bq9b%2FYE1038u15heQOy4qqeMEKjF98UHuYoSHcRMWzogrKHdpy6XlzoVTmpkLnqQsd%2F7L5SIYd7i73Qf908XiYRbc8f8%3D%3C%2Fdiagram%3E%3C%2Fmxfile%3E)

</details>

---

<details>
  <summary><h2>🧠 ISA (Arquitetura do Conjunto de Instruções)</h2></summary>

O **Coprocessador Gráfico** implementado na FPGA é controlado por um conjunto de instruções de 32 bits, que compõem sua **Arquitetura do Conjunto de Instruções (ISA)**. O campo de **OPCODE** (3 bits mais significativos) define a operação a ser executada, enquanto os demais campos fornecem os operandos necessários (como endereços, dados ou offsets).

A comunicação entre o HPS (onde roda a API em Assembly) e a FPGA é feita escrevendo essa palavra de 32 bits em um registrador mapeado na memória.

### Tabela de Opcodes (3 bits)

O **OPCODE** é o responsável por passar o código de operação que o decodificador irá ler e acionar a ação correspondente:

| OPCODE (3 bits) | Descrição da Operação                   |
| :-------------: | :-------------------------------------- |
|     **001**     | Carregar Imagem                         |
|     **010**     | Vizinho Mais Próximo (Nearest Neighbor) |
|     **011**     | Replicação (Pixel Replication)          |
|     **100**     | Decimação (Pixel Decimation)            |
|     **101**     | Média de Blocos (Block Averaging)       |
|     **110**     | Reset                                   |
|     **111**     | Load                                    |

### Formato Geral da Instrução (32 bits)

| Campo         | Bits (MSB) | Descrição                                                                 |
| :------------ | :--------- | :------------------------------------------------------------------------ |
| **OPCODE**    | 31:29      | Código da operação a ser executada pelo coprocessador.                    |
| **Operandos** | 28:0       | Dados específicos para a operação (endereços, offsets, valores de pixel). |

### Tipos de Instrução

O único novo formato de instrução é a instrução de LOAD, com isso, o formato das outras instruções podem ser vistas no repositório da Fase 2.

#### Instrução de LOAD:

Utilizada para transferir dados (pixels) do HPS para a memória da FPGA.

| Campo                | Bits  | Tamanho | Descrição                                                  |
| :------------------- | :---- | :------ | :--------------------------------------------------------- |
| **OPCODE**           | 31:29 | 3 bits  | Identifica a operação de **LOAD** (Carregamento de Pixel). |
| **Vazio**            | 28:25 | 4 bits  | Bits não utilizados.                                       |
| **Endereço (Baixo)** | 24:8  | 17 bits | Endereço de leitura na memória da FPGA.                    |
| **Vazio**            | 7:0   | 8 bits  | Bits não utilizados.                                       |

_Nota: A API em Assembly utiliza o opcode `0b111` para esta operação.

</details>

---

<details>
  <summary><h2>📜 API em Assembly (Driver de Software)</h2></summary>
  
A **Application Programming Interface (API)** atua como o driver de software, traduzindo chamadas de função de alto nível (C) em instruções de baixo nível (Assembly) para o coprocessador gráfico na FPGA.

Nesta fase, a principal adição à API implementada em `assembly.s` é:

| Função (C)                    | Descrição                                                                                     | Instrução para FPGA           |
| :---------------------------- | :-------------------------------------------------------------------------------------------- | :---------------------------- |
| `load_pixel`                  | Envia um endereço para leitura na memória da FPGA e retorna o dado lido ao HPS.               | Instrução de Load + Endereço  |

As demais funções da API (inicialização, carregamento de imagem, algoritmos de zoom) podem ser consultadas no **repositório da Fase 2**.

</details>

---

<details>
  <summary><h2>🚀 Guia de Uso</h2></summary>

Para utilizar o projeto no HPS da DE1-SoC:

1.  **Pré-requisito:** O bitstream da FPGA (o hardware do coprocessador) deve estar carregado na placa.
2.  **Compilação:** No terminal do Linux embarcado, execute o `Makefile`:
    ```bash
    make
    ```
3.  **Execução:** Execute o programa gerado:
    ```bash
    ./zoom_digital
    ```
4.  **Interação:** Siga as opções do menu de texto para carregar a imagem e aplicar os diferentes algoritmos de zoom.

</details>

---

<details>
  <summary><h2>⚙️ Funcionamento</h2></summary>

O sistema inicia com um **menu no terminal** apresentando as seguintes opções:
1. **Abrir imagem PGM**
2. **Selecionar algoritmos de zoom**
3. **Selecionar área de zoom com mouse**

### Fluxo de Operação

**1. Carregamento Inicial:**
- O usuário deve **abrir uma imagem** PGM através do menu
- A imagem é transferida para a memória da FPGA e exibida no monitor VGA

**2. Seleção de Área:**
- Com o **mouse**, o usuário seleciona dois cantos opostos de uma janela retangular
- As **coordenadas (x, y)** são exibidas em tempo real no terminal
- Cada canto é confirmado com um **clique do mouse**

**3. Escolha de Algoritmos:**
- Seleção de um algoritmo de **Zoom In** (Vizinho Mais Próximo ou Replicação de Pixel)
- Seleção de um algoritmo de **Zoom Out** (Decimação ou Média de Blocos)

**4. Operações Interativas:**
- **Tecla +:** Aplica zoom in na janela selecionada
- **Teclas WASD:** Navegação pela imagem com a janela ampliada ("lupa")
  - **W:** Move para cima
  - **A:** Move para esquerda
  - **S:** Move para baixo
  - **D:** Move para direita
- **Tecla -:** Aplica zoom out até retornar à resolução original
- **Tecla Q:** Finaliza a navegação e retorna ao menu

**5. Ciclo Contínuo:**
- Após finalizar, o usuário pode selecionar nova área, trocar algoritmos e repetir o processo

A janela ampliada é sempre **desenhada sobre a imagem original**, permitindo visualização contextual durante as operações de zoom.

</details>

---

<details>
  <summary><h2>✅ Conclusão</h2></summary>

A conclusão da 3ª etapa do projeto Zoom Digital em FPGA consolida o sistema completo de processamento interativo de imagens, integrando hardware, software e interface de usuário. A aplicação desenvolvida em C demonstrou comunicação eficiente com a API em Assembly e o coprocessador FPGA, permitindo controle intuitivo através de **mouse e teclado** para seleção de regiões e operações de zoom.

A implementação da **instrução de Load** e do **PIO de entrada** possibilitou a leitura de pixels específicos da memória, essencial para validação das operações em tempo real. A adição da **terceira memória** garantiu separação adequada entre processamento e exibição, permitindo operações simultâneas sem interferência visual. Os testes confirmaram que a seleção de janelas com mouse, a aplicação de zoom in/out com teclas **+/-** e a sobreposição de janelas ampliadas funcionaram de forma precisa e estável.

O sistema operou integralmente com os recursos da DE1-SoC, demonstrando robustez na integração de todos os componentes desenvolvidos ao longo das três fases do projeto. A interface interativa proporcionou experiência fluida ao usuário, com feedback visual em tempo real das coordenadas do mouse e controle responsivo das operações.

Diante dos resultados obtidos, conclui-se que o projeto atendeu plenamente aos objetivos estabelecidos, entregando uma solução embarcada completa e funcional para processamento interativo de imagens em tempo real.

</details>

---

<details>
  <summary><h2>🖥️ Contribuidores</h2></summary>

[<img src="https://github.com/enejota-njs.png" width="80" height="80">](https://github.com/enejota-njs)     [<img src="https://github.com/limajonatas.png" width="80" height="80">](https://github.com/limajonatas)     [<img src="https://github.com/FelipeBastosz.png" width="80" height="80">](https://github.com/FelipeBastosz) 

</details>

---

<details>
  <summary><h2>🧠 Repositório da fase 1 e 2</h2></summary>

Fase 1: Disponível em: <a href="https://github.com/enejota-njs/ZoomDigital_Fase_1" target="_blank">https://github.com/enejota-njs/ZoomDigital_Fase_1</a>
Fase 2: Disponível em: <a href="https://github.com/enejota-njs/ZoomDigital_Fase_2" target="_blank">https://github.com/enejota-njs/ZoomDigital_Fase_2</a>

</details>

---

<details>
  <summary><h2>📚 Referências</h2></summary>

**FPGA Academy**. Disponível em: <a href="https://fpgacademy.org/index.html" target="_blank">https://fpgacademy.org/index.html</a>

**Cyclone® V Hard Processor System Technical Reference Manual**. Disponível em:  
<a href="https://www.intel.com/content/www/us/en/docs/programmable/683126/21-2/hps-to-fpga-interfaces.html" target="_blank">https://www.intel.com/content/www/us/en/docs/programmable/683126/21-2/hps-to-fpga-interfaces.html</a>

**Comunicação entre processador HPS e FPGA em um chip SoC Cyclone V**. Disponível em:  
<a href="https://revistas.cbpf.br/index.php/NT/article/download/270/304" target="_blank">https://revistas.cbpf.br/index.php/NT/article/download/270/304</a>

**Embedded Peripherals IP User Guide**. Disponível em:  
<a href="https://www.intel.com/content/www/us/en/docs/programmable/683130/21-3/pio-core.html" target="_blank">https://www.intel.com/content/www/us/en/docs/programmable/683130/21-3/pio-core.html</a>

**Syscalls ARM32 Reference**. Disponível em:  
<a href="https://nirilu.github.io/arm32-syscall-ref.github.io/" target="_blank">https://nirilu.github.io/arm32-syscall-ref.github.io/</a>

</details>
