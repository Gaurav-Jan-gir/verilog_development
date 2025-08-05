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
    if (numInputs > 6) {
        // For large inputs, generate random test cases instead of exhaustive
        tb << "        // Random test cases for large input modules\n";
        tb << "        repeat(20) begin\n";
        for (const auto& input : info.inputs) {
            tb << "            " << input << " = $random;\n";
        }
        tb << "            #10;\n";
        tb << "            $display(\"Time=%0t: ";
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
        tb << ");\n";
        tb << "        end\n\n";
    } else {
        // Exhaustive test cases for small inputs
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
    }
    
    tb << "        #10;\n";
    tb << "        $finish;\n";
    tb << "    end\n\n";
    tb << "endmodule\n";
    
    tb.close();
}

void createDirectory(const string& path) {
    // Cross-platform directory creation
    #ifdef _WIN32
        string cmd = "mkdir \"" + path + "\" 2>nul";
    #else
        string cmd = "mkdir -p \"" + path + "\" 2>/dev/null";
    #endif
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
    
    #ifdef _WIN32
        string testbenchPath = "testBench\\" + baseName + "_tb.v";
        string vvpPath = "vvp\\" + baseName + ".vvp";
    #else
        string testbenchPath = "testBench/" + baseName + "_tb.v";
        string vvpPath = "vvp/" + baseName + ".vvp";
    #endif
    string vcdPath = "vcd/" + baseName + ".vcd";
    
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
    
    // Check if testbench already exists
    ifstream testbenchCheck(testbenchPath);
    if (testbenchCheck.good()) {
        testbenchCheck.close();
        cout << "Testbench already exists: " << testbenchPath << " (skipping generation)" << endl;
    } else {
        // Generate testbench
        generateTestbench(info, vcdPath, testbenchPath);
        cout << "Generated testbench: " << testbenchPath << endl;
    }
    
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
        cout << "\nYou can view the VCD file using a waveform viewer:" << endl;
        cout << "  GTKWave: gtkwave \"" << vcdPath << "\"" << endl;
        cout << "  Surfer: surfer \"" << vcdPath << "\"" << endl;
        
        // Optional: Auto-open GTKWave if available
        cout << "\nAttempting to open waveform viewer..." << endl;
        string waveCmd;
        #ifdef _WIN32
            waveCmd = "start gtkwave \"" + vcdPath + "\" 2>nul";
        #else
            waveCmd = "which gtkwave >/dev/null 2>&1 && gtkwave \"" + vcdPath + "\" >/dev/null 2>&1 &";
        #endif
        system(waveCmd.c_str());

    } else {
        cout << "Simulation failed!" << endl;
        return 1;
    }
    
    return 0;
}
