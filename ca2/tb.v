`timescale 1ns/1ps

module tb();

    // Parameters
    parameter K = 4;
    parameter SIZE = 16;
    parameter BIT = $clog2(K);
    
    reg [$clog2(SIZE) - 1 : 0] in =  4'd14;

    wire [($clog2(SIZE) * K) - 1:0] num_out;
    wire [($clog2(SIZE) + $clog2(K)) * K - 1 : 0] out;
    wire [(SIZE * $clog2(K)) - 1:0] results;

    Generator #(.SIZE(SIZE) , .K(K))
    generator (
        .num_in(in),
        .num_out(num_out)
    );

    Concat #(.SIZE(SIZE) , .K(K))
    concat 
    (
        .in(num_out),
        .out(out)
    );

    Array_selector #(.SIZE(SIZE) , .K(K))
    array_selector
    (
        .inputs(out) ,
        .results(results)
    );

    initial #10 $stop;
    

endmodule
