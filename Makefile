# Makefile for Verilog Development Environment
# Cross-platform automation tool compilation

# Compiler settings
CXX = g++
CXXFLAGS = -std=c++11 -Wall -Wextra -O2
TARGET = RunVerilog
SOURCE = .vscode/RunVerilog.cpp

# OS Detection
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
    PLATFORM = linux
    TARGET_EXT = 
endif
ifeq ($(UNAME_S),Darwin)
    PLATFORM = macos
    TARGET_EXT = 
endif
ifeq ($(OS),Windows_NT)
    PLATFORM = windows
    TARGET_EXT = .exe
    CXX = g++
endif

# Default target
.PHONY: all setup clean test help install-deps

all: setup

# Main compilation target
setup: $(TARGET)$(TARGET_EXT)
	@echo "✅ Verilog automation tool compiled successfully!"
	@echo "📋 Usage: ./$(TARGET)$(TARGET_EXT) src/your_module.v"
	@echo "🎯 VS Code: Press Ctrl+Alt+N to run current file"

$(TARGET)$(TARGET_EXT): $(SOURCE)
	@echo "🔨 Compiling automation tool for $(PLATFORM)..."
	$(CXX) $(CXXFLAGS) -o $(TARGET)$(TARGET_EXT) $(SOURCE)

# Install system dependencies
install-deps:
	@echo "📦 Installing dependencies for $(PLATFORM)..."
ifeq ($(PLATFORM),linux)
	@if command -v apt-get >/dev/null 2>&1; then \
		sudo apt-get update && sudo apt-get install -y iverilog gtkwave g++; \
	elif command -v yum >/dev/null 2>&1; then \
		sudo yum install -y iverilog gtkwave gcc-c++; \
	elif command -v dnf >/dev/null 2>&1; then \
		sudo dnf install -y iverilog gtkwave gcc-c++; \
	else \
		echo "❌ Unsupported package manager. Please install manually:"; \
		echo "   - iverilog (Icarus Verilog)"; \
		echo "   - gtkwave (Waveform viewer)"; \
		echo "   - g++ (C++ compiler)"; \
	fi
endif
ifeq ($(PLATFORM),macos)
	@if command -v brew >/dev/null 2>&1; then \
		brew install icarus-verilog gtkwave; \
	else \
		echo "❌ Homebrew not found. Please install:"; \
		echo "   1. Homebrew: /bin/bash -c \"\$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""; \
		echo "   2. Dependencies: brew install icarus-verilog gtkwave"; \
	fi
endif
ifeq ($(PLATFORM),windows)
	@echo "📋 For Windows, please manually install:"
	@echo "   1. Icarus Verilog: http://bleyer.org/icarus/"
	@echo "   2. GTKWave: https://gtkwave.sourceforge.net/"
	@echo "   3. MinGW-w64: https://www.mingw-w64.org/"
	@echo "   4. Add all to system PATH"
endif

# Test the automation tool
test: $(TARGET)$(TARGET_EXT)
	@echo "🧪 Testing automation tool..."
	@if [ -f "src/and_gate.v" ]; then \
		./$(TARGET)$(TARGET_EXT) src/and_gate.v; \
	elif [ -f "src/or_gate.v" ]; then \
		./$(TARGET)$(TARGET_EXT) src/or_gate.v; \
	else \
		echo "⚠️  No test modules found in src/"; \
		echo "📝 Create a simple module like:"; \
		echo "   module test_gate(input a, b, output y);"; \
		echo "       assign y = a & b;"; \
		echo "   endmodule"; \
	fi

