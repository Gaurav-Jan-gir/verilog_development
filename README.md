# Verilog Development Environment

🚀 **Automated Verilog Testing & Simulation Environment**

This project provides a complete automated workflow for Verilog hardware design, testing, and simulation. Write your Verilog modules and get instant testbenches, compilation, simulation, and waveform visualization - all with a single command!

## ✨ Features

- 🔄 **Automatic testbench generation** for combinational and sequential circuits
- 🧠 **Smart testbench detection** - uses existing custom testbenches when available
- ⚡ **One-command workflow**: compile, simulate, and view waveforms
- 🖥️ **Cross-platform support**: Linux, macOS, and Windows
- 📊 **Smart test generation**: exhaustive for small inputs, random for large inputs
- 🌊 **Integrated waveform viewing** with GTKWave auto-launch
- 🎯 **VS Code integration** with tasks and Code Runner support
- 📁 **Organized project structure** with automatic directory creation

## 🆕 What's New

- **Smart Testbench Detection**: If `module_name_tb.v` exists in `testBench/`, the tool uses it instead of generating a new one
- **Improved Error Handling**: Better feedback when compilation or simulation fails
- **Enhanced Cross-Platform Support**: Works seamlessly on Linux, macOS, and Windows

## 🚀 Quick Start

### 1. Install Dependencies
```bash
# Linux/Ubuntu
sudo apt install iverilog gtkwave g++

# macOS
brew install icarus-verilog gtkwave

# Windows: Download from official websites
```

### 2. Clone and Setup
```bash
git clone https://github.com/Gaurav-Jan-gir/verilog_development.git
cd verilog_development
g++ -o RunVerilog .vscode/RunVerilog.cpp
```

### 3. Test with Sample Module
```bash
# Run any module from src/
./RunVerilog src/and_gate.v
```

🎉 **That's it!** Your testbench is generated, simulation runs, and GTKWave opens automatically.

### 4. Custom Testbenches (New!)
```bash
# Create your own testbench
touch testBench/my_module_tb.v
# Edit with custom test cases...

# Run - tool will use your custom testbench
./RunVerilog src/my_module.v
# Output: "Testbench already exists: (skipping generation)"
```

## 📋 Project Structure

```
verilog_development/
├── src/                    # 📝 Your Verilog source files
│   ├── adder.v            # ➕ Arithmetic circuits
│   ├── mux_*.v            # 🔀 Multiplexers
│   ├── counter.v          # 🔢 Sequential circuits
│   └── ...                # 🔧 Your custom modules
├── testBench/             # 🧪 Auto-generated testbenches
├── vcd/                   # 📊 Waveform files (GTKWave)
├── vvp/                   # ⚙️ Compiled simulation files
├── .vscode/               # 🔧 VS Code configuration
│   ├── RunVerilog.cpp     # 🤖 Main automation tool
│   ├── settings.json      # ⚙️ Code Runner integration
│   └── tasks.json         # 📋 VS Code tasks
├── USER_GUIDE.md          # 📖 Comprehensive documentation
└── README.md              # 👋 This file
```

## 🎯 Usage Examples

### Basic Gate
```verilog
// src/and_gate.v
module and_gate(input a, b, output y);
    assign y = a & b;
endmodule
```
```bash
./RunVerilog src/and_gate.v  # Auto-generates 4 test cases
```

### Complex Circuit
```verilog
// src/alu.v
module alu(
    input [7:0] a, b,
    input [2:0] op,
    output [7:0] result
);
    // Your ALU logic
endmodule
```
```bash
./RunVerilog src/alu.v  # Auto-generates random test cases
```

### Sequential Circuit
```verilog
// src/counter.v
module counter(
    input clk, reset,
    output [3:0] count
);
    // Your counter logic
endmodule
```

## 🛠️ Advanced Features

### VS Code Integration
- **Code Runner**: `Ctrl+Alt+N` to run current file
- **Tasks**: `Ctrl+Shift+B` to build and run
- **IntelliSense**: Full Verilog syntax support

### Smart Test Generation
- **≤6 inputs**: Exhaustive testing (2^n combinations)
- **>6 inputs**: Random testing (20 test vectors)
- **Custom patterns**: Easily modifiable in source code

### Cross-Platform Compatibility
- **Linux**: Native support with POSIX utilities
- **macOS**: Homebrew integration
- **Windows**: MinGW and MSVC support

## 📚 Available Modules

### Combinational Circuits
- ✅ `and_gate.v` - Basic AND gate
- ✅ `or_gate.v` - Basic OR gate
- ✅ `mux_*.v` - Various multiplexers (2:1, 4:1, 8:1, 16:1)
- ✅ `demux.v` - Demultiplexers
- ✅ `adder*.v` - Adders (simple, carry-lookahead, generic)

### Sequential Circuits
- ✅ `latch.v` - SR Latch
- ✅ `dff_*.v` - D Flip-flops (positive/negative edge)
- ✅ `counter.v` - Binary counters
- ✅ `p_counter.v` - Programmable counter

### Complex Circuits
- ✅ `vending_machine.v` - FSM-based vending machine
- ✅ `comb_circuit.v` - Complex combinational logic

## 🔧 Installation Guide

### Prerequisites
1. **C++ Compiler**: GCC, Clang, or MSVC
2. **Icarus Verilog**: HDL compiler and simulator
3. **GTKWave**: Waveform viewer

### Detailed Setup

