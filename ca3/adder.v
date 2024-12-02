module adder (
    input wire [15:0] in1,
    input wire [15:0] in2,
    input wire cin1,
    input wire cin2,
    output wire [15:0] out,
    output wire co
);
    wire [15:0] b_mux;
    wire [16:0] carry;
    assign carry[0] = cin1;

    // Multiplex between in2 and its complement based on the condition
    assign b_mux = (cin1 && ~cin2) ? in2 : ~in2;

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : add_block
            adder_1bit u_adder (
                .A(in1[i]),
                .B(b_mux[i]),
                .Cin(carry[i]),
                .Sum(out[i]),
                .Cout(carry[i+1])
            );
        end
    endgenerate

    assign co = carry[16];
endmodule
