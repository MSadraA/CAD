module controller (
    input clk,
    input rst,
    input start,
    input count_done,
    input zero,
    output reg ld1,
    output reg ld2,
    output reg sel,
    output reg shift_left,
    output reg shift_right,
    output reg done
);
    parameter [3:0] Idle = 4'd0 , Init = 4'd1 ,  Count = 4'd2 , Load = 4'd3 , 
    Shift = 4'd4 , Done = 4'd5;

    reg [3:0] ps , ns;

    always @(*) begin
        case (ps)
            Idle : ns = (start) ? Init : Idle;
            Init : ns = (start) ? Init : Count;
            Count : ns = (count_done) ? Load : Count;
            Load : ns = (zero) ? Done : Shift;
            Shift : ns = (zero) ? Done : Shift;
            default: ns = Idle;
        endcase
    end

    always @(ps) begin
        {ld1 , ld2 , sel , shift_left , shift_right , done} = 6'b0;
        case (ps)
            Init : begin ld1 = 1'b1 ; ld2 = 1'b1 ; end
            Count : begin shift_left = 1'b1; end
            Load : begin sel = 1'b1; ld1 = 1'b1; ld2 = 1'b1; end
            Shift : begin shift_right = 1'b1 ;end
            Done : begin done = 1'b1; end
        endcase
    end

    always @(posedge clk , posedge rst) begin
        if(rst) ps <= Idle;
        else ps <= ns;
    end
    
endmodule