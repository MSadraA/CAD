module array_mul_16bit (
    input [7:0] a,
    input [7:0] b,
    output [15:0] mul
);
    assign mul = a * b;
endmodule