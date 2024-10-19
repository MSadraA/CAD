module Up_counter_4bit
(
    input clk,
    input rst,
    input inc,
    output reg [3:0] par_out
);
    always @(posedge clk) begin
        if(rst)
            par_out <= 4'b0;
        else if(inc)
            par_out <= par_out + 1'b1
    end
endmodule
