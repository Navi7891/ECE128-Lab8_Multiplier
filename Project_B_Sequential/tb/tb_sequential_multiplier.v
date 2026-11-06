`timescale 1ns / 1ps
// Exhaustive test: 16 x 16 = 256 unsigned operand pairs.
// Changes inputs after start to prove the design captures them at start.
module tb_sequential_multiplier;
    reg clk;
    reg rst, start;
    reg [3:0] a, b;
    wire [7:0] product;
    wire busy, done;
    integer i, j, passed;

    sequential_multiplier dut (
        .clk(clk), .rst(rst), .start(start),
        .a(a), .b(b), .product(product), .busy(busy), .done(done)
    );

    initial clk = 1'b0;
    always #5 clk = ~clk;  // 100 MHz simulation clock (10 ns period)

    task check_case;
        input [3:0] aa;
        input [3:0] bb;
        reg [7:0] expected;
        integer cycles;
        begin
            expected = aa * bb;
            @(negedge clk);
            a = aa;
            b = bb;
            start = 1'b1;
            @(negedge clk);  // start sampled at intervening rising edge
            start = 1'b0;

            if (busy !== 1'b1 || done !== 1'b0) begin
                $display("FAIL sequential handshake for %0d * %0d", aa, bb);
                $finish;
            end

            // Should not affect operation: operand values were latched at START.
            a = ~aa;
            b = ~bb;

            cycles = 0;
            while (done !== 1'b1 && cycles < 20) begin
                @(negedge clk);
                cycles = cycles + 1;
            end

            if (done !== 1'b1 || busy !== 1'b0 || product !== expected) begin
                $display("FAIL sequential: %0d * %0d expected %0d got %0d; done=%b busy=%b",
                         aa, bb, expected, product, done, busy);
                $finish;
            end

            passed = passed + 1;
            if ((aa == 5 && bb == 3) || (aa == 15 && bb == 15))
                $display("Example: %0d * %0d = %0d in %0d waiting cycles",
                         aa, bb, product, cycles);
        end
    endtask

    initial begin
        rst = 1'b1;
        start = 1'b0;
        a = 4'd0;
        b = 4'd0;
        passed = 0;
        repeat (2) @(negedge clk);
        rst = 1'b0;

        for (i = 0; i < 16; i = i + 1)
            for (j = 0; j < 16; j = j + 1)
                check_case(i, j);

        $display("PASS sequential: %0d / 256 cases", passed);
        $finish;
    end
endmodule
