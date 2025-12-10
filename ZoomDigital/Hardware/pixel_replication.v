module pixel_replication (
    input  [7:0] in_data,
    output [31:0] out_data
);
    assign out_data = {in_data, in_data, in_data, in_data};
endmodule