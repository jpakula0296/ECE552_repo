module cpu(
  input clk, rst_n,
  output hlt,
  output [15:0] pc
  );

// control module (opcode directly connected to instr)
wire [3:0] opcode;

// PC Memory
wire [15:0] pc_data_in, instr, pc_addr;

// Data Memory
wire [15:0] data_in, data_out, data_addr;
wire data_wr;

// Register File wires
wire WriteReg;
wire Z_in, O_in, N_in, Z_en, O_en, N_en, Z_out, O_out, N_out;
wire [3:0] rs, rt, rd;
wire [15:0] rsData, rtData, DstData;
wire load_instr; // for assigning regwrite enable
wire load_half_instr;

assign rst = ~rst_n; // keep active high/low resets straight
assign hlt = (opcode == 4'b1111);

// PC Memory, read only
// data_in doesn't need connection, never write data after initial loading
// address multiplexed from PC+4 and branch/jump logic
// on hlt instruction pc_addr holds its value
// enable strapped high since we are always reading from this memor
// write enable strapped low, always reading
// output is instr
assign opcode = instr[15:12];
memory1c prog_mem(.clk(clk), .rst(rst), .data_in(pc_data_in), .data_out(instr),
  .addr(pc_addr), .enable(1'b1), .wr(1'b0));

// Register File
// DstReg, SrcRegs from instr, WriteReg from opcode
// DstData multiplexed from ALU output and data memory
// SrcDatas fed to ALU or memory
// SrcReg1 = RS, SrcReg2 = RT
// rt is either instr[11:8] on store instrs and [3:0] otherwise
// WriteReg on all compute and LW instrs
// DstData is either ALU or memory depending on instruction
// load half byte operations require reading from dest reg to build full word
assign load_instr = opcode[3] & ~opcode[2];
assign load_half_instr = load_instr & ~opcode[1];
assign rd = instr[11:8];
assign rs = (load_half_instr) ? instr[11:8] : instr[7:4];
assign rt = (opcode[3]) ? instr[11:8] : instr[3:0];
// UNCOMMENT WHEN ALU DONE assign DstData = (load_instr) ? data_out : ALU_out;
RegisterFile regfile(.clk(clk), .rst(rst), .WriteReg(WriteReg), .SrcReg1(rs),
  .SrcReg2(rt), .DstReg(rd), .SrcData1(rsData), .SrcData2(rtData),
  .DstData(DstData));

// ALU

// Data Memory
// data_in from register rt, data_out to DstReg multiplexer, address from ALU,
// overall enable strapped high, muxing read data anyway
// write enable assigned to store opcode
// data_out to DstData
assign data_wr = (opcode == 4'b1001); // only write on store instrs
memory1c data_mem(.data_in(data_in), .data_out(DstData), .data_addr(data_addr),
  .enable(1'b1), .wr(data_wr), .clk(clk), .rst(rst));


endmodule
