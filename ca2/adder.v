module adder #(
	parameter SIZE = 8,
	parameter BIT = $clog2(SIZE)
) (
	input [BIT - 1 : 0] par_in,
	input [BIT - 1 : 0] imm,
	output [BIT - 1 : 0] par_out
);
	assign par_out = par_in + imm;
endmodule
