module RAM
#(
    parameter WIDTH = 4,
    parameter HEIGHT = 4,
    parameter ADD_WIDTH = (HEIGHT > 1) ? $clog2(HEIGHT) : 1
)
(
    input clk,
    input rst,
    input [ADD_WIDTH-1:0] addr,
    input [WIDTH-1:0] din,
    input ld,
    output reg [WIDTH-1:0] dout
);

    reg [WIDTH-1:0] mem [HEIGHT-1:0];
    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < HEIGHT; i = i + 1) begin
                mem[i] <= {WIDTH{1'b0}};
            end
            dout <= {WIDTH{1'b0}};
        end else if (ld) begin
            mem[addr] <= din;
        end else begin
            dout <= mem[addr];
        end
    end

endmodule
