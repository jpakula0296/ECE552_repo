module EX_data(
    input clk,
    input stall_n,
    input flush,

    input [3:0] id_rs_reg,
    output [3:0] ex_rs_reg,

    input [3:0] id_rt_reg,
    output [3:0] ex_rt_reg,

    input  [15:0]   id_rs_data,
    output [15:0]   ex_rs_data,

    input  [15:0]   id_rt_data,
    output [15:0]   ex_rt_data,

    input  [15:0]   id_imm,
    output [15:0]   ex_imm,

    input  [3:0]    id_opcode,
    output [3:0]    ex_opcode,

    input           id_load_half_instr,
    input [15:0]    id_load_half_data,
    output [15:0]   ex_load_half_data,
    output          ex_load_half_instr,

    input           id_imm_instr,
    output          ex_imm_instr
);
dff_16bit rs_data_ff(.clk(clk), .wen(stall_n), .rst(flush), .q(ex_rs_data), .d(id_rs_data));
dff_16bit rt_data_ff(.clk(clk), .wen(stall_n), .rst(flush), .q(ex_rt_data), .d(id_rt_data));
dff_16bit imm_ff    (.clk(clk), .wen(stall_n), .rst(flush), .q(ex_imm),     .d(id_imm));
dff_16bit load_half_data_dff(.clk(clk), .wen(stall_n), .rst(flush), .d(id_load_half_data),
.q(ex_load_half_data));

dff_4bit  opcode_ff (.clk(clk), .wen(stall_n), .rst(flush), .q(ex_opcode),  .d(id_opcode));
dff load_half_instr_ff(
    .clk(clk),
    .wen(stall_n),
    .rst(flush),
    .q(ex_load_half_instr),
    .d(id_load_half_instr)
);
dff imm_instr_ff(
    .clk(clk),
    .wen(stall_n),
    .rst(flush),
    .q(ex_imm_instr),
    .d(id_imm_instr)
);

dff_4bit rs_reg_ff (.clk(clk), .wen(stall_n), .rst(flush), .q(ex_rs_reg), .d(id_rs_reg));
dff_4bit rt_reg_ff (.clk(clk), .wen(stall_n), .rst(flush), .q(ex_rt_reg), .d(id_rt_reg));
endmodule
