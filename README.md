# Asynchronous FIFO Design in Verilog

---

## Table of Contents

- Overview
- Design Specifications
- Design Architecture
- Module Description
- Simulation and Verification
- Waveform
- Synthesized Schematic
- RTL Linter Report
- References
- Final Notes

---

## Overview

This project demonstrates the design and verification of an **Asynchronous FIFO (First-In First-Out)** using Verilog HDL in Xilinx Vivado.

The FIFO is designed to transfer data between two independent clock domains using separate write and read clocks.

The design uses Gray-coded read and write pointers along with two-stage synchronizers to safely transfer pointer information between clock domains.

### Key Features

- Independent write and read clock domains.
- Parameterized data width and FIFO depth.
- Gray-code-based pointer generation.
- Two-stage flip-flop synchronizers.
- FIFO full and empty flag generation.
- Protection against FIFO overflow and underflow.
- Modular RTL design.
- Functional verification using a self-checking testbench.

---

## Design Specifications

| Parameter | Value |
|---|---|
| Design Type | Asynchronous FIFO |
| HDL | Verilog |
| Data Width | 8 bits |
| FIFO Depth | 16 |
| Address Width | 4 bits |
| Pointer Width | 5 bits |
| Write Clock | 100 MHz |
| Read Clock | Approximately 71.4 MHz |
| Simulation Tool | Xilinx Vivado Simulator |
| Synthesis Tool | Xilinx Vivado |

---

## Design Architecture

The asynchronous FIFO is divided into several functional modules to simplify the design and improve modularity.

### Block Diagram

<img width="1090" height="737" alt="Screenshot 2026-11-01 232411" src="https://github.com/user-attachments/assets/07df6d8e-330f-4cef-bd76-ada1cbe4c7ea" />


`![Asynchronous FIFO Architecture](Images/async_fifo_architecture.png)`

### Module Description

The design consists of the following modules:

**1. Async_FIFO (Top Module)**

- Main module that integrates all functional blocks.
- Contains the FIFO memory array.
- Controls memory read and write operations.
- Generates FIFO full and empty flags.

**2. Write_Controller**

- Operates in the write clock domain.
- Maintains the binary write pointer.
- Generates the corresponding Gray-coded write pointer.
- Updates the pointer during valid write operations.

**3. Read_Controller**

- Operates in the read clock domain.
- Maintains the binary read pointer.
- Generates the corresponding Gray-coded read pointer.
- Updates the pointer during valid read operations.

**4. Binary_Gray_Encoder**

- Converts binary pointer values into Gray code.
- Ensures that only one bit changes between consecutive Gray-coded pointer values.

**5. Synchronizer**

- Implements a two-stage flip-flop synchronizer.
- Transfers Gray-coded pointers between independent clock domains.
- Reduces the risk of metastability during clock-domain crossing.

---

## Simulation and Verification

The design was functionally verified using a self-checking Verilog testbench in Vivado Simulator.

The testbench uses independent write and read clocks to verify asynchronous FIFO operation.

### Verification Scenarios

- Reset operation.
- Sequential write operations.
- FIFO full detection.
- Overflow protection.
- Sequential read operations.
- Data integrity verification.
- FIFO empty detection.

### Simulation Results

- Total verification checks: 20
- Passed checks: 20
- Failed checks: 0

<badge>All 20 checks passed</badge>

---

## Waveform

The following waveform demonstrates the asynchronous FIFO operation.

It shows:

- Independent write and read clock signals.
- Sequential data write operations.
- FIFO full flag assertion.
- Sequential data read operations.
- FIFO empty flag assertion.
- Correct data transfer from input to output.
<img width="1606" height="882" alt="Screenshot 2026-11-01 230751" src="https://github.com/user-attachments/assets/0f714d77-05a0-4bfa-b3c6-26a4048ec1e6" />


---

## Synthesized Schematic

The following schematic is generated after RTL synthesis using Xilinx Vivado.

It illustrates the internal structure of the asynchronous FIFO, including pointer controllers, synchronizers, memory, and flag-generation logic.

<img width="1570" height="788" alt="Screenshot 2026-11-01 231407" src="https://github.com/user-attachments/assets/2ff2485d-30c9-42c6-8b22-80f66e7c29cb" />


---

## RTL Linter Report

RTL linting was performed using Vivado to identify potential design issues.

- Synthesis completed successfully.
- Zero errors were reported.
- Two unused-pointer-bit warnings were reported because the upper pointer bits are not used for memory addressing.

These upper pointer bits are retained for FIFO pointer wrap-around and status detection.

<img width="1578" height="813" alt="Screenshot 2026-11-01 231320" src="https://github.com/user-attachments/assets/78b3ce54-4526-4df6-ac82-935ecc671dcb" />


---

## References

- Clifford E. Cummings, "Simulation and Synthesis Techniques for Asynchronous FIFO Design," SNUG 2002.
- Xilinx Vivado Design Suite Documentation.
- Verilog HDL Language Reference.

---

## Final Notes

This project demonstrates the implementation and functional verification of an asynchronous FIFO using Verilog HDL.

The design successfully demonstrates data transfer between two independent clock domains using Gray-coded pointers and two-stage synchronizers.

Future improvements may include:

- CDC analysis and timing constraint verification.
- FPGA hardware implementation.
- Parameterized FIFO configurations.
- Extended randomized and concurrent read/write verification.

The project provides a foundation for understanding asynchronous FIFO architecture and clock-domain crossing techniques in digital VLSI and FPGA design.
