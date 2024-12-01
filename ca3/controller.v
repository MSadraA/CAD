module controller (
    input clk,
    input rst,
    input start,
    input count_done,
    input co1,
    input co2,
    output reg ld1,
    output reg ld2,
    output reg sel,
    output reg shift_left,
    output reg shift_right,
    output reg done ,
    output reg down_cnt1,
    output reg down_cnt2
);
    parameter [3:0] Idle = 4'd0 , Init = 4'd1 ,  Count = 4'd2 , Load = 4'd3 , 
    Shift1 = 4'd4 , Stall1 = 4'd5 , Shift2 = 4'd6 , Stall2 = 4'd7 , Stall3 = 4'd8;

    reg [3:0] ps , ns;

    always @(*) begin
        case (ps)
            Idle : ns = (start) ? Init : Idle;
            Init : ns = (start) ? Init : Count;
            Count : ns = (count_done) ? Load : Count;
            Load : ns = Stall3;
            Stall3 : ns = Stall1;
            Stall1 : ns = (co1) ? Stall2 : Shift1;
            Shift1 : ns = (co1) ? Stall2 : Shift1;
            Stall2 : ns = (co2) ? Idle : Shift2;
            Shift2 : ns = (co2) ? Idle : Shift2;
            default: ns = Idle;
        endcase
    end

    always @(ps) begin
        {ld1 , ld2 , sel , down_cnt2 , down_cnt1 , shift_left , shift_right , done} = 8'b0;
        case (ps)
            Idle : begin done = 1'b1; end
            Init : begin ld1 = 1'b1; ld2 = 1'b1; end
            Count : begin shift_left = 1'b1; end
            Load : begin sel = 1'b1; ld1 = 1'b1; ld2 = 1'b1; down_cnt1 = 1'b1 ; down_cnt2 = 1'b1 ; end
            Shift1 : begin shift_right = 1'b1; down_cnt1 = 1'b1; end
            Shift2 : begin shift_right = 1'b1; down_cnt2 = 1'b1; end
        endcase
    end

    always @(posedge clk , posedge rst) begin
        if(rst) ps <= Idle;
        else ps <= ns;
    end
    
endmodule