module Filter_read_controller (
    input clk,
    input rst,
    input en,
    input empty,
    input res,
    output reg chip_en,
    output reg buf_wen,
    output reg buf_ren,
    output reg write_cnt_en,
    output reg sp_wen ,
    output reg done
);

    parameter [2:0] Idle = 3'd0 , Write_Buf = 3'd1 , Load_filter = 3'd2 ,
    Stall = 3'd3 , Done = 3'd4;

    reg [2:0] ps , ns;

    //determine next state
    always @(*) begin
        case (ps)
            Idle : ns = (en) ? Write_Buf : Idle;
            Write_Buf : ns = (empty) ? Write_Buf : Load_filter;
            Load_filter : begin
                if(empty == 1'b0)
                    ns = Load_filter;
                else
                    ns = (res) ? Done : Stall;
            end
            Done : ns = Idle;
            Stall : ns = (empty) ? Stall : Load_filter;
            default: ns = Idle;
        endcase
    end

    //determine output signals
    always @(ps) begin
        case (ps)
            Write_Buf : begin
                buf_wen = 1'b1;    
            end

            Load_filter: begin
                sp_wen = 1'b1;
                buf_ren = 1'b1;
                chip_en = 1'b1;
                write_cnt_en = 1'b1;
            end

            Done : begin
                done = 1'b1;
            end

            Stall : begin
                buf_wen = 1'b1;
            end

            default: {buf_ren , buf_wen , chip_en , write_cnt_en , done , sp_wen} = 6'b0;
        endcase
    end
    
    always @(posedge clk or posedge rst) begin
        if(rst)
            ps <= Idle;
        else
            ps <= ns;
    end

endmodule