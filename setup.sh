#!/bin/bash

# Verilog Development Environment - Quick Setup Script
# This script automates the installation of dependencies and compilation

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${BLUE}"
    echo "=================================================="
    echo "  Verilog Development Environment Setup"
    echo "=================================================="
    echo -e "${NC}"
}

# Detect OS
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        OS="linux"
        print_status "Detected OS: Linux"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
        print_status "Detected OS: macOS"
    elif [[ "$OSTYPE" == "cygwin" ]] || [[ "$OSTYPE" == "msys" ]]; then
        OS="windows"
        print_status "Detected OS: Windows (Cygwin/MSYS)"
    else
        OS="unknown"
        print_warning "Unknown OS: $OSTYPE"
    fi
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install dependencies based on OS
install_dependencies() {
    print_status "Installing dependencies..."
    
    case $OS in
        "linux")
            if command_exists apt-get; then
                print_status "Using apt-get (Ubuntu/Debian)..."
                sudo apt-get update
                sudo apt-get install -y iverilog gtkwave g++ make
            elif command_exists yum; then
                print_status "Using yum (RHEL/CentOS)..."
                sudo yum install -y iverilog gtkwave gcc-c++ make
            elif command_exists dnf; then
                print_status "Using dnf (Fedora)..."
                sudo dnf install -y iverilog gtkwave gcc-c++ make
            elif command_exists pacman; then
                print_status "Using pacman (Arch Linux)..."
                sudo pacman -S --noconfirm iverilog gtkwave gcc make
            else
                print_error "No supported package manager found!"
                print_status "Please install manually:"
                echo "  - iverilog (Icarus Verilog)"
                echo "  - gtkwave (Waveform viewer)"
                echo "  - g++ (C++ compiler)"
                echo "  - make (Build tool)"
                exit 1
            fi
            ;;
        "macos")
            if command_exists brew; then
                print_status "Using Homebrew..."
                brew install icarus-verilog gtkwave
            else
                print_error "Homebrew not found!"
                print_status "Installing Homebrew first..."
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
                print_status "Now installing dependencies..."
                brew install icarus-verilog gtkwave
            fi
            ;;
        "windows")
            print_warning "Windows detected. Manual installation required:"
            echo "  1. Download and install Icarus Verilog: http://bleyer.org/icarus/"
            echo "  2. Download and install GTKWave: https://gtkwave.sourceforge.net/"
            echo "  3. Install MinGW-w64: https://www.mingw-w64.org/"
            echo "  4. Add all tools to your system PATH"
            echo ""
            read -p "Press Enter after installing dependencies manually..."
            ;;
        *)
            print_error "Unsupported OS for automatic installation"
            exit 1
            ;;
    esac
}

# Verify installations
verify_installation() {
    print_status "Verifying installations..."
    
    local all_good=true
    
    if command_exists iverilog; then
        print_success "iverilog found: $(iverilog -V | head -1)"
    else
        print_error "iverilog not found!"
        all_good=false
    fi
    
    if command_exists gtkwave; then
        print_success "gtkwave found"
    else
        print_error "gtkwave not found!"
        all_good=false
    fi
    
    if command_exists g++; then
        print_success "g++ found: $(g++ --version | head -1)"
    elif command_exists clang++; then
        print_success "clang++ found: $(clang++ --version | head -1)"
        export CXX=clang++
    else
        print_error "No C++ compiler found!"
        all_good=false
    fi
    
    if [ "$all_good" = false ]; then
        print_error "Some dependencies are missing. Please install them manually."
        exit 1
    fi
}

# Compile automation tool
compile_tool() {
    print_status "Compiling automation tool..."
    
    if [ -f ".vscode/RunVerilog.cpp" ]; then
        ${CXX:-g++} -std=c++11 -Wall -Wextra -O2 -o RunVerilog .vscode/RunVerilog.cpp
        print_success "Automation tool compiled successfully!"
    else
        print_error "Source file .vscode/RunVerilog.cpp not found!"
        exit 1
    fi
}

# Create directory structure
create_directories() {
    print_status "Creating directory structure..."
    
    mkdir -p src testBench vcd vvp
    print_success "Directories created"
}

# Create example modules
create_examples() {
    print_status "Creating example modules..."
    
    if [ ! -f "src/and_gate.v" ]; then
        cat > src/and_gate.v << 'EOF'
module and_gate(
    input wire a,
    input wire b,
    output wire y
);
    assign y = a & b;
endmodule
EOF
        print_success "Created src/and_gate.v"
    fi
    
    if [ ! -f "src/or_gate.v" ]; then
        cat > src/or_gate.v << 'EOF'
module or_gate(
    input wire a,
    input wire b,
    output wire y
);
    assign y = a | b;
endmodule
EOF
        print_success "Created src/or_gate.v"
    fi
    
    if [ ! -f "src/mux2to1.v" ]; then
        cat > src/mux2to1.v << 'EOF'
module mux2to1(
    input wire [1:0] data,
    input wire sel,
    output wire out
);
    assign out = sel ? data[1] : data[0];
endmodule
EOF
        print_success "Created src/mux2to1.v"
    fi
}

# Test the installation
test_installation() {
    print_status "Testing installation..."
    
    if [ -f "RunVerilog" ] && [ -f "src/and_gate.v" ]; then
        print_status "Running test simulation..."
        ./RunVerilog src/and_gate.v
        print_success "Test completed successfully!"
    else
        print_error "Cannot run test - missing files"
    fi
}

# Main installation process
main() {
    print_header
    
    print_status "Starting automated setup..."
    
    # Check if already set up
    if [ -f "RunVerilog" ] && command_exists iverilog && command_exists gtkwave; then
        print_success "Environment already set up!"
        read -p "Do you want to run a test? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            test_installation
        fi
        exit 0
    fi
    
    detect_os
    create_directories
    
    # Install dependencies if needed
    if ! command_exists iverilog || ! command_exists gtkwave; then
        install_dependencies
    else
        print_success "Dependencies already installed"
    fi
    
    verify_installation
    compile_tool
    create_examples
    
    print_success "Setup completed successfully!"
    
    echo ""
    echo -e "${GREEN}🎉 Verilog Development Environment is ready!${NC}"
    echo ""
    echo "Quick start:"
    echo "  ./RunVerilog src/and_gate.v    # Test with example"
    echo "  ./RunVerilog src/your_module.v # Run your own module"
    echo ""
    echo "VS Code integration:"
    echo "  Ctrl+Alt+N                     # Run current file"
    echo ""
    echo "Available example modules:"
    echo "  - src/and_gate.v               # Basic AND gate"
    echo "  - src/or_gate.v                # Basic OR gate"
    echo "  - src/mux2to1.v                # 2:1 Multiplexer"
    echo ""
    
    read -p "Do you want to run a test now? (Y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Nn]$ ]]; then
        test_installation
    fi
}

# Run main function
main "$@"
