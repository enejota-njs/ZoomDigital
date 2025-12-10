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

    // Estados do FSM
    localparam IDLE  = 2'd0;
    localparam READ  = 2'd1;
    localparam WAIT  = 2'd2;
    localparam WRITE = 2'd3;

    reg [1:0] state;
    reg [7:0] out_x;  // 0 a 159
    reg [7:0] out_y;  // 0 a 119

    always @(posedge clk) begin
        if (rst) begin
            state <= IDLE;
            rd_address <= 17'd0;
            wr_address <= 17'd0;
            wr_data <= 8'd0;
            wren <= 1'b0;
            done <= 1'b0;
            out_x <= 8'd0;
            out_y <= 8'd0;
        end else begin
            case (state)
                IDLE: begin
                    wren <= 1'b0;
                    done <= 1'b0;
                    out_x <= 8'd0;
                    out_y <= 8'd0;
                    if (start) begin
                        // Primeiro endereço de leitura: (0,0) * 2 = (0,0)
                        rd_address <= 17'd0;
                        state <= READ;
                    end
                end

                READ: begin
                    // Calcula endereço de leitura: (out_y*2) * 320 + (out_x*2)
                    rd_address <= (out_y << 1) * 320 + (out_x << 1);
                    wren <= 1'b0;
                    state <= WAIT;
                end

                WAIT: begin
                    // Espera memória responder
                    state <= WRITE;
                end

                WRITE: begin
                    // Escreve na posição (out_y, out_x) da memória 320x240
                    // Para ocupar o primeiro quadrante: out_y * 320 + out_x
                    wr_address <= out_y * 320 + out_x;
                    wr_data <= pixel_data;
                    wren <= 1'b1;
                    
                    // Avança para próximo pixel de saída
                    if (out_x == 8'd159) begin
                        out_x <= 8'd0;
                        if (out_y == 8'd119) begin
                            // Terminou
                            done <= 1'b1;
                            state <= IDLE;
                        end else begin
                            out_y <= out_y + 8'd1;
                            state <= READ;
                        end
                    end else begin
                        out_x <= out_x + 8'd1;
                        state <= READ;
                    end
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule