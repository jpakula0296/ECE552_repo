module ID_EX_MEM_data(
  input [15:0] rt_Data_in,
  input mem_write_in,

  output [15:0] rt_Data_out,
  output mem_write_out,

  input clk,
  input stall_n,
  input flush );

dff_16bit rt_Data(
    .d(rt_Data_in),
    .q(rt_Data_out),
    .wen(stall_n),
    .clk(clk),
    .rst(flush)
);

dff mem_write(
    .d(mem_write_in),
    .q(mem_write_out),
    .wen(stall_n),
    .clk(clk),
    .rst(flush)
);

endmodule
