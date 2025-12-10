module address_counter_avg (
    input wire clk,
    input wire rst,
    input wire en,          
    input wire start,       
    output reg [16:0] value,
    output reg processing 
);
    
    reg started; 

    always @(posedge clk) begin
        if (rst) begin
            // reset geral
            value <= 17'd0;
            processing <= 1'b0;
            started <= 1'b0;
        end else begin
            if (start && !started) begin
                // inicia contagem
                processing <= 1'b1;
                started <= 1'b1;
                value <= 17'd0;
            end
            
            if (processing && en) begin
                if (value < 17'd19199) begin
                    value <= value + 1;
                end else begin
                    processing <= 1'b0;
                    started <= 1'b0;
                end
            end
        end
    end
    
endmodule
