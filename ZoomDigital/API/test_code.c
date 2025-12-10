#include "library.h"
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <termios.h>
#include <linux/input.h>
#include <fcntl.h>
#include <errno.h>

#define IMG_WIDTH 320
#define IMG_HEIGHT 240

// Globais para coordenadas
int sel_x1 = 0, sel_y1 = 0, sel_x2 = 0, sel_y2 = 0;
int coordenadas_selecionadas = 0;

// 0 = Estado Normal (Zoom Out), 1 = Estado Ampliado (Zoom In)
int estado_zoom = 0; 

// Matrizes de imagem
uint8_t imagem_principal[IMG_HEIGHT][IMG_WIDTH];
uint8_t imagem_resultado[IMG_HEIGHT][IMG_WIDTH];
uint8_t imagem_selecao[IMG_HEIGHT][IMG_WIDTH]; 

// Protótipo para uso interno
void zoom_in(int tipo_zoom_in);

char getch(void) { // Função apenas para não precisar digitar ENTER
    struct termios oldt, newt;
    char ch;
    tcgetattr(STDIN_FILENO, &oldt);
    newt = oldt;
    newt.c_lflag &= ~(ICANON | ECHO);
    tcsetattr(STDIN_FILENO, TCSANOW, &newt);
    ch = getchar();
    tcsetattr(STDIN_FILENO, TCSANOW, &oldt);
    return ch;
}

// Função para capturar coordenadas do mouse
int get_mouse_coordinate(int *x_out, int *y_out) {
    const char *device = "/dev/input/event0"; // Endereço do dispositivo de mouse
    int fd;
    struct input_event ev;
    int x = 0, y = 0;
    const int MAX_X = IMG_WIDTH - 1;
    const int MAX_Y = IMG_HEIGHT - 1;

    fd = open(device, O_RDONLY);
    if (fd < 0) {
        perror("Erro abrindo input");
        return -1;
    }

    printf("\nMova o mouse e clique para confirmar...\n");

    while (1) {
        ssize_t n = read(fd, &ev, sizeof(ev));
        if (n == -1) {
            if (errno == EINTR) continue;
            close(fd);
            return -1;
        }
        if (n != sizeof(ev)) continue;

        if (ev.type == EV_REL) { // Verifica movimento relativo
            if (ev.code == REL_X) // Verifica movimento no eixo X
                x += ev.value;
            else if (ev.code == REL_Y) // Verifica movimento no eixo Y
                y += ev.value;

            if (x < 0) x = 0;
            if (x > MAX_X) x = MAX_X; 
            if (y < 0) y = 0;
            if (y > MAX_Y) y = MAX_Y;

            // Print que atualiza na mesma linha
            printf("\rPosição Atual -> X: %03d | Y: %03d", x, y);
            fflush(stdout);

        } else if (ev.type == EV_KEY) {
            if (ev.code == BTN_LEFT && ev.value == 1) { // Clique esquerdo
                *x_out = x;
                *y_out = y;
                printf("\nClique registrado em: (%d, %d)\n", x, y);
                close(fd);
                return 0;
            }
        }
    }
    close(fd);
    return -1;
}

// Função para selecionar coordenadas com o mouse
void selecionar_coordenadas(void) {
    int x1, y1, x2, y2, largura, altura;
    
    printf("\n--- Clique no primeiro ponto ---\n");
    if (get_mouse_coordinate(&x1, &y1) != 0) // Pega a primeira coordenada
        return;
        
    printf("\n--- Clique no segundo ponto ---\n");
    if (get_mouse_coordinate(&x2, &y2) != 0) // Pega a segunda coordenada
        return;

    // Ordena para garantir que xi/yi sejam o canto superior esquerdo
    int xi = (x1 < x2) ? x1 : x2;
    int xf = (x1 > x2) ? x1 : x2;
    int yi = (y1 < y2) ? y1 : y2;
    int yf = (y1 > y2) ? y1 : y2;

    // Ajuste de Borda (Garante espaço para o mínimo de 50px)
    if (xi > IMG_WIDTH - 50) xi = IMG_WIDTH - 51;
    if (yi > IMG_HEIGHT - 50) yi = IMG_HEIGHT - 51;

    // Calcula largura inicial
    largura = xf - xi;
    altura = yf - yi;

    // Aplica Limites de Tamanho (Min 50, Max 100)
    if (largura < 50)  { xf = xi + 50;  largura = 50; }
    if (largura > 100) { xf = xi + 100; largura = 100; }

    if (altura < 50)   { yf = yi + 50;  altura = 50; }
    if (altura > 100)  { yf = yi + 100; altura = 100; }

    sel_x1 = xi;
    sel_y1 = yi;
    sel_x2 = xf;
    sel_y2 = yf;
    
    printf("\nÁrea Selecionada: (%d, %d) até (%d, %d)\n", xi, yi, xf, yf);
    printf("Tamanho: %d x %d\n", largura, altura);
    
    coordenadas_selecionadas = 1;
    estado_zoom = 0; 
}

