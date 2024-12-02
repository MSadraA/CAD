module inv_and
(
    input a, b,
    output y
);
    C2 inv_and_inst (
        .A0(a),
        .A1(a),
        .B0(b),
        .B1(a),
        .D({1'b0, 1'b0, 1'b1, 1'b0}),
        .out(y)
    );
endmodule