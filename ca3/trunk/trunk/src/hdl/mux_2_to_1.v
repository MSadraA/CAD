module mux_2_to_1 #(parameter Bit = 16)
(
    input wire [Bit - 1:0] a,
    input wire [ Bit - 1:0] b,
    input wire sel,
    output wire [Bit - 1:0] out
);

    genvar i;
    generate
        for (i = 0; i < Bit ; i = i + 1) begin : mux_block
            C1 mux_inst (
                .A0(a[i]),
                .A1(b[i]),
                .SA(sel),
                .B0(1'b1),
                .B1(1'b1),
                .SB(1'b1),
                .S0(1'b0),
                .S1(1'b0),
                .F(out[i])
            );
        end
    endgenerate

endmodule