// Função para carregar a imagem principal da memória
void carregar_imagem_principal(void) {
    for (int y = 0; y < IMG_HEIGHT; y++) {
        for (int x = 0; x < IMG_WIDTH; x++) {
            uint32_t addr = y * IMG_WIDTH + x;
            imagem_principal[y][x] = load(addr);
        }
    }
}

// Função para salvar a imagem principal na memória 
void salvar_imagem(void) {
    for (int y = 0; y < IMG_HEIGHT; y++) {
        for (int x = 0; x < IMG_WIDTH; x++) {
            uint32_t addr = y * IMG_WIDTH + x;
            store(addr, imagem_principal[y][x]);
        }
    }
    reset();
}

// Função para carregar o resultado do zoom da memória para a matriz de resultado
void carregar_resultado(void) {
    for (int y = 0; y < IMG_HEIGHT; y++)
        for (int x = 0; x < IMG_WIDTH; x++) {
            uint32_t addr = y * IMG_WIDTH + x;
            imagem_resultado[y][x] = load(addr);
        }
}

// Função para salvar a imagem atual da memória em um arquivo PGM
void salvar_pgm(const char *filename) {
    FILE *fp;
    uint32_t addr;
    uint8_t pixel;
    int width = IMG_WIDTH, height = IMG_HEIGHT;
    int total = width * height;

    fp = fopen(filename, "wb"); // Abre arquivo para escrita binária
    if (fp == NULL)
        return;

    fprintf(fp, "P5\n%d %d\n255\n", width, height);

    for (addr = 0; addr < total; addr++) {
        pixel = load(addr); // Carrega pixel da memória
        fputc(pixel, fp); // Escreve pixel no arquivo
    }

    fclose(fp); // Fecha o arquivo
}

// Função de Zoom In
void zoom_in(int tipo_zoom_in) {
    int xi = sel_x1;
    int xf = sel_x2;
    int yi = sel_y1;
    int yf = sel_y2;

    int largura = xf - xi; // Largura da seleção
    int altura = yf - yi; // Altura da seleção

    // Inicializa matriz de seleção preta
    for (int y = 0; y < IMG_HEIGHT; y++)
        for (int x = 0; x < IMG_WIDTH; x++)
            imagem_selecao[y][x] = 0;

    // Copia área selecionada
    for (int y = 0; y < altura; y++)
        for (int x = 0; x < largura; x++)
            imagem_selecao[y][x] = imagem_principal[yi + y][xi + x];

    // Manda a área selecionada para a memória
    for (int y = 0; y < IMG_HEIGHT; y++)
        for (int x = 0; x < IMG_WIDTH; x++) {
            uint32_t addr = y * IMG_WIDTH + x;
            store(addr, imagem_selecao[y][x]);
        }
     
    usleep(50000);

    // Aplica o zoom in sobre essa imagem na memória
    if (tipo_zoom_in == 1)
        nearest_neighbor(0, 0);
    else
        pixel_replication(0, 0);

    usleep(50000);

    salvar_pgm("zoom_in.pgm"); // salva resultado do zoom in para verificação

    carregar_resultado(); // carrega todo resultado da memória

    // calcula offsets para centralizar o zoom in
    int offset_x = largura / 2; 
    int offset_y = altura / 2;

    if (xi < 10) offset_x = 3;
    if (xf > IMG_WIDTH - 10) offset_x = largura; 
    if (yi < 10) offset_y = 0;
    if (yf > IMG_HEIGHT - 10) offset_y = altura;

    for (int y = 0; y < altura; y++) {
        for (int x = 0; x < largura; x++) {
            int src_x = offset_x + x;
            int src_y = offset_y + y;
            
            if (src_x < (largura * 2) && src_y < (altura * 2)) {
                imagem_principal[yi + y][xi + x] = imagem_resultado[src_y][src_x]; // Mescla o zoom in
            }
        }
    }

    salvar_imagem(); // Salva a imagem mesclada na memória
   
    estado_zoom = 1; 
}

