module BitCell_tb();

reg clk, rst, D, WriteEnable, ReadEnable1, ReadEnable2;
wire Bitline1, Bitline2;
integer i;

BitCell bitcell(.clk(clk), .rst(rst), .D(D), .WriteEnable(WriteEnable),
  .ReadEnable1(ReadEnable1), .ReadEnable2(ReadEnable2), .Bitline1(Bitline1),
  .Bitline2(Bitline2));


initial begin
    clk = 1'b1;
    rst = 1'b1;
    WriteEnable = 1'b0;
    ReadEnable1 = 1'b0;
    ReadEnable2 = 1'b0;
    D = 1;

    @(negedge clk);
    rst=1'b0;
    #1; $display("WriteEnable=%b ReadEnable1=%b ReadEnable2=%b rst=%b D=%b time=%d", WriteEnable,ReadEnable1,ReadEnable2, rst, D, $time);
    @(posedge clk);
    #1; $display("Bitline1=%b Bitline2=%b time=%d\n", Bitline1, Bitline2, $time);

    @(negedge clk);
    WriteEnable = 1'b1;
    ReadEnable1 = 1'b1;
    #1; $display("WriteEnable=%b ReadEnable1=%b ReadEnable2=%b rst=%b D=%b time=%d", WriteEnable,ReadEnable1,ReadEnable2, rst, D, $time);
    @(posedge clk);
    #1; $display("Bitline1=%b Bitline2=%b time=%d\n", Bitline1, Bitline2, $time);

    @(negedge clk);
    WriteEnable = 1'b0;
    rst=1'b1;
    #1; $display("WriteEnable=%b ReadEnable1=%b ReadEnable2=%b rst=%b D=%b time=%d", WriteEnable,ReadEnable1,ReadEnable2, rst, D, $time);
    @(posedge clk);
    #1; $display("Bitline1=%b Bitline2=%b time=%d\n", Bitline1, Bitline2, $time);

    @(negedge clk);
    ReadEnable2 = 1'b1;
    ReadEnable1 = 1'b0;
    #1; $display("WriteEnable=%b ReadEnable1=%b ReadEnable2=%b rst=%b D=%b time=%d", WriteEnable,ReadEnable1,ReadEnable2, rst, D, $time);
    @(posedge clk);
    #1; $display("Bitline1=%b Bitline2=%b time=%d\n", Bitline1, Bitline2, $time);

    @(negedge clk);
    WriteEnable = 1'b1;
    #1; $display("WriteEnable=%b ReadEnable1=%b ReadEnable2=%b rst=%b D=%b time=%d", WriteEnable,ReadEnable1,ReadEnable2, rst, D, $time);
    @(posedge clk);
    #1; $display("Bitline1=%b Bitline2=%b time=%d\n", Bitline1, Bitline2, $time);

    @(negedge clk);
    WriteEnable = 1'b0;
    D = 1'b0;
    #1; $display("WriteEnable=%b ReadEnable1=%b ReadEnable2=%b rst=%b D=%b time=%d", WriteEnable,ReadEnable1,ReadEnable2, rst, D, $time);
    @(posedge clk);
    #1; $display("Bitline1=%b Bitline2=%b time=%d\n", Bitline1, Bitline2, $time);

    @(negedge clk);
    WriteEnable = 1'b1;
    #1; $display("WriteEnable=%b ReadEnable1=%b ReadEnable2=%b rst=%b D=%b time=%d", WriteEnable,ReadEnable1,ReadEnable2, rst, D, $time);
    @(posedge clk);
    #1; $display("Bitline1=%b Bitline2=%b time=%d\n", Bitline1, Bitline2, $time);


    $finish();
end



always begin
  #5 clk = ~clk;
end


endmodule
