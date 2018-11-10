/*
 * A 16 bit multifunction adder, capable of doing the following operations:
 *      16 bit add with saturation
 *      16 bit subtract with saturation
 *      4 bit parallel add with saturation
 *      8 bit reduction
 *
 * Implementation:
 *      The adder is made from seven 4-bit carry lookahead adders. All
 *      operations are done by modifying how the carry ins and carry outs are
 *      connected to each 4-bit adder.
 */
module adder_multifunc_16bit(
    input padd,         // setting to 1 does 4 half-byte parallel additions
    input red,          // setting to 1 does an 8 bit reduction
    input sub,          // setting to 1 does a subtraction instead of an addition
    input [15:0] a,     // src 1
    input [15:0] b,     // src 2, negated during subtraction
    output [15:0] s,    // result
    output ovfl         // signals if overflow occured
);
    wire [6:0] all_ovfl;    // the ovfl output of each adder
    wire [6:0] cla_cout;    // the calculated cout for each adder
    wire [6:0] all_cin;     // the cin signal to each adder
    wire [6:0] prop, gen;   // the group propogate and generate for each adder
    wire [15:0] s_unsat;    // the adder output before saturation is applied
    wire [11:0] s_red;      // the reduction output
    wire [15:0] b_flip;     // the b operand with optionally applied inversion
    wire [6:0] dummy_cout;  // suppresses warnings in Modelsim

    /*
     * Adder instantiation
     */

    // the adders for 16 bit and 4 bit parallel operations
    adder_cla_4bit adder0(
        .a(a[3:0]),
        .b(b_flip[3:0]),
        .cin(all_cin[0]),
        .s(s_unsat[3:0]),
        .ovfl(all_ovfl[0]),
        .prop_group(prop[0]),
        .gen_group(gen[0]),
        .cout(dummy_cout[0])
    );
    adder_cla_4bit adder1(
        .a(a[7:4]),
        .b(b_flip[7:4]),
        .cin(all_cin[1]),
        .s(s_unsat[7:4]),
        .ovfl(all_ovfl[1]),
        .prop_group(prop[1]),
        .gen_group(gen[1]),
        .cout(dummy_cout[1])
    );
    adder_cla_4bit adder2(
        .a(a[11:8]),
        .b(b_flip[11:8]),
        .cin(all_cin[2]),
        .s(s_unsat[11:8]),
        .ovfl(all_ovfl[2]),
        .prop_group(prop[2]),
        .gen_group(gen[2]),
        .cout(dummy_cout[2])
    );
    adder_cla_4bit adder3(
        .a(a[15:12]),
        .b(b_flip[15:12]),
        .cin(all_cin[3]),
        .s(s_unsat[15:12]),
        .ovfl(all_ovfl[3]),
        .prop_group(prop[3]),
        .gen_group(gen[3]),
        .cout(dummy_cout[3])
    );

    // additional adders needed for 8 bit reductions
    adder_cla_4bit adder4(
        .a(s_unsat[3:0]),
        .b(s_unsat[11:8]),
        .cin(all_cin[4]),
        .s(s_red[3:0]),
        .ovfl(all_ovfl[4]),
        .prop_group(prop[4]),
        .gen_group(gen[4]),
        .cout(dummy_cout[4])
    );
    adder_cla_4bit adder5(
        .a(s_unsat[7:4]),
        .b(s_unsat[15:12]),
        .cin(all_cin[5]),
        .s(s_red[7:4]),
        .ovfl(all_ovfl[5]),
        .prop_group(prop[5]),
        .gen_group(gen[5]),
        .cout(dummy_cout[5])
    );
    adder_cla_4bit adder6(
        .a({4{cla_cout[1] ^ a[7] ^ b_flip[7]}}),   // sign bit of first 8 bit addition
        .b({4{cla_cout[3] ^ a[15] ^ b_flip[15]}}), // sign bit of second 8 bit addition
        .cin(all_cin[6]),
        .s(s_red[11:8]),
        .ovfl(all_ovfl[6]),
        .prop_group(prop[6]),
        .gen_group(gen[6]),
        .cout(dummy_cout[6])
    );

    /*
     * CLA lookahead logic
     */
    assign cla_cout[0] = gen[0] | (prop[0] & all_cin[0]);
    assign cla_cout[1] = gen[1] | (prop[1] & all_cin[1]);
    assign cla_cout[2] = gen[2] | (prop[2] & all_cin[2]);
    assign cla_cout[3] = gen[3] | (prop[3] & all_cin[3]);
    assign cla_cout[4] = gen[4] | (prop[4] & all_cin[4]);
    assign cla_cout[5] = gen[5] | (prop[5] & all_cin[5]);
    assign cla_cout[6] = gen[6] | (prop[6] & all_cin[6]);

    /*
     * Adders 0-3 can be bifurcated into four 4-bit adders, two 8-bit adders,
     * or one 16-bit adder depending on the control signals. How the
     * carry-ins are assigned determintes the connections.
     */
    assign all_cin[0] = sub; // do 2's complement if subtracting
    assign all_cin[1] = padd ?          1'b0 : cla_cout[0];
    assign all_cin[2] = padd | red ?    1'b0 : cla_cout[1];
    assign all_cin[3] = padd ?          1'b0 : cla_cout[2];


    /*
     * Adders 4-6 comprise their own 12 bit adder used for reductions
     */
    assign all_cin[4] = 1'b0;
    assign all_cin[5] = cla_cout[4];
    assign all_cin[6] = cla_cout[5];

    /*
     * Do 2's complement on subtraction. all_cin[0] is the +1 part of 2's
     * complement.
     */
    assign b_flip = sub? ~b : b;


    /*
     * Output Assignment
     */

    // set the output based on what operation we're performing and what
    // overflow has happened
    assign s[15:0] =
        padd?
            // In parallel mode, saturate each adder output individually and
            // then concatenate.
            {
                all_ovfl[3] ? a[15] ? 4'h8 : 4'h7 : s_unsat[15:12],
                all_ovfl[2] ? a[11] ? 4'h8 : 4'h7 : s_unsat[11:8],
                all_ovfl[1] ? a[7]  ? 4'h8 : 4'h7 : s_unsat[7:4],
                all_ovfl[0] ? a[3]  ? 4'h8 : 4'h7 : s_unsat[3:0]
            }
        :red?
            // In 8-bit reduction mode, sign extend the output from adders 4 and 5.
            { {4{s_red[11]}}, s_red[11:0] }
        :
            // In 16 bit mode, saturate based on the final overflow bit.
            all_ovfl[3]? a[15]? 16'h8000 : 16'h7FFF : s_unsat[15:0]
        ;

    assign ovfl = 
        padd?
            |all_ovfl[3:0]
        :red?
            0
        :
            all_ovfl[3]
        ;

endmodule