#### Linux (Ubuntu/Debian)
```bash
sudo apt update
sudo apt install iverilog gtkwave g++ make
git clone https://github.com/Gaurav-Jan-gir/verilog_development.git
cd verilog_development
make setup  # Compiles automation tool
```

#### macOS
```bash
# Install Homebrew if not already installed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install dependencies
brew install icarus-verilog gtkwave

# Clone and setup
git clone https://github.com/Gaurav-Jan-gir/verilog_development.git
cd verilog_development
g++ -o RunVerilog .vscode/RunVerilog.cpp
```

#### Windows
1. **Install Dependencies**:
   - [Icarus Verilog for Windows](http://bleyer.org/icarus/)
   - [GTKWave for Windows](https://gtkwave.sourceforge.net/)
   - [MinGW-w64](https://www.mingw-w64.org/) or Visual Studio

2. **Clone and Compile**:
```cmd
git clone https://github.com/Gaurav-Jan-gir/verilog_development.git
cd verilog_development
g++ -o RunVerilog.exe .vscode\RunVerilog.cpp
```

## 🐛 Troubleshooting

### Common Issues

**"Command not found" errors**:
```bash
# Check if tools are installed
which iverilog gtkwave g++

# Add to PATH if needed (Linux/macOS)
export PATH=$PATH:/usr/local/bin
```

**Permission denied**:
```bash
chmod +x RunVerilog
```

**Compilation errors**:
```bash
# Test Verilog syntax
iverilog -t null src/your_module.v
```

## 🤝 Contributing

We welcome contributions! Here's how to get involved:

1. **🍴 Fork** the repository
2. **🌿 Create** a feature branch: `git checkout -b feature/amazing-feature`
3. **✅ Test** your changes with multiple module types
4. **📝 Commit** your changes: `git commit -m 'Add amazing feature'`
5. **🚀 Push** to the branch: `git push origin feature/amazing-feature`
6. **🔀 Create** a Pull Request

### Areas for Contribution
- 🧪 Additional test generation patterns
- 🔧 Support for more Verilog constructs
- 🎨 GUI frontend development
- 📚 Documentation improvements
- 🐛 Bug fixes and optimizations

## 📊 Performance

### Benchmarks
- **Small modules** (≤6 inputs): ~2 seconds end-to-end
- **Large modules** (>6 inputs): ~5 seconds with random testing
- **Complex sequential**: Manual testbench recommended

### Scalability
- ✅ **Tested up to**: 32-bit arithmetic units
- ✅ **Memory usage**: <50MB for typical projects
- ✅ **Platform performance**: Consistent across OS

## 🏷️ Version History

- **v1.4.0** - Smart test generation, cross-platform support
- **v1.3.0** - GTKWave integration, VS Code tasks
- **v1.2.0** - Automatic directory management
- **v1.1.0** - Code Runner integration
- **v1.0.0** - Initial release with basic automation

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🔗 Useful Resources

- 📖 **[Complete User Guide](USER_GUIDE.md)** - Detailed documentation
- 🌐 **[Icarus Verilog Documentation](http://iverilog.icarus.com/)**
- 🌊 **[GTKWave User Guide](https://gtkwave.sourceforge.net/gtkwave.pdf)**
- 🎓 **[Verilog Tutorial](https://www.chipverify.com/verilog/verilog-tutorial)**
- 💻 **[VS Code Verilog Extension](https://marketplace.visualstudio.com/items?itemName=mshr-h.VerilogHDL)**

## 🙏 Acknowledgments

- **Icarus Verilog Team** - For the excellent open-source simulator
- **GTKWave Developers** - For the powerful waveform viewer
- **VS Code Team** - For the extensible editor platform
- **Contributors** - For improving this project

---

**Ready to start your Verilog journey? 🚀**

```bash
git clone https://github.com/Gaurav-Jan-gir/verilog_development.git
cd verilog_development
./RunVerilog src/and_gate.v
```

*Happy Hardware Design! 🔧⚡*
   - All possible input combinations (2^n test cases)
   - VCD dump for waveform analysis
   - Display statements showing signal values
   - Proper timing with #10 delays

3. **Compilation**: Uses Icarus Verilog to compile:
   - Your source file
   - Generated testbench
   - Outputs to VVP file

4. **Simulation**: Runs the simulation and generates:
   - Console output with signal values
   - VCD file for GTKWave or other waveform viewers

## Example Output

For a file `src/and.v` with module `andGate`:
- Testbench: `testBench/and_tb.v`
- VCD file: `vcd/and.vcd`
- VVP file: `vvp/and.vvp`

## Requirements

- **Icarus Verilog** (`iverilog` and `vvp` commands must be in PATH)
- **VS Code** with this workspace open
- **Windows** (paths are configured for Windows)

## Custom Testbench Creation

If you need a custom testbench template:

```powershell
.\.vscode\createTestBench.exe myModule testBench/custom_tb.v A B -- Y Z
```

This creates a testbench for module `myModule` with inputs `A, B` and outputs `Y, Z`.

## Troubleshooting

- **"Command not found"**: Ensure Icarus Verilog is installed and in your PATH
- **"Module not found"**: Check that your Verilog file has proper module declaration
- **Permission errors**: Run VS Code as administrator if needed

## File Extensions

- `.v` - Verilog source files
- `_tb.v` - Generated testbench files
- `.vcd` - Value Change Dump files for waveforms
- `.vvp` - Compiled Verilog simulation files
