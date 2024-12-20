module multiplier #(
	parameter SIZE = 8,
) (
	input [SIZE - 1 : 0] par_in1,
	input [SIZE - 1 : 0] par_in2,
	output [(2*SIZE) - 1 : 0] par_out
);
	assign par_out = par_in1 * par_in2;
endmodule