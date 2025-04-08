# FPGA_Signed_Approx_Mul

This repository provides the Verilog source code and simulation files for the approximate multipliers proposed in the paper **"FPGA-Based Low-Power Signed Approximate Multiplier for Diverse Error-Resilient Applications"**. The library includes implementations of 16×16 and 33×32 signed approximate multipliers, along with reusable Partial Product Generators (PPGs) and Partial Product Accumulators (PPAs) for constructing approximate multipliers of various sizes.

---

## Overview
This repository provides Verilog implementations of signed approximate multipliers for energy-efficient computing in error-resilient applications. It includes:
- **16×16** and **32×32 approximate multipliers**
- Proposed **PPGs (Partial Product Generators)** and **PPAs (Partial Product Accumulators)**
- Testbenches with pre-generated 16-bit/32-bit signed random test vectors

Designed for FPGA platforms, the modules enable trade-offs between precision and power consumption while supporting flexible configurations.

---

## Repository Structure

├── 16x16/
│ ├── sources/
│ │ ├── Triple_A_Generation.v // Generates ±3A partial products
│ │ ├── Acc_Radix8.v // Optimized exact Radix-8 PPG
│ │ ├── Carry_Chains_X.v // Long carry chains for accumulation
│ │ ├── Approxi_Mult.v // Core 16b approximate multiplier
│ │ └── top.v // Top-level with configurable parameters
│ └── sim/
│ ├── tb_top.v // Testbench for 16b multiplier
│ └── random_signed_16bit_numbers.v // 16b test vectors


├── 32x32/
│ ├── sources/ // (Same structure as 16x16/sources)
│ └── sim/ // Contains 32b testbench & vectors


├── PPGs/
│ ├── Acc_Radix-8_PPG.v // Proposed exact Radix-8 PPG
│ ├── App_Radix-8_PPG.v // Approximate Radix-8 PPG
│ └── App_Radix-16_PPG.v // Approximate Radix-16 PPG

└── PPAs/
├── Type_A.v // Exact PPA (Baseline)
├── Type_B.v // Enhanced exact PPA
└── Type_A_star.v // Approximate PPA variant


---

## Key Modules
### Partial Product Generators (PPGs)
- **Acc_Radix-8_PPG**: Exact Radix-8 implementation with optimized Booth encoding
- **App_Radix-8_PPG**: Approximate version with reduced logic complexity
- **App_Radix-16_PPG**: High-radix approximate generator for larger multipliers

### Partial Product Accumulators (PPAs)
- **Type_A**: Baseline exact accumulator
- **Type_B**: Enhanced exact accumulator with carry look-ahead
- **Type_A_star**: Approximate variant with truncated carry chains

### Core Multipliers
- **16×16/32×32 Approxi_Mult**:  
  Configurable through `top.v` parameters:
  - `PPG_TYPE`: Select PPG implementation
  - `PPA_TYPE`: Choose accumulator type
  - `APPROX_LEVEL`: Error-energy tradeoff level

---

## Simulation Setup
### Requirements
- **Tool:** Xilinx Vivado 2018.3
- **FPGA:** Xilinx 7-Series (xc7vx485tffg1157)

### Test Flow
1. Add source files from `*/sources/` and `PPGs/`, `PPAs/`
2. Include testbench (`*/*/sim/tb_top.v`) and random vectors
3. Run behavioral simulation with signed decimal radix

---
