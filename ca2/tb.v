`timescale 1ns/1ps

module tb();

    // Parameters
    parameter K = 4;
    parameter SIZE = 16;
    parameter BIT = $clog2(K);
    reg [$clog2(SIZE) - 1 : 0] in =  4'd5;

    wire [($clog2(SIZE) * K) - 1:0] num_out;
    wire [($clog2(SIZE) + $clog2(K)) * K - 1 : 0] out;
    wire [$clog2(K)-1:0] final_result;   

    Generator #(.SIZE(16) , .K(4))
    generator (
        .num_in(in),
        .num_out(num_out)
    );

    Concat #(.SIZE(16) , .K(4))
    concat 
    (
        .in(num_out),
        .out(out)
    );

    Selector #(.SIZE(16) , .K(4))
    Selector
    (
        .N(4'd6) ,
        .inputs(out) ,
        .final_result(final_result)
    );

    initial #10 $stop;
    

endmodule
