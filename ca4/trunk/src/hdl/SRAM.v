module SRAM
  # (parameter ADDR_WIDTH = 4,
     parameter DATA_WIDTH = 32,
     parameter DEPTH = 16
    )

  ( 	input clk,
   		input [ADDR_WIDTH-1:0] raddr,
        input [ADDR_WIDTH-1:0] waddr,
        input [DATA_WIDTH_WIDTH-1:0] din,
   		output [DATA_WIDTH-1:0]	dout,
   		input chip_en,
   		input wen,
   		input ren
  );

  reg [DATA_WIDTH-1:0] 	tmp_data;
  reg [DATA_WIDTH-1:0] 	mem [DEPTH];

  always @ (posedge clk) begin
    if (chip_en & wen)
      mem[waddr] <= din;
  end

  always @ (posedge clk) begin
    if (chip_en & ren)
    	tmp_data <= mem[raddr];
  end

  assign data = tmp_data;
endmodule