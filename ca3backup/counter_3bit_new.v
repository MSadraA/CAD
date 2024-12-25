module counter_4bit_new(
    input clk,
    input rst,
    input en,
    input load,
    input [3:0] in,
    output wire co
);
    wire [3:0] adder_out;
    wire [3:0] counter;
    wire co_add;

    adder adder_inst(.in1(counter), .in2(4'b0000), .cin(en), .out(adder_out), .co(co));


    genvar i;

    generate
        for (i = 0; i < 4; i = i + 1) begin : register_block
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
