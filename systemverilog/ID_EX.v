// TODO: replace high z signals with what we actually need here


module ID_EX(
  input clk,
  input rst,
  input stall_n,

  // EX_data
  input  [15:0]   id_rs_data,
  output [15:0]   ex_rs_data,

  input  [15:0]   id_rt_data,
  output [15:0]   ex_rt_data,

  input  [15:0]   id_imm,
  output [15:0]   ex_imm,

  input  [3:0]    id_opcode,
  output [3:0]    ex_opcode,

  input           id_load_half_instr,
  input [15:0]    id_load_half_data,
  output          ex_load_half_instr,
  output [15:0]   ex_load_half_data,

  input           id_imm_instr,
  output          ex_imm_instr,

  // MEM_data
  // rt data shared with EX signal id_rt_data and ex_rt_data
  // rd data comes from ALU later on, DUMMIES here
  input id_mem_write,
  output ex_mem_write,

  // WB_data
  // ALU_result and data_mem needed before write back stage but unavailable for now
  // high z for now
  input id_WriteReg,
  output ex_WriteReg

  );

// DUM PLACEHOLDERS
wire [15:0] DUM_rd_Data_in, DUM_rd_Data_out, DUM_ALU_res_in, DUM_data_mem_in,
DUM_ALU_res_out, DUM_data_mem_out;

// EX_data
EX_data exdata(.clk(clk), .stall_n(stall_n), .flush(rst), .id_rs_data(id_rs_data),
.ex_rs_data(ex_rs_data), .id_rt_data(id_rt_data), .ex_rt_data(ex_rt_data),
.id_imm(id_imm), .ex_imm(ex_imm), .id_opcode(id_opcode), .ex_opcode(ex_opcode),
.id_load_half_instr(id_load_half_instr), .ex_load_half_instr(ex_load_half_instr),
.id_imm_instr(id_imm_instr), .ex_imm_instr(ex_imm_instr),
.id_load_half_data(id_load_half_data), .ex_load_half_data(ex_load_half_data));

// MEM_data
MEM_data memdata(.clk(clk), .stall_n(stall_n), .flush(rst), .rd_Data_in(DUM_rd_Data_in),
.rt_Data_in(id_rt_data), .mem_write_in(id_mem_write), .rd_Data_out(DUM_rd_Data_out),
.rt_Data_out(ex_rt_data), .mem_write_out(ex_mem_write));

// WB_data
WB_data wbdata(.clk(clk), .flush(rst), .stall_n(stall_n), .WriteReg_in(id_WriteReg),
.ALU_res_in(DUM_ALU_res_in), .data_mem_in(DUM_data_mem_in), .WriteReg_out(ex_WriteReg),
.ALU_res_out(DUM_ALU_res_out), .data_mem_out(DUM_data_mem_out));




  endmodule
