module demux81(
    input in,
    input [2:0] sel,
    output reg [7:0] out
);
    always @* begin
        out = 8'b0;        // Clear all outputs
        out[sel] = in;     // Set only the selected output
    end
endmodule