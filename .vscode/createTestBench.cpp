#include <iostream>
#include <fstream>
#include <string>
#include <vector>

using namespace std;

void createCustomTestbench(const string& moduleName, const vector<string>& inputs, const vector<string>& outputs, const string& outputPath) {
    ofstream tb(outputPath);
    
    tb << "`timescale 1ns/1ps\n\n";
    tb << "module " << moduleName << "_tb;\n\n";
    
    // Declare inputs as reg and outputs as wire
    for (const auto& input : inputs) {
        tb << "    reg " << input << ";\n";
    }
    
    for (const auto& output : outputs) {
        tb << "    wire " << output << ";\n";
    }
    
    tb << "\n    // Instantiate the Unit Under Test (UUT)\n";
    tb << "    " << moduleName << " uut (\n";
    
    // Connect ports
    for (size_t i = 0; i < inputs.size(); i++) {
        tb << "        ." << inputs[i] << "(" << inputs[i] << ")";
        if (i < inputs.size() - 1 || !outputs.empty()) tb << ",";
        tb << "\n";
    }
    
    for (size_t i = 0; i < outputs.size(); i++) {
        tb << "        ." << outputs[i] << "(" << outputs[i] << ")";
        if (i < outputs.size() - 1) tb << ",";
        tb << "\n";
    }
    
    tb << "    );\n\n";
    
    tb << "    initial begin\n";
    tb << "        // Initialize VCD dump\n";
    tb << "        $dumpfile(\"vcd/" << moduleName << ".vcd\");\n";
    tb << "        $dumpvars(0, " << moduleName << "_tb);\n\n";
    
    tb << "        // TODO: Add your custom test cases here\n";
    tb << "        // Initialize inputs\n";
    for (const auto& input : inputs) {
        tb << "        " << input << " = 0;\n";
    }
    
    tb << "\n        // Example test case\n";
    tb << "        #10;\n";
    tb << "        // Add your test vectors here\n";
    tb << "\n        #10;\n";
    tb << "        $finish;\n";
    tb << "    end\n\n";
    tb << "endmodule\n";
    
    tb.close();
}

int main(int argc, char* argv[]) {
    if (argc < 4) {
        cout << "Usage: " << argv[0] << " <module_name> <output_path> <input1> [input2] ... -- <output1> [output2] ..." << endl;
        cout << "Example: " << argv[0] << " myModule testBench/my_tb.v A B -- Y Z" << endl;
        return 1;
    }
    
    string moduleName = argv[1];
    string outputPath = argv[2];
    
    vector<string> inputs;
    vector<string> outputs;
    bool isOutput = false;
    
    for (int i = 3; i < argc; i++) {
        string arg = argv[i];
        if (arg == "--") {
            isOutput = true;
            continue;
        }
        
        if (isOutput) {
            outputs.push_back(arg);
        } else {
            inputs.push_back(arg);
        }
    }
    
    createCustomTestbench(moduleName, inputs, outputs, outputPath);
    cout << "Custom testbench created: " << outputPath << endl;
    
    return 0;
}
