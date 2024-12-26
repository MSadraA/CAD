module TopModule #(
    parameter OUT_WIDTH = 16,
    parameter OUT_HEIGHT = 12,
    parameter IF_WIDTH = 16,
    parameter IF_HEIGHT = 12,
    parameter FILTER_WIDTH = 16,
    parameter FILTER_HEIGHT = 12,
    parameter FILTER_SIZE = 4,
    parameter STRIDE_SIZE = 2,
    parameter MAX_ROW = 2,

    parameter OUT_PAR_READ = 16,
    parameter IF_PAR_WRITE = 16,
    parameter FILTER_PAR_WRITE = 16
)
(
  input clk,
  input rst,
  input start,
  input ren,
  input [STRIDE_SIZE - 1:0] stride_in,
  input [(IF_WIDTH * IF_PAR_WRITE)-1:0] input_in,
  input [(FILTER_WIDTH * FILTER_PAR_WRITE)-1:0] filter_in,
  output [(OUT_WIDTH * OUT_PAR_READ)-1:0] out,
  output done
);
  wire done1;
  wire done2;
  wire filter_full;
  wire if_full;
  wire write_done;
  wire finish_row;
  wire finish_filter;
  wire input_end;
  wire filter_end;
  wire en1;
  wire en2;
  wire ld_row_ptr;
  wire clr_index;
  wire clr_filter_head;
  wire ld_filter_head;
  wire index_cnt_en;
  wire row_ptr_cnt_en;
  wire sel;
  wire filter_cnt_en;
  wire ld_input_head;
  wire clr_row_ptr;
  wire filter_ren;
  wire chip_en;
  wire conv_done;
  wire clr1;
  wire clr2;
  wire clr3;
  wire clr_if;
  wire clr_filter;
  wire clr_out;
  wire ld1;
  wire ld2;
  wire ld3;


  Main_controller controller(
    .clk(clk),
    .rst(rst),
    .start(start),
    .done1(done1),
    .done2(done2),
    .filter_full(filter_full),
    .if_full(if_full),
    .write_done(write_done),
    .finish_row(finish_row),
    .finish_filter(finish_filter),
    .input_end(input_end),
    .filter_end(filter_end),
    .en1(en1),
    .en2(en2),
    .ld_row_ptr(ld_row_ptr),
    .clr_index(clr_index),
    .clr_filter_head(clr_filter_head),
    .ld_filter_head(ld_filter_head),
    .index_cnt_en(index_cnt_en),
    .row_ptr_cnt_en(row_ptr_cnt_en),
    .sel(sel),
    .filter_cnt_en(filter_cnt_en),
    .ld_input_head(ld_input_head),
    .clr_row_ptr(clr_row_ptr),
    .filter_ren(filter_ren),
    .chip_en(chip_en),
    .conv_done(conv_done),
    .done(done),
    .clr1(clr1),
    .clr2(clr2),
    .clr3(clr3),
    .clr_if(clr_if),
    .clr_filter(clr_filter),
    .clr_out(clr_out),
    .ld1(ld1),
    .ld2(ld2),
    .ld3(ld3)
  );


  datapath #(
    .OUT_WIDTH(OUT_WIDTH),
    .OUT_HEIGHT(OUT_HEIGHT),
    .IF_WIDTH(IF_WIDTH),
    .IF_HEIGHT(IF_HEIGHT),
    .FILTER_WIDTH(FILTER_WIDTH),
    .FILTER_HEIGHT(FILTER_HEIGHT),
    .FILTER_SIZE(FILTER_SIZE),
    .STRIDE_SIZE(STRIDE_SIZE),
    .MAX_ROW(MAX_ROW),

    .IF_PAR_WRITE(IF_PAR_WRITE),
    .FILTER_PAR_WRITE(FILTER_PAR_WRITE),
    .OUT_PAR_READ(OUT_PAR_READ)
  ) dp 
  (
    .out_buf_ren(ren),
    .clr_out(clr_out),
    .clk(clk),
    .rst(rst),
    .input_in(input_in),
    .filter_in(filter_in),
    .IF_read_cntrl_en(en1),
    .Filter_read_cntrl__en(en2),
    .clr_If(clr_if),
    .clr_Filter(clr_filter),
    //address generators
    .stride_in(stride_in),
    .ld_row_ptr(ld_row_ptr),
    .sel(sel),
    .ld_input_head(ld_input_head),
    .row_ptr_cnt_en(row_ptr_cnt_en),
    .filter_cnt_en(filter_cnt_en),
    .ld_filter_head(ld_filter_head),
    .clr_filter_head(clr_filter_head),
    .clr_row_ptr(clr_row_ptr),
    .index_cnt_en(index_cnt_en),
    .clr_index(clr_index),
    .filter_ren(filter_ren),
    .chip_en(chip_en),
    .clr1(clr1),
    .clr2(clr2),
    .clr3(clr3),
    .ld1(ld1),
    .ld2(ld2),
    .ld3(ld3),
    .conv_done(conv_done),
    //outputs
    .out(out),
    .if_full(if_full),
    .filter_full(filter_full),
    .IF_done(done1),
    .Filter_done(done2),
    .row_end(input_end),
    .finish_row(finish_row),
    .filter_end(filter_end),
    .finish_filter(finish_filter),
    .write_done(write_done)
  );
endmodule