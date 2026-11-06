# ECE 128 - Lab 8: Combinational and Sequential Multipliers

Two separate, 4-bit unsigned multiplier designs for the Digilent Basys3 FPGA.  
**Project A (Q2):** combinational multiplier using partial products and an adder tree.  
**Project B (Q1):** clocked shift-and-add sequential multiplier with Start/Reset.

Both testbenches exhaustively check **256 operand pairs**; the lab simulations showed 256/256 passing cases. The board-demo wrappers in this archive are **the LED-debug versions used for the working board demonstrations**. They are intentionally different from the initial wrappers provided earlier.

## Directory structure

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

## Vivado project setup

Make **two separate Vivado RTL projects**, one per folder. In your working lab setup the project part was `xc7a35tcpg236-2L`; keep your proven settings consistent between projects rather than switching parts during troubleshooting. Record the actual part in your report. These are plain Verilog RTL designs, not packaged Vivado IP blocks.

### Project A - combinational
- **Design Sources:** `Project_A_Combinational/rtl/*.v`
- **Design Top:** `basys3_combinational_top`
- **Simulation Sources:** `Project_A_Combinational/tb/tb_combinational_multiplier.v`
- **Simulation Top:** `tb_combinational_multiplier`
- **Constraints:** `Project_A_Combinational/constraints/basys3_combinational.xdc` **only**
- Run Behavioral Simulation to completion (`PASS combinational: 256 / 256 cases`).
- Run Synthesis, Implementation, Generate Bitstream, and Program Device.
- `SW0..3` = A, `SW4..7` = B. Product on `LD0..7`; inputs mirrored on `LD8..15`. LEDs update immediately as switches change.

### Project B - sequential
- **Design Sources:** `Project_B_Sequential/rtl/*.v`
- **Design Top:** `basys3_sequential_top`
- **Simulation Sources:** `Project_B_Sequential/tb/tb_sequential_multiplier.v`
- **Simulation Top:** `tb_sequential_multiplier`
- **Constraints:** `Project_B_Sequential/constraints/basys3_sequential.xdc` **only**
- Run Behavioral Simulation to completion (`PASS sequential: 256 / 256 cases`).
- Run Synthesis, Implementation, Generate Bitstream, and Program Device.
- Press/release **BTNU** to reset. Set A with SW0..3 and B with SW4..7. Press and release **BTNC** to start. The 10 ms debounce circuit needs a normal human-length button press.
- `LD0..7` = stored binary product, `LD8` = done, `LD9` = Start seen, `LD10` = debounced center button, `LD11` = raw center button, `LD12` = reset button, `LD13` = blinking heartbeat, `LD14` = SW0, `LD15` = SW4. This is the verified **diagnostic LED** variant, not a binary-to-seven-segment design.
- `busy` remains a Verilog output of the core, even though this debug wrapper does not display it on an LED. Observe `busy` in the testbench waveforms.

### Test vectors

| A | B | Binary product LD7..0 | Decimal product |
|---:|---:|:---:|---:|
| 1 | 1 | 00000001 | 1 |
| 3 | 5 | 00001111 | 15 |
| 15 | 15 | 11100001 | 225 |

For 3 x 5: enable SW0, SW1, SW4, and SW6, all others OFF. For 15 x 15, enable SW0..SW7. In Project B press BTNC after changing switches; Project A updates immediately.

## Verified course results (from user-provided Vivado screenshots)

| Resource | Project A top-level | Project B top-level |
|---|---:|---:|
| Slice LUTs | 16 | 38 |
| Slice registers | 0* | 61 |
| Slices | 5* | 22 |
| Bonded IOBs | 24 | 27 |
| BUFGCTRL | 0* | 1 |

*Project A registers, slices, and BUFGCTRL values come from the earlier extended utilization screenshot or the design type; verify against your fresh build before reporting if Vivado differs. **Resource counts above are from the earlier synthesized board versions.** The demonstrator wrappers in this zip drive additional diagnostic LEDs, so re-run utilization for the final versions and replace numbers in the report as needed. A direct core comparison should exclude the Project B debounce/heartbeat wrapper.

## Submission checklist
- Include the two RTL implementations, two board wrappers, testbenches and separate XDC constraints.
- Provide the required Level-0/Level-1 prelab diagrams in your report.
- Save both waveform screenshots (256/256), FPGA board photos, and updated utilization reports.
- Describe the debug indicator meanings clearly, especially Project B LD9..LD15.
- Add contributor names, actual work split, conclusion, and GitHub link.
- Avoid committing transient Vivado `.runs`, `.sim`, `.cache`, `.xpr`, and bitstreams by default.
