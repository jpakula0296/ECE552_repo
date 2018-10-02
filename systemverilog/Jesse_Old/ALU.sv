/* 4-bit ALU module with NAND, XOR, ADD, and SUBTRACTION
 * Implemented by muxing each operation based on Opcode
 * 00 = NAND
 * 01 = XOR
 * 10 = ADD
 * 11 = SUBTRACT
*/
module ALU (
  input [3:0] ALU_In1, ALU_In2,
  input [1:0] Opcode,
  output [3:0] ALU_Out,
  output Error
);

// NAND implemented with bitwise AND and negation
wire[3:0] nand_out;
assign nand_out = ~(ALU_In1 & ALU_In2);

// XOR output
wire[3:0] xor_out;
assign xor_out = ALU_In1 ^ ALU_In2;

// add an subtract come from ripple carry adder module

wire [3:0] addsub_out;
wire addsub_error;
addsub_4bit add(.A(ALU_In1), .B(ALU_In2), .sub(Opcode[0]), .Sum(addsub_out), .Ovfl(addsub_error));


// mux the outputs based on Opcode, if opcode[1] is 1 it comes from 4bit addsub
assign ALU_Out = (Opcode == 2'b00) ? nand_out :
                 (Opcode == 2'b01) ? xor_out  : addsub_out;

// Error/overflow impossible for nand/xor, otherwise catch addsub_4bit overflow
assign Error = (Opcode[1]) ? addsub_error : 1'b0;

endmodule
