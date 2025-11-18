// Experiment 6: Mod-10 Up Counter
module t_ff(
    input t, clk, rst,
    output reg q
);
    initial q = 1'b0;
    
    always @(posedge clk or posedge rst) begin
        if (rst)
            q <= 1'b0;
        else if (t)
            q <= ~q;
    end
endmodule

module mod10_counter(
    input clk,
    output [3:0] q
);
    wire rst;
    wire [3:0] q_int;
    
    t_ff T1(.t(1'b1), .clk(clk), .rst(rst), .q(q_int[0]));
    t_ff T2(.t(q_int[0]), .clk(clk), .rst(rst), .q(q_int[1]));
    t_ff T3(.t(q_int[1] & q_int[0]), .clk(clk), .rst(rst), .q(q_int[2]));
    t_ff T4(.t(q_int[2] & q_int[1] & q_int[0]), .clk(clk), .rst(rst), .q(q_int[3]));
    
    assign rst = (q_int == 4'b1010) ? 1'b1 : 1'b0;
    assign q = q_int;
endmodule
