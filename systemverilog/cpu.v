module cpu(
  input clk, rst_n,
  output hlt,
  output [15:0] pc
  );

wire [3:0] opcode; // pulled from instruction

// PC Memory
wire [15:0] if_pc_current, instr, id_pc_current, if_pc_next, if_pc_increment;
wire [2:0] flags;
wire branch_taken;
wire if_hlt;

// Data Memory
wire [15:0] mem_data_out, data_addr, mem_data_in;
wire id_store_instr;
wire mem_store_instr;

// flag register/control s
wire Z_in, V_in, N_in, Z_out, V_out, N_out, Z_en, V_en, N_en;

// control signals found by ID stage
wire id_WriteReg;
wire [3:0] rs, rt, rd;
wire [15:0] rsData, rtData, DstData, SrcData2;
wire [15:0] id_instr_out, id_pc_new;
wire load_instr; // for assigning regwrite enable
wire id_data_mux;
wire imm_instr;
wire PCS_instr; // for assiging DstData
wire load_half_instr;
wire ALU_instr;
wire arith_instr; // indicates addition or subtraction
wire mem_instr; // indicates if data memory is being read from or written to
wire xor_instr;
wire sll_instr;
wire sra_instr;
wire ror_instr;
wire logical_instr;
wire reg_write_instr; // if not high 'write' to $0 since we can't anyway

// global stall signal
wire stall_n;

wire [15:0] load_half_data;

// IF/ID
wire if_id_stall_n;

// ID/EX Stage pipeline outputs
wire [3:0] ex_rs_reg;
wire [3:0] ex_rt_reg;
wire [15:0] ex_rt_data;
wire [15:0] ex_rs_data;
wire [15:0] ex_imm, id_imm, ex_load_half_data;
wire [3:0] ex_opcode;
wire [3:0] ex_rd;
wire ex_load_half_instr;
wire ex_imm_instr;
wire ex_mem_write;
wire ex_WriteReg;
wire ex_data_mux;
wire ex_memread;

// EX/MEM Stage pipeline wires
wire ex_mem_flush;
wire mem_memory_write_enable;
wire mem_register_write_enable;
wire [15:0] mem_data_addr_or_alu_result;
wire [15:0] mem_data_write_val;
wire [3:0]  mem_rd, mem_rs, mem_rt;
wire mem_data_mux;
wire ex_hlt;
wire mem_hlt;
wire [3:0] mem_opcode;

// MEM/WB Stage pipeline wires
wire mem_wb_stall_m, mem_wb_flush;
wire [15:0] wb_ALU_res;
wire [15:0] wb_data_mem;
wire [3:0]  wb_rd, wb_rs, wb_rt;
wire wb_data_mux;
wire wb_WriteReg;
wire wb_hlt;

// Forwarding Unit wires
wire Forward_EX_rs, Forward_EX_rt, Forward_MEM_EX_rs, Forward_MEM_EX_rt,
Forward_MEM_MEM_rt;
wire [15:0] ex_forward_data, mem_forward_data;
wire hazard_stall_n;

// ALU wires
wire [15:0] ALU_out; // ALU output
wire [15:0] ALU_rt_data; // data fed into rt of ALU
wire [15:0] ALU_rs_data;

// Cache wires
wire icache_miss, dcache_miss;
wire icache_wr_data_array, dcache_wr_data_array, dcache_wr_data;
wire icache_wr_tag_array, dcache_wr_tag_array;
wire [15:0] dcache_fill_data, dcache_fill_addr, dcache_miss_addr,
icache_fill_data, icache_fill_addr, icache_miss_addr;
wire [15:0] icache_addr, dcache_data_in, dcache_addr;
wire memstage_mem_instr;
wire icache_fsm_busy;
wire [15:0] pc_minus_two, pc_minus_four;
wire pc_write;
wire dcache_fsm_busy;


rca_16bit pc_minus2(.a(if_pc_current), .b(16'hFFFE), .cin(1'b0), .s(pc_minus_two),
.cout());
rca_16bit pc_minus4(.a(if_pc_current), .b(16'hFFFC), .cin(1'b0), .s(pc_minus_four),
.cout());


// multicycle memory wires
wire [15:0] mainmem_data_out;
wire [15:0] mainmem_data_in;
wire [15:0] mainmem_addr;
wire        mainmem_wr;
wire        mainmem_data_valid;

wire rst;
assign rst = ~rst_n; // keep active high/low resets straight

