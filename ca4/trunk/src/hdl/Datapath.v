module datapath(
    input clk, 
    input rst, 
    input ld1, 
    input ld2, 
    input ld3, 
    input ld4, 
    input ld5,
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

    register reg1 #(
	parameter SIZE = 8
    )(
        .clk(clk),
        .rst(rst),
        .ld(),
        .par_in(),
        .par_out(w2)
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


endmodule