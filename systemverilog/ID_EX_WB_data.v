module ID_EX_WB_data(
  input clk,
  input flush,
  input stall_n,
  input WriteReg_in,
  output WriteReg_out );

dff write_reg_dff(.d(WriteReg_in), .q(WriteReg_out), .wen(stall_n), .clk(clk), .rst(flush));

endmodule