// Função de Zoom Out
void zoom_out(int tipo_zoom_out) {
    int xi = sel_x1;
    int xf = sel_x2;
    int yi = sel_y1;
    int yf = sel_y2;

    int largura_mb; 
    int largura = xf - xi; // Largura da seleção
    int altura = yf - yi; // Altura da seleção

    // Manda o resultado do zoom in da matriz para a memória
    for (int y = 0; y < IMG_HEIGHT; y++)
        for (int x = 0; x < IMG_WIDTH; x++)
            store(y * IMG_WIDTH + x, imagem_resultado[y][x]);
    
    usleep(10000);

    // Aplica o zoom out sobre essa imagem na memória
    if (tipo_zoom_out == 1)
        pixel_decimation();
    else
        block_average();
    usleep(50000);

    salvar_pgm("zoom_out.pgm");

    // Carrega o resultado do zoom out da memória para a matriz
    carregar_resultado();

    usleep(10000);
    
    // Mescla o resultado do zoom out na área selecionada
    for (int y = 0; y < altura; y++) {
    for (int x = 0; x < largura; x++) {
        if (tipo_zoom_out == 1) {
            imagem_principal[yi + y][xi + x] = imagem_resultado[y][x + 2];
        } else {
            if (x == largura - 1) {
                imagem_principal[yi + y][xi + x] = imagem_resultado[y][x + 1];
            } else {
                imagem_principal[yi + y][xi + x] = imagem_resultado[y][x + 2];
            }
        }
    }
}

    salvar_imagem(); // Salva a imagem mesclada na memória
    
    estado_zoom = 0;
    printf("\nZoom Out aplicado.\n");
}

// Função para movimentar a área selecionada
void movimentar(int tipo_zoom) {
    printf("\nUse [WASD] para mover (Passo: 10px). [Q] para sair.\n");
    
    while (1) {
        char k = getch();
        int mudou = 0;
        int step = 10; // Tamanho padrão do passo

        if (k == 'q' || k == 'Q') {
            break;
        }

        // Direita (D)
        if (k == 'd' || k == 'D') {
            // Se o passo ultrapassar a largura, reduz o passo para encostar na borda
            if (sel_x2 + step > IMG_WIDTH) step = IMG_WIDTH - sel_x2;
            
            // Aplica o movimento se o passo for válido
            if (step > 0) { 
                sel_x1 += step; 
                sel_x2 += step; 
                mudou = 1; 
            }
        }
        // Esquerda (A)
        else if (k == 'a' || k == 'A') {
            // Se o passo ultrapassar o zero, reduz o passo para encostar no zero
            if (sel_x1 - step < 0) step = sel_x1;

            // Aplica o movimento se o passo for válido
            if (step > 0) { 
                sel_x1 -= step; 
                sel_x2 -= step; 
                mudou = 1; 
            }
        }
        // Baixo (S)
        else if (k == 's' || k == 'S') {
            if (sel_y2 + step > IMG_HEIGHT) step = IMG_HEIGHT - sel_y2;

            // Aplica o movimento se o passo for válido
            if (step > 0) { 
                sel_y1 += step; 
                sel_y2 += step; 
                mudou = 1; 
            }
        }
        // Cima (W)
        else if (k == 'w' || k == 'W') {
            if (sel_y1 - step < 0) step = sel_y1;

            // Aplica o movimento se o passo for válido
            if (step > 0) { 
                sel_y1 -= step; 
                sel_y2 -= step; 
                mudou = 1; 
            }
        }

        if (mudou) { // Se houve movimento, reaplica o zoom in na nova posição
            open_image("Linux.pgm"); // Abre a imagem original

            carregar_imagem_principal(); // Carrega a imagem principal na matriz
            
            zoom_in(tipo_zoom); // Reaplica o zoom in na nova posição
            
            printf("\rPosição: (%d, %d)   ", sel_x1, sel_y1);
            fflush(stdout);
        }
    }
    printf("\nPosição fixada.\n");
}

