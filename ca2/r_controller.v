module r_controller(
    input clk,
    input rst,
    input read_en,
    input empty,
    input full,
    output reg ld3,
    output reg valid
);
    parameter Idle = 2'd0 , HS = 2'd1 , Read = 2'd2 ;
    reg [1:0] ps , ns;

    always @(*) begin
        ns = Idle;
        case (ps)
            Idle :begin
                if((~read_en) || ((empty) && (~empty || ~full)))
                    ns = Idle;
                else begin
                    if((read_en) && ((~empty) || (empty && full)))
                        ns = Read;
                end
            end
            // HS : ns = (read_en) ? HS : Read;
            Read : ns = Idle;
        endcase
    end

    always @(ps) begin
        {ld3 , valid} = 2'b0;
        case (ps)
            // HS : valid = 1'b1 ;
            Read : begin {ld3} = 1'b1; valid = ~empty; end
            default: 
                {ld3 , valid} = 2'b0;
        endcase
    end
    
    always @(posedge clk or posedge rst) begin
        if(rst)
            ps <= Idle;
        else
            ps <= ns;
    end


endmodule