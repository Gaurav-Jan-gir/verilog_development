module p_counter(clear, clk, count);
    parameter WIDTH = 8;
    input clear, clk;
    output [WIDTH-1:0] count;
    reg [WIDTH-1:0] count;

    always @(negedge clk or posedge clear) begin
        if (clear) begin
            count <= 0;
        end else begin
            count <= count + 1;
        end
    end
endmodule