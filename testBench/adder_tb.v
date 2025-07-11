`timescale 10ps/1ps

module adder_tb;
    reg [15:0] a, b;
    wire [15:0] sum;
    wire cout, sign, parity, overflow;
    integer i,j,o;

    adder_16 uut (
        .sum(sum),
        .a(a),
        .b(b),
        .sign(sign),
        .parity(parity),
        .overflow(overflow),
        .cout(cout)
    );

    initial begin
        $dumpfile("vcd/adder.vcd");
        $dumpvars(0, adder_tb);
        $monitor("Time=%0t: a=%h b=%h sum=%h cout=%b sign=%b parity=%b overflow=%b", $time, a, b, sum, cout, sign, parity, overflow);
        // Test all combinations of a and b
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                a = i;
                b = j;
                #10; // Wait for the output to stabilize
            end
        end
        // Test some edge cases
        a = 16'hFFFF; // Max value
        b = 16'h0001; // Overflow case
        #10;
        a = 16'h8000; // Negative value
        b = 16'h8000; // Negative value
        #10;
        a = 16'h7FFF; // Max positive value
        b = 16'h0001; // No overflow
        #10;
        a = 16'h0000; // Zero
        b = 16'h0000; // Zero
        #10;
        a = 16'h0000; // Zero
        b = 16'hFFFF; // Negative value
        #10;
        a = 16'hFFFF; // Negative value
        b = 16'h0000; // Zero
        #10;
        a = 16'h1234; // Random value
        b = 16'h5678; // Random value
        #10;
        a = 16'hABCD; // Random value
        b = 16'hEF01; // Random value
        #10;
        a = 16'h0001; // Small positive value
        b = 16'h0001; // Small positive value
        #10;
        $finish;
    end
endmodule

