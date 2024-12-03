module counter_4bit(
    input clk,
    input rst,
    input up_cnt_en,
    input down_cnt_en,
    output [3:0] par_out,
    output wire carry_out
);
    wire [3:0] adder_out;

    adder adder_inst(.in(par_out), .up(up_cnt_en), .down(down_cnt_en), .out(adder_out), .co());

    shift_reg #(4) reg_inst(.clk(clk), .rst(rst), .ld(1'b1), .shen(1'b0), .par_in(adder_out), .ser_in(1'b0), .par_out(par_out) , .MSB_out());

    assign carry_out = par_out[3];

endmodule

