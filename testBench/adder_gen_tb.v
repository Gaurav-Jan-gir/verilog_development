`timescale 1ns/100ps

module adder_gen_tb;
    parameter N = 16;  // Use N instead of WIDTH
    
    reg [N-1:0] a, b;
    wire [N-1:0] sum;
    wire cout;
    
    // Instantiate the Unit Under Test (UUT)
    adder_gen #(.N(N)) uut (  // Use .N(N) instead of .WIDTH(WIDTH)
        .a(a),
        .b(b),
        .sum(sum),
        .cout(cout)
    );
    
    initial begin
        $dumpfile("vcd/adder_gen.vcd");
        $dumpvars(0, adder_gen_tb);
        
        // Test cases
        a = 8'h0F; b = 8'h0F;
        #10 $display("a=%h b=%h sum=%h cout=%b", a, b, sum, cout);
        
        a = 8'hFF; b = 8'h01;
        #10 $display("a=%h b=%h sum=%h cout=%b", a, b, sum, cout);
        
        a = 8'hAA; b = 8'h55;
        #10 $display("a=%h b=%h sum=%h cout=%b", a, b, sum, cout);
        
        #10 $finish;
    end
endmodule