# Verilog Automation Tool - User Guide

## Overview

This automated Verilog testbench generator simplifies the development and testing of digital circuits by automatically generating comprehensive testbenches, compiling your Verilog code, running simulations, and producing waveform files for analysis.

**🔥 New Feature**: Smart testbench detection - if `module_name_tb.v` already exists, the tool will use it instead of generating a new one!

## 🚀 Quick Start

1. **Install Dependencies** (see [Installation](#installation))
2. **Write your Verilog module** in the `src/` folder  
3. **Run the automation**: `./RunVerilog src/your_module.v` or use VS Code Code Runner
4. **View waveforms** in GTKWave (opens automatically)
5. **Custom testbenches**: Create `testBench/your_module_tb.v` to use your own tests

---

## 📋 Installation

### Prerequisites

- **C++ Compiler** (GCC/G++ or Visual Studio)
- **Icarus Verilog** (iverilog)
- **GTKWave** (waveform viewer)

### Step 1: Install Icarus Verilog

#### Linux (Ubuntu/Debian):
```bash
sudo apt update
sudo apt install iverilog
```

#### Linux (RHEL/CentOS/Fedora):
```bash
sudo yum install iverilog    # RHEL/CentOS
sudo dnf install iverilog    # Fedora
```

#### macOS:
```bash
# Using Homebrew
brew install icarus-verilog

# Using MacPorts
sudo port install iverilog
```

#### Windows:
1. Download from: [http://bleyer.org/icarus/](http://bleyer.org/icarus/)
2. Run the installer
3. Add installation path to system PATH

**Verify Installation:**
```bash
iverilog -V
```

### Step 2: Install GTKWave

#### Linux (Ubuntu/Debian):
```bash
sudo apt install gtkwave
```

#### Linux (RHEL/CentOS/Fedora):
```bash
sudo yum install gtkwave     # RHEL/CentOS
sudo dnf install gtkwave     # Fedora
```

#### macOS:
```bash
# Using Homebrew
brew install --cask gtkwave

# Using MacPorts
sudo port install gtkwave
```

#### Windows:
1. Download from: [https://gtkwave.sourceforge.net/](https://gtkwave.sourceforge.net/)
2. Install and add to PATH

**Verify Installation:**
```bash
gtkwave --version
```

### Step 3: Compile the Automation Tool

Navigate to your project directory and compile:

```bash
cd /path/to/your/verilog/project
g++ -o RunVerilog .vscode/RunVerilog.cpp
```

**For Windows (Visual Studio):**
```cmd
cl /EHsc .vscode\RunVerilog.cpp /Fe:RunVerilog.exe
```

### Step 4: VS Code Setup (Recommended for Best Experience)

#### 4.1 Install Required Extensions

Open VS Code and install these extensions:

1. **Verilog-HDL/SystemVerilog/Bluespec SystemVerilog** 
   - Extension ID: `mshr-h.VerilogHDL`
   - Provides syntax highlighting and IntelliSense for Verilog

2. **Code Runner**
   - Extension ID: `formulahendry.code-runner`
   - Enables running code with keyboard shortcuts

#### 4.2 Configure Code Runner Settings

Add to your `.vscode/settings.json`:

```json
{
  "code-runner.executorMap": {
    "verilog": "cd $workspaceRoot && g++ -o RunVerilog .vscode/RunVerilog.cpp && ./RunVerilog $fileName"
  },
  "code-runner.runInTerminal": true,
  "code-runner.saveFileBeforeRun": true,
  "code-runner.clearPreviousOutput": true,
  "code-runner.preserveFocus": false,
  "files.associations": {
    "*.v": "verilog",
    "*.vh": "verilog",
    "*.sv": "systemverilog"
  }
}
```

#### 4.3 Setup Custom Keybindings (Optional)

Create/edit `.vscode/keybindings.json`:

```json
[
  {
    "key": "f5",
    "command": "code-runner.run",
    "when": "editorTextFocus && editorLangId == 'verilog'"
  },
  {
    "key": "ctrl+f5", 
    "command": "workbench.action.tasks.runTask",
    "args": "Run Verilog Automation",
    "when": "editorTextFocus && editorLangId == 'verilog'"
  }
]
```

#### 4.4 Setup VS Code Tasks

Create/edit `.vscode/tasks.json`:

```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "Run Verilog Automation",
      "type": "shell",
      "command": "./RunVerilog",
      "args": ["${file}"],
      "group": {
        "kind": "build",
        "isDefault": true
      },
      "presentation": {
        "echo": true,
        "reveal": "always",
        "focus": false,
        "panel": "shared"
      },
      "problemMatcher": []
    },
    {
      "label": "Compile Automation Tool",
      "type": "shell", 
      "command": "g++",
      "args": ["-o", "RunVerilog", ".vscode/RunVerilog.cpp"],
      "group": "build",
      "presentation": {
        "echo": true,
        "reveal": "silent"
      }
    }
  ]
}
```

#### 4.5 Quick Start Commands

After setup, you can use these VS Code shortcuts:

- **`F5`**: Run current Verilog file (Code Runner)
- **`Ctrl+F5`**: Run using VS Code tasks
- **`Ctrl+Shift+P`** → "Tasks: Run Task" → "Run Verilog Automation"
- **`Ctrl+Alt+N`**: Default Code Runner shortcut
- **Right-click** → "Run Code"

---

## 🏗️ Project Structure

Your project should follow this structure:
```
your_project/
├── src/                    # Your Verilog source files
│   ├── module1.v
│   ├── module2.v
│   └── ...
├── testBench/             # Auto-generated testbenches
├── vcd/                   # Waveform files
├── vvp/                   # Compiled simulation files
├── .vscode/
│   ├── RunVerilog.cpp     # Automation tool
│   ├── settings.json      # VS Code settings
│   └── tasks.json         # VS Code tasks
└── README.md
```

---

## 🔧 Usage

### Method 1: Command Line (Recommended)

```bash
# Basic usage
./RunVerilog src/your_module.v

# Examples
./RunVerilog src/and_gate.v
./RunVerilog src/mux4to1.v
./RunVerilog src/decoder.v
```

### Method 2: VS Code Integration

1. **Open file** in VS Code
2. **Press `Ctrl+Alt+N`** (Code Runner)
3. **Or use Command Palette**: `Ctrl+Shift+P` → "Tasks: Run Task" → "Run Verilog Automation"

### 🆕 Smart Testbench Detection

The tool now intelligently handles testbenches:

- **Auto-Generate**: If `testBench/module_name_tb.v` doesn't exist, creates a comprehensive testbench
- **Use Existing**: If `testBench/module_name_tb.v` exists, uses your custom testbench instead
- **Skip Generation**: Displays message "Testbench already exists: (skipping generation)"

**Example Workflow**:
```bash
# First run - generates testbench automatically
./RunVerilog src/counter.v
# Output: "Generated testbench: testBench/counter_tb.v"

# Edit the testbench for custom test cases
nano testBench/counter_tb.v

# Second run - uses your custom testbench
./RunVerilog src/counter.v  
# Output: "Testbench already exists: testBench/counter_tb.v (skipping generation)"
```

### Method 3: Manual Compilation

```bash
# Step by step
iverilog -o vvp/module.vvp src/module.v testBench/module_tb.v
vvp vvp/module.vvp
gtkwave vcd/module.vcd
```

---

## 📝 Writing Verilog Modules

### Supported Module Types

✅ **Fully Supported:**
- Combinational circuits (AND, OR, MUX, Decoder, etc.)
- Simple sequential circuits (Latches, Flip-flops)
- Arithmetic circuits (Adders, Multipliers)
- Small finite state machines

❓ **Partially Supported:**
- Complex sequential circuits (may need manual testbench editing)
- Modules with complex timing requirements
- Parameterized modules (basic support)

### Module Format Requirements

```verilog
module your_module_name(
    input wire a,           // Single bit inputs
    input wire [3:0] b,     // Multi-bit inputs
    input wire clk,         // Clock signals
    output wire y,          // Single bit outputs  
    output wire [7:0] result // Multi-bit outputs
);
    // Your logic here
endmodule
```

### Example: 4-to-1 Multiplexer

```verilog
// File: src/mux4to1.v
module mux4to1(
    input wire [3:0] data_in,
    input wire [1:0] select,
    output wire data_out
);
    assign data_out = data_in[select];
endmodule
```

---

## 🔍 Understanding the Output

### Generated Files

1. **`testBench/module_tb.v`** - Auto-generated testbench
2. **`vcd/module.vcd`** - Waveform data for GTKWave
3. **`vvp/module.vvp`** - Compiled simulation executable

### Console Output Example

```
Processing src/mux4to1.v...
Found module: mux4to1
Inputs: [3:0] data_in [1:0] select 
Outputs: data_out 
Generated testbench: testBench/mux4to1_tb.v
Compiling: iverilog -o "vvp/mux4to1.vvp" "src/mux4to1.v" "testBench/mux4to1_tb.v"
Running simulation: vvp "vvp/mux4to1.vvp"
Simulation completed successfully!
Files generated:
  Testbench: testBench/mux4to1_tb.v
  VCD file: vcd/mux4to1.vcd
  VVP file: vvp/mux4to1.vvp

You can view the VCD file using a waveform viewer:
  GTKWave: gtkwave "vcd/mux4to1.vcd"
  Surfer: surfer "vcd/mux4to1.vcd"

Attempting to open waveform viewer...
```

### Generated Testbench Structure

```verilog
`timescale 1ns/1ps

module mux4to1_tb;
    reg [3:0] data_in;
    reg [1:0] select;
    wire data_out;

    // Instantiate the Unit Under Test (UUT)
    mux4to1 uut (
        .data_in(data_in),
        .select(select),
        .data_out(data_out)
    );

    initial begin
        // Initialize VCD dump
        $dumpfile("vcd/mux4to1.vcd");
        $dumpvars(0, mux4to1_tb);

        // Initialize inputs
        data_in = 0;
        select = 0;

        // Exhaustive test cases (2^6 = 64 combinations)
        #10;
        data_in = 0; select = 0;
        #10;
        $display("Time=%0t: data_in=%b select=%b data_out=%b", $time, data_in, select, data_out);
        
        // ... more test cases ...
        
        #10;
        $finish;
    end
endmodule
```

---

## 🎯 Advanced Features

### Custom Testbench Generation

For modules with >6 inputs, the tool automatically switches to random testing:

```cpp
// Automatic optimization for large inputs
if (numInputs > 6) {
    // Random test cases instead of exhaustive (2^n)
    repeat(20) begin
        // Random stimulus
    end
}
```

### Cross-Platform Support

- **Linux/macOS**: Full support with POSIX commands
- **Windows**: Compatible with both MinGW and MSVC
- **Directory creation**: Automatic cross-platform path handling

### GTKWave Integration

- **Auto-launch**: Attempts to open GTKWave automatically
- **Fallback options**: Supports alternative viewers (Surfer, etc.)
- **Silent operation**: Background execution doesn't block terminal

---

## 🐛 Troubleshooting

### Common Issues

#### 1. "iverilog: command not found"
```bash
# Solution: Install Icarus Verilog
sudo apt install iverilog  # Linux
brew install icarus-verilog  # macOS
```

#### 2. "Permission denied: ./RunVerilog"
```bash
# Solution: Make executable
chmod +x RunVerilog
```

#### 3. "Could not find module declaration"
- **Check**: Module syntax is correct
- **Verify**: File contains `module module_name(...);`
- **Ensure**: Proper input/output declarations

#### 4. Compilation Errors
```bash
# Check Verilog syntax
iverilog -t null src/your_module.v
```

#### 5. "GTKWave not opening"
```bash
# Manually open waveform
gtkwave vcd/your_module.vcd

# Or check if GTKWave is installed
which gtkwave
```

### Debug Mode

Enable verbose output by modifying the source or using:
```bash
# Add debug prints to see detailed parsing
./RunVerilog src/module.v 2>&1 | tee debug.log
```

---

## 🔧 Customization

### Modify Test Generation

Edit `.vscode/RunVerilog.cpp` to customize:

```cpp
// Custom test patterns
void generateCustomTests(const ModuleInfo& info, ofstream& tb) {
    // Your custom test generation logic
    tb << "        // Custom test sequence\n";
    tb << "        input1 = 4'b1010;\n";
    tb << "        input2 = 4'b0101;\n";
    tb << "        #10;\n";
}
```

### Timing Modifications

```cpp
// Change simulation timing
tb << "        #10;\n";  // Change to #5, #20, etc.
```

### Output Formatting

```cpp
// Customize display format
tb << "        $display(\"Custom: %b -> %b\", input, output);\n";
```

---

## 📊 Performance Tips

### For Large Modules
- Use random testing (automatically enabled for >6 inputs)
- Reduce simulation time with shorter delays
- Use directed testing instead of exhaustive

### For Complex Circuits
- Write custom testbenches manually
- Use the auto-generated version as a template
- Add specific test vectors for edge cases

### For Sequential Circuits
- Add clock generation manually
- Include reset sequences
- Test state transitions explicitly

---

## 🤝 Contributing

### Adding New Features

1. **Fork** the repository
2. **Modify** `.vscode/RunVerilog.cpp`
3. **Test** with various module types
4. **Submit** pull request

### Reporting Issues

Include in your bug report:
- Operating system and version
- Verilog module that fails
- Complete error message
- Steps to reproduce

---

## 📚 Examples

### Basic AND Gate
```verilog
// File: src/and_gate.v
module and_gate(
    input wire a,
    input wire b,
    output wire y
);
    assign y = a & b;
endmodule
```

**Run:** `./RunVerilog src/and_gate.v`

### 8-bit Adder
```verilog
// File: src/adder8.v
module adder8(
    input wire [7:0] a,
    input wire [7:0] b,
    input wire cin,
    output wire [7:0] sum,
    output wire cout
);
    assign {cout, sum} = a + b + cin;
endmodule
```

**Run:** `./RunVerilog src/adder8.v`

### D Flip-Flop
```verilog
// File: src/dff.v
module dff(
    input wire d,
    input wire clk,
    input wire reset,
    output reg q
);
    always @(posedge clk or posedge reset) begin
        if (reset)
            q <= 1'b0;
        else
            q <= d;
    end
endmodule
```

**Run:** `./RunVerilog src/dff.v`

---

## 🏷️ Version History

- **v1.0**: Basic testbench generation
- **v1.1**: Cross-platform support
- **v1.2**: Random testing for large inputs
- **v1.3**: GTKWave integration
- **v1.4**: VS Code task integration

---

## 📄 License

This project is open source. See LICENSE file for details.

---

## 🔗 Useful Links

- **Icarus Verilog**: [http://iverilog.icarus.com/](http://iverilog.icarus.com/)
- **GTKWave**: [https://gtkwave.sourceforge.net/](https://gtkwave.sourceforge.net/)
- **Verilog Tutorial**: [https://www.chipverify.com/verilog/verilog-tutorial](https://www.chipverify.com/verilog/verilog-tutorial)
- **VS Code**: [https://code.visualstudio.com/](https://code.visualstudio.com/)

---

**Happy Coding! 🚀**
