// PC encompasses all logic in deciding how to calculate pc_addr_out
// including necessary computations
module PC_control (
    output [15:0] pc_new,
    input clk,
    input [2:0] flags,
    input [15:0] instruction, // need full instr for conditional branch
    input [15:0] branch_reg_addr, // connected to rs data
    input [15:0] pc_current,
    input rst);

wire [15:0] plus_two, branch_imm, plus_imm;
wire [3:0] opcode;
assign opcode = instruction[15:11]; // used to decide final pc_addr_in

wire Z_flag;
assign Z_flag = flags[0];
wire N_flag;
assign N_flag = flags[1];
wire V_flag;
assign V_flag = flags[2];

wire [2:0] condition_flags; // from instruction \
assign condition_flags = instruction[10:8];
reg condition_passed;
always @* case (condition_flags)
  3'b000 : condition_passed = ~Z_flag; // not equal
  3'b001 : condition_passed = Z_flag; // equal
  3'b010 : condition_passed = ~Z_flag & ~N_flag; // greater than
  3'b011 : condition_passed = N_flag;  // less than
  3'b100 : condition_passed = Z_flag | ~N_flag; // greather than or equal to
  3'b101 : condition_passed = N_flag | Z_flag; // less than or equal to
  3'b110 : condition_passed = V_flag; // overflow
  3'b111 : condition_passed = 1'b1; // unconditional
endcase

wire [7:0] immediate;
assign immediate = instruction[7:0];

// Adder modules
rca_16bit plus2 ( // PC + 2
    .a(pc_current),
    .b(16'h2),
    .cin(1'b0),
    .s(plus_two),
    .cout()
);
rca_16bit plusimm ( // PC + 2 + (I << 1)
    .a(plus_two),
    .b({{8{1'b0}}, immediate}),
    .cin(1'b0),
    .s(branch_imm),
    .cout()
);

assign pc_new = (opcode == 4'b1111) ? pc_current : // halt
  (~condition_passed) ?  plus_two : (opcode == 4'b1100) ? branch_imm :
  (opcode == 4'b1101) ? branch_reg_addr : plus_two;

endmodule
