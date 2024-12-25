module mux_2_to_1_1bit (
    input a,
    input b,
    input sel,
    output out
);

C1 mux_inst (
    .A0(a),
    .A1(b),
    .SA(sel),
    .B0(1'b1),
    .B1(1'b1),
    .SB(1'b1),
    .S0(1'b0),
    .S1(1'b0),
    .F(out)
);
    
endmodule