module If_Map_generator #(
    parameter FILTER_SIZE = 4,
    parameter STRIDE_SIZE = 2
    parameter SIZE = 16
)(
    input clk,
    input rst,
    input ld_head,
    input [STRIDE_SIZE -1 : 0] stride,
    input offset,
    input CLR,
    input cnt_en,
    input ld_row,
    output finish_row,
    output Raddr,
    output row_end
);
    wire [SIZE-1:0] in ,w1, head_reg_out, start_reg_out, r1, w3;
    register head_reg #(
        parameter SIZE = ($log2(HEIGHT))
    )(
        .clk(clk),
        .rst(rst),
        .ld(ld_head),
        .par_in(in),
        .par_out(head_reg_out)
    );

    Mux_2_to_1 mux2 #(
        parameter WIDTH = 16
    )(
        .sel(sel),
        .a(w1),
        .b(start_reg_out),
        .out(in)
    );

    register start_reg #(
        parameter SIZE = 16
    )(
        .clk(clk),
        .rst(rst),
        .ld(Ad),
        .par_in(in),
        .par_out(start_reg_out)
    );

    register end_reg #(
        parameter SIZE = 16
    )(
        .clk(clk),
        .rst(rst),
        .ld(Ad),
        .par_in(in),
        .par_out(end_reg_out)
    );

    Counter row_cnt #(
        parameter WIDTH = ($log2(row_number)+1)
    )(
        .clk(clk),
        .rst(rst),
        .clr(CLR),
        .inc(cnt_en),
        .dout(row_par_out),
        .cout(Ad)
    );

    register row_reg #(
        parameter SIZE = 16
    )(
        .clk(clk),
        .rst(rst),
        .ld(ld_row),
        .par_in(row_par_out),
        .par_out(r1)
    );


    assign w1 = stride + head_reg_out;
    assign Raddr = head_reg_out + offset;
    assign finish_row = (r1 == row_par_out) ? 1'b1 : 1'b0;
    assign w3 = FILTER_SIZE + head_reg_out;
    assign row_end = (w3 > end_reg_out) ? 1'b1 : 1'b0;
endmodule