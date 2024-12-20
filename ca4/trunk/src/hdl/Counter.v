module Counter #(
    parameter WIDTH = 8
)(
    input clk,
    input rst,
    input inc,
    output reg [WIDTH-1:0] dout,
    output reg cout
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            dout <= 0;
        end
        else if (inc) begin
            dout <= dout + 1;
        end
    end

    assign carry = (out == WIDTH{1'b1}) ? 1'b1 : 1'b0;
endmodule