module W_controller(
    input clk,
    input rst,
    input full,
    input w_en,
    output reg ready,
    output reg ld1,
    output reg ld2
);
    parameter Idle = 2'd0 , HS = 2'd1 , Write = 2'd2 ;
    reg [1:0] ps , ns;

    always @(*) begin
        ns = Idle;
        case (ps)
            Idle :begin
                if((~w_en) || full)
                    ns = Idle;
                else begin
                    if((w_en)&(~full))
                        ns = HS;
                end
            end
            HS : ns = (w_en) ? HS : Write;
            Write : ns = Idle;
        endcase
    end

    always @(*) begin
        {ready , ld1 , ld2} = 3'b0;
        case (ps)
            HS : ready= 1'b1 ;
            Write : begin ld1 = 1'b1 ; ld2 = 1'b1; end
            default: 
                {ready , ld1 , ld2} = 3'b0;
        endcase
    end
    
    always @(posedge clk or posedge rst) begin
        if(rst)
            ps <= Idle;
        else
            ps <= ns;
    end


endmodule