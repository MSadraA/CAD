module nor_try_state (
    input en,
    input a,
    input b,
    output c
);
    wire temp_out;

    S1 nor_logic(
        .D({1'b0, ~(a | b), 1'b0, 1'b0 }),
        .A1(en),
        .B1(1'b0),
        .A0(1'b0),
        .B0(1'b0),
        .clr(1'b0),
        .clk(1'b0),
        .out(temp_out)
    );

    assign c = temp_out;
endmodule