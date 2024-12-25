module shift_reg #(
    parameter WIDTH = 16
)  (
    input clk,
    input rst,
    input ld,
    input shen,
    input [WIDTH - 1:0] par_in,
    input ser_in,
    output [WIDTH - 1:0] par_out,
    output MSB_out
);

wire [WIDTH - 1:0] data;
genvar i;

generate
    for (i = 0; i < WIDTH; i = i + 1) begin : register_block
        S2 reg_inst (
            .A0(shen),
            .B0(shen),
            .A1(ld),
            .B1(ld),
            .D({par_in[i], par_in[i], (i == 0) ? ser_in : data[i-1], data[i]}),
            .clk(clk),
            .clr(rst),
            .out(data[i])
        );
    end
endgenerate

assign par_out = data;
assign MSB_out = data[WIDTH - 1];

endmodule