// PC encompasses all logic in deciding how to calculate pc_addr_out
// including necessary computations
module PC_control (
    output [15:0] pc_new,
    output flush_out,
    input [2:0] flags,
    input [15:0] instruction, // need full instr for conditional branch
    input [15:0] branch_reg_addr, // connected to rs data
    input [15:0] pc_current
    );

wire [15:0] plus_two, branch_imm;
wire [3:0] opcode;
assign opcode = instruction[15:12]; // used to decide final pc_addr_in

wire Z_flag;
assign Z_flag = flags[0];
wire N_flag;
assign N_flag = flags[1];
wire V_flag;
assign V_flag = flags[2];

wire [2:0] condition_flags; // from instruction \
assign condition_flags = instruction[11:9];
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
  default: condition_passed = 1'b0;
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
    .b({{8{immediate[7]}}, (immediate << 1)}),
    .cin(1'b0),
    .s(branch_imm),
    .cout()
);

wire halt_instr, branch_instr;
assign halt_instr = opcode == 4'b1111;
assign branch_instr = opcode[3:1] == 3'b110;


assign pc_new = halt_instr ? pc_current : // halt
  (~condition_passed) ?  plus_two : (opcode == 4'b1100) ? branch_imm :
  (opcode == 4'b1101) ? branch_reg_addr : plus_two;

assign flush_out = branch_instr & condition_passed;
endmodule
