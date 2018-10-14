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
    output ovfl,
    output prop_group,
    output gen_group
);
    wire [3:0] carry;
    wire [3:0] dummy_cout; // needed to suppress warning

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
        .s(s[0]),
        .cout(dummy_cout[0])
    );
    full_adder fa1(
        .a(a[1]),
        .b(b[1]),
        .cin(carry[0]),
        .s(s[1]),
        .cout(dummy_cout[1])
    );
    full_adder fa2(
        .a(a[2]),
        .b(b[2]),
        .cin(carry[1]),
        .s(s[2]),
        .cout(dummy_cout[2])
    );
    full_adder fa3(
        .a(a[3]),
        .b(b[3]),
        .cin(carry[2]),
        .s(s[3]),
        .cout(dummy_cout[3])
    );

    assign cout = carry[3];
    assign ovfl = carry[3] ^ carry[2];
endmodule
