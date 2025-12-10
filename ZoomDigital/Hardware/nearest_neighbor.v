module nearest_neighbor (
    input  wire        clk,
    input  wire        rst,
    input  wire        start,
    input  wire [7:0]  pixel_data,
	 input  wire [7:0]  offset_x,
	 input  wire [7:0]  offset_y,
    output reg  [16:0] rd_address,
    output reg  [16:0] wr_address,
    output reg  [7:0]  wr_data,
    output reg         wren,
    output reg         done
);

    // Estados da máquina
    localparam IDLE       = 3'd0;
    localparam READ_PIXEL = 3'd1;
    localparam WRITE_00   = 3'd2;
    localparam WRITE_01   = 3'd3;
    localparam WRITE_10   = 3'd4;
    localparam WRITE_11   = 3'd5;
    localparam DONE_ST    = 3'd6;
    
    reg [2:0] state;
    reg [7:0] x_in;          // Posição X na imagem 160x120 (0-159)
    reg [6:0] y_in;          // Posição Y na imagem 160x120 (0-119)
    reg [7:0] pixel_buffer;  // Buffer para armazenar o pixel lido
    
    // Coordenadas de saída na imagem 320x240
    wire [8:0] x_out_base;
    wire [7:0] y_out_base;
    
    assign x_out_base = {x_in, 1'b0};  // x_in * 2
    assign y_out_base = {y_in, 1'b0};  // y_in * 2
    
    // Cálculo de endereços
    wire [16:0] addr_in;
    wire [16:0] addr_out_00, addr_out_01, addr_out_10, addr_out_11;
	 
	 localparam X_OFFSET = 8'd80;   // Zoom centralizado
	 localparam Y_OFFSET = 7'd60;

	 wire [8:0] x = x_in + offset_x;  // 80 → 239
	 wire [7:0] y = y_in + offset_y;  // 60 → 179
    
    // Endereço de entrada: y_in * 160 + x_in
    assign addr_in = (y * 320) + x;
    
    // Endereços de saída (cada pixel de entrada gera 4 pixels de saída)
    assign addr_out_00 = (y_out_base * 320) + x_out_base;           // (2y, 2x)
    assign addr_out_01 = (y_out_base * 320) + x_out_base + 1;       // (2y, 2x+1)
    assign addr_out_10 = ((y_out_base + 1) * 320) + x_out_base;     // (2y+1, 2x)
    assign addr_out_11 = ((y_out_base + 1) * 320) + x_out_base + 1; // (2y+1, 2x+1)
    
    always @(posedge clk) begin
        if (rst) begin
            state <= IDLE;
            rd_address <= 17'd0;
            wr_address <= 17'd0;
            wr_data <= 8'd0;
            wren <= 1'b0;
            done <= 1'b0;
            x_in <= 8'd0;
            y_in <= 7'd0;
            pixel_buffer <= 8'd0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 1'b0;
                    wren <= 1'b0;
                    if (start) begin
                        x_in <= 8'd0;
                        y_in <= 7'd0;
                        rd_address <= 17'd0;
                        state <= READ_PIXEL;
                    end
                end
                
                READ_PIXEL: begin
                    // Lê o pixel da memória primária
                    rd_address <= addr_in;
                    pixel_buffer <= pixel_data;
                    state <= WRITE_00;
                end
                
                WRITE_00: begin
                    // Escreve o pixel replicado na posição (2y, 2x)
                    wr_address <= addr_out_00;
                    wr_data <= pixel_buffer;
                    wren <= 1'b1;
                    state <= WRITE_01;
                end
                
                WRITE_01: begin
                    // Escreve o pixel replicado na posição (2y, 2x+1)
                    wr_address <= addr_out_01;
                    wr_data <= pixel_buffer;
                    wren <= 1'b1;
                    state <= WRITE_10;
                end
                
                WRITE_10: begin
                    // Escreve o pixel replicado na posição (2y+1, 2x)
                    wr_address <= addr_out_10;
                    wr_data <= pixel_buffer;
                    wren <= 1'b1;
                    state <= WRITE_11;
                end
                
                WRITE_11: begin
                    // Escreve o pixel replicado na posição (2y+1, 2x+1)
                    wr_address <= addr_out_11;
                    wr_data <= pixel_buffer;
                    wren <= 1'b1;
                    
                    // Avança para o próximo pixel
                    if (x_in == 8'd159) begin
                        x_in <= 8'd0;
                        if (y_in == 7'd119) begin
                            // Terminou toda a imagem
                            state <= DONE_ST;
                        end else begin
                            y_in <= y_in + 1;
                            state <= READ_PIXEL;
                        end
                    end else begin
                        x_in <= x_in + 1;
                        state <= READ_PIXEL;
                    end
                end
                
                DONE_ST: begin
                    wren <= 1'b0;
                    done <= 1'b1;
                    state <= IDLE;
                end
                
                default: begin
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule