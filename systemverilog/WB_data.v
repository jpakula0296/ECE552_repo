module WB_data(
  input WriteReg_in,
  input [15:0] ALU_res_in,
  input [15:0] data_mem_in,
  output WriteReg_out,
  output [15:0] ALU_res_out,
  output [15:0] data_mem_out
  );
