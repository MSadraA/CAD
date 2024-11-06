module adder #(
	parameter K = 4
)	(a,b,w);

	input [K-1:0] a, b;
	output [K-1:0] w;

	assign w= a + b;

endmodule
