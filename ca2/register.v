module register #(
	parameter SIZE = 8,
	parameter BIT = $clog2(SIZE)
) 
(
	input clk,
	input rst,
	input ld,
	input [BIT - 1:0] par_in,
	output reg [BIT - 1 :0] par_out
);
	always @(posedge clk) begin
		if(rst)
			par_out <= 0;
		else if(ld)
			par_out <= par_in;
	end
endmodule