module counter_4bit(
    input clk,
    input rst,
    input up_cnt_en,
    input down_cnt_en,
    input [3:0] par_in,
    output [3:0] par_out,
    output wire carry_out
);
    wire [3:0] adder_out;
    wire [3:0] counter;
    wire co_add;

    adder adder_inst(.in1(counter), .in2(4'b0000), .cin1(up_cnt_en), .cin2(down_cnt_en), .out(adder_out), .co(co));


    genvar i;

    generate
        for (i = 0; i < 4; i = i + 1) begin : register_block
            S2 reg_inst (
                .A0(up_cnt_en),
                .B0(up_cnt_en),
                .A1(load),
                .B1(load),
                .D({par_in[i], par_in[i], adder_out[i], counter[i]}),
                .CLK(clk),
                .CLR(rst),
                .out(counter[i])
            );
        end
    endgenerate


endmodule

