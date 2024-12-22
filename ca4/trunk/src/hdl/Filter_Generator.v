module Filter_Generator #(
    parameter HEIGHT = 16,
    parameter FILTER_SIZE = 8,
)(
    input clk,
    input rst,
    input filter_cnt_en,
    input ld_head,
    input index_cnt_en,
    input sel,
    input index_clr,
    output finish_filter,
    output Raddr,
    output filter_end
);

    wire filter_counter_out, head_reg_out, index_counter_out, mux_out, s1, s2;

    Counter filter_counter #(
        parameter WIDTH = 1
    )(
        .clk(clk),
        .rst(rst),
        .clr(1'b0),
        .inc(filter_cnt_en),
        .dout(filter_counter_out),
        .cout(),

    );

    Counter index_counter #(
        parameter WIDTH = 1
    )(
        .clk(clk),
        .rst(rst),
        .clr(index_clr),
        .inc(index_cnt_en),
        .dout(index_counter_out),
        .cout()
    );

    register head_reg #(
        parameter SIZE = 1
    )(
        .clk(clk),
        .rst(rst),
        .ld(ld_head),
        .par_in(),
        .par_out(head_reg_out)
    );

    Mux_2_to_1 mux1 #(
        parameter WIDTH = 16
    )(
        .sel(sel),
        .a(WIDTH{1'b0}),
        .b(s1),
        .out(mux_out)
    );

    assign num = $floor(HEIGHT/FILTER_SIZE)
    assign s1 = head_reg_out + FILTER_SIZE;
    assign Raddr = head_reg_out + index_counter_out;
    assign finish_filter = filter_counter_out + num;
    assign filter_end = (index_counter_out > FILTER_SIZE) ? 1'b1 : 1'b0; 

endmodule