module counter(clk, reset, count);
    parameter n = 4;
    input clk, reset;
    output reg [n-1:0] count = 0;
    always @(posedge clk or posedge reset) begin
        if (reset)
            count <= 0;  // Reset the counter to 0
        else
            count <= count + 1;  // Increment the counter
    end
endmodule