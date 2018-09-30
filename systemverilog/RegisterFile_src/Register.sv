/* Register for Register_File, made up of 16 BitCells.
 */
module Register(
  input clk, rst,
  input WriteReg, ReadEnable1, ReadEnable2,
  inout [15:0] Bitline1, Bitline2
  );

// Need to be able to write to Bitlines same cycle this register is written
wire [15:0] Data;
assign BitLine1 = (ReadEnable1) ? Data : 1'bz;
assign BitLine2 = (ReadEnable2) ? Data : 1'bz;

// 16 Bit Cells, internal write-before-read bypassing
BitCell bitcell0 (.clk(clk), .rst(rst), .D(Data[0]), .WriteEnable(WriteReg), .ReadEnable1(ReadEnable1), .ReadEnable2(ReadEnable2));
BitCell bitcell1 (.clk(clk), .rst(rst), .D(Data[1]), .WriteEnable(WriteReg), .ReadEnable1(ReadEnable1), .ReadEnable2(ReadEnable2));
BitCell bitcell2 (.clk(clk), .rst(rst), .D(Data[2]), .WriteEnable(WriteReg), .ReadEnable1(ReadEnable1), .ReadEnable2(ReadEnable2));
BitCell bitcell3 (.clk(clk), .rst(rst), .D(Data[3]), .WriteEnable(WriteReg), .ReadEnable1(ReadEnable1), .ReadEnable2(ReadEnable2));
BitCell bitcell4 (.clk(clk), .rst(rst), .D(Data[4]), .WriteEnable(WriteReg), .ReadEnable1(ReadEnable1), .ReadEnable2(ReadEnable2));
BitCell bitcell5 (.clk(clk), .rst(rst), .D(Data[5]), .WriteEnable(WriteReg), .ReadEnable1(ReadEnable1), .ReadEnable2(ReadEnable2));
BitCell bitcell6 (.clk(clk), .rst(rst), .D(Data[6]), .WriteEnable(WriteReg), .ReadEnable1(ReadEnable1), .ReadEnable2(ReadEnable2));
BitCell bitcell7 (.clk(clk), .rst(rst), .D(Data[7]), .WriteEnable(WriteReg), .ReadEnable1(ReadEnable1), .ReadEnable2(ReadEnable2));
BitCell bitcell8 (.clk(clk), .rst(rst), .D(Data[8]), .WriteEnable(WriteReg), .ReadEnable1(ReadEnable1), .ReadEnable2(ReadEnable2));
BitCell bitcell9 (.clk(clk), .rst(rst), .D(Data[9]), .WriteEnable(WriteReg), .ReadEnable1(ReadEnable1), .ReadEnable2(ReadEnable2));
BitCell bitcell10 (.clk(clk), .rst(rst), .D(Data[10]), .WriteEnable(WriteReg), .ReadEnable1(ReadEnable1), .ReadEnable2(ReadEnable2));
BitCell bitcell11 (.clk(clk), .rst(rst), .D(Data[11]), .WriteEnable(WriteReg), .ReadEnable1(ReadEnable1), .ReadEnable2(ReadEnable2));
BitCell bitcell12 (.clk(clk), .rst(rst), .D(Data[12]), .WriteEnable(WriteReg), .ReadEnable1(ReadEnable1), .ReadEnable2(ReadEnable2));
BitCell bitcell13 (.clk(clk), .rst(rst), .D(Data[13]), .WriteEnable(WriteReg), .ReadEnable1(ReadEnable1), .ReadEnable2(ReadEnable2));
BitCell bitcell14 (.clk(clk), .rst(rst), .D(Data[14]), .WriteEnable(WriteReg), .ReadEnable1(ReadEnable1), .ReadEnable2(ReadEnable2));
BitCell bitcell15 (.clk(clk), .rst(rst), .D(Data[15]), .WriteEnable(WriteReg), .ReadEnable1(ReadEnable1), .ReadEnable2(ReadEnable2));



endmodule
