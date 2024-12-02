module or_gate
(
    input [3:0] a,
    output y
);
    C2 or_inst (
        .A0(a[1]),
        .A1(a[3]),
        .B0(a[1]),
        .B1(a[2]),
        .D({a[0], 1'b1, 1'b1, 1'b1}),
        .out(y)
    );
endmodule