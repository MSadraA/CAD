module TopModule #(
    parameter SIZE = 16,    // Buffer size
    parameter WIDTH = 8,    // Data width
    parameter K = 4,        // Input parallel factor
    parameter J = 4,        // Output parallel factor
    parameter BIT = $clog2(SIZE)  // Address bits
)   
(
    input clk,
    input rst,
    input w_en,
    input r_en,
    input [(WIDTH*K)-1:0] par_in,
    output [(WIDTH*J)-1:0] par_out,
    output empty,
    output ready,
    output full,
    output valid
);

wire [(WIDTH*J)-1:0] out;

wire ld1 , ld2 , ld3;

Controller controller
(
    .clk(clk),
    .rst(rst),
    .full(full),
    .w_en(w_en),
    .ready(ready),
    .ld1(ld1),
    .ld2(ld2),
    .read_en(r_en),
    .empty(empty),
    .valid(valid),
    .ld3(ld3)
);

Datapath  #(
    .SIZE(SIZE),
    .WIDTH(WIDTH),
    .K(K),
    .J(J)
)   
datapath_inst(
    .clk(clk),
    .rst(rst),
    .ld1(ld1),
    .ld2(ld2),
    .ld3(ld3),
    .par_in(par_in),
    .par_out(par_out),
    .full(full),
    .empty(empty)
);

endmodule