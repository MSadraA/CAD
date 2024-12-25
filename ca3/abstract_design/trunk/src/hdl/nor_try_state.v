module nor_try_state (
    input en,
    input a,
    input b,
    output c
);
    assign c = (en) ? ~(a | b): 1'b0;
endmodule