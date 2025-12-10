module control_unit (
    input  wire clock_50MHz,       // Clock de entrada principal (50 MHz)
    input  wire start_repl,        // Sinal de start para replicação de pixels
    input  wire start_dec,         // Sinal de start para decimação
    input  wire start_avg,         // Sinal de start para média de blocos
    input  wire start_nn,          // Sinal de start para vizinho mais próximo        
    output wire hsync,             // Sinal horizontal de sincronização VGA
    output wire vsync,             // Sinal vertical de sincronização VGA
    output [7:0] red,              // Componente de cor vermelha VGA
    output [7:0] green,            // Componente de cor verde VGA
    output [7:0] blue,             // Componente de cor azul VGA
    output sync,                   // Sinal de sincronização VGA
    output clk,                    // Clock para VGA
    output blank                   // Sinal de blank VGA
);

    wire clock_25MHz; 
    
    // Sinais VGA
    wire [16:0] rd_addr_vga;  
    wire [7:0] q;              
    wire [7:0] color;          
    wire [9:0] next_x;         
    wire [9:0] next_y;         
    
    // Controle de Memórias
    wire [16:0] rd_addr_primary;     
    wire [16:0] wr_addr_secondary;  
    wire [7:0] wr_data_secondary;    
    wire wr_en_secondary;           
    wire [7:0] pixel_from_primary;  
    
    // Reset e Cópia Inicial
    reg reset_active;                
    reg [16:0] reset_addr_counter;   
    reg [1:0] copy_state;           
    reg trigger_reset_copy;          
    reg internal_rst;               
    localparam CPY_IDLE = 2'b00, CPY_PROCESS = 2'b01; 
    
    // Reset inicial (power-on)
    reg [3:0] power_on_counter; 
    initial begin
        power_on_counter = 4'd0;
        internal_rst = 1'b0;
    end
    
    always @(posedge clock_25MHz) begin
        if (power_on_counter < 4'd10) begin
            power_on_counter <= power_on_counter + 1;
            internal_rst <= 1'b0;
        end else begin
            internal_rst <= 1'b1;
        end
    end
    
    // Modo de Display
    reg display_mode; // 0=320x240, 1=160x120
 
    // Replicação de Pixels
    wire [16:0] addr_counter_repl;    
    wire [16:0] addr_write_repl;      
    wire [31:0] replicated_pixels;   
    wire [7:0] out_pixel_repl;        
    wire pixel_done_repl;             
    wire wren_repl;                  
    wire done_repl;                   
    
    reg [7:0] pixel_repl_r;
    always @(posedge clock_25MHz) pixel_repl_r <= pixel_from_primary;
    
    // Decimação de Pixels
    wire [16:0] rd_addr_dec;    
    wire [16:0] wr_addr_dec;   
    wire [7:0] wr_data_dec;     
    wire wren_dec;              
    wire done_dec;             
    
    // Média de Blocos (Block Average)
    wire [16:0] in_addr_avg;        
    wire [16:0] mem_read_addr_avg;  
    wire [16:0] out_addr_avg;    
    wire [7:0] out_data_avg;        
    wire wren_avg;                  
    wire done_avg;                
    wire processing_avg;            
    wire [7:0] val00, val01, val10, val11; 
    
    // Nearest Neighbor (Interpolação)
    wire [16:0] rd_addr_nn;     
    wire [16:0] wr_addr_nn;     
    wire [7:0] wr_data_nn;      
    wire wren_nn;              
    wire done_nn;             
    
    // Sinais de Controle
    reg repl_active;    
    reg dec_active;     
    reg avg_active;     
    reg nn_active;      
    reg algo_applied;   
    reg [2:0] last_algo;
    
    // Codificação dos algoritmos
    localparam ALGO_NONE = 3'b000;
    localparam ALGO_REPL = 3'b001;
    localparam ALGO_DEC  = 3'b010;
    localparam ALGO_AVG  = 3'b011;
    localparam ALGO_NN   = 3'b100;
    
    // Detecção de borda (botões)
    reg start_repl_prev;
    reg start_dec_prev;
    reg start_avg_prev;
    reg start_nn_prev;
    wire start_repl_edge;
    wire start_dec_edge;
    wire start_avg_edge;
    wire start_nn_edge;
    
    // Sincronização dos botões
    always @(posedge clock_25MHz) begin
        if (!internal_rst) begin
            start_repl_prev <= 1'b1;
            start_dec_prev <= 1'b1;
            start_avg_prev <= 1'b1;
            start_nn_prev <= 1'b1;
        end else begin
            start_repl_prev <= start_repl;
            start_dec_prev <= start_dec;
            start_avg_prev <= start_avg;
            start_nn_prev <= start_nn;
        end
    end
    
    // Geração dos pulsos de borda
    assign start_repl_edge = !start_repl && start_repl_prev;
    assign start_dec_edge = !start_dec && start_dec_prev;
    assign start_avg_edge = !start_avg && start_avg_prev;
    assign start_nn_edge = !start_nn && start_nn_prev;
    
    // Detecção de término Block Average
    reg prev_processing_avg;
    wire avg_finished;
    
    always @(posedge clock_25MHz) begin
        if (!internal_rst) begin
            prev_processing_avg <= 1'b0;
        end else begin
            prev_processing_avg <= processing_avg;
        end
    end
    
    assign avg_finished = prev_processing_avg && !processing_avg;
    
    // Máquina de estados principal
    always @(posedge clock_25MHz) begin
        if (!internal_rst) begin
            repl_active <= 1'b0;
            dec_active <= 1'b0;
            avg_active <= 1'b0;
            nn_active <= 1'b0;
            display_mode <= 1'b0;
            algo_applied <= 1'b0;
            last_algo <= ALGO_NONE;
            trigger_reset_copy <= 1'b0;
            copy_state <= CPY_PROCESS;
            reset_active <= 1'b1;
            reset_addr_counter <= 17'd0;
        end else begin
            case (copy_state)
				
                // Processo de cópia inicial
                CPY_PROCESS: begin
                    reset_active <= 1'b1;
                    if (reset_addr_counter < 17'd76800) begin
                        reset_addr_counter <= reset_addr_counter + 1;
                    end else begin
                        copy_state <= CPY_IDLE;
                        reset_active <= 1'b0;
                        trigger_reset_copy <= 1'b0;
                    end
                end
                
                // Estado idle (aguardando comandos)
                CPY_IDLE: begin
                    reset_active <= 1'b0;
                    
                    if (trigger_reset_copy) begin
                        // Reinicia cópia para restaurar imagem base
                        copy_state <= CPY_PROCESS;
                        reset_addr_counter <= 17'd0;
                        display_mode <= 1'b0;
                    end
                    else begin
                        // Caso já tenha um algoritmo aplicado, força reset se outro for escolhido
                        if (algo_applied) begin
                            if (start_repl_edge && last_algo != ALGO_REPL) begin
                                trigger_reset_copy <= 1'b1;
                                algo_applied <= 1'b0;
                            end
                            else if (start_dec_edge && last_algo != ALGO_DEC) begin
                                trigger_reset_copy <= 1'b1;
                                algo_applied <= 1'b0;
                            end
                            else if (start_avg_edge && last_algo != ALGO_AVG) begin
                                trigger_reset_copy <= 1'b1;
                                algo_applied <= 1'b0;
                            end
                            else if (start_nn_edge && last_algo != ALGO_NN) begin
                                trigger_reset_copy <= 1'b1;
                                algo_applied <= 1'b0;
                            end
                        end
                        // Se nenhum algoritmo ativo, aceita qualquer botão
                        else if (start_repl_edge && !repl_active && !dec_active && !avg_active && !nn_active) begin
                            repl_active <= 1'b1;
                            display_mode <= 1'b0;
                        end
                        else if (start_dec_edge && !repl_active && !dec_active && !avg_active && !nn_active) begin
                            dec_active <= 1'b1;
                            display_mode <= 1'b0;
                        end
                        else if (start_avg_edge && !repl_active && !dec_active && !avg_active && !nn_active) begin
                            avg_active <= 1'b1;
                            display_mode <= 1'b0;
                        end
                        else if (start_nn_edge && !repl_active && !dec_active && !avg_active && !nn_active) begin
                            nn_active <= 1'b1;
                            display_mode <= 1'b0;
                        end
                        // Finalizações de algoritmos
                        else if (done_dec && dec_active) begin
                            dec_active <= 1'b0;
                            display_mode <= 1'b1;
                            algo_applied <= 1'b1;
                            last_algo <= ALGO_DEC;
                        end
                        else if (repl_active && done_repl) begin
                            repl_active <= 1'b0;
                            display_mode <= 0;
                            algo_applied <= 1'b1;
                            last_algo <= ALGO_REPL;
                        end
                        else if (avg_active && avg_finished) begin
                            avg_active <= 1'b0;
                            display_mode <= 1'b1;
                            algo_applied <= 1'b1;
                            last_algo <= ALGO_AVG;
                        end
                        else if (nn_active && done_nn) begin
                            nn_active <= 1'b0;
                            display_mode <= 0;
                            algo_applied <= 1'b1;
                            last_algo <= ALGO_NN;
                        end
                    end
                end
                
                default: begin
                    copy_state <= CPY_IDLE;
                    reset_active <= 1'b0;
                end
            endcase
        end
    end
    
    // Flags de start para cada algoritmo
    wire start_repl_sig = repl_active;
    wire start_dec_sig = dec_active;
    wire start_avg_sig = avg_active;
    wire start_nn_sig = nn_active;

    // Multiplexadores
    reg [16:0] rd_addr_primary_r;
    reg [16:0] wr_addr_secondary_r;
    reg [7:0] wr_data_secondary_r;
    reg wr_en_secondary_r;
    
    always @(posedge clock_25MHz) begin
        if (!internal_rst) begin
            rd_addr_primary_r <= 17'd0;
            wr_addr_secondary_r <= 17'd0;
            wr_data_secondary_r <= 8'd0;
            wr_en_secondary_r <= 1'b0;
        end else begin
            // Seleciona origem dos sinais
            rd_addr_primary_r <= reset_active ? reset_addr_counter :
                                dec_active ? rd_addr_dec :
                                avg_active ? mem_read_addr_avg :
                                nn_active ? rd_addr_nn :
                                addr_counter_repl;
            
            wr_addr_secondary_r <= reset_active ? reset_addr_counter :
                                  dec_active ? wr_addr_dec :
                                  avg_active ? out_addr_avg :
                                  nn_active ? wr_addr_nn :
                                  addr_write_repl;
            
            wr_data_secondary_r <= reset_active ? pixel_from_primary :
                                  dec_active ? wr_data_dec :
                                  avg_active ? out_data_avg :
                                  nn_active ? wr_data_nn :
                                  out_pixel_repl;
                                    
            wr_en_secondary_r <= reset_active || 
                               (dec_active && wren_dec) || 
                               (repl_active && wren_repl) ||
                               (avg_active && wren_avg) ||
                               (nn_active && wren_nn);
        end
    end
    
    assign rd_addr_primary = rd_addr_primary_r;
    assign wr_addr_secondary = wr_addr_secondary_r;
    assign wr_data_secondary = wr_data_secondary_r;
    assign wr_en_secondary = wr_en_secondary_r;
     
	 wire clock_75MHz;
	 
	 // Clock 75 MHz
	 clock_75MHz (
		  .refclk(clock_50MHz),   
		  .rst(1'b0),      
		  .outclk_0(clock_75MHz)
	 );
	  
	 // Divisor de clock 50 MHz → 25 MHz 
    clock_divider clock_div_inst (
        .clock_50MHz(clock_50MHz),
        .clock_25MHz(clock_25MHz)
    );

    // Replicação de pixels 
    pixel_replication repl_inst (
        .in_data(pixel_repl_r),
        .out_data(replicated_pixels)
    );
    
    // Controle de endereços para replicação
    address_pixel_replication addr_repl_inst (
        .clk(clock_25MHz),
        .rst(~internal_rst),
        .start(start_repl_sig),
        .in_data(replicated_pixels),
        .rd_address(addr_counter_repl),
        .wr_address(addr_write_repl),
        .wr_data(out_pixel_repl),
        .wren(wren_repl),
        .done(done_repl),
        .pixel_done(pixel_done_repl)
    );

    // Decimação 
    pixel_decimation dec_inst (
        .clk(clock_25MHz),
        .rst(~internal_rst),
        .start(start_dec_sig),
        .pixel_data(pixel_from_primary),
        .rd_address(rd_addr_dec),
        .wr_address(wr_addr_dec),
        .wr_data(wr_data_dec),
        .wren(wren_dec),
        .done(done_dec)
    );

    // Contador de endereços para média de blocos
    address_counter_avg addr_counter_avg_inst (
        .clk(clock_25MHz),
        .rst(~internal_rst),
        .en(done_avg),
        .start(start_avg_sig),
        .value(in_addr_avg),
        .processing(processing_avg)
    );

    // Controle da média de blocos 
    address_block_average block_avg_ctrl (
        .clk(clock_25MHz),
        .rst(~internal_rst),
        .in_address(in_addr_avg),
        .in_data(pixel_from_primary),
        .mem_read_addr(mem_read_addr_avg),
        .out_address(out_addr_avg),
        .out_wren(wren_avg),
        .done(done_avg),
        .val00(val00),
        .val01(val01),
        .val10(val10),
        .val11(val11)
    );

    // Calcula média de 4 pixels
    block_average block_avg_calc (
        .val00(val00),
        .val01(val01),
        .val10(val10),
        .val11(val11),
        .enable(1'b1),
        .media_out(out_data_avg)
    );

    // Interpolação por vizinho mais próximo
    nearest_neighbor nn_inst (
        .clk(clock_25MHz),
        .rst(~internal_rst),
        .start(start_nn_sig),
        .pixel_data(pixel_from_primary),
        .rd_address(rd_addr_nn),
        .wr_address(wr_addr_nn),
        .wr_data(wr_data_nn),
        .wren(wren_nn),
        .done(done_nn)
    );

    // Memória primária (imagem original)
    primary_memory primary_mem_inst (
        .address(rd_addr_primary),
        .clock(clock_25MHz),
        .data(8'd0),
        .rden(1'b1),
        .wren(1'b0),
        .q(pixel_from_primary)
    );

    // Memória secundária (imagem processada)
    secondary_memory secondary_mem_inst (
        .data(wr_data_secondary),
        .rd_aclr(1'b0),
        .rdaddress(rd_addr_vga),
        .rdclock(clock_25MHz),
        .rden(1'b1),
        .wraddress(wr_addr_secondary),
        .wrclock(clock_75MHz),
        .wren(wr_en_secondary),
        .q(q)
    );

    // Controlador VGA 
    vga_controller vga_ctrl_inst (
        .clock(clock_25MHz),
        .next_x(next_x),
        .next_y(next_y),
        .data(q),
        .decimation_mode(display_mode),
        .rdaddress(rd_addr_vga),
        .color(color)
    );

    // Driver VGA 
    vga_driver vga_driver_inst (
        .clock(clock_25MHz),
        .reset(1'b0),
        .color_in(color),
        .next_x(next_x),
        .next_y(next_y),
        .hsync(hsync),
        .vsync(vsync),
        .red(red),
        .green(green),
        .blue(blue),
        .sync(sync),
        .clk(clk),
        .blank(blank)
    );
	 
endmodule 