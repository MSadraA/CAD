module controller(
    input clk,
    input rst,
    input read_en,
    input empty,
    output valid,
    output ld3
);
    parameter Idle = 2'd0 , HS = 2'd1 , Read = 2'd2 ;
    reg [1:0] ps , ns;

    always @(*) begin
        ns = Idle;
        case (ps)
            Idle :begin
                if((~read_en) || empty)
                    ns = Idle;
                else begin
                    if((read_en)&(~empty))
                        ns = HS;
                end
            end
            HS : ns = (read_en) ? HS : Read;
            Read : ns = Idle;
        endcase
    end

    always @(ps) begin
        {valid , ld3} = 2'b0;
        case (ps)
            HS : valid = 1'b1 ;
            Read : ld3 = 1'b1;
            default: 
                {ready , ld1 , ld2} = 3'b0;;
        endcase
    end
    
    always @(posedge clk or posedge rst) begin
        if(rst)
            ps <= Idle;
        else
            ps <= ns;
    end


endmodule