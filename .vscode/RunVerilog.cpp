#include <iostream>
#include <fstream>
#include <string>
#include <regex>
#include <vector>
#include <cstdlib>
#include <sstream>
#include <algorithm>
#ifdef _WIN32
#include <windows.h>
#else
#include <dirent.h>
#include <sys/stat.h>
#endif

using namespace std;

struct Port {
    string width;   // e.g. [7:0] or empty
    string name;    // identifier
};

struct ModuleInfo {
    string moduleName;
    vector<Port> inputs;
    vector<Port> outputs;
};

string getBaseName(const string& filepath) {
    // Extract filename
    size_t lastSlash = filepath.find_last_of("/\\");
    string filename = (lastSlash == string::npos) ? filepath : filepath.substr(lastSlash + 1);
    // Remove extension (last '.') only if it is not the first character
    size_t dot = filename.find_last_of('.');
    if (dot != string::npos && dot != 0) {
        return filename.substr(0, dot);
    }
    return filename;
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

static void parseANSIPorts(const string &portList, ModuleInfo &info) {
    // Parse ANSI-style port declarations like "input in, input [2:0] sel, output reg [7:0] out"
    vector<string> portDecls = split(portList, ',');
    
    for (auto &decl : portDecls) {
        // Trim and check for input/output keywords
        string trimmed = decl;
        auto trim = [](string &s){
            size_t a = s.find_first_not_of(" \t\r\n");
            size_t b = s.find_last_not_of(" \t\r\n");
            if (a == string::npos) { s.clear(); return; }
            s = s.substr(a, b - a + 1);
        };
        trim(trimmed);
        
        if (trimmed.empty()) continue;
        
        bool isInput = (trimmed.find("input") == 0);
        bool isOutput = (trimmed.find("output") == 0);
        
        if (isInput || isOutput) {
            // Remove the input/output keyword
            string remaining = trimmed.substr(isInput ? 5 : 6);
            trim(remaining);
            
            Port p = parseSinglePortToken(remaining);
            if (!p.name.empty()) {
                if (isInput) info.inputs.push_back(p);
                else info.outputs.push_back(p);
            }
        }
    }
}

static Port parseSinglePortToken(const string &raw) {
    // Remove extra internal spaces
    string token = raw;
    // Collapse multiple spaces
    token.erase(remove(token.begin(), token.end(), '\r'), token.end());
    // Trim
    auto trim = [](string &s){
        size_t a = s.find_first_not_of(" \t");
        size_t b = s.find_last_not_of(" \t");
        if (a == string::npos) { s.clear(); return; }
        s = s.substr(a, b - a + 1);
    };
    trim(token);

    // Remove leading keywords (wire, reg, logic, signed, unsigned)
    vector<string> keywords = {"wire","reg","logic","signed","unsigned"};
    string tmp = token;
    string width;

    // Extract width if present at start e.g. [7:0]
    regex widthR(R"(^\s*(\[[^\]]+\]))");
    smatch m;
    if (regex_search(tmp, m, widthR)) {
        width = m[1].str();
        tmp = tmp.substr(m[0].length());
    }

    // Tokenize remaining by spaces to discard type keywords, keep last identifier as name.
    vector<string> parts; string part; stringstream ss(tmp);
    while (ss >> part) {
        bool isKw = false;
        for (auto &k: keywords) { if (part == k) { isKw = true; break; } }
        if (!isKw) parts.push_back(part);
    }

    Port p;
    p.width = width;
    if (!parts.empty()) {
        // If something like [3:0]A (no space) originally, handle by regex
        string candidate = parts.back();
        // Maybe width attached: [7:0]A
        smatch m2;
        if (regex_match(candidate, m2, regex(R"((\[[^\]]+\])([A-Za-z_][A-Za-z0-9_]*))"))) {
            p.width = m2[1].str();
            p.name = m2[2].str();
        } else {
            p.name = candidate;
        }
    }
    return p;
}

ModuleInfo parseVerilogModule(const string& filepath) {
    ModuleInfo info;
    ifstream file(filepath);
    if(!file.is_open()){
        throw runtime_error("Could not open file: " + filepath);
    }
    string content, line;
    
    // Read entire file for better parsing
    while (getline(file, line)) {
        content += line + "\n";
    }
    file.close();
    
    // Extract module name and ANSI-style ports
    regex moduleRegex(R"(module\s+(\w+)\s*\(([^)]*)\))");
    smatch moduleMatch;
    if (regex_search(content, moduleMatch, moduleRegex)) {
        info.moduleName = moduleMatch[1].str();
        string portList = moduleMatch[2].str();
        
        // Parse ANSI-style ports within parentheses
        parseANSIPorts(portList, info);
    }
    
    // Also check for traditional separate input/output declarations
    regex inputRegex(R"(input\s+([^;]+);)");
    regex outputRegex(R"(output\s+([^;]+);)");
    
    sregex_iterator inputIter(content.begin(), content.end(), inputRegex);
    sregex_iterator inputEnd;
    for (; inputIter != inputEnd; ++inputIter) {
        string ports = (*inputIter)[1].str();
        vector<string> tokens = split(ports, ',');
        for (auto &t : tokens) {
            Port p = parseSinglePortToken(t);
            if (!p.name.empty()) {
                // Avoid duplicates from ANSI parsing
                bool exists = false;
                for (const auto &existing : info.inputs) {
                    if (existing.name == p.name) { exists = true; break; }
                }
                if (!exists) info.inputs.push_back(p);
            }
        }
    }
    
    sregex_iterator outputIter(content.begin(), content.end(), outputRegex);
    sregex_iterator outputEnd;
    for (; outputIter != outputEnd; ++outputIter) {
        string ports = (*outputIter)[1].str();
        vector<string> tokens = split(ports, ',');
        for (auto &t : tokens) {
            Port p = parseSinglePortToken(t);
            if (!p.name.empty()) {
                // Avoid duplicates from ANSI parsing
                bool exists = false;
                for (const auto &existing : info.outputs) {
                    if (existing.name == p.name) { exists = true; break; }
                }
                if (!exists) info.outputs.push_back(p);
            }
        }
    }
    
    return info;
}

void generateTestbench(const ModuleInfo& info, const string& vcdPath, const string& outputPath) {
    ofstream tb(outputPath);
    
    tb << "`timescale 1ns/1ps\n\n";
    tb << "module " << info.moduleName << "_tb;\n\n";
    
    // Determine if we have a clock / reset among inputs (simple heuristics)
    string clkName; bool hasClock = false;
    string rstName; bool hasReset = false; bool resetActiveLow = false;

    auto isClockName = [](const string &n){
        string l = n; transform(l.begin(), l.end(), l.begin(), ::tolower);
        return (l == "clk" || l == "clock" || l == "i_clk" || l == "clk_i");
    };
    auto isResetName = [](const string &n){
        string l = n; transform(l.begin(), l.end(), l.begin(), ::tolower);
        return (l == "rst" || l == "reset" || l == "rst_n" || l == "reset_n" || l == "nreset");
    };

    for (const auto& input : info.inputs) {
        if (!hasClock && isClockName(input.name)) { hasClock = true; clkName = input.name; }
        if (!hasReset && isResetName(input.name)) { hasReset = true; rstName = input.name; }
    }
    if (hasReset) {
        string l = rstName; transform(l.begin(), l.end(), l.begin(), ::tolower);
        if (l.find("_n") != string::npos || l.find("nreset") != string::npos) resetActiveLow = true;
    }

    auto isNumericWidth = [](const string &w)->bool {
        if (w.empty()) return false;
        return regex_match(w, regex(R"(^\[\s*\d+\s*:\s*\d+\s*\]$)"));
    };

    // Only emit numeric widths, otherwise scalar
    for (const auto& input : info.inputs) {
        tb << "    reg ";
        if (isNumericWidth(input.width)) tb << input.width << " ";
        tb << input.name << ";\n";
    }
    for (const auto& output : info.outputs) {
        tb << "    wire ";
        if (isNumericWidth(output.width)) tb << output.width << " ";
        tb << output.name << ";\n";
    }
    
    tb << "\n    // Instantiate the Unit Under Test (UUT)\n";
    tb << "    " << info.moduleName << " uut (\n";
    
    // Connect ports
    for (size_t i = 0; i < info.inputs.size(); i++) {
        tb << "        ." << info.inputs[i].name << "(" << info.inputs[i].name << ")";
        if (i < info.inputs.size() - 1 || !info.outputs.empty()) tb << ",";
        tb << "\n";
    }
    
    for (size_t i = 0; i < info.outputs.size(); i++) {
        tb << "        ." << info.outputs[i].name << "(" << info.outputs[i].name << ")";
        if (i < info.outputs.size() - 1) tb << ",";
        tb << "\n";
    }
    
    tb << "    );\n\n";

    // Clock generation always outside initial
    if (hasClock) {
        tb << "    always #5 " << clkName << " = ~" << clkName << ";\n";
    }

    tb << "    initial begin\n";
    tb << "        // Initialize VCD dump\n";
    tb << "        $dumpfile(\"" << vcdPath << "\");\n";
    tb << "        $dumpvars(0, " << info.moduleName << "_tb);\n\n";
    
    tb << "        // Initialize inputs\n";
    for (const auto& input : info.inputs) {
        // For clock leave at 0, for reset set asserted value initially
        if (hasReset && input.name == rstName) {
            if (resetActiveLow) tb << "        " << input.name << " = 0; // active-low reset asserted\n";
            else tb << "        " << input.name << " = 1; // active-high reset asserted\n";
        } else {
            tb << "        " << input.name << " = 0;\n";
        }
    }

    // (clock generation moved outside initial)

    if (hasReset) {
        tb << "\n        // Reset pulse\n";
        tb << "        #20;\n";
        if (resetActiveLow) tb << "        " << rstName << " = 1; // deassert active-low reset\n";
        else tb << "        " << rstName << " = 0; // deassert active-high reset\n";
    }
    
    tb << "\n        // Test cases\n";
    
    // Generate simple stimulus
    vector<string> dataInputs;
    for (const auto &p : info.inputs) {
        if (hasClock && p.name == clkName) continue;
        if (hasReset && p.name == rstName) continue;
        dataInputs.push_back(p.name);
    }

    int numDataInputs = static_cast<int>(dataInputs.size());
    bool doExhaustive = (numDataInputs > 0 && numDataInputs <= 6);

    if (hasClock) {
        tb << "\n        // Clocked stimulus\n";
        if (numDataInputs == 0) {
            tb << "        // No data inputs: just run some cycles\n";
            tb << "        repeat (32) begin @(posedge " << clkName << "); #1; $display(\"T=%0t";
            for (const auto& outp : info.outputs) tb << " " << outp.name << "=%b";
            tb << "\", $time";
            for (const auto& outp : info.outputs) tb << ", " << outp.name;
            tb << "); end\n";
        } else if (doExhaustive) {
            tb << "        integer vec;\n";
            tb << "        for (vec = 0; vec < " << (1 << (numDataInputs == 0 ? 1 : numDataInputs)) << "; vec = vec + 1) begin\n";
            tb << "            @(posedge " << clkName << ");\n";
            for (int i = 0; i < numDataInputs; ++i) {
                tb << "            " << dataInputs[i] << " = (vec >> " << i << ") & 1;\n";
            }
            tb << "            #1; // allow propagation\n";
            tb << "            $display(\"T=%0t";
            for (auto &din : dataInputs) tb << " " << din << "=%b";
            for (const auto& outp : info.outputs) tb << " " << outp.name << "=%b";
            tb << "\", $time";
            for (auto &din : dataInputs) tb << ", " << din;
            for (const auto& outp : info.outputs) tb << ", " << outp.name;
            tb << ");\n";
            tb << "        end\n";
        } else {
            tb << "        integer i;\n";
            tb << "        // Randomized cycles for wide input space\n";
            tb << "        for (i = 0; i < 32; i = i + 1) begin\n";
            tb << "            @(posedge " << clkName << ");\n";
            for (auto &din : dataInputs) tb << "            " << din << " = $random;\n";
            tb << "            #1;\n";
            tb << "            $display(\"T=%0t";
            for (auto &din : dataInputs) tb << " " << din << "=%b";
            for (const auto& outp : info.outputs) tb << " " << outp.name << "=%b";
            tb << "\", $time";
            for (auto &din : dataInputs) tb << ", " << din;
            for (const auto& outp : info.outputs) tb << ", " << outp.name;
            tb << ");\n";
            tb << "        end\n";
        }
    } else {
        // Combinational-like stimulus (fallback)
        if (numDataInputs == 0) {
            tb << "        // No inputs: sample outputs over time\n";
            tb << "        repeat (8) begin #10; $display(\"T=%0t";
            for (const auto& outp : info.outputs) tb << " " << outp.name << "=%b";
            tb << "\", $time";
            for (const auto& outp : info.outputs) tb << ", " << outp.name;
            tb << "); end\n";
        } else if (doExhaustive) {
            tb << "\n        integer vec;\n";
            tb << "        for (vec = 0; vec < " << (1 << (numDataInputs == 0 ? 1 : numDataInputs)) << "; vec = vec + 1) begin\n";
            tb << "            #10;\n";
            for (int i = 0; i < numDataInputs; ++i) {
                tb << "            " << dataInputs[i] << " = (vec >> " << i << ") & 1;\n";
            }
            tb << "            #1;\n";
            tb << "            $display(\"T=%0t";
            for (auto &din : dataInputs) tb << " " << din << "=%b";
            for (const auto& outp : info.outputs) tb << " " << outp.name << "=%b";
            tb << "\", $time";
            for (auto &din : dataInputs) tb << ", " << din;
            for (const auto& outp : info.outputs) tb << ", " << outp.name;
            tb << ");\n";
            tb << "        end\n";
        } else if (numDataInputs > 0) {
            tb << "\n        integer i;\n";
            tb << "        for (i = 0; i < 32; i = i + 1) begin\n";
            tb << "            #10;\n";
            for (auto &din : dataInputs) tb << "            " << din << " = $random;\n";
            tb << "            #1;\n";
            tb << "            $display(\"T=%0t";
            for (auto &din : dataInputs) tb << " " << din << "=%b";
            for (const auto& outp : info.outputs) tb << " " << outp.name << "=%b";
            tb << "\", $time";
            for (auto &din : dataInputs) tb << ", " << din;
            for (const auto& outp : info.outputs) tb << ", " << outp.name;
            tb << ");\n";
            tb << "        end\n";
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

vector<string> getVerilogFiles(const string& srcDir) {
    vector<string> verilogFiles;
    
#ifdef _WIN32
    WIN32_FIND_DATA findFileData;
    string searchPath = srcDir + "\\*.v";
    HANDLE hFind = FindFirstFile(searchPath.c_str(), &findFileData);
    
    if (hFind != INVALID_HANDLE_VALUE) {
        do {
            if (!(findFileData.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY)) {
                verilogFiles.push_back(findFileData.cFileName);
            }
        } while (FindNextFile(hFind, &findFileData) != 0);
        FindClose(hFind);
    }
#else
    DIR* dir = opendir(srcDir.c_str());
    if (dir) {
        struct dirent* entry;
        while ((entry = readdir(dir)) != nullptr) {
            string filename = entry->d_name;
            if (filename.length() > 2 && filename.substr(filename.length() - 2) == ".v") {
                verilogFiles.push_back(filename);
            }
        }
        closedir(dir);
    }
#endif
    
    return verilogFiles;
}

int processAllFiles() {
    vector<string> verilogFiles = getVerilogFiles("src");
    
    if (verilogFiles.empty()) {
        cout << "No Verilog files found in src/ directory." << endl;
        return 1;
    }
    
    cout << "Found " << verilogFiles.size() << " Verilog files in src/ directory:" << endl;
    
    int successCount = 0;
    int failCount = 0;
    
    for (const auto& filename : verilogFiles) {
        cout << "\n=== Processing " << filename << " ===" << endl;
        
        string verilogFile = "src/" + filename;
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
        
        // Parse the Verilog module
        ModuleInfo info = parseVerilogModule(verilogFile);
        
        if (info.moduleName.empty()) {
            cout << "Error: Could not find module declaration in " << verilogFile << endl;
            failCount++;
            continue;
        }
        
        cout << "Found module: " << info.moduleName << endl;
        cout << "Inputs: ";
        for (const auto& input : info.inputs) cout << input.name << " ";
        cout << endl;
        cout << "Outputs: ";
        for (const auto& output : info.outputs) cout << output.name << " ";
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
            cout << "Compilation failed for " << filename << "!" << endl;
            failCount++;
            continue;
        }
        
        // Run simulation
        string runCmd = "vvp \"" + vvpPath + "\"";
        cout << "Running simulation: " << runCmd << endl;
        int runResult = system(runCmd.c_str());
        
        if (runResult == 0) {
            cout << "Simulation completed successfully for " << filename << "!" << endl;
            successCount++;
        } else {
            cout << "Simulation failed for " << filename << "!" << endl;
            failCount++;
        }
    }
    
    cout << "\n=== BATCH PROCESSING SUMMARY ===" << endl;
    cout << "Total files processed: " << verilogFiles.size() << endl;
    cout << "Successful: " << successCount << endl;
    cout << "Failed: " << failCount << endl;
    
    return (failCount == 0) ? 0 : 1;
}

int main(int argc, char* argv[]) {
    if (argc == 2 && string(argv[1]) == "--all") {
        cout << "Batch processing all Verilog files in src/ directory..." << endl;
        return processAllFiles();
    }
    
    if (argc != 2) {
        cout << "Usage: " << argv[0] << " <verilog_file>" << endl;
        cout << "   or: " << argv[0] << " --all  (process all files in src/)" << endl;
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
        string vcdPath = "vcd\\" + baseName + ".vcd";
    #else
        string testbenchPath = "testBench/" + baseName + "_tb.v";
        string vvpPath = "vvp/" + baseName + ".vvp";
        string vcdPath = "vcd/" + baseName + ".vcd";
    #endif
    
    cout << "Processing " << verilogFile << "..." << endl;
    
    // Parse the Verilog module
    ModuleInfo info = parseVerilogModule(verilogFile);
    
    if (info.moduleName.empty()) {
        cout << "Error: Could not find module declaration in " << verilogFile << endl;
        return 1;
    }
    
    cout << "Found module: " << info.moduleName << endl;
    cout << "Inputs: ";
    for (const auto& input : info.inputs) cout << input.name << " ";
    cout << endl;
    cout << "Outputs: ";
    for (const auto& output : info.outputs) cout << output.name << " ";
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
