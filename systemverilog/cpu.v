module cpu(
  input clk, rst_n,
  output hlt,
  output [15:0] pc
  );

// control module (opcode directly connected to instruction)
wire [3:0] opcode;
assign opcode = instruction[15:12];

// PC Memory
wire [15:0] pc_data_in, instruction, pc_addr;

// Data Memory
wire [15:0] data_in, data_out, data_addr;
wire data_wr;
assign data_wr = (opcode == 4'b1001) // only write on store instructions

// Register File wires
wire WriteReg;
wire Z_in, O_in, N_in, Z_en, O_en, N_en, Z_out, O_out, N_out;
wire [3:0] rs, rt, rd;
wire [15:0] rsData, rtData, DstData;
assign rd = instruction[11:8];
assign rs = instruction[7:4];
// rt is either instr[11:8] on store instructions and [3:0] otherwise
assign rt = (opcode[3]) ? instruction[11:8] : instruction[3:0];

assign rst = ~rst_n; // keep active high/low resets straight

// PC Memory, read only
// data_in doesn't need connection, never write data after initial loading
// address multiplexed from PC+4 and branch/jump logic
// enable strapped high since we are always reading from this memory
// write enable strapped low, always reading
// output is instruction
memory1c prog_mem(.clk(clk), .rst(rst), .data_in(pc_data_in), .data_out(instruction),
  .addr(pc_addr), .enable(1'b1), .wr(1'b0));

// control module
control cntrl(.clk(clk), .rst_n(rst_n), .opcode(opcode));


// Register File
// DstReg, SrcRegs from instruction, WriteReg from opcode
// DstData multiplexed from ALU output and data memory
// SrcDatas fed to ALU or memory
// SrcReg1 = RS, SrcReg2 = RT
RegisterFile regfile(.clk(clk), .rst(rst), .WriteReg(WriteReg), .SrcReg1(rs),
  .SrcReg2(rt), .DstReg(rd), .SrcData1(rsData), .SrcData2(rtData),
  .DstData(DstData));

// ALU

// Data Memory
// data_in from register rt, data_out to DstReg multiplexer, address from ALU,
// overall enable strapped high, muxing read data anyway
// write enable assigned to store opcode
// data_out to DstData
memory1c data_mem(.data_in(data_in), .data_out(DstData), .data_addr(data_addr),
  .enable(1'b1), .wr(data_wr), .clk(clk), .rst(rst));

// Write Data Mux chooses ALU output or data memory output to write to rd






endmodule
