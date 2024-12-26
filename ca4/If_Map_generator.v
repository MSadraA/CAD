module If_Map_generator #(
    parameter IF_MAP_HEIGHT = 8,
    parameter MAX_ROW = 2,
    parameter STRIDE_SIZE = 2,
    parameter FILTER_SIZE = 4,
    parameter ADD_WIDTH = (IF_MAP_HEIGHT > 1) ? $clog2(IF_MAP_HEIGHT) : 1,
    parameter ROW_PTR_WIDTH = (MAX_ROW > 1) ? $clog2(MAX_ROW) : 1
)(
    input clk,
    input rst,
    input ld_input_head,
    input [STRIDE_SIZE - 1:0] stride_in,
    input sel,
    input [STRIDE_SIZE - 1:0] offset,
    input [ADD_WIDTH - 1:0] start_in,
    input [ADD_WIDTH - 1:0] end_in,
    input [FILTER_SIZE - 1:0] filter_size,
    input ld_start,
    input ld_end,
    input row_ptr_cnt_en,
    input clr_row_ptr,
    input ld_row_ptr,
    output row_end,
    output finish_row,
    output [ADD_WIDTH - 1:0] input_raddr,
    output [ROW_PTR_WIDTH - 1:0] row_ptr_out
);
    wire [ADD_WIDTH - 1:0] head_reg_in , head_reg_out;
    wire [ADD_WIDTH - 1:0] start_ram_out , end_ram_out;
    wire [ROW_PTR_WIDTH - 1:0] row_ptr_reg_out;
    wire [ADD_WIDTH -1 : 0] next_head;
    wire [ADD_WIDTH -1 : 0] end_row_wire;


    Register #(
        .WIDTH(ADD_WIDTH)
    ) head_reg
    (
        .clk(clk),
        .rst(rst),
        .ld(ld_input_head),
        .clr(),
        .par_in(head_reg_in),
        .par_out(head_reg_out)
    );

    RAM #(
        .WIDTH(ADD_WIDTH),
        .HEIGHT(MAX_ROW)
    ) start_ram
    (
        .clk(clk),
        .rst(rst),
        .addr(row_ptr_out),
        .din(start_in),
        .ld(ld_start),
        .dout(start_ram_out)
    );

    RAM #(
        .WIDTH(ADD_WIDTH),
        .HEIGHT(MAX_ROW)
    ) end_ram
    (
        .clk(clk),
        .rst(rst),
        .addr(row_ptr_out),
        .din(end_in),
        .ld(ld_end),
        .dout(end_ram_out)
    );

    Counter #(
        .WIDTH(ROW_PTR_WIDTH)
    ) row_ptr_ounter
    (
        .clk(clk),
        .rst(rst),
        .inc(row_ptr_cnt_en),
        .clr(clr_row_ptr),
        .dout(row_ptr_out),
        .cout()
    );

    Register #(
        .WIDTH(ROW_PTR_WIDTH)
    ) row_ptr_reg
    (
        .clk(clk),
        .rst(rst),
        .ld(ld_row_ptr),
        .clr(),
        .par_in(row_ptr_out),
        .par_out(row_ptr_reg_out)
    );

    

    assign input_raddr = head_reg_out + offset;
    assign finish_row = (row_ptr_reg_out == row_ptr_out) ? 1:0;
    assign next_head = head_reg_out + stride_in;
    assign end_row_wire = head_reg_out + filter_size;
    assign row_end = (end_row_wire == end_ram_out) ? 1:0;
    assign head_reg_in = (sel) ? start_ram_out : next_head;

endmodule
