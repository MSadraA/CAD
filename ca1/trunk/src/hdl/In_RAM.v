module in_ram(
	    input clk,
	    input [3:0]address,
	    output reg [15:0]data_out
	);

	reg [15:0] in_ram_block [0:15];

	initial $readmemb("data_in.txt", in_ram_block);

	always @(posedge clk) begin
		data_out <= in_ram_block[address];
	end
endmodule