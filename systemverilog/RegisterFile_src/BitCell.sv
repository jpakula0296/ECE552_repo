/* BitCell to make up registers in Register File.s
 * Made up of DFF and tristate buffers so they can be read from
 * both read data lines.
 */

module BitCell(
  input clk, rst, D, WriteEnable, ReadEnable1, ReadEnable2,
  inout Bitline1, Bitline2
  );

  wire Q; // output of DFF, tristated to Bitline1 and Bitline2

// instantiate DFF
dff DFF(.clk(clk), .rst(rst), .d(D), .wen(WriteEnable), .q(Q));

// tristate output to the bitlines, implement bypass
assign Bitline1 = (WriteEnable & ReadEnable1) ? D :
                  (ReadEnable1) ? Q : 1'bz;
assign Bitline2 = (WriteEnable & ReadEnable2) ? D :
                  (ReadEnable2) ? Q : 1'bz;

endmodule
