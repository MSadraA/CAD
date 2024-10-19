`define RT     7'b0110011
`define IT     7'b0010011
`define ST     7'b0100011
`define BT     7'b1100011
`define UT     7'b0110111
`define JT     7'b1101111
`define LWT    7'b0000011
`define JALRT  7'b1100111


`define IF     5'b00000
`define ID     5'b00001
`define EXE8    5'b00010
`define EXE5    5'b00011
`define EXE3    5'b00100
`define EXE9    5'b00101
`define EXE2    5'b00110
`define EXE6    5'b00111
`define EXE7    5'b01000
`define EXE1    5'b01001
`define EXE4    5'b01010
`define MEM2   5'b01011
`define MEM1   5'b01100
`define MEM3   5'b01101
`define MEM4   5'b01110
`define MEM5   5'b01111
`define MEM6   5'b10000
`define WB     5'b10001

module MainController(clk, rst, op, zero, 
                      PCUpdate, adrSrc, memWrite, branch,
                      IRWrite, resultSrc, ALUOp, neg,
                      ALUSrcA, ALUSrcB, immSrc, regWrite);

    input [6:0] op;
    input clk, rst, zero , neg;

    output reg [1:0]  resultSrc, ALUSrcA, ALUSrcB, ALUOp;
    output reg [2:0] immSrc;
    output reg adrSrc, regWrite, memWrite, PCUpdate, branch, IRWrite;

    reg [4:0] pstate;
    reg [4:0] nstate = `IF;

    always @(pstate or op) begin
        case(pstate)
            `IF : nstate <= `ID;

            `ID: nstate <= (op == `RT) ? `EXE5 :
                           (op == `IT) ? `EXE3 :
                           (op == `ST) ? `EXE6 :
                           (op == `JT) ? `EXE9 :
                           (op == `BT) ? `EXE8 :
                           (op == `UT) ? `MEM5 :
                           (op == `LWT) ? `EXE4 :
                           (op == `JALRT) ? `EXE1: `IF;

            `EXE8 : nstate <= `MEM1;
            `EXE5 : nstate <= `MEM4;
            `EXE3 : nstate <= `IF;
            `EXE4 : nstate <= `EXE7;
            `EXE2 : nstate <= `MEM1;
            `EXE6 : nstate <= `MEM3;
            `EXE7 : nstate <= `MEM6;
            `EXE1 : nstate <= `EXE2;
            `EXE9 : nstate <= `MEM2;
            `MEM2: nstate <= `WB;
            `MEM1: nstate <= `IF;
            `MEM3: nstate <= `IF;
            `MEM4: nstate <= `IF;
            `MEM5: nstate <= `IF;
            `MEM6: nstate <= `IF;

            `WB  : nstate <= `IF;
        endcase
    end


    always @(pstate) begin

        {resultSrc, memWrite, ALUOp, ALUSrcA, ALUSrcB, immSrc, 
                regWrite, PCUpdate, branch, IRWrite} <= 14'b0;

        case(pstate)

            `IF : begin
                IRWrite   <= 1'b1;
                ALUSrcA   <= 2'b00;
                ALUSrcB   <= 2'b10;
                ALUOp     <= 2'b00;
                resultSrc <= 2'b10;
                PCUpdate  <= 1'b1;
                adrSrc = 1'b0;
            end
        
            `ID: begin
                ALUSrcA   <= 2'b01;
                ALUSrcB   <= 2'b01;
                ALUOp     <= 2'b00;
                immSrc    <= 3'b010;
            end
        
            `EXE3: begin 
                ALUSrcA   <= 2'b10;
                ALUSrcB   <= 2'b01;
                immSrc    <= 3'b000;
                ALUOp     <= 2'b11;
            end

            `EXE5: begin
                ALUSrcA   <= 2'b10;
                ALUSrcB   <= 2'b00;
                ALUOp     <= 2'b10;
            end
        
            `EXE8: begin
                ALUSrcA   <= 2'b10;
                ALUSrcB   <= 2'b00;
                ALUOp     <= 2'b01;
                resultSrc <= 2'b0;
                branch    <= 1'b1;
            end
        
            `EXE9: begin
                ALUSrcA   <= 2'b01;
                ALUSrcB   <= 2'b10;
                ALUOp     <= 2'b00;
            end
        
            `EXE2: begin
                ALUSrcA   <= 2'b01;
                ALUSrcB   <= 2'b10;
                ALUOp     <= 2'b00;
                resultSrc <= 2'b00;
                PCUpdate  <= 1'b1;
            end
        
            `EX6: begin
                ALUSrcA   <= 2'b10;
                ALUSrcB   <= 2'b01;
                ALUOp     <= 2'b00;
                immSrc    <= 3'b001;
            end
        
            `EX7: begin
                regWrite  <= 1'b1;
                ALUSrcA   <= 2'b01;
                ALUSrcB   <= 2'b01;
                immSrc    <= 3'b011;
                ALUOp     <= 2'b00;
            end

            `EX8: begin 
                ALUSrcA   <= 2'b10;
                ALUSrcB   <= 2'b01;
                immSrc    <= 3'b000;
                ALUOp     <= 2'b00;
            end

            `EXE4: begin 
                ALUSrcA   <= 2'b10;
                ALUSrcB   <= 2'b01;
                immSrc    <= 3'b000;
                ALUOp     <= 2'b00;
            end

            `MEM1: begin
                resultSrc <= 2'b00;
                adrSrc    <= 1'b1;
            end
        
            `MEM2: begin
                resultSrc <= 2'b00;
                regWrite  <= 1'b1;
            end
        
            `MEM3: begin
                resultSrc <= 2'b00;
                adrSrc    <= 1'b1;
                memWrite  <= 1'b1;
            end
        
            `MEM4: begin
                resultSrc <= 2'b00;
                regWrite  <= 1'b1;
            end
        
            `MEM5: begin
                resultSrc <= 2'b11;
                immSrc    <= 3'b100;
                regWrite  <= 1'b1;
            end
        
            `MEM6: begin
                resultSrc <= 2'b00;
                PCUpdate  <= 1'b1;
            end
        
            `WB: begin
                resultSrc <= 2'b01;
                regWrite  <= 1'b1;
                end
        
        endcase
    end

    always @(posedge clk or posedge rst) begin
        if(rst)
            pstate <= `IF;
        else
            pstate <= nstate;
    end

endmodule