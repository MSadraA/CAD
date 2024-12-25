module datapath #(
    parameter WIDTH = 16
)(
    input clk, 
    input rst,
    input clr,
    input if_write_cnt_en,
    input if_buf_ren,
    input if_buf_wen,
    input if_wen,
    input ld_ptr_row,
    input ld_input_head,
    output row_end,
    output row_end,
    //output finish_input,
    input CLR_index,
    input row_ptr_cnt_en,
    input filter_wen,
    input read_chip_en,
    input chip_en,
    input filter_ren,
    input filter_buf_ren,
    input filter_buf_wen,
    input filter_full,
    input filter_write_cnt_en,
    input ld_filter_head,
    input out_wen,
    output filter_empty
);

    wire [WIDTH-1:0] out_buf_if , out_buf_filter;

    Fifo_buffer buff_in_if #(
        parameter DATA_WIDTH = 16, //data bitwidth
        parameter PAR_WRITE = 1,
        parameter PAR_READ = 1,
        parameter DEPTH = 4 //total size
    )(
        .clk(clk),
        .rstn(rst), //active low reset
        .clear(clr), //clear buffer counters
        .ren(if_buf_ren), //read enable 
        .wen(if_buf_wen), //write enable
        .din(), //input data to write into the buffer
        .dout(out_buf_if), //output data to read from the buffer
        .full(if_full), //output to signal if buffer is full
        .empty(if_empty) //output to signal if buffer is empty
    );

    RAM ram 
    # (parameter ADDR_WIDTH = 4,
     parameter DATA_WIDTH = 32,
     parameter DEPTH = 16
    )(
        .clk(clk),
        .raddr(input_Raddr),
        .waddr(if_write_counter_out),
        .din(),
        .dout(w1),
        .wen(if_wen),
        .ren(row_ptr_out)
    );


    If_Map_generator if_map_gen #(
    parameter FILTER_SIZE = 4,
    parameter STRIDE_SIZE = 2
    parameter SIZE = 16
)(
    .clk(clk),
    .rst(rst),
    .ld_input_head(ld_input_head),
    .stride_in(),
    .offset(),
    .CLR(CLR_index),
    .ptr_cnt_en(row_ptr_cnt_en),
    .ld_ptr_row(ld_ptr_row),
    .sel(sel)
    .finish_row(),
    .input_Raddr(),
    .row_end()
);

    register reg1 #(
	parameter SIZE = 8
    )(
        .clk(clk),
        .rst(rst),
        .ld(),
        .clr(),
        .par_in(),
        .par_out(w2)
    );


    Fifo_buffer buff_in_filter #(
        parameter DATA_WIDTH = 16, //data bitwidth
        parameter PAR_WRITE = 1,
        parameter PAR_READ = 1,
        parameter DEPTH = 4 //total size
    )(
        .clk(clk),
        .rstn(rst), //active low reset
        .clear(clr), //clear buffer counters
        .ren(filter_buf_ren), //read enable 
        .wen(filter_buf_wen), //write enable
        .din(), //input data to write into the buffer
        .dout(out_buf_filter), //output data to read from the buffer
        .full(filter_full), //output to signal if buffer is full
        .empty(filter_empty) //output to signal if buffer is empty
    );


    wire[DATA_WIDTH - 1 : 0] w1, w2 , w3 , w4;
    SRAM sram 
    # (parameter ADDR_WIDTH = 4,
     parameter DATA_WIDTH = 32,
     parameter DEPTH = 16
    )(
        .clk(clk),
        .raddr(),
        .waddr(filter_write_counter_out),
        .din(out_buf_filter),
        .dout(w1),
        .chip_en(chipen),
        .wen(filter_wen),
        .ren(filter_ren)
    );

    Filter_Generator filter_gen #(
    parameter HEIGHT = 16,
    parameter FILTER_SIZE = 8,
)(
    .clk(clk),
    .rst(rst),
    .filter_cnt_en(filter_cnt_en),
    .ld_head(ld_filter_head),
    .index_cnt_en(index_cnt_en),
    .sel(sel),
    .index_clr(CLR_index),
    .finish_filter(),
    .Raddr(),
    .filter_end()
);

    wire [WIDTH-1:0] filter_write_counter_out;

    Counter filter_write_counter #(
        parameter WIDTH = 16
    )(
        .clk(clk),
        .rst(rst),
        .clr(1'b0),
        .inc(filter_write_cnt_en),
        .dout(filter_counter_out),
        .cout(filter_write_counter_out)
    );

   
    register reg2 #(
	parameter SIZE = 8
    )(
        .clk(clk),
        .rst(rst),
        .ld(),
        .clr(),
        .par_in(w3),
        .par_out(w4)
    );

    register reg3 #(
	parameter SIZE = 8
    )(
        .clk(clk),
        .rst(rst),
        .ld(),
        .clr(),
        .par_in(w5),
        .par_out(w6)
    );

    Counter if_write_counter #(
        parameter WIDTH = 16
    )(
        .clk(clk),
        .rst(rst),
        .clr(1'b0),
        .inc(if_write_cnt_en),
        .dout(if_write_counter_out),
        .cout(),
    );


    Fifo_buffer out_buff #(
        parameter DATA_WIDTH = 16, //data bitwidth
        parameter PAR_WRITE = 1,
        parameter PAR_READ = 1,
        parameter DEPTH = 4 //total size
    )(
        .clk(clk),
        .rstn(rst), //active low reset
        .clear(clr), //clear buffer counters
        .ren(filter_buf_ren), //read enable 
        .wen(out_wen), //write enable
        .din(w6), //input data to write into the buffer
        .dout(out_buf_filter), //output data to read from the buffer
        .full(filter_full), //output to signal if buffer is full
        .empty(filter_empty) //output to signal if buffer is empty
    );

    Counter out_counter #(
        parameter WIDTH = 16
    )(
        .clk(clk),
        .rst(rst),
        .clr(1'b0),
        .inc(out_write_cnt_en),
        .dout(out_waddr),
        .cout(),
    );

    assign chipen = (chip_en || read_chip_en);
    assign res = ((filter_write_counter % FILTER_SIZE) == 0) ? 1'b1 : 1'b0; 
    assign w3 = w1 * w2;
    assign w5 = w4 + w6;
endmodule