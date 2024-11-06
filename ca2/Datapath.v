module datapath #(
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
    output empty,
    output out
);

    wire [K-1:0] w1, w3, w5;
    wire [J-1:0] w2, w4;
    wire [(WIDTH*J)-1:0] parallelout;
    wire wire_full = 1'b0, wire_empty = 1'b0;

    //in_buffer
    Buffer #(
        .SIZE(SIZE),
        .WIDTH(WIDTH),
        .K(K),
        .J(J),
        .BIT($clog2(SIZE))
    ) Buffer_inst(
        .clk(clk),
        .ld(ld1),
        .rst(rst),
        .write_add(w1),
        .read_add(w2),
        .par_in(par_in),
        .par_out(parallelout)
    );
    //write register
    
    register w_pointer
    (
        .clk(clk),
        .ld(ld2),
        .pIn(w3),
        .pOut(w1)
    );

    //read register
    register r_pointer
    (
        .clk(clk),
        .ld(ld3),
        .pIn(w4),
        .pOut(w2)
    );

    adder #(.K(K))
     add1
    (
        .a(w1),
        .b(k),
        .w(w3)

    );

    adder #(.K(K))
     add2
    (
        .a(w3),
        .b({K{1'b1}}),
        .w(w5)

    );

    adder #(.K(K))
    add3
    (
        .a(w2),
        .b(J),
        .w(w4)

    );

    comparator comp1
    (
        .a(w5),
        .b(w2),
        .bt(wire_full)
    );

    comparator comp2
    (
        .a(w1),
        .b(J),
        .bt(wire_empty)
    );

    
    assign empty = wire_empty;
    assign full = wire_full;
    assign par_out = parallelout;
endmodule