module tb ();
    parameter OUT_WIDTH = 32;
    parameter OUT_HEIGHT = 32;
    parameter IF_WIDTH = 18;
    parameter IF_HEIGHT = 16;
    parameter FILTER_WIDTH = 16;
    parameter FILTER_HEIGHT = 16;
    parameter FILTER_SIZE = 4;
    parameter STRIDE_SIZE = 3;
    parameter MAX_ROW = 2;

    parameter IF_PAR_WRITE = 16;
    parameter FILTER_PAR_WRITE = 16;
    parameter OUT_PAR_READ = 32;


    reg clk = 0;
    reg rst = 1;
    reg start = 0;
    wire done;
    wire [(32 * 32)-1:0] out;

    //todo

    reg [(18 * 16) - 1 : 0] input_in;

    reg [(16 * 16) - 1:0] filter_in;


    TopModule #(
        .OUT_WIDTH(OUT_WIDTH),
        .OUT_HEIGHT(OUT_HEIGHT),
        .IF_WIDTH(IF_WIDTH),
        .IF_HEIGHT(IF_HEIGHT),
        .FILTER_WIDTH(FILTER_WIDTH),
        .FILTER_HEIGHT(FILTER_HEIGHT),
        .FILTER_SIZE(FILTER_SIZE),
        .STRIDE_SIZE(STRIDE_SIZE),
        .MAX_ROW(MAX_ROW),
        .IF_PAR_WRITE(IF_PAR_WRITE),
        .FILTER_PAR_WRITE(FILTER_PAR_WRITE),
        .OUT_PAR_READ(OUT_PAR_READ)
    ) test
    (
        .clk(clk),
        .rst(rst),
        .start(start),
        .ren(1'b0),
        .stride_in(3'd4),
        .input_in(input_in),
        .filter_in(filter_in),
        .out(out),
        .done(done)
    );

    initial begin
        rst = 1;
        #20 rst = 0;
        
        input_in = {
        {18'b101111111111011111} ,
        {18'b000000000000100000} ,
        {18'b001111111111100111} ,
        {18'b001111111111011000} ,
        {18'b001111111111101001} ,
        {18'b000000000000111110} ,
        {18'b001111111111100000} ,
        {18'b010000000000100011} ,
        {18'b100000000000000101} ,
        {18'b001111111111101110} ,
        {18'b000000000000100000} ,
        {18'b001111111111010000} ,
        {18'b001111111111001100} ,
        {18'b001111111111001111} ,
        {18'b001111111111101111} ,
        {18'b011111111111001111}
    };
        
        filter_in = {
        {16'b1111111111001001},
        {16'b0000000000001001},
        {16'b1111111111100100},
        {16'b0000000000110110},
        {16'b0000000000011110},
        {16'b1111111111011000},
        {16'b0000000000110100},
        {16'b0000000000111111},
        {16'b1111111111000100},
        {16'b0000000000101110},
        {16'b0000000000011111},
        {16'b0000000000101111},
        {16'b0000000000100100},
        {16'b1111111111101101},
        {16'b1111111111001110},
        {16'b1111111111011011}

    };

        #10 start = 1'b1;
        #10 start = 1'b0;

        #2000 $stop;
    end 

    always #5 clk = ~clk;

    
endmodule