module Ram 
#(
    parameter WIDTH = 16,
    parameter SIZE = 8
)
(
    input clk,
    input rst,
    input ld,
    input [(SIZE*WIDTH)-1:0] par_in,      
    output reg [(SIZE*WIDTH)-1:0] par_out 
);

   
    reg [WIDTH-1:0] regblock [0:SIZE-1]; 

    integer i;

    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < SIZE; i = i + 1) begin
                regblock[i] <= {WIDTH{1'b0}};
            end
        end else if (ld) begin
            for (i = 0; i < SIZE; i = i + 1) begin
                regblock[i] <= par_in[i*WIDTH +: WIDTH];
            end
        end
    end

    always @(*) begin
        for (i = 0; i < SIZE; i = i + 1) begin
            par_out[i*WIDTH +: WIDTH] = regblock[i];
        end
    end

endmodule

