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
