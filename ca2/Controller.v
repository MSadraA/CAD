module Controller (
    input clk,
    input rst,
    input full,
    input w_en,
    output ready,
    output ld1,
    output ld2,
    input read_en,
    input empty,
    output valid,
    output ld3
);

    W_controller write_controller
    (
        .clk(clk),
        .rst(rst),
        .full(full),
        .w_en(w_en),
        .ready(ready),
        .ld1(ld1),
        .ld2(ld2)
    );

    r_controller read_controller
    (
        .clk(clk),
        .rst(rst),
        .read_en(read_en),
        .empty(empty),
        .valid(valid),
        .ld3(ld3)
    );
    
endmodule