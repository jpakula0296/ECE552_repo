module PC (
    output [15:0] pc_addr,
    input [15:0] pc_data_in,
    input clk,
    input hlt,
    input rst);

  wire [15:0] plus_four;


// State Flip-flop
// feeds program memory address, changes every posedge clk
// input calculated from PC+4 or branch instruction
// write enable not needed, keep high
dff DFF0(.q(pc_addr), .d(pc_data_in), .wen(1'b1), .clk(clk), .rst(rst));

// TODO: Replace this with Add 4 module
assign plus_four = pc_addr + 4;



endmodule
