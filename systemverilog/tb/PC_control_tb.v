module PC_control_tb();

wire [15:0] pc_new;
reg [2:0] flags;
wire [15:0] instruction; // need full instr for conditional branch
reg [15:0] branch_reg_addr; // connected to rs data
reg [15:0] pc_current;

// dumbly parsed instruction within control module, separate elements and
// recombine here so we can manipulate each field more easily
reg [7:0] immediate;
reg [2:0] condition_flags;
reg [3:0] opcode;
assign instruction = {opcode, condition_flags, immediate};



PC_control DUT(
    .pc_new(pc_new),
    .flags(flags),
    .instruction(instruction),
    .branch_reg_addr(branch_reg_addr),
    .pc_current(pc_current)
    );


initial begin
    flags = 3'b000;
    branch_reg_addr = 16'h0000;
    pc_current = 16'h0000;
    immediate = 0;
    condition_flags = 0;
    opcode = 4'b0000;
    branch_reg_addr = 16'h000F;

    // check we are getting PC + 2
    #5 if (pc_new != 2) begin
      $display("PC+2 ERROR");
      $display("PC = %d", pc_new);
      $stop();
    end

    // branch_reg check, condition already true (Z = 0)
    opcode = 4'b1101;
    #5 if (pc_new != 16'h000F) begin
      $display("BR ERROR");
      $display("PC = %d", pc_new);
      $stop();
    end

    // branch immediate check, should get 4 for new address
    opcode = 4'b1100;
    immediate = 1;
    #5 if (pc_new != 4) begin
      $display("BRANCH IMM ERROR");
      $display("PC = %d", pc_new);
      $stop();
    end

    $display("SUCCESS");
    $stop();
end
endmodule
