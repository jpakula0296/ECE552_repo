module cpu(
  input clk, rst_n,
  output hlt,
  output [15:0] pc
  );

  // PC memory
  wire [15:0] pc_data_in, pc_data_out, pc_addr;
  wire pc_enable, pc_wr;

  // Register File wires
  wire WriteReg;
  wire Z_in, O_in, N_in, Z_en, O_en, N_en, Z_out, O_out, N_out;
  wire [3:0] SrcReg1, SrcReg2, DstReg;
  wire [15:0] SrcData1, SrcData2, DstData;

  assign rst = rst_n; // keep active high/low resets straight

// Instantiate Register File:
RegisterFile regfile(.clk(clk), .rst(rst), .WriteReg(WriteReg), .SrcReg1(SrcReg1),
  .SrcReg2(SrcReg2), .DstReg(DstReg), .SrcData1(SrcData1), .SrcData2(SrcData2),
  .DstData(DstData));

memory1c prog_mem(.data_in(pc_data_in), .data_out(pc_data_out), .addr(pc_addr),
  .enable(pc_enable), .wr(pc_wr));

endmodule
