`timescale 10ps/1ps

module dff_nedge_tb;
    reg clock = 1 , d;
    wire q, qn;
    dff_nedge uut (
        .clk(clock),
        .d(d),
        .q(q),
        .qn(qn)
    );
    initial forever #1 clock = ~clock;  // Generate clock signal with a period of 2 time units
    initial begin
        $dumpfile("vcd/dff_nedge.vcd");
        $dumpvars(0, dff_nedge_tb);
        $monitor("Time=%0t: clock=%b d=%b q=%b qn=%b", $time, clock, d, q, qn);
        repeat (10) begin
            d = $random % 2;  // Randomly set d to 0 or 1
            #2;  // Wait for two clock cycles
        end
        $finish;  // End simulation
    end
endmodule