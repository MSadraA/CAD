module array_mul_16bit_new (
    input [7:0] a,
    input [7:0] b,
    output [15:0] mul
);
    // Using direct multiplication
    wire [15:0] temp_mul;

    c2 multiply_logic(
        .D00(a * b),
        .D01(a * b),
        .D10(a * b),
        .D11(a * b),
        .A1(1'b0),
        .B1(1'b0),
        .A0(1'b0),
        .B0(1'b0),
        .out(temp_mul)
    );

    assign mul = temp_mul;
endmodule









