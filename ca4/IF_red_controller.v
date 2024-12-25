module IF_read_controller (
    input clk ,
    input rst,
    input en,
    input empty,
    input start_bit,
    input end_bit,
    input co,
    output reg buf_wen,
    output reg buf_ren,
    output reg ld_start,
    output reg ld_end,
    output reg sp_wen,
    output reg write_cnt_en,
    output reg row_ptr_cnt_en,
    output reg done
);
    parameter [3:0] Idle = 4'd0 , Write_buf = 4'd1 , Read_buf = 4'd2 ,
    Load_start = 4'd3 , Load_row = 4'd4 , Load_end = 4'd5 , Read_other_row = 4'd6 ,
    Single_element = 4'd7 , Done = 4'd8 , Stall = 4'd9;

    reg[3:0] ps , ns;

    //determine next state using input signals
    always @(*) begin
        case (ps)
            Idle : ns = (en) ? Write_buf:Idle;
            Write_buf : ns = (empty) ? Write_buf:Read_buf;
            Read_buf : begin
                if(start_bit == 1'b0)
                    ns = Read_buf;
                else 
                    ns = (end_bit) ? Single_element:Load_start;
            end 
            Load_start : ns = (empty) ? Stall : Load_row;
            Load_row : begin
                if(end_bit)
                    ns = Load_end;
                else
                    ns = (empty) ? Stall : Load_row;
            end
            Load_end : ns = (co || empty) ? Done : Read_other_row;
            Read_other_row : begin
                if(start_bit == 1'b0)
                    ns = Read_other_row;
                else
                    ns = (end_bit) ? Single_element : Load_start;
            end
            Single_element : ns = (co || empty) ? Done : Read_buf;
            Done : ns = Idle;
            Stall : ns = (empty) ? Stall : Load_row;
            default: ns = Idle;
        endcase
    end

    //determine output signals
    always @(ps) begin
        case (ps)

            Write_buf : begin
                buf_wen = 1'b1;
            end

            Read_buf : begin
                buf_ren = 1'b1;
            end

            Load_start : begin
                ld_start = 1'b1;
                sp_wen = 1'b1;
                write_cnt_en = 1'b1;
            end

            Load_row : begin
                sp_wen = 1'b1;
                write_cnt_en = 1'b1;
                buf_ren = 1'b1;
            end

            Load_end : begin
                ld_end = 1'b1;
                write_cnt_en = 1'b1;
                sp_wen = 1'b1;
                row_ptr_cnt_en = 1'b1;
            end

            Read_other_row : begin
                buf_ren = 1'b1;
            end

            Single_element : begin
                ld_start = 1'b1;
                ld_end = 1'b1;
                row_ptr_cnt_en = 1'b1;
                sp_wen = 1'b1;
            end

            Done : begin
                done = 1'b1;
            end

            Stall : begin
                buf_wen = 1'b1;
            end

            default: {buf_wen , buf_ren , ld_start , ld_end,sp_wen , write_cnt_en , row_ptr_cnt_en , done} = 8'b0;
        endcase
    end

    always @(posedge clk or posedge rst) begin
        if(rst)
            ps <= Idle;
        else
            ps <= ns;
    end
endmodule