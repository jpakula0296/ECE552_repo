module EX_data(
    input clk;
    input stall_n;
    input flush;

    input  [15:0]   id_rs_data;
    output [15:0]   ex_rs_data;

    input  [15:0]   id_rt_data;
    output [15:0]   ex_rt_data;

    input  [15:0]   id_imm;
    output [15:0]   ex_imm;

    input  [3:0]    id_opcode;
    output [3:0]    ex_opcode;

    input           id_load_half_instr;
    output          ex_load_half_instr;

    input           id_imm_instr;
    output          ex_imm_instr;
);
    dff_16bit rs_data_ff(.clk(clk), .wen(stall_n), .rst(flush), .q(id_rs_data), .d(ex_rs_data));
    dff_16bit rt_data_ff(.clk(clk), .wen(stall_n), .rst(flush), .q(id_rt_data), .d(ex_rt_data));
    dff_16bit imm_ff    (.clk(clk), .wen(stall_n), .rst(flush), .q(id_imm),     .d(ex_imm));
    dff_4bit  opcode_ff (.clk(clk), .wen(stall_n), .rst(flush), .q(id_opcode),  .d(ex_opcode));
    dff load_half_instr_ff(
        .clk(clk),
        .wen(stall_n),
        .rst(flush),
        .q(id_load_half_instr),
        .d(ex_load_half_instr)
    );
    dff imm_instr_ff(
        .clk(clk),
        .wen(stall_n),
        .rst(flush),
        .q(id_imm_instr),
        .d(ex_imm_instr)
    );
endmodule
