module cpu(
  input clk, rst_n,
  output hlt,
  output [15:0] pc
  );

wire [3:0] opcode; // pulled from instruction

// PC Memory
wire [15:0] pc_current, instr, pc_new, pc_cntrl_in;
wire [2:0] flags;

// Data Memory
wire [15:0] data_out, data_addr;
wire id_store_instr;
wire mem_store_instr;

// flag register/control s
wire Z_in, V_in, N_in, Z_out, V_out, N_out, Z_en, V_en, N_en;

// control signals found by ID stage
wire WriteReg;
wire [3:0] rs, rt, rd;
wire [15:0] rsData, rtData, DstData;
wire [15:0] id_instr_out;
wire load_instr; // for assigning regwrite enable
wire imm_instr;
wire PCS_instr; // for assiging DstData
wire load_half_instr;
wire ALU_instr;
wire arith_instr; // indicates addition or subtraction
wire xor_instr;
wire sll_instr;
wire sra_instr;
wire ror_instr;
wire logical_instr;
wire reg_write_instr; // if not high 'write' to $0 since we can't anyway
wire stall_n;
wire [15:0] load_half_data;

// ID/EX Stage pipeline outputs
wire [15:0] ex_rt_data;
wire [15:0] ex_rs_data;
wire [15:0] ex_imm, id_imm, ex_load_half_data;
wire [3:0] ex_opcode;
wire ex_load_half_instr;
wire ex_imm_instr;
wire ex_mem_write;
wire ex_WriteReg;

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
PC_control pc_cntrl(.pc_new(pc_new), .flags(flags), .instruction(id_instr_out),
  .branch_reg_addr(rsData), .pc_current(pc_cntrl_in));

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
pc_mem prog_mem(.clk(clk), .rst(rst), .data_in(16'b0), .data_out(instr),
  .addr(pc_current), .enable(1'b1), .wr(1'b0));

// IF-ID stage pipeline - holds current instruction and pc_plus_four
// to pass to decode portion to determine control signals
// Input - instr_in from pc_memory, pc_plus_four from pc_control
// output - just flops inputs, passed to branch control logic and
// decode signals below
IF_ID if_id(.instr_in(instr), .instr_out(id_instr_out), .pc_current_in(pc_current),
  .pc_current_out(pc_cntrl_in), .clk(clk), .rst(rst));

// pull opcode from output of id_instruction
// register file and later signals will be decoded based on this and passed
// along.
assign opcode = id_instr_out[15:12];


// Register File
// DstReg, SrcRegs from instr, WriteReg from opcode
// DstData multiplexed from ALU output and data memory
// SrcDatas fed to ALU or memory
// SrcReg1 = RS, SrcReg2 = RT
// rt is either instr[11:8] on store instrs and [3:0] otherwise
// WriteReg on all compute and LW instrs
// DstData is either ALU or memory depending on instruction
// rd = 0 when not write instruction, can't write to this register
// set flag enable signals based on type of instruction
assign load_instr = opcode[3] & ~opcode[2];
assign PCS_instr = (opcode == 4'b1110);
assign imm_instr = (~opcode[3] & opcode[2] & ~(&opcode[1:0])); // all shift instructions
assign load_half_instr = load_instr & opcode[1];
assign ALU_instr = ~opcode[3];
assign arith_instr = (opcode[3:1] == 3'b000);
assign xor_instr = (opcode == 4'b0010);
assign sll_instr = (opcode == 4'b0100);
assign sra_instr = (opcode == 4'b0101);
assign ror_instr = (opcode == 4'b0110);
assign id_store_instr = (opcode == 4'b1001); // only write on store instrs

assign logical_instr = xor_instr | sll_instr | sra_instr | ror_instr;
assign Z_en = arith_instr | logical_instr; // change z flag on arithmetic or logical
assign V_en = arith_instr; // V and N flags change on arith instr only
assign N_en = arith_instr;

assign WriteReg = ALU_instr | load_instr | PCS_instr;
assign rd = instr[11:8];
assign rs = (load_half_instr) ? rd : id_instr_out[7:4];
assign rt = (opcode[3]) ? id_instr_out[11:8] : id_instr_out[3:0];
assign id_imm = id_instr_out[3:0];
assign load_half_data = {8'h00, id_instr_out[7:0]};

assign DstData =
    (load_instr & ~load_half_instr)?
        data_out
    :(PCS_instr)?
        pc_new
    :
        ALU_out
    ;

RegisterFile regfile(.clk(clk), .rst(rst), .WriteReg(WriteReg), .SrcReg1(rs),
  .SrcReg2(rt), .DstReg(rd), .SrcData1(rsData), .SrcData2(rtData),
  .DstData(DstData), .Z_in(Z_in), .V_in(V_in), .N_in(N_in), .Z_out(Z_out),
  .N_out(N_out), .V_out(V_out), .Z_en(Z_en), .V_en(V_en), .N_en(N_en));

// ID_EX stage pipeline
// flops all signals necessary for later stages
// TODO: Remove signals connected to high z by replacing with correctly sized reg
ID_EX id_ex(.clk(clk), .rst(rst), .stall_n(stall_n), .id_rs_data(rsData),
.ex_rs_data(ex_rs_data), .id_rt_data(rtData), .ex_rt_data(ex_rt_data), .id_imm(id_imm),
.ex_imm(ex_imm), .id_opcode(opcode), .ex_opcode(ex_opcode),
.id_load_half_instr(load_half_instr), .ex_load_half_instr(ex_load_half_instr),
.id_imm_instr(imm_instr), .ex_imm_instr(ex_imm_instr), .id_mem_write(id_store_instr),
.ex_mem_write(ex_mem_write), .id_load_half_data(load_half_data),
.ex_load_half_data(ex_load_half_data));


// ALU
// TODO: PROBABLY NEED TO PIPELINE FLAG SIGNALS
assign ALU_rt_data = load_half_instr ? ex_load_half_data : imm_instr ? ex_imm  : ex_rt_data;
alu ALU(.rs(ex_rs_data), .rt(ALU_rt_data), .control(ex_opcode), .rd(ALU_out), .N(N_in), .Z_flag(Z_in), .V(V_in));

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
data_mem data_memory(.data_in(rtData), .data_out(data_out), .addr(data_addr),
  .enable(1'b1), .wr(data_wr), .clk(clk), .rst(rst));

//TODO: connect signals
MEM_WB mem_wb(
    .clk(clk), .rst(rst), .stall_n(stall_n),
    .mem_WriteReg(), .mem_ALU_res(), .mem_data_mem()),
    .wb_WriteReg(), .wb_ALU_res(), .wb_data_mem()
);

// assign output pc
assign pc = pc_current;
endmodule
