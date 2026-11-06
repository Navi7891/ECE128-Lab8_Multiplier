`timescale 1ns / 1ps
// Lab 8 - Q1: 4-bit unsigned shift-and-add sequential multiplier.
// Matches the prelab's IDLE -> MULTIPLY -> UPDATE -> DONE FSM.
// Four iterations, using a single 8-bit accumulator/adder.
module sequential_multiplier (
    input  wire       clk,
    input  wire       rst,       // active-high synchronous reset
    input  wire       start,     // pulse for one clock cycle to start a multiplication
    input  wire [3:0] a,
    input  wire [3:0] b,
    output reg  [7:0] product,  // saved result; holds until next computation finishes
    output reg        busy,
    output reg        done      // stays high until next start/reset
);
    localparam [1:0] IDLE = 2'd0,
                     MULTIPLY = 2'd1,
                     UPDATE = 2'd2,
                     DONE = 2'd3;

    reg [1:0] state;
    reg [7:0] multiplicand;
    reg [3:0] multiplier;
    reg [7:0] accumulator;
    reg [2:0] count;

    always @(posedge clk) begin
        if (rst) begin
            state        <= IDLE;
            multiplicand <= 8'd0;
            multiplier   <= 4'd0;
            accumulator  <= 8'd0;
            count        <= 3'd0;
            product      <= 8'd0;
            busy         <= 1'b0;
            done         <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        multiplicand <= {4'b0000, a};
                        multiplier   <= b;
                        accumulator  <= 8'd0;
                        count        <= 3'd0;
                        busy         <= 1'b1;
                        done         <= 1'b0;
                        state        <= MULTIPLY;
                    end
                end

                MULTIPLY: begin
                    // Add the current partial product if the multiplier LSB is one.
                    if (multiplier[0])
                        accumulator <= accumulator + multiplicand;
                    state <= UPDATE;
                end

                UPDATE: begin
                    multiplicand <= multiplicand << 1;
                    multiplier   <= multiplier >> 1;
                    count        <= count + 3'd1;
                    if (count == 3'd3)
                        state <= DONE;     // four bits have been processed
                    else
                        state <= MULTIPLY;
                end

                DONE: begin
                    product <= accumulator;
                    busy    <= 1'b0;
                    done    <= 1'b1;
                    state   <= IDLE;
                end

                default: state <= IDLE;
            endcase
        end
    end
endmodule
