module TopModule #(
    parameter SIZE = 16,    // Buffer size
    parameter WIDTH = 8,    // Data width
    parameter K = 4,        // Input parallel factor
    parameter J = 4,        // Output parallel factor
    parameter BIT = $clog2(SIZE)  // Address bits

)   (
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

parameter INIT_LOW = 1'b0;
parameter INIT_HIGH = 1'b1;

wire [(WIDTH*J)-1:0] out;
wire ld1 , ld2;
wire wire_full = 1'b0, wire_empty = 1'b0;


  W_controller writecontroller(
    .clk(clk),
    .rst(rst),
    .full(full),
    .w_en(w_en),
    .ready(ready),
    .ld1(ld1),
    .ld2(ld2)
);

r_controller readcontroller(
    .clk(clk),
    .rst(rst),
    .read_en(r_en),
    .empty(empty_wire),
    .valid(valid),
    .ld3(ld3)
);

datapath  #(
    .SIZE(SIZE),
    .WIDTH(WIDTH),
    .K(K),
    .J(J),
    .BIT(BIT)

)   datapath_inst(
    .clk(clk),
    .rst(rst),
    .ld1(ld1),
    .ld2(ld2),
    .ld3(ld2),
    .par_in(par_in),
    .par_out(par_out),
    .full(full_wire),
    .empty(empty_wire),
    .out(out)
    
);


assign par_out = out;
assign empty = empty_wire;
assign full = full_wire;

endmodule