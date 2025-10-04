module address_block_average (
    input wire clk,
    input wire rst,
    input wire [16:0] in_address,      
    input wire [7:0] in_data,          
    output reg [16:0] mem_read_addr,   
    output reg [16:0] out_address,    
    output reg out_wren,               
    output reg done,                  
    output reg [7:0] val00,            
    output reg [7:0] val01,            
    output reg [7:0] val10,            
    output reg [7:0] val11             
);

    // Estados da máquina
    localparam IDLE        = 3'd0;
    localparam READ_00     = 3'd1;
    localparam READ_01     = 3'd2;
    localparam READ_10     = 3'd3;
    localparam READ_11     = 3'd4;
    localparam WRITE       = 3'd5;

    reg [2:0] state = IDLE;
    reg [8:0] row, col;
    reg [16:0] base_addr;
    reg [1:0] read_delay;

    // Calcula linha e coluna do bloco 2x2 na imagem original
    always @(*) begin
        // in_address: 0-19199 representa blocos 160x120
        col = (in_address % 160) * 2;  // Coluna base: 0, 2, 4, ..., 318
        row = (in_address / 160) * 2;  // Linha base: 0, 2, 4, ..., 238
        base_addr = row * 320 + col;  
    end

    // Máquina de estados principal
    always @(posedge clk) begin
        if (rst) begin
            state <= IDLE;
            val00 <= 8'd0;
            val01 <= 8'd0;
            val10 <= 8'd0;
            val11 <= 8'd0;
            mem_read_addr <= 17'd0;
            out_address <= 17'd0;
            out_wren <= 1'b0;
            done <= 1'b0;
            read_delay <= 2'd0;
        end else begin
            // Valores padrão
            out_wren <= 1'b0;
            done <= 1'b0;
            
            case (state)
                IDLE: begin
                    if (in_address < 19200) begin
                        state <= READ_00;
                        mem_read_addr <= base_addr;  // Pixel (row, col)
                        read_delay <= 2'd1;
                    end
                end
                
                READ_00: begin
                    if (read_delay > 0) begin
                        read_delay <= read_delay - 1;
                    end else begin
                        val00 <= in_data;
                        mem_read_addr <= base_addr + 1;  // Pixel (row, col+1)
                        read_delay <= 2'd1;
                        state <= READ_01;
                    end
                end
                
                READ_01: begin
                    if (read_delay > 0) begin
                        read_delay <= read_delay - 1;
                    end else begin
                        val01 <= in_data;
                        mem_read_addr <= base_addr + 320;  // Pixel (row+1, col)
                        read_delay <= 2'd1;
                        state <= READ_10;
                    end
                end
                
                READ_10: begin
                    if (read_delay > 0) begin
                        read_delay <= read_delay - 1;
                    end else begin
                        val10 <= in_data;
                        mem_read_addr <= base_addr + 321;  // Pixel (row+1, col+1)
                        read_delay <= 2'd1;
                        state <= READ_11;
                    end
                end
                
                READ_11: begin
                    if (read_delay > 0) begin
                        read_delay <= read_delay - 1;
                    end else begin
                        val11 <= in_data;
                        out_address <= in_address;  // Endereço na imagem reduzida
                        state <= WRITE;
                    end
                end
                
                WRITE: begin
                    out_wren <= 1'b1;
                    done <= 1'b1;
                    state <= IDLE;
                end
                
                default: state <= IDLE;
            endcase
        end
    end

endmodule