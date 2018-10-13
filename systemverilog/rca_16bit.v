/*
 * 16 bit ripple carry adder: Combines four 4 bit ripple carry adders to create a 16 bit adder with carry-in
 */
module rca_16bit(
    input [15:0] a,
    input [15:0] b,
    input cin,
    output [15:0] s,
    output cout);

    wire carry[2:0];

    rca_4bit rca0(
        .a(a[3:0]),
        .b(b[3:0]),
        .cin(cin),
        .s(s[3:0]),
        .cout(carry[0])
    );
    rca_4bit rca1(
        .a(a[7:4]),
        .b(b[7:4]),
        .cin(carry[0]),
        .s(s[7:4]),
        .cout(carry[1])
    );
    rca_4bit rca2(
        .a(a[11:8]),
        .b(b[11:8]),
        .cin(carry[1]),
        .s(s[11:8]),
        .cout(carry[2])
    );
    rca_4bit rca3(
        .a(a[15:12]),
        .b(b[15:12]),
        .cin(carry[2]),
        .s(s[15:12]),
        .cout(cout)
    );

endmodule
