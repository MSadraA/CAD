module counter_3bit(
    input clk,
    input rst,
    input en,
    input load,
    input [2:0] in,
    output wire co
);
    wire [2:0] adder_out;
    wire [2:0] counter;
    wire co_add;

    adder adder_inst(.in1(counter), .in2(3'b000), .cin(en), .out(adder_out), .co(co));


    genvar i;

    generate
        for (i = 0; i < 3; i = i + 1) begin : register_block
            S2 reg_inst (
                .A0(en),
                .B0(en),
                .A1(load),
                .B1(load),
                .D({in[i], in[i], adder_out[i], counter[i]}),
                .CLK(clk),
                .CLR(rst),
                .out(counter[i])
            );
        end
    endgenerate


endmodule
