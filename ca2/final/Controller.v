module Controller (
    input clk,
    input rst,
    input full,
    input w_en,
    output ld1,
    output ld2,
    input read_en,
    input empty,
    output ld3,
    output ready,
    output valid
);

    W_controller write_controller
    (
        .clk(clk),
        .rst(rst),
        .full(full),
        .empty(empty),
        .w_en(w_en),
        .ld1(ld1),
        .ld2(ld2),
        .ready(ready)
    );

    r_controller read_controller
    (
        .clk(clk),
        .rst(rst),
        .full(full),
        .read_en(read_en),
        .empty(empty),
        .ld3(ld3),
        .valid(valid)
    );

    // assign ready = ~full;
    // assign valid = ~empty;

    // always @(w_en or full) begin
    //     ready = (w_en) ? ~full:0; 
    // end

    // always @(read_en or empty) begin
    //     valid = (read_en) ? ~empty:0;
    // end
    
endmodule