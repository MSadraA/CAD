module Filter_generator #(
    parameter HEIGHT = 16,
    parameter WIDTH = 8,
    parameter FILTER_SIZE = 8,
    
    parameter ADD_WIDTH = (HEIGHT > 1) ? $clog2(HEIGHT) : 1,
    parameter NUM = (HEIGHT * WIDTH)/FILTER_SIZE,
    parameter FILTER_NUM = (NUM > 1) ? $clog2(NUM) : 1,
    parameter INDEX_WIDTH = (FILTER_SIZE > 1) ? $clog2(FILTER_SIZE) : 1
)(
    input clk,
    input rst,
    input filter_cnt_en,
    input ld_filter_head,
    input clr_filter_head,
    input index_cnt_en,
    input clr_index,
    output reg [ADD_WIDTH - 1:0] filter_raddr,
    output [INDEX_WIDTH - 1:0] index_counter_out,
    output reg filter_end,
    output reg finish_filter
);

    wire [FILTER_NUM - 1:0] filter_counter_out;
    wire [ADD_WIDTH - 1:0] head_reg_out;
    wire [ADD_WIDTH - 1:0] head_reg_in;

    Counter #(
        .WIDTH(FILTER_NUM)
    ) filter_counter
    (
        .clk(clk),
        .rst(rst),
        .clr(),
        .inc(filter_cnt_en),
        .dout(filter_counter_out),
        .cout()
    );

    Register #(
        .WIDTH(ADD_WIDTH)
    ) head_reg
    (
        .clk(clk),
        .rst(rst),
        .ld(ld_filter_head),
        .clr(clr_filter_head),
        .par_in(head_reg_in),
        .par_out(head_reg_out)
    );

    Counter #(
        .WIDTH(INDEX_WIDTH)
    ) index_counter
    (
        .clk(clk),
        .rst(rst),
        .clr(clr_index),    
        .inc(index_cnt_en),
        .dout(index_counter_out),
        .cout()
    );

    assign finish_filter = (filter_counter_out == NUM - 1) ? 1:0;//check in testbench
    assign filter_raddr = head_reg_out + index_counter_out;
    assign head_reg_in = head_reg_out + FILTER_SIZE;
    assign filter_end = (index_counter_out == FILTER_SIZE - 1) ? 1:0;//check in testbench

endmodule