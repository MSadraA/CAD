module inv_mod(
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