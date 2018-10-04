module RegisterFile_tb();

reg clk, rst, WriteReg;
reg [3:0] SrcReg1, SrcReg2, DstReg;
reg [15:0] Data1, Data2;
reg Z_in, O_in, N_in, Z_en, O_en, N_en;
wire Z_out, O_out, N_out;
wire [15:0] SrcData1, SrcData2;
reg [15:0] DstData;
reg write1, write2;

// instantiate DUT
RegisterFile regfile(.clk(clk), .rst(rst), .WriteReg(WriteReg), .SrcReg1(SrcReg1),
  .SrcReg2(SrcReg2), .DstReg(DstReg), .DstData(DstData), .SrcData1(SrcData1),
  .SrcData2(SrcData2), .Z_in(Z_in), .Z_en(Z_en), .Z_out(Z_out),
  .O_in(O_in), .O_en(O_en), .O_out(O_out), .N_in(N_in), .N_en(N_en), .N_out(N_out));

// tristate SrcData
assign SrcData1 = (write1) ? Data1 : 16'hzzzz;
assign SrcData2 = (write2) ? Data2 : 16'hzzzz;


// test writes by alternating writing 0XDEAD and 0xBEEF in each register
// and make sure we can read the data on the same cycle
integer register; // register counter
initial begin
  clk = 1'b0;
  register = 1;
  Z_in = 0;
  O_in = 0;
  N_in = 0;
  Z_en = 0;
  O_en = 0;
  N_en = 0;
  while (register < 16) begin
    write1 = 1'b0;
    write2 = 1'b0;
    rst = 1'b1;
    WriteReg = 1'b0;
    Data1 = 16'h0000;
    Data2 = 16'h0000;
    if (register % 2 == 0)
      DstData = 16'hdead;
    else
      DstData = 16'hbeef;
    // write to and read from register at the same time to test bypass
    SrcReg1 = register;
    SrcReg2 = register;
    DstReg = register;

    @(posedge clk);
    WriteReg = 1'b1; // turn on write
    rst = 1'b0; // turn off reset
    Z_en = 1;
    O_en = 1;
    N_en = 1;

    register = register + 1;
    @(posedge clk);
  end
  $stop();
end

always begin
  #5 clk = ~clk;
end

endmodule
