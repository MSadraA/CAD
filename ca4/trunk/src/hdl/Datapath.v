module datapath(
    input clk, 
    input rst,
);

    SRAM ram 
    # (parameter ADDR_WIDTH = 4,
     parameter DATA_WIDTH = 32,
     parameter DEPTH = 16
    )(
        .clk(clk),
        .raddr(),
        .waddr(),
        .din(),
        .dout(w1),
        .chip_en(),
        .wen(),
        .ren()
    );


    If_Map_generator if_map_gen #(
    parameter FILTER_SIZE = 4,
    parameter STRIDE_SIZE = 2
    parameter SIZE = 16
)(
    .clk(clk),
    .rst(rst),
    .ld_head(),
    .stride(),
    .offset(),
    .CLR(),
    .cnt_en(),
    .ld_row(),
    .finish_row(),
    .Raddr(),
    .row_end()
);

     register reg1 #(
	parameter SIZE = 8
    )(
        .clk(clk),
        .rst(rst),
        .ld(),
        .par_in(),
        .par_out(w2)
    );


    wire[DATA_WIDTH - 1 : 0] w1, w2 , w3 , w4;
    SRAM sram 
    # (parameter ADDR_WIDTH = 4,
     parameter DATA_WIDTH = 32,
     parameter DEPTH = 16
    )(
        .clk(clk),
        .raddr(),
        .waddr(),
        .din(),
        .dout(w1),
        .chip_en(),
        .wen(),
        .ren()
    );

    Filter_Generator filter_gen #(
    parameter HEIGHT = 16,
    parameter FILTER_SIZE = 8,
)(
    .clk(clk),
    .rst(rst),
    .filter_cnt_en(),
    .ld_head(),
    .index_cnt_en(),
    .sel(),
    .index_clr(),
    .finish_filter(),
    .Raddr(),
    .filter_end()
);

   
    register reg2 #(
	parameter SIZE = 8
    )(
        .clk(clk),
        .rst(rst),
        .ld(),
        .par_in(w3),
        .par_out(w4)
    );

    register reg3 #(
	parameter SIZE = 8
    )(
        .clk(clk),
        .rst(rst),
        .ld(),
        .par_in(w5),
        .par_out(w6)
    );

    multiplier mult #(
	parameter SIZE = 8,
    )(
        .par_in1(w1),
        .par_in2(w2),
        .par_out(w3)
        
    );

    adder add #(
	parameter SIZE = 8
    )(
        .par_in1(w4),
        .par_in2(w6),
        .par_out(w5)
    );


    Counter if_write_counter #(
        parameter WIDTH = 16
    )(
        .clk(clk),
        .rst(rst),
        .clr(1'b0),
        .inc(cnt_en),
        .dout(if_write_counter_out),
        .cout(),
    );

    Counter filter_counter #(
        parameter WIDTH = 16
    )(
        .clk(clk),
        .rst(rst),
        .clr(1'b0),
        .inc(cnt_en),
        .dout(filter_counter_out),
        .cout(),
    );


endmodule