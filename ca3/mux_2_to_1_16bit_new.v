module mux_2_to_1_16bit_new (
    input [15:0] a,
    input [15:0] b,
    input sel,
    output [15:0] out
);
    wire [15:0] temp_out;

    c1 mux_logic(
        .A0(a),
        .A1(b),
        .SA(sel),
        .B0(16'b0),
        .B1(16'b0),
        .SB(1'b0),
        .S0(1'b0),
        .S1(sel),
        .f(temp_out)
    );

    assign out = temp_out;
endmodule