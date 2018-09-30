module Register(
  input clk, rst,
  input WriteReg, ReadEnable1, ReadEnable2,
  inout [15:0] Bitline1, Bitline2
  );
  
