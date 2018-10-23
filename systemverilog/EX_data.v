module EX_data(
    input [15:0]    id_rs_data;
    input [15:0]    id_rt_data;
    input [15:0]    id_imm;
    input [3:0]     id_opcode;
    input           id_load_half_instr;
    input           id_imm_instr;

    output [15:0]   ex_rs_data;
    output [15:0]   ex_rt_data;
    output [15:0]   ex_imm;
    output [3:0]    ex_opcode;
    output          ex_load_half_instr;
    output          ex_imm_instr;
);
endmodule
