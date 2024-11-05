`timescale 1ns/1ps

module tb();

    // Parameters
    parameter K = 2;
    parameter SIZE = 8;
    parameter BIT = $clog2(K);
    reg [$clog2(SIZE) - 1 : 0] in =  3'd5;

    wire [($clog2(SIZE) * K) - 1:0] num_out;
    wire [($clog2(SIZE) + $clog2(K)) * K - 1 : 0] out;

    Generator #(.SIZE(8) , .K(2))
    generator (
        .num_in(in),
        .num_out(num_out)
    );

    Concat #(.SIZE(8) , .K(2))
    concat 
    (
        .in(num_out),
        .out(out)
    );

    initial #10 $stop;
    

endmodule
