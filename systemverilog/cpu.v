module cpu(
  input clk, rst_n,
  output hlt,
  output [15:0] pc
  );

wire [3:0] opcode; // pulled from instruction

// PC Memory
wire [15:0] pc_current, instr, pc_new;
wire [2:0] flags;

// Data Memory
wire [15:0] data_out, data_addr;
wire data_wr;

// Register File wires
wire WriteReg;
wire Z_in, V_in, N_in, Z_out, V_out, N_out;
wire [3:0] rs, rt, rd;
wire [15:0] rsData, rtData, DstData;
wire load_instr; // for assigning regwrite enable
wire PCS_instr; // for assiging DstData
wire load_half_instr;
wire ALU_instr;
wire reg_write_instr; // if not high 'write' to $0 since we can't anyway

// ALU wires
wire [15:0] ALU_out; // ALU output
wire [15:0] ALU_rt_data; // data fed into rt of ALU

wire rst;
assign rst = ~rst_n; // keep active high/low resets straight
assign hlt = (opcode == 4'b1111);

// PC Control - determines next instruction fetched from PC memory
// flags based on output of flag register, flops ALU flag outputs
// branch_reg_addr acts on register RS
assign flags = {V_out, N_out, Z_out};
PC_control pc_cntrl(.pc_new(pc_new), .flags(flags), .instruction(instr),
  .branch_reg_addr(rsData), .pc_current(pc_current));

// PC Address Flip-Flop
// feeds program memory address, changes every posedge clk
// input calculated from PC+2 or branch instruction
// write enable not needed, keep high
dff_16bit DFF0(.q(pc_current), .d(pc_new), .wen(1'b1), .clk(clk), .rst(rst));

// PC Memory, read only
// data_in doesn't need connection, never write data after initial loading
// address multiplexed from PC+2 and branch/jump logic
// on hlt instruction pc_addr holds its value
// enable strapped high since we are always reading from this memory
// write enable strapped low, always reading
// output is instr
assign opcode = instr[15:12];
pc_mem prog_mem(.clk(clk), .rst(rst), .data_in(16'b0), .data_out(instr),
  .addr(pc_current), .enable(1'b1), .wr(1'b0));

// Register File
// DstReg, SrcRegs from instr, WriteReg from opcode
// DstData multiplexed from ALU output and data memory
// SrcDatas fed to ALU or memory
// SrcReg1 = RS, SrcReg2 = RT
// rt is either instr[11:8] on store instrs and [3:0] otherwise
// WriteReg on all compute and LW instrs
// DstData is either ALU or memory depending on instruction
// rd = 0 when not write instruction, can't write to this register
assign load_instr = opcode[3] & ~opcode[2];
assign PCS_instr = (opcode == 4'b1110);
assign load_half_instr = load_instr & ~opcode[1];
assign ALU_instr = ~opcode[3];
assign WriteReg = ALU_instr | load_instr | PCS_instr;
assign rd = instr[11:8];
assign rs = (load_half_instr) ? rd : instr[7:4];
assign rt = (opcode[3]) ? instr[11:8] : instr[3:0];
assign DstData =
    (load_instr)?
        data_out
    :(PCS_instr)?
        pc_new
    :
        ALU_out
    ;

RegisterFile regfile(.clk(clk), .rst(rst), .WriteReg(WriteReg), .SrcReg1(rs),
  .SrcReg2(rt), .DstReg(rd), .SrcData1(rsData), .SrcData2(rtData),
  .DstData(DstData), .Z_in(Zin), .V_in(V_in), .N_in(N_in), .Z_out(Z_out),
  .N_out(N_out), .V_out(V_out));

// ALU
assign ALU_rt_data = load_half_instr? {8'h0, instr[7:0]} : rtData;
alu ALU(.rs(rsData), .rt(ALU_rt_data), .control(opcode), .rd(ALU_out), .N(N_in), .Z(Z_in), .V(V_in));

// Data Memory Control - Computes Data Memory address based on instruction
// read data registers from register file, offset from instruction
// send target address to data memory for read or write
data_mem_control data_control(.rsData(rsData), .rtData(rtData),
  .offset(instr[3:0]), .target_addr(data_addr));

// Data Memory
// data_in from register rt, data_out to DstReg multiplexer, address from ALU,
// overall enable strapped high, muxing read data anyway
// write enable assigned to store opcode
// data_out to DstData
assign data_wr = (opcode == 4'b1001); // only write on store instrs
data_mem data_memory(.data_in(rtData), .data_out(data_out), .addr(data_addr),
  .enable(1'b1), .wr(data_wr), .clk(clk), .rst(rst));

// assign output pc
assign pc = pc_current;
endmodule
