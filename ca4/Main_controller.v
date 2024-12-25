module Main_controller (
    input clk,
    input rst,
    input start,
    input done1,
    input done2,
    input filter_full,
    input if_full,
    input write_done,
    input finish_row,
    input finish_filter,
    input input_end,
    input filter_end,
    output reg en1,
    output reg en2,
    output reg ld_row_ptr,
    output reg clr_index,
    output reg clr_filter_head,
    output reg ld_filter_head,
    output reg index_cnt_en,
    output reg row_ptr_cnt_en,
    output reg sel,
    output reg filter_cnt_en,
    output reg ld_input_head,
    output reg clr_row_ptr,
    output reg filter_ren,
    output reg chip_en,
    output reg conv_done,
    output reg done
);

    parameter [4:0] Idle = 5'd0 , Wait = 5'd1 , Write_sp = 5'd2 , HS1 = 5'd3 ,
    HS2 = 5'd4 , Write_done = 5'd5 , Read_filter = 5'd6 , Mul = 5'd7, Add = 5'd8,
    Done = 5'd9 , Check = 5'd10 , Finish = 5'd11 , S = 5'd12 , Change_row = 5'd13,
    Stride = 5'd14 , Continue = 5'd15 , Change_filter = 5'd16;
    
    reg [4:0] ps , ns;

    //determine next state
    always @(*) begin
        case (ps)
            Idle : ns = (start) ? Wait : Idle;
            Wait : ns = (start) ? Wait : Write_sp;
            Write_sp : begin
                if(if_full || filter_full)
                    ns = Idle;
                else begin
                if (~done1 && ~done2)
                    ns = Write_sp;
                else if (done1 && ~done2)
                    ns = HS1;
                else if (~done1 && done2)
                    ns = HS2;
                else if (done1 && done2)
                    ns = write_done;
                end
            end 
            HS1 : begin
                if(filter_full)
                    ns = Idle;
                else 
                    ns = (done2) ? Write_done : HS1;
            end
            HS2 : begin
                if(if_full)
                    ns = Idle;
                else
                    ns = (done1) ? Write_done : HS2;
            end
            write_done : ns = Read_filter;
            Read_filter : ns = Mul;
            Mul : ns = Add ;
            Add : ns = Done;
            Done : ns = (write_done) ? Check : Done;
            Check : begin
                if(finish_row)
                    ns = Finish;
                else
                    ns = (finish_filter) ? Change_row : S; 
            end
            Change_row : ns = Read_filter;
            S : begin
                if(input_end)
                    ns = Change_filter;
                else
                    ns = (filter_end) ? Stride : Continue;
            end
            Stride : ns = Read_filter;
            Continue : ns = Read_filter;
            Change_filter : ns = Read_filter;
            Finish : ns = Idle;
            default: ns = Idle;
        endcase
    end

    //determine output signals
    always @(ps) begin
        case (ps)
            Write_sp : begin
                en1 = 1'b1;
                en2 = 1'b1;
            end 

            Write_done : begin
                ld_row_ptr = 1'b1;
                clr_index = 1'b1;
                clr_filter_head = 1'b1;
                sel = 1'b1;
                ld_input_head = 1'b1;
                clr_row_ptr = 1'b1;
            end

            Read_filter : begin
                filter_ren = 1'b1;
                chip_en = 1'b1;
            end

            Done : begin
                conv_done = 1'b1;
            end

            Finish : begin
                done = 1'b1;
            end

            Change_row : begin
                clr_filter_head = 1'b1;
                row_ptr_cnt_en = 1'b1;
                sel = 1'b1;
                ld_input_head = 1'b1;
            end

            Stride : begin
                ld_input_head = 1'b1;
                clr_index = 1'b1;
            end

            Continue : begin
                index_cnt_en = 1'b1;
            end

            Change_filter : begin
                sel = 1'b1;
                ld_input_head = 1'b1;
                clr_index = 1'b1;
                ld_filter_head = 1'b1;
                filter_cnt_en = 1'b1;
            end

            default: {en1 , en2 , ld_filter_head , ld_input_head , ld_row_ptr , clr_index , clr_filter_head ,
            sel , filter_cnt_en , index_cnt_en , chip_en , conv_done , done , row_ptr_cnt_en , filter_ren} = 15'b0;
        endcase
    end
endmodule