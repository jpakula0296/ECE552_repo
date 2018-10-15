/* 16 registers each holding 16 bits of data
 * ACTIVE HIGH RESET
 * two read ports, one right. possible to write and read from written port same
 * cycle. Three bit Flag Register with zero, overflow, and negative flags
 * Register 0 is hardwired to 0x0000 and cannot be written to.
 */

module RegisterFile(
  input clk, rst, WriteReg,
  input [3:0] SrcReg1, SrcReg2, DstReg,
  input [15:0] DstData,
  output [15:0] SrcData1, SrcData2,

  // flag register inputs/outputs
  input Z_in, V_in, N_in, // inputs to each flag bit FFs
  output Z_out, V_out, N_out // flag FF outputs

  );

  // Read/Write Enable signals derived from respective Decoders
  wire [15:0] ReadEnable1;
  wire [15:0] ReadEnable2;
  wire [15:0] WriteEnable;


// Decoders for Read and Write Enable signals
ReadDecoder_4_16 read_decode1(.RegId(SrcReg1), .Wordline(ReadEnable1));
ReadDecoder_4_16 read_decode2(.RegId(SrcReg2), .Wordline(ReadEnable2));
WriteDecoder_4_16 write_decode(.RegId(DstReg), .WriteReg(WriteReg), .Wordline(WriteEnable));

// Instantiate 16 registers assigning enable signals
// register $0 is hardwired to 0x0000: WriteReg and data input strapped low so
// not present in instantiation
Register_zero reg0(.clk(clk), .rst(rst), .ReadEnable1(ReadEnable1[0]),
.ReadEnable2(ReadEnable2[0]), .Bitline1(SrcData1), .Bitline2(SrcData2));
Register reg1(.clk(clk), .rst(rst), .WriteReg(WriteEnable[1]),
.ReadEnable1(ReadEnable1[1]), .ReadEnable2(ReadEnable2[1]), .D(DstData), .Bitline1(SrcData1),
.Bitline2(SrcData2));
Register reg2(.clk(clk), .rst(rst), .WriteReg(WriteEnable[2]),
.ReadEnable1(ReadEnable1[2]), .ReadEnable2(ReadEnable2[2]), .D(DstData), .Bitline1(SrcData1),
.Bitline2(SrcData2));
Register reg3(.clk(clk), .rst(rst), .WriteReg(WriteEnable[3]),
.ReadEnable1(ReadEnable1[3]), .ReadEnable2(ReadEnable2[3]), .D(DstData), .Bitline1(SrcData1),
.Bitline2(SrcData2));
Register reg4(.clk(clk), .rst(rst), .WriteReg(WriteEnable[4]),
.ReadEnable1(ReadEnable1[4]), .ReadEnable2(ReadEnable2[4]), .D(DstData), .Bitline1(SrcData1),
.Bitline2(SrcData2));
Register reg5(.clk(clk), .rst(rst), .WriteReg(WriteEnable[5]),
.ReadEnable1(ReadEnable1[5]), .ReadEnable2(ReadEnable2[5]), .D(DstData), .Bitline1(SrcData1),
.Bitline2(SrcData2));
Register reg6(.clk(clk), .rst(rst), .WriteReg(WriteEnable[6]),
.ReadEnable1(ReadEnable1[6]), .ReadEnable2(ReadEnable2[6]), .D(DstData), .Bitline1(SrcData1),
.Bitline2(SrcData2));
Register reg7(.clk(clk), .rst(rst), .WriteReg(WriteEnable[7]),
.ReadEnable1(ReadEnable1[7]), .ReadEnable2(ReadEnable2[7]), .D(DstData), .Bitline1(SrcData1),
.Bitline2(SrcData2));
Register reg8(.clk(clk), .rst(rst), .WriteReg(WriteEnable[8]),
.ReadEnable1(ReadEnable1[8]), .ReadEnable2(ReadEnable2[8]), .D(DstData), .Bitline1(SrcData1),
.Bitline2(SrcData2));
Register reg9(.clk(clk), .rst(rst), .WriteReg(WriteEnable[9]),
.ReadEnable1(ReadEnable1[9]), .ReadEnable2(ReadEnable2[9]), .D(DstData), .Bitline1(SrcData1),
.Bitline2(SrcData2));
Register reg10(.clk(clk), .rst(rst), .WriteReg(WriteEnable[10]),
.ReadEnable1(ReadEnable1[10]), .ReadEnable2(ReadEnable2[10]), .D(DstData), .Bitline1(SrcData1),
.Bitline2(SrcData2));
Register reg11(.clk(clk), .rst(rst), .WriteReg(WriteEnable[11]),
.ReadEnable1(ReadEnable1[11]), .ReadEnable2(ReadEnable2[11]), .D(DstData), .Bitline1(SrcData1),
.Bitline2(SrcData2));
Register reg12(.clk(clk), .rst(rst), .WriteReg(WriteEnable[12]),
.ReadEnable1(ReadEnable1[12]), .ReadEnable2(ReadEnable2[12]), .D(DstData), .Bitline1(SrcData1),
.Bitline2(SrcData2));
Register reg13(.clk(clk), .rst(rst), .WriteReg(WriteEnable[13]),
.ReadEnable1(ReadEnable1[13]), .ReadEnable2(ReadEnable2[13]), .D(DstData), .Bitline1(SrcData1),
.Bitline2(SrcData2));
Register reg14(.clk(clk), .rst(rst), .WriteReg(WriteEnable[14]),
.ReadEnable1(ReadEnable1[14]), .ReadEnable2(ReadEnable2[14]), .D(DstData), .Bitline1(SrcData1),
.Bitline2(SrcData2));
Register reg15(.clk(clk), .rst(rst), .WriteReg(WriteEnable[15]),
.ReadEnable1(ReadEnable1[15]), .ReadEnable2(ReadEnable2[15]), .D(DstData), .Bitline1(SrcData1),
.Bitline2(SrcData2));

// Flag Register
Flag_Register flag_reg(.clk(clk), .rst(rst), .Z_in(Z_in), .Z_en(1'b1), .Z_out(Z_out),
  .V_in(V_in), .O_en(1'b1), .V_out(V_out), .N_in(N_in), .N_en(1'b1), .N_out(N_out));


endmodule
