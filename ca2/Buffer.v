module Buffer #(
    parameter SIZE = 16,
    parameter WIDTH = 8,
    parameter K = 4,
    parameter J = 4,
    parameter BIT = $clog2(SIZE)
) (
    input clk,
    input ld,
    input rst,
    input [BIT - 1: 0 ] write_add,
    input [BIT - 1 : 0] read_add,
    input [(WIDTH * K)- 1:0] par_in,
    output [(WIDTH * J)-1:0] par_out
);
    wire [BIT * K - 1:0] generated_add;
    wire [(SIZE * $clog2(K)) - 1:0] generated_sel;
    wire [SIZE - 1:0] load_sel;

    wire [WIDTH - 1 :0] selected [0:SIZE - 1];

    wire [(RAM_SIZE*SIZE)-1:0] ram_out;
    wire [(SIZE*WIDTH)-1:0] ram_in;


    Logic #(.SIZE(SIZE) , .K(K))
    logic
    (
        .address_in(write_add),
        .generated_nums(generated_add),
        .final_result(generated_sel)
    );

    Decoder #(.SIZE(SIZE) , .K(K))
    decoder
    (
        .generated_addr(generated_add),
        .out(load_sel)
    );

    genvar i;
    generate
        for (i = 0; i < SIZE; i = i + 1) begin : 
            wire [$clog2(K)-1:0] sel;
    
            assign sel = generated_sel[$clog2(K) * (i + 1) -1:$clog2(K) * (i)];
            Mux_k_to_1 #(.WIDTH(WIDTH) , .K(K))
            mux_k_to_1
            (
                .in_bus(par_in),
                .sel(sel),
                .out(selected[i])
            );
        end
    endgenerate

    generate
        for (i = 0; i < SIZE; i = i + 1) begin : 
            wire sel;
            assign sel = load_sel[i];

            Mux_2_to_1 #(.WIDTH(WIDTH))
            mux_2_to_1
            (
                .sel(sel)
                .a()
                .b(selected[i])
                .out(ram_in[WIDTH * (i+1) - 1 : WIDTH* i])
            );
        end
    endgenerate

    Ram #(.SIZE(SIZE) , .WIDTH(WIDTH))
    ram
    (
        .clk(clk),
        .rst(rst),
        .ld(ld)
        .par_in(ram_in),
        .par_out(ram_out)
    );

    generate
        for (i = 0; i < J; i = i + 1) begin : 
            wire sel;
            assign sel = generated_add[BIT * (i+1) - 1: BIT * i];

            Mux_k_to_1 #(.WIDTH(WIDTH) , .K(SIZE))
            mux_k_to_1_out
            (
                .in_bus(ram_out),
                .sel(sel),
                .out(par_out[WIDTH * (i+1) - 1:WIDTH *i])
            );
        end

    endgenerate

    wire [($clog2(SIZE) * K) - 1:0] generated_numbers;
    wire [WIDTH-1:0] mux_output;
    
     Generator #(
        .SIZE(SIZE),
        .K(K)
    ) generator_inst (
        .num_in(read_add),
        .num_out(generated_numbers)
    );

    // Instantiate the Mux to select one of the generated numbers
    Mux_k_to_1 #(
        .K(SIZE),
        .WIDTH(WIDTH)
    ) mux_inst (
        .in_bus(generated_numbers),
        .sel(read_add[$clog2(K)-1:0]), // Select among K outputs
        .out(mux_output)
    );

     Mux_k_to_1 #(
        .K(SIZE),
        .WIDTH(WIDTH)
    ) mux_inst (
        .in_bus(generated_numbers),
        .sel(read_add[$clog2(K)-1:0]), // Select among K outputs
        .out(mux_output)
    );

     Mux_k_to_1 #(
        .K(SIZE),
        .WIDTH(WIDTH)
    ) mux_inst (
        .in_bus(generated_numbers),
        .sel(read_add[$clog2(K)-1:0]), // Select among K outputs
        .out(mux_output)
    );

     Mux_k_to_1 #(
        .K(SIZE),
        .WIDTH(WIDTH)
    ) mux_inst (
        .in_bus(generated_numbers),
        .sel(read_add[$clog2(K)-1:0]), // Select among K outputs
        .out(mux_output)
    );

endmodule