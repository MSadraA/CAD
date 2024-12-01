module shift_reg_16bit_new (
    input clk,
    input rst,
    input ld,
    input shl_en,
    input shr_en,
    input [15:0] par_in,
    input ser_in_l,
    output reg [15:0] par_out,
    output MSB_out,
    output LSB_out
);
    wire shift_select, load_select;
    wire [15:0] next_par_out;

    c1 shift_decision(
        .A0(par_out[15:1]),
        .A1({par_out[14:0], 1'b0}),
        .SA(shl_en),
        .B0(par_out[15:1]),
        .B1(par_in),
        .SB(ld),
        .S0(shr_en),
        .S1(ld | shl_en),
        .f(next_par_out)
    );

    always @(posedge clk or posedge rst) begin
        if (rst)
            par_out <= 16'b0;
        else
            par_out <= next_par_out;
    end

    assign MSB_out = par_out[15];
    assign LSB_out = par_out[0];
endmodule