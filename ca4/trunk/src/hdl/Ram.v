module RAM
  # (parameter ADDR_WIDTH = 4,
     parameter DATA_WIDTH = 32,
     parameter DEPTH = 16
    )

  ( 	input clk,
   		input [ADDR_WIDTH-1:0] raddr,
        input [ADDR_WIDTH-1:0] waddr,
        input [DATA_WIDTH_WIDTH-1:0] din,
   		output [DATA_WIDTH-1:0]	dout,
   		input wen,
   		input ren
  );

  reg [DATA_WIDTH-1:0] 	tmp_data;
  reg [DATA_WIDTH-1:0] 	mem [DEPTH];

  always @ (posedge clk || posedge wen) begin
    if (wen)
      mem[waddr] <= din;
  end

  always @ (posedge clk || ren) begin
    if (ren)
    	tmp_data <= mem[raddr];
  end

  assign data = tmp_data;
endmodule
