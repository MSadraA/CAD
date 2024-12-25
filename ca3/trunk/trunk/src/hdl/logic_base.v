module And_not
(
    input a, 
    input b,
    output y
);
    C2 inv_and_inst (
        .A0(b),
        .A1(a),
        .B0(b),
        .B1(a),
        .D({1'b0, 1'b1, 1'b0, 1'b0}),
        .out(y)
    );
endmodule

module Not(
    input a,
    output b
);
    C1 not_inst (
           .A0(1'b1),
           .A1(1'b1),
           .SA(1'b1),
           .B0(1'b0),
           .B1(1'b0),
           .SB(1'b0),
           .S0(a),
           .S1(a),
           .F(b)
    );
endmodule

module And
(
    input a, b,
    output y
);
    C1 and_inst (
        .A0(1'b0),
        .A1(b),
        .SA(a),
        .B0(1'b0),
        .B1(1'b0),
        .SB(1'b0),
        .S0(1'b0),
        .S1(1'b0),
        .F(y)
    );
endmodule

module nor_try_state (
    input en,
    input a,
    input b,
    output c
);
    wire temp_out;

    C2 nor_logic(
        .A0(en),
        .A1(a),
        .B0(en),
        .B1(b),
        .D({1'b0, 1'b0, 1'b1, 1'b0}),
        .out(c)
    );
endmodule

module Or
(
    input a, b,
    output y
);
    C1 or_inst (
        .A0(1'b0),
        .A1(1'b0),
        .SA(1'b0),
        .B0(1'b1),
        .B1(1'b1),
        .SB(1'b1),
        .S0(a),
        .S1(b),
        .F(y)
    );
endmodule

module or_4bit
(
    input [3:0] a,
    output y
);
    C2 or_inst (
        .A0(a[2]),
        .A1(a[0]),
        .B0(a[2]),
        .B1(a[1]),
        .D({1'b1 , 1'b1, 1'b1, a[3]}),
        .out(y)
    );
endmodule

