`timescale 1ns / 1ps
// Lab 8 - Q2: 4-bit unsigned combinational multiplier.
// Level-1 implementation matches the prelab: four partial products and an adder tree.
module combinational_multiplier (
    input  wire [3:0] a,
    input  wire [3:0] b,
    output wire [7:0] product
);
    // Each 4-bit partial product is zero-extended to 8 bits before shifting.
    wire [7:0] pp0, pp1, pp2, pp3;
    wire [7:0] sum01, sum23;

    assign pp0 = {4'b0000, (a & {4{b[0]}})};
    assign pp1 = {4'b0000, (a & {4{b[1]}})} << 1;
    assign pp2 = {4'b0000, (a & {4{b[2]}})} << 2;
    assign pp3 = {4'b0000, (a & {4{b[3]}})} << 3;

    assign sum01  = pp0 + pp1;
    assign sum23  = pp2 + pp3;
    assign product = sum01 + sum23;
endmodule