// Stores the current PC address, and assigns the next one. Assume that
// branches aren't taken, unless more info is received from the ID stage.
assign if_pc_next = (icache_wr_tag_array) ? pc_minus_two : (dcache_wr_tag_array) ? pc_minus_four :
branch_taken ? id_pc_new : if_hlt ? if_pc_current : if_pc_increment;
assign pc_write = (icache_wr_tag_array | dcache_wr_tag_array) ? 1'b1 : if_id_stall_n;
dff_16bit DFF0(.d(if_pc_next), .q(if_pc_current), .wen(pc_write), .clk(clk), .rst(rst));
rca_16bit if_pc_next_addr(.a(if_pc_current), .b(16'h2), .cin(1'b0), .s(if_pc_increment), .cout());

assign if_hlt = instr[15:12] == 4'b1111;


assign icache_addr = (stall_n) ? if_pc_current : icache_fill_addr;
assign memstage_mem_instr = (mem_opcode == 4'b1000) | (mem_opcode == 4'b1001);
// TODO: add interfaces here to hook up to the arbiter
cache instr_cache(
    .clk(clk),
    .rst(rst),
    .data_out(instr),
    .data_in(icache_fill_data),
    .addr(icache_addr),
    .data_wr(icache_wr_data_array),
    .miss_detected(icache_miss),
    .write_tag_array(icache_wr_tag_array),
    .memstage_mem_instr(1'b1)
);

// not sure if dcache_fill_data/icache_fill_data are redundant since always
// pulling from same memory output
assign dcache_data_in = (stall_n | dcache_wr_tag_array) ? mem_data_in : dcache_fill_data;
assign dcache_addr = (stall_n) ? dcache_fill_addr : mem_data_addr_or_alu_result;
assign dcache_wr_data = dcache_wr_data_array | mem_memory_write_enable;
cache data_cache(
    .clk(clk),
    .rst(rst),
    .data_out(mem_data_out),
    .data_in(dcache_data_in),
    .addr(dcache_addr),
    .data_wr(dcache_wr_data),
    .miss_detected(dcache_miss),
    .write_tag_array(dcache_wr_tag_array),
    .memstage_mem_instr(memstage_mem_instr)
);

/*
 * Cache Arbiter decides which cache is being serviced if we have multiple requests
 *
 * Note about the TODO's here
 *  These should be hooked up directly to their respective caches I think.
 *  Inside the caches then, we need to find a way to enable writing to the
 *  data arrays while the cache fill fsms are busy.
 */
cache_arbiter Cache_Arbiter(
    .clk(clk),
    .rst_n(rst_n),
    .stall_n(stall_n),

    .icache_fill_data(icache_fill_data),
    .icache_fill_addr(icache_fill_addr),
    .icache_write_data_array(icache_wr_data_array),
    .icache_write_tag_array(icache_wr_tag_array),
    .icache_addr(icache_addr),
    .icache_miss_detected(icache_miss),
    .icache_fsm_busy(icache_fsm_busy),

    .dcache_fill_data(dcache_fill_data),
    .dcache_fill_addr(dcache_fill_addr),
    .dcache_write_data_array(dcache_wr_data_array),
    .dcache_write_tag_array(dcache_wr_tag_array),
    .dcache_addr(dcache_addr),
    .dcache_miss_detected(dcache_miss),

    .dcache_write_data(mem_data_in),
    .dcache_write_enable(mem_memory_write_enable),
    .dcache_fsm_busy(dcache_fsm_busy),

    .mainmem_addr(mainmem_addr),
    .mainmem_write_data(mainmem_data_in),
    .mainmem_read_data(mainmem_data_out),
    .mainmem_data_valid(mainmem_data_valid)
);


// 4 cycle memory to which both caches mirror. Only communicates directly with
// the arbiter module.
memory4c main_memory(
    .data_out(mainmem_data_out),
    .data_in(mem_data_in),
    .addr(mainmem_addr),
    .enable(1'b1),
    .wr(mem_memory_write_enable),
    .data_valid(mainmem_data_valid),
    .clk(clk),
    .rst(rst)
);

// IF-ID stage pipeline - holds current instruction and pc_plus_four
// to pass to decode portion to determine control signals
// Input - instr_in from pc_memory, pc_plus_four from pc_control
// output - just flops inputs, passed to branch control logic and
// decode signals below
IF_ID if_id(.instr_in(instr), .instr_out(id_instr_out), .pc_current_in(if_pc_current),
  .pc_current_out(id_pc_current), .clk(clk), .rst(branch_taken | rst), .wen(if_id_stall_n));

// PC Control - determines next instruction fetched from PC memory
// flags based on output of flag register, flops ALU flag outputs
// branch_reg_addr acts on register RS
assign flags = {V_out, N_out, Z_out};
PC_control pc_cntrl(.pc_new(id_pc_new), .flags(flags), .instruction(id_instr_out),
  .branch_reg_addr(rsData), .pc_current(id_pc_current), .flush_out(branch_taken));


// pull opcode from output of id_instruction
// register file and later signals will be decoded based on this and passed
// along.
assign opcode = id_instr_out[15:12];


// Register File
// DstReg, SrcRegs from instr, id_WriteReg from opcode
// DstData multiplexed from ALU output and data memory
// SrcDatas fed to ALU or memory
// SrcReg1 = RS, SrcReg2 = RT
// rt is either instr[11:8] on store instrs and [3:0] otherwise
// id_WriteReg on all compute and LW instrs
// DstData is either ALU or memory depending on instruction
// rd = 0 when not write instruction, can't write to this register
// set flag enable signals based on type of instruction
assign load_instr = (opcode == 4'b1000) | (opcode == 4'b1010) | (opcode == 4'b1011);
assign PCS_instr = (opcode == 4'b1110);
assign imm_instr = (~opcode[3] & opcode[2] & ~(&opcode[1:0])) | mem_instr; // all shift and memory instructions
assign load_half_instr = load_instr & opcode[1];
assign ALU_instr = ~opcode[3];
assign arith_instr = (opcode[3:1] == 3'b000);
assign xor_instr = (opcode == 4'b0010);
assign sll_instr = (opcode == 4'b0100);
assign sra_instr = (opcode == 4'b0101);
assign ror_instr = (opcode == 4'b0110);
assign mem_instr = (opcode[3:1] == 3'b100);
assign id_store_instr = (opcode == 4'b1001); // only write on store instrs

assign logical_instr = xor_instr | sll_instr | sra_instr | ror_instr;

assign id_WriteReg = ALU_instr | load_instr | PCS_instr;
assign rd = id_instr_out[11:8];
assign rs = (load_half_instr) ? rd : id_instr_out[7:4];
assign rt = (opcode[3]) ? id_instr_out[11:8] : id_instr_out[3:0];
assign id_imm =  mem_instr ? {{11{id_instr_out[3]}}, id_instr_out[3:0], 1'b0} : id_instr_out[3:0]; // If doing a mem instr, shift left 1 and sign extend, otherwise just get raw immediate
assign load_half_data = {8'h00, id_instr_out[7:0]};
assign id_data_mux = load_instr & ~load_half_instr;

assign DstData = wb_data_mux ? wb_data_mem : wb_ALU_res;

RegisterFile regfile(.clk(clk), .rst(rst), .WriteReg(wb_WriteReg), .SrcReg1(rs),
.SrcReg2(rt), .DstReg(wb_rd), .SrcData1(rsData), .SrcData2(SrcData2),
.DstData(DstData), .Z_in(Z_in), .V_in(V_in), .N_in(N_in), .Z_out(Z_out),
.N_out(N_out), .V_out(V_out), .Z_en(Z_en), .V_en(V_en), .N_en(N_en));

// on PCS instructions, the next PC value gets passed through rtData
assign rtData = PCS_instr ? id_pc_new : SrcData2;
assign if_id_stall_n = hazard_stall_n & stall_n;

// ID_EX stage pipeline
// flops all signals necessary for later stages
ID_EX id_ex(.clk(clk), .rst(rst), .stall_n(stall_n), .id_rs_data(rsData),
.ex_rs_data(ex_rs_data), .id_rt_data(rtData), .ex_rt_data(ex_rt_data), .id_imm(id_imm),
.ex_imm(ex_imm), .id_opcode(opcode), .ex_opcode(ex_opcode),
.id_load_half_instr(load_half_instr), .ex_load_half_instr(ex_load_half_instr),
.id_imm_instr(imm_instr), .ex_imm_instr(ex_imm_instr), .id_mem_write(id_store_instr),
.ex_mem_write(ex_mem_write), .id_load_half_data(load_half_data),
.ex_load_half_data(ex_load_half_data), .ex_WriteReg(ex_WriteReg), .id_WriteReg(id_WriteReg),
.id_rd(rd), .ex_rd(ex_rd), .id_rs_reg(rs), .id_rt_reg(rt), .ex_rs_reg(ex_rs_reg),
.ex_rt_reg(ex_rt_reg), .id_data_mux(id_data_mux), .ex_data_mux(ex_data_mux),
.ex_hlt(ex_hlt), .ex_memread(ex_memread),
.if_id_stall_n(if_id_stall_n));

// ALU
// assign EX forwarding data first since that would be the most recent value
assign ALU_rt_data =
    (ex_load_half_instr) ?
        ex_load_half_data
    : (ex_imm_instr) ?
        ex_imm
    : (Forward_EX_rt) ?
        ex_forward_data
    : (Forward_MEM_EX_rt) ?
        mem_forward_data
    :
        ex_rt_data
;

assign ALU_rs_data = (Forward_EX_rs) ? ex_forward_data : (Forward_MEM_EX_rs) ?
mem_forward_data : ex_rs_data;
alu ALU(.rs(ALU_rs_data), .rt(ALU_rt_data), .control(ex_opcode), .rd(ALU_out),
.N(N_in), .Z_flag(Z_in), .V(V_in), .N_en(N_en), .Z_en(Z_en), .V_en(V_en));

// just hook up stall and flush to global stall and reset to begin with
assign ex_mem_flush = rst;
EX_MEM ex_mem(
    .clk(clk),
    .stall_n(stall_n),
    .flush(ex_mem_flush),

    .ex_data_addr_or_alu_result(ALU_out),
    .mem_data_addr_or_alu_result(mem_data_addr_or_alu_result),

    .ex_data_write_val(ex_rt_data),
    .mem_data_write_val(mem_data_write_val),

    .ex_memory_write_enable(ex_mem_write),
    .mem_memory_write_enable(mem_memory_write_enable),

    .ex_register_write_enable(ex_WriteReg),
    .mem_register_write_enable(mem_register_write_enable),

    .ex_rd(ex_rd),
    .mem_rd(mem_rd),

    .ex_rs(ex_rs_reg),
    .mem_rs(mem_rs),
    .ex_rt(ex_rt_reg),
    .mem_rt(mem_rt),

    .ex_data_mux(ex_data_mux),
    .mem_data_mux(mem_data_mux),

    .ex_hlt(ex_hlt),
    .mem_hlt(mem_hlt),

    .ex_opcode(ex_opcode),
    .mem_opcode(mem_opcode)

);

// Data Memory
// data_in from register rt or MEM-MEM forward
// mem_data_out to DstReg multiplexer,
// address from ALU (rs + imm)
// overall enable strapped high, muxing read data anyway
// write enable assigned to store opcode
// mem_data_out to DstData
assign mem_data_in = (Forward_MEM_MEM_rt) ? mem_forward_data : mem_data_write_val;
// see "cache data_cache(...);" declaration for more memory details

MEM_WB mem_wb(
.clk(clk), .rst(rst), .stall_n(stall_n),
.mem_WriteReg(mem_register_write_enable), .mem_ALU_res(mem_data_addr_or_alu_result), .mem_data_mem(mem_data_out),
.wb_WriteReg(wb_WriteReg), .wb_ALU_res(wb_ALU_res), .wb_data_mem(wb_data_mem), .mem_rd(mem_rd), .wb_rd(wb_rd),
.mem_rs(mem_rs), .wb_rs(wb_rs), .mem_rt(mem_rt), .wb_rt(wb_rt),
.mem_data_mux(mem_data_mux), .wb_data_mux(wb_data_mux), .mem_hlt(mem_hlt),
.wb_hlt(wb_hlt)
);

// Forwarding Unit
// Take rs and rt data from ID_EX and EX_MEM pipeline registers
// Outputs Forward_MEM_EX_rs, Forward_MEM_EX_rt, Forward_EX_rs, and Forward_EX_rt
// as control signals. When one of these goes high, the output on the corresponding
// data line will be the forwarded data and should be used as the input to
// memory or ALU.
Forwarding_Unit forwarding_unit(.EX_MEM_regwrite(mem_register_write_enable),
.mem_rd(mem_rd), .ex_rs(ex_rs_reg), .ex_rt(ex_rt_reg), .MEM_WB_regwrite(wb_WriteReg),
.wb_rd(wb_rd), .mem_rs(mem_rs), .mem_rt(mem_rt), .Forward_EX_rs(Forward_EX_rs),
.Forward_EX_rt(Forward_EX_rt), .Forward_MEM_EX_rs(Forward_MEM_EX_rs),
.Forward_MEM_EX_rt(Forward_MEM_EX_rt), .ex_forward_data_in(mem_data_addr_or_alu_result),
.ex_forward_data_out(ex_forward_data), .mem_forward_data_in(DstData),
.mem_forward_data_out(mem_forward_data), .EX_MEM_memwrite(mem_memory_write_enable),
.Forward_MEM_MEM_rt(Forward_MEM_MEM_rt), .ex_memread(ex_memread), .id_rs(rs),
.id_rt(rt), .id_memwrite(id_store_instr), .hazard_stall_n(hazard_stall_n));

// assign output pc and hlt
assign pc = if_pc_current;
assign hlt =  wb_hlt;

endmodule
