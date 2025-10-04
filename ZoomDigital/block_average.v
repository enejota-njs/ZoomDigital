module block_average (
    input wire [7:0] val00,
    input wire [7:0] val01,
    input wire [7:0] val10,
    input wire [7:0] val11,
    input wire       enable,
    output reg [7:0] media_out
);
    wire [9:0] soma;
    
    assign soma = val00 + val01 + val10 + val11;
    
    always @(*) begin
        if (enable) begin
            media_out = soma[9:2];  // Divide por 4 (shift right 2)
        end else begin
            media_out = 8'd0;
        end
    end
endmodule