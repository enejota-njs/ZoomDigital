module clock_divider (
	input clock_50MHz,
	output reg clock_25MHz
	);
	
	always @(posedge clock_50MHz) begin
		clock_25MHz <= ~clock_25MHz;
		end
	
endmodule