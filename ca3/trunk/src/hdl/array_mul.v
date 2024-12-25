module array_mul (
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


    And and_inst (
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
    Not not_co
    (
        .a(co),
        .b(inv_co)
    );

    wire or_pi_ci;
    Or or_inst (
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



