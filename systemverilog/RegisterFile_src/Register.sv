/* Register for Register_File, made up of 16 BitCells.
 */
module Register(
  input clk, rst, load_half_instr,
  input WriteReg, ReadEnable1, ReadEnable2,
  input [15:0] D,
  output [15:0] Bitline1, Bitline2
  );


// 16 Bit Cells, internal write-before-read bypassing
BitCell bitcell0 (.clk(clk), .rst(rst), .D(D[0]), .WriteEnable(WriteReg), .load_half_instr(load_half_instr),
.ReadEnable1(ReadEnable1), .ReadEnable2(ReadEnable2), .Bitline1(Bitline1[0]), .Bitline2(Bitline2[0]));
BitCell bitcell1 (.clk(clk), .rst(rst), .D(D[1]), .WriteEnable(WriteReg), .load_half_instr(load_half_instr),
.ReadEnable1(ReadEnable1), .ReadEnable2(ReadEnable2), .Bitline1(Bitline1[1]), .Bitline2(Bitline2[1]));
BitCell bitcell2 (.clk(clk), .rst(rst), .D(D[2]), .WriteEnable(WriteReg), .load_half_instr(load_half_instr),
.ReadEnable1(ReadEnable1), .ReadEnable2(ReadEnable2), .Bitline1(Bitline1[2]), .Bitline2(Bitline2[2]));
BitCell bitcell3 (.clk(clk), .rst(rst), .D(D[3]), .WriteEnable(WriteReg), .load_half_instr(load_half_instr),
.ReadEnable1(ReadEnable1), .ReadEnable2(ReadEnable2), .Bitline1(Bitline1[3]), .Bitline2(Bitline2[3]));
BitCell bitcell4 (.clk(clk), .rst(rst), .D(D[4]), .WriteEnable(WriteReg), .load_half_instr(load_half_instr),
.ReadEnable1(ReadEnable1), .ReadEnable2(ReadEnable2), .Bitline1(Bitline1[4]), .Bitline2(Bitline2[4]));
BitCell bitcell5 (.clk(clk), .rst(rst), .D(D[5]), .WriteEnable(WriteReg), .load_half_instr(load_half_instr),
.ReadEnable1(ReadEnable1), .ReadEnable2(ReadEnable2), .Bitline1(Bitline1[5]), .Bitline2(Bitline2[5]));
BitCell bitcell6 (.clk(clk), .rst(rst), .D(D[6]), .WriteEnable(WriteReg), .load_half_instr(load_half_instr),
.ReadEnable1(ReadEnable1), .ReadEnable2(ReadEnable2), .Bitline1(Bitline1[6]), .Bitline2(Bitline2[6]));
BitCell bitcell7 (.clk(clk), .rst(rst), .D(D[7]), .WriteEnable(WriteReg), .load_half_instr(load_half_instr),
.ReadEnable1(ReadEnable1), .ReadEnable2(ReadEnable2), .Bitline1(Bitline1[7]), .Bitline2(Bitline2[7]));
BitCell bitcell8 (.clk(clk), .rst(rst), .D(D[8]), .WriteEnable(WriteReg), .load_half_instr(load_half_instr),
 .ReadEnable1(ReadEnable1), .ReadEnable2(ReadEnable2), .Bitline1(Bitline1[8]), .Bitline2(Bitline2[8]));
BitCell bitcell9 (.clk(clk), .rst(rst), .D(D[9]), .WriteEnable(WriteReg), .load_half_instr(load_half_instr),
.ReadEnable1(ReadEnable1), .ReadEnable2(ReadEnable2), .Bitline1(Bitline1[9]), .Bitline2(Bitline2[9]));
BitCell bitcell10 (.clk(clk), .rst(rst), .D(D[10]), .WriteEnable(WriteReg), .load_half_instr(load_half_instr),
.ReadEnable1(ReadEnable1), .ReadEnable2(ReadEnable2), .Bitline1(Bitline1[10]), .Bitline2(Bitline2[10]));
BitCell bitcell11 (.clk(clk), .rst(rst), .D(D[11]), .WriteEnable(WriteReg), .load_half_instr(load_half_instr),
.ReadEnable1(ReadEnable1), .ReadEnable2(ReadEnable2), .Bitline1(Bitline1[11]), .Bitline2(Bitline2[11]));
BitCell bitcell12 (.clk(clk), .rst(rst), .D(D[12]), .WriteEnable(WriteReg), .load_half_instr(load_half_instr),
.ReadEnable1(ReadEnable1), .ReadEnable2(ReadEnable2), .Bitline1(Bitline1[12]), .Bitline2(Bitline2[12]));
BitCell bitcell13 (.clk(clk), .rst(rst), .D(D[13]), .WriteEnable(WriteReg), .load_half_instr(load_half_instr),
.ReadEnable1(ReadEnable1), .ReadEnable2(ReadEnable2), .Bitline1(Bitline1[13]), .Bitline2(Bitline2[13]));
BitCell bitcell14 (.clk(clk), .rst(rst), .D(D[14]), .WriteEnable(WriteReg), .load_half_instr(load_half_instr),
.ReadEnable1(ReadEnable1), .ReadEnable2(ReadEnable2), .Bitline1(Bitline1[14]), .Bitline2(Bitline2[14]));
BitCell bitcell15 (.clk(clk), .rst(rst), .D(D[15]), .WriteEnable(WriteReg), .load_half_instr(load_half_instr),
.ReadEnable1(ReadEnable1), .ReadEnable2(ReadEnable2), .Bitline1(Bitline1[15]), .Bitline2(Bitline2[15]));



endmodule