// Menu para seleção dos algoritmos de Zoom In e Zoom Out
void menu_algoritmos(void) {
    char opcao;
    int running = 1;
    int algoritmo_zoom_in = 0;  // 0 = não selecionado, 1 = Vizinho, 2 = Replicação
    int algoritmo_zoom_out = 0; // 0 = não selecionado, 1 = Decimação, 2 = Média
    
    carregar_imagem_principal(); // Carrega a imagem principal na matriz
    
    // Primeiro: selecionar algoritmo de Zoom In
    while (algoritmo_zoom_in == 0) {
        printf("\n");
        printf("+---------------------------------------+\n");
        printf("|     SELECIONE O ALGORITMO DE ZOOM IN  |\n");
        printf("+---------------------------------------+\n");
        printf("|  1. Vizinho Mais Próximo              |\n");
        printf("|  2. Replicação de Pixel               |\n");
        printf("|  0. Voltar ao Menu Principal          |\n");
        printf("+---------------------------------------+\n");
        printf("Escolha uma opção: ");
        
        opcao = getch();
        printf("%c\n", opcao);
        
        switch (opcao) {
            case '1':
                algoritmo_zoom_in = 1;
                printf("\nZoom In: Vizinho Mais Próximo selecionado.\n");
                break;
            case '2':
                algoritmo_zoom_in = 2;
                printf("\nZoom In: Replicação de Pixel selecionada.\n");
                break;
            case '0':
                return;
            default:
                printf("\nOpção inválida!\n");
                break;
        }
    }
    
    // Segundo: selecionar algoritmo de Zoom Out
    while (algoritmo_zoom_out == 0) {
        printf("\n");
        printf("+---------------------------------------+\n");
        printf("|    SELECIONE O ALGORITMO DE ZOOM OUT  |\n");
        printf("+---------------------------------------+\n");
        printf("|  1. Decimação                         |\n");
        printf("|  2. Média de Blocos                   |\n");
        printf("|  0. Voltar ao Menu Principal          |\n");
        printf("+---------------------------------------+\n");
        printf("Escolha uma opção: ");
        
        opcao = getch();
        printf("%c\n", opcao);
        
        switch (opcao) {
            case '1':
                algoritmo_zoom_out = 1;
                printf("\nZoom Out: Decimação selecionada.\n");
                break;
            case '2':
                algoritmo_zoom_out = 2;
                printf("\nZoom Out: Média de Blocos selecionada.\n");
                break;
            case '0':
                return; 
            default:
                printf("\nOpção inválida!\n");
                break;
        }
    }
    
    // Menu principal de controle com + e -
    while (running) {
        printf("\n");
        printf("+---------------------------------------+\n");
        printf("|          CONTROLE DE ZOOM             |\n");
        printf("+---------------------------------------+\n");
        printf("|  Algoritmos selecionados:             |\n");
        printf("|  Zoom In:  %s       |\n", 
               algoritmo_zoom_in == 1 ? "Vizinho Mais Próximo" : "Replicação de Pixel ");
        printf("|  Zoom Out: %s            |\n", 
               algoritmo_zoom_out == 1 ? "Decimação      " : "Média de Blocos");
        printf("|                                       |\n");
        if (estado_zoom == 0) {
            printf("|  STATUS: Imagem Normal                |\n");
            printf("|  [+] Pressione + para Zoom In         |\n");
        } else {
            printf("|  STATUS: Zoom Aplicado                |\n");
            printf("|  [-] Pressione - para Zoom Out        |\n");
        }
        printf("|                                       |\n");
        printf("|  [0] Voltar ao Menu Principal         |\n");
        printf("+---------------------------------------+\n");
        printf("Escolha: ");
        
        opcao = getch();
        printf("%c\n", opcao);
        
        switch (opcao) {
            case '+':
                if (estado_zoom == 0) {
                    zoom_in(algoritmo_zoom_in);
                    movimentar(algoritmo_zoom_in);
                } else {
                    printf("\n Você já está em Zoom In!  Use - para Zoom Out.\n");
                }
                break;
            case '-':
                if (estado_zoom == 1) {
                    zoom_out(algoritmo_zoom_out);
                } else {
                    printf("\n Você já está em Zoom Out! Use + para Zoom In.\n");
                }
                break;
            case '0':
                if (estado_zoom == 0) {
                    running = 0;
                } else {
                    printf("\n Você precisa aplicar Zoom Out (-) antes de voltar!\n");
                }
                break;
            default:
                printf("\nOpção inválida!  Use + ou -\n");
                break;
        }
    }
}

int main(void) {
    char opcao;
    int running = 1;
    int imagem_aberta = 0;
    initialization(); // Inicializa o sistema
    
    // Loop principal do menu
    while (running) {
        printf("\n");
        printf("+------------------------------------+\n");
        printf("|           SISTEMA DE ZOOM          |\n");
        printf("+------------------------------------+\n");
        printf("|  1. Selecionar Coordenadas         |\n");
        printf("|  2. Algoritmos (Zoom In/Out)       |\n");
        printf("|  3. Abrir Imagem                   |\n");
        printf("|  0. Sair                           |\n");
        printf("+------------------------------------+\n");
        printf("Escolha uma opção: ");
        
        opcao = getch();
        printf("%c\n", opcao);
        
        switch (opcao) {
            case '1':
                if (imagem_aberta) {
                    open_image("Linux.pgm"); // Reabre a imagem original
                    selecionar_coordenadas(); // Seleciona coordenadas
                } else {
                    printf("\nErro: Abra uma imagem antes de selecionar coordenadas.\n");
                }
                break;
            case '2':
                if (!coordenadas_selecionadas) {
                    printf("\nErro: Selecione as coordenadas primeiro.\n");
                } else {
                    menu_algoritmos(); // Entra no menu de algoritmos
                }
                break;
            case '3':
                open_image("Linux.pgm"); // Abre a imagem
                imagem_aberta = 1;
                coordenadas_selecionadas = 0;
                estado_zoom = 0; 
                printf("\nImagem carregada com sucesso.\n");
                break;
            case '0':
                running = 0;
                break;
            default:
                printf("\nOpção inválida.\n");
                break;
        }
    }
    finalization(); // Finaliza o sistema
    return 0;
}