module array_mul_16bit (
    input wire [7:0] a,
    input wire [7:0] b,
    output wire [15:0] mul
);
    
    wire [8:0][8:0] xv, yv, pv, cv;

    genvar i, j;

    generate
        for (i = 0; i < 8; i = i + 1) begin : row
            for (j = 0; j < 8; j = j + 1) begin : column
                bit_multiplier inst(
                    .xi(xv[i][j]),
                    .yi(yv[i][j]),
                    .pi(pv[i][j+1]),
                    .ci(cv[i][j]),
                    .xo(xv[i][j+1]),
                    .yo(yv[i+1][j]),
                    .po(pv[i+1][j]),
                    .co(cv[i][j+1])
                );
            end
        end
    endgenerate

    generate
        for (i = 0; i < 8; i = i + 1) begin : xv_gen
            assign xv[i][0] = a[i];
            assign cv[i][0] = 1'b0;
            assign pv[0][i + 1] = 1'b0;
            assign pv[i + 1][8] = cv[i][8];
            assign yv[0][i] = b[i];
            assign mul[i] = pv[i + 1][0];
            assign mul[i + 8] = pv[8][i + 1];
        end
    endgenerate

endmodule

module bit_multiplier
(
    input xi, yi, ci, pi,
    output xo, yo, co, po
);
    wire xy;
    assign xo = xi;
    assign yo = yi;


    // assign xy = xi & yi;
    // assign co = (pi & xy) | (pi & ci) | (xy & ci);
    // assign po = pi ^ xy ^ ci;

    and_mod and_inst (
        .a(xi),
        .b(yi),
        .y(xy)
    );

    C1 co_gen (
        .A0(1'b0),
        .A1(ci),
        .SA(xy),
        .B0(ci),
        .B1(1'b1),
        .SB(xy),
        .S0(pi),
        .S1(pi),
        .F(co)
    );

    wire inv_co;
    not_mod not_co
    (
        .A(co),
        .out(inv_co)
    );

    wire or_pi_ci;
    or_mod or_inst (
        .a(pi),
        .b(ci),
        .y(or_pi_ci)
    );

    C2 po_gen (
        .A0(pi),
        .B0(ci),
        .A1(xy),
        .B1(xy),
        .D({1'b1, inv_co, inv_co, or_pi_ci}),
        .out(po)
    );

endmodule


module xor_mod (
    input wire A,
    input wire B,
    output wire out
);

    C2 xor_inst (
        .A0(A),
        .B0(B),
        .A1(A),
        .B1(B),
        .D(4'b0100),
        .out(out)
    );

endmodule

module not_mod (
    input wire A,
    output wire out
);

    C1 not_inst (
        .A0(1'b1),
        .A1(1'b1),
        .SA(1'b1),
        .B0(1'b0),
        .B1(1'b0),
        .SB(1'b0),
        .S0(A),
        .S1(A),
        .F(out)
    );

endmodule

module nor_mod (
    input wire A,
    input wire B,
    output wire out
);

    C1 nor_inst (
        .A0(1'b1),
        .A1(1'b1),
        .SA(1'b1),
        .B0(1'b0),
        .B1(1'b0),
        .SB(1'b0),
        .S0(A),
        .S1(B),
        .F(out)
    );

endmodule

module or_mod
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

module and_mod
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









