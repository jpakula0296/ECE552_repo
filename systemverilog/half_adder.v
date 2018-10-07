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
