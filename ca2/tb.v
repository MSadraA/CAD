module tb (
);
    wire [15:0] out;
    reg [15:0] in [0:3];

    initial begin
        in[0] = 16'd0;
        in[1] = 16'd1;
        in[2] = 16'd2;
        in[3] = 16'd3;
    end
    
    Mux_k_to_1 #(4 , 16) test(.in(in) , .sel(2'd2) , .out(out));
endmodule