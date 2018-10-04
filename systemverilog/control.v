module control(
  input clk, rst_n,
  input [3:0] opcode,

  // chooses which part of instruction interpreted as writereg
  output Write_src_sel; 
  );
