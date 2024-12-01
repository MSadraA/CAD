module adder (
    input wire [15:0] in1,
    input wire [15:0] in2,
    input wire cin,
    output wire [15:0] out,
    output wire co
);
    wire [WIDTH:0] carry;
    assign carry[0] = cin;

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : gen_adder
            adder_1bit u_adder (
                .A(in1[i]),
                .B(in2[i]),
                .Cin(carry[i]),
                .Sum(out[i]),
                .Cout(carry[i+1])
            );
        end
    endgenerate

    assign co = carry[16];
endmodule

module adder_1bit (
    input wire A,
    input wire B,
    input wire Cin,
    output wire Sum,
    output wire Cout
);

    wire A_inv;
    not_mod not_inst (
        .A(A),
        .out(A_inv)
    );

    C1 sum (
        .A0(A), .A1(A_inv),
        .SA(B),
        .B0(A_inv), .B1(A),
        .SB(B),
        .S0(Cin), .S1(Cin),
        .F(Sum)
    );

    C1 carry (
        .A0(1'b0), .A1(A),
        .SA(B),
        .B0(A), .B1(1'b1),
        .SB(B),
        .S0(Cin), .S1(Cin),
        .F(Cout)
    );
endmodule