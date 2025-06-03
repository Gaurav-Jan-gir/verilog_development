# Verilog Automation Setup

This workspace is configured to automatically generate testbenches and run Verilog simulations.

## Features

- **Automatic testbench generation** from Verilog modules
- **VCD file generation** for waveform viewing
- **VVP file compilation** with Icarus Verilog
- **VS Code integration** with keyboard shortcuts

## Directory Structure

```
src/                    # Your Verilog source files (.v)
testBench/             # Generated testbench files (*_tb.v)
vcd/                   # Generated VCD waveform files (*.vcd)
vvp/                   # Compiled VVP files (*.vvp)
.vscode/
├── RunVerilog.exe     # Main automation executable
├── createTestBench.exe # Custom testbench creator
├── tasks.json         # VS Code task configuration
└── keybindings.json   # Keyboard shortcut configuration
```

## Usage

### Method 1: Keyboard Shortcut (Recommended)
1. Open any Verilog file in the `src/` folder
2. Press **Ctrl+Alt+N** to run the automation
3. Files will be generated automatically in their respective folders

### Method 2: VS Code Task
1. Open any Verilog file in the `src/` folder
2. Press **Ctrl+Shift+B** to open the task menu
3. Select "Run Verilog Automation"

### Method 3: Command Line
```powershell
.\.vscode\RunVerilog.exe "src\your_file.v"
```

## What Happens When You Run

1. **Module Analysis**: The program parses your Verilog file to extract:
   - Module name
   - Input ports
   - Output ports

2. **Testbench Generation**: Creates a comprehensive testbench with:
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
