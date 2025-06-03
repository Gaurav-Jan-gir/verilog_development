#include <iostream>
#include <fstream>
#include <string>
#include <regex>
#include <vector>
#include <cstdlib>
#include <sstream>

using namespace std;

struct ModuleInfo {
    string moduleName;
    vector<string> inputs;
    vector<string> outputs;
};

string getBaseName(const string& filepath) {
    size_t lastSlash = filepath.find_last_of("/\\");
    size_t lastDot = filepath.find_last_of('.');
    
    string filename = (lastSlash == string::npos) ? filepath : filepath.substr(lastSlash + 1);
    return (lastDot == string::npos) ? filename : filename.substr(0, lastDot - (lastSlash + 1));
}

vector<string> split(const string& str, char delimiter) {
    vector<string> tokens;
    stringstream ss(str);
    string token;
    
    while (getline(ss, token, delimiter)) {
        // Remove leading/trailing whitespace
        size_t start = token.find_first_not_of(" \t");
        if (start == string::npos) continue;
        size_t end = token.find_last_not_of(" \t");
        tokens.push_back(token.substr(start, end - start + 1));
    }
    
    return tokens;
}

ModuleInfo parseVerilogModule(const string& filepath) {
    ModuleInfo info;
    ifstream file(filepath);
    string line;
    regex moduleRegex(R"(module\s+(\w+)\s*\()");
    regex inputRegex(R"(input\s+([^;]+);)");
    regex outputRegex(R"(output\s+([^;]+);)");
    
    while (getline(file, line)) {
        smatch match;
        
        // Extract module name
        if (regex_search(line, match, moduleRegex)) {
            info.moduleName = match[1].str();
        }
        
        // Extract inputs
        if (regex_search(line, match, inputRegex)) {
            string inputs_str = match[1].str();
            vector<string> tokens = split(inputs_str, ',');
            for (const auto& token : tokens) {
                info.inputs.push_back(token);
            }
        }
        
        // Extract outputs
        if (regex_search(line, match, outputRegex)) {
            string outputs_str = match[1].str();
            vector<string> tokens = split(outputs_str, ',');
            for (const auto& token : tokens) {
                info.outputs.push_back(token);
            }
        }
    }
    
    return info;
}

void generateTestbench(const ModuleInfo& info, const string& vcdPath, const string& outputPath) {
    ofstream tb(outputPath);
    
    tb << "`timescale 1ns/1ps\n\n";
    tb << "module " << info.moduleName << "_tb;\n\n";
    
    // Declare inputs as reg and outputs as wire
    for (const auto& input : info.inputs) {
        tb << "    reg " << input << ";\n";
    }
    
    for (const auto& output : info.outputs) {
        tb << "    wire " << output << ";\n";
    }
    
    tb << "\n    // Instantiate the Unit Under Test (UUT)\n";
    tb << "    " << info.moduleName << " uut (\n";
    
    // Connect ports
    for (size_t i = 0; i < info.inputs.size(); i++) {
        tb << "        ." << info.inputs[i] << "(" << info.inputs[i] << ")";
        if (i < info.inputs.size() - 1 || !info.outputs.empty()) tb << ",";
        tb << "\n";
    }
    
    for (size_t i = 0; i < info.outputs.size(); i++) {
        tb << "        ." << info.outputs[i] << "(" << info.outputs[i] << ")";
        if (i < info.outputs.size() - 1) tb << ",";
        tb << "\n";
    }
    
    tb << "    );\n\n";
      tb << "    initial begin\n";
    tb << "        // Initialize VCD dump\n";
    tb << "        $dumpfile(\"" << vcdPath << "\");\n";
    tb << "        $dumpvars(0, " << info.moduleName << "_tb);\n\n";
    
    tb << "        // Initialize inputs\n";
    for (const auto& input : info.inputs) {
        tb << "        " << input << " = 0;\n";
    }
    
    tb << "\n        // Test cases\n";
    
    // Generate simple test cases based on number of inputs
    int numInputs = info.inputs.size();
    int testCases = (1 << numInputs); // 2^n test cases
    
    for (int i = 0; i < testCases; i++) {
        tb << "        #10;\n";
        for (int j = 0; j < numInputs; j++) {
            tb << "        " << info.inputs[j] << " = " << ((i >> j) & 1) << ";\n";
        }
        tb << "        #10;\n";
        tb << "        $display(\"Time=%0t: ";
        for (const auto& input : info.inputs) {
            tb << input << "=%b ";
        }
        for (const auto& output : info.outputs) {
            tb << output << "=%b ";
        }
        tb << "\", $time";
        for (const auto& input : info.inputs) {
            tb << ", " << input;
        }
        for (const auto& output : info.outputs) {
            tb << ", " << output;
        }
        tb << ");\n\n";
    }
    
    tb << "        #10;\n";
    tb << "        $finish;\n";
    tb << "    end\n\n";
    tb << "endmodule\n";
    
    tb.close();
}

