module Controller(
    input clk,
    input rst,
    input read_en,
    input write_en,
    input empty,
    input full,
    output reg valid,
    output reg ready,
    output reg ld1,
    output reg ld2,
    output reg ld3

);
    parameter Init = 4'd0 , Write = 4'd1 , Read = 4'd2 , Idle = 4'd3 , Write_read = 4'd4,
              Write_wait_for_reading = 4'd5, Read_wait_for_writing = 4'd6,
              wait_for_reading = 4'd7, wait_for_writing = 4'd8, Write2 = 4'd9, Read2 = 4'd10;
    reg [3:0] ps , ns;

    always @(*) begin
        ns = Init;
        case (ps)
            Init :begin
                if(~write_en)
                    ns = Init;
                else 
                        ns = Write;
            end
            Write :begin
                if((write_en) && (~read_en) && (~full))
                    ns = Write;
                else if ((~write_en) && (read_en) && (~empty))
                    ns = Read;
                else if ((~write_en) && (~read_en))
                    ns = Idle;
                else if ((write_en) && (read_en) && (~empty) && (~full))
                    ns = Write_read;
                else if ((write_en) && (read_en) && (empty))
                    ns = Write_wait_for_reading;
                else if ((write_en) && (read_en) && (full))
                    ns = Read_wait_for_writing;
                else if ((~write_en) && (read_en) && (empty))
                    ns = wait_for_reading;
                else if ((write_en) && (~read_en) && (full))
                    ns = wait_for_writing;
            end

            Read :begin
                if((write_en) && (~read_en) && (~full))
                    ns = Write;
                else if ((~write_en) && (read_en) && (~empty))
                    ns = Read;
                else if ((~write_en) && (~read_en))
                    ns = Idle;
                else if ((write_en) && (read_en) && (~empty) && (~full))
                    ns = Write_read;
                else if ((write_en) && (read_en) && (empty))
                    ns = Write_wait_for_reading;
                else if ((write_en) && (read_en) && (full))
                    ns = Read_wait_for_writing;
                else if ((~write_en) && (read_en) && (empty))
                    ns = wait_for_reading;
                else if ((write_en) && (~read_en) && (full))
                    ns = wait_for_writing;
            end

            Write :begin
                if((write_en) && (~read_en) && (~full))
                    ns = Write;
                else if ((~write_en) && (read_en) && (~empty))
                    ns = Read;
                else if ((~write_en) && (~read_en))
                    ns = Idle;
                else if ((write_en) && (read_en) && (~empty) && (~full))
                    ns = Write_read;
                else if ((write_en) && (read_en) && (empty))
                    ns = Write_wait_for_reading;
                else if ((write_en) && (read_en) && (full))
                    ns = Read_wait_for_writing;
                else if ((~write_en) && (read_en) && (empty))
                    ns = wait_for_reading;
                else if ((write_en) && (~read_en) && (full))
                    ns = wait_for_writing;
            end

            Idle :begin
                if((write_en) && (~read_en) && (~full))
                    ns = Write;
                else if ((~write_en) && (read_en) && (~empty))
                    ns = Read;
                else if ((~write_en) && (~read_en))
                    ns = Idle;
                else if ((write_en) && (read_en) && (~empty) && (~full))
                    ns = Write_read;
                else if ((write_en) && (read_en) && (empty))
                    ns = Write_wait_for_reading;
                else if ((write_en) && (read_en) && (full))
                    ns = Read_wait_for_writing;
                else if ((~write_en) && (read_en) && (empty))
                    ns = wait_for_reading;
                else if ((write_en) && (~read_en) && (full))
                    ns = wait_for_writing;
            end

            Write_read :begin
                if((write_en) && (~read_en) && (~full))
                    ns = Write;
                else if ((~write_en) && (read_en) && (~empty))
                    ns = Read;
                else if ((~write_en) && (~read_en))
                    ns = Idle;
                else if ((write_en) && (read_en) && (~empty) && (~full))
                    ns = Write_read;
                else if ((write_en) && (read_en) && (empty))
                    ns = Write_wait_for_reading;
                else if ((write_en) && (read_en) && (full))
                    ns = Read_wait_for_writing;
                else if ((~write_en) && (read_en) && (empty))
                    ns = wait_for_reading;
                else if ((write_en) && (~read_en) && (full))
                    ns = wait_for_writing;
            end

            Write_wait_for_reading :begin
                if(empty)
                    ns = wait_for_reading;
                else
                    ns = Read;
                
            end

            Read_wait_for_writing :begin
                if(full)
                    ns = wait_for_writing;
                else
                    ns = Write;
                
            end

            wait_for_reading :begin
                if(~write_en)
                    ns = wait_for_reading;
                else
                    ns = Write2;
                
            end

            wait_for_writing :begin
                if(~read_en)
                    ns = wait_for_writing;
                else
                    ns = Read2;
                
            end

            Write2 :begin
                if(empty)
                    ns = wait_for_reading;
                else
                    ns = Read;
                
            end

            Read2 :begin
                if(full)
                    ns = wait_for_writing;
                else
                    ns = Write;
                
            end
        endcase
    end

    always @(ps) begin
        {valid, ready, ld1, ld2, ld3} = 5'd0;
        case (ps)
            Write : {ld1, ld2, ready} = 3'b111 ;
            Read : {ld3, valid} = 2'b11;
            Write_read : {valid, ready, ld1, ld2, ld3} = 5'b11111;
            Write_wait_for_reading : {ready, ld1, ld2} = 3'b111;
            Read_wait_for_writing : {valid, ld3} = 2'b11;
            Write2 : {ld1, ld2, ready} = 3'b111;
            Read2 : {ld3, valid} = 2'b11;
            default: 
                {valid, ready, ld1, ld2, ld3} = 5'd0;
        endcase
    end
    
    always @(posedge clk or posedge rst) begin
        if(rst)
            ps <= Init;
        else
            ps <= ns;
    end


endmodule