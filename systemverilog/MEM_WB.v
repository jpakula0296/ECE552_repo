module MEM_WB(
  input clk,
  input rst,
  input stall_n,

  input mem_WriteReg,
  input mem_data_mux,
  input [3:0]  mem_rd, mem_rs, mem_rt,
  input [15:0] mem_ALU_res,
  input [15:0] mem_data_mem,

  output wb_WriteReg,
  output wb_data_mux,
  output [3:0]  wb_rd, wb_rs, wb_rt,
  output [15:0] wb_ALU_res,
  output [15:0] wb_data_mem
  );

WB_data wbdata(
    .clk(clk),
    .flush(rst),
    .stall_n(stall_n),

    .WriteReg_in(mem_WriteReg),
    .ALU_res_in(mem_ALU_res),
    .data_mem_in(mem_data_mem),

    .WriteReg_out(wb_WriteReg),
    .ALU_res_out(wb_ALU_res),
    .data_mem_out(wb_data_mem)
);

dff_4bit rd_ff(
    .clk(clk),
    .rst(rst),
    .wen(stall_n),
    .d(mem_rd),
    .q(wb_rd)
);

dff_4bit rs_ff(.clk(clk), .rst(rst), .wen(stall_n), .d(mem_rs), .q(wb_rs));
dff_4bit rt_ff(.clk(clk), .rst(rst), .wen(stall_n), .d(mem_rt), .q(wb_rt));
dff data_mux_ff(
    .clk(clk),
    .rst(rst),
    .wen(stall_n),
    .d(mem_data_mux),
    .q(wb_data_mux)
);
endmodule
