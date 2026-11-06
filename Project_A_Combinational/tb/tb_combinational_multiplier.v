`timescale 1ns / 1ps
// Exhaustive test: 16 x 16 = 256 unsigned operand pairs.
module tb_combinational_multiplier;
    reg  [3:0] a, b;
    wire [7:0] product;
    reg  [7:0] expected;
    integer i, j;
    integer passed;

    combinational_multiplier dut (.a(a), .b(b), .product(product));

    initial begin
        a = 4'd0;
        b = 4'd0;
        passed = 0;
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                a = i;
                b = j;
                expected = i * j;
                #10;
                if (product !== expected) begin
                    $display("FAIL combinational: %0d * %0d expected %0d got %0d",
                             a, b, expected, product);
                    $finish;
                end
                passed = passed + 1;
                if ((a == 5 && b == 3) || (a == 15 && b == 15))
                    $display("Example: %0d * %0d = %0d", a, b, product);
            end
        end
        $display("PASS combinational: %0d / 256 cases", passed);
        $finish;
    end
endmodule
