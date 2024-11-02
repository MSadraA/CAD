module comparator(a, b, bt);

	input [10:0] a, b;
	output lt;

	assign bt = (a >= b) ? 1'b1 : 1'b0;

endmodule
