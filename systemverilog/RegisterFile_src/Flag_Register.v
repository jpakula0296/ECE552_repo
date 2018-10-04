/* Holds flag values set by ALU operations.
 * Zero, Overflow, and Sign flags, written to by ALU, read from by
 * control module. Made up of 3 outputs.
 */

module Flag_Register(
  input clk, rst, // clk and async reset signal
  input Z_in, O_in, N_in, // inputs to each flag bit FFs
  input Z_en, O_en, N_en, // write enable signals for each FF
  output Z_out, O_out, N_out // FF outputs
  );

// instantiate each FF for each bit
dff Z_FF(.clk(clk), .rst(rst), .d(Z_in), .wen(Z_en), .q(Z_out));
dff O_FF(.clk(clk), .rst(rst), .d(O_in), .wen(O_en), .q(O_out));
dff S_FF(.clk(clk), .rst(rst), .d(N_in), .wen(N_en), .q(N_out));

endmodule
