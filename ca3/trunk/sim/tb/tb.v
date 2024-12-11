module tb (
);
    reg clk = 0;
    reg rst = 1;

    // reg [15:0] x1 = 16'h0000;
    // reg [15:0] x2 = 16'h0000;
    //16'h0000

    // reg [15:0] x1 = 16'h0000;
    // reg [15:0] x2 = 16'hffff;
    //16'h0000

    // reg [15:0] x1 = 16'h7fff;
    // reg [15:0] x2 = 16'h8000;
    // //16'h3fc0

    // reg [15:0] x1 = 16'haaaa;
    // reg [15:0] x2 = 16'h5555;
    // // 16'h3872

    // reg [15:0] x1 = 16'hffff;
    // reg [15:0] x2 = 16'hffff;
    //16'hfe01

    // reg [15:0] x1 = 16'h1234;
    // reg [15:0] x2 = 16'habcd;
    //16'0c1b6000

    // reg [15:0] x1 = 16'hffff;
    // reg [15:0] x2 = 16'h0001;
    //16'0000ff00

    reg [15:0] x1 = 16'h0001;
    reg [15:0] x2 = 16'h0002;
    //16'h00000002


    reg start = 1'b1;

    wire [31:0] out;
    wire done;

    always #5 clk = ~clk;

    initial begin
        #10 rst = 1'b0;
        #20 start = 1'b0;
        #400 $stop;
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