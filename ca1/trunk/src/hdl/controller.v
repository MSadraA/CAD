module controller(
    input clk,
    input rst,
    input start,
    input count_done1,
    input count_done2,
    input carry2,
    input carry3,
    input carry4,
    output reg Countrst1,
    output reg Countrst2,
    output reg Countrst3,
    output reg Countrst4,
    output reg ld1,
    output reg ld2,
    output reg ld3,
    output reg ld4,
    output reg ld5,
    output reg Inc1,
    output reg Inc2,
    output reg Inc3,
    output reg Inc4,
    output reg Shle1,
    output reg Shle2,
    output reg Shre,
    output reg We,
    output reg done
);
    parameter Idle = 4'd0 , Init = 4'd1 , Load1 = 4'd2 , Load2 = 4'd3 , Shift12 = 4'd4 ,
    Shift1 = 4'd5 , Shift2 = 4'd6 , ShiftDone = 4'd7 , Shiftr1 = 4'd8 , Shiftr2 = 4'd9 ,
    Write = 4'd10 , Done = 4'd11;

    reg [3:0] ps , ns;

    always @(ps , start , count_done1 , count_done2 , carry2 , carry3 , carry4) begin
        ns = Idle;
        case (ps)
            Idle : ns = (start) ? Init : Idle;
            Init : ns = (start) ? Init : Load1;
            Load1 : ns = Load2; 
            Load2 : ns = Shift12;
            Shift12 : begin
                if((~count_done1)&(~count_done2))
                    ns = Shift12;
                else begin
                    if((count_done1)&(~count_done2))
                        ns = Shift2;
                    else if ((~count_done1)&(count_done2))
                        ns = Shift1;
                    else if ((count_done1)&(count_done2))
                        ns = ShiftDone;
                end
            end
            Shift1 : ns = (count_done1) ? ShiftDone : Shift1;
            Shift2 : ns = (count_done2) ? ShiftDone : Shift2;
            ShiftDone : ns = Shiftr1;
            Shiftr1 : ns = (carry2) ? Shiftr2 : Shiftr1;
            Shiftr2 : ns = (carry3) ? Write : Shiftr2;
            Write : ns = (carry4) ? Done : Load1;
            Done : ns = Idle;
            default: ns = Idle;
        endcase
    end

    always @(ps) begin
        {Countrst1 , Countrst2 , Countrst3 , Countrst4 , ld1 , ld2 , ld3 , ld4 , ld5 , Inc1 , Inc2 ,
        Inc3 , Inc4 , Shle1 , Shle2 , Shre , We , done} = 18'b0;
        case (ps)
            Init : begin Countrst1 = 1'b1 ; Countrst4 = 1'b1; end
            Load1 : begin Countrst2 = 1'b1 ; Countrst3 = 1'b1 ; ld1 = 1'b1 ; Inc1 = 1'b1; end
            Load2 : begin ld2 = 1'b1; end
            Shift12 :begin Shle1 = 1'b1 ; Shle2 = 1'b1 ; Inc3 = 1'b1; end
            Shift1 : begin Shle1 = 1'b1 ; Inc2 = 1'b1; end
            Shift2 : begin Shle2 = 1'b1 ; Inc3 = 1'b1; end
            ShiftDone : begin ld4 = 1'b1 ; ld5 = 1'b1 ; ld3 = 1'b1; end
            Shiftr1 : begin Inc2 = 1'b1 ; Shre = 1'b1;  end
            Shiftr2 : begin Inc3 = 1'b1 ; Shre = 1'b1; end
            Write : begin Inc4 = 1'b1 ; We = 1'b1; end
            Done : begin done = 1'b1; end

            default: 
                {Countrst1 , Countrst2 , Countrst3 , Countrst4 , ld1 , ld2 , ld3 , ld4 , ld5 , Inc1 , Inc2 ,
                Inc3 , Inc4 , Shle1 , Shle2 , Shre , We , done} = 18'b0;
        endcase
    end
    
    always @(posedge clk or posedge rst) begin
        if(rst)
            ps <= Idle;
        else
            ps <= ns;
    end


endmodule