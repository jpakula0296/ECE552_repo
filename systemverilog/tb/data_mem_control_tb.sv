module data_mem_control_tb();

reg clk, rst, wr;
reg [15:0] rsData, rtData;
reg [3:0] offset;
wire [15:0] target_addr;
wire[15:0] data_out;

data_mem_control iDUT(.rsData(rsData), .rtData(rtData), .offset(offset),
  .target_addr(target_addr));

data_mem data_memory(.data_out(data_out), .data_in(rtData), .addr(target_addr),
  .enable(1'b1), .wr(wr), .clk(clk), .rst(rst));

initial begin
  rsData = 0;
  rtData = 16'hBEEF;
  offset = 0;
  clk = 0;
  rst = 1;
  wr = 0;
  // try a write operation at address 0 first
  repeat(2) @(posedge clk);

  wr = 1;
  rst = 0;
  @(posedge clk);

  wr = 0;
  rtData = 16'hDEAD;
  rsData = 0;
  offset = 1;
  @(posedge clk);
  wr = 1;
  @(posedge clk);
  wr = 0;
  @(posedge clk);

$stop();
end

always begin
  #5 clk = ~clk;
end
endmodule
