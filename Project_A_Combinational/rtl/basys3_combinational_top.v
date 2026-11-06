`timescale 1ns / 1ps
// ECE 128 Lab 8 - Project A board-demo version (verified with physical LEDs).
// SW[3:0]=A, SW[7:4]=B; LD[7:0]=product; LD[15:8]=input switches.
module basys3_combinational_top (
    input  wire [7:0] sw,
    output wire [15:0] led
);
    wire [7:0] product;

    combinational_multiplier dut (
        .a(sw[3:0]),
        .b(sw[7:4]),
        .product(product)
    );

    assign led[7:0]  = product;
    assign led[15:8] = sw; // visible input indicators used in demo
endmodule
