module counter_3bit_new (
    input clk,
    input rst,
    input up_cnt_en,
    input down_cnt_en,
    output reg [2:0] par_out,
    output carry_out
);
    wire [2:0] next_par_out;

    s2 counter_logic(
        .D00(par_out),
        .D01(par_out + 1),
        .D10(par_out - 1),
        .D11(par_out),
        .A1(up_cnt_en),
        .B1(down_cnt_en),
        .A0(1'b1),
        .B0(1'b0),
        .clr(rst),
        .clk(clk),
        .out(next_par_out)
    );

    always @(posedge clk or posedge rst) begin
        if (rst)
            par_out <= 3'b0;
        else
            par_out <= next_par_out;
    end

    assign carry_out = ((par_out == 3'b111) && up_cnt_en) || ((par_out == 3'b000) && down_cnt_en);
endmodule
