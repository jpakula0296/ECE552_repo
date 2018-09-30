/* Register for Register_File, made up of 16 BitCells.
 */
module Register(
  input clk, rst,
  input WriteReg, ReadEnable1, ReadEnable2,
  input [15:0] D,
  inout [15:0] Bitline1, Bitline2
  );

// Need to be able to write to Bitlines same cycle this register is written
assign Bitline1 = (ReadEnable1) ? D : 16'bz;
assign Bitline2 = (ReadEnable2) ? D : 16'bz;


// 16 Bit Cells, internal write-before-read bypassing
BitCell bitcell0 (.clk(clk), .rst(rst), .D(D[0]), .WriteEnable(WriteReg),
.ReadEnable1(ReadEnable1), .ReadEnable2(ReadEnable2), .Bitline1(D[0]), .Bitline2(D[0]));
BitCell bitcell1 (.clk(clk), .rst(rst), .D(D[1]), .WriteEnable(WriteReg),
.ReadEnable1(ReadEnable1), .ReadEnable2(ReadEnable2), .Bitline1(D[1]), .Bitline2(D[1]));
BitCell bitcell2 (.clk(clk), .rst(rst), .D(D[2]), .WriteEnable(WriteReg),
.ReadEnable1(ReadEnable1), .ReadEnable2(ReadEnable2), .Bitline1(D[2]), .Bitline2(D[2]));
BitCell bitcell3 (.clk(clk), .rst(rst), .D(D[3]), .WriteEnable(WriteReg),
.ReadEnable1(ReadEnable1), .ReadEnable2(ReadEnable2), .Bitline1(D[3]), .Bitline2(D[3]));
BitCell bitcell4 (.clk(clk), .rst(rst), .D(D[4]), .WriteEnable(WriteReg),
.ReadEnable1(ReadEnable1), .ReadEnable2(ReadEnable2), .Bitline1(D[4]), .Bitline2(D[4]));
BitCell bitcell5 (.clk(clk), .rst(rst), .D(D[5]), .WriteEnable(WriteReg),
.ReadEnable1(ReadEnable1), .ReadEnable2(ReadEnable2), .Bitline1(D[5]), .Bitline2(D[5]));
BitCell bitcell6 (.clk(clk), .rst(rst), .D(D[6]), .WriteEnable(WriteReg),
.ReadEnable1(ReadEnable1), .ReadEnable2(ReadEnable2), .Bitline1(D[6]), .Bitline2(D[6]));
BitCell bitcell7 (.clk(clk), .rst(rst), .D(D[7]), .WriteEnable(WriteReg),
.ReadEnable1(ReadEnable1), .ReadEnable2(ReadEnable2), .Bitline1(D[7]), .Bitline2(D[7]));
BitCell bitcell8 (.clk(clk), .rst(rst), .D(D[8]), .WriteEnable(WriteReg),
 .ReadEnable1(ReadEnable1), .ReadEnable2(ReadEnable2), .Bitline1(D[8]), .Bitline2(D[8]));
BitCell bitcell9 (.clk(clk), .rst(rst), .D(D[9]), .WriteEnable(WriteReg),
.ReadEnable1(ReadEnable1), .ReadEnable2(ReadEnable2), .Bitline1(D[9]), .Bitline2(D[9]));
BitCell bitcell10 (.clk(clk), .rst(rst), .D(D[10]), .WriteEnable(WriteReg),
.ReadEnable1(ReadEnable1), .ReadEnable2(ReadEnable2), .Bitline1(D[10]), .Bitline2(D[10]));
BitCell bitcell11 (.clk(clk), .rst(rst), .D(D[11]), .WriteEnable(WriteReg),
.ReadEnable1(ReadEnable1), .ReadEnable2(ReadEnable2), .Bitline1(D[11]), .Bitline2(D[11]));
BitCell bitcell12 (.clk(clk), .rst(rst), .D(D[12]), .WriteEnable(WriteReg),
.ReadEnable1(ReadEnable1), .ReadEnable2(ReadEnable2), .Bitline1(D[12]), .Bitline2(D[12]));
BitCell bitcell13 (.clk(clk), .rst(rst), .D(D[13]), .WriteEnable(WriteReg),
.ReadEnable1(ReadEnable1), .ReadEnable2(ReadEnable2), .Bitline1(D[13]), .Bitline2(D[13]));
BitCell bitcell14 (.clk(clk), .rst(rst), .D(D[14]), .WriteEnable(WriteReg),
.ReadEnable1(ReadEnable1), .ReadEnable2(ReadEnable2), .Bitline1(D[14]), .Bitline2(D[14]));
BitCell bitcell15 (.clk(clk), .rst(rst), .D(D[15]), .WriteEnable(WriteReg),
.ReadEnable1(ReadEnable1), .ReadEnable2(ReadEnable2), .Bitline1(D[15]), .Bitline2(D[15]));



endmodule
