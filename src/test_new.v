module testModule (clk, reset, out);
    input clk, reset;
    output out;
    
    assign out = clk & ~reset;
endmodule
