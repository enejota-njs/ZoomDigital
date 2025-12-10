module decoder (
    input         clock_25MHz,
    input         enable_instruction,      
    input  [31:0] instruction, 
    output [7:0] offset_y,
    output [7:0] offset_x, 
    output reg    start_repl,  
    output reg    start_dec,    
    output reg    start_avg,    
    output reg    start_nn, 
    output reg    wren_image,
    output [16:0] address_image,
    output [7:0]  data_image,
    output reg    start_reset,
    output reg    start_load,
    output [16:0] address_load
);

    reg [31:0] reg_instruction;
    
    // Registradores fixos para offset
    reg [7:0] reg_offset_y;
    reg [7:0] reg_offset_x;

    always @(posedge clock_25MHz) begin
        if (enable_instruction)
            reg_instruction <= instruction;  
        else
            reg_instruction <= 32'b0;       
    end

    wire [2:0] OPCODE;

    assign OPCODE = reg_instruction[31:29];
    assign address_image = reg_instruction[24:8];
    assign data_image    = reg_instruction[7:0];
    
    assign address_load = reg_instruction[24:8];
    
    // Saídas apontam para os registradores fixos
    assign offset_y = reg_offset_y;
    assign offset_x = reg_offset_x;
    
    // Armazena offset quando recebe instrução específica (OPCODE 010 ou 011)
    always @(posedge clock_25MHz) begin
        if (enable_instruction) begin
            if (instruction[31:29] == 3'b010 || instruction[31:29] == 3'b011) begin
                reg_offset_y <= instruction[7:0];
                reg_offset_x <= instruction[15:8];
            end
        end
    end
    
    always @(*) begin
        start_repl = 1'b1;
        start_dec  = 1'b1;
        start_avg  = 1'b1;
        start_nn   = 1'b1;
        wren_image = 1'b0;
        start_reset = 1'b0;
        start_load = 1'b0;
          
        case (OPCODE)
            3'b001: begin 
                wren_image = 1'b1;    
            end
            3'b010: begin
                start_nn   = 1'b0;
            end
            3'b011: begin
                start_repl = 1'b0;
            end
            3'b100: begin
                start_dec  = 1'b0;     
            end
            3'b101: begin
                start_avg  = 1'b0;    
            end
            3'b110: begin
                start_reset = 1'b1;
            end
            3'b111: begin
                start_load = 1'b1;
            end
            default: begin
            end
        endcase
    end

endmodule