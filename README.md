
# ECE 128 - Lab 8: Combinational and Sequential Multipliers

**Course:** ECE 128 FPGA Laboratory - Fall 2026  
**Instructor:** Jannatun Naher, PhD  
**Team:** Mahir Ashab Enan and Navjot Bains

## Project Description

In this lab, we designed and tested two 4-bit unsigned multipliers using Verilog and the Basys 3 FPGA board.

**Project A (Q2):** Combinational multiplier using partial products and addition.

**Project B (Q1):** Sequential multiplier using a clock and the shift-and-add method.

Both designs multiply two 4-bit numbers and produce an 8-bit result. We tested both multipliers using behavioral simulations in Vivado and implemented them on the Basys 3 board.

Both testbenches checked all 256 input combinations, and all 256 cases passed for each design.

## Directory Structure

```text
Project_A_Combinational/
  rtl/combinational_multiplier.v
  rtl/basys3_combinational_top.v
  tb/tb_combinational_multiplier.v
  constraints/basys3_combinational.xdc

Project_B_Sequential/
  rtl/sequential_multiplier.v
  rtl/basys3_sequential_top.v
  tb/tb_sequential_multiplier.v
  constraints/basys3_sequential.xdc

README.md
.gitignore
```

## Tools Used

- Vivado 2026.1 for simulations and software testing
- Vivado 2023.1 for FPGA implementation at Lehigh
- Digilent Basys 3 FPGA board
- Verilog HDL

## Vivado Project Setup

We used two separate Vivado projects, one for each multiplier. The FPGA part selected for our projects was `xc7a35tcpg236-2L`.

### Project A - Combinational Multiplier

1. Create a new Vivado RTL project.
2. Add the Verilog files from `Project_A_Combinational/rtl` as Design Sources.
3. Set `basys3_combinational_top` as the Design Top.
4. Add `tb_combinational_multiplier.v` as a Simulation Source.
5. Set `tb_combinational_multiplier` as the Simulation Top.
6. Add `basys3_combinational.xdc` as the constraints file.
7. Run Behavioral Simulation to check the multiplication results.
8. Run Synthesis, Implementation, and Generate Bitstream to program the board.

**FPGA Board Inputs and Outputs:**

- SW0-SW3: Input A
- SW4-SW7: Input B
- LD0-LD7: Multiplication result
- LD8-LD15: Input switch values

The combinational multiplier calculates the product when the input switches change.

### Project B - Sequential Multiplier

1. Create a separate Vivado RTL project.
2. Add the Verilog files from `Project_B_Sequential/rtl` as Design Sources.
3. Set `basys3_sequential_top` as the Design Top.
4. Add `tb_sequential_multiplier.v` as a Simulation Source.
5. Set `tb_sequential_multiplier` as the Simulation Top.
6. Add `basys3_sequential.xdc` as the constraints file.
7. Run Behavioral Simulation to check the multiplication results.
8. Run Synthesis, Implementation, and Generate Bitstream to program the board.

**FPGA Board Inputs and Outputs:**

- SW0-SW3: Input A
- SW4-SW7: Input B
- BTNU: Reset button
- BTNC: Start button
- LD0-LD7: Multiplication result
- LD8: Done signal
- LD9: Start signal
- LD10: Debounced button signal
- LD11: Raw button signal
- LD12: Reset signal
- LD13: Blinking heartbeat
- LD14: SW0 input
- LD15: SW4 input

For the sequential multiplier, we first set the input switches and then press BTNC to start the calculation. The result is displayed on LD0-LD7 when the multiplication is complete.

## Simulation Results

Both multipliers were tested using behavioral simulation in Vivado. The testbenches checked all 256 possible combinations of two 4-bit inputs.

**Project A:** 256/256 tests passed.

**Project B:** 256/256 tests passed.

Some of the multiplication examples are shown below.

| Input A | Input B | Binary Product | Decimal Result |
|---|---|---|---|
| 1 | 1 | 00000001 | 1 |
| 3 | 5 | 00001111 | 15 |
| 5 | 5 | 00011001 | 25 |
| 9 | 7 | 00111111 | 63 |
| 15 | 15 | 11100001 | 225 |

The simulation results matched the expected multiplication outputs for both designs.

## Area Utilization Results

We also ran synthesis in Vivado to compare the FPGA resources used by both multipliers.

| Resource | Project A | Project B |
|---|---:|---:|
| Slice LUTs | 16 | 38 |
| Slice Registers | 0 | 61 |
| Slices | 5 | 22 |
| Bonded IOBs | 24 | 27 |
| BUFGCTRL | 0 | 1 |

The combinational multiplier used fewer resources in the recorded synthesis results. The sequential FPGA design also included clocked logic and additional button and LED controls.

## FPGA Board Demonstration

Both multipliers were programmed and tested on the Basys 3 FPGA board using Vivado 2023.1.

For the combinational multiplier, we changed the input switches and observed the multiplication result on the LEDs.

For the sequential multiplier, we set the input switches and pressed the Start button. The LEDs displayed the result after the calculation finished.

We tested different input combinations, including 15 × 15, which produced 225 (`11100001` in binary).

### Demonstration Videos

**Project A - Combinational Multiplier:**  
https://drive.google.com/file/d/11I0vWkZYVeBgAmo88sDv1n_U52YyoRAv/view?usp=sharing

**Project B - Sequential Multiplier:**  
https://drive.google.com/file/d/16VOewRFavCh1Qbx_n-myrE9XXxYUzPAM/view?usp=sharing

## Conclusion

In this lab, we designed and tested combinational and sequential multipliers using Verilog. Both designs produced the correct multiplication results during simulation and were tested on the Basys 3 FPGA board.

The combinational design calculates the result directly from the inputs, while the sequential design uses multiple clock cycles. This lab helped us understand the differences between the two designs and how they can be implemented and tested using Vivado.
