module WB_data(
  input clk,
  input flush,
  input stall_n,
  input WriteReg_in,
  input [15:0] ALU_res_in,
  input [15:0] data_mem_in,
  output WriteReg_out,
  output [15:0] ALU_res_out,
  output [15:0] data_mem_out
  );

dff write_reg_dff(.d(WriteReg_in), .q(WriteReg_out), .wen(stall_n), .clk(clk), .rst(stall_n));
dff_16bit ALU_res_dff(.d(ALU_res_in), .q(ALU_res_out), .wen(stall_n), .clk(clk), .rst(stall_n));
dff_16bit data_mem_dff(.d(data_mem_in), .q(data_mem_out), .wen(stall_n), .clk(clk), .rst(stall_n));


endmodule
