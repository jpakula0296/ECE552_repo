module IF_ID(
    input clk,
    input rst,
    input wen,
    input [15:0] instr_in,
    input [15:0] pc_new_in,
    output [15:0] instr_out,
    output [15:0] pc_new_out,
    output id_memwrite

    );

// instruction flip flop
dff_16bit dff0 (.d(instr_in), .q(instr_out), .wen(wen), .clk(clk), .rst(rst));
// pc flip flop
dff_16bit dff1 (.d(pc_new_in), .q(pc_new_out), .wen(wen), .clk(clk), .rst(rst));

assign id_memwrite = (pc_new_out[15:0] == 4'b1001);


endmodule
