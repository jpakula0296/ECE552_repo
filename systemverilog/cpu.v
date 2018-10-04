module cpu(
  input clk, rst_n,
  output hlt,
  output [15:0] pc
  );

  assign rst = rst_n; // keep active high/low resets straight

// Instantiate Register File:
RegisterFile regfile(.clk(clk), .rst(rst), )
