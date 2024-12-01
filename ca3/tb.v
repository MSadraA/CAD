module tb (
);
    reg clk = 0;
    reg rst = 1;

    reg [15:0] x1 = 16'd4;
    reg [15:0] x2 = 16'd5;
    reg start = 1'b1;

    wire [31:0] out;
    wire done;

    always #5 clk = ~clk;

    initial begin
        #10 rst = 1'b0;
        #10 start = 1'b0;
        #2000 $stop;
    end

    top_module uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .x1(x1),
        .x2(x2),
        .out(out),
        .done(done)
    );
    
endmodule