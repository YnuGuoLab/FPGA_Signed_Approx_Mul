# FPGA_Signed_Approx_Mul

This repository provides the Verilog source code and simulation files for the approximate multipliers proposed in the paper **"FPGA-Based Low-Power Signed Approximate Multiplier for Diverse Error-Resilient Applications"**. The library includes implementations of 16×16 and 33×32 signed approximate multipliers, along with reusable Partial Product Generators (PPGs) and Partial Product Accumulators (PPAs) for constructing approximate multipliers of various sizes.

---

## 📁 Folder Structure
├── 16x16/ │ ├── sim/ # Testbench and 16-bit random input data │ │ ├── tb_top.v │ │ └── random_signed_16bit_numbers.txt │ └── sources/ # Source files for 16-bit multiplier │ ├── Triple_A_Generation.v # Generates partial product ±3A │ ├── Acc_Radix8.v # Accurate radix-8 PPG │ ├── Carry_Chains_X.v # Long carry chain adder │ ├── Approxi_Mult.v # Proposed 16-bit approximate multiplier │ └── top.v # Top-level configurable wrapper │ ├── 32x32/ │ ├── sim/ # Testbench and 32-bit random input data │ │ ├── tb_top.v │ │ └── random_signed_32bit_numbers.txt │ └── sources/ # Source files for 32-bit multiplier │ ├── Triple_A_Generation.v │ ├── Acc_Radix8.v │ ├── Carry_Chains_X.v │ ├── Approxi_Mult.v │ └── top.v │ ├── PPGs/ # Partial Product Generators │ ├── Acc_Radix-8_PPG.v # Accurate radix-8 PPG │ ├── App_Radix-8_PPG.v # Approximate radix-8 PPG │ └── App_Radix-16_PPG.v # Approximate radix-16 PPG │ └── PPAs/ # Partial Product Accumulators ├── Type_A.v # Accurate PPA - Type A ├── Type_B.v # Accurate PPA - Type B └── Type_A_star.v # Approximate PPA - Type A*


---

## 🧪 Simulation & Synthesis

- **Simulation Tool:** Vivado Simulator  
- **Version:** Vivado 2018.3  
- **Target FPGA:** Xilinx 7-Series `xc7vx485tffg1157`

Each `sim/` directory includes a testbench (`tb_top.v`) and a set of random signed input vectors for validating the functionality of the proposed multipliers.

---

## 💡 How to Use

1. Open Vivado and create a new project.
2. Import files from the `sources/` and `sim/` directories of the desired multiplier size.
3. Set `top.v` as the top module.
4. Run behavioral simulation using `tb_top.v`.
5. Modify parameters in `top.v` to explore different configurations.

---

## 📎 Notes

- `Triple_A_Generation.v` is responsible for generating special partial products of ±3A.
- `Carry_Chains_X.v` implements the long carry chains used in accumulation.
- `PPGs/` and `PPAs/` folders provide modular building blocks for designing custom approximate multipliers.

---

## 📬 Contact

For academic use or further research reference, please cite the corresponding paper.  
This repository is provided for educational and research purposes.

---

