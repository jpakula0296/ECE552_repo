/*
 * 16 bit ALU, capable of performing the following operations:
 *      ADD         control=0
 *      SUB         control=1
 *      PADDSB      control=2
 *      RED         control=3
 *      XOR         control=4
 *      SLL         control=5
 *      SRA         control=6
 *      ROR         control=7
 */
module alu(
    input [15:0]    rs,
    input [15:0]    rt,
    output [15:0]   rd,
    input [2:0]     control
);
    wire [15:0] add_multifunc_out;
    wire padd, red, sub;

    wire [15:0] shift_out;
    wire [3:0] shift_val;
    wire [1:0] shift_mode;

    adder_multifunc_16bit adder(
        .padd(padd),
        .red(red),
        .sub(sub),
        .a(rs),
        .b(rt),
        .s(add_multifunc_out)
    );

    Shifter shifter(
        .Shift_In(rs),
        .Shift_Val(shift_val),
        .Shift_Out(shift_out),
        .Shift_Mode(shift_mode)
    );

endmodule
