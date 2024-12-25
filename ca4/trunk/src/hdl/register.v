module register #(
	parameter SIZE = 8
) 
(
	input clk,
	input rst,
	input ld,
	input clr,
	input [SIZE - 1:0] par_in,
	output reg [SIZE - 1 :0] par_out
);
	always @(posedge clk) begin
		if(rst || clr)
			par_out <= 0;
		else if(ld)
			par_out <= par_in;
	end
endmodule