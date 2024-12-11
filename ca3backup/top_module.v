module top_module (
    input clk,
    input rst,
    input start,
    input [15:0] x1,
    input [15:0] x2,
    output [31:0] out,
    output done
);

    wire ld1 , ld2 , sel , shift_left , shift_right , count_done , zero;
    controller controller1 (
        .clk(clk),
        .rst(rst),
        .start(start),
        .count_done(count_done),
        .ld1(ld1),
        .ld2(ld2),
        .sel(sel),
        .shift_left(shift_left),
        .shift_right(shift_right),
        .done(done),
        .zero(zero)
    );

    data_path data_path1 (
        .clk(clk),
        .rst(rst),
        .shift_left(shift_left),
        .shift_right(shift_right),
        .x1(x1),
        .x2(x2),
        .ld1(ld1),
        .ld2(ld2),
        .sel(sel),
        .out(out),
        .count_done(count_done),
        .zero(zero)
    );
endmodule