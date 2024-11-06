module comparator #(
	parameter SIZE = 8,
	parameter BIT = $clog2(SIZE)
) (
	input [BIT - 1 : 0] a,
	input [BIT -1 : 0 ] b,
	output bte
);
	assign bte = (a >= b) ? 1'b1:1'b0;
endmodule