module s_counter(clk, reset, count);
    input clk, reset;
    output [3:0] count;
    reg [3:0] count;

    always @(posedge clk) begin
        if(reset) begin
            count <= 4'b0000; // Reset the counter to 0
        end else begin
            count <= count + 1; // Increment the counter
        end
    end
endmodule