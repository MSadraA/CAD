module datapath
#(parameter k = 4, parameter j = 4 )
(
    input clk, 
    input rst, 
    input ld1, 
    input ld2, 
    input ld3, 
    output full,
    output empty,
    output out
);

    //in_buffer
    wire [3:0] in_add;
    buffer buff
    (
        .out(in_add),
        .inc(Inc1), 
        .clk(clk),
        .reset(Countrst1)
    );

    //write register
    wire [k-1:0] w1 , w3;
    register w_pointer
    (
        .clk(clk),
        .ld(ld2),
        .pIn(w3),
        .pOut(w1)
    );

    //read register
    wire [j-1:0] in_ram_out;
    register r_pointer
    (
        .clk(clk),
        .ld(ld3),
        .pIn(w4),
        .pOut(w2)
    );

    adder add1
    (
        .a(w1),
        .b(k),
        .w(w3)

    );

    adder add2
    (
        .a(w3),
        .b(k'd1),
        .w(w5)

    );

    adder add3
    (
        .a(w2),
        .b(j),
        .w(w4)

    );

    output wire_full;
    comparator comp1
    (
        .a(w5),
        .b(w2),
        .bt(wire_full)
    );

    wire wire_empty;
    comparator comp2
    (
        .a(w1),
        .b(j),
        .bt(wire_empty)
    );

    
    assign empty = wire_empty;
    assign full = wire_full;
endmodule