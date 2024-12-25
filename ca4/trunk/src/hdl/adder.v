module adder #(
	parameter SIZE = 8
) (
	input [BIT - 1 : 0] par_in1,
	input [BIT - 1 : 0] par_in2,
	output [BIT - 1 : 0] par_out
);
	assign par_out = par_in1 + par_in2;
endmodule
