module pixel_decimation (
    input  wire clk,
    input  wire rst,
    input  wire start,              
    input  wire [7:0] pixel_data,   
    output reg  [16:0] rd_address,  
    output reg  [16:0] wr_address,  
    output reg  [7:0] wr_data,      
    output reg  wren,               
    output reg  done               
);

    localparam ORIG_WIDTH = 320;
    localparam TOTAL_PIXELS = 19200; 

    // Estados do FSM
    localparam IDLE  = 2'd0;
    localparam READ  = 2'd1;
    localparam WRITE = 2'd2;

    reg [1:0] state;
    reg [16:0] pixel_count; // contador de pixels processados
    reg [8:0] row_orig;     // linha na imagem original
    reg [8:0] col_orig;     // coluna na imagem original

    always @(posedge clk) begin
        if (rst) begin
            // reset geral
            state <= IDLE;
            rd_address <= 17'd0;
            wr_address <= 17'd0;
            wr_data <= 8'd0;
            wren <= 1'b0;
            done <= 1'b0;
            pixel_count <= 17'd0;
        end else begin
            case (state)
                IDLE: begin
                    // espera pelo start
                    wren <= 1'b0;
                    done <= 1'b0;
                    pixel_count <= 17'd0;
                    if (start) state <= READ;
                end

                READ: begin
                    // pega pixel a cada 2 linhas e 2 colunas
                    row_orig <= (pixel_count / 160) << 1;
                    col_orig <= (pixel_count % 160) << 1;
                    
                    // endereço correspondente na imagem original
                    rd_address <= ((pixel_count / 160) << 1) * ORIG_WIDTH + 
                                  ((pixel_count % 160) << 1);
                    
                    state <= WRITE;
                end

                WRITE: begin
                    // escreve pixel reduzido na nova memória
                    wr_address <= pixel_count;
                    wr_data <= pixel_data;
                    wren <= 1'b1;
                    
                    if (pixel_count >= TOTAL_PIXELS - 1) begin
                        // terminou a redução
                        done <= 1'b1;
                        wren <= 1'b0;
                        state <= IDLE;
                    end else begin
                        // vai para o próximo pixel
                        pixel_count <= pixel_count + 17'd1;
                        state <= READ;
                    end
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule
