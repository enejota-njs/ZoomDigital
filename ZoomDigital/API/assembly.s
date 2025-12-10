.section .text
.global initialization
.type initialization, %function

.global pixel_decimation
.type pixel_decimation, %function

.global nearest_neighbor
.type nearest_neighbor, %function

.global pixel_replication
.type pixel_replication, %function

.global block_average
.type block_average, %function

.global open_image
.type open_image, %function

.global finalization
.type finalization, %function

.global load
.type load, %function

.global store
.type store, %function

.global reset
.type reset, %function

initialization:
        sub sp, sp, #28                         @ abre espaço na stack
        str r0, [sp, #0]
        str r1, [sp, #4]
        str r2, [sp, #8]
        str r3, [sp, #12]
        str r4, [sp, #16]
        str r5, [sp, #20]
        str r7, [sp, #24]

        ldr r0, =DEV_MEM                        @ r0 = endereço da string "/dev/mem"
        mov r1, #2                              @ r1 = O_RDWR  (flag para abrir arquivo)
        mov r2, #0                              @ r2 = modo = 0
        mov r7, #5                              @ r7 = syscall number 5 = open()

        svc 0

        mov r4, r0                              @ guarda o file descriptor retornado em r4
        ldr r0, =FD                             @ carrega o endereço da variável global FD
        str r4, [r0, #0]                        @ armazena o file descriptor dentro de FD

        mov r0, #0                  
        ldr r1, =LW_BRIDGE_SPAN                 @ carrega o endereço da variável LW_BRIDGE_SPAN
        ldr r1, [r1, #0]                        @ r1 = tamanho do mapeamento (span)
        mov r2, #3                              @ r2 = PROT_READ | PROT_WRITE (3)
        mov r3, #1                              @ r3 = MAP_SHARED
        ldr r5, =LW_BRIDGE_BASE                 @ carrega endereço da variable LW_BRIDGE_BASE
        ldr r5, [r5, #0]                        @ r5 = endereço físico real do bridge
        mov r7, #192                          @ syscall 192 = mmap2()

        svc 0

        ldr r1, =INSTRUCTION_PTR                 @ carrega endereço da variável que aponta para INSTRUCTION_PTR
        str r0, [r1, #0]                         @ armazena o ponteiro do mmap nela

        add r0, r0, #0x10                        @ ajusta ponteiro para acessar um offset de +0x10
        ldr r1, =ENABLE_INSTRUCTION_PTR
        str r0, [r1, #0]                         @ salva ponteiro ajustado em ENABLE_INSTRUCTION_PTR

        add r0, r0, #0x10                        @ ajusta ponteiro para acessar um offset de +0x10
        ldr r1, =LOAD_PTR
        str r0, [r1, #0]                         @ salva ponteiro ajustado em ENABLE_INSTRUCTION_PTR

        ldr r0, [sp, #0]
        ldr r1, [sp, #4]
        ldr r2, [sp, #8]
        ldr r3, [sp, #12]
        ldr r4, [sp, #16]
        ldr r5, [sp, #20]
        ldr r7, [sp, #24]
        add sp, sp, #28                           @ fecha espaço na stack

        bx lr                                     @ retorna

pixel_decimation:
        sub sp, sp, #16                           @ abre espaço na stack
        str r0, [sp, #0]
        str r1, [sp, #4]
        str r2, [sp, #8]
        str r3, [sp, #12]

        ldr r0, =0x80000000                       @ valor da instrução para decimação
        ldr r1, =INSTRUCTION_PTR                  @ carrega endereço onde está o ponteiro das instruções
        ldr r1, [r1]                              @ r1 = ponteiro mapeado 
        str r0, [r1]                              @ escreve a instrução para a FPGA

        ldr r2, =ENABLE_INSTRUCTION_PTR           @ endereço do registrador de enable
        ldr r2, [r2]                              @ r2 = ponteiro real para o enable
        mov r3, #1                                @ habilita a instrução
        str r3, [r2]                   
        mov r3, #0                                @ desabilita logo em seguida
        str r3, [r2]                   

        ldr r0, [sp, #0]
        ldr r1, [sp, #4]
        ldr r2, [sp, #8]
        ldr r3, [sp, #12]
        add sp, sp, #16                           @ fecha espaço na stack

        bx lr                                     @ retorna

nearest_neighbor:
        sub sp, sp, #16                           @ abre espaço na stack
        str r0, [sp, #0]
        str r1, [sp, #4]
        str r2, [sp, #8]
        str r3, [sp, #12]

        mov r3, #2                                @ r3 = 2 (opcode do algoritmo)
        lsl r3, r3, #29                           @ desloca para posição 
        lsl r0, r0, #8                            @ desloca r0 8 bits (r0 = OFFSET X)
        orr r3, r3, r0                            @ combina r3 com r0
        orr r3, r3, r1                            @ combina r3 com r1 (r1 = OFFSET Y)

        ldr r1, =INSTRUCTION_PTR                  @ carrega endereço do ponteiro
        ldr r1, [r1]             
        str r3, [r1]                              @ envia instrução 

        ldr r2, =ENABLE_INSTRUCTION_PTR           @ endereço do registrador de enable
        ldr r2, [r2]                              @ r2 = ponteiro real para o enable
        mov r3, #1                                @ habilita a instrução
        str r3, [r2]                   
        mov r3, #0                                @ desabilita logo em seguida
        str r3, [r2]                    

        ldr r0, [sp, #0]
        ldr r1, [sp, #4]
        ldr r2, [sp, #8]
        ldr r3, [sp, #12]
        add sp, sp, #16                            @ fecha espaço na stack

        bx lr                                      @ retorna

pixel_replication: 
        sub sp, sp, #16                            @ abre espaço na stack
        str r0, [sp, #0]
        str r1, [sp, #4]
        str r2, [sp, #8]
        str r3, [sp, #12]

        mov r3, #3                                 @ r3 = 3 (opcode do algoritmo)
        lsl r3, r3, #29                            @ desloca para posição 
        lsl r0, r0, #8                             @ desloca r0 8 bits (r0 = OFFSET X)
        orr r3, r3, r0                             @ combina r3 com r0
        orr r3, r3, r1                             @ combina r3 com r1 (r1 = OFFSET Y)

        ldr r1, =INSTRUCTION_PTR                   @ carrega endereço do ponteiro
        ldr r1, [r1]             
        str r3, [r1]                               @ envia instrução 

        ldr r2, =ENABLE_INSTRUCTION_PTR            @ endereço do registrador de enable
        ldr r2, [r2]                               @ r2 = ponteiro real para o enable
        mov r3, #1                                 @ habilita a instrução
        str r3, [r2]                   
        mov r3, #0                                 @ desabilita logo em seguida
        str r3, [r2]                    

        ldr r0, [sp, #0]
        ldr r1, [sp, #4]
        ldr r2, [sp, #8]
        ldr r3, [sp, #12]
        add sp, sp, #16                            @ fecha espaço na stack

        bx lr                                      @ retorna

block_average:
        sub sp, sp, #16                            @ abre espaço na stack
        str r0, [sp, #0]
        str r1, [sp, #4]
        str r2, [sp, #8]
        str r3, [sp, #12]

        ldr r0, =0xA0000000                        @ valor da instrução para média de blocos
        ldr r1, =INSTRUCTION_PTR                   @ carrega endereço onde está o ponteiro das instruções
        ldr r1, [r1]                               @ r1 = ponteiro mapeado 
        str r0, [r1]                               @ escreve a instrução para a FPGA


        ldr r2, =ENABLE_INSTRUCTION_PTR            @ endereço do registrador de enable
        ldr r2, [r2]                               @ r2 = ponteiro real para o enable
        mov r3, #1                                 @ habilita a instrução
        str r3, [r2]                   
        mov r3, #0                                 @ desabilita logo em seguida
        str r3, [r2]

        ldr r0, [sp, #0]
        ldr r1, [sp, #4]
        ldr r2, [sp, #8]
        ldr r3, [sp, #12]
        add sp, sp, #16                            @ fecha espaço na stack

        bx lr                                      @ retorna

open_image:
        push {r4-r11, lr}                            @ salva registradores de uma vez

        mov r1, #0                                   @ r1 = O_RDONLY
        mov r2, #0                                   @ sem flags extras
        mov r7, #5                                   @ syscall open()
        svc 0                                        @ abre arquivo
        mov r4, r0                                   @ r4 = file descriptor   
        
        mov r0, r4              
        ldr r1, =BUFFER                              @ endereço do buffer
        mov r2, #15                                  @ lê primeiros 15 bytes (cabeçalho)
        mov r7, #3                                   @ syscall read()
        svc 0

        mov r0, r4              
        ldr r1, =BUFFER                              @ buffer de destino
        mov r2, #76800                               @ lê 240*320 bytes da imagem
        mov r7, #3                                   @ syscall read()
        svc 0

        ldr r8, =BUFFER                              @ r8 = ponteiro fixo do buffer
        mov r9, #0                                   @ r9 = índice

.loop:
        cmp r9, #76800                               @ compara índice com tamanho total
        beq .end_of_loop                             @ se chegou ao fim, sai do loop

        ldrb r10, [r8, r9]                           @ carrega 1 byte da imagem (pixel) usando r8
        
        mov  r0, r9                                  @ r0 = endereço
        mov  r1, r10                                 @ r1 = dado (pixel)

        bl   store                                   @ chama store (que preserva r8, r9, r10)

        add  r9, r9, #1                              @ incrementa índice
        b    .loop                                   @ volta para o início do loop

.end_of_loop:
        ldr r0, =0xC0000000
        ldr r1, =INSTRUCTION_PTR   
        ldr r1, [r1]               
        str r0, [r1]
        
        ldr r2, =ENABLE_INSTRUCTION_PTR
        ldr r2, [r2]
        mov r3, #1
        str r3, [r2]                  
        mov r3, #0
        str r3, [r2] 

        pop {r4-r11, pc}         @  Restaura os registradores salvos

reset:
        
        ldr r0, =0xC0000000                          @ instrução de reset
        ldr r1, =INSTRUCTION_PTR   
        ldr r1, [r1]               
        str r0, [r1]                                 @ escreve instrução 

        ldr r2, =ENABLE_INSTRUCTION_PTR
        ldr r2, [r2]
        mov r3, #1                                   @ ativa enable
        str r3, [r2]                  
        mov r3, #0                                   @ desativa enable
        str r3, [r2] 

        bx lr

store:
        push {r3-r5, lr}                             @ SALVA os registradores que vai usar
        
        ldr  r3, =INSTRUCTION_PTR
        ldr  r3, [r3]
        ldr  r4, =ENABLE_INSTRUCTION_PTR
        ldr  r4, [r4]

        lsl  r5, r0, #8                              @ desloca address para bits [25:8]
        orr  r5, r5, r1                              @ adiciona data nos bits [7:0]
        bic  r5, r5, #(0b111 << 29)
        orr  r5, r5, #(1 << 29)
        
        str  r5, [r3]                                @ escreve instrução

        mov  r0, #1                                  @ ativa enable
        str  r0, [r4]              
        mov  r0, #0                                  @ desativa enable
        str  r0, [r4]

        pop {r3-r5, pc}                              @ RESTAURA e retorna

load:
        ldr r1, =INSTRUCTION_PTR
        ldr r1, [r1]
        ldr r2, =ENABLE_INSTRUCTION_PTR
        ldr r2, [r2]
        ldr r3, =LOAD_PTR
        ldr r3, [r3]

        lsl r5, r0, #8                          @ desloca endereço para bits [25:8]
        bic r5, r5, #(0b111 << 29)              @ limpa bits 29-31
        orr r5, r5, #(7 << 29)                  @ define opcode 7 (LOAD)
        
        str r5, [r1]                            @ envia instrução

        mov r0, #1                              @ ativa enable
        str r0, [r2]              
        mov r0, #0                              @ desativa enable
        str r0, [r2]              

        ldr r0, [r3]                            @ lê o valor retornado

        bx  lr

finalization:
        sub sp, sp, #12                               @ abre espaço na stack
        str r0, [sp, #0]
        str r1, [sp, #4]
        str r7, [sp, #8]

        ldr r0, =INSTRUCTION_PTR                      @ endereço da variável com o ponteiro
        ldr r0, [r0, #0]                              @ r0 = ponteiro real mapeado no FPGA
        ldr r1, =LW_BRIDGE_SPAN                       @ endereço do tamanho do mapeamento
        ldr r1, [r1, #0]                              @ r1 = span real
        mov r7, #91                                   @ syscall munmap()

        svc 0

        ldr r0, =FD                                   @ endereço onde foi salvo o fd do /dev/mem
        ldr r0, [r0, #0]                              @ r0 = fd
        mov r7, #6                                    @ syscall close()

        svc 0

        ldr r0, [sp, #0]
        ldr r1, [sp, #4]
        ldr r7, [sp, #8]
        add sp, sp, #12                               @ fecha espaço da stack

        bx lr                                         @ retorna

.section .data

BUFFER:        
        .space 76800  

DEV_MEM:
        .asciz "/dev/mem"

LW_BRIDGE_SPAN:
        .word 0x1000

INSTRUCTION_PTR:
        .space 4

ENABLE_INSTRUCTION_PTR:
        .space 4

LOAD_PTR:
        .space 4

FD:
        .space 4

LW_BRIDGE_BASE:
        .word 0xff200