# Clean generated files
clean:
	@echo "🧹 Cleaning generated files..."
	@rm -f $(TARGET)$(TARGET_EXT)
	@rm -f testBench/*_tb.v
	@rm -f vcd/*.vcd
	@rm -f vvp/*.vvp
	@echo "✅ Cleanup complete!"

# Verify installation
verify:
	@echo "🔍 Verifying installation..."
	@echo -n "📋 Checking iverilog: "
	@if command -v iverilog >/dev/null 2>&1; then \
		echo "✅ Found (version: $$(iverilog -V | head -1))"; \
	else \
		echo "❌ Not found"; \
	fi
	@echo -n "📋 Checking gtkwave: "
	@if command -v gtkwave >/dev/null 2>&1; then \
		echo "✅ Found"; \
	else \
		echo "❌ Not found"; \
	fi
	@echo -n "📋 Checking C++ compiler: "
	@if command -v $(CXX) >/dev/null 2>&1; then \
		echo "✅ Found (version: $$($(CXX) --version | head -1))"; \
	else \
		echo "❌ Not found"; \
	fi
	@echo -n "📋 Checking automation tool: "
	@if [ -f "$(TARGET)$(TARGET_EXT)" ]; then \
		echo "✅ Compiled"; \
	else \
		echo "❌ Not compiled (run 'make setup')"; \
	fi

# Quick installation (deps + compilation)
install: install-deps setup verify
	@echo ""
	@echo "🎉 Installation complete!"
	@echo "📋 Quick start:"
	@echo "   1. Create a Verilog module in src/"
	@echo "   2. Run: ./$(TARGET)$(TARGET_EXT) src/your_module.v"
	@echo "   3. Or use VS Code: Ctrl+Alt+N"

# Development helpers
dev-clean: clean
	@echo "🔄 Development cleanup..."
	@rm -rf *.o *.tmp .DS_Store

# Show help
help:
	@echo "🚀 Verilog Development Environment - Makefile"
	@echo ""
	@echo "📋 Available targets:"
	@echo "   setup        - Compile the automation tool (default)"
	@echo "   install-deps - Install system dependencies"
	@echo "   install      - Full installation (deps + compilation)"
	@echo "   test         - Test the automation tool"
	@echo "   verify       - Check if all tools are installed"
	@echo "   clean        - Remove generated files"
	@echo "   help         - Show this help message"
	@echo ""
	@echo "🎯 Quick start:"
	@echo "   make install     # Full setup"
	@echo "   make setup       # Just compile tool"
	@echo "   make test        # Test functionality"
	@echo ""
	@echo "💡 Platform detected: $(PLATFORM)"
	@echo "🔧 Compiler: $(CXX)"

# Create example module if none exists
example:
	@echo "📝 Creating example Verilog modules..."
	@mkdir -p src
	@if [ ! -f "src/and_gate.v" ]; then \
		echo "module and_gate(input a, b, output y);" > src/and_gate.v; \
		echo "    assign y = a & b;" >> src/and_gate.v; \
		echo "endmodule" >> src/and_gate.v; \
		echo "✅ Created src/and_gate.v"; \
	fi
	@if [ ! -f "src/or_gate.v" ]; then \
		echo "module or_gate(input a, b, output y);" > src/or_gate.v; \
		echo "    assign y = a | b;" >> src/or_gate.v; \
		echo "endmodule" >> src/or_gate.v; \
		echo "✅ Created src/or_gate.v"; \
	fi
	@echo "🎯 Test with: make test"

# Show project status
status:
	@echo "📊 Project Status:"
	@echo "   📁 Source files: $$(find src -name "*.v" 2>/dev/null | wc -l) modules"
	@echo "   🧪 Testbenches: $$(find testBench -name "*_tb.v" 2>/dev/null | wc -l) files"
	@echo "   📊 VCD files: $$(find vcd -name "*.vcd" 2>/dev/null | wc -l) waveforms"
	@echo "   ⚙️  VVP files: $$(find vvp -name "*.vvp" 2>/dev/null | wc -l) compiled"
	@echo "   🔧 Tool: $(if $(wildcard $(TARGET)$(TARGET_EXT)),✅ Compiled,❌ Not compiled)"
