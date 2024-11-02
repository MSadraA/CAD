module comparator(a, b, lt);

	input [10:0] a, b;
	output lt;

	assign lt = (a >= b) ? 1'b1 : 1'b0;

endmodule
