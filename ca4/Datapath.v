module datapath #(
    parameter OUT_WIDTH = 16,
    parameter OUT_HEIGHT = 12,
    parameter OUT_PAR_READ = OUT_HEIGHT,
    parameter IF_WIDTH = 16,
    parameter IF_HEIGHT = 12,
    parameter FILTER_WIDTH = 16,
    parameter FILTER_HEIGHT = 12,
    parameter FILTER_SIZE = 4,
    parameter STRIDE_SIZE = 2,
    parameter MAX_ROW = 2,

    parameter IF_PAR_WRITE = IF_HEIGHT,
    parameter FILTER_PAR_WRITE = FILTER_HEIGHT,
    //local parameters
    parameter IF_ADDRESS_WIDTH =  (IF_HEIGHT > 1) ? $clog2(IF_HEIGHT) : 1,
    parameter FILTER_ADDRESS_WIDTH = (FILTER_HEIGHT > 1) ? $clog2(FILTER_HEIGHT) : 1,

    parameter ROW_PTR_WIDTH = (MAX_ROW > 1) ? $clog2(MAX_ROW) : 1,
    parameter INDEX_WIDTH = (FILTER_SIZE > 1) ? $clog2(FILTER_SIZE) : 1,

    parameter OUT_ADDRESS_WIDTH = (OUT_HEIGHT > 1) ? $clog2(OUT_HEIGHT) : 1
) (
    input out_buf_ren,
    input clr_out,
    input clk,
    input rst,
    input [(IF_WIDTH * IF_PAR_WRITE)-1:0] input_in,
    input [(FILTER_WIDTH * FILTER_PAR_WRITE)-1:0] filter_in,
    input IF_read_cntrl_en,
    input Filter_read_cntrl__en,
    input clr_If,
    input clr_Filter,
    //address generators
    input [STRIDE_SIZE - 1:0] stride_in,
    input ld_row_ptr,
    input [FILTER_SIZE - 1:0] filter_size,
    input sel,
    input ld_input_head,
    input row_ptr_cnt_en,
    input filter_cnt_en,
    input ld_filter_head,
    input clr_filter_head,
    input clr_row_ptr,
    input index_cnt_en,
    input clr_index,
    input filter_ren,
    input chip_en,
    input clr1,
    input clr2,
    input clr3,
    input ld1,
    input ld2,
    input ld3,
    input conv_done,
    //outputs
    output [(OUT_WIDTH * OUT_PAR_READ) - 1:0] out,
    output if_full,
    output filter_full,
    output IF_done,
    output Filter_done,
    output row_end,
    output finish_row,
    output filter_end,
    output finish_filter,
    output write_done
);

    wire If_buf_ren , If_buf_wen , If_empty;
    wire [IF_WIDTH - 1:0] IF_buffer_out;   
    wire Filter_buf_ren , Filter_buf_wen , Filter_empty;
    wire co;
    wire ld_start , ld_end , if_sp_wen , If_write_cnt_en , If_row_ptr_cnt_en;
    wire [IF_ADDRESS_WIDTH - 1:0] if_write_cntr_out;
    wire [IF_WIDTH - 3:0] if_sp_out;
    wire [INDEX_WIDTH - 1:0] offset;
    wire [IF_ADDRESS_WIDTH - 1:0] if_read_addr;

    wire [FILTER_WIDTH - 1:0] Filter_buffer_out;
    wire filter_wen , read_chip_en;
    wire [FILTER_WIDTH - 1:0] filter_sp_out;
    wire [FILTER_ADDRESS_WIDTH - 1:0] filter_raddr;
    wire filter_write_cnt_en;
    wire [FILTER_ADDRESS_WIDTH - 1:0] filter_write_cntr_out;
    wire res;
    wire [IF_WIDTH - 3:0] reg1_out;
    wire [((IF_WIDTH - 2) + FILTER_WIDTH) - 1:0] mul_out;
    wire [((IF_WIDTH - 2) + FILTER_WIDTH) - 1:0] reg2_out;
    wire [OUT_WIDTH - 1:0] add_out;
    wire [OUT_WIDTH - 1:0] reg3_out;
    wire out_buf_wen , out_full , out_write_cnt_en;
    wire [OUT_ADDRESS_WIDTH - 1:0] out_write_cntr_out;
    wire [ROW_PTR_WIDTH - 1 : 0] row_ptr_out;

    //if map part
    assign co = (row_ptr_out == MAX_ROW) ? 1'b1 : 1'b0;


    Fifo_buffer #(
        .DATA_WIDTH(IF_WIDTH),
        .PAR_WRITE(IF_PAR_WRITE),
        .PAR_READ(1),
        .DEPTH(IF_HEIGHT)
    ) IF_buffer (
      .clk(clk),
      .rstn(rst),
      .clear(clr_if),
      .ren(If_buf_ren),
      .wen(If_buf_wen),
      .din(input_in),
      .dout(IF_buffer_out),
      .full(if_full),
      .empty(If_empty)
    );

    IF_read_controller IF_read_controller
    (
        .clk(clk),
        .rst(rst),
        .en(IF_read_cntrl_en),
        .empty(If_empty),
        .start_bit(IF_buffer_out[IF_WIDTH - 1]),
        .end_bit(IF_buffer_out[IF_WIDTH - 2]),
        .co(co),
        .buf_wen(If_buf_wen),
        .buf_ren(If_buf_ren),
        .ld_start(ld_start),
        .ld_end(ld_end),
        .done(IF_done),
        .sp_wen(if_sp_wen),
        .write_cnt_en(If_write_cnt_en),
        .row_ptr_cnt_en(If_row_ptr_cnt_en)
    );

    IF_Map_SP #(
        .IFMAP_SPAD_WIDTH(IF_WIDTH - 2),
        .IFMAP_SPAD_ROW(IF_HEIGHT)
    ) if_map_sp (
        .clk(clk),
        .rst(rst),
        .din(IF_buffer_out[IF_WIDTH - 3:0]),
        .raddr(if_read_addr),
        .waddr(if_write_cntr_out),
        .wen(if_sp_wen),
        .dout(if_sp_out)
    );

    Counter #(
        .WIDTH(IF_ADDRESS_WIDTH)
    )
    if_write_cntr (
        .clk(clk),
        .rst(rst),
        .clr(clr_if),
        .inc(If_write_cnt_en),
        .dout(if_write_cntr_out),
        .cout()
    );
    
    If_Map_generator #(
        .IF_MAP_HEIGHT(IF_HEIGHT),
        .MAX_ROW(MAX_ROW),
        .STRIDE_SIZE(STRIDE_SIZE),
        .FILTER_SIZE(FILTER_SIZE),
        .ADD_WIDTH(IF_ADDRESS_WIDTH),
        .ROW_PTR_WIDTH(ROW_PTR_WIDTH)
    ) If_map_generator (
        .clk(clk),
        .rst(rst),
        .ld_input_head(ld_input_head),
        .stride_in(stride_in),
        .sel(sel),
        .offset(offset),
        .start_in(if_write_cntr_out),
        .end_in(if_write_cntr_out),
        .filter_size(filter_size),
        .ld_start(ld_start),
        .ld_end(ld_end),
        .row_ptr_cnt_en(If_row_ptr_cnt_en | row_ptr_cnt_en),
        .clr_row_ptr(clr_row_ptr),
        .ld_row_ptr(ld_row_ptr),
        .row_end(row_end),
        .finish_row(finish_row),
        .input_raddr(if_read_addr),
        .row_ptr_out(row_ptr_out)
    );

    //filter part

    assign res = (filter_write_cntr_out % filter_size == 0) ? 1'b1 : 1'b0;

    Fifo_buffer #(
        .DATA_WIDTH(FILTER_WIDTH),
        .PAR_WRITE(FILTER_PAR_WRITE),
        .PAR_READ(1),
        .DEPTH(FILTER_HEIGHT)
    ) Filter_buffer (
        .clk(clk),
        .rstn(rst),
        .clear(clr_Filter),     
        .ren(Filter_buf_ren),   
        .wen(Filter_buf_wen),
        .din(filter_in),
        .dout(Filter_buffer_out),
        .full(Filter_full),
        .empty(Filter_empty)
    );

    Filter_SP #(
        .FILTER_WIDTH(FILTER_WIDTH),
        .FILTER_ROW(FILTER_HEIGHT)
    ) filter_sp
    (
        .clk(clk),
        .rst(rst),
        .din(Filter_buffer_out),
        .raddr(),
        .waddr(),
        .ren(filter_ren),
        .wen(filter_wen),
        .chip_en(read_chip_en | chip_en),
        .dout(filter_sp_out)
    );

    Counter #(
        .WIDTH(FILTER_ADDRESS_WIDTH)
    ) filter_write_cntr (
        .clk(clk),
        .rst(rst),
        .clr(clr_Filter),
        .inc(filter_write_cnt_en),
        .dout(filter_write_cntr_out),
        .cout()
    );

    Filter_read_controller filter_read_controller
    (
        .clk(clk),
        .rst(rst),
        .en(Filter_read_cntrl__en),
        .empty(Filter_empty),
        .res(res),
        .buf_wen(Filter_buf_wen),
        .buf_ren(Filter_buf_ren),
        .write_cnt_en(filter_write_cnt_en),
        .sp_wen(filter_wen),
        .done(Filter_done),
        .chip_en(read_chip_en)
    );

    Filter_generator #(
        .FILTER_SIZE(FILTER_SIZE),
        .ADD_WIDTH(FILTER_ADDRESS_WIDTH),
        .WIDTH(FILTER_WIDTH),
        .HEIGHT(FILTER_HEIGHT)
    )
    filter_generator (
        .clk(clk),
        .rst(rst),
        .filter_cnt_en(filter_write_cnt_en),
        .ld_filter_head(ld_filter_head),
        .clr_filter_head(clr_filter_head),
        .index_cnt_en(index_cnt_en),
        .clr_index(clr_index),
        .filter_size(filter_size),
        .filter_raddr(filter_raddr),
        .filter_end(filter_end),
        .finish_filter(finish_filter)
    );

    //conv part
    Register #(
        .WIDTH(IF_WIDTH - 2)
    ) reg1 (
        .clk(clk),
        .rst(rst),
        .ld(ld1),
        .clr(clr1),
        .par_in(if_sp_out),
        .par_out(reg1_out)   
    );

    assign mul_out = reg1_out * filter_sp_out;

    Register #(
        .WIDTH((IF_WIDTH - 2) + FILTER_WIDTH)
    ) reg2 (
        .clk(clk),
        .rst(rst),
        .ld(ld2),
        .clr(clr2),
        .par_in(mul_out),
        .par_out(reg2_out)
    );

    assign add_out = reg2_out + reg3_out; 

    Register #(
        .WIDTH(OUT_WIDTH)
    ) reg3 (
        .clk(clk),
        .rst(rst),
        .ld(ld3),
        .clr(clr3),
        .par_in(add_out),
        .par_out(reg3_out)
    );

    //out buffer instance
    Fifo_buffer #(
        .DATA_WIDTH(OUT_WIDTH),
        .PAR_WRITE(1),
        .PAR_READ(OUT_PAR_READ),
        .DEPTH(OUT_HEIGHT)
    ) out_buffer (
        .clk(clk),
        .rstn(rst),
        .clear(clr_out),
        .ren(out_buf_ren),
        .wen(out_buf_wen),
        .din(reg3_out),
        .dout(out),
        .full(out_full),
        .empty()
    );
    
    Counter #(
        .WIDTH(OUT_ADDRESS_WIDTH)
    ) out_write_cntr (
        .clk(clk),
        .rst(rst),
        .clr(clr_out),
        .inc(out_write_cnt_en),
        .dout(out_write_cntr_out),
        .cout()
    );

    Write_controller write_controller
    (
        .clk(clk),
        .rst(rst),
        .conv_done(conv_done),
        .full(out_full),
        .cnt_en(out_write_cnt_en),
        .wen(out_buf_wen),
        .write_done(write_done)
    );
    
endmodule