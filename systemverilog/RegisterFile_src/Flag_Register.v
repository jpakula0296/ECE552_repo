/* Holds flag values set by ALU operations.
 * Zero, Overflow, and Sign flags, written to by ALU, read from by
 * control module. Made up of 3 outputs.
 */

module Flag_Register(
  input clk, rst, // clk and async reset signal
  input Z_in, V_in, N_in, // inputs to each flag bit FFs
  input Z_en, V_en, N_en, // write enable signals for each FF
  output Z_out, V_out, N_out // FF outputs
  );

wire Z_flop, V_flop, N_flop;

// instantiate each FF for each bit
dff Z_FF(.clk(clk), .rst(rst), .d(Z_in), .wen(Z_en), .q(Z_flop));
dff O_FF(.clk(clk), .rst(rst), .d(V_in), .wen(V_en), .q(V_flop));
dff S_FF(.clk(clk), .rst(rst), .d(N_in), .wen(N_en), .q(N_flop));

// Do a write-before-read if necessary
assign Z_out = Z_en ? Z_in : Z_flop;
assign V_out = V_en ? V_in : V_flop;
assign N_out = N_en ? N_in : N_flop;

endmodule
