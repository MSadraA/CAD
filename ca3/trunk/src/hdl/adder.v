module adder (
    input wire [3:0] in,
    input wire up,
    input wire down,
    output wire [3:0] out,
    output wire co
);
    // mod = 0 --> add
    // mod = 1 --> subtract

    wire [4:0] carry;
    wire [3:0] in2;
    assign carry[0] = 1'b0;

    wire extend , en;

    C2 extend_inst (
        .A0(up),
        .A1(up),
        .B0(up),
        .B1(down),
        .D({1'b0, 1'b1, 1'b0, 1'b0}),
        .out(extend)
    );
    
    Or or_inst (
        .a(up),
        .b(down),
        .y(en)
    );

    assign in2 = {extend, extend, extend, en};

    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : add_block
            adder_1bit u_adder (
                .A(in[i]),
                .B(in2[i]),
                .Cin(carry[i]),
                .Sum(out[i]),
                .Cout(carry[i+1])
            );
        end
    endgenerate

    assign co = carry[4];
endmodule
