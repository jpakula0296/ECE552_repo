module RegisterFile(
  input clk, rst, WriteReg,
  input [3:0] SrcReg1, SrcReg2, DstReg,
  input [15:0] DstData,
  inout [15:0] SrcData1, SrcData2
  );
