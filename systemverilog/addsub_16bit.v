/*
 * The 16 bit adder. It is created from four 4-bit cla adders.
 * The overflow output on the adders is used to detect when the output
 * should be saturated. Additionally, if the parallel_add wire is high,
 * the adders are separated to perform parallel addition. If the sub wire
 * is high, the carry-in input is set to 1, and the b input is inverted.
 */
module addsub_16bit(
    input padd,         // setting to 1 does 4 half-byte parallel additions
    input sub,          // setting to 1 does a subtraction instead of an addition
    input [15:0] a,     // src 1
    input [15:0] b,     // src 2, negated during subtraction
    output [15:0] s,    // result
    output cout         // carry-out
);
    wire [3:0] ovfl;
    wire [3:0] cla_cout;
    wire [3:0] prop, gen;
    wire [15:0] s_unsat;
    wire [15:0] b_flip;
    wire cin;

    // if subtracting, do 2's complement on b
    assign b_flip = sub? ~b : b;
    assign cin = sub;

    adder_cla_4bit adder0(
        .a(a[3:0]),
        .b(b_flip[3:0]),
        .cin(cin),
        .s(s_unsat[3:0]),
        .ovfl(ovfl[0]),
        .prop_group(prop[0]),
        .gen_group(gen[0])
    );
    adder_cla_4bit adder1(
        .a(a[7:4]),
        .b(b_flip[7:4]),
        .cin(cla_cout[0]),
        .s(s_unsat[7:4]),
        .ovfl(ovfl[1]),
        .prop_group(prop[1]),
        .gen_group(gen[1])
    );
    adder_cla_4bit adder2(
        .a(a[11:8]),
        .b(b_flip[11:8]),
        .cin(cla_cout[1]),
        .s(s_unsat[11:8]),
        .ovfl(ovfl[2]),
        .prop_group(prop[2]),
        .gen_group(gen[2])
    );
    adder_cla_4bit adder3(
        .a(a[15:12]),
        .b(b_flip[15:12]),
        .cin(cla_cout[2]),
        .s(s_unsat[15:12]),
        .ovfl(ovfl[3]),
        .prop_group(prop[3]),
        .gen_group(gen[3])
    );

    // perform saturation logic
    assign s[15:0] =
        padd?
            // In parallel mode, saturate each adder output individually and
            // then concatenate.
            {
                ovfl[3]? s_unsat[15]? 4'h8 : 4'h7 : s_unsat[15:12],
                ovfl[2]? s_unsat[11]? 4'h8 : 4'h7 : s_unsat[11:8],
                ovfl[1]? s_unsat[7]?  4'h8 : 4'h7 : s_unsat[7:4],
                ovfl[0]? s_unsat[3]?  4'h8 : 4'h7 : s_unsat[3:0]
            }
        :
            // In 16 bit mode, saturate only based on the final overflow bit
            ovfl[3]? s_unsat[15]? 16'h8000 : 16'h7FFF : s_unsat[15:0]
        ;


    // do carry lookahead logic, but only when in 16 bit mode
    assign cla_cout[0] = padd ? 1'b0 : gen[0] | (prop[0] & cin);
    assign cla_cout[1] = padd ? 1'b0 : gen[1] | (prop[1] & cla_cout[0]);
    assign cla_cout[2] = padd ? 1'b0 : gen[2] | (prop[2] & cla_cout[1]);
    assign cla_cout[3] = padd ? 1'b0 : gen[3] | (prop[3] & cla_cout[2]);

endmodule
