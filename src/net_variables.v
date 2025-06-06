module fun1(a,b,c,d,f_wire,f_tri,f_wor,f_wand,f_supply0,f_supply1);
    input a,b,c,d;
    output f_wire,f_tri,f_wor,f_wand,f_supply0,f_supply1;
    wire f_wire;
    tri f_tri;
    wor f_wor;
    wand f_wand;
    supply0 f_supply0;
    supply1 f_supply1;

    assign f_wire = (a&b);
    assign f_wire = (c|d);
    assign f_tri = (a&b);
    assign f_tri = (c|d);
    assign f_wor = (a&b);
    assign f_wor = (c|d);
    assign f_wand = (a&b);
    assign f_wand = (c|d);
    assign f_supply0 = (a&b);
    assign f_supply0 = (c|d);
    assign f_supply1 = (a&b);
    assign f_supply1 = (c|d);

endmodule
