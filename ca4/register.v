module Register #(
	parameter WIDTH = 8
) 
(
	input clk,
	input rst,
	input ld,
	input clr,
	input [WIDTH - 1:0] par_in,
	output reg [WIDTH - 1 :0] par_out
);

always @(posedge clk or posedge rst) begin
	if (rst) begin
		par_out <= 0;
	end else begin
		if (clr) begin
			par_out <= 0;
		end else if (ld) begin
			par_out <= par_in;
		end
	end
end
endmodule