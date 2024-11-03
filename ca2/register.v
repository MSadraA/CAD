module register(clk, ld, pIn, pOut);

	input clk, ld;
	input [9:0] pIn;
	output reg [9:0] pOut;

	always@(posedge clk) begin
		if(ld)
			pOut <= pIn;
		else
			pOut <= pOut;
	end

endmodule	