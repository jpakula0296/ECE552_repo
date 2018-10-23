module ID_EX(
  input clk,
  input rst,
  input wen,

  // EX_data
  input stall_n,
  input  [15:0]   id_rs_data,
  output [15:0]   ex_rs_data,

  input  [15:0]   id_rt_data,
  output [15:0]   ex_rt_data,

  input  [15:0]   id_imm,
  output [15:0]   ex_imm,

  input  [3:0]    id_opcode,
  output [3:0]    ex_opcode,

  input           id_load_half_instr,
  output          ex_load_half_instr,

  input           id_imm_instr,
  output          ex_imm_instr,

  // MEM_data
  input [15:0] rd_Data_in,
  input [15:0] rt_Data_in,
  input mem_write_in,

  output [15:0] rd_Data_out,
  output [15:0] rt_Data_out,
  output mem_write_out,


  // WB_data
  input WriteReg_in,
  input [15:0] ALU_res_in,
  input [15:0] data_mem_in,
  output WriteReg_out,
  output [15:0] ALU_res_out,
  output [15:0] data_mem_out
  );

// EX_data
EX_data exdata(.clk(clk), .stall_n(wen), .flush(rst), .id_rs_data(id_rs_data),
.ex_rs_data(ex_rs_data), .id_rt_data(id_rt_data), .ex_rt_data(ex_rt_data),
.id_imm(id_imm), .ex_imm(ex_imm), .id_opcode(id_opcode), .ex_opcode(ex_opcode),
.id_load_half_instr(id_load_half_instr), .ex_load_half_instr(ex_load_half_instr),
.id_imm_instr(id_imm_instr), .ex_imm_instr(ex_imm_instr));




  endmodule
