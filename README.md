# CPUID Utility

A lightweight, high-performance x86-64 Assembly utility for Windows designed to query the CPU directly using native `cpuid` hardware instructions. It extracts low-level processor details without relying on heavy high-level language runtimes.

## Features

- **Processor Identification:** Fetches Core Vendor ID and full Processor Brand Name.
- **Hardware Architecture:** Detects total number of Logical Cores (Threads).
- **Instruction Set Extensions:** Checks active hardware support for **AES Encryption** and **AVX Vector Math**.
- **Ultra Lightweight:** Compiled purely into native machine code.

## Prerequisites

To build this project from source, make sure you have the following tools installed and added to your Windows environment variables (`PATH`):

1. **NASM (Netwide Assembler):** The assembler used to compile the `.asm` source file.
2. **MinGW-w64 (GCC/G++):** Used as the linker to generate the final Windows 64-bit executable file.

---

## How to Build

Follow these steps to compile the source code using the Command Prompt (`cmd`):

1. Open your terminal or Command Prompt and navigate to the folder containing your source files:
   ```cmd
   cd path\(\to\your\project\folder \%\%\)MAGIT_PARSER_PROTECT%%   ```

2. Assemble the source code into a Windows 64-bit object file using NASM:
   ```cmd
   nasm -f win64 cpuid.asm -o main.o
   ```

3. Link the object file into a standalone Windows executable (`.exe`) using G++:
   ```cmd
   g++ main.o -o main.exe -lkernel32
   ```

---

## How to Run

Once compiled successfully, execute the utility directly through the command line to display your processor's structural diagnostics:

```cmd
main.exe
```

## License

This project is licensed under the **MIT License** - see the source header for details. Developed by **RedHarlowCore**.
