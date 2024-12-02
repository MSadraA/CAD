module counter_4bit (
    input clk,
    input rst,
    input up_cnt_en,
    input down_cnt_en,
    output reg [3:0] par_out,
    output carry_out
);

    always @(posedge clk , posedge rst) begin
        if (rst) begin
            par_out <= 4'b0;
        end
        else begin
        if (up_cnt_en)
            par_out <= par_out + 1; 
        else if (down_cnt_en)
            par_out <= par_out - 1; 
        end
    end

        assign carry_out = par_out[3];

    
endmodule
