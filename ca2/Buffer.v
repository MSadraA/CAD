module Buffer #(
    parameter SIZE = 16,    // Buffer size
    parameter WIDTH = 8,    // Data width
    parameter K = 4,        // Input parallel factor
    parameter J = 4,        // Output parallel factor
    parameter BIT = $clog2(SIZE)  // Address bits
) (
    input wire clk,
    input wire ld,
    input wire rst,
    input wire [BIT-1:0] write_add,
    input wire [BIT-1:0] read_add,
    input wire [(WIDTH*K)-1:0] par_in,
    output wire [(WIDTH*J)-1:0] par_out
);
    // Internal signals
    wire [BIT*K-1:0] generated_add;
    wire [(SIZE*$clog2(K))-1:0] generated_sel;
    wire [SIZE-1:0] load_sel;
    wire [WIDTH-1:0] selected [0:SIZE-1];
    wire [(WIDTH*SIZE)-1:0] ram_out;  // Fixed RAM_SIZE to WIDTH
    wire [(SIZE*WIDTH)-1:0] ram_in;
    wire [($clog2(SIZE)*J)-1:0] gen_out;

    // Logic module instantiation
    Logic #(
        .SIZE(SIZE),
        .K(K)
    ) logic_inst (
        .address_in(write_add),
        .generated_nums(generated_add),
        .final_result(generated_sel)
    );

    // Decoder module instantiation
    Decoder #(
        .SIZE(SIZE),
        .K(K)
    ) decoder (
        .generated_addr(generated_add),
        .out(load_sel)
    );

    // Input mux generation for K-to-1 multiplexers
    genvar i;
    generate
        for (i = 0; i < SIZE; i = i + 1) begin : input_mux_gen
            wire [$clog2(K)-1:0] sel;
            
            assign sel = generated_sel[$clog2(K)*(i+1)-1:$clog2(K)*i];
            
            Mux_k_to_1 #(
                .WIDTH(WIDTH),
                .K(K)
            ) mux_k_to_1 (
                .in_bus(par_in),
                .sel(sel),
                .out(selected[i])
            );
        end
    endgenerate

    // 2-to-1 multiplexer generation
    generate
        for (i = 0; i < SIZE; i = i + 1) begin : mux_2to1_gen
            wire sel;
            assign sel = load_sel[i];
            
            Mux_2_to_1 #(
                .WIDTH(WIDTH)
            ) mux_2_to_1 (
                .sel(sel),
                .a(ram_out[WIDTH*(i+1)-1:WIDTH*i]),  // Added missing connection
                .b(selected[i]),
                .out(ram_in[WIDTH*(i+1)-1:WIDTH*i])
            );
        end
    endgenerate

    // RAM instantiation
    Ram #(
        .SIZE(SIZE),
        .WIDTH(WIDTH)
    ) ram (
        .clk(clk),
        .rst(rst),
        .ld(ld),          // Fixed missing comma
        .par_in(ram_in),
        .par_out(ram_out)
    );

    // Output generator instantiation
    Generator #(
        .SIZE(SIZE),
        .K(J)
    ) generator (
        .num_in(read_add),
        .num_out(gen_out)
    );

    // Output mux generation
    generate
        for (i = 0; i < J; i = i + 1) begin : output_mux_gen
            wire [BIT-1:0] sel;  // Fixed sel width
            assign sel = gen_out[BIT*(i+1)-1:BIT*i];
            
            Mux_k_to_1 #(
                .WIDTH(WIDTH),
                .K(SIZE)
            ) mux_k_to_1_out (
                .in_bus(ram_out),
                .sel(sel),
                .out(par_out[WIDTH*(i+1)-1:WIDTH*i])
            );
        end
    endgenerate

endmodule