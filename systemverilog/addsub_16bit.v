module addsub_16bit(
    input padd,         // setting to 1 does 4 half-byte parallel additions
    input sub,          // setting to 1 does a subtraction instead of an addition
    input [15:0] a,     // src 1
    input [15:0] b,     // src 2, negated during subtraction
    output [15:0] s,    // result
    output cout         // carry-out
);
    /*
     * Instantiate the 16 bit adder. It is created from four 4-bit cla adders.
     * The overflow output on the adders is used to detect when the output
     * should be saturated. Additionally, if the parallel_add wire is high,
     * the adders are separated to perform parallel addition. If the sub wire
     * is high, the carry-in input is set to 1, and the b input is inverted.
     */
    wire [3:0] ovfl;
    wire [3:0] cout;
    wire [3:0] prop, gen;
    wire cin;
    wire b_mod;

    // if subtracting, do 2's complement on b
    assign b_mod = sub? ~b : b;
    assign cin = sub;

    adder_cla_4bit(
        .a(a[3:0]),
        .b(b_mod[3:0]),
        .cin(cin),
        .s(s[3:0]),
        .ovfl(ovfl[0]),
        .prop_group(prop[0]),
        .gen_group(gen[0])
    );
    adder_cla_4bit(
        .a(a[7:4]),
        .b(b_mod[7:4]),
        .cin(cout[0]),
        .s(s[7:4]),
        .ovfl(ovfl[1]),
        .prop_group(prop[1]),
        .gen_group(gen[1])
    );
    adder_cla_4bit(
        .a(a[11:8]),
        .b(b_mod[11:8]),
        .cin(cout[1]),
        .s(s[11:8]),
        .ovfl(ovfl[2]),
        .prop_group(prop[2]),
        .gen_group(gen[2])
    );
    adder_cla_4bit(
        .a(a[3:0]),
        .b(b_mod[3:0]),
        .cin(cin),
        .s(s[3:0]),
        .ovfl(ovfl[0]),
        .prop_group(prop[0]),
        .gen_group(gen[0])
    );

    // do carry lookahead logic
    assign cout[0] = gen[0] | (prop[0] & cin);
    assign cout[1] = gen[1] | (prop[1] & cout[0]);
    assign cout[2] = gen[2] | (prop[2] & cout[1]);
    assign cout[3] = gen[3] | (prop[3] & cout[2]);
endmodule
