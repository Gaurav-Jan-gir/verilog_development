module serial_to_parallel (
    input wire serial_in, clk, rst,
    output wire [3:0] parallel_out
);
    wire [3:0] dff_out;
    DFF dff0 (.D(serial_in), .clk(clk), .rst(rst), .Q(dff_out[0]));
    DFF dff1 (.D(dff_out[0]), .clk(clk), .rst(rst), .Q(dff_out[1]));
    DFF dff2 (.D(dff_out[1]), .clk(clk), .rst(rst), .Q(dff_out[2]));
    DFF dff3 (.D(dff_out[2]), .clk(clk), .rst(rst), .Q(dff_out[3]));
    assign parallel_out = dff_out;
endmodule

module DFF (
    input wire D,clk,rst,
    output reg Q
);
    always @(negedge clk or negedge rst) begin
        if (~rst)
            Q <= 1'b0;
        else
            Q <= D;
    end
endmodule

