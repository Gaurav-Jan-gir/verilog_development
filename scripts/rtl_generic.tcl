# Generic Yosys RTL export script (Tcl)
# Usage:
#   yosys -c scripts/rtl_generic.tcl <input_verilog_file> <top_module_name> [output_prefix]
#
# Notes:
# - Requires Graphviz 'dot' in PATH for 'show' to emit SVG.
# - Outputs will be written to build/<output_prefix or top>.*
# - Accepts SystemVerilog via -sv on read_verilog.

# Import Yosys commands into Tcl (required when using -c)
yosys -import

# Argument parsing
if {[llength $argv] < 2} {
    puts stderr "Usage: yosys -c scripts/rtl_generic.tcl <input_verilog_file> <top_module_name> [output_prefix]"
    exit 1
}
set in_file [lindex $argv 0]
set top     [lindex $argv 1]
set outbase [expr {[llength $argv] >= 3 ? [lindex $argv 2] : $top}]

# Normalize output prefix under build/
file mkdir build
set out_prefix [file join build $outbase]

# Read design (SystemVerilog allowed)
read_verilog -sv $in_file

# Prepare and set top, then light cleanup
prep -top $top
opt -purge

# Emit artifacts: DOT schematic via Yosys (more portable on Windows)
show -format dot -prefix $out_prefix -viewer none

# Convert DOT -> SVG using Graphviz directly (avoids shell move quirks)
if {[file exists ${out_prefix}.dot]} {
    catch { exec dot -Tsvg ${out_prefix}.dot -o ${out_prefix}.svg } dotErr
}

# Netlists
write_json ${out_prefix}.json
write_verilog -noexpr -nohex ${out_prefix}_netlist.v

set ts [clock format [clock seconds] -format {%Y-%m-%d %H:%M:%S}]
puts "$ts Wrote: [file exists ${out_prefix}.svg]?${out_prefix}.svg:${out_prefix}.dot, ${out_prefix}.json, ${out_prefix}_netlist.v"