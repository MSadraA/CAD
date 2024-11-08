module W_controller(
    input clk,
    input rst,
    input full,
    input empty,
    input w_en,
    output reg ld1,
    output reg ld2,
    output reg ready
);
    parameter Idle = 2'd0 , HS = 2'd1 , Write = 2'd2 ;
    reg [1:0] ps , ns;

    always @(*) begin
        ns = Idle;
        case (ps)
            Idle :begin
                if((~w_en) || ((full) && (~full || ~empty)))
                    ns = Idle;
                else begin
                    if((w_en)&((~full) || (full && empty)))
                        ns = Write;
                end
            end
            // HS : ns = (w_en) ? HS : Write;
            Write : ns = Idle;
        endcase
    end

    always @(ps) begin
        {ld1 , ld2 , ready} = 3'b0;
        case (ps)
            // HS : ready= 1'b1 ;
            Write : begin ld1 = 1'b1 ; ld2 = 1'b1; ready = ~full; end
            default: 
                { ld1 , ld2 ,ready} = 3'b0;
        endcase
    end
    
    always @(posedge clk or posedge rst) begin
        if(rst)
            ps <= Idle;
        else
            ps <= ns;
    end


endmodule