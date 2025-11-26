# 4bit-alu
A fully synthesizable 4-bit Arithmetic Logic Unit (ALU) implemented in Verilog, including a clean testbench, waveform outputs, and documentation. Designed for FPGA/RTL learning, academic projects, and hardware verification practice.

# 4-bit ALU (Verilog) — RTL Design & Testbench

A fully synthesizable **4-bit Arithmetic Logic Unit (ALU)** implemented in **Verilog HDL**, complete with a clean testbench, waveform generation, and documentation.  
Suitable for FPGA beginners, digital logic learners, and RTL design practice.

---

## 📦 Project Structure


---

## 📘 ALU Block Diagram

<p align="center">
  <img src="https://github.com/Shivaaaydv/4bit-alu/blob/main/alu_diagram.svg" width="600px">
</p>

---

## ⚙️ Features

### **Supported Operations** (`OP[2:0]`)
| Opcode | Operation             |
|--------|------------------------|
| `000`  | ADD                    |
| `001`  | SUB                    |
| `010`  | AND                    |
| `011`  | OR                     |
| `100`  | XOR                    |
| `101`  | XNOR                   |
| `110`  | Logical Shift Left     |
| `111`  | Rotate Right           |

### **Status Flags**
- `carry`
- `overflow`
- `zero`

---

## ▶️ Simulation Instructions (Icarus Verilog)

![Waveform](https://github.com/Shivaaaydv/4bit-alu/blob/main/4%20Bit%20ALU%20Design.png)

### **Compile:**
```bash
iverilog -g2005-sv -o alu.out design/alu_4bit.v tb/tb_alu_4bit.sv

vvp alu.out
gtkwave alu_4bit.vcd

---










