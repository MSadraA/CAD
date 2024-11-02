module tb (
);
    wire [15:0] out;
    reg [15:0] in [0:3];

    
    Mux_k_to_1 #(4 , 16) test(.in(in) , .sel(2'd2) , .out(out));
endmodule