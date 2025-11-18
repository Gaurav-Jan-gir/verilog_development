// Testbench for 3:8 Decoder
`timescale 1ns/1ps

module decoder_3to8_tb;
    reg [2:0] S;
    wire [7:0] D;
    
    decoder_3to8 uut (
        .S(S),
        .D(D)
    );
    
    initial begin
        $dumpfile("vcd/decoder_3to8.vcd");
        $dumpvars(0, decoder_3to8_tb);
        
        // Test all combinations
        S = 3'b000; #10;
        S = 3'b001; #10;
        S = 3'b010; #10;
        S = 3'b011; #10;
        S = 3'b100; #10;
        S = 3'b101; #10;
        S = 3'b110; #10;
        S = 3'b111; #10;
        
        $display("3:8 Decoder Test Complete");
        $finish;
    end
    
    initial begin
        $monitor("Time=%0t S=%b D=%b", $time, S, D);
    end
endmodule
