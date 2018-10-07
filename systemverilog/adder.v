/*
 * contains adder modules
 */

/*
 * Half adder: Adds two bits, and gives their sum and carry-out
 */
module half_adder(
    input a,
    input b,
    output s,
    output cout
);
    assign s = a ^ b;
    assign cout = a & b;
endmodule

/*
 * Full adder: Combines two half adders to create a full adder with carry-in
 */
module full_adder(
    input a,
    input b,
    input cin,
    output s,
    output cout
);

    wire s_0, cout_0, cout_1;

    half_adder ha0(a, b, s_0, cout_0);
    half_adder ha1(s_0, cin, s, cout_1);
    assign cout = cout_0 | cout_1;

endmodule


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

/*
 *  A 4 bit cla adder. Has an overflow output to make saturation arithmetic
 *  easier in the ALU.
 */
module adder_cla_4bit(
    input [3:0] a,
    input [3:0] b,
    input cin,
    output [3:0] s,
    output cout,
    output ovfl
);
    wire [3:0] carry;
    wire prop_group;
    wire gen_group;

    /*
     * Spec calls for a CLA adder, so use a CLA module.
     */
    cla_4bit cla(
        .a(a),
        .b(b),
        .cin(cin),
        .cout(carry),
        .prop_group(prop_group),
        .gen_group(gen_group)
    );

    /*
     * Instantiate each of the full adders and hook them up to the cla module.
     */
    full_adder fa0(
        .a(a[0]),
        .b(b[0]),
        .cin(cin),
        .s(s[0])
    );
    full_adder fa1(
        .a(a[1]),
        .b(b[1]),
        .cin(carry[0]),
        .s(s[1])
    );
    full_adder fa2(
        .a(a[2]),
        .b(b[2]),
        .cin(carry[1]),
        .s(s[2])
    );
    full_adder fa3(
        .a(a[3]),
        .b(b[3]),
        .cin(carry[2]),
        .s(s[3])
    );

    assign cout = carry[3];
    assign ovfl = carry[3] ^ carry[2];
endmodule
