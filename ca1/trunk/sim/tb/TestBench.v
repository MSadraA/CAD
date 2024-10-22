module TestBench();
    reg clk, rst = 1, start = 0;
    wire done;
    TopModule top_module
    (
        .clk(clk), 
        .rst(rst), 
        .start(start),
        .done(done)
    );
    always #5 clk = ~clk;

    initial begin
        clk = 1'b0;
        #2 rst = 1'b1;
        #6 rst = 1'b0;
        #3500 $stop;
    end

    initial begin
        #10 start = 1;
        #5 start = 0;
    end
    
endmodule