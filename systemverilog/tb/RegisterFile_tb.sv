module RegisterFile_tb();

reg clk, rst, WriteReg;
reg [3:0] SrcReg1, SrcReg2, DstReg;
reg [15:0] Data1, Data2;
wire [15:0] SrcData1, SrcData2;
reg [15:0] DstData;
reg write1, write2;

// instantiate DUT
RegisterFile regfile(.clk(clk), .rst(rst), .WriteReg(WriteReg), .SrcReg1(SrcReg1),
  .SrcReg2(SrcReg2), .DstReg(DstReg), .DstData(DstData), .SrcData1(SrcData1),
  . SrcData2(SrcData2));

// tristate SrcData
assign SrcData1 = (write1) ? Data1 : 16'hzzzz;
assign SrcData2 = (write2) ? Data2 : 16'hzzzz;


// test writes by alternating writing 0XDEAD and 0xBEEF in each register
// and make sure we can read the data on the same cycle
integer register; // register counter
initial begin
  register = 0;
  while (register < 16) begin
    write1 = 1'b0;
    write2 = 1'b0;
    clk = 1'b0;
    rst = 1'b0;
    WriteReg = 1'b0;
    Data1 = 16'h0000;
    Data2 = 16'h0000;

    #5 WriteReg = 1'b1; // turn on write
    if (register % 2 == 0)
      DstData = 16'hDEAD;
    else
      DstData = 16'hBEEF;
    // write to and read from register at the same time to test bypass
    SrcReg1 = register;
    SrcReg2 = register;
    DstReg = register;

    register = register + 1;
  end
end

always begin
  #5 clk = ~clk;
end

endmodule
