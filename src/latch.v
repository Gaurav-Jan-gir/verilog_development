module latch (data, load, out);
    input data,load;
    output reg out;
    reg t;
    always @(data or load) begin
        if(!load)
            t = data;
         out = ~t;
    end
endmodule