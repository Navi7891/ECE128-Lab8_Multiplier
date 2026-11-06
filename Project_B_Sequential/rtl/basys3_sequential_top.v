`timescale 1ns / 1ps
// Board demonstration: SW[3:0]=A, SW[7:4]=B.
// BTN C = start (debounced); BTN U = active-high reset.
// LD[7:0] = binary result; LD8 = done; LD9..LD15 = demo indicators.
module basys3_sequential_top (
    input  wire        clk,       // on-board 100 MHz clock
    input  wire [7:0]  sw,
    input  wire        btnC,
    input  wire        btnU,
    output wire [15:0] led
);
    // Two-flop synchronizer + 10 ms debounce + one-clock start pulse.
    // 100 MHz * 0.010 seconds = 1,000,000 clock cycles.
    reg btn_meta;
    reg btn_sync;
    reg btn_stable;
    reg btn_stable_prev;
    reg [19:0] stable_counter;

    always @(posedge clk) begin
        if (btnU) begin
            btn_meta        <= 1'b0;
            btn_sync        <= 1'b0;
            btn_stable      <= 1'b0;
            btn_stable_prev <= 1'b0;
            stable_counter  <= 20'd0;
        end else begin
            btn_meta <= btnC;
            btn_sync <= btn_meta;
            btn_stable_prev <= btn_stable;

            if (btn_sync == btn_stable) begin
                stable_counter <= 20'd0;
            end else if (stable_counter == 20'd999999) begin
                btn_stable     <= btn_sync;
                stable_counter <= 20'd0;
            end else begin
                stable_counter <= stable_counter + 20'd1;
            end
        end
    end

    wire start_pulse;
    wire [7:0] product;
    wire busy, done;

    assign start_pulse = btn_stable & ~btn_stable_prev;

    sequential_multiplier dut (
        .clk(clk),
        .rst(btnU),
        .start(start_pulse),
        .a(sw[3:0]),
        .b(sw[7:4]),
        .product(product),
        .busy(busy),
        .done(done)
    );

    // DEMO DIAGNOSTIC LEDS: retained from successful board troubleshooting.
    // Reset once after programming so the heartbeat and start_seen registers
    // begin in a defined state. clk is the Basys3 100 MHz board clock.
    reg [26:0] heartbeat;
    reg start_seen;

    always @(posedge clk) begin
        if (btnU) begin
            heartbeat  <= 27'd0;
            start_seen <= 1'b0;
        end else begin
            heartbeat <= heartbeat + 1'b1;
            if (start_pulse)
                start_seen <= 1'b1;
        end
    end

    assign led[7:0]  = product;       // output product in binary
    assign led[8]    = done;          // stays ON after completion
    assign led[9]    = start_seen;    // stays ON after a start pulse
    assign led[10]   = btn_stable;    // debounced center button level
    assign led[11]   = btnC;          // raw center button level
    assign led[12]   = btnU;          // raw upper button level
    assign led[13]   = heartbeat[26]; // visible blinking clock check
    assign led[14]   = sw[0];        // A least significant bit
    assign led[15]   = sw[4];        // B least significant bit
endmodule
