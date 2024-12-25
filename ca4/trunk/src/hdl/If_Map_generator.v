module If_Map_generator #(
    parameter FILTER_SIZE = 4,
    parameter STRIDE_SIZE = 2
    parameter SIZE = 16
)(
    input clk,
    input rst,
    input ld_input_head,
    input [STRIDE_SIZE -1 : 0] stride_in,
    input offset,
    input CLR,
    input ptr_cnt_en,
    input ld_ptr_row,
    output finish_row,
    output input_Raddr,
    output row_end
);
    wire [SIZE-1:0] in ,w1, head_reg_out, start_ram_out,end_ram_out,  row_ptr_reg_out, w3;
    register head_reg #(
        parameter SIZE = ($log2(HEIGHT))
    )(
        .clk(clk),
        .rst(rst),
        .ld(ld_input_head),
        .par_in(in),
        .par_out(head_reg_out)
    );

    Mux_2_to_1 mux2 #(
        parameter WIDTH = 16
    )(
        .sel(sel),
        .a(w1),
        .b(start_ram_out),
        .out(in)
    );
/*
    register start_reg #(
        parameter SIZE = 16
    )(
        .clk(clk),
        .rst(rst),
        .ld(Ad),
        .par_in(in),
        .par_out(start_ram_out)
    );

    RAM start_ram
    #(
        parameter WIDTH = 16,
        parameter SIZE = 8
    )(
        .clk(clk),
        .rst(rst),
        .ld(addr),
        .par_in(in),      
        .par_out(start_ram_out) 
    );

    register end_reg #(
        parameter SIZE = 16
    )(
        .clk(clk),
        .rst(rst),
        .ld(Ad),
        .par_in(in),
        .par_out(end_reg_out)
    ); */

    RAM strat_ram 
    # (parameter ADDR_WIDTH = 4,
     parameter DATA_WIDTH = 32,
     parameter DEPTH = 16
    )(
        .clk(clk),
        .raddr(row_par_out),
        .waddr(),
        .din(start_in),
        .dout(start_ram_out),
        .wen(),
        .ren()
    );

    RAM end_ram 
    # (parameter ADDR_WIDTH = 4,
     parameter DATA_WIDTH = 32,
     parameter DEPTH = 16
    )(
        .clk(clk),
        .raddr(row_par_out),
        .waddr(),
        .din(end_in),
        .dout(end_ram_out),
        .wen(),
        .ren()
    );

    Counter row_pointer_counter #(
        parameter WIDTH = ($log2(row_number)+1)
    )(
        .clk(clk),
        .rst(rst),
        .clr(CLR),
        .inc(ptr_cnt_en),
        .dout(row_par_out),
        .cout()
    );

    register row_ptr_reg #(
        parameter SIZE = 16
    )(
        .clk(clk),
        .rst(rst),
        .ld(ld_row_ptr),
        .par_in(row_ptr_reg_out),
        .par_out(r1)
    );


    assign w1 = stride_in + head_reg_out;
    assign input_Raddr = head_reg_out + offset;
    assign finish_row = (row_ptr_reg_out == row_par_out) ? 1'b1 : 1'b0;
    assign w3 = FILTER_SIZE + head_reg_out;
    assign row_end = (w3 == end_reg_out) ? 1'b1 : 1'b0;
endmodule