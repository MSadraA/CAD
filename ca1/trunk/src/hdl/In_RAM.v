module ram(
	    input clk,
	    input [4:0]address,
	    output reg [15:0]data_out
	);

	reg [15:0]ram_block[0:15];

	initial $readmemb("data_in.mem", ram_block);

	always @(posedge clk) begin
		data_out <= ram_block[address]
	end
endmodule