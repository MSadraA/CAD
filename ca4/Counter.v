module Counter #(
    parameter WIDTH = 4 // حداقل سایز قابل پشتیبانی
)(
    input clk,
    input rst,
    input inc,
    input clr,
    output reg [WIDTH - 1:0] dout, // تعداد بیت‌های لازم
    output reg cout
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            {dout , cout} <= 0;
        end else if (clr) begin
            {dout , cout} <= 0;
        end else if (inc) begin
            {cout , dout} <= dout + 1;
        end
    end

endmodule
