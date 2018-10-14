module cpu_tb();

reg clk, rst_n;
wire hlt;
wire [15:0] pc;

// Instantiate DUT
cpu iDUT(.clk(clk), .rst_n(rst_n), .hlt(hlt), .pc(pc));


endmodule
