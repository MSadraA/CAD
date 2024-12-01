module counter_3bit (
    input clk,
    input rst,
    input up_cnt_en,
    input down_cnt_en,
    output reg [2:0] par_out,
    output carry_out
);

    always @(posedge clk or posedge rst) begin
        if (rst)
            par_out <= 3'b0; 
        else if (up_cnt_en)
            par_out <= par_out + 1; 
        else if (down_cnt_en)
            par_out <= par_out - 1; 
    end

        assign carry_out = (((par_out == 3'b111) && up_cnt_en) || ((par_out == 3'b000) && down_cnt_en));
    

endmodule
