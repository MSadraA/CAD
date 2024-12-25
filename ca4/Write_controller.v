module Write_controller (
    input clk,
    input rst,
    input conv_done,
    input full,
    output reg cnt_en,
    output reg wen,
    output reg write_done
);
    parameter [2:0] Idle = 3'd0 , Check = 3'd1 , Write = 3'd2;

    reg [2:0] ps , ns;

    always @(*) begin
        case (ps)
            Idle : ns = (conv_done) ? Check : Idle;
            Check : ns = (full) ? Check : Write;
            Write : ns = Idle; 
            default: ns = Idle;
        endcase
    end

    always @(ps) begin
        case (ps)
            Write : begin
                cnt_en = 1'b1;
                wen = 1'b1;
                write_done = 1'b1;
            end 
            default: {cnt_en , wen , write_done} = 3'b0;
        endcase
    end

    always @(posedge clk or posedge rst) begin
        if(rst)
            ps <= Idle;
        else
         ps <= ns;
    end
endmodule