module BitCell_tb();

reg clk, rst, D, WriteEnable, ReadEnable1, ReadEnable2;
wire Bitline1, Bitline2;

BitCell bitcell(.clk(clk), .rst(rst), .D(D), .WriteEnable(WriteEnable),
  .ReadEnable1(ReadEnable1), .ReadEnable2(ReadEnable2), .Bitline1(Bitline1),
  .Bitline2(Bitline2));


initial begin
  clk = 1'b0;
  rst = 1'b1;
  WriteEnable = 1'b0;
  ReadEnable1 = 1'b0;
  ReadEnable2 = 1'b0;
  D = 1;


  @(posedge clk) begin
    rst = 1'b0;
    WriteEnable = 1'b1;
  end

  @(posedge clk) begin
    WriteEnable = 1'b0;
    ReadEnable1 = 1'b1;
    $display("Bitline 1: %b", Bitline1);
  end

  @(posedge clk) begin
    rst = 1'b1;
    $display("Bitline 1: %b", Bitline1);
  end

  @(posedge clk) begin
    rst = 1'b0;
    $display("Bitline 1: %b", Bitline1);
  end

  WriteEnable = 1;

  @(posedge clk) begin
    $display("Bitline 1: %b", Bitline1);
  end

  //tests bypass
  $display("Bitline 1: %b bypassing", Bitline1);

  @(posedge clk) begin
    $display("Bitline 1: %b", Bitline1);
  end

  $finish();


end



always begin

  #5 clk = ~clk;
end


endmodule