void createDirectory(const string& path) {
    string cmd = "mkdir \"" + path + "\" 2>nul";
    system(cmd.c_str());
}

int main(int argc, char* argv[]) {
    if (argc != 2) {
        cout << "Usage: " << argv[0] << " <verilog_file>" << endl;
        return 1;
    }
    
    string verilogFile = argv[1];
    string baseName = getBaseName(verilogFile);
    
    // Create directories if they don't exist
    createDirectory("testBench");
    createDirectory("vcd");
    createDirectory("vvp");
      string testbenchPath = "testBench\\" + baseName + "_tb.v";
    string vcdPath = "vcd/" + baseName + ".vcd";
    string vvpPath = "vvp\\" + baseName + ".vvp";
    
    cout << "Processing " << verilogFile << "..." << endl;
    
    // Parse the Verilog module
    ModuleInfo info = parseVerilogModule(verilogFile);
    
    if (info.moduleName.empty()) {
        cout << "Error: Could not find module declaration in " << verilogFile << endl;
        return 1;
    }
    
    cout << "Found module: " << info.moduleName << endl;
    cout << "Inputs: ";
    for (const auto& input : info.inputs) cout << input << " ";
    cout << endl;
    cout << "Outputs: ";
    for (const auto& output : info.outputs) cout << output << " ";
    cout << endl;
    
    // Generate testbench
    generateTestbench(info, vcdPath, testbenchPath);
    cout << "Generated testbench: " << testbenchPath << endl;
    
    // Compile with Icarus Verilog
    string compileCmd = "iverilog -o \"" + vvpPath + "\" \"" + verilogFile + "\" \"" + testbenchPath + "\"";
    cout << "Compiling: " << compileCmd << endl;
    int compileResult = system(compileCmd.c_str());
    
    if (compileResult != 0) {
        cout << "Compilation failed!" << endl;
        return 1;
    }
    
    // Run simulation
    string runCmd = "vvp \"" + vvpPath + "\"";
    cout << "Running simulation: " << runCmd << endl;
    int runResult = system(runCmd.c_str());
    
    if (runResult == 0) {
        cout << "Simulation completed successfully!" << endl;
        cout << "Files generated:" << endl;
        cout << "  Testbench: " << testbenchPath << endl;
        cout << "  VCD file: " << vcdPath << endl;
        cout << "  VVP file: " << vvpPath << endl;
        cout << "You can view the VCD file using a waveform viewer." << endl;
        cout << "For example, you can use GTKWave:" << endl;
        cout << "  gtkwave \"" << vcdPath << "\"" << endl;
        string compileCmd2 = "  gtkwave \"" + vcdPath + "\"";
        cout << "Compiling: " << compileCmd2 << endl;
        int compileResult2 = system(compileCmd2.c_str());
        
        if (compileResult2 != 0) {
            cout << "Compilation failed!" << endl;
            return 1;
        }

    } else {
        cout << "Simulation failed!" << endl;
        return 1;
    }
    
    return 0;
}
