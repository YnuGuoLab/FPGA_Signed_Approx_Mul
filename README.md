# FPGA_Signed_Approx_Mul

## Overview

This repository provides the Verilog source code and simulation files for the signed approximate multipliers proposed in the paper **"FPGA-Based Low-Power Signed Approximate Multiplier for Diverse Error-Resilient Applications"**.
It includes:
- **16×16** and **32×32 approximate multipliers**
- Proposed Partial Product Generators (PPGs) and Partial Product Accumulators (PPAs) for constructing approximate multipliers of various sizes.
- Testbenches with pre-generated 16-bit/32-bit signed random test vectors

Designed for FPGA platforms, the modules enable trade-offs between precision and power consumption while supporting flexible configurations.

---

## 📁Repository Structure

<pre>
├── 16x16/                                              # Contains 16×16-bit approximate multiplier implementation       
│   ├── sim/                                            # Testbench and input data for simulation
│   │   ├── tb_top.v
│   │   └── random_signed_16bit_numbers.txt             
│   └── sources/
│       ├── Triple_A_Generation.v                       # Generates ±3A partial products
│       ├── Acc_Radix8.v                                # Optimized accurate radix-8 PPG
│       ├── Carry_Chains_X.v                            # Carry chains used in accumulation
│       ├── Approxi_Mult.v                              # 16-bit approximate multiplier
│       └── top.v                                       # Top-level wrapper (configurable)

  
├── 32x32/                                              # Contains 32×32-bit approximate multiplier implementation
│   ├── sim/                                            # Testbench and input data for simulation
│   │   ├── tb_top.v
│   │   └── random_signed_32bit_numbers.txt
│   └── sources/
│       ├── Triple_A_Generation.v                       # Generates ±3A partial products
│       ├── Acc_Radix8.v                                # Optimized accurate radix-8 PPG
│       ├── Carry_Chains_X.v                            # Carry chains used in accumulation
│       ├── Approxi_Mult.v                              # 32-bit approximate multiplier
│       └── top.v                                       # Top-level wrapper (configurable)

  
├── PPGs/                                               # Proposed partial product generators
│   ├── Acc_Radix-8_PPG.v                               # Accurate radix-8 PPG
│   ├── App_Radix-8_PPG.v                               # Approximate radix-8 PPG
│   └── App_Radix-16_PPG.v                              # Approximate radix-16 PPG

  
├── PPAs/                                               # Proposed partial product accumulators
│   ├── Type_A.v                                        # Accurate PPA (Type A)
│   ├── Type_B.v                                        # Accurate PPA (Type B)
│   └── Type_A_star.v                                   # Approximate PPA (Type A*)
</pre>


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
4. Modify parameters in `top.v` to explore different configurations.
5. **Synthesize the design**, then run simulation using `tb_top.v`.
    📌 **Note:** Make sure to modify the file path inside `tb_top.v` to correctly locate the input random number file (`random_signed_16bit_numbers.txt` or `random_signed_32bit_numbers.txt`), depending on its location in your environment.
---

