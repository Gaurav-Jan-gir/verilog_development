`timescale 1ns/100ps

module tb_latch;

    reg data, load;
    wire out;

    // Instantiate the Unit Under Test (UUT)
    latch uut (
        .data(data),
        .load(load),
        .out(out)
    );

    initial begin
        // Initialize VCD dump
        $dumpfile("vcd/latch.vcd");
        $dumpvars(0, tb_latch);

        // Initialize inputs
        data = 0;
        load = 0;

        // Test cases
        #10;
        data = 0; load = 0;
        #10;
        $display("Time=%0t: data=%b load=%b out=%b", $time, data, load, out);

        #10;
        data = 1; load = 0;
        #10;
        $display("Time=%0t: data=%b load=%b out=%b", $time, data, load, out);

        #10;
        data = 0; load = 1;
        #10;
        $display("Time=%0t: data=%b load=%b out=%b", $time, data, load, out);

        #10;
        data = 1; load = 1;
        #10;
        $display("Time=%0t: data=%b load=%b out=%b", $time, data, load, out);

        #10;
        $finish;
    end
endmodule