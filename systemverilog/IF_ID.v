module IF_ID(
    input clk,
    input rst,
    input wen,
    input [15:0] instr_in,
    input [15:0] pc_current_in,
    output [15:0] instr_out,
    output [15:0] pc_current_out

    );

// instruction flip flop
dff_16bit dff0 (.d(instr_in), .q(instr_out), .wen(wen), .clk(clk), .rst(rst));
// pc flip flop
dff_16bit dff1 (.d(pc_current_in), .q(pc_current_out), .wen(wen), .clk(clk), .rst(rst));



endmodule
