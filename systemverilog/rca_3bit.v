/*
 * 3 bit ripple carry adder using 3 full adders
 */
module rca_3bit(
    input [2:0] a,
    input [2:0] b,
    input cin,
    output [2:0] s,
    output cout
);
    wire [1:0] ripple_carry;
    full_adder fa0(
        .a(a[0]),
        .b(b[0]),
        .cin(cin),
        .s(s[0]),
        .cout(ripple_carry[0])
    );
    full_adder fa1(
        .a(a[1]),
        .b(b[1]),
        .cin(ripple_carry[0]),
        .s(s[1]),
        .cout(ripple_carry[1])
    );
    full_adder fa2(
        .a(a[2]),
        .b(b[2]),
        .cin(ripple_carry[1]),
        .s(s[2]),
        .cout(cout)
    );
endmodule
