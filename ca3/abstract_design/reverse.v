module reverse_bits #(parameter N = 8) ( // N طول بیت‌های ورودی و خروجی
    input  [N-1:0] in,   // ورودی N بیتی
    output [N-1:0] out   // خروجی N بیتی با بیت‌های معکوس
);
    genvar i;  // متغیر برای تولید سخت‌افزار
    generate
        for (i = 0; i < N; i = i + 1) begin : bit_reverse
            assign out[i] = in[N-1-i];
        end
    endgenerate
endmodule
