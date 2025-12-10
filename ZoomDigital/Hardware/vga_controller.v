module vga_controller (
    input clock,
    input [9:0] next_x,
    input [9:0] next_y,
    input [7:0] data,
    output reg [16:0] rdaddress,
    output reg [7:0] color
);
    
    reg in_area;
    
    always @(*) begin
            // MODO 320×240 centralizado
            if ((next_x >= 160) && (next_x < 480) &&
                (next_y >= 120) && (next_y < 360)) begin
                in_area = 1'b1;
                rdaddress = (next_y - 120) * 320 + (next_x - 157);
            end else begin
                in_area = 1'b0;
                rdaddress = 17'd0;
            end
    end
    
    always @(posedge clock) begin
        color <= in_area ? data : 8'd0;
    end
    
endmodule