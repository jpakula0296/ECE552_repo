module PC_control_tb();

wire [15:0] pc_new;
reg clk;
reg [2:0] flags;
wire [15:0] instruction; // need full instr for conditional branch
reg [15:0] branch_reg_addr; // connected to rs data
reg [15:0] pc_current;
reg rst;

// dumbly parsed instruction within control module, separate elements and
// recombine here so we can manipulate each field more easily
reg [7:0] immediate;
reg [2:0] condition_flags;
reg [3:0] opcode
assign instruction = {opcode, condition_flags, immediate};

PC_control DUT(
    .pc_new(pc_new),
    .clk(clk),
    .flags(flags),
    .instruction(instruction),
    .branch_reg_addr(branch_reg_addr),
    .pc_current(pc_current),
    .rst(rst)
);

initial begin
    clk = 1'b0;
    rst = 1'b1;
    flags = 3'b000;
    instruction = 16'h0000;
    branch_reg_addr = 16'h0000;
    pc_




end

always begin
  #5 clk = ~clk;
end

endmodule
