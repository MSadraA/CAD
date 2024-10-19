module ram(
	    input clk,
	    input write_enable,
	    input [3:0]address,
	    input [15:0]data_in,
	    output reg [15:0]data_out
	);

	reg [7:0]ram_block[0:15];

	always @(posedge clk) begin
	        if(write_enable)
	            ram_block[address] <= data_in;
	        else
	            data_out <= ram_block[address];
	end
endmodule