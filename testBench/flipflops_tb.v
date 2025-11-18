// Testbench for all Flip-flops
`timescale 1ns/1ps

module flipflops_tb;
    reg clk;
    
    // SR Flip-flop signals
    reg S, R;
    wire Q_sr, Qn_sr;
    
    // D Flip-flop signals
    reg D;
    wire Q_d, Qn_d;
    
    // JK Flip-flop signals
    reg J, K;
    wire Q_jk, Qn_jk;
    
    // T Flip-flop signals
    reg T;
    wire Q_t, Qn_t;
    
    // Instantiate all flip-flops
    sr_flipflop sr_ff(.S(S), .R(R), .clk(clk), .Q(Q_sr), .Qn(Qn_sr));
    d_flipflop d_ff(.D(D), .clk(clk), .Q(Q_d), .Qn(Qn_d));
    jk_flipflop jk_ff(.J(J), .K(K), .clk(clk), .Q(Q_jk), .Qn(Qn_jk));
    t_flipflop t_ff(.T(T), .clk(clk), .Q(Q_t), .Qn(Qn_t));
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        $dumpfile("vcd/flipflops.vcd");
        $dumpvars(0, flipflops_tb);
        
        // Initialize
        S = 0; R = 0; D = 0; J = 0; K = 0; T = 0;
        #10;
        
        // Test SR Flip-flop
        S = 1; R = 0; #10; // Set
        S = 0; R = 0; #10; // Hold
        S = 0; R = 1; #10; // Reset
        S = 0; R = 0; #10; // Hold
        
        // Test D Flip-flop
        D = 1; #10;
        D = 0; #10;
        D = 1; #10;
        
        // Test JK Flip-flop
        J = 1; K = 0; #10; // Set
        J = 0; K = 0; #10; // Hold
        J = 0; K = 1; #10; // Reset
        J = 1; K = 1; #10; // Toggle
        J = 1; K = 1; #10; // Toggle
        
        // Test T Flip-flop
        T = 1; #10; // Toggle
        T = 1; #10; // Toggle
        T = 0; #10; // Hold
        T = 1; #10; // Toggle
        
        $display("All Flip-flops Test Complete");
        #10;
        $finish;
    end
    
    initial begin
        $monitor("Time=%0t clk=%b | SR: S=%b R=%b Q=%b | D: D=%b Q=%b | JK: J=%b K=%b Q=%b | T: T=%b Q=%b", 
                 $time, clk, S, R, Q_sr, D, Q_d, J, K, Q_jk, T, Q_t);
    end
endmodule
