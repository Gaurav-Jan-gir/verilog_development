module dff_nedge(clk, d, q, qn);
    input clk, d;
    output reg q, qn;

    always @(negedge clk) begin
        q <= d;  // Non-blocking assignment for sequential logic
        qn <= ~d;  // Invert d for qn
    end
endmodule