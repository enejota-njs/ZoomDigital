module address_pixel_replication (
    input  wire clk,
    input  wire rst,
    input  wire start,
    input  wire [31:0] in_data,    
    output reg  [16:0] rd_address, 
    output reg  [16:0] wr_address, 
    output reg  [7:0]  wr_data,   
    output reg  wren,            
    output reg  done,             
    output reg  pixel_done        
);

    // Estados do FSM
    localparam IDLE   = 3'd0;
    localparam READ   = 3'd1;
    localparam WRITE0 = 3'd2;
    localparam WRITE1 = 3'd3;
    localparam WRITE2 = 3'd4;
    localparam WRITE3 = 3'd5;
    localparam NEXT   = 3'd6;
    
    reg [2:0] state;
    reg [16:0] pixel_count;  // contador de pixels processados
    reg [8:0] row_in;        // linha (0..119)
    reg [8:0] col_in;        // coluna (0..159)
    reg [16:0] base_out;     // base de escrita para replicação
    reg [31:0] pixel_data;   // pixel expandido (4 cópias)

    always @(posedge clk) begin
        if (rst) begin
            // reset geral
            state <= IDLE;
            rd_address <= 17'd0;
            wr_address <= 17'd0;
            wr_data <= 8'd0;
            wren <= 1'b0;
            done <= 1'b0;
            pixel_done <= 1'b0;
            pixel_count <= 17'd0;
            pixel_data <= 32'd0;
        end else begin
            case (state)
                IDLE: begin
                    // espera start
                    wren <= 1'b0;
                    done <= 1'b0;
                    pixel_done <= 1'b0;
                    pixel_count <= 17'd0;
                    if (start) state <= READ;
                end
                
                READ: begin
                    // calcula posição do pixel (160x120)
                    row_in = pixel_count / 160;
                    col_in = pixel_count % 160;
                    
                    // endereço de leitura na imagem original (320x240)
                    rd_address <= row_in * 320 + col_in;
                    pixel_data <= in_data;
                    
                    // calcula endereço base da saída (pixel vira bloco 2x2)
                    base_out = (row_in * 2) * 320 + (col_in * 2);
                    
                    state <= WRITE0;
                    pixel_done <= 1'b0;
                end
                
                WRITE0: begin
                    // escreve canto superior esquerdo
                    wr_address <= base_out;
                    wr_data <= pixel_data[7:0];
                    wren <= 1'b1;
                    state <= WRITE1;
                end
                
                WRITE1: begin
                    // escreve canto superior direito
                    wr_address <= base_out + 1;
                    wr_data <= pixel_data[15:8];
                    wren <= 1'b1;
                    state <= WRITE2;
                end
                
                WRITE2: begin
                    // escreve canto inferior esquerdo
                    wr_address <= base_out + 320;
                    wr_data <= pixel_data[23:16];
                    wren <= 1'b1;
                    state <= WRITE3;
                end
                
                WRITE3: begin
                    // escreve canto inferior direito
                    wr_address <= base_out + 321;
                    wr_data <= pixel_data[31:24];
                    wren <= 1'b1;
                    state <= NEXT;
                end
                
                NEXT: begin
                    // avança pro próximo pixel
                    wren <= 1'b0;
                    pixel_done <= 1'b1;
                    
                    if (pixel_count >= 17'd19199) begin 
                        done <= 1'b1;
                        state <= IDLE;
                    end else begin
                        pixel_count <= pixel_count + 1;
                        state <= READ;
                    end
                end
                
                default: state <= IDLE;
            endcase
        end
    end
endmodule
