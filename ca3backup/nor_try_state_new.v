module nor_try_state_new (
    input en,
    input a,
    input b,
    output c
);
    wire temp_out;

    s1 nor_logic(
        .D00(1'b0),
        .D01(~(a | b)),
        .D10(1'b0),
        .D11(1'b0),
        .A1(en),
        .B1(1'b0),
        .A0(1'b0),
        .clr(1'b0),
        .clk(1'b0),
        .out(temp_out)
    );

    assign c = temp_out;
endmodule