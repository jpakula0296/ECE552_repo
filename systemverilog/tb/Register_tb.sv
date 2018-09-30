module Register_tb();

reg clk, rst, WriteReg, ReadEnable1, ReadEnable2;
reg [15:0] D;
wire [15:0] Bitline1, Bitline2;

Register register(.clk(clk), .rst(rst), .WriteReg(WriteReg), .ReadEnable1(ReadEnable1),
  .ReadEnable2(ReadEnable2), .D(D), .Bitline1(Bitline1), .Bitline2(Bitline2));

initial begin
  clk = 1'b0;
  rst = 1'b1;
  WriteReg = 1'b0;
  ReadEnable1 = 1'b0;
  ReadEnable2 = 1'b0;
  D = 16'hffff;

  @(posedge clk);
  rst = 1'b0;
  WriteReg = 1'b1;
  @(posedge clk);
  WriteReg = 1'b0;
  D = 16'h0000;
  ReadEnable1 = 1'b1;
  @(posedge clk);
  ReadEnable1 = 1'b0;
  ReadEnable2 = 1'b1;
  @(posedge clk);

  $stop();



end

always begin
  #5 clk = ~clk;
end
endmodule
