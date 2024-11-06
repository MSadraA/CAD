module Datapath #(
    parameter SIZE = 16,    // Buffer size
    parameter WIDTH = 8,    // Data width
    parameter K = 4,        // Input parallel factor
    parameter J = 4,        // Output parallel factor
    parameter BIT = $clog2(SIZE)  // Address bits )
)   (
    input clk, 
    input rst, 
    input ld1, 
    input ld2, 
    input ld3, 
    input [(WIDTH*K)-1:0] par_in,
    output [(WIDTH*J)-1:0] par_out,
    output full,
    output empty
    // output out
);

    wire [BIT-1:0] write_add , read_add;
    wire [BIT - 1 : 0] w_pointer_in , r_pointer_in;
    wire [BIT - 1 : 0] full_comprator_in , empty_comprator_in;


    //in_buffer
    Buffer #(
        .SIZE(SIZE),
        .WIDTH(WIDTH),
        .K(K),
        .J(J)
    ) Buffer_inst(
        .clk(clk),
        .ld(ld1),
        .rst(rst),
        .write_add(write_add),
        .read_add(read_add),
        .par_in(par_in),
        .par_out(par_out)//
    );
    //write register
    
    register #(
        .SIZE(SIZE)
    )
    w_pointer
    (
        .clk(clk),
        .rst(rst),
        .ld(ld2),
        .par_in(w_pointer_in),
        .par_out(write_add)
    );

    //read register
    register #(
        .SIZE(SIZE)
    )
    r_pointer
    (
        .clk(clk),
        .ld(ld3),
        .rst(rst),
        .par_in(r_pointer_in),
        .par_out(read_add)
    );

    adder #(.SIZE(SIZE))
    w_address_adder
    (
        .par_in(write_add),
        .imm(K[BIT-1:0]),
        .par_out(w_pointer_in)
    );

    adder #(.SIZE(SIZE))
    w_address_inc
    (
        .par_in(w_pointer_in),
        .imm({{BIT-1{1'b0}} , 1'b1}),
        .par_out(full_comprator_in)
    );

    adder #(.SIZE(SIZE))
    r_address_adder
    (
        .par_in(read_add),
        .imm(J[BIT-1:0]),
        .par_out(empty_comprator_in)
    );

    comparator #(.SIZE(SIZE))
    full_comprator
    (
        .a(full_comprator_in),
        .b(read_add),
        .bte(full)
    );

    comparator #(.SIZE(SIZE))
    empty_comprator
    (
        .a(empty_comprator_in),
        .b(write_add),
        .bte(empty)
    );

endmodule