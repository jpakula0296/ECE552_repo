/*
 * CLA 4 bit: a carry lookahead module for a 4 bit adder
 */
module cla_4bit(
    input [3:0] a,
    input [3:0] b,
    input cin,
    output [3:0] cout,
    output prop_group,
    output gen_group
);
    wire [3:0] prop;
    wire [3:0] gen;

    assign prop = a ^ b;
    assign gen = a & b;

    assign cout[0] = gen[0] | (prop[0] & cin);
    assign cout[1] = gen[1] | (prop[1] & cout[0]);
    assign cout[2] = gen[2] | (prop[2] & cout[1]);
    assign cout[3] = gen[3] | (prop[3] & cout[2]);

    assign prop_group = &prop;
    assign gen_group =
        gen[3] |
        (gen[2] & prop[3]) |
        (gen[1] & prop[3] & prop[2]) |
        (gen[0] & prop[3] & prop[2] & prop[3]);

endmodule